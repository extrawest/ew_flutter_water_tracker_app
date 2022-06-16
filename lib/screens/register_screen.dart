import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_barrel.dart';
import 'package:water_tracker/theme/decorations.dart';
import '../routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (BuildContext context, state) {
          if (state.status == AuthStatus.signedIn) {
            Navigator.pushReplacementNamed(context, homeScreenRoute);
          }
        },
        child: Center(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Align(
                            alignment: Alignment.center, child: Text('Register'))),
                    Expanded(flex: 5, child: _form()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _formField(
              controller: emailController,
              obscure: false,
              hint: 'Enter your Email',
              icon: const Icon(Icons.account_circle_rounded)),
          _formField(
              controller: nameController,
              obscure: false,
              maxLength: 20,
              hint: 'Enter your Name',
              icon: const Icon(Icons.account_circle_rounded)),
          _formField(
              controller: passwordController,
              obscure: true,
              maxLength: 15,
              hint: 'Enter your Password',
              icon: const Icon(Icons.security),
              validator: _validatePassword),
          _formField(
            controller: confirmPasswordController,
            obscure: true,
            maxLength: 15,
            hint: 'Re-enter your Password',
            icon: const Icon(Icons.security),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            child: TextButton(
                onPressed: () {
                  _submitForm();
                },
                style: textButtonStyle[0],
                child: const Text('Register')),
          ),
          TextButton(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Have an account already? Sign In',
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget _formField(
      {required TextEditingController controller,
      required bool obscure,
      int? maxLength,
      required String hint,
      required Icon icon,
      String? Function(String?)? validator}) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 8.0, left: 20.0, right: 20.0),
      child: TextFormField(
        maxLength: maxLength,
        controller: controller,
        style: const TextStyle(color: Color(0xff274a6d)),
        obscureText: obscure,
        decoration: _input(
          controller: controller,
          icon: icon,
          hint: hint,
        ),
        validator: validator,
      ),
    );
  }

  InputDecoration _input(
      {required TextEditingController controller,
      required Icon icon,
      required String hint}) {
    return InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 20.0, color: Colors.black12),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff5aaed4), width: 2)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12, width: 1)),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: IconTheme(
              data: const IconThemeData(color: Color(0xff274a6d)), child: icon),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: const Icon(
              Icons.clear,
              //color: Colors.white,
            ),
            onPressed: () {
              controller.text = '';
            },
            splashRadius: 20,
          ),
        ));
  }

  void _registerUser() {
    context.read<AuthBloc>().add(AuthRegister(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text));
  }

  String? _validatePassword(String? value) {
    if (passwordController.text.length < 6) {
      return 'Password must contain at least 6 characters';
    } else if (passwordController.text != confirmPasswordController.text) {
      return "Passwords doesn't match each other";
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _registerUser();
    }
  }
}
