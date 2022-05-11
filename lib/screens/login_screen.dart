import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:water_tracker/routes.dart';

import '../services/firebase/firebase_authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _authService = AuthService();

  final invalidAuthSnackBar = const SnackBar(
    content: Text('Invalid email or password'),
    duration: Duration(seconds: 5),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Expanded(
                flex: 3,
                child:
                    Align(alignment: Alignment.center, child: Text('Sign In'))),
            Expanded(flex: 4, child: _form()),
            Text('Or Sign In with:'),
            Expanded(flex: 2,child: Align(alignment: Alignment.topCenter,child: _otherAuth())),
          ],
        ),
      ),
    );
  }

  Widget _form() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _input(const Icon(Icons.account_circle_rounded),
              'Enter your email', emailController, false),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _input(const Icon(Icons.security), 'Enter your password',
              passwordController, true),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child: TextButton(
              onPressed: () async {
                await _loginUser();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(20),
                primary: Colors.white,
                backgroundColor:
                    const Color.fromRGBO(67, 91, 206, 0.9019607843137255),
              ),
              child: const Text('Login')),
        ),
        TextButton(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Haven't an account yet? Register",
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, registerScreenRoute);
          },
        )
      ],
    );
  }

  Widget _input(
      Icon icon, String hint, TextEditingController controller, bool obscure) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Color(0xff274a6d)),
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 20.0, color: Colors.black12),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff5aaed4), width: 2)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12, width: 1)),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: IconTheme(
                  data: const IconThemeData(color: Color(0xff274a6d)),
                  child: icon),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.clear,
                ),
                onPressed: () {
                  controller.text = '';
                },
                splashRadius: 20,
              ),
            )),
      ),
    );
  }

  Widget _otherAuth() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () async {
              await _loginWithGoogle();
            },
            icon: Image.asset('assets/images/google.png'),
        ),
        IconButton(
          onPressed: () async {
            await _loginWithFacebook();
          },
          icon: Image.asset('assets/images/facebook.png'),
        ),
      ],
    );
  }

  Future<void> _loginUser() async {
    User? user = await _authService.signInWithEmailAndPassword(
        emailController.text, passwordController.text);
    if (user != null) {
      Navigator.pushReplacementNamed(context, homeScreenRoute);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(invalidAuthSnackBar);
    }
  }

  Future<void> _loginWithGoogle() async {
    await _authService.signInWithGoogle();
    if(_authService.firebaseAuth.currentUser != null) {
      Navigator.pushReplacementNamed(context, homeScreenRoute);
    }
  }

  Future<void> _loginWithFacebook() async {
    await _authService.signInWithFacebook();
    if(_authService.firebaseAuth.currentUser != null) {
      Navigator.pushReplacementNamed(context, homeScreenRoute);
    }
  }
}
