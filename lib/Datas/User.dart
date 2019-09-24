import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class User {
  //int id;
  String username;
  String password;
  //String name;
  //String schoolCode;
  String schoolUrl;
  String schoolName;
  //String parentName;
  //String parentId;
  String trainingName;
  String trainingId;

  Color color;

  User(this.username, this.password, this.schoolUrl, this.schoolName, this.trainingName, this.trainingId);

  User.fromJson(Map json) {
    //id = json["id"];
    username = json["username"];
    password = json["password"];
    //name = json["name"];
    //schoolCode = json["schoolCode"];
    schoolUrl = json["schoolUrl"];
    schoolName = json["schoolName"];
    trainingName = json["trainingName"];
    trainingId = json["trainingId"];
    try {
      color = Color(json["color"]);

    } catch (e) {
      color = Color(0);
    } finally {

    }
  }

  bool isSelected() => username == globals.selectedUser.username;

  Map<String, dynamic> toMap() {
    var userMap = {
      //"id": id,
      "username": username,
      "password": password,
      //"name": name,
      //"schoolCode": schoolCode,
      "schoolUrl": schoolUrl,
      "schoolName": schoolName,
      //"parentName": parentName,
      //"parentId": parentId,
      "trainingName": trainingName,
      "trainingId": trainingId,
      "color": color != null ? color.value : 0,
    };
    return userMap;
  }
}