import '../../../../core/di/i_use_case.dart';
import '../../../../core/modules/data_state.dart';
import '../models/post.dart';
import '../repositories/i_posts_repository.dart';

class GetPostsUseCase implements UseCase<DataState<List<Post>>>{
  GetPostsUseCase(this._repository);

  final IPostsRepository _repository;

  @override
  Future<DataState<List<Post>>> call() {
    return _repository.getAllPosts();
  }
}
