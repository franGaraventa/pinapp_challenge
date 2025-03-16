import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import '../../../../../core/modules/data_state.dart';
import '../../../domain/repositories/i_posts_repository.dart';
import '../../models/comment_model.dart';
import '../../models/post_model.dart';

class PostsRepositoryImpl implements IPostsRepository {
  PostsRepositoryImpl({required this.baseUrl, Client? client}) : _client = client ?? Client();

  final String baseUrl;
  final Client _client;

  static const serviceErrorMsg = 'Hubo un error al realizar el llamado';
  static const connectionErrorMsg = 'Hubo un error con la conexion';
  static MethodChannel platform = const MethodChannel('com.pinapp.challenge.pinapp_challenge.service');
  static MethodChannel? mockPlatform;

  @override
  Future<DataState<List<PostModel>>> getAllPosts() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/posts'));

      if (response.statusCode == HttpStatus.ok) {
        final jsonDecode = await json.decode(response.body);
        var list = (jsonDecode as List).map((post) => PostModel.fromJson(post)).toList();
        return DataSuccess(list);
      } else {
        return DataFailed('$serviceErrorMsg (${response.statusCode})');
      }
    } catch (error) {
      return DataFailed(connectionErrorMsg, retryable: true);
    }
  }

  @override
  Future<DataState<List<CommentModel>>> getPostComments({required int id}) async {
    try {
      final result = await (mockPlatform ?? platform).invokeMethod(
        'getComments',
        {'url': '$baseUrl/comments?postId=$id'},
      );
      final jsonDecode = await json.decode(result);
      var list = (jsonDecode as List).map((post) => CommentModel.fromJson(post)).toList();
      return DataSuccess(list);
    } catch (error) {
      return DataFailed(connectionErrorMsg, retryable: true);
    }
  }
}
