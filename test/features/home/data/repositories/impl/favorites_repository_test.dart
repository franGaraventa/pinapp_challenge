import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pinapp_challenge/features/home/data/repositories/i_favorite_datasource.dart';
import 'package:pinapp_challenge/features/home/data/repositories/impl/favorite_repository_impl.dart';
import 'package:pinapp_challenge/features/home/domain/repositories/i_favorite_repository.dart';

import 'favorites_repository_test.mocks.dart';

@GenerateMocks([IFavoriteDatasource])
void main() {
  late IFavoriteRepository repository;
  late MockIFavoriteDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockIFavoriteDatasource();
    repository = FavoriteRepositoryImpl(favoriteDatasource: mockDatasource);
  });

  group('FavoriteRepositoryImpl Tests', () {
    test('add method should call datasource.add', () async {
      await repository.add(id: 1);
      verify(mockDatasource.add(id: 1)).called(1);
    });

    test('isFavorite should call datasource.isFavorite and return the result', () async {
      when(mockDatasource.isFavorite(id: 1)).thenAnswer((_) async => true);
      final result = await repository.isFavorite(id: 1);
      expect(result, true);
      verify(mockDatasource.isFavorite(id: 1)).called(1);
    });

    test('remove method should call datasource.remove', () async {
      await repository.remove(id: 1);
      verify(mockDatasource.remove(id: 1)).called(1);
    });

    test('getFavorites should call datasource.getFavorites and return the result', () async {
      when(mockDatasource.getFavorites()).thenAnswer((_) async => {1, 2, 3});
      final result = await repository.getFavorites();
      expect(result, {1, 2, 3});
      verify(mockDatasource.getFavorites()).called(1);
    });
  });
}
