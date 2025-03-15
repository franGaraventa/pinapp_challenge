import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinapp_challenge/core/di/environments.dart';
import 'package:pinapp_challenge/core/di/shared_preferences_manager.dart';
import 'package:pinapp_challenge/core/modules/data_state.dart';
import 'package:pinapp_challenge/core/modules/pinapp_module.dart';
import 'package:pinapp_challenge/features/home/domain/models/comment.dart';
import 'package:pinapp_challenge/features/home/domain/models/post.dart';
import 'package:pinapp_challenge/features/home/presentation/bloc/favorites_bloc.dart';
import 'package:pinapp_challenge/features/home/presentation/bloc/posts_bloc.dart';
import 'package:pinapp_challenge/features/home/presentation/screen/post_comments_screen.dart';
import 'package:pinapp_challenge/features/home/presentation/widget/like_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockPostsBloc extends Mock implements PostsBloc {}

class MockFavoritesBloc extends Mock implements FavoritesBloc {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockPostsBloc mockPostsBloc;
  late MockFavoritesBloc mockFavoritesBloc;
  late SharedPreferences mockSharedPreferences;
  late Post post;

  setUp(() async {
    mockPostsBloc = MockPostsBloc();
    mockFavoritesBloc = MockFavoritesBloc();
    mockSharedPreferences = MockSharedPreferences();
    post = Post(id: 1, userId: 1, title: 'Test Post', body: 'Test Body');

    SharedPreferences.setMockInitialValues({});
    await SharedPreferencesManager.initialize();

    Modular.bindModule(PinAppModule(environment: Environment.latest));
    Modular.replaceInstance<PostsBloc>(mockPostsBloc);
    Modular.replaceInstance<FavoritesBloc>(mockFavoritesBloc);
    Modular.replaceInstance<SharedPreferences>(mockSharedPreferences);
  });


  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  group('PostCommentsScreen Widget Tests', () {
    testWidgets('should display loading indicator when comments are loading', (WidgetTester tester) async {
      when(() => mockPostsBloc.postCommentStream).thenAnswer((_) => Stream.value(const DataLoading()));
      when(() => mockFavoritesBloc.favoritesStream).thenAnswer((_) => Stream.value(false));

      when(() => mockPostsBloc.getPostComments(id: post.id)).thenAnswer((_) => Future.value());
      when(() => mockFavoritesBloc.isFavorite(id: post.id)).thenAnswer((_) => Future.value(false));

      await tester.pumpWidget(makeTestableWidget(child: PostCommentsScreen(post: post)));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display comment list when comments are loaded', (WidgetTester tester) async {
      final comments = [
        Comment(id: 1, postId: 1, name: 'Test Comment 1', email: 'test1@example.com', body: 'Test Body 1'),
        Comment(id: 2, postId: 1, name: 'Test Comment 2', email: 'test2@example.com', body: 'Test Body 2'),
      ];
      when(() => mockPostsBloc.postCommentStream).thenAnswer((_) => Stream.value(DataSuccess(comments)));
      when(() => mockFavoritesBloc.favoritesStream).thenAnswer((_) => Stream.value(false));

      when(() => mockPostsBloc.getPostComments(id: post.id)).thenAnswer((_) => Future.value());
      when(() => mockFavoritesBloc.isFavorite(id: post.id)).thenAnswer((_) => Future.value(false));

      await tester.pumpWidget(makeTestableWidget(child: PostCommentsScreen(post: post)));
      await tester.pump();

      expect(find.byType(ListTile), findsNWidgets(comments.length));
      expect(find.text('Test Comment 1'), findsOneWidget);
      expect(find.text('test1@example.com'), findsOneWidget);
      expect(find.text('Test Body 2'), findsOneWidget);
    });

    testWidgets('should display empty state when comments are empty', (WidgetTester tester) async {
      when(() => mockPostsBloc.postCommentStream).thenAnswer((_) => Stream.value(const DataSuccess([])));
      when(() => mockFavoritesBloc.favoritesStream).thenAnswer((_) => Stream.value(false));

      when(() => mockPostsBloc.getPostComments(id: post.id)).thenAnswer((_) => Future.value());
      when(() => mockFavoritesBloc.isFavorite(id: post.id)).thenAnswer((_) => Future.value(false));

      await tester.pumpWidget(makeTestableWidget(child: PostCommentsScreen(post: post)));
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('El post no contiene comentarios'), findsOneWidget);
    });

    testWidgets('should display retry button when comments fail with retryable error', (WidgetTester tester) async {
      when(() => mockPostsBloc.postCommentStream).thenAnswer((_) => Stream.value(DataFailed('Error', retryable: true)));
      when(() => mockFavoritesBloc.favoritesStream).thenAnswer((_) => Stream.value(false));

      when(() => mockPostsBloc.getPostComments(id: post.id)).thenAnswer((_) => Future.value());
      when(() => mockFavoritesBloc.isFavorite(id: post.id)).thenAnswer((_) => Future.value(false));

      await tester.pumpWidget(makeTestableWidget(child: PostCommentsScreen(post: post)));
      await tester.pumpAndSettle();

      expect(find.byIcon(CupertinoIcons.refresh_thick), findsOneWidget);
    });

    testWidgets('should call getPostComments when retry button is tapped', (WidgetTester tester) async {
      when(() => mockPostsBloc.postCommentStream).thenAnswer((_) => Stream.value(DataFailed('Error', retryable: true)));
      when(() => mockFavoritesBloc.favoritesStream).thenAnswer((_) => Stream.value(false));

      when(() => mockPostsBloc.getPostComments(id: post.id)).thenAnswer((_) => Future.value());
      when(() => mockFavoritesBloc.isFavorite(id: post.id)).thenAnswer((_) => Future.value(false));

      await tester.pumpWidget(makeTestableWidget(child: PostCommentsScreen(post: post)));
      await tester.pump();

      await tester.tap(find.byIcon(CupertinoIcons.refresh_thick));
      await tester.pump();

      verify(() => mockPostsBloc.getPostComments(id: post.id)).called(2);
    });

    testWidgets('should display LikeIcon with correct isEnabled value from FavoritesBloc', (WidgetTester tester) async {
      when(() => mockPostsBloc.postCommentStream).thenAnswer((_) => Stream.value(const DataSuccess([])));
      when(() => mockFavoritesBloc.favoritesStream).thenAnswer((_) => Stream.value(true));

      when(() => mockPostsBloc.getPostComments(id: post.id)).thenAnswer((_) => Future.value());
      when(() => mockFavoritesBloc.isFavorite(id: post.id)).thenAnswer((_) => Future.value(false));

      await tester.pumpWidget(makeTestableWidget(child: PostCommentsScreen(post: post)));
      await tester.pump();

      final likeIcon = tester.widget<LikeIcon>(find.byType(LikeIcon));
      expect(likeIcon.isEnabled, true);

      when(() => mockFavoritesBloc.favoritesStream).thenAnswer((_) => Stream.value(false));
      await tester.pump();

      final likeIcon2 = tester.widget<LikeIcon>(find.byType(LikeIcon));
      expect(likeIcon2.isEnabled, true);
    });

    testWidgets('should call toggleFavorite when LikeIcon is tapped', (WidgetTester tester) async {
      when(() => mockPostsBloc.postCommentStream).thenAnswer((_) => Stream.value(const DataSuccess([])));
      when(() => mockFavoritesBloc.favoritesStream).thenAnswer((_) => Stream.value(false));

      when(() => mockPostsBloc.getPostComments(id: post.id)).thenAnswer((_) => Future.value());
      when(() => mockFavoritesBloc.isFavorite(id: post.id)).thenAnswer((_) => Future.value(false));
      when(() => mockFavoritesBloc.toggleFavorite(id: post.id)).thenAnswer((_) => Future.value());

      await tester.pumpWidget(makeTestableWidget(child: PostCommentsScreen(post: post)));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LikeIcon));
      await tester.pumpAndSettle();

      verify(() => mockFavoritesBloc.toggleFavorite(id: post.id)).called(1);
    });
  });
}
