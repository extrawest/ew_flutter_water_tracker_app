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
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('I drunk ${state.linkParameter} milliliters')));
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
    return BlocBuilder<DatePickerBloc, DatePickerState>(
        builder: (context, state) {
      return Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              onPressed: () {
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
              },
            ),
            Column(
              children: [
                Text(state.dayOfWeek),
                Text(state.dateInfo),
              ],
            ),
            Row(children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () {},
              ),
              const VerticalDivider(),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () {},
              ),
            ]),
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.stacked_bar_chart),
                    onPressed: () {
                      throw Exception();
                    },
                  ),
                  const SizedBox(),
                  IconButton(
                    icon: const Icon(Icons.account_circle_outlined),
                    onPressed: () {
                      final oldDailyLimit =
                          drinksProvider.state.dailyWaterLimit;
                      Navigator.pushNamed(context, profileScreenRoute,
                              arguments: drinksProvider.state.drunkWater)
                          .then((dailyLimit) {
                        if (dailyLimit == null || dailyLimit == oldDailyLimit) {
                          return;
                        } else {
                          drinksProvider.add(LoadDailyLimit());
                        }
                      });
                      // MaterialPageRoute(
                      //     builder: (_) => BlocProvider<DrinksBloc>.value(
                      //           value: context.read<DrinksBloc>(),
                      //           child: const ProfileScreenWrapper(),
                      //         )));
                    },
                  ),
                ],
              ),
            ),
            const AddWaterButton(),
          ],
        ),
      );
    });
  }
}
