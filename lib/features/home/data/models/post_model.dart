import '../../domain/models/post.dart';

class PostModel extends Post {
  PostModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        body: json['body'],
      );
}
