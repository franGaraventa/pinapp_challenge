import 'dart:convert';
import 'dart:io';

import '../../../../core/modules/data_state.dart';
import '../../domain/models/comment.dart';
import '../../domain/models/post.dart';
import '../../domain/repositories/i_posts_repository.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';

class PostsRepositoryImpl implements IPostsRepository {
  PostsRepositoryImpl({required this.baseUrl});

  final String baseUrl;
  final _client = HttpClient();

  static const serviceErrorMsg = 'Hubo un error al realizar el llamado';
  static const connectionErrorMsg = 'Hubo un error con la conexion';

  @override
  Future<DataState<List<Post>>> getAllPosts() async {
    try {
      final request = await _client.getUrl(Uri.parse('$baseUrl/posts'));
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final jsonString = await utf8.decoder.bind(response).join();
        final jsonDecode = await json.decode(jsonString);
        var list = (jsonDecode as List).map((post) => PostModel.fromJson(post)).toList();
        return DataSuccess(list);
      } else {
        return DataFailed('Hubo un error al realizar el llamado (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Hubo un error con la conexion: $e');
    }
  }

  @override
  Future<DataState<List<Comment>>> getPostComments({required int id}) async {
    try {
      final request = await _client.getUrl(Uri.parse('$baseUrl/comments?postId=$id'));
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final jsonString = await utf8.decoder.bind(response).join();
        final jsonDecode = await json.decode(jsonString);
        var list = (jsonDecode as List).map((post) => CommentModel.fromJson(post)).toList();
        return DataSuccess(list);
      } else {
        return DataFailed('$serviceErrorMsg (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('$connectionErrorMsg: $e');
    }
  }
}
