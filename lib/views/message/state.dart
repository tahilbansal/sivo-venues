import 'package:rivus_user/common/entities/message.dart';
import 'package:get/get.dart';

class MessageState {
  RxList<Message> msgList = <Message>[].obs;
  RxList<Message> filteredMsgList = <Message>[].obs;
}
