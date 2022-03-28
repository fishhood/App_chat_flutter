import 'package:flutter/material.dart';

AppBar appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset("assets/images/logo.jpg"),
  );
}


InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white54,// chữ ẩn
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white) //đường gạch
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white) // tự động hiển thị màu kh cần phải nhấp chuột
      ),
  );
}

TextStyle simpleTextStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 16
  );
}

TextStyle mediumTextStyle(){
  return TextStyle(
  color: Colors.white,
  fontSize: 17
  );
}


