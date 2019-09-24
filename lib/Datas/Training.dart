class Training {
  String id;
  String name;

  Training(this.id, this.name);

  Training.fromJson(Map json) {

  this.id=json["TrainingList"][0]["Id"].toString();
  this.name=json["TrainingList"][0]["Description"];
  }
}
