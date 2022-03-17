import 'package:flutter/material.dart';
import 'package:notes_app/Model/Utility.dart';
import 'package:notes_app/views/ColorSlider.dart';

enum moreOptions { share, delete, copy }

class MoreOptionSheet extends StatefulWidget {
  final Color color;
  final DateTime date_last_edited;

  final void Function(Color) callbackColorTapped;
  final void Function(moreOptions) callBackOptionTapped;

  const MoreOptionSheet(
      {@required this.color,
      @required this.date_last_edited,
      @required this.callbackColorTapped,
      @required this.callBackOptionTapped});

  @override
  _MoreOptionSheetState createState() => _MoreOptionSheetState();
}

class _MoreOptionSheetState extends State<MoreOptionSheet> {
  var note_color;

  @override
  void initState() {
    super.initState();
    note_color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: note_color,
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.delete),
            title: Text("Delete Permanently"),
            onTap: () {
              Navigator.of(context).pop();
              widget.callBackOptionTapped(moreOptions.delete);
            },
          ),
          ListTile(
            leading: Icon(Icons.content_copy),
            title: Text("Duplicate"),
            onTap: () {
              Navigator.of(context).pop();
              widget.callBackOptionTapped(moreOptions.copy);
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text("Share"),
            onTap: () {
              Navigator.of(context).pop();
              widget.callBackOptionTapped(moreOptions.share);
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              height: 44,
              width: MediaQuery.of(context).size.width,
              child: ColorSlider(
                  callBackColorTapped: _changeColor, noteColor: note_color),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 44,
                child: Center(
                  child: Text(CentralStation.stringForDatetime(
                      widget.date_last_edited)),
                ),
              )
            ],
          ),
          ListTile()
        ],
      ),
    );
  }

  void _changeColor(Color color) {
    setState(() {
      this.note_color = color;
      widget.callbackColorTapped(color);
    });
  }
}
