import '../../../../core/di/i_use_case.dart';
import '../../../../core/modules/data_state.dart';
import '../models/comment.dart';
import '../repositories/i_posts_repository.dart';

class GetPostCommentsUseCase implements UseCaseWithParams<DataState<List<Comment>>, int>{
  GetPostCommentsUseCase(this._repository);

  final IPostsRepository _repository;

  @override
  Future<DataState<List<Comment>>> call({int? params}) {
    return _repository.getPostComments(id: params!);
  }
}
