import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_barrel.dart';
import 'package:water_tracker/bloc/date_picker_bloc/date_picker_bloc_barrel.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_bloc_barrel.dart';
import 'package:water_tracker/bloc/dynamic_link_bloc/dynamic_link_barrel.dart';
import 'package:water_tracker/bloc/home_cubit/home_cubit.dart';
import 'package:water_tracker/repository/firestore_repository.dart';
import 'package:water_tracker/routes.dart';
import 'package:water_tracker/services/firebase/cloud_messaging_service.dart';
import 'package:water_tracker/services/firebase/crashlytics_service.dart';
import 'package:water_tracker/services/firebase/remote_config_service.dart';
import 'package:water_tracker/widgets/add_water_button.dart';
import 'package:water_tracker/widgets/drinks_list.dart';
import 'package:water_tracker/widgets/drinks_overall.dart';

class HomeScreenWrapper extends StatelessWidget {
  const HomeScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
        BlocProvider<DatePickerBloc>(
          create: (context) =>
              DatePickerBloc()..add(DatePickerSelectDate(DateTime.now())),
        ),
        BlocProvider<DrinksBloc>(
          create: (context) => DrinksBloc(
            repository: context.read<FirestoreRepositoryImpl>(),
            crashlyticsService: context.read<CrashlyticsService>(),
            remoteConfigService: context.read<RemoteConfigService>(),
          )
            ..add(LoadDailyLimit())
            ..add(FetchIndicatorType()),
        ),
      ],
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<DynamicLinkBloc>().add(RequestSubscription());
    context.read<CloudMessagingService>().subscribeTopic('reminders');
    context
        .read<CloudMessagingService>()
        .fcmInstance
        .getInitialMessage()
        .then((message) {
      if (message != null) {
        Navigator.pushNamed(context, profileScreenRoute);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.signedOut) {
            Navigator.pushNamedAndRemoveUntil(
                context, loginScreenRoute, (route) => false);
          }
        },
        child: BlocBuilder<DynamicLinkBloc, DynamicLinkState>(
            builder: (context, state) {
          if (state.linkParameter != null) {
            SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('I drunk ${state.linkParameter} milliliters')));
              context.read<DynamicLinkBloc>().add(DropLink());
            });
          }
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _dateSelect(),
                Expanded(flex: 4, child: _body()),
                _bottomBar(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _dateSelect() {
    final theme = Theme.of(context);
    return BlocBuilder<DatePickerBloc, DatePickerState>(
        builder: (context, state) {
      return Container(
        height: 50,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 5),
              child: _buttonWrapping(
                  icon: Icon(Icons.arrow_drop_down, color: theme.primaryColor),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: state.date ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((date) {
                      context
                          .read<DatePickerBloc>()
                          .add(DatePickerSelectDate(date!));
                    });
                  }),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.dayOfWeek, style: Theme.of(context).textTheme.bodyText1,),
                    Text(state.dateInfo, style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: _buttonWrapping(icon: Icon(Icons.arrow_left, color: theme.primaryColor), onTap: () {}),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: VerticalDivider(color: theme.primaryColor,),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 5),
                  child: _buttonWrapping(icon: Icon(Icons.arrow_right, color: theme.primaryColor), onTap: () {}),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _body() {
    return BlocListener<DatePickerBloc, DatePickerState>(
        listenWhen: (previousState, state) {
          if (previousState.date != state.date) {
            return true;
          } else {
            return false;
          }
        },
        listener: (context, state) {
          context
              .read<DrinksBloc>()
              .add(DrinksOverviewSubscriptionRequested(state.date!));
        },
        child: Container(
          margin: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, homeState) {
              return homeState.tab == HomeTab.drinks
                  ? const DrinksList()
                  : const DrinksOverall();
            },
          ),
        ));
  }

  Widget _bottomBar() {
    final drinksProvider = context.read<DrinksBloc>();
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buttonWrapping(
                      icon: const Icon(Icons.stacked_bar_chart), onTap: () {}),
                  const SizedBox(),
                  _buttonWrapping(
                      icon: const Icon(Icons.account_circle_outlined,),
                      onTap: () {
                        final oldDailyLimit =
                            drinksProvider.state.dailyWaterLimit;
                        Navigator.pushNamed(context, profileScreenRoute,
                                arguments: drinksProvider.state.drunkWater)
                            .then((dailyLimit) {
                          if (dailyLimit == null ||
                              dailyLimit == oldDailyLimit) {
                            return;
                          } else {
                            drinksProvider.add(LoadDailyLimit());
                          }
                        });
                      }),
                ],
              ),
            ),
            const AddWaterButton(),
          ],
        ),
      );
    });
  }

  Widget _buttonWrapping({required Icon icon, required void Function() onTap}) {
    return Material(
      child: InkWell(
        highlightColor: Colors.blueAccent.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: icon,
        ),
      ),
    );
  }
}
