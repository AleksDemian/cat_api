import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_api/src/core/network/cat_fact_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:cat_api/src/core/database/local_repository.dart';
import 'package:cat_api/src/core/model/cat.dart';
import 'package:cat_api/src/module/image/bloc/image_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatefulWidget {
  final Cat cat;
  final CachedNetworkImageProvider imageProvider;

  ImageScreen(this.cat, this.imageProvider, {Key? key}) : super(key: key);

  @override
  _ImageScreenState createState() => _ImageScreenState(
      ImageBloc(KiwiContainer().resolve<LocalRepository>(), cat));
}

class _ImageScreenState extends State<ImageScreen> {
  final ImageBloc _bloc;

  _ImageScreenState(this._bloc);

  @override
  Widget build(BuildContext context) {
    _bloc.changeStatusBarStyle(Colors.black, StatusBarStyle.LIGHT_CONTENT);
    return StreamBuilder<ImageState>(
      stream: _bloc.imageState,
      initialData: ImageState.initial(),
      builder: (BuildContext context, AsyncSnapshot<ImageState> snapshot) {
        print("[DEBUG] _ImageScreen ${snapshot.data}");


        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                _buildPhotoView(context),
                _buildAppBar(context, _bloc),
                _getCatFact(),
                _buildBottomFavourite(_bloc, snapshot.data!.favourite),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Widget _buildPhotoView(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PhotoView(
            // CachedNetworkImageProvider(_cat.url),
            minScale: PhotoViewComputedScale.contained,
            imageProvider: widget.imageProvider,
            maxScale: 2.0,
            heroAttributes: PhotoViewHeroAttributes(tag: widget.cat.url),
          ),
        ],
      );

  Widget _buildAppBar(BuildContext context, ImageBloc bloc) => Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.dark,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, "OK"),
          ),
        ),
      );

  Widget _getCatFact() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 10.0),
    child: Container(
      alignment: Alignment.bottomCenter,
      child: FutureBuilder<String>(
        future: CatFactProvider.getCatFact(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
            Text(snapshot.data ?? '',
            style: TextStyle(color: Colors.white, fontSize: 18),
            ),
      ),
    ),
  );

  Widget _buildBottomFavourite(ImageBloc bloc, bool favourite) => Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            icon: Icon(
              (favourite) ? Icons.favorite : Icons.favorite_border,
              color: (favourite) ? Colors.red : Colors.white,
            ),
            onPressed: () => bloc.changeFavouriteStatus(widget.cat, !favourite),
          ),
        ),
      );
}