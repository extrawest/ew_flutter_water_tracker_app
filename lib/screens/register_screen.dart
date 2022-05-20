import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_barrel.dart';
import '../routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (BuildContext context, state) {
          if(state.status == AuthStatus.signedIn){
            Navigator.pushReplacementNamed(context, homeScreenRoute);
          }
        },
        child: Center(
          child: Column(
            children: [
              const Expanded(
                  flex: 3,
                  child: Align(
                      alignment: Alignment.center, child: Text('Register'))),
              Expanded(flex: 5, child: _form()),
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
          Padding(
            padding:
                const EdgeInsets.only(bottom: 8.0, left: 20.0, right: 20.0),
            child: TextFormField(
              controller: emailController,
              style: const TextStyle(color: Color(0xff274a6d)),
              decoration: _input(
                emailController,
                const Icon(Icons.account_circle_rounded),
                'Enter your email',
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 8.0, left: 20.0, right: 20.0),
            child: TextFormField(
              controller: passwordController,
              style: const TextStyle(color: Color(0xff274a6d)),
              obscureText: true,
              decoration: _input(
                passwordController,
                const Icon(Icons.security),
                'Enter your password',
              ),
              validator: _validatePassword,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 8.0, left: 20.0, right: 20.0),
            child: TextFormField(
              controller: confirmPasswordController,
              style: const TextStyle(color: Color(0xff274a6d)),
              obscureText: true,
              decoration: _input(
                confirmPasswordController,
                const Icon(Icons.security),
                'Re-enter your password',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            child: TextButton(
                onPressed: () {
                  _submitForm();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  primary: Colors.white,
                  backgroundColor:
                      const Color.fromRGBO(67, 91, 206, 0.9019607843137255),
                ),
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

  InputDecoration _input(
      TextEditingController controller, Icon icon, String hint) {
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
        email: emailController.text, password: passwordController.text));
  }

  String? _validatePassword(String? value) {
    if (passwordController.text.length < 6 ||
        passwordController.text.length > 15) {
      return 'Password must contain from 6 to 15 characters';
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
