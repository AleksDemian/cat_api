import 'package:cat_api/screens/cats/cats_screen.dart';
import 'package:cat_api/screens/favorites/favorite_cats_page.dart';
import 'package:cat_api/screens/profile.dart/user_profile.dart';
import 'package:flutter/material.dart';

class HomeScreenUser extends StatefulWidget {
  HomeScreenUser({Key? key}) : super(key: key);

  @override
  _HomeScreenUserState createState() => _HomeScreenUserState();
}

class _HomeScreenUserState extends State<HomeScreenUser> {
  int _currentIndex = 0;
  PageController _pageController = PageController();
  List<Widget> _screens = [
    CatsScreen(),
    Favorites(),
    UserProfile(),
  ];
  void _onPageChanged(int index) {}

  void onTapped(int _currentIndex) {
    _pageController.jumpToPage(_currentIndex);
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.blueGrey[100],
          appBar: AppBar(
            centerTitle: true,
            title: Text('Cats Test App'),
            backgroundColor: Colors.blueGrey,
          ),
          body: PageView(
            controller: _pageController,
            children: _screens,
            onPageChanged: _onPageChanged,
          ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.blueGrey,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  onTapped(_currentIndex);
                });
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_a_photo),
                  label: "Cats",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: "Favourite",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Profile",
                ),
              ],
              unselectedItemColor: Colors.blueGrey,
            ),
          ),
      );
}
