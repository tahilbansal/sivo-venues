import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/common/entities/message.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/views/message/controller.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MessageController controller = Get.find<MessageController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        backgroundColor: kPrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              onChanged: (value) => controller.searchMessages(value),
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final filteredMessages = controller.state.filteredMsgList;

              if (filteredMessages.isEmpty) {
                return const Center(
                  child: Text("No results found."),
                );
              }

              return ListView.builder(
                itemCount: filteredMessages.length,
                itemBuilder: (context, index) {
                  final Message message = filteredMessages[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(message.avatar ?? ''),
                    ),
                    title: Text(message.name ?? ''),
                    subtitle: Text(message.last_msg ?? ''),
                    onTap: () {
                      Get.toNamed("/chat", arguments: {
                        "doc_id": message.doc_id,
                        "to_uid": message.token,
                        "to_name": message.name,
                        "to_avatar": message.avatar,
                      });
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

