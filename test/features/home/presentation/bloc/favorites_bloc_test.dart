import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pinapp_challenge/features/home/domain/repositories/i_favorite_repository.dart';
import 'package:pinapp_challenge/features/home/presentation/bloc/favorites_bloc.dart';

import 'favorites_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<IFavoriteRepository>()])
void main() {
  late FavoritesBloc bloc;
  late MockIFavoriteRepository mockRepository;

  setUp(() {
    mockRepository = MockIFavoriteRepository();
    bloc = FavoritesBloc(mockRepository);
  });

  tearDown(() {
    bloc.dispose();
  });

  group('FavoritesBloc Tests', () {
    test('toggleFavorite should add favorite if not exists', () async {
      when(mockRepository.getFavorites()).thenAnswer((_) async => {1, 2, 3});
      await bloc.initialize();
      when(mockRepository.isFavorite(id: 1)).thenAnswer((_) async => false);
      when(mockRepository.add(id: 1)).thenAnswer((_) async {});
      expectLater(bloc.favoritesStream, emitsAnyOf([true]));

      await bloc.toggleFavorite(id: 1);

      expect(bloc.favorites, contains(1));
      verify(mockRepository.add(id: 1)).called(1);
    });

    test('toggleFavorite should remove favorite if exists', () async {
      await bloc.initialize();
      when(mockRepository.getFavorites()).thenAnswer((_) async => {1, 2, 3});
      when(mockRepository.isFavorite(id: 1)).thenAnswer((_) async => true);
      when(mockRepository.remove(id: 1)).thenAnswer((_) async {});
      expect(bloc.favoritesController.stream, emitsAnyOf([false]));

      await bloc.toggleFavorite(id: 1);

      expect(bloc.favorites, isNot(contains(1)));
      verify(mockRepository.remove(id: 1)).called(1);
    });

    test('isFavorite should return true if favorite exists', () async {
      await bloc.initialize();
      when(mockRepository.isFavorite(id: 1)).thenAnswer((_) async => true);
      expect(bloc.favoritesController.stream, emitsAnyOf([true]));

      final result = await bloc.isFavorite(id: 1);

      expect(result, true);
      verify(mockRepository.isFavorite(id: 1)).called(1);
    });

    test('isFavorite should return false if favorite doesn\'t exist', () async {
      await bloc.initialize();
      when(mockRepository.isFavorite(id: 1)).thenAnswer((_) async => false);
      expect(bloc.favoritesController.stream, emitsAnyOf([false]));

      final result = await bloc.isFavorite(id: 1);

      expect(result, false);
      verify(mockRepository.isFavorite(id: 1)).called(1);
    });

    test('initialize should load favorites from repository', () async {
      when(mockRepository.getFavorites()).thenAnswer((_) async => {1, 2, 3});

      await bloc.initialize();

      expect(bloc.favorites, containsAll([1, 2, 3]));
      verify(mockRepository.getFavorites()).called(1);
    });

    test('dispose should close the stream controller', () async {
      bloc.dispose();
      expect(bloc.favoritesController.isClosed, true);
    });
  });
}
