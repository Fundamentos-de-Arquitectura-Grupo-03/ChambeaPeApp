import 'package:chambeape/config/utils/login_user_data.dart';
import 'package:chambeape/domain/entities/posts_entity.dart';
import 'package:chambeape/infrastructure/models/login/login_response.dart';
import 'package:chambeape/presentation/providers/posts/post_provider.dart';
import 'package:chambeape/presentation/screens/3_posts/widgets/post_card_widget.dart';
import 'package:chambeape/presentation/screens/3_posts/widgets/stepper_post.dart';
import 'package:chambeape/presentation/screens/postulations/postulation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostView extends ConsumerStatefulWidget {
  static const String routeName = 'post_view';

  const PostView({super.key});

  @override
  createState() => _PostViewState();
}

class _PostViewState extends ConsumerState<PostView> {
  late Future<LoginResponse> _futureUser;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _futureUser = LoginData().loadSession();
  }

  Future<void> _initializePosts(LoginResponse user) async {
    if (!_initialized) {
      if (user.userRole == 'E') {
        await ref.read(postsProvider.notifier).getPostsByEmployerId(user.id);
      } else {
        await ref.read(postsProvider.notifier).getPosts();
      }
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postsProvider);

    return FutureBuilder<LoginResponse>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar sesión de usuario'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No se encontró la sesión de usuario'));
        } else {
          final user = snapshot.data!;
          _initializePosts(user); // Inicializa los posts si no se ha hecho antes
          final role = user.userRole;
          return role == 'E'
              ? _EmployerPosts(posts: posts)
              : _WorkerPosts(posts: posts);
        }
      },
    );
  }
}

class _EmployerPosts extends StatelessWidget {
  const _EmployerPosts({
    required this.posts,
  });

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const StepperPost()));
            },
          )
        ],
      ),
      body: PostCardWidget(posts: posts),
    );
  }
}

class _WorkerPosts extends StatelessWidget {
  const _WorkerPosts({
    required this.posts,
  });

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton.filled(
            icon: const Icon(Icons.assignment_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, PostulationView.routeName);
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: PostCardWidget(posts: posts),
    );
  }
}
