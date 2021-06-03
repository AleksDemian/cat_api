import 'package:cat_api/src/common/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignin = GoogleSignIn(scopes: ['email']);
  final fb = FacebookLogin();

  Stream<User?> get currentUser => authService.currentUser;

  loginGoogle() async {
    try{
      final GoogleSignInAccount? googleUser = await googleSignin.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
      );

      //FireBase Sign in
      final result = await authService.signInWithCredential(credential);

      print('${result.user!.displayName}');

    } catch(error) {
      print(error);
    }
  }

  loginFacebook() async {
    print('Starting Facebook Login');

    final res = await fb.logIn(
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email
      ]
    );



    switch(res.status){
      case FacebookLoginStatus.success:
        print('It worked');

        //Get token
        final FacebookAccessToken? fbToken = res.accessToken;

        //Convert to Auth Credential
        final AuthCredential credential = FacebookAuthProvider.credential(fbToken!.token);

        //User Credential to Sign in with Firebase
        final result = await authService.signInWithCredential(credential);

        print('${result.user!.displayName} is now logged in');

        String photoUrl = result.user!.photoURL! + "?height=500&access_token=" + fbToken.token;
        result.user!.updateProfile(photoURL: photoUrl);

        break;
      case FacebookLoginStatus.cancel:
        print('The user cancel  the login');
        break;
      case FacebookLoginStatus.error:
        print('There was an error');
        break;
    }

  }

  logout() {
    authService.logout();
  }
}