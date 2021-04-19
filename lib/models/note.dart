import 'package:flutter/scheduler.dart';


class Note {
  int _id, _priority;
  String _title, _desc, _date;
  Note(this._title, this._date, this._priority, [this._desc]);
  Note.withId(this._id, this._title, this._date, this._priority, [this._desc]);

  //getter methods
  int get id => _id;
  int get priority => _priority;
  String get title => _title;
  String get date => _date;
  String get desc => _desc;

  //setter methos
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set desc(String newdesc) {
    if (newdesc.length <= 255) {
      this._desc = newdesc;
    }
  }

  set date(String newDate) {
    if (newDate.length <= 255) {
      this._date = newDate;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  //Convert Note into Map Object

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['desc'] = _desc;
    map['date'] = _date;
    map['priority'] = _priority;

    return map;
  }

  //convert Map object into Note
  Note.fromMapObject(Map<String,dynamic> map)
  {
    this._id = map['id'];
    this._priority = map['priority'];
    this._date = map['date'];
    this._title = map['title'];
    this._desc = map['desc'];
  }
}
