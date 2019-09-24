import 'dart:ui';
import 'dart:math';
import '../Helpers/encrypt_codec.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Helpers/DBHelper.dart';

import 'SettingsHelper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../Helpers/SettingsHelper.dart';
import '../globals.dart' as globals;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import '../Datas/Student.dart';
import '../Helpers/TimetableHelper.dart';
import '../Utils/StringFormatter.dart';
import '../Utils/AccountManager.dart';
import '../Datas/User.dart';
import '../Datas/Account.dart';
import '../Datas/Note.dart';
import '../Datas/Lesson.dart';
import 'package:connectivity/connectivity.dart';


class BackgroundHelper {
  Future<bool> get canSyncOnData async =>
      await SettingsHelper().getCanSyncOnData();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  void doEvaluations(Account account) async {
    await account.refreshStudentString(true);
    List<Evaluation> offlineEvals = account.student.Evaluations;
    // testing:
    // offlineEvals.removeAt(0);
    await account.refreshStudentString(false);
    List<Evaluation> evals = account.student.Evaluations;

    for (Evaluation e in evals) {
      bool exist = false;
      for (Evaluation o in offlineEvals)
        if (e.trueID() == o.trueID())
          exist = true;
      if (!exist) {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'evaluations', 'jegyek', 'értesítések a jegyekről',
          importance: Importance.Max,
          priority: Priority.High,
          color: Colors.blue,
        );
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            e.trueID(),
            e.Subject + " - " +
                (e.NumberValue != 0 ? e.NumberValue.toString() : e.Value),
            e.owner.username + ", " + (e.Theme ?? ""), platformChannelSpecifics,
            payload: e.trueID().toString());
      }

      //todo jegyek változása
      //todo új házik
      //todo ha óra elmarad/helyettesítés
    }
  }

  void doNotes(Account account) async {
    await account.refreshStudentString(true);
    List<Note> offlineNotes = account.notes;
    await account.refreshStudentString(false);
    List<Note> notes = account.notes;
    // testing:
    // offlineNotes.removeAt(0);

    for (Note n in notes) {
      if (!offlineNotes.map((Note note) => note.id).contains(n.id)) {
        print(offlineNotes.map((Note note) => note.id).toList());
        print(n.id);
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'notes', 'feljegyzések', 'értesítések a feljegyzésekről',
            importance: Importance.Max,
            priority: Priority.High,
            color: Colors.blue);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            n.id,
            n.title + " - " + n.type,
            n.content, platformChannelSpecifics,
            payload: n.id.toString());
      }
    }
  }

  void doAbsences(Account account) async {
    await account.refreshStudentString(true);
    Map<String, List<Absence>> offlineAbsences = account.absents;
    await account.refreshStudentString(false);
    Map<String, List<Absence>> absences = account.absents;
    // testing:
    // offlineAbsences.remove(offlineAbsences.keys.first);

    if (absences != null)
      absences.forEach((String date, List<Absence> absenceList) {
        for (Absence absence in absenceList) {
          bool exist = false;
          offlineAbsences.forEach((String dateOffline, List<Absence> absenceList2) {
            for (Absence offlineAbsence in absenceList2)
              if (absence.AbsenceId == offlineAbsence.AbsenceId)
                exist = true;
          });
          if (!exist) {
            var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
              'absences', 'mulasztások', 'értesítések a hiányzásokról',
              importance: Importance.Max,
              priority: Priority.High,
              color: Colors.blue,
              groupKey: account.user.username + absence.Type,);
            var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
            var platformChannelSpecifics = new NotificationDetails(
                androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
            flutterLocalNotificationsPlugin.show(
              absence.AbsenceId,
              absence.Subject + " " + absence.TypeName,
              absence.owner.username +
                  (absence.DelayTimeMinutes != 0 ? (", " +
                      absence.DelayTimeMinutes.toString() +
                      " perc késés") : ""), platformChannelSpecifics,
              payload: absence.AbsenceId.toString(),);
          }
        }
      });
  }

  void doLessons(Account account) async {
    DateTime startDate = new DateTime.now();
    startDate = startDate.add(
        new Duration(days: (-1 * startDate.weekday + 1)));

    List<Lesson> lessonsOffline = await getLessonsOffline(
        startDate, startDate.add(new Duration(days: 7)), account.user);
    List<Lesson> lessons = await getLessons(
        startDate, startDate.add(new Duration(days: 7)), account.user);

    for (Lesson lesson in lessons) {
      bool exist = false;
      for (Lesson offlineLesson in lessonsOffline) {
        exist = (lesson.id == offlineLesson.id &&
            ((lesson.isMissed && !offlineLesson.isMissed) ||
                (lesson.isSubstitution && !offlineLesson.isSubstitution)));
      }
      if (exist) {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'lessons', 'órák', 'értesítések elmaradt/helyettesített órákról',
            importance: Importance.Max,
            priority: Priority.High,
            style: AndroidNotificationStyle.BigText,
            color: Colors.blue);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
            lesson.id,
            lesson.subject + " " +
                lesson.date.toIso8601String().substring(0, 10) + " (" +
                dateToWeekDay(lesson.date) + ")",
            lesson.stateName + " " + lesson.depTeacher,
            platformChannelSpecifics,
            payload: lesson.id.toString());
      }
    }
  }

  void doBackground() async {
    final storage = new FlutterSecureStorage();
    String value = await storage.read(key: "db_key");
    if (value == null) {
      int randomNumber = Random.secure().nextInt(4294967296);
      await storage.write(key: "db_key", value: randomNumber.toString());
      value = await storage.read(key: "db_key");
    }

    var codec = getEncryptSembastCodec(password: value);

    globals.db = await globals.dbFactory.openDatabase(
        (await DBHelper().localFolder) + DBHelper().dbPath,
        codec: codec);

    List accounts = List();
    for (User user in await AccountManager().getUsers())
      accounts.add(Account(user));
    for (Account account in globals.accounts) {
      try {
        doEvaluations(account);
      } catch (e) {
        print(e);
      }
      try {
        doNotes(account);
      } catch (e) {
        print(e);
      }
      try {
        doAbsences(account);
      } catch (e) {
        print(e);
      }
      try {
        doLessons(account);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<int> backgroundTask() async {
    await Connectivity().checkConnectivity().then((ConnectivityResult result) async {
      try {
        if (result == ConnectivityResult.mobile && await canSyncOnData ||
            result == ConnectivityResult.wifi)
          doBackground();
      } catch (e) {
        print(e);
      }
    });

    return 0;
  }

  void backgroundFetchHeadlessTask() async {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('notification_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await backgroundTask().then((int finished) {
      BackgroundFetch.finish();
    });
  }

  Future<void> configure() async {
    if (await SettingsHelper().getNotification()) {
      await SettingsHelper().getRefreshNotification().then((int _refreshNotification) {
        BackgroundFetch.configure(BackgroundFetchConfig(
          minimumFetchInterval: _refreshNotification,
          stopOnTerminate: false,
          forceReload: false,
          enableHeadless: true,
          startOnBoot: true,
        ), backgroundFetchHeadlessTask);
      });
    }
  }

  Future<void> register() async {
    if (await SettingsHelper().getNotification()) {
      BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    }
  }

}