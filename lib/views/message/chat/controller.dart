import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sivo_venues/common/utils/security.dart';
import 'package:sivo_venues/controllers/login_controller.dart';
import 'package:sivo_venues/models/environment.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sivo_venues/common/entities/entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/models/suppliers.dart';
import 'index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  var supplier = Rxn<Suppliers>();
  ChatController();
  ChatState state = ChatState();
  var doc_id;
  final textController = TextEditingController();
  ScrollController msgScrolling = ScrollController();
  FocusNode contentNode = FocusNode();
  final box = GetStorage();

  String? user_id; // UserStore.to.token;
  var user_profile = Get.find<LoginController>().loginResponse;
  final db = FirebaseFirestore.instance;
  var listener;
  var to_uid;
  var from_uid;
  var from_name;
  var to_name;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  // Method to fetch supplier details and update the state
  Future<void> fetchSupplierDetails(String supplierId) async {
    try {
      // Call an API or database to fetch the supplier details
      final response = await http.get(
          Uri.parse('${Environment.appBaseUrl}/api/supplier/byId/$supplierId'));
      if (response.statusCode == 200) {
        final supplierData = jsonDecode(response.body);
        supplier.value = Suppliers.fromJson(supplierData);
      }
    } catch (error) {
      print('Error fetching supplier: $error');
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print("No image selected");
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print("No image captured");
    }
  }

  Future getImgUrl(String name) async {
    final spaceRef = FirebaseStorage.instance.ref("chat").child(name);
    var str = await spaceRef.getDownloadURL();
    return str ?? "";
  }

  sendImageMessage(String url) async {
    final content = Msgcontent(
        uid: user_id, content: url, type: "image", addtime: Timestamp.now());

    await FirebaseFirestore.instance
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgcontent, options) =>
                msgcontent.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
      print("Document snapshot added with id, ${doc.id}");
    });
    await FirebaseFirestore.instance
        .collection("message")
        .doc(doc_id)
        .update({"last_msg": "【image】", "last_time": Timestamp.now()});
    var userbase = await FirebaseFirestore.instance
        .collection("users")
        .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options) => userdata.toFirestore(),
        )
        .where("id", isEqualTo: state.to_uid.value)
        .get();
    if (userbase.docs.isEmpty) {
      var title = "Message made by $from_name";
      var body = "【image】";
      var token = userbase.docs.first.data().fcmtoken;
      if (token != null) {
        sendNotification(title, body, token);
      }
    }
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = getRandomString(15) + extension(_photo!.path);
    try {
      final ref = FirebaseStorage.instance.ref("chat").child(fileName);

      ref.putFile(_photo!).snapshotEvents.listen((event) async {
        switch (event.state) {
          case TaskState.running:
            break;
          case TaskState.paused:
            break;
          case TaskState.success:
            String imgUrl = await getImgUrl(fileName);
            sendImageMessage(imgUrl);
            break;
          case TaskState.error:
            break;
          case TaskState.canceled:
            break;
        }
      });
    } catch (e) {
      print("There's an error $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    user_id = box.read("userId");
    if (user_id != null) {
      user_id = jsonDecode(user_id!);
    }

    var data = Get.arguments;
    doc_id = data['doc_id'] ?? "";
    state.to_uid.value = data['to_uid'] ?? "";
    state.to_name.value = data['to_name'] ?? "";
    state.to_avatar.value = data['to_avatar'] ?? "";
    state.supplier_uid = data['supplier_uid'] ?? "";
    // Fetch supplier details when the controller is initialized
    fetchSupplierDetails(state.supplier_uid);
    clear_msg_num(doc_id);
  }

  @override
  void onClose() {
    super.onClose();
    clear_msg_num(doc_id);
  }

  clear_msg_num(String docId) async {
    var messageRes = await db
        .collection("message")
        .doc(docId)
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .get();
    if (messageRes.data() != null) {
      var item = messageRes.data()!;
      to_uid = item.to_uid;
      from_uid = item.from_uid;
      from_name = item.from_name;
      to_name = item.to_name;
      int toMsgNum = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int fromMsgNum = item.from_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_uid == user_id) {
        toMsgNum = 0;
      } else {
        fromMsgNum = 0;
      }
      await db
          .collection("message")
          .doc(docId)
          .update({"to_msg_num": toMsgNum, "from_msg_num": fromMsgNum});
    }
  }

  sendMessage() async {
    String sendContent = textController.text;
    if (sendContent.isEmpty) return;
    final content = Msgcontent(
        uid: user_id,
        content: sendContent,
        type: "text",
        addtime: Timestamp.now());
    await FirebaseFirestore.instance
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgcontent, options) =>
                msgcontent.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
      textController.clear();
      Get.focusScope?.unfocus();
    });
    var messageRes = await db
        .collection("message")
        .doc(doc_id)
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .get();

    if (messageRes.data() != null) {
      var item = messageRes.data()!;
      int toMsgNum = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int fromMsgNum = item.from_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_uid == user_id) {
        fromMsgNum = fromMsgNum + 1;
      } else {
        toMsgNum = toMsgNum + 1;
      }
      await db.collection("message").doc(doc_id).update({
        "to_msg_num": toMsgNum,
        "from_msg_num": fromMsgNum,
        "last_msg": sendContent,
        "last_time": Timestamp.now()
      });
    }
    var userbase = await FirebaseFirestore.instance
        .collection("users")
        .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options) => userdata.toFirestore(),
        )
        .where("id", isEqualTo: state.to_uid.value)
        .get();

    if (userbase.docs.isNotEmpty) {
      var title = "Message sent by $from_name";
      var body = sendContent;
      var token = userbase.docs.first.data().fcmtoken;
      if (token != null) {
        sendNotification(title, body, token);
      } else {
        print("token is empty, so won't send notification");
      }
    } else {
      print("docs are empty");
    }
  }

  sendOrderMessage(String message, String orderId) async {
    String sendContent = message;
    final content = Msgcontent(
        uid: user_id,
        content: sendContent,
        type: "order",
        orderId: orderId,
        addtime: Timestamp.now());

    // Add message to Firestore
    await FirebaseFirestore.instance
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgcontent, options) =>
                msgcontent.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
      textController.clear();
      Get.focusScope?.unfocus();
    });

    // Update message count and last message
    var messageRes = await db
        .collection("message")
        .doc(doc_id)
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .get();

    if (messageRes.data() != null) {
      var item = messageRes.data()!;
      int toMsgNum = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int fromMsgNum = item.from_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_uid == user_id) {
        fromMsgNum = fromMsgNum + 1;
      } else {
        toMsgNum = toMsgNum + 1;
      }
      await db.collection("message").doc(doc_id).update({
        "to_msg_num": toMsgNum,
        "from_msg_num": fromMsgNum,
        "last_msg": sendContent,
        "last_time": Timestamp.now()
      });
    }

    // Send notification
    var userbase = await FirebaseFirestore.instance
        .collection("users")
        .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options) => userdata.toFirestore(),
        )
        .where("id", isEqualTo: state.to_uid.value)
        .get();

    if (userbase.docs.isNotEmpty) {
      var title = "Message sent by $from_name";
      var body = sendContent;
      var token = userbase.docs.first.data().fcmtoken;
      if (token != null) {
        sendNotification(title, body, token);
      } else {
        print("token is empty, so won't send notification");
      }
    } else {
      print("docs are empty");
    }
  }

  @override
  void onReady() {
    super.onReady();
    var messages = FirebaseFirestore.instance
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgcontent, options) =>
                msgcontent.toFirestore())
        .orderBy("addtime", descending: false);
    state.msgcontentList.clear();
    listener = messages.snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null) {
              state.msgcontentList.insert(0, change.doc.data()!);
            }
            break;
          case DocumentChangeType.modified:
            break;

          case DocumentChangeType.removed:
            break;
        }
      }
    }, onError: (error) => print("Listen failed:  $error"));
    getLocation();
  }

  Future<void> sendNotification(
      String? title, String? body, String? token) async {
    if (title == null || body == null || token == null || from_uid == null) {
      print("One of the info is null. Cancel sending notification");
      return;
    }
    var url =
        Uri.parse('${Environment.appBaseUrl}/api/supplier/messagesByRes/');
    var IosNotification = {
      "data": {
        "doc_id": "$doc_id",
        "to_uid": "$to_uid",
        "to_name": "${user_profile?.username}",
        "to_avatar": "${user_profile?.profile}"
      },
      "notification": {
        "body": body,
        "title": title,
        "content_available": true,
        "mutable_content": true,
        "sound": "task_cancel.caf",
        "badge": 1
      },
      "to": token
    };
    String IosNotificationJson = jsonEncode(IosNotification);
    // android
    var AndroidNotification = {
      "data": {
        "doc_id": "$doc_id",
        "to_uid": "$to_uid",
        "to_name": "${user_profile?.username}",
        "to_avatar": "${user_profile?.profile}"
      },
      "notification": {
        "body": body,
        "title": title,
        "android_channel_id": "in.sivo.venue",
        "sound": "default",
      },
      "to": token
    };
    var restToken = await box.read("token");
    restToken = jsonDecode(restToken);
    String AndroidNotificationJson = jsonEncode(AndroidNotification);
    var notificationInfo = jsonEncode({
      "data": {
        "doc_id": "$doc_id",
        "to_uid": to_uid,
        "to_name": "${user_profile?.username}",
        "to_avatar": "${user_profile?.profile}"
      },
      "notification": {
        "body": body,
        "title": title,
        "android_channel_id": "in.sivo.venue",
        "sound": "default"
      },
      "to": token
    });
    try {
      await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $restToken'
          },
          //body: GetPlatform.isIOS?IosNotificationJson:AndroidNotificationJson

          body: notificationInfo);
    } catch (e) {
      print("Error sending notification ${e.toString()}");
    }
  }

  getLocation() async {
    try {
      var userLocation = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: state.to_uid.value)
          .withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userdata, options) =>
                  userdata.toFirestore())
          .get();
      var location = userLocation.docs.first.data().location;
      if (location != "") {
        state.to_location.value = location ?? "unknown";
      } else {}
    } catch (e) {
      print("We have error $e");
    }
  }

  @override
  void dispose() {
    msgScrolling.dispose();
    listener.cancel();
    super.dispose();
  }
}
