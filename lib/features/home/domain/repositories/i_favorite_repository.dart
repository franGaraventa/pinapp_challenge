abstract class IFavoriteRepository {
  Future<void> add({required int id});

  Future<void> remove({required int id});

  Future<bool> isFavorite({required int id});

  Future<Set<int>> getFavorites();
}
