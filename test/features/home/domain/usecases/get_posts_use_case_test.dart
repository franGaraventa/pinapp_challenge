import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pinapp_challenge/core/modules/data_state.dart';
import 'package:pinapp_challenge/features/home/domain/models/post.dart';
import 'package:pinapp_challenge/features/home/domain/repositories/i_posts_repository.dart';
import 'package:pinapp_challenge/features/home/domain/usecases/get_posts_use_case.dart';

import 'get_post_comments_use_case_test.mocks.dart';

@GenerateMocks([IPostsRepository])
void main() {
  late GetPostsUseCase useCase;
  late MockIPostsRepository mockRepository;

  setUp(() {
    mockRepository = MockIPostsRepository();
    useCase = GetPostsUseCase(mockRepository);
  });

  group('GetPostsUseCase Tests', () {
    test('should get posts from repository on success', () async {
      final postList = [Post(userId: 1, id: 1, title: 'Test Post', body: 'Test Body')];
      final dataSuccess = DataSuccess<List<Post>>(postList);
      when(mockRepository.getAllPosts()).thenAnswer((_) async => dataSuccess);
      final result = await useCase.call();
      expect(result, dataSuccess);
      verify(mockRepository.getAllPosts()).called(1);
    });

    test('should return DataFailed on repository failure', () async {
      var dataFailed = DataFailed<List<Post>>('Error message');
      when(mockRepository.getAllPosts()).thenAnswer((_) async => dataFailed);
      final result = await useCase.call();
      expect(result, dataFailed);
      verify(mockRepository.getAllPosts()).called(1);
    });
  });
}
