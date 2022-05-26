import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/user_profile_bloc/user_profile_barrel.dart';
import 'package:water_tracker/repository/firestore_repository.dart';
import 'package:water_tracker/repository/storage_repository.dart';

class ProfileScreenWrapper extends StatelessWidget {
  const ProfileScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(
          context.read<FirestoreRepositoryImpl>(), context.read<StorageRepositoryImpl>())
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black45),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.black45,
            onPressed: () {
              userProvider.add(CheckEdit(true));
            },
            splashRadius: 15,
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_left_rounded),
          color: Colors.black45,
          onPressed: () {
            Navigator.pop(context);
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
      }, builder: (context, state) {
        if (state.status == UserProfileStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            margin: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _userPhoto(context, state),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          controller: _nameController,
                          style: TextStyle(
                              color: state.isEdit
                                  ? const Color(0xff274a6d)
                                  : Colors.black38),
                          enabled: state.isEdit,
                          decoration: _formDecoration('Name'),
                        ),
                      ),
                      TextFormField(
                        controller: _dailyLimitController,
                        style: TextStyle(
                            color: state.isEdit
                                ? const Color(0xff274a6d)
                                : Colors.black38),
                        enabled: state.isEdit,
                        decoration: _formDecoration('Daily Water Limit'),
                      ),
                      Visibility(
                          visible: state.isEdit,
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  userProvider.add(SaveChanges(
                                      _nameController.text,
                                      _dailyLimitController.text));
                                },
                                child: const Text('Apply'),
                              ),
                              TextButton(
                                onPressed: () {
                                  userProvider.add(CheckEdit(false));
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  InputDecoration _formDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12, width: 1)),
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
            child: CircleAvatar(
              backgroundImage: NetworkImage(state.photoUrl),
            ),
          ),
          Visibility(
            visible: state.isEdit,
            child: SizedBox(
              width: 140,
              child: TextButton(
                onPressed: () {
                  context.read<UserProfileBloc>().add(PickPhotoFromGallery());
                },
                child: const Text('Set new photo'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
