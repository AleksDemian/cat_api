import 'package:cat_api/src/core/model/cat.dart';
import 'package:cat_api/src/core/network/api_provider.dart';

class RemoteRepository {

  final ApiProvider _apiProvider;

  RemoteRepository(this._apiProvider);

  Future<List<Cat>> search(int limit, int page, String mimeType) async => _apiProvider.search(limit, page, mimeType);
}