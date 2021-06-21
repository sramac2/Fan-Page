import 'dart:async';

import 'package:fan_page/API/AuthAPI.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginDemo extends StatelessWidget {
  const LoginDemo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
        ),
        body: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthAPI api = AuthAPI();
  TextEditingController emailController;
  TextEditingController pwdController;
  StreamController<String> emailStreamController;
  StreamController<String> pwdStreamController;
  SnackBar snackBar;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    emailController = TextEditingController();
    pwdController = TextEditingController();
    emailStreamController = StreamController<String>.broadcast();
    pwdStreamController = StreamController<String>.broadcast();

    BuildContext currentCtx;
    snackBar = SnackBar(content: Text('Test'));

    emailController.addListener(() {
      emailStreamController.sink.add(emailController.text.trim());
    });
    pwdController.addListener(() {
      pwdStreamController.sink.add(pwdController.text.trim());
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error Initializing Firebase'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Column(
              children: [
                Text(
                  'Login Page',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    snackBar = SnackBar(content: Text("Sample Test"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black,
                )
              ],
            )),
          );
        });
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String pwd = pwdController.text.trim();
    if (email.isEmpty || pwd.isEmpty) {
      snackBar = SnackBar(content: Text('All fields need to be filled!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    String response = await api.LoginUserEmailPass(email, pwd);
    if (response != null) {
      snackBar = SnackBar(content: Text(response));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    //TODO: naviagte to mesages page
  }
}
