import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sivo_venues/common/entities/entities.dart';
import 'package:sivo_venues/common/entities/message.dart';
import 'package:sivo_venues/common/utils/firebase_messaging_handler.dart';
import 'package:sivo_venues/common/utils/http.dart';
import 'package:sivo_venues/models/environment.dart';
import 'package:sivo_venues/views/message/state.dart';

class MessageController extends GetxController {
  MessageController();

  final box = GetStorage();
  String? token; //= box.read('userId');
  final db = FirebaseFirestore.instance;
  final MessageState state = MessageState();
  var listener;
  // Add this variable to hold the search query
  var searchQuery = ''.obs;

  final RefreshController refreshController = RefreshController(initialRefresh: true);

  @override
  void onInit() {
    token = box.read('userId');
    if (token != null) {
      token = jsonDecode(token!);
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getUserLocation();
    _snapshots();
  }

  asyncLoadMsgData() async {

    var from_messages = await db.collection("message")
    .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    ).where("from_uid", isEqualTo: token).get();

    var to_messages = await db.collection("message")
    .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    )
    .where("to_uid", isEqualTo: token).get();

    state.msgList.clear();

    if (from_messages.docs.isNotEmpty) {
      await addMessage(from_messages.docs);
    }
    if (to_messages.docs.isNotEmpty) {
      await addMessage(to_messages.docs);
    }
    // sort
    state.msgList.value.sort((a, b) {
      if (b.last_time == null) {
        return 0;
      }
      if (a.last_time == null) {
        return 0;
      }
      return b.last_time!.compareTo(a.last_time!);
    });

    // Initially set filtered list to msgList
    state.filteredMsgList.assignAll(state.msgList);
  }

  addMessage(List<QueryDocumentSnapshot<Msg>> data) async {
    data.forEach((element) {
      var item = element.data();
      Message message = new Message();
      message.doc_id = element.id;
      message.last_time = item.last_time;
      message.msg_num = item.msg_num;
      message.last_msg = item.last_msg;
      if (item.from_uid == token) {
        message.name = item.to_name;
        message.supplier_uid = item.supplier_uid;
        message.avatar = item.to_avatar;
        message.token = item.to_uid;
        //message.online = item.to_online;
        message.msg_num = item.to_msg_num ?? 0;
      } else {
        message.name = item.from_name;
        message.avatar = item.from_avatar;
        message.token = item.from_uid;
        //message.online = item.from_online;
        message.msg_num = item.from_msg_num ?? 0;
      }
      state.msgList.add(message);
    });
  }

  _snapshots() async {
    final toMessageRef = db.collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        ).where("to_uid", isEqualTo: token);
    final fromMessageRef = db.collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("from_uid", isEqualTo: token);

    toMessageRef.snapshots().listen(
      (event) async {
        await asyncLoadMsgData();
      },
      onError: (error) => print("Listen failed: $error"),
    );
    fromMessageRef.snapshots().listen(
      (event) async {
        await asyncLoadMsgData();
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  getUserLocation() async {
    try {
      final location = await Location().getLocation();
      String address = "${location.latitude}, ${location.longitude}";

      String url = "https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=${Environment.googleApiKey}";

      var response = await HttpUtil().get(url);
      MyLocation location_res = MyLocation.fromJson(response);
      if (location_res.status == "OK") {
        String? myaddresss = location_res.results?.first.formattedAddress;
        if (myaddresss != null) {
          var user_location =
              await db.collection("users").where("id", isEqualTo: token).get();
          if (user_location.docs.isNotEmpty) {
            var doc_id = user_location.docs.first.id;
            await db
                .collection("users")
                .doc(doc_id)
                .update({"location": myaddresss});
          }
        }
      } else {
        print("Did not get the location");
      }
    } catch (e) {
      print("Getting error $e");
    }
  }

  getFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      var user =
          await db.collection("users").where("id", isEqualTo: token).get();
      if (user.docs.isNotEmpty) {
        var doc_id = user.docs.first.id;
        await db.collection("users").doc(doc_id).update({"fcmtoken": fcmToken});
      } else {
        print("----------docs are empty-------");
      }
    }
    await FirebaseMessaging.instance.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      HelperNotification.showNotification(message.notification!.title!, message.notification!.body!);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data != null) {
        var to_uid = message.data["to_uid"];
        var to_name = message.data["to_name"];
        var to_avatar = message.data["to_avatar"];
        var doc_id = message.data['doc_id'];
        var supplier_uid = message.data['supplier_uid'];
        Get.toNamed("/chat", parameters: {
          "doc_id": doc_id,
          "to_uid": to_uid,
          "to_name": to_name,
          "to_avatar": to_avatar,
          "supplier_uid": supplier_uid,
        });
      }
    });
  }
  void reset() {
    state.msgList.clear();
    listener?.cancel();
  }

  void searchMessages(String query) {
    searchQuery.value = query.trim();

    if (query.isEmpty) {
      state.filteredMsgList.assignAll(state.msgList);
    } else {
      state.filteredMsgList.value = state.msgList.where((message) {
        return message.name?.toLowerCase().contains(query.toLowerCase()) ??
            false ||
                message.last_msg!.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
    }
  }
}
