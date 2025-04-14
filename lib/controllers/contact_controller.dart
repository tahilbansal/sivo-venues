import 'dart:convert';

import 'package:sivo_venues/common/entities/entities.dart';
import 'package:sivo_venues/common/utils/check_user.dart';
import 'package:sivo_venues/models/login_response.dart';
import 'package:sivo_venues/models/response_model.dart';
import 'package:sivo_venues/models/suppliers.dart';
import 'package:sivo_venues/views/message/chat/index.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class ContactState {
  var count = 0.obs;
  RxString supplierId = "".obs;
  RxString ownerId = "".obs;
  Rxn<Suppliers> supplier = Rxn<Suppliers>();
  RxBool loading = false.obs;
  RxList<UserData> contactList = <UserData>[].obs;
}

class ContactController extends GetxController {
  ContactController();

  final ContactState state = ContactState();
  final db = FirebaseFirestore.instance;
  final box = GetStorage();
  String? token;

  @override
  void onReady() {
    super.onReady();
    //this token could be something encrypted
    token = box.read("userId");
    if (token != null) {
      token = jsonDecode(token!);
    }
  }

  Future<ResponseModel> goChat(Suppliers toUserdata) async {
    String? token = box.read("userId");
    if (token != null) {
      token = jsonDecode(token);
    }
    if (token == state.ownerId.value) {
      return ResponseModel(
          isSuccess: false,
          message: "You can not chat to yourself",
          title: "Token issue");
    }
    if (token == null) {
      return ResponseModel(
          isSuccess: false,
          message: "Login before you continue",
          title: "Login issue");
    }
    bool appUser = CheckUser.isValidId(token);
    if (appUser == false) {
      return ResponseModel(
          isSuccess: false,
          message: "Corrupted user account",
          title: "Serious issue");
    }
    toUserdata.id =  toUserdata.owner;
    bool supplierOwner = CheckUser.isValidId(toUserdata.id!);

    if (toUserdata.id == null) {
      return ResponseModel(
          isSuccess: false,
          message: "Supplier may not exist, try another shop");
    }
    if (supplierOwner == false) {
      return ResponseModel(
          isSuccess: false,
          message: "Corrupted supplier account",
          title: "Serious issue");
    }
    var fromMessages = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: token) //and condition
        .where("to_uid", isEqualTo: toUserdata.id)
        .get();
    var toMessages = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: toUserdata.id)
        .where("to_uid", isEqualTo: token)
        .get();
    if (fromMessages.docs.isEmpty) {
      print("Empty chat list");
    } else {
      print("Chat id is ${fromMessages.docs.first.id}");
    }

    if (fromMessages.docs.isEmpty && toMessages.docs.isEmpty) {
      String? data = box.read("user");
      if (data == null) {
        return ResponseModel(
            isSuccess: false, message: "Try to login again", title: "Login");
      }
      LoginResponse userdata = LoginResponse.fromJson(jsonDecode(data));
      print("inserting---------");
      var msgdata = Msg(
          from_uid: userdata.id,
          to_uid: toUserdata.owner,
          from_name: userdata.username,
          to_name: toUserdata.title,
          from_avatar: userdata.profile,
          to_avatar: toUserdata.imageUrl,
          supplier_uid: state.supplierId.value,
          last_msg: "",
          last_time: Timestamp.now(),
          msg_num: 0);
      await db
          .collection("message")
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg.toFirestore())
          .add(msgdata)
          .then((value) {
        Get.to(const ChatPage(), arguments: {
          "doc_id": value.id,
          "to_uid": toUserdata.id ?? "",
          "to_name": toUserdata.title ?? "",
          "to_avatar": toUserdata.logoUrl ?? "",
          "supplier_uid": state.supplierId.value ?? "",
        });
      });
      return ResponseModel(isSuccess: true, message: "");
    } else {
      if (fromMessages.docs.isNotEmpty) {
        Get.to(const ChatPage(), arguments: {
          "doc_id": fromMessages.docs.first.id,
          "to_uid": toUserdata.id ?? "",
          "to_name": toUserdata.title ?? "",
          "to_avatar": toUserdata.logoUrl ?? "",
          "supplier_uid": state.supplierId.value ?? "",
        });
      }
      if (toMessages.docs.isNotEmpty) {
        Get.to(const ChatPage(), arguments: {
          "doc_id": toMessages.docs.first.id,
          "to_uid": toUserdata.id ?? "",
          "to_name": toUserdata.title ?? "",
          "to_avatar": toUserdata.logoUrl ?? "",
          "supplier_uid": state.supplierId.value ?? "",
        });
      }
      return ResponseModel(isSuccess: true);
    }
  }

  Future<ResponseModel> asyncLoadSingleSupplier() async {
    // Retrieve the userId from storage
    final userId = box.read("userId");
    if (userId == null) {
      return ResponseModel(isSuccess: false, message: "You did not login");
    }
    final decodedUserId = jsonDecode(userId).toString();
    final ownerId = state.ownerId.value;
    state.contactList.clear();
    // Query the Firestore collection
    var usersbase = await db
        .collection("users")
        .where("id", isNotEqualTo: decodedUserId)
        .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options) => userdata.toFirestore(),
        )
        .get();
    state.contactList.add(usersbase.docs[0].data());
    print("${usersbase.docs[0].data().toFirestore()}");
    return ResponseModel(isSuccess: true);
  }

  Future<ResponseModel> asyncLoadMultipleSupplier() async {
    // Retrieve the userId from storage

    final userId = box.read("userId");
    if (userId == null) {
      return ResponseModel(isSuccess: false, message: "You did not login");
    }
    final decodedUserId = jsonDecode(userId).toString();
    final ownerId = state.ownerId.value;
    print("Raw user id from storage: $userId");
    print("Decoded user id: $decodedUserId");
    print("Supplier id : $ownerId");
    // Query the Firestore collection
    var usersbase = await db
        .collection("users")
        .where("id", isNotEqualTo: decodedUserId)
        .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options) => userdata.toFirestore(),
        )
        .get();
    state.contactList.clear();
    for (var item in usersbase.docs) {
      state.contactList.add(item.data());
    }
    //state.contactList.add(usersbase.docs[0].data());
    print("${usersbase.docs[0].data().toFirestore()}");
    return ResponseModel(isSuccess: true);
  }
}
