import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/home/home.dart';
import 'package:flutter_application_1/src/pages/profile/profile.dart';
import 'package:flutter_application_1/src/pages/chat/chat.dart';

class NavigatorPage extends StatefulWidget {

  final String? userId;
  final String? displayName;
  final String? imageUrl;

  const NavigatorPage({Key? key, this.userId, this.displayName, this.imageUrl})
      : super(key: key);
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    Page2(),
    Page3(),
    ChatSelectionPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        showSelectedLabels: true, // Show labels for all icons
        selectedItemColor: Colors.lightGreen, // Color for selected icon
        unselectedItemColor: Colors.grey, // Color for unselected icons

      ),
    );
  }
}


class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page 2'),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page 3'),
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page 4'),
    );
  }
}

