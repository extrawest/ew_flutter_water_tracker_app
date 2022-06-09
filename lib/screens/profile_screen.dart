import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_barrel.dart';
import 'package:water_tracker/bloc/dynamic_link_bloc/dynamic_link_barrel.dart';
import 'package:water_tracker/bloc/user_profile_bloc/user_profile_barrel.dart';
import 'package:water_tracker/common/app_constants.dart';
import 'package:water_tracker/repository/firestore_repository.dart';
import 'package:water_tracker/repository/storage_repository.dart';
import 'package:water_tracker/services/firebase/crashlytics_service.dart';
import 'package:water_tracker/theme/decorations.dart';

class ProfileScreenWrapper extends StatelessWidget {
  const ProfileScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(
          firestoreRepository: context.read<FirestoreRepositoryImpl>(),
          storageRepository: context.read<StorageRepositoryImpl>(),
          crashlyticsService: context.read<CrashlyticsService>())
        ..add(LoadUserProfile())
        ..add(LoadUserPhoto()),
      child: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _dailyLimitController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProfileBloc>();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: theme.textTheme.bodyText1,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: theme.primaryColor,),
            color: Colors.black45,
            onPressed: () {
              userProvider.add(CheckEdit(true));
            },
            splashRadius: 15,
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_left_rounded, color: theme.primaryColor),
          onPressed: () {
            Navigator.pop(context,
                context.read<UserProfileBloc>().state.user?.dailyWaterLimit);
          },
          splashRadius: 15,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
          listenWhen: (previousState, currentState) {
        if (currentState != previousState) {
          return true;
        } else {
          return false;
        }
      }, listener: (context, state) {
        if (state.status == UserProfileStatus.success) {
          _nameController.text = state.user!.name;
          _dailyLimitController.text = '${state.user!.dailyWaterLimit}';
        }
      }, buildWhen: (previousState, currentState) {
        if (currentState.status == UserProfileStatus.updatedDailyLimit) {
          return false;
        } else {
          return true;
        }
      }, builder: (context, state) {
        if (state.status == UserProfileStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            margin: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _userPhoto(context, state),
                  _form(context, state),
                  _logOutButton(context, state),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  InputDecoration _formDecoration(String label) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelStyle: theme.inputDecorationTheme.labelStyle,
      labelText: label,
      border: theme.inputDecorationTheme.border,
      focusedBorder: theme.inputDecorationTheme.focusedBorder,
      enabledBorder: theme.inputDecorationTheme.enabledBorder
    );
  }

  Widget _userPhoto(BuildContext context, UserProfileState state) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: state.photoUrl != ''
                ? CircleAvatar(
                    backgroundImage: NetworkImage(state.photoUrl),
                  )
                : CircleAvatar(
                    child: Image.asset(ImagesPath.ACCOUNT_IMAGE),
                  ),
          ),
          Visibility(
            visible: state.isEdit,
            child: SizedBox(
              width: 140,
              child: TextButton(
                style: textButtonStyle[1],
                onPressed: () {
                  context.read<UserProfileBloc>().add(PickPhotoFromGallery());
                },
                child: Text('Set new photo', style: Theme.of(context).textTheme.button),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _form(BuildContext context, UserProfileState state) {
    final theme = Theme.of(context);
    final sumOfMilliliters = ModalRoute.of(context)!.settings.arguments as int;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              controller: _nameController,
              style: state.isEdit ? theme.textTheme.bodyText2 : theme.textTheme.subtitle2,
              enabled: state.isEdit,
              decoration: _formDecoration('Name'),
            ),
          ),
          TextFormField(
            controller: _dailyLimitController,
            style: state.isEdit ? theme.textTheme.bodyText2 : theme.textTheme.subtitle2,
            enabled: state.isEdit,
            decoration: _formDecoration('Daily Water Limit'),
          ),
          Visibility(
            visible: !state.isEdit,
            child: TextButton(
              style: textButtonStyle[1],
              onPressed: () {
                context.read<DynamicLinkBloc>().add(ShareDynamicLink(sumOfMilliliters));
              },
              child: Text('Share my result', style: Theme.of(context).textTheme.button),
            ),
          ),
          Visibility(
              visible: state.isEdit,
              child: Row(
                children: [
                  TextButton(
                    style: textButtonStyle[1],
                    onPressed: () {
                      context.read<UserProfileBloc>().add(SaveChanges(
                          _nameController.text, _dailyLimitController.text));
                    },
                    child: Text('Save changes', style: Theme.of(context).textTheme.button),
                  ),
                  TextButton(
                    style: textButtonStyle[1],
                    onPressed: () {
                      context.read<UserProfileBloc>().add(CheckEdit(false));
                    },
                    child: Text('Cancel', style: Theme.of(context).textTheme.button),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _logOutButton(BuildContext context, UserProfileState state) {
    return Visibility(
      visible: state.isEdit,
      child: Container(
        margin: const EdgeInsets.only(top: 60),
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: Size(MediaQuery.of(context).size.width, 30),
            ),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogOut());
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            )),
      ),
    );
  }
}
