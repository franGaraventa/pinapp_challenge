import 'package:shared_preferences/shared_preferences.dart';

import '../../repositories/i_favorite_datasource.dart';

class FavoritesLocalDatasourceImpl implements IFavoriteDatasource {
  @override
  Future<Set<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites');
    if (favorites == null) return {};
    return favorites.map((id) => int.parse(id)).toSet();
  }

  @override
  Future<void> add({required int id}) async {
    final prefs = await SharedPreferences.getInstance();
    Set<int> favorites = await getFavorites();
    favorites.add(id);
    await prefs.setStringList('favorites', favorites.map((e) => e.toString()).toList());
  }

  @override
  Future<bool> isFavorite({required int id}) async {
    Set<int> favorites = await getFavorites();
    return favorites.contains(id);
  }

  @override
  Future<void> remove({required int id}) async {
    final prefs = await SharedPreferences.getInstance();
    Set<int> favorites = await getFavorites();
    favorites.remove(id);
    await prefs.setStringList('favorites', favorites.map((e) => e.toString()).toList());
  }
}
