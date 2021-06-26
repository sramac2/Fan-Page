class Message {
  String datetime;
  String uid;
  String content;

  Message({this.datetime, this.uid, this.content});

  Message.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    uid = json['uid'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datetime'] = this.datetime;
    data['uid'] = this.uid;
    data['content'] = this.content;
    return data;
  }
}