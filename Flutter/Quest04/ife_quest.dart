import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: MainPage(onToggleDarkMode: _toggleDarkMode, isDarkMode: _isDarkMode),
    );
  }
}

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
          if (_selectedIndex == 1) // 홈 페이지일 때만 설정 아이콘 표시
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

class ContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('뉴스', style: TextStyle(fontSize: 24)),
    );
  }
}

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
