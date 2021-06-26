import 'package:fan_page/API/AuthAPI.dart';
import 'package:fan_page/Models/User.dart' as models;
import 'package:fan_page/UI/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RegistrationDemo extends StatelessWidget {
  const RegistrationDemo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Registration Page'),
        ),
        body: RegistrationPage(),
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  SnackBar snackBar;
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  Uuid uuid = Uuid();
  AuthAPI authAPI = AuthAPI();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: TextFormField(
            controller: fNameController,
            decoration: InputDecoration(
              labelText: "First Name",
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: TextFormField(
            controller: lNameController,
            decoration: InputDecoration(
              labelText: "Last Name",
            ),
          ),
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
            controller: pwdController,
            decoration: InputDecoration(
              labelText: "Password",
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            register();
          },
          child: Text(
            "Register",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.black,
        ),
        MaterialButton(
          onPressed: () async {
            String res = await authAPI.googleSignIn();

            if (res != null) {
              snackBar = SnackBar(content: Text(res));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              var curUser = FirebaseAuth.instance.currentUser;
              models.User u = models.User(
                  uid: curUser == null
                      ? '4a37afa0-ff31-4390-a3b4-91ae03d70d17'
                      : curUser.uid,
                  firstName: curUser == null ? 'Tester' : curUser.displayName,
                  lastName:
                      curUser == null ? 'Tester Last' : curUser.displayName,
                  role: 'customer',
                  datetime: DateTime.now().toString());
              String dbRes = await authAPI.createUser(u);
              if (dbRes != null) {
                snackBar = SnackBar(content: Text(res));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              }
            }
          },
          child: Text("Google Sign In"),
        ),
      ],
    );
  }

  Future<void> register() async {
    String email = emailController.text.trim();
    String pwd = pwdController.text.trim();
    String fName = fNameController.text.trim();
    String lName = lNameController.text.trim();
    if (email.isEmpty || pwd.isEmpty || fName.isEmpty || lName.isEmpty) {
      snackBar = SnackBar(content: Text('All fields need to be filled!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    String authRes = await authAPI.registerEmailPass(email, pwd);
    if (authRes != null) {
      snackBar = SnackBar(content: Text(authRes));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    models.User user = models.User(
        firstName: fName,
        lastName: lName,
        datetime: DateTime.now().toString(),
        role: 'customer',
        uid: FirebaseAuth.instance.currentUser.uid);
    print(user.toJson());
    String dbRes = await authAPI.createUser(user);
    if (dbRes != null) {
      snackBar = SnackBar(content: Text(dbRes));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
