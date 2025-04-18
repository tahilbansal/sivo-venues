import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? doc_id;
  String? token;
  String? name;
  String? avatar;
  String? last_msg;
  Timestamp? last_time;
  int? msg_num;
  int? online;
  String? supplier_uid;

  Message({
    this.doc_id,
    this.token,
    this.name,
    this.avatar,
    this.last_msg,
    this.last_time,
    this.msg_num,
    this.online,
    this.supplier_uid,
  });
}

class CallMessage {
  String? doc_id;
  String? token;
  String? name;
  String? avatar;
  String? call_time;
  String? type;
  Timestamp? last_time;
  String? supplier_uid;

  CallMessage({
    this.doc_id,
    this.token,
    this.name,
    this.avatar,
    this.call_time,
    this.type,
    this.last_time,
    this.supplier_uid,
  });
}
