
import '../../../../core/modules/data_state.dart';
import '../models/comment.dart';
import '../models/post.dart';

abstract class IPostsRepository {
  Future<DataState<List<Post>>> getAllPosts();

  Future<DataState<List<Comment>>> getPostComments({required int id});
}
