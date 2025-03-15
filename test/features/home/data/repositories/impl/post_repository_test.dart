import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pinapp_challenge/core/modules/data_state.dart';
import 'package:pinapp_challenge/features/home/data/models/comment_model.dart';
import 'package:pinapp_challenge/features/home/data/models/post_model.dart';
import 'package:pinapp_challenge/features/home/data/repositories/impl/posts_repository_impl.dart';

import 'post_repository_test.mocks.dart';

@GenerateMocks([http.Client, MethodChannel])
void main() {
  late PostsRepositoryImpl repository;
  late MockClient mockClient;
  late MockMethodChannel mockMethodChannel;

  setUp(() {
    mockClient = MockClient();
    mockMethodChannel = MockMethodChannel();
    PostsRepositoryImpl.mockPlatform = mockMethodChannel;
    repository = PostsRepositoryImpl(baseUrl: 'http://example.com', client: mockClient);
  });

  tearDown(() {
    PostsRepositoryImpl.mockPlatform = null; // Reset the mock
  });

  group('PostsRepositoryImpl Tests', () {
    test('getAllPosts should return DataSuccess with posts when successful', () async {
      final mockResponse = http.Response(
        json.encode([
          {'userId': 1, 'id': 1, 'title': 'Test Post', 'body': 'Test Body'}
        ]),
        HttpStatus.ok,
      );

      when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

      final result = await repository.getAllPosts();

      expect(result, isA<DataSuccess<List<PostModel>>>());
      expect(result.data, isNotNull);
      expect(result.data!.length, 1);
      expect(result.data![0].id, 1);
    });

    test('getAllPosts should return DataFailed when server returns error', () async {
      final mockResponse = http.Response('Error', HttpStatus.internalServerError);

      when(mockClient.get(any)).thenAnswer((_) async => mockResponse);

      final result = await repository.getAllPosts();

      expect(result, isA<DataFailed<List<PostModel>>>());
      expect(result.error, 'Hubo un error al realizar el llamado (500)');
    });

    test('getPostComments should return DataSuccess with comments when successful', () async {
      final mockResponse = json.encode([
        {'postId': 1, 'id': 1, 'name': 'Test Comment', 'body': 'Test Body', 'email': 'test@example.com'}
      ]);

      when(mockMethodChannel.invokeMethod('getComments', any)).thenAnswer((_) async => mockResponse);

      final result = await repository.getPostComments(id: 1);

      expect(result, isA<DataSuccess<List<CommentModel>>>());
      expect(result.data, isNotNull);
      expect(result.data!.length, 1);
      expect(result.data![0].id, 1);
    });
  });
}
