import 'dart:async';

import 'package:cat_api/src/core/bloc/auth_bloc.dart';
import 'package:cat_api/src/module/settings/ui/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:cat_api/src/common/widget/platform_indicator.dart';

import 'package:cat_api/src/module/favourite/ui/favourite_screen.dart';
import 'package:cat_api/src/module/main/bloc/main_bloc.dart';
import 'package:cat_api/src/module/search/ui/search_screen.dart';
import 'package:cat_api/src/module/settings/ui/settings_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late StreamSubscription<User?> homeStateSubscription;


  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    homeStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    homeStateSubscription.cancel();
    _bloc.dispose();
    super.dispose();
  }

  final _bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _bloc.selectedIndex,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return PlatformIndicator(
          android: _buildAndroid(context, _bloc, snapshot.data),
          ios: _buildAndroid(context, _bloc, snapshot.data),
        );
      },
    );
  }


  Widget _buildAndroid(BuildContext context, MainBloc bloc, int? data) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        centerTitle: true,
        title: Text(
          "Cat Test Api",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
      body: _buildBody(data!),
      bottomNavigationBar: BottomNavigationBar(
        items: _createNavigationBarItem(context),
        currentIndex: data,
        onTap: (index) => bloc.updateSelectedIndex(index),
      ),
    );
  }

  List<BottomNavigationBarItem> _createNavigationBarItem(BuildContext context) {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.add_a_photo),
        title: Text("Cat Gallery"),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        title: Text("Favourite"),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        title: Text("Profile"),
      ),
    ];
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return SearchScreen();
      case 1:
        return FavouriteScreen();
      default:
        return Profile();
    }
  }
}
