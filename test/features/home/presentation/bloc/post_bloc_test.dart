import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pinapp_challenge/core/modules/data_state.dart';
import 'package:pinapp_challenge/features/home/domain/models/comment.dart';
import 'package:pinapp_challenge/features/home/domain/models/post.dart';
import 'package:pinapp_challenge/features/home/domain/usecases/get_post_comments_use_case.dart';
import 'package:pinapp_challenge/features/home/domain/usecases/get_posts_use_case.dart';
import 'package:pinapp_challenge/features/home/presentation/bloc/posts_bloc.dart';

import 'post_bloc_test.mocks.dart';

@GenerateMocks([GetPostsUseCase, GetPostCommentsUseCase])
void main() {
  late PostsBloc bloc;
  late MockGetPostsUseCase mockGetPostsUseCase;
  late MockGetPostCommentsUseCase mockGetPostCommentsUseCase;

  setUp(() {
    mockGetPostsUseCase = MockGetPostsUseCase();
    mockGetPostCommentsUseCase = MockGetPostCommentsUseCase();
    bloc = PostsBloc(mockGetPostsUseCase, mockGetPostCommentsUseCase);
  });

  tearDown(() {
    bloc.dispose();
  });

  final posts = [
    Post(id: 1, userId: 1, title: 'Test Post 1', body: 'Test Body 1'),
    Post(id: 2, userId: 2, title: 'Test Post 2', body: 'Test Body 2'),
  ];

  group('PostsBloc Tests', () {
    test('getAllPosts should emit DataSuccess with posts when successful', () async {
      final posts = [
        Post(id: 1, userId: 1, title: 'Test Post', body: 'Test Body'),
      ];
      when(mockGetPostsUseCase.call()).thenAnswer((_) async => DataSuccess(posts));

      bloc.getAllPosts();

      expect(bloc.postsStream, emits(isA<DataSuccess<List<Post>>>()));
      verify(mockGetPostsUseCase.call()).called(1);
    });

    test('getAllPosts should emit DataLoading and DataFailed when failed', () async {
      when(mockGetPostsUseCase.call()).thenAnswer((_) async => DataFailed('Error'));

      expectLater(
        bloc.postsStream,
        emitsInOrder(
          [
            isA<DataLoading>(),
            isA<DataFailed<List<Post>>>(),
          ],
        ),
      );

      bloc.getAllPosts();
      verify(mockGetPostsUseCase.call()).called(1);
    });

    test('filter should emit DataSuccess with filtered posts when query is not empty', () async {
      when(mockGetPostsUseCase.call()).thenAnswer((_) async => DataSuccess(posts));
      expectLater(
        bloc.postsStream,
        emitsInOrder([
          isA<DataLoading>(),
          isA<DataSuccess<List<Post>>>(),
          isA<DataSuccess<List<Post>>>(),
        ]),
      );

      bloc.getAllPosts();
      bloc.filter(query: 'Test');
    });

    test('filter should emit DataSuccess with original posts when query is empty', () async {
      when(mockGetPostsUseCase.call()).thenAnswer((_) async => DataSuccess(posts));
      expectLater(
        bloc.postsStream,
        emitsInOrder([
          isA<DataLoading>(),
          isA<DataSuccess<List<Post>>>(),
          isA<DataSuccess<List<Post>>>(),
        ]),
      );

      bloc.getAllPosts();
      bloc.filter(query: '');
    });

    test('getPostComments should emit DataLoading and DataSuccess with comments when successful', () async {
      final comments = [
        Comment(postId: 1, id: 1, name: 'Test Comment', email: 'test@example.com', body: 'Test Body'),
      ];
      when(mockGetPostCommentsUseCase.call(params: 1)).thenAnswer((_) async => DataSuccess(comments));

      expectLater(
        bloc.postCommentStream,
        emitsInOrder([
          isA<DataLoading>(),
          isA<DataSuccess<List<Comment>>>(),
        ]),
      );

      bloc.getPostComments(id: 1);
      verify(mockGetPostCommentsUseCase.call(params: 1)).called(1);
    });

    test('getPostComments should emit DataLoading and DataFailed when failed', () async {
      when(mockGetPostCommentsUseCase.call(params: 1)).thenAnswer((_) async => DataFailed('Error'));

      expectLater(
        bloc.postCommentStream,
        emitsInOrder([
          isA<DataLoading<List<Comment>>>(),
          isA<DataFailed<List<Comment>>>(),
        ]),
      );

      bloc.getPostComments(id: 1);
      verify(mockGetPostCommentsUseCase.call(params: 1)).called(1);
    });

    test('dispose should close the stream controllers', () {
      expect(bloc.postsController.isClosed, false);
      expect(bloc.postCommentsController.isClosed, false);

      bloc.dispose();

      expect(bloc.postsController.isClosed, true);
      expect(bloc.postCommentsController.isClosed, true);
    });
  });
}
