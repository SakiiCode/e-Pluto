import 'dart:async';
import 'dart:convert' show utf8, json;
import 'dart:io';

import '../Datas/User.dart';

import 'package:path_provider/path_provider.dart';

Future<String> get _localFolder async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> _localEvaluations(User user) async {
  final path = await _localFolder;
  String suffix = user.id.toString();
  return new File('$path/evaluations_$suffix.json');
}

Future<File> saveEvaluations(String evaluationsString, User user) async {
  final file = await _localEvaluations(user);

  // Write the file
  return file.writeAsString(evaluationsString);
}

Future<Map<String, dynamic>> readEvaluations(User user) async {
  try {
    final file = await _localEvaluations(user);
    // Read the file
    String contents = await file.readAsString();

    Map<String, dynamic> evaluationsMap = json.decode(contents);
    return evaluationsMap;
  } catch (e) {
    return Map<String, dynamic>();
    // If we encounter an error, return 0
  }
}

Future<File> _localEvents(User user) async {
  final path = await _localFolder;
  String suffix = user.id.toString();
  return new File('$path/events_$suffix.json');
}

Future<File> saveEvents(String eventsString, User user) async {
  final file = await _localEvents(user);

  // Write the file
  return file.writeAsString(eventsString);
}

Future<List<dynamic>> readEvents(User user) async {
  try {
    final file = await _localEvents(user);
    // Read the file
    String contents = await file.readAsString();

    List<dynamic> eventsMap = json.decode(contents);
    return eventsMap;
  } catch (e) {
    // If we encounter an error, return 0
  }
}


Future<File> _localNotes(User user) async {
  final path = await _localFolder;
  String suffix = user.id.toString();
  return new File('$path/notes.json');
}

Future<File> saveNotes(String eventsString, User user) async {
  final file = await _localNotes(user);

  // Write the file
  return file.writeAsString(eventsString);
}

Future<List<dynamic>> readNotes(User user) async {
  try {
    final file = await _localNotes(user);
    // Read the file
    String contents = await file.readAsString();

    List<dynamic> notesMap = json.decode(contents);
    return notesMap;
  } catch (e) {
    // If we encounter an error, return 0
  }
}


Future<File> _localTimeTable(String time, User user) async {
  final path = await _localFolder;
  String suffix = user.id.toString();
  return new File('$path/timetable_$time-$suffix.json');
}

Future<File> saveTimetable(String timetableString, String time, User user) async {
  final file = await _localTimeTable(time, user);

  // Write the file
  return file.writeAsString(timetableString);
}

Future<List<dynamic>> readTimetable(String time, User user) async {
  try {
    final file = await _localTimeTable(time, user);
    // Read the file
    String contents = await file.readAsString();

    List<dynamic> timetableMap = json.decode(contents);
    return timetableMap;
  } catch (e) {
    // If we encounter an error, return 0
  }
}

Future<File> get _localSettings async {
  final path = await _localFolder;
  return new File('$path/settings.json');
}

Future<File> saveSettings(String settingsString) async {
  final file = await _localSettings;

  // Write the file
  return file.writeAsString(settingsString);
}

Future<Map<String, dynamic>> readSettings() async {
  try {
    final file = await _localSettings;
    // Read the file
    String contents = await file.readAsString();

    Map<String, dynamic> settingsMap = json.decode(contents);
    return settingsMap;
  } catch (e) {
    return new Map();
    // If we encounter an error, return 0
  }
}