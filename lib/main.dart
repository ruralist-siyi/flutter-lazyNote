import 'package:flutter/material.dart';
import './views/objective/ObjectiveList.dart';
import './views/mine/Mine.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '懒得记'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _navSelectedIndex = 0;
  final _contentItems = [ObjectiveListWidget(), MineWidget()];

  void _addObjective() {

  }

  void _onNavClick(int index) {
    print(index);
    setState(() {
      _navSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          child: _contentItems[_navSelectedIndex]
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.collections_bookmark), title: Text('目标')),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text('我的')),
        ],
        currentIndex: _navSelectedIndex,
        fixedColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        onTap: _onNavClick,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addObjective,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
