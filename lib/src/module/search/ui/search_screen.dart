import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_api/src/core/database/local_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:cat_api/src/common/widget/platform_loading.dart';
import 'package:cat_api/src/core/bloc/bloc.dart';
import 'package:cat_api/src/core/model/cat.dart';
import 'package:cat_api/src/core/network/remote_repository.dart';

import 'package:cat_api/src/module/image/ui/image_screen.dart';
import 'package:cat_api/src/module/search/bloc/search_bloc.dart';
import 'package:cat_api/src/common/widget/ripple_grid.dart';

import 'package:kiwi/kiwi.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchBloc _bloc =
      SearchBloc(KiwiContainer().resolve<RemoteRepository>(), KiwiContainer().resolve<LocalRepository>());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 3;

    return RefreshIndicator(
      child: StreamBuilder<SearchScreenState>(
        stream: _bloc.searchResult,
        initialData: SearchScreenState.initial(),
        builder:
            (BuildContext context, AsyncSnapshot<SearchScreenState> snapshot) {
              if (!snapshot.data!.init) {
                return PlatformLoading();
              } else {
                return createGridView(size, snapshot.data!.results);
              }
            }
      ),
      displacement: 50,
      onRefresh: () => _bloc.search(),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Widget createGridView(double size, List<Cat> cats) => GridView.count(
      crossAxisCount: 3,
      physics: AlwaysScrollableScrollPhysics(),
      children: List.generate(cats.length, (index) {
        return RippleGrid((CachedNetworkImageProvider cachedNetworkImageProvider) async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                  body: ImageScreen(cats[index], cachedNetworkImageProvider, )),
            ),
          );

          _bloc.changeStatusBarStyle(
              Colors.white, StatusBarStyle.DARK_CONTENT);
        }, size, cats[index].url);
      }),
    );
}
