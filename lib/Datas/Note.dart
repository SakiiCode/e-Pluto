import 'User.dart';

class Note {
  int id;
  String type;
  String title;
  String content;
  String teacher;
  DateTime date;
  String creationDate;
  bool isEvent = false;
  User owner;

  Note(this.id, this.type, this.title, this.content, this.teacher, this.date,
      this.creationDate);

  Note.fromJson(Map json) {
    /*if (json["EventId"] != null) {
      this.id = json["EventId"];
      isEvent = true;
    } else*/
    this.id = json["Id"];
    String sendDate = json["SendDate"];
    String ms = sendDate.substring(6,19);
    this.date = DateTime.fromMillisecondsSinceEpoch(int.parse(ms),isUtc:true);
    this.content = json["Detail"];
    this.title = json["Subject"];
    this.teacher = json["Name"];
    this.type = json["IsNew"].toString();
  }
}
