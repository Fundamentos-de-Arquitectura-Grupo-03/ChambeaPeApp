import 'package:chambeape/domain/entities/posts_entity.dart';
import 'package:chambeape/presentation/providers/posts/posts_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsProvider = StateNotifierProvider<PostsNotifier, List<Post>>((ref) {
  final repository = ref.watch(postsRepositoryProvider);

  return PostsNotifier(
    fetchPosts: repository.getPosts,
    fetchPostsByEmployerId: repository.getPostsByEmployerId,
    createPostCallback: repository.createPost,
    updatePostCallback: repository.updatePost,
    deletePostCallback: repository.deletePost,
  );
});

typedef GetPostsCallback = Future<List<Post>> Function();
typedef GetPostsByEmployerIdCallback = Future<List<Post>> Function(
    int employerId);
typedef CreatePostCallback = Future<Post> Function(Post post);
typedef UpdatePostCallback = Future<Post> Function(Post post);
typedef DeletePostCallback = Future<void> Function(String id);

class PostsNotifier extends StateNotifier<List<Post>> {
  bool isLoading = false;
  bool _isDeleting = false;

  final GetPostsCallback fetchPosts;
  final GetPostsByEmployerIdCallback fetchPostsByEmployerId;
  final CreatePostCallback createPostCallback;
  final UpdatePostCallback updatePostCallback;
  final DeletePostCallback deletePostCallback;

  PostsNotifier({
    required this.fetchPosts,
    required this.fetchPostsByEmployerId,
    required this.createPostCallback,
    required this.updatePostCallback,
    required this.deletePostCallback,
  }) : super([]);

  bool get isDeleting => _isDeleting;

  Future<void> getPosts() async {
    if (isLoading) return;

    isLoading = true;
    try {
      final posts = await fetchPosts();
      state = posts;
    } finally {
      isLoading = false;
    }
  }

  Future<void> getPostsByEmployerId(int employerId) async {
    if (isLoading) return;

    isLoading = true;
    try {
      final posts = await fetchPostsByEmployerId(employerId);
      state = posts;
    } finally {
      isLoading = false;
    }
  }

  Future<void> createPost(Post post, String role) async {
    if (isLoading) return;

    isLoading = true;
    try {
      await createPostCallback(post);
      if (role == 'E') {
        final posts = await fetchPostsByEmployerId(post.employerId);
        state = posts;
      } else {
        final posts = await fetchPosts();
        state = posts;
      }
    } finally {
      // Restablece el estado de carga a falso, indicando que la operación ha terminado
      isLoading = false;
    }
  }

  Future<void> updatePost(Post post, String role) async {
    if (isLoading) return;

    isLoading = true;
    try {
      await updatePostCallback(post);
      if (role == 'E') {
        final posts = await fetchPostsByEmployerId(post.employerId);
        state = posts;
      } else {
        final posts = await fetchPosts();
        state = posts;
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> deletePost(String id, String role, int employerId) async {
    if (_isDeleting) return;

    _isDeleting = true;
    try {
      await deletePostCallback(id);
      if (role == 'E') {
        final posts = await fetchPostsByEmployerId(employerId);
        state = posts;
      } else {
        final posts = await fetchPosts();
        state = posts;
      }
    } finally {
      _isDeleting = false;
    }
  }
}
