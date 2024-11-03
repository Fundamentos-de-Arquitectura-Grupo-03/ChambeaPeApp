import 'package:chambeape/domain/entities/posts_entity.dart';

abstract class PostsRepository {
  Future<List<Post>> getPosts();

  Future<List<Post>> getPostsByEmployerId(int employerId);

  Future<Post> createPost(Post post);

  Future<Post> updatePost(Post post);

  Future<void> deletePost(String id);
}
