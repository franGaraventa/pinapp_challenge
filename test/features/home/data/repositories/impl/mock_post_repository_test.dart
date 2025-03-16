import 'package:flutter_test/flutter_test.dart';

import 'package:pinapp_challenge/core/modules/data_state.dart';
import 'package:pinapp_challenge/features/home/data/models/comment_model.dart';
import 'package:pinapp_challenge/features/home/data/models/post_model.dart';
import 'package:pinapp_challenge/features/home/data/repositories/impl/mock_posts_repository_impl.dart';

void main() {
  late MockPostRepositoryImpl repository;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    repository = MockPostRepositoryImpl();
  });

  group('MockPostRepositoryImpl Tests', () {
    test('getAllPosts should return a list of PostModel', () async {
      final result = await repository.getAllPosts();
      expect(result, isA<DataSuccess<List<PostModel>>>());

      final posts = (result as DataSuccess<List<PostModel>>).data;
      expect(posts, isNotEmpty);
    });

    test('getPostComments should return a list of CommentModel', () async {
      final result = await repository.getPostComments(id: 1);
      expect(result, isA<DataSuccess<List<CommentModel>>>());

      final comments = (result as DataSuccess<List<CommentModel>>).data;
      expect(comments, isNotEmpty);
    });

    test('getPostComments should return DataFailed when file does not exist', () async {
      final result = await repository.getPostComments(id: 999);
      expect(result, isA<DataFailed<List<CommentModel>>>());

      final error = (result as DataFailed<List<CommentModel>>).error;
      expect(error, isNotEmpty);
    });
  });
}
