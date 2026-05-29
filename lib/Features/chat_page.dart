import 'package:car_rent_app/Shared/custom_textfeild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatPage extends StatefulWidget {
  final String carId;
  final String userId;
  const ChatPage({super.key, required this.userId, required this.carId});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  Map<String, dynamic> user = {};

  void getUser() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    setState(() {
      user = snapshot.data() as Map<String, dynamic>;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return user.isEmpty
        ? Center(child: CircularProgressIndicator())
        : GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: Scaffold(
              appBar: AppBar(title: Text(user['First name'])),
              body: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('messages')
                            .where(
                              Filter.or(
                                Filter.and(
                                  Filter(
                                    'senderId',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid,
                                  ),
                                  Filter(
                                    'receiverId',
                                    isEqualTo: widget.userId,
                                  ),
                                ),
                                Filter.and(
                                  Filter('senderId', isEqualTo: widget.userId),
                                  Filter(
                                    'receiverId',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid,
                                  ),
                                ),
                              ),
                            )
                            .orderBy('messageDate')
                            .snapshots(),

                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('لا توجد رسائل'));
                          }

                          List docs = snapshot.data!.docs;

                          return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> message =
                                  docs[index].data() as Map<String, dynamic>;

                              bool isMe =
                                  message['sender id'] ==
                                  FirebaseAuth.instance.currentUser!.uid;

                              return Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,

                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.h),
                                  padding: EdgeInsets.all(12.w),

                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),

                                  child: Text(
                                    message['message content'],
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 10.h),

                    CustomTextfeild(
                      controller: messageController,
                      lable: 'اكتب رسالتك هنا',
                      icon: Icons.message,

                      action: () async {
                        await FirebaseFirestore.instance
                            .collection('messages')
                            .add({
                              'senderId':
                                  FirebaseAuth.instance.currentUser!.uid,
                              'receiverId': widget.userId,
                              'messageContent': messageController.text,
                              'messageDate': Timestamp.now(),
                              'carId': widget.carId,
                            });

                        messageController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
