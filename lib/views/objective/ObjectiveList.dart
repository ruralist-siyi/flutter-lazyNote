import 'package:flutter/material.dart';

class ObjectiveListWidget extends StatefulWidget {
  @override
  _ObjectiveListState createState() => _ObjectiveListState();
}

class _ObjectiveListState extends State<ObjectiveListWidget> {
  
  @override
  void initState() {
    print('objectiveList render');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
        children: [
          Text('objectiveList')
        ]
    );
  }
}