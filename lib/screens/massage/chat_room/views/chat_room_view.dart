import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medkit_app/controller/auth_controllerr.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/theme.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  static String routeName = "/chatroomview";
  final authC = Get.find<AuthControllerr>();
  final String chat_id = (Get.arguments as Map<String, dynamic>)["chat_id"];
  final String friemail =
      (Get.arguments as Map<String, dynamic>)["friendEmail"];
  @override
  final controller = Get.put(ChatRoomController());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/BgChat.png',
              ),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            centerTitle: false,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: StreamBuilder<DocumentSnapshot<Object?>>(
                      stream: controller.streamFriendData(friemail),
                      builder: (context, snapFriendUser) {
                        if (snapFriendUser.connectionState ==
                            ConnectionState.active) {
                          var dataFriend = snapFriendUser.data!.data()
                              as Map<String, dynamic>;

                          if (dataFriend["photoUrl"] == "noimage") {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                "assets/logo/noimage.png",
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                dataFriend["photoUrl"],
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                        }
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            "assets/logo/noimage.png",
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  StreamBuilder<DocumentSnapshot<Object?>>(
                    stream: controller.streamFriendData(
                        (Get.arguments as Map<String, dynamic>)["friendEmail"]),
                    builder: (context, snapFriendUser) {
                      if (snapFriendUser.connectionState ==
                          ConnectionState.active) {
                        var dataFriend =
                            snapFriendUser.data!.data() as Map<String, dynamic>;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(dataFriend["name"],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: kWhite)),
                            if (dataFriend['status'] != "")
                              Text(
                                dataFriend["status"],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ])),
        body: WillPopScope(
          onWillPop: () {
            if (controller.isShowEmoji.isTrue) {
              controller.isShowEmoji.value = false;
            } else {
              Navigator.pop(context);
            }
            return Future.value(false);
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: controller.streamChats(chat_id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        var alldata = snapshot.data!.docs;
                        Timer(
                          Duration.zero,
                          () => controller.scrollC.jumpTo(
                              controller.scrollC.position.maxScrollExtent),
                        );
                        return ListView.builder(
                          controller: controller.scrollC,
                          itemCount: alldata.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    "${alldata[index]["groupTime"]}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: kBlack),
                                  ),
                                  ItemChat(
                                    msg: "${alldata[index]["msg"]}",
                                    isSender: alldata[index]["pengirim"] ==
                                            authC.user.value.email!
                                        ? true
                                        : false,
                                    time: "${alldata[index]["time"]}",
                                  ),
                                ],
                              );
                            } else {
                              if (alldata[index]["groupTime"] ==
                                  alldata[index - 1]["groupTime"]) {
                                return ItemChat(
                                  msg: "${alldata[index]["msg"]}",
                                  isSender: alldata[index]["pengirim"] ==
                                          authC.user.value.email!
                                      ? true
                                      : false,
                                  time: "${alldata[index]["time"]}",
                                );
                              } else {
                                return Column(
                                  children: [
                                    Text(
                                      "${alldata[index]["groupTime"]}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ItemChat(
                                      msg: "${alldata[index]["msg"]}",
                                      isSender: alldata[index]["pengirim"] ==
                                              authC.user.value.email!
                                          ? true
                                          : false,
                                      time: "${alldata[index]["time"]}",
                                    ),
                                  ],
                                );
                              }
                            }
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: controller.isShowEmoji.isTrue
                      ? 5
                      : context.mediaQueryPadding.bottom,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        child: TextField(
                          autocorrect: false,
                          cursorColor: kPrimaryColor,
                          controller: controller.chatC,
                          focusNode: controller.focusNode,
                          onEditingComplete: () => controller.newChat(
                            authC.user.value.email!,
                            Get.arguments as Map<String, dynamic>,
                            controller.chatC.text,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kWhite,
                            prefixIconColor: kPrimaryColor,
                            prefixIcon: IconButton(
                              onPressed: () {
                                controller.focusNode.unfocus();
                                controller.isShowEmoji.toggle();
                              },
                              focusColor: kPrimaryColor,
                              highlightColor: kPrimaryColor,
                              icon: const Icon(
                                Icons.emoji_emotions_outlined,
                              ),
                              color: kPrimaryColor,
                            ),
                          ).copyWith(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: const BorderSide(color: kWhite),
                              gapPadding: 10,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: const BorderSide(color: kWhite),
                              gapPadding: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      borderRadius: BorderRadius.circular(100),
                      color: kPrimaryColor,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () => controller.newChat(
                          authC.user.value.email!,
                          Get.arguments as Map<String, dynamic>,
                          controller.chatC.text,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => (controller.isShowEmoji.isTrue)
                    ? Container(
                        height: 325,
                        child: EmojiPicker(
                          onEmojiSelected: (category, emoji) {
                            controller.addEmojiToChat(emoji);
                          },
                          onBackspacePressed: () {
                            controller.deleteEmoji();
                          },
                          config: const Config(
                            backspaceColor: kPrimaryColor,
                            columns: 8,
                            emojiSizeMax: 30.0,
                            verticalSpacing: 5,
                            horizontalSpacing: 5,
                            initCategory: Category.RECENT,
                            bgColor: Color(0xFFF2F2F2),
                            indicatorColor: kPrimaryColor,
                            iconColor: Colors.grey,
                            iconColorSelected: kPrimaryColor,
                            progressIndicatorColor: kPrimaryColor,
                            showRecentsTab: true,
                            recentsLimit: 28,
                            noRecents: Text('No Recents',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black26)),
                            categoryIcons: CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat({
    Key? key,
    required this.isSender,
    required this.msg,
    required this.time,
  }) : super(key: key);

  final bool isSender;
  final String msg;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: kOrange,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSender ? Color.fromARGB(255, 165, 246, 219) : kWhite,
              boxShadow: shadowBOX,
              borderRadius: isSender
                  ? const BorderRadius.only(
                      topLeft: const Radius.circular(15),
                      topRight: const Radius.circular(15),
                      bottomLeft: const Radius.circular(15),
                    )
                  : const BorderRadius.only(
                      topLeft: const Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
            ),
            padding: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              // child: Text(
              //   "$msg",
              //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              //         color: kBlack,
              //       ),
              // ),
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                      child: Column(
                    crossAxisAlignment: isSender
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$msg",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: kBlack,
                            ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        DateFormat('HH.mm').format(DateTime.parse(time)),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )),
                  // WidgetSpan(
                  //   child: Text(
                  //     DateFormat('HH.mm').format(DateTime.parse(time)),
                  //     style: Theme.of(context).textTheme.bodySmall,
                  //     textAlign: TextAlign.right,
                  //   ),
                  // ),
                ]),
              ),
            ),
          ),
          // Text(
          //   DateFormat('HH.mm').format(DateTime.parse(time)),
          //   style: Theme.of(context).textTheme.bodySmall,
          // ),
        ],
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
