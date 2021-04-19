import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/utils/database_helper.dart';
import 'dart:async';
import 'dart:ui';

class NoteDetail extends StatefulWidget {
  final String appTitle;
  final Note note;
  NoteDetail(this.note, this.appTitle);
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  //Variable Declaration
  var _formkey = GlobalKey<FormState>();
  String appTitle;
  Note note;
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();
  var _priorities = ['High', 'Low'];
  String _currentItem = 'Low';

  DatabaseHelper helper = DatabaseHelper();

  NoteDetailState(this.note, this.appTitle);
  @override
  Widget build(BuildContext context) {
    TextStyle textstyle = Theme.of(context).textTheme.subhead;

    titlecontroller.text = note.title;
    desccontroller.text = note.desc;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Form(
            key: _formkey,
            child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                //First Element
                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String dropDownStringItem) {
                      return DropdownMenuItem(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem));
                    }).toList(),
                    style: textstyle,
                    value: getPriorityAsString(note.priority),
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User Selected $valueSelectedByUser');
                        updatepriorityAsInt(valueSelectedByUser);
                      });
                    },
                  ),
                ),
                //Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: titlecontroller,
                    style: textstyle,
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return 'Please Enter Title of Note';
                      }
                    },
                    onChanged: (value) {
                      debugPrint('title field changed');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textstyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                //Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: desccontroller,
                    style: textstyle,
                    validator: (String value){
                      if(value.isEmpty)
                      {
                        return "Please Enter Description of Note ";
                      }
                    },
                    onChanged: (value) {
                      debugPrint('desc field changed');
                      updateDesc();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textstyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                //Fourth Element
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text(
                                  'Save',
                                  textScaleFactor: 1.5,
                                ),
                                onPressed: () {
                                  setState(() {
                                    debugPrint('Save pressed');
                                    if(_formkey.currentState.validate()){
                                      _save();
                                    }
                                  });
                                })),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                            child: RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text(
                                  'Delete',
                                  textScaleFactor: 1.5,
                                ),
                                onPressed: () {
                                  setState(() {
                                    debugPrint('Delete pressed');
                                    _delete();
                                  });
                                }))
                      ],
                    )),
              ],
            ),
          )),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

//Convert String priority into int before saving into DB
  void updatepriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }
  //convert int priority into String to display in DropDown

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  //Update title of Note Object
  void updateTitle() {
    note.title = titlecontroller.text;
  }

  void updateDesc() {
    note.desc = desccontroller.text;
  }

  //to save data into database
  void _save() async {
    moveToLastScreen();
    int res;
    note.date = DateFormat.yMMMd().format(DateTime.now());
    if (note.id != null) {
      //update operation
      res = await helper.updateNote(note);
    } else {
      //insert Note
      res = await helper.insertNote(note);
    }
    if (res != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note ');
    }
  }

  void _showAlertDialog(String title, String msg) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  //to delete Note
  void _delete() async {
    moveToLastScreen();
    //check if user is creating Note
    if (note.id == null) {
      _showAlertDialog("Status", 'First Create Note');
      return;
    }
    int res = await helper.deleteNote(note.id);
    if (res != 0) {
      _showAlertDialog("Status", 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }
}
