import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinapp_challenge/core/di/environments.dart';
import 'package:pinapp_challenge/core/di/shared_preferences_manager.dart';
import 'package:pinapp_challenge/core/modules/data_state.dart';
import 'package:pinapp_challenge/core/modules/pinapp_module.dart';
import 'package:pinapp_challenge/features/home/domain/models/post.dart';
import 'package:pinapp_challenge/features/home/presentation/bloc/favorites_bloc.dart';
import 'package:pinapp_challenge/features/home/presentation/bloc/posts_bloc.dart';
import 'package:pinapp_challenge/features/home/presentation/screen/home_screen.dart';
import 'package:pinapp_challenge/features/home/presentation/widget/like_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockPostsBloc extends Mock implements PostsBloc {}

class MockFavoritesBloc extends Mock implements FavoritesBloc {
  final StreamController<bool> _favoritesController = StreamController<bool>.broadcast();

  @override
  StreamController<bool> get favoritesController => _favoritesController;
}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockPostsBloc mockPostsBloc;
  late MockFavoritesBloc mockFavoritesBloc;
  late MockSharedPreferences mockSharedPreferences;

  final posts = [
    Post(id: 1, userId: 1, title: 'Test Post 1', body: 'Test Body 1'),
    Post(id: 2, userId: 2, title: 'Test Post 2', body: 'Test Body 2'),
  ];

  setUp(() async {
    mockPostsBloc = MockPostsBloc();
    mockFavoritesBloc = MockFavoritesBloc();
    mockSharedPreferences = MockSharedPreferences();

    SharedPreferences.setMockInitialValues({});
    await SharedPreferencesManager.initialize();

    Modular.bindModule(PinAppModule(environment: Environment.latest));
    Modular.replaceInstance<PostsBloc>(mockPostsBloc);
    Modular.replaceInstance<FavoritesBloc>(mockFavoritesBloc);
    Modular.replaceInstance<SharedPreferences>(mockSharedPreferences);
  });

  tearDown(() {
    Modular.dispose();
  });

  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('should display header and search field', (WidgetTester tester) async {
      when(() => mockPostsBloc.getAllPosts()).thenAnswer((_) => Future.value([posts[0]]));
      when(() => mockPostsBloc.postsStream).thenAnswer((_) => Stream.value(DataSuccess([posts[0]])));
      when(() => mockFavoritesBloc.favorites).thenReturn({});

      await tester.pumpWidget(makeTestableWidget(child: const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.text('Desafio Tecnico'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should display post list when posts are loaded', (WidgetTester tester) async {
      var postList = posts.sublist(0, 1);
      when(() => mockPostsBloc.getAllPosts()).thenAnswer((_) => Future.value(postList));
      when(() => mockPostsBloc.postsStream).thenAnswer((_) => Stream.value(DataSuccess(postList)));
      when(() => mockFavoritesBloc.favorites).thenReturn({});

      await tester.pumpWidget(makeTestableWidget(child: const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(postList.length));
      expect(find.text('Test Post 1'), findsOneWidget);
      expect(find.byType(LikeIcon), findsNWidgets(postList.length));
    });

    testWidgets('should display empty state when posts are empty', (WidgetTester tester) async {
      when(() => mockPostsBloc.getAllPosts()).thenAnswer((_) => Future.value([]));
      when(() => mockPostsBloc.postsStream).thenAnswer((_) => Stream.value(const DataSuccess([])));
      when(() => mockFavoritesBloc.favorites).thenReturn({});

      await tester.pumpWidget(makeTestableWidget(child: const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display retry button when posts fail with retryable error', (WidgetTester tester) async {
      when(() => mockPostsBloc.getAllPosts()).thenAnswer((_) => Future.value([]));
      when(() => mockPostsBloc.postsStream).thenAnswer((_) => Stream.value(DataFailed('Error', retryable: true)));
      when(() => mockFavoritesBloc.favorites).thenReturn({});

      await tester.pumpWidget(makeTestableWidget(child: const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byIcon(CupertinoIcons.refresh_thick), findsOneWidget);
    });

    testWidgets('should filter posts when search text changes', (WidgetTester tester) async {
      when(() => mockPostsBloc.getAllPosts()).thenAnswer((_) => Future.value(posts));
      when(() => mockPostsBloc.postsStream).thenAnswer((_) => Stream.value(DataSuccess(posts)));
      when(() => mockFavoritesBloc.favorites).thenReturn({});

      await tester.pumpWidget(makeTestableWidget(child: const HomeScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Test');
      await tester.pumpAndSettle();

      verify(() => mockPostsBloc.filter(query: 'test')).called(1);
    });

    testWidgets('should call getAllPosts when retry button is tapped', (WidgetTester tester) async {
      when(() => mockPostsBloc.getAllPosts()).thenAnswer((_) => Future.value([]));
      when(() => mockPostsBloc.postsStream).thenAnswer((_) => Stream.value(DataFailed('Error', retryable: true)));
      when(() => mockFavoritesBloc.favorites).thenReturn({});

      await tester.pumpWidget(makeTestableWidget(child: const HomeScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(CupertinoIcons.refresh_thick));
      await tester.pumpAndSettle();

      verify(() => mockPostsBloc.getAllPosts()).called(2);
    });
  });
}
