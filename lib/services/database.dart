import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String charRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(charRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  /// thay vì trả về QuerySnapshot như video làm
  /// mình đổi cái QuerySnapshot sang List<Map<String, dynamic>> luôn
  /// để không phải xử lí ở bên UI kia nữa
  /// tí nếu trong video có đoạn chuyển từ snapshot sang docs
  /// hay List gì thì chị bỏ qua phần đó mà làm từ đoạn
  /// nó converst sang List<Map<String, dynamic>> luôn nhé
  ///
  Stream<List<Map<String, dynamic>>> getConversationMessages(
      String chatRoomId) {
    log(chatRoomId);
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getChatRooms(String userName) {
    //log(userName);
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return <String, dynamic>{
          "chatroomId": data["chatroomId"] as String,
          "users": List<String>.from(data["users"]),
        };
      }).toList();
    });
  }
}
