import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:ku_auto_grade_check/class/grade-std.dart';

class GradePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _GradePageState();
}

class _GradePageState extends State<GradePage> {
  Map _grade = {'Course Name': 'Grade'};
  GradeStd client = new GradeStd();
  int year = 63;
  int sem = 1;
  final Map<String, int> dropdownValueStringToIntMap = {'First': 1, 'Second': 2, 'Summer': 0};
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Grade Page")),
      body: new Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildYearAndSemInput(),
            new RaisedButton(
                child: new Text(
                  'reset',
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
                onPressed: reset,
                color: Color(0xFFFF0000)),
            _buildGradeList()
          ],
        ),
      ),
    );
  }

  Widget _buildYearAndSemInput() {
    return new Row(
      mainAxisSize: MainAxisSize.min, // see 3
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Year',
                icon: Icon(Icons.date_range),
                contentPadding: EdgeInsets.all(0.0),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                year = int.parse(value);
              },
            ),
            flex: 12),
        Spacer(),
        Flexible(
            child: new DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelText: 'Semester', contentPadding: EdgeInsets.all(0.0)),
              items: <String>['First', 'Second', 'Summer'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (value) {
                  sem = dropdownValueStringToIntMap[value];
              },
            ),
            flex: 8),
      ],
    );
  }

  Future getGrade() async {
    var a = await client.gradeOf(year, sem);
    print("a");
    setState(() {
      _grade.addAll(a);
    });
    ;
  }

  Future<void> reset() {
    setState(() {
      _grade = {'Course Name': 'Grade'};
    });
    getGrade();
  }

  Widget _buildGradeList() {
    if (_grade.length == 0) {
      getGrade();
    }
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _grade.length,
        itemBuilder: (BuildContext context, int index) {
          String key = _grade.keys.elementAt(index);
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: new Text('$key'),
                    flex: 10,
                  ),
                  Spacer(),
                  Expanded(
                      child: Text(
                        _grade[key],
                        textAlign: TextAlign.center,
                      ),
                      flex: 2),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
