import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:cat_api/src/common/mixins/status_bar_handler.dart';
import 'package:cat_api/src/core/bloc/bloc.dart';
import 'package:cat_api/src/core/model/cat.dart';
import 'package:cat_api/src/core/database/local_repository.dart';
import 'package:rxdart/rxdart.dart';

class FavouriteBloc extends BaseBloc with StatusBarHandler {
  final LocalRepository _localRepository;
  final _favourites = BehaviorSubject<List<Cat>>();

  Stream<List<Cat>> get favourites => _favourites.stream;

  FavouriteBloc(this._localRepository) {
    fetch();
    changeStatusBarStyle(Colors.white, StatusBarStyle.DARK_CONTENT);
  }

  fetch() async {
    List<Cat> cats = await _localRepository.fetchFavourites();
    _favourites.sink.add(cats);
  }

  @override
  dispose() async {
    await _favourites.drain();
    _favourites.close();
  }
}
