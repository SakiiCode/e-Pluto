import 'dart:convert' show utf8, json;

import 'User.dart';
import 'Note.dart';
import 'Average.dart';
import 'Student.dart';
import '../globals.dart';
import '../Helpers/DBHelper.dart';
import '../Helpers/RequestHelper.dart';
import '../Helpers/AbsentHelper.dart';
import '../Helpers/AverageHelper.dart';
import '../Helpers/NotesHelper.dart';
import '../Utils/Saver.dart';

class Account {
  Student student;

  User user;
  Map _studentJson;
  String _eventsString;
  Map<String, List<Absence>> absents;
  List<Note> notes;
  List<Average> averages;

  //todo add a Bearer token here

  Account(User user) {
    this.user = user;
  }

  Future<void> refreshStudentString(bool isOffline) async {
    if (isOffline && _studentJson == null) {
      try {
        _studentJson = await DBHelper().getStudentJson(user);
      } catch (e) {
        print(e);
      }
    } else if (!isOffline) {
      _studentJson = json.decode('{"TermId":-1,"TotalRowCount":-1,"ExceptionsEnum":0,"UserLogin":"'+user.username+'","Password":"'+user.password+'","NeptunCode":"'+user.username+'","CurrentPage":0,"StudentTrainingID":'+user.trainingId+',"LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}');//TODO  fix await RequestHelper().getStudentString(''));
      await DBHelper().addStudentJson(_studentJson, user);
    }

    student = Student.fromMap(_studentJson, user);
    absents = new Map<String, List<Absence>>();//await AbsentHelper().getAbsentsFrom(student.Absences);
    await _refreshEventsString(isOffline);
    notes = await NotesHelper().getNotesFrom(await new RequestHelper().getMessages(user.schoolUrl,user.username,user.password,user.trainingId), user);
    averages = new List<Average>();//await AverageHelper().getAveragesFrom(json.encode(_studentJson), user);
  }

  Future<void> _refreshEventsString(bool isOffline) async {
    /*if (isOffline)
      _eventsString = await readEventsString(user);
    else
      _eventsString = await RequestHelper().getEvents(user); //todo eredetileg eventsString*/
    _eventsString = "";
  }

  List<Evaluation> get midyearEvaluations =>
      student.Evaluations.where(
              (Evaluation evaluation) => evaluation.isMidYear()).toList();
}