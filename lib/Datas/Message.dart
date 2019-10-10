class Message {
    int id;
  bool seen;
  DateTime date;
  String senderName;
  String text;
  String subject;

  Message.fromJson(Map json) {
    this.id = json["PersonMessageId"];
    this.seen = !json["IsNew"];
    String sendDate = json["SendDate"];
    String ms = sendDate.substring(6,19);
    this.date = DateTime.fromMillisecondsSinceEpoch(int.parse(ms),isUtc:true);
    this.senderName = json["Name"];
    this.text = json["Detail"];
    this.subject = json["Subject"];


  }
}