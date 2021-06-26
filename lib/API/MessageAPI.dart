import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page/Models/Message.dart';

class MessageAPI {
  Future<List<Message>> getAllMessages() async {
    List<Message> result = [];
    var collection = FirebaseFirestore.instance.collection('messages');
    var querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      result.add(
        Message.fromJson(
          doc.data(),
        ),
      );
    }
    return result;
  }

  Future<String> createMessage(Message msg) async {
    CollectionReference users = FirebaseFirestore.instance.collection('messages');
    return await users
        .add(msg.toJson())
        .then((value) => null)
        .catchError((error) => error.toString());
  }

  
}
