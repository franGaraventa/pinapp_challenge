import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pinapp_challenge/core/modules/data_state.dart';
import 'package:pinapp_challenge/features/home/domain/models/comment.dart';
import 'package:pinapp_challenge/features/home/domain/repositories/i_posts_repository.dart';
import 'package:pinapp_challenge/features/home/domain/usecases/get_post_comments_use_case.dart';

import 'get_post_comments_use_case_test.mocks.dart';

@GenerateMocks([IPostsRepository])
void main() {
  late GetPostCommentsUseCase useCase;
  late MockIPostsRepository mockRepository;

  setUp(() {
    mockRepository = MockIPostsRepository();
    useCase = GetPostCommentsUseCase(mockRepository);
  });

  group('GetPostCommentsUseCase Tests', () {
    test('should get comments from repository on success', () async {
      final commentList = [Comment(postId: 1, id: 1, name: 'Test Comment', email: 'test@example.com', body: 'Test Body')];
      final dataSuccess = DataSuccess<List<Comment>>(commentList);

      when(mockRepository.getPostComments(id: 1)).thenAnswer((_) async => dataSuccess);

      final result = await useCase.call(params: 1);

      expect(result, dataSuccess);
      verify(mockRepository.getPostComments(id: 1)).called(1);
    });

    test('should return DataFailed on repository failure', () async {
      var dataFailed = DataFailed<List<Comment>>('Error message');

      when(mockRepository.getPostComments(id: 1)).thenAnswer((_) async => dataFailed);

      final result = await useCase.call(params: 1);

      expect(result, dataFailed);
      verify(mockRepository.getPostComments(id: 1)).called(1);
    });
  });
}
