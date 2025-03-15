import 'dart:async';

import '../../../../core/di/i_bloc.dart';
import '../../../../core/modules/data_state.dart';
import '../../domain/models/comment.dart';
import '../../domain/models/post.dart';
import '../../domain/usecases/get_post_comments_use_case.dart';
import '../../domain/usecases/get_posts_use_case.dart';

class PostsBloc extends IBloc {
  PostsBloc(
    this._getPostsUseCase,
    this._getPostCommentsUseCase,
  );

  final GetPostsUseCase _getPostsUseCase;
  final GetPostCommentsUseCase _getPostCommentsUseCase;

  StreamController<DataState<List<Post>>> postsController = StreamController.broadcast();
  StreamController<DataState<List<Comment>>> postCommentsController = StreamController.broadcast();

  Stream<DataState<List<Post>>> get postsStream => postsController.stream;

  Stream<DataState<List<Comment>>> get postCommentStream => postCommentsController.stream;

  final _originalList = <Post>[];

  Future<void> getAllPosts() async {
    _originalList.clear();
    postsController.sink.add(const DataLoading());
    var response = await _getPostsUseCase.call();
    if (response is DataSuccess<List<Post>>) {
      _originalList.addAll(response.data!);
    }
    postsController.sink.add(response);
  }

  void filter({required String query}) {
    postsController.sink.add(
      query.isEmpty
          ? DataSuccess(_originalList)
          : DataSuccess(
              _originalList.where((post) {
                return post.title.toLowerCase().contains(query);
              }).toList(),
            ),
    );
  }

  Future<void> getPostComments({required int id}) async {
    postCommentsController.sink.add(const DataLoading());
    var response = await _getPostCommentsUseCase.call(params: id);
    postCommentsController.sink.add(response);
  }

  @override
  void dispose() {
    postsController.close();
    postCommentsController.close();
  }

  @override
  void initialize() {}
}
