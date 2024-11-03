import 'dart:convert';

import 'package:chambeape/config/constats/environmet.dart';
import 'package:chambeape/domain/datasources/posts_datasource.dart';
import 'package:chambeape/domain/entities/posts_entity.dart';
import 'package:chambeape/infrastructure/mappers/post_mapper.dart';
import 'package:chambeape/infrastructure/models/post_model.dart';
import 'package:http/http.dart' as http;

class PostsdbDatasource extends PostsDataSource {
  @override
  Future<List<Post>> getPosts() async {
    const String uri = '${UriEnvironment.baseUrl}/posts';

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> postsResponse =
          json.decode(utf8.decode(response.bodyBytes));
      final List<Post> posts = postsResponse
          .map((item) => PostMapper.postModelToEntity(PostModel.fromJson(item)))
          .toList();

      return posts;
    } else {
      // Handle errors as needed
      throw Exception(
          'Error fetching posts: ${response.statusCode}, Response: ${response.body}');
    }
  }

  @override
  Future<List<Post>> getPostsByEmployerId(int employerId) async {
    final Uri uri =
        Uri.parse('${UriEnvironment.baseUrl}/employers/$employerId/posts');

    final response = await http.get(uri);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> postsResponse =
          json.decode(utf8.decode(response.bodyBytes));
      final List<Post> posts = postsResponse
          .map((item) => PostMapper.postModelToEntity(PostModel.fromJson(item)))
          .toList();
      print('SUCCESS:' + posts.toString());
      return posts;
    } else {
      // Handle errors as needed
      throw Exception(
          'Error fetching posts: ${response.statusCode}, Response: ${response.body}');
    }
  }

  @override
  Future<Post> createPost(Post post) async {
    final Uri uri = await UriEnvironment.getPostUri();
    final PostModel postModel = PostMapper.entityToPostModel(post);

    Map<String, dynamic> requestBody = {
      'title': postModel.title,
      'description': postModel.description,
      'subtitle': postModel.subtitle,
      'imgUrl': postModel.imgUrl
    };

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PostMapper.postModelToEntity(
          PostModel.fromJson(json.decode(response.body)));
    } else {
      throw Exception(
          'Failed to create post: ${response.statusCode}, Response: ${response.body}');
    }
  }

  @override
  Future<Post> updatePost(Post post) async {
    final Uri uri = Uri.parse(
        'https://chambeape.azurewebsites.net/api/v1/posts/${post.id}');
    final postModel = PostMapper.entityToPostModel(post);

    Map<String, dynamic> requestBody = {
      'title': postModel.title,
      'description': postModel.description,
      'subtitle': postModel.subtitle,
      'imgUrl': postModel.imgUrl
    };

    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        var responseJson = json.decode(response.body);
        return PostMapper.postModelToEntity(PostModel.fromJson(responseJson));
      } else {
        return post;
      }
    } else {
      throw Exception(
          'Failed to update post: ${response.statusCode}, Response: ${response.body}');
    }
  }

  @override
  Future<void> deletePost(String id) async {
    final Uri uri =
        Uri.parse('https://chambeape.azurewebsites.net/api/v1/posts/$id');

    final response = await http.delete(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      throw Exception(
          'Failed to delete post: ${response.statusCode}, Response: ${response.body}');
    }
  }
}
