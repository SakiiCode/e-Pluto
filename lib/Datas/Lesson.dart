class Lesson {
  int id;
  int count;
  DateTime date;
  DateTime start;
  DateTime end;
  String subject;
  String subjectName;
  String room;
  String group;
  String teacher;
  String depTeacher;
  String state;
  String stateName;
  String presence;
  String presenceName;
  String theme;
  String homework;
  String calendarOraType;

  static const String MISSED = "Missed";

  Lesson(
      this.id,
      this.count,
      this.date,
      this.start,
      this.end,
      this.subject,
      this.subjectName,
      this.room,
      this.group,
      this.teacher,
      this.depTeacher,
      this.state,
      this.stateName,
      this.presence,
      this.presenceName,
      this.theme,
      this.homework,
      this.calendarOraType);

  bool get isMissed => state == MISSED;
  bool get isSubstitution => depTeacher != "";

  Lesson.fromJson(Map json) {
    id = json["id"];

    date = DateTime.fromMillisecondsSinceEpoch(int.parse(json["start"].substring(6,19)),isUtc:true);
    start = DateTime.fromMillisecondsSinceEpoch(int.parse(json["start"].substring(6,19)),isUtc:true);
    end = DateTime.fromMillisecondsSinceEpoch(int.parse(json["end"].substring(6,19)),isUtc:true);

    count = start.hour~/2-3;

    subject = json["title"].split('(')[0].split(']')[1].trim();
    subjectName = json["SubjectCategoryName"];
    room = json["location"];

    List<String> details = json["title"].split(' ');


    group = details[7];
    teacher = json["title"].split('(')[2].split(')')[0];
    depTeacher = json["DeputyTeacher"];
    state = details[0];
    stateName = details[0];
    presence = json["PresenceType"];
    presenceName = json["PresenceTypeName"];
    theme = json["Theme"];
    homework = json["Homework"];
    calendarOraType = json["CalendarOraType"];

    if (theme == null)
      theme = "";
    if (subject == null)
      subject = "";
    if (subjectName == null)
      subjectName = "";
    if (room == null)
      room = "";
    if (group == null)
      group = "";
    if (teacher == null)
      teacher = "";
    if (depTeacher == null)
      depTeacher = "";
    if (state == null)
      state = "";
    if (stateName == null)
      stateName = "";
    if (presence == null)
      presence = "";
    if (presenceName == null)
      presenceName = "";
    if (homework == null)
      homework = "";
    if (calendarOraType == null)
      calendarOraType = "";
  }
}
