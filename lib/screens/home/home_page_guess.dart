import 'package:cat_api/bloc/auth_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<AuthBloc>(context);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInButton(
                Buttons.Facebook,
                onPressed: () {
                  _bloc.add(FacebookLoginEvent());
                },
              ),
              SignInButton(
                Buttons.Google,
                onPressed: () {
                  _bloc.add(GoogleLoginEvent());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
