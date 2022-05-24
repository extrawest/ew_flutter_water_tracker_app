import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/user_profile_bloc/user_profile_barrel.dart';
import 'package:water_tracker/repository/firestore_repository.dart';

class ProfileScreenWrapper extends StatelessWidget {
  const ProfileScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserProfileBloc(context.read<FirestoreRepositoryImpl>())..add(LoadUserProfile()),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          if(state.status == UserProfileStatus.loading || state.status == UserProfileStatus.initial) {
            return const Center(child: CircularProgressIndicator(),);
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.user!.name),
                Text(state.user!.email),
              ],
            );
          }

        }
      ),
    );
  }
}
