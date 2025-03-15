import 'dart:convert';
import 'dart:io';

import '../../../../core/modules/data_state.dart';
import '../../domain/models/comment.dart';
import '../../domain/models/post.dart';
import '../../domain/repositories/i_posts_repository.dart';
import '../models/post_model.dart';

class PostsRepositoryImpl implements IPostsRepository {
  final _client = HttpClient();

  @override
  Future<DataState<List<Post>>> getAllPosts() async {
    try {
      final request = await _client.getUrl(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
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
  Future<DataState<List<Comment>>> getPostComments({required int id}) {
    // TODO: implement getPostComments
    throw UnimplementedError();
  }
}
