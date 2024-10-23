import 'package:flutter/material.dart';

// 앱 시작 
void main() {
  runApp(MyApp());
}

// StatefulWidget 사용, 상태를 가짐
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  // 다크 모드 토글하는 함수
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 테마를 다크 모드 상태에 따라서 변경
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: MainPage(onToggleDarkMode: _toggleDarkMode, isDarkMode: _isDarkMode),
    );
  }
}

// 메인페이지 위젯 생성
class MainPage extends StatefulWidget {
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  MainPage({required this.onToggleDarkMode, required this.isDarkMode});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static List<String> _titles = <String>['쇼핑', '홈', '콘텐츠', '클립'];
  static List<Widget> _widgetOptions = <Widget>[
    ShoppingScreen(),
    HomeScreen(),
    ContentScreen(),
    ClipScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('NAVER'),
            SizedBox(width: 10),
            Text(_titles[_selectedIndex], style: TextStyle(fontSize: 18)),
          ],
        ),
        backgroundColor: Colors.green,
        actions: [
          if (_selectedIndex == 1) 
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      onToggleDarkMode: widget.onToggleDarkMode,
                      isDarkMode: widget.isDarkMode,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: '쇼핑'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: '콘텐츠'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: '클립'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
// 홈 화면 위젯 
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('검색', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          Text('날씨', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
// 쇼핑 화면 위젯 
class ShoppingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('배송 정보', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          Text('쇼핑 추천 목록', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
// 콘텐츠 화면 위젯 
class ContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('뉴스', style: TextStyle(fontSize: 24)),
    );
  }
}
// 클립 화면 위젯
class ClipScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('영상', style: TextStyle(fontSize: 24)),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  SettingsPage({required this.onToggleDarkMode, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('다크 모드 설정'),
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                onToggleDarkMode(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
