import 'package:flutter/material.dart';
import 'package:notes_app/Model/Note.dart';
import 'package:notes_app/Model/Utility.dart';
import 'package:notes_app/viewController/StaggeredView.dart';
import 'package:notes_app/viewController/gh.dart';

enum viewType { List, Staggered }

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notesViewType;

  @override
  void initState() {
    // TODO: implement initState
    notesViewType = viewType.Staggered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: _appBarActions(),
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Notes"),
      ),
      body: SafeArea(
          child: _body(), right: true, left: true, top: true, bottom: true),
      bottomSheet: _bottomBar(),
    );
  }

  List<Widget> _appBarActions() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
          child: GestureDetector(
            onTap: () => _toggleViewType(),
            child: Icon(
              notesViewType == viewType.List
                  ? Icons.developer_board
                  : Icons.view_headline,
              color: CentralStation.fontColor,
            ),
          ),
        ),
      )
    ];
  }

  void _toggleViewType() {
    setState(() {
      CentralStation.updateNeeded = true;
      if (notesViewType == viewType.List) {
        notesViewType = viewType.Staggered;
      } else {
        notesViewType = viewType.List;
      }
    });
  }

  Widget _body() {
    return Container(
      child: StaggeredGridPage(
        notesViewType: notesViewType,
      ),
    );
  }

  Widget _bottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton(
          onPressed: () => _newNoteTapped(context),
          child: Text("New Note",
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  void _newNoteTapped(BuildContext context) {
    //-1 indicates that the note is not new
    var emptyNote =
        Note(-1, "", "", DateTime.now(), DateTime.now(), Colors.white);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NotePage(emptyNote);
    }));
  }
}
