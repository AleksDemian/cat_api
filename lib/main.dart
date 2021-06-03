import 'package:cat_api/src/core/bloc/app_bloc.dart';
import 'package:cat_api/src/core/bloc/auth_bloc.dart';
import 'package:cat_api/src/core/bloc/bloc.dart';
import 'package:cat_api/src/core/preferences/preferences_repository.dart';
import 'package:cat_api/src/module/settings/ui/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';
import 'package:cat_api/src/core/di/injector.dart';
import 'package:cat_api/src/common/enum/connectivity_status.dart';
import 'package:cat_api/src/common/services/connectivity_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  inject();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppBloc _bloc =
  AppBloc(KiwiContainer().resolve<PreferencesRepository>());

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBloc(),
      child: MultiProvider(
        providers: [
          StreamProvider<ConnectivityStatus>(
              create: (context) =>  ConnectivityService().connectionStatusController.stream,
              initialData: ConnectivityStatus.values.last
          ),

        ],
        child: BlocProvider<AppBloc>(
          bloc: _bloc,
          child: MaterialApp(
            title: 'Flutter Login CatApi',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Raleway',
            ),
            home: LoginScreen(),
          ),
        ),
      ),
    );
  }
}


