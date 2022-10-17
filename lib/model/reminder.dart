class Reminder {
  int? id;
  String? event;
  String? desc;
  String? date;
  String? time;
  String? location;

  Reminder(
      {this.id, this.event, this.desc, this.date, this.time, this.location});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }
    map['event'] = event;
    map['desc'] = desc;
    map['date'] = date;
    map['time'] = time;
    map['location'] = location;

    return map;
  }

  Reminder.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.event = map['event'];
    this.desc = map['desc'];
    this.date = map['date'];
    this.time = map['time'];
    this.location = map['location'];
  }
}
