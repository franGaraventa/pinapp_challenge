import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pinapp_challenge/features/home/data/datasources/local/favorites_local_datasource_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late FavoritesLocalDatasourceImpl datasource;
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    datasource = FavoritesLocalDatasourceImpl(preferences: sharedPreferences);
  });

  group('FavoritesLocalDatasourceImpl Tests', () {
    test('getFavorites should return empty set when no favorites are stored', () async {
      when(sharedPreferences.getStringList('favorites')).thenReturn(null);
      final result = await datasource.getFavorites();
      expect(result, <int>{});
    });

    test('getFavorites should return stored favorites', () async {
      when(sharedPreferences.getStringList('favorites')).thenReturn(['1', '2', '3']);
      final result = await datasource.getFavorites();
      expect(result, {1, 2, 3});
    });

    test('isFavorite should return true if favorite exists', () async {
      when(sharedPreferences.getStringList('favorites')).thenReturn(['1', '2', '3']);
      final result = await datasource.isFavorite(id: 2);
      expect(result, true);
    });

    test('isFavorite should return false if favorite does not exist', () async {
      when(sharedPreferences.getStringList('favorites')).thenReturn(['1', '3']);
      final result = await datasource.isFavorite(id: 2);
      expect(result, false);
    });
  });
}
