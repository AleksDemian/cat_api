import 'package:cat_api/src/core/database/database_provider.dart';
import 'package:cat_api/src/core/database/local_repository.dart';
import 'package:cat_api/src/core/network/api_client.dart';
import 'package:cat_api/src/core/network/api_provider.dart';
import 'package:cat_api/src/core/network/remote_repository.dart';
import 'package:kiwi/kiwi.dart';
import 'package:cat_api/src/core/preferences/preferences_repository.dart';
import 'package:http/http.dart' as http;

part 'injector.g.dart';

abstract class Injector {

  // database
  @Register.singleton(DatabaseProvider)
  @Register.singleton(LocalRepository)
  // network
  @Register.singleton(ApiClient)
  @Register.singleton(ApiProvider)
  @Register.singleton(RemoteRepository)
  @Register.singleton(PreferencesRepository)


  void configure();
}

void inject() {
  var injector = _$Injector();
  injector.configure();
}