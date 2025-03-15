import '../../../../core/modules/data_state.dart';
import '../../domain/models/comment.dart';
import '../../domain/models/post.dart';
import '../../domain/repositories/i_posts_repository.dart';

class PostsRepositoryImpl implements IPostsRepository {
  @override
  Future<DataState<List<Post>>> getAllPosts() {
    // TODO: implement getAllPosts
    throw UnimplementedError();
  }

  @override
  Future<DataState<List<Comment>>> getPostComments({required int id}) {
    // TODO: implement getPostComments
    throw UnimplementedError();
  }
}
