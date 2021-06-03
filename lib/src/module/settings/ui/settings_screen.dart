import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_api/src/core/bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Center(
      child: StreamBuilder<User?>(
          stream: authBloc.currentUser,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(snapshot.data!.displayName.toString(),
                    style: TextStyle(fontSize: 35.0)),
                SizedBox(height: 20.0),
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(snapshot.data!.photoURL
                      .toString()
                      .replaceFirst('s96', 's400')),
                  radius: 60.0,
                ),
                SizedBox(height: 20.0),
                Text(
                  snapshot.data!.email.toString(),
                  style: TextStyle(fontSize: 30.0),
                ),
                SizedBox(height: 100.0),
                SignInButtonBuilder(
                  text: 'Sign Out',
                  icon: Icons.logout,
                  onPressed: () => authBloc.logout(),
                  backgroundColor: Colors.blueGrey[700]!,
                )
              ],
            );
          }),
    );
  }
}
