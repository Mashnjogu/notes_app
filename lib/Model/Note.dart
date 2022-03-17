import 'dart:convert';

import 'package:flutter/widgets.dart';

class Note {
  int id;
  String title;
  String content;
  DateTime date_created;
  DateTime date_last_edited;
  Color note_color;
  int is_archived = 0;

  Note(this.id, this.title, this.content, this.date_created,
      this.date_last_edited, this.note_color);

  Map<String, dynamic> toMap(bool forUpdate) {
    var data = {
      //'id': id,  since id is auto incremented in the database we don't need to send it to the insert query.
      'title': utf8.encode(title),
      'content': utf8.encode(content),
      'date_created': epochFromDate(date_created),
      'date_last_edited': epochFromDate(date_last_edited),
      'note_color': note_color.value,
      'is_archived': is_archived
    };

    if (forUpdate) {
      data['id'] = this.id;
    }
    return data;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = utf8.decode(map['title']);
    this.content = utf8.decode(map['content']);
    this.date_created = map['date_created'];
    this.date_last_edited = map['date_last_edited'];
    this.note_color = map['note_color'];
    this.is_archived = map['is_archived'];
  }

  int epochFromDate(DateTime date_created) {
    return date_created.millisecondsSinceEpoch ~/ 1000;
  }

  void archiveThisNote() {
    is_archived = 1;
  }
}
