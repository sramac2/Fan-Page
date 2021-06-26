import 'package:fan_page/API/AuthAPI.dart';
import 'package:fan_page/Models/Message.dart';
import 'package:fan_page/Models/User.dart' as models;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fan_page/API/MessageAPI.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Message>> messages;
  MessageAPI messageAPI = MessageAPI();
  Future<models.User> user;
  AuthAPI authAPI = AuthAPI();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                authAPI.logout();
                Navigator.pop(context);
              },
            )
          ],
        ),
        floatingActionButton: FutureBuilder<models.User>(
            future: user,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data.role == 'admin') {
                return FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    showAlertDialog('message');
                  },
                );
              }
              return Visibility(
                  visible: false,
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {},
                  ));
            }),
        body: FutureBuilder<List<Message>>(
            future: messages,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      child: ListTile(
                        title: Text('${snapshot.data[index].content}'),
                        subtitle: Text('${snapshot.data[index].datetime}'),
                      ),
                    );
                  },
                );
              }
              return CircularProgressIndicator(
                semanticsLabel: 'Loading...',
              );
            }),
      ),
    );
  }

  @override
  void initState() {
    var cUser = FirebaseAuth.instance.currentUser;
    messages = messageAPI.getAllMessages();
    user = authAPI.findUserbyId(cUser!=null ? cUser.uid:'4a37afa0-ff31-4390-a3b4-91ae03d70d17' );
    super.initState();
  }

  Uuid uuid = Uuid();
  showAlertDialog(String message) {
    TextEditingController tx = TextEditingController();
    Widget okButton = TextButton(
      child: Text("POST MESSAGE"),
      onPressed: () async {
        await messageAPI.createMessage(Message(
            content: tx.text.trim(),
            datetime: DateTime.now().toString(),
            uid: uuid.v4()));
        Navigator.pop(context);
        messages = messageAPI.getAllMessages();
        setState(() {});
      },
    );

    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          Container(
              width: 250,
              margin: EdgeInsets.only(left: 5),
              child: TextField(
                controller: tx,
              )),
        ],
      ),
      actions: [okButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
