import 'dart:async';
import 'dart:convert' show utf8, json;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:native_http_request/native_http_request.dart' as nhttp;

import '../Datas/User.dart';
import '../Utils/Saver.dart';

class RequestHelper {

  Future<String> getInstitutes() async {
    final String url =
        "mobilecloudservice.cloudapp.net/MobileServiceLib/MobileCloudService.svc/GetAllNeptunMobileUrls";

    var r = nhttp.NativeHttpRequest.getRequest(url, headers: {
      "HOST": "kretaglobalmobileapi.ekreta.hu",
      "apiKey": "7856d350-1fda-45f5-822d-e1a2f3f1acf0"
    });

    return r;
    //return json.decode(await response.transform(utf8.decoder).join());
  }

  Future<String> getStuffFromUrl(String url, String body) async {

    HttpClient client = new HttpClient();

    final HttpClientRequest request = await client.postUrl(Uri.parse(url))
      ..headers.set("Content-Type","application/json; charset=utf-8")
      ..headers.set("Content-Length",body.length)
      ..headers.set("Expect","100-continue")
      ..headers.set("Host",url.split("/")[2])..add(utf8.encode(body));



    return await (await request.close()).transform(utf8.decoder).join();
  }

  Future<String> getEvaluations(String schoolUrl, String userName, String password, String trainingId) =>
      getStuffFromUrl(schoolUrl + "/GetMarkbookData",'{"filter":{"TermID":0},"TotalRowCount":-1,"ExceptionsEnum":0,"UserLogin":"'+userName+'","Password":"'+password+'","NeptunCode":"'+userName+'","CurrentPage":1,"StudentTrainingID":"'+trainingId+'","LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}');

  Future<String> getForums(String schoolUrl, String userName, String password, String trainingId) =>
      getStuffFromUrl(schoolUrl + "/GetForums",'{"TotalRowCount":-1,"ExceptionsEnum":0,"ForumName":"","UserLogin":"'+userName+'","Password":"'+password+'","NeptunCode":"'+userName+'","CurrentPage":0,"StudentTrainingID":'+trainingId+',"LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}');

  Future<String> getMessages(String schoolUrl, String userName, String password, String trainingId) =>
      getStuffFromUrl(schoolUrl + "/GetMessages",'{"TotalRowCount":-1,"ExceptionsEnum":0,"ForumName":"","UserLogin":"'+userName+'","Password":"'+password+'","NeptunCode":"'+userName+'","CurrentPage":0,"StudentTrainingID":'+trainingId+',"LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}');


  /*Future<String> getHomeworkByTeacher(String accessToken,
      String schoolCode, int id) => getStuffFromUrl("https://" + schoolCode +
      ".e-kreta.hu/mapi/api/v1/HaziFeladat/TanarHaziFeladat/" + id.toString(),
      accessToken, schoolCode);*/

  Future<String> getEvents(String schoolUrl, String userName, String password, String trainingId) =>
      getStuffFromUrl(schoolUrl + "/GetPeriods", '{"PeriodTermID":70618,"TotalRowCount":-1,"ExceptionsEnum":0,"UserLogin":"'+userName+'","Password":"'+password+'","NeptunCode":"'+userName+'","CurrentPage":0,"StudentTrainingID":'+trainingId+',"LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}');

  Future<String> getTimeTable(String schoolUrl, String userName, String password, String trainingId, DateTime from, DateTime to) =>
      getStuffFromUrl(schoolUrl +"/GetCalendarData", '{"needAllDaylong":false,"TotalRowCount":-1,"ExceptionsEnum":0,"Time":true,"Exam":true,"Task":true,"Apointment":true,"RegisterList":true,"Consultation":true,"startDate":"\/Date('+from.millisecondsSinceEpoch.toString()+')\/","endDate":"\/Date('+to.millisecondsSinceEpoch.toString()+')\/","entityLimit":0,"UserLogin":"'+userName+'","Password":"'+password+'","NeptunCode":"'+userName+'","CurrentPage":0,"StudentTrainingID":'+trainingId+',"LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}');

  Future<String> getTraining(String schoolUrl, String userName, String password){

    String url = schoolUrl +"/GetTrainings";
    String body = '{"OnlyLogin":false,"TotalRowCount":-1,"ExceptionsEnum":0,"UserLogin":"'+userName+'","Password":"'+password+'","NeptunCode":null,"CurrentPage":0,"StudentTrainingID":null,"LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}';
    Future<String> response = getStuffFromUrl(url, body);
    return response;
  }



/*Future<http.Response> getBearer(String jsonBody, String schoolCode) {
    try {
      return http.post("https://" + schoolCode + ".e-kreta.hu/idp/api/v1/Token",
          headers: {
            "HOST": schoolCode + ".e-kreta.hu",
            "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
          },
          body: jsonBody);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "HĂĄlĂłzati hiba",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return null;
    }
  }

  void seeMessage(int id, User user) async {
    try {
      String jsonBody =
          "institute_code=" + user.schoolCode +
              "&userName=" + user.username +
              "&password=" + user.password +
              "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";

      Map<String, dynamic> bearerMap = json.decode(
          (await RequestHelper().getBearer(jsonBody, user.schoolCode))
              .body);
      String code = bearerMap.values.toList()[0];

      await http.post("https://eugyintezes.e-kreta.hu//integration-kretamobile-api/v1/kommunikacio/uzenetek/olvasott",
          headers: {
        "Authorization": ("Bearer " + code),
          },
          body: "{\"isOlvasott\":true,\"uzenetAzonositoLista\":[$id]}");
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "HĂĄlĂłzati hiba",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return null;
    }
  }*/

  void seeMessage(int id, User user) async {
    /*try {
      String jsonBody =
          "institute_code=" + user.schoolCode +
              "&userName=" + user.username +
              "&password=" + user.password +
              "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";

      Map<String, dynamic> bearerMap = json.decode(
          (await RequestHelper().getBearer(jsonBody, user.schoolCode))
              .body);
      String code = bearerMap.values.toList()[0];

      await http.post("https://eugyintezes.e-kreta.hu//integration-kretamobile-api/v1/kommunikacio/uzenetek/olvasott",
          headers: {
            "Authorization": ("Bearer " + code),
          },
          body: "{\"isOlvasott\":true,\"uzenetAzonositoLista\":[$id]}");
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Hálózati hiba",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return null;
    }*/
  }

  Future<String> getStudentString(User user, {bool showErrors=true}) async {
    String instCode = user.schoolUrl;
    String userName = user.username;
    String password = user.password;
/*
    String jsonBody = "institute_code=" +
        instCode +
        "&userName=" +
        userName +
        "&password=" +
        password +
        "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";

    Map<String, dynamic> bearerMap;
    try {
      bearerMap = json.decode((await getBearer(jsonBody, instCode)).body);
    } catch (SocketException) {
      if (showErrors)
        Fluttertoast.showToast(
            msg: "HĂĄlĂłzati hiba",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
    }

    if (bearerMap["error"] == "invalid_grant"){
      Fluttertoast.showToast(
          msg: "HibĂĄs jelszĂł vagy felhasznĂĄlĂłnĂŠv",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      String code = bearerMap["access_token"];

      String evaluationsString =
      (await getEvaluations(code, instCode));

      return evaluationsString;
    }
    return null;*/

    return getTraining(instCode, userName, password);
  }
/*
  Future<String> getEventsString(User user) async {
    String instCode = user.schoolCode;
    String userName = user.username;
    String password = user.password;
    String trainingId=user.trainingId;

    String jsonBody = "institute_code=" +
        instCode +
        "&userName=" +
        userName +
        "&password=" +
        password +
        "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";
    Map<String, dynamic> bearerMap;
    try {
      bearerMap =
          json.decode((await getBearer(jsonBody, instCode)).body);
    } catch (e) {
      print(e);
    }

    String code = bearerMap.values.toList()[0];

    String eventsString = await getEvents(code, instCode);

    saveEvents(eventsString, user);

    return eventsString;
  }*/

}
