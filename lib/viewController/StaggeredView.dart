import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/Model/Note.dart';
import 'package:notes_app/Model/SqliteHandler.dart';
import 'package:notes_app/Model/Utility.dart';
import 'package:notes_app/viewController/Home.dart';
import 'package:notes_app/views/StaggeredTiles.dart';

class StaggeredGridPage extends StatefulWidget {
  final notesViewType; // either grid or list
  const StaggeredGridPage({Key key, this.notesViewType}) : super(key: key);

  @override
  _StaggeredGridPageState createState() => _StaggeredGridPageState();
}

class _StaggeredGridPageState extends State<StaggeredGridPage> {
  var noteDb = NoteDbHandler();
  List<Map<String, dynamic>> _allNotesInQuery = [];
  viewType notesViewType;

  @override
  void initState() {
    super.initState();
    this.notesViewType = widget.notesViewType;
  }

  @override
  void setState(fn) {
    super.setState(fn);
    this.notesViewType = widget.notesViewType;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _stagKey = GlobalKey();
    print("update needed?: ${CentralStation.updateNeeded}");

    if (CentralStation.updateNeeded) {
      retrieveAllNotesFromDatabase();
    }
    return Container(
      child: Padding(
          padding: _paddingForView(context),
          child: StaggeredGridView.count(
            crossAxisCount: _colForStaggeredView(context),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            children: List.generate(_allNotesInQuery.length, (index) {
              return _tileGenerator(index);
            }),
            staggeredTiles: _tilesForView(),
          )),
    );
  }

  void retrieveAllNotesFromDatabase() {
    // queries for all the notes from the database ordered by latest edited note. excludes archived notes.
    var _test_Data = noteDb.selectAllNotes();
    _test_Data.then((value) {
      setState(() {
        _allNotesInQuery = value;
        CentralStation.updateNeeded = false;
      });
    });
  }

  EdgeInsets _paddingForView(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding;
    double top_bottom = 8;
    if (width > 500) {
      padding =
          width * 0.05; //5% padding on the width of the screen on both sides
    } else {
      padding = 8;
    }
    return EdgeInsets.only(
        left: padding, right: padding, top: top_bottom, bottom: top_bottom);
  }

  int _colForStaggeredView(BuildContext context) {
    if (widget.notesViewType == viewType.List) {
      return 1;
    } else {
      //for width larger than 600 on grid mode, return 3 irrelevant of the orientation to accomodate more notes horizontally
      return MediaQuery.of(context).size.width > 600 ? 3 : 2;
    }
  }

  MyStaggeredTile _tileGenerator(int index) {
    return MyStaggeredTile(Note(
        _allNotesInQuery[index]["id"],
        _allNotesInQuery[index]["title"] == null
            ? ""
            : utf8.decode(_allNotesInQuery[index]["title"]),
        _allNotesInQuery[index]["content"] == null
            ? ""
            : utf8.decode(_allNotesInQuery[index]["content"]),
        DateTime.fromMillisecondsSinceEpoch(
            _allNotesInQuery[index]["date_created"] * 1000),
        DateTime.fromMillisecondsSinceEpoch(
            _allNotesInQuery[index]["date_last_edited"] * 1000),
        Color(_allNotesInQuery[index]["note_color"])));
  }

  List<StaggeredTile> _tilesForView() {
    // Generate staggered tiles for the view based on the current preference.
    return List.generate(_allNotesInQuery.length, (index) {
      return StaggeredTile.fit(1);
    });
  }
}
