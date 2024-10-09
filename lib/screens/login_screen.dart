import 'package:flash_chat_app2/constants.dart';
import 'package:flutter/material.dart';
import '../components/Rounded_Buttons.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: SizedBox(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                // Do something with the user input.
              },
              decoration:kTextFieldDecoration.copyWith(hintText: 'Enter your Email'),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                // Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password'),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              text: 'Log In',
              colors: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
