import 'package:chambeape/config/utils/login_user_data.dart';
import 'package:chambeape/domain/entities/posts_entity.dart';
import 'package:chambeape/infrastructure/models/login/login_response.dart';
import 'package:chambeape/presentation/screens/3_posts/widgets/post_detail.dart';
import 'package:chambeape/services/postulation/postulation_service.dart';
import 'package:flutter/material.dart';

class PostulationView extends StatefulWidget {
  static const String routeName = 'postulation_view';
  const PostulationView({super.key});

  @override
  State<PostulationView> createState() => _PostulationViewState();
}

class _PostulationViewState extends State<PostulationView> {
  LoginResponse user = LoginData().user;

  Future<List<dynamic>> getMyPostulations(int userId) async {
    int idUser = userId;
    List<dynamic> postulations =
        await PostulationService().getPostulationsByWorkerId(idUser);
    List<dynamic> myPostulations = [];
    for (var postulation in postulations) {
      myPostulations.add(postulation['post']);
    }
    return myPostulations;
  }

  @override
  void initState() {
    super.initState();
    LoginData().loadSession().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Postulaciones'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getMyPostulations(user.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar postulaciones'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontraron postulaciones'));
          } else {
            final postulations = snapshot.data!;
            return ListView.builder(
              itemCount: postulations.length,
              itemBuilder: (context, index) {
                return _PostulationCard(
                  postulation: postulations[index],
                  textTheme: textTheme,
                  role: user.userRole,
                  userId: user.id,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class _PostulationCard extends StatelessWidget {
  const _PostulationCard(
      {required this.postulation,
      required this.textTheme,
      required this.role,
      required this.userId});

  final dynamic postulation;
  final TextTheme textTheme;
  final String role;
  final int userId;

  Post dynamicToPost(dynamic postulation) {
    return Post(
      id: postulation['id'],
      title: postulation['title'],
      description: postulation['description'],
      subtitle: postulation['subtitle'],
      imgUrl: postulation['imgUrl'],
      employerId: postulation['employerId'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.amber.shade700.withOpacity(0.35),
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(postulation['imgUrl']),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postulation['title'],
                        style: textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        postulation['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _PostButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetailPage(
                                    post: dynamicToPost(postulation),
                                    role: role,
                                    workerId: userId,
                                  ),
                                ),
                              );
                            },
                            text: 'Ver Publicación',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  final buttonStyle = ButtonStyle(
    minimumSize: WidgetStateProperty.resolveWith(
      (states) => const Size(110, 30),
    ),
  );

  _PostButton({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
