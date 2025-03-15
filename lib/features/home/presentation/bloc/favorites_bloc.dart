import 'dart:async';

import '../../../../core/di/i_bloc.dart';
import '../../domain/repositories/i_favorite_repository.dart';

class FavoritesBloc extends IBloc {
  FavoritesBloc(this._favoriteRepository);

  final IFavoriteRepository _favoriteRepository;

  StreamController<bool> favoritesController = StreamController.broadcast();

  Stream<bool> get favoritesStream => favoritesController.stream;

  var favorites = Set<int>();

  Future<void> toggleFavorite({required int id}) async {
    var isFavorite = await _favoriteRepository.isFavorite(id: id);
    if (isFavorite) {
      _favoriteRepository.remove(id: id);
      favorites.remove(id);
      favoritesController.sink.add(false);
    } else {
      _favoriteRepository.add(id: id);
      favorites.add(id);
      favoritesController.sink.add(true);
    }
  }

  Future<bool> isFavorite({required int id}) async {
    var isFavorite = await _favoriteRepository.isFavorite(id: id);
    favoritesController.sink.add(isFavorite);
    return isFavorite;
  }

  @override
  void dispose() {}

  @override
  Future<void> initialize() async {
    favorites.clear();
    favorites.addAll(await _favoriteRepository.getFavorites());
  }
}
