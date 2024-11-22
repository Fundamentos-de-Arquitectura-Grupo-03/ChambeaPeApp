import 'package:chambeape/infrastructure/models/workers.dart';
import 'package:chambeape/presentation/shared/widgets/user_card_widget.dart';
import 'package:chambeape/services/postulation/postulation_service.dart';
import 'package:flutter/material.dart';
import 'package:chambeape/domain/entities/posts_entity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;
  final String role;
  final int workerId;

  const PostDetailPage({
    super.key,
    required this.post,
    required this.role,
    required this.workerId,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Future<bool> userHasPostulated() async {
    final postulation = await PostulationService()
        .getPostulationByPostIdAndWorkerId(widget.post.id, widget.workerId);
    return postulation != null;
  }

  Future<List<Workers>> getPostulations() async {
    List<Workers> workers = [];
    final postulations = await PostulationService()
        .getPostulationsByPostId(widget.post.id);
    for (var postulation in postulations) {
      workers.add(Workers.fromJson(postulation['worker']));
    }
    return workers;
  }

  Widget _buildPostulationsList() {
    return FutureBuilder<List<Workers>>(
      future: getPostulations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SpinKitThreeBounce(
            color: Colors.amber,
            size: 20,
          );
        } else if (snapshot.hasError) {
          return const Text('Error al cargar los postulantes');
        } else {
          List<Workers> workers = snapshot.data ?? [];
          if (workers.isEmpty) {
            return const Text(
              'No hay postulantes',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            );
          }
          return ListView.builder(
            itemCount: workers.length,
            itemBuilder: (context, index) {
              return UserCardWidget(worker: workers[index]);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descripción'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: Image.network(
                widget.post.imgUrl,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.post.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (widget.role == 'E') ...[
              const Text(
                'Chambeadores Postulados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: _buildPostulationsList(),
              ),
            ] else if (widget.role == 'W') ...[
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: FutureBuilder<bool>(
                    future: userHasPostulated(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SpinKitThreeBounce(
                          color: Colors.amber,
                          size: 20,
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Error al cargar la postulación');
                      } else {
                        bool hasPostulated = snapshot.data ?? false;
                        return hasPostulated
                            ? _DeletePostualteButton(
                                onPressed: () => _showDeleteDialog(context),
                              )
                            : _PostulateButton(
                                onPressed: () => _showPostulateDialog(context),
                              );
                      }
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPostulateDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Postular'),
          content:
              const Text('¿Estás seguro de postularte a esta publicación?'),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                await PostulationService()
                    .createPostulation(widget.post.id, widget.workerId);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Postular'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar postulación'),
          content: const Text('¿Estás seguro de eliminar esta postulación?'),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                await PostulationService()
                    .deletePostulation(widget.post.id, widget.workerId);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}

class _PostulateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _PostulateButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: const Text('Postular', style: TextStyle(fontSize: 18)),
    );
  }
}

class _DeletePostualteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DeletePostualteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: const Text('Eliminar postulación', style: TextStyle(fontSize: 18)),
    );
  }
}
