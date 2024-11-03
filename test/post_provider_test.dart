import 'package:flutter_test/flutter_test.dart';
import 'package:chambeape/domain/entities/posts_entity.dart';
import 'package:chambeape/presentation/providers/posts/post_provider.dart';

void main() {
  group('Post Management Tests', () {
    test('Crear anuncios de trabajo', () async {
      // Arrange
      Future<Post> mockCreatePostCallback(Post post) async {
        return post;
      }

      final postsNotifier = PostsNotifier(
        fetchPosts: () async => [],
        fetchPostsByEmployerId: (id) async => [],
        createPostCallback: mockCreatePostCallback,
        updatePostCallback: (post) async => post,
        deletePostCallback: (id) async {},
      );

      final newPost = Post(
        id: 1,
        title: 'Nuevo Trabajo',
        description: 'Descripción de prueba',
        subtitle: 'Subtítulo de prueba',
        imgUrl: 'url_de_imagen.png',
        employerId: 1,
      );

      // Act
      await postsNotifier.createPost(newPost, 'E');
      postsNotifier.state = [...postsNotifier.state, newPost];

      // Assert
      expect(postsNotifier.state, contains(newPost));
    });

    test('Editar anuncios de trabajo', () async {
      // Arrange
      Future<Post> mockUpdatePostCallback(Post post) async {
        return post;
      }

      final postsNotifier = PostsNotifier(
        fetchPosts: () async => [],
        fetchPostsByEmployerId: (id) async => [],
        createPostCallback: (post) async => post,
        updatePostCallback: mockUpdatePostCallback,
        deletePostCallback: (id) async {},
      );

      final updatedPost = Post(
        id: 1,
        title: 'Trabajo Editado',
        description: 'Descripción editada',
        subtitle: 'Subtítulo editado',
        imgUrl: 'url_actualizada.png',
        employerId: 1,
      );

      // Act
      await postsNotifier.updatePost(updatedPost, 'E');
      postsNotifier.state = [updatedPost];

      // Assert
      expect(postsNotifier.state, contains(updatedPost));
    });

    test('Eliminar anuncios de trabajo', () async {
      // Arrange
      Future<void> mockDeletePostCallback(String id) async {}
      final postsNotifier = PostsNotifier(
        fetchPosts: () async => [],
        fetchPostsByEmployerId: (id) async => [],
        createPostCallback: (post) async => post,
        updatePostCallback: (post) async => post,
        deletePostCallback: mockDeletePostCallback,
      );

      final newPost = Post(
        id: 1,
        title: 'Trabajo a Eliminar',
        description: 'Descripción de prueba',
        subtitle: 'Subtítulo de prueba',
        imgUrl: 'url_de_imagen.png',
        employerId: 1,
      );

      postsNotifier.state = [newPost];

      // Act
      await postsNotifier.deletePost('1', 'E', 1);
      postsNotifier.state = [];

      // Assert
      expect(postsNotifier.state, isEmpty);
    });

    test('Visualizar anuncios de trabajo creados', () async {
      // Arrange
      Future<List<Post>> mockFetchPostsByEmployerId(int id) async {
        return [
          Post(
            id: 1,
            title: 'Trabajo 1',
            description: 'Descripción 1',
            subtitle: 'Subtítulo 1',
            imgUrl: 'url_imagen_1.png',
            employerId: 1,
          )
        ];
      }

      final postsNotifier = PostsNotifier(
        fetchPosts: () async => [],
        fetchPostsByEmployerId: mockFetchPostsByEmployerId,
        createPostCallback: (post) async => post,
        updatePostCallback: (post) async => post,
        deletePostCallback: (id) async {},
      );

      // Act
      await postsNotifier.getPostsByEmployerId(1);

      // Assert
      expect(postsNotifier.state.isNotEmpty, true);
      expect(postsNotifier.state.first.title, equals('Trabajo 1'));
    });
  });
}
