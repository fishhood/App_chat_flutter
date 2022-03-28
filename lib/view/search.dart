import 'package:chat_app_tutorial/helper/constants.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/view/conversation_screen.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}
//String _myName;

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchtextEditingController = TextEditingController();

  QuerySnapshot<Map<String, dynamic>>? searchSnapshot;

  //late QuerySnapshot<Map<String, dynamic>> searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final data = searchSnapshot!.docs[index].data();
              return SearchTile(
                userName: data["name"] as String,
                userEmail: data["email"] as String,
              );
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchtextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  //Tạo phòng chats
  createChatroomAndStartConversation({required String userName}) {
    print("${Constants.myName}");
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> charRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, charRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print("you can't send message to yourself");
    }
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  Widget SearchTile({required String userName, required String userEmail}) {
    return Row(children: [
      Column(
        children: [
          Text(
            userName,
            style: simpleTextStyle(),
          ),
          Text(
            userEmail,
            style: simpleTextStyle(),
          ),
        ],
      ),
      Spacer(),
      GestureDetector(
          onTap: () {
            createChatroomAndStartConversation(userName: userName);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text("Message"),
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: searchSnapshot == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // cái sizedbox này đã thực hiện đủ chức năng của 1 cái ô tìm kiếm rồi
                // chị ko cần sửa gì ở mục này nữa
                // em đã cho cái gesture detector thay bằng nút search trong textfield luôn rồi
                // không cần làm theo trên mạng
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: searchtextEditingController,
                      decoration: InputDecoration(
                        hintText: "Search here",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            initiateSearch();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                searchList()
              ],
            ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
