import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:cat_api/src/common/widget/ripple_grid.dart';
import 'package:cat_api/src/core/database/local_repository.dart';
import 'package:cat_api/src/core/model/cat.dart';
import 'package:cat_api/src/module/favourite/bloc/favourite_bloc.dart';
import 'package:cat_api/src/module/image/ui/image_screen.dart';
import 'package:kiwi/kiwi.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final _bloc = FavouriteBloc(KiwiContainer().resolve<LocalRepository>());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 3;

    return StreamBuilder<List<Cat>>(
      stream: _bloc.favourites,
      initialData: List<Cat>.empty(),
      builder: (BuildContext context, AsyncSnapshot<List<Cat>> snapshot) {
        return GridView.count(
          crossAxisCount: 3,
          physics: AlwaysScrollableScrollPhysics(),
          children: List.generate(snapshot.data!.length, (index) {
            return RippleGrid((CachedNetworkImageProvider imageProvider) async {
              _bloc.changeStatusBarStyle(
                  Colors.black, StatusBarStyle.LIGHT_CONTENT);

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Scaffold(body: ImageScreen(snapshot.data![index], imageProvider)),
                ),
              );

              _bloc.fetch();
              _bloc.changeStatusBarStyle(
                  Colors.white, StatusBarStyle.DARK_CONTENT);
            }, size, snapshot.data![index].url);
          }),
        );
      },
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
