import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './views/login/Login.dart';
import './views/mine/Mine.dart';
import './views/objective/ObjectiveList.dart';
import './views/register/Register.dart';
import 'models/index.dart';
import 'providerModels/index.dart';
import 'utils/HttpUtil.dart';

void main() async {
  final userInfo = UserProviderModel();
  final globalInfo = GlobalProviderModel();
  final objectiveListInfo = ObjectiveProviderModel();
  WidgetsFlutterBinding.ensureInitialized();
  // 强制竖屏
  // If you're running an application and need to access the binary messenger before `runApp()` has been called (for example, during plugin initialization), then you need to explicitly call the `WidgetsFlutterBinding.ensureInitialized()` first.
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<UserProviderModel>.value(value: userInfo),
      ChangeNotifierProvider<GlobalProviderModel>.value(value: globalInfo),
      ChangeNotifierProvider<ObjectiveProviderModel>.value(
          value: objectiveListInfo)
    ], child: MyApp()));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        // 沉浸式透明
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        // 该属性仅用于 iOS 设备顶部状态栏亮度
        statusBarBrightness: Brightness.light,
        // 底部导航的设置
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.grey,
        systemNavigationBarIconBrightness: Brightness.dark));
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: MaterialApp(
        title: '懒得记',
        theme: ThemeData(
          primarySwatch: Colors.blue,
//        platform: TargetPlatform.iOS
        ),
        home: MyHomePage(title: '懒得记'),
        routes: {
          '/login': (context) => LoginWidget(),
          '/register': (context) => RegisterWidget()
        },
      ),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserDetail();
  }

  // 请求用户详情数据
  fetchUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get('token');
    if (token != null && prefs.get('userInfo') != null) {
      final userInfo = json.decode(prefs.get('userInfo'));
      UserInfoModel prefsUserInfo = UserInfoModel.fromJson(userInfo);
      var userId = prefsUserInfo.userId;
      Map<String, dynamic> params = {'userId': userId};
      var res = await Http.getInstance().get('/user/queryDetail', data: params);
      var result = UserInfoModel.fromJson(res);
      Provider.of<UserProviderModel>(context, listen: false).setUserData(
          userName: result.userName,
          userId: result.userId,
          phone: result.phone,
          email: result.email);
    }
  }

  void _addObjective() {}

  void _onNavClick(int index) {
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
//          brightness: Brightness.dark,
          // Adaptive: android title is left
          centerTitle: true),
      body: Center(child: _contentItems[_navSelectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.collections_bookmark), title: Text('目标')),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), title: Text('我的')),
          ],
          currentIndex: _navSelectedIndex,
          fixedColor: Colors.blue,
          type: BottomNavigationBarType.fixed,
          onTap: _onNavClick),
      floatingActionButton: FloatingActionButton(
        onPressed: _addObjective,
        tooltip: '新增目标',
        child: Icon(Icons.add),
      ),
    );
  }
}
