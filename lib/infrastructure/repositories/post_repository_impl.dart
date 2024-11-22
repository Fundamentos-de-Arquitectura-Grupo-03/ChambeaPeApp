import 'package:chambeape/domain/datasources/posts_datasource.dart';
import 'package:chambeape/domain/entities/posts_entity.dart';
import 'package:chambeape/domain/repositories/posts_repository.dart';

class PostRepositoryImpl extends PostsRepository {
  final PostsDataSource datasource;

  PostRepositoryImpl(this.datasource);

  @override
  Future<List<Post>> getPosts() {
    return datasource.getPosts();
  }

  @override
  Future<List<Post>> getPostsByEmployerId(int employerId) {
    return datasource.getPostsByEmployerId(employerId);
  }

  @override
  Future<Post> createPost(Post post) {
    return datasource.createPost(post);
  }

  @override
  Future<void> deletePost(String id) {
    return datasource.deletePost(id);
  }

  @override
  Future<Post> updatePost(Post post) {
    return datasource.updatePost(post);
  }
}
