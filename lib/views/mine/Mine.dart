import 'package:flutter/material.dart';

class MineWidget extends StatefulWidget {
  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<MineWidget> {

  @override
  void initState() {
    print('Mine render');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
        children: [
          Text('Mine')
        ]
    );
  }
}