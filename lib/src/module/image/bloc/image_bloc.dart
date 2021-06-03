import 'package:cat_api/src/common/mixins/status_bar_handler.dart';
import 'package:cat_api/src/core/bloc/bloc.dart';
import 'package:cat_api/src/core/database/local_repository.dart';
import 'package:cat_api/src/core/model/cat.dart';
import 'package:cat_api/src/core/network/cat_fact_provider.dart';
import 'package:rxdart/rxdart.dart';


class ImageBloc extends BaseBloc with StatusBarHandler {
  final LocalRepository _localRepository;
  final Cat _cat;
  final _imageState = BehaviorSubject<ImageState>();

  Stream<ImageState> get imageState => _imageState.stream;

  ImageBloc(this._localRepository, this._cat) {
    _init(_cat.id);
  }

  @override
  dispose() async {
    await _imageState.drain();
    _imageState.close();
  }

  changeFavouriteStatus(Cat cat, bool favourite) async {
    final ImageState currentState = await imageState.first;
    if (favourite) {
      await _localRepository. insertFavourite(cat.toMap());
    } else {
      await _localRepository.deleteFavourite(cat.id);
    }
    _imageState.sink.add(currentState.copyWith(
      favourite: favourite,
      showSnackBar: false,
    ));
  }

  _init(String id) async {
    final result = await _localRepository.hasFavourite(id);
    _imageState.sink.add(ImageState(
      favourite: result,
    ));
  }
}

class ImageState {
  final bool favourite;
  final bool showSnackBar;
  final String imagePath;

  ImageState({
    this.favourite = false,
    this.showSnackBar = false,
    this.imagePath = "",
  });

  ImageState.initial()
      : favourite = false,
        showSnackBar = false,
        imagePath = "";

  copyWith(
          {bool? favourite,
          bool? showSnackBar,
            String? fact,
          String? imagePath}) =>
      ImageState(
        favourite: favourite ?? this.favourite,
        showSnackBar: showSnackBar ?? this.showSnackBar,
        imagePath: imagePath ?? this.imagePath,
      );

  @override
  String toString() {
    return 'ImageState{favourite: $favourite, showSnackBar: $showSnackBar, imagePath: $imagePath}';
  }
}
