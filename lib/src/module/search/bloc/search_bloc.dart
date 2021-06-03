import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:cat_api/src/common/mixins/status_bar_handler.dart';
import 'package:cat_api/src/core/bloc/bloc.dart';
import 'package:cat_api/src/core/model/cat.dart';
import 'package:cat_api/src/core/network/remote_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cat_api/src/core/database/local_repository.dart';


class SearchBloc extends BaseBloc with StatusBarHandler {
  final LocalRepository _localRepository;
  final _search = BehaviorSubject<List<Cat>>();

  final RemoteRepository _remoteRepository;
  final _searchResult = BehaviorSubject<SearchScreenState>();

  Stream<List<Cat>> get favourites => _search.stream;

  Stream<SearchScreenState> get searchResult => _searchResult.stream;

  SearchBloc(this._remoteRepository, this._localRepository) {
    fetch();

    search();

    changeStatusBarStyle(Colors.white, StatusBarStyle.DARK_CONTENT);
  }

  fetch() async {
    List<Cat> cats = await _localRepository.fetchSearch();
    _search.sink.add(cats);
  }

  search() async {
    final cats = await _remoteRepository.search(21, 1, "image/png");
    _searchResult.sink.add(SearchScreenState(true, cats));
  }

  dispose() async {
    await _searchResult.drain();
    _searchResult.close();
    await _search.drain();
    _search.close();
  }
}

class SearchScreenState {
  final bool init;
  final List<Cat> results;

  SearchScreenState(this.init, this.results);

  SearchScreenState.initial()
      : init = false,
        results = List<Cat>.empty();
}
