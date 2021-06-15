import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_api/bloc/cat_facts/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HeroScreen extends StatelessWidget {
  final String imgUrl;
  final String tag;

  const HeroScreen({Key? key, required this.imgUrl, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
        ),
        body: Center(
          child: Hero(
            tag: tag,
            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              return SingleChildScrollView(
                child: CachedNetworkImage(imageUrl: '$imgUrl',),
              );
            },
            child: Container(
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  CachedNetworkImage(imageUrl: '$imgUrl',),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Facts()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Facts extends StatelessWidget {
  const Facts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<CatFactsBloc, CatFactsState>(
        builder: (context, state) {
          if (state is CatsFactsLoaded) {
            return Column(
              children: state.facts
                  .map(
                    (e) => Text('«$e»',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        )),
                  )
                  .toList(),
            );
          } else {
            return Center(
              child: SpinKitFadingCircle(
                size: 100,
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.blueGrey : Colors.blueGrey[300],
                      borderRadius: BorderRadius.circular(180),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
