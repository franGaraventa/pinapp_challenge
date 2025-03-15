import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../../core/modules/data_state.dart';
import '../../domain/repositories/i_posts_repository.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';

class MockPostRepositoryImpl extends IPostsRepository {
  @override
  Future<DataState<List<PostModel>>> getAllPosts() async {
    final String response = await rootBundle.loadString('assets/mock/posts.json');
    final jsonDecode = await json.decode(response);
    var list = (jsonDecode as List).map((post) => PostModel.fromJson(post)).toList();
    return DataSuccess(list);
  }

  @override
  Future<DataState<List<CommentModel>>> getPostComments({required int id}) async {
    try {
      final String response = await rootBundle.loadString('assets/mock/post_$id.json');
      final jsonDecode = await json.decode(response);
      var list = (jsonDecode as List).map((comment) => CommentModel.fromJson(comment)).toList();
      return DataSuccess(list);
    } on FlutterError catch (error) {
      return DataFailed(error.message);
    }
  }
}
