import '../../../domain/repositories/i_favorite_repository.dart';
import '../i_favorite_datasource.dart';

class FavoriteRepositoryImpl implements IFavoriteRepository {
  FavoriteRepositoryImpl({required this.favoriteDatasource});

  final IFavoriteDatasource favoriteDatasource;

  @override
  Future<void> add({required int id}) async {
    await favoriteDatasource.add(id: id);
  }

  @override
  Future<bool> isFavorite({required int id}) async {
    return await favoriteDatasource.isFavorite(id: id);
  }

  @override
  Future<void> remove({required int id}) async {
    await favoriteDatasource.remove(id: id);
  }

  @override
  Future<Set<int>> getFavorites() async {
    return await favoriteDatasource.getFavorites();
  }
}
