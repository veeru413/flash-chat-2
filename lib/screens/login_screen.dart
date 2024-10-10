import 'package:flash_chat_app2/constants.dart';
import 'package:flash_chat_app2/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import '../components/Rounded_Buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  final textController = TextEditingController();
  final textController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: textController,
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
                controller: textController1,
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
                text: 'Log In',
                colors: Colors.lightBlueAccent,
                onPressed: () async{
                  setState(() {
                    showSpinner = true;
                  });
                  textController.clear();
                  textController1.clear();
                  final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                  try{
                    if(user!=null)
                      {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }

                  }
                  catch(e){
                    print(e);
                  }

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
