import 'package:flash_chat_app2/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import '../components/Rounded_Buttons.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegistrationScreen extends StatefulWidget {
  static const id = 'registration_screen';

  const RegistrationScreen({super.key});
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
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
                email = value;
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
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password'),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              text: 'Register',
              colors: Colors.blue,
              onPressed: () async{
                try{
                  final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                    Navigator.pushNamed(context, ChatScreen.id);
                                  }
                catch(e){
                  print(e);
                }

              },
            ),
          ],
        ),
      ),
    );
  }
}
