import 'package:chambeape/domain/entities/posts_entity.dart';
import 'package:chambeape/infrastructure/datasources/postsdb_datasource.dart';
import 'package:chambeape/infrastructure/models/negotiation.dart';
import 'package:chambeape/infrastructure/models/users.dart';
import 'package:chambeape/presentation/shared/enums/enum.dart';
import 'package:chambeape/presentation/shared/exceptions/no_posts_exception.dart';
import 'package:chambeape/services/negotiation/negotiation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DealDialog extends StatefulWidget {
  final Users? currentUser, otherUser;
  const DealDialog(
      {super.key, required this.currentUser, required this.otherUser});

  @override
  State<DealDialog> createState() => _DealDialogState();
}

class _DealDialogState extends State<DealDialog> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController remunerationController = TextEditingController();
  late Future<void> loadNegotiationDetails;
  late Negotiation negotiation = Negotiation(
    id: 0,
    workerId: 0,
    employerId: 0,
    startDay: DateTime.now(),
    endDay: DateTime.now(),
    salary: 0.0,
    state: NegotiationStatus.PENDING.name,
    postId: 0,
  );
  List<Post> posts = [];
  late int employerId, workerId;
  bool dataLoaded = false;

  Future<void> _loadNegotiationDetails() async {
    if (widget.currentUser != null && widget.otherUser != null) {
      if (widget.currentUser!.userRole == 'W') {
        employerId = widget.otherUser!.id ?? 0;
        workerId = widget.currentUser!.id ?? 0;
      } else {
        employerId = widget.currentUser!.id ?? 0;
        workerId = widget.otherUser!.id ?? 0;
      }
      negotiation = await NegotiationService()
          .getNegotiationByWorkerIdAndEmployerId(workerId, employerId);
      posts = await PostsdbDatasource().getPostsByEmployerId(employerId);
      if (posts.isEmpty) {
        throw NoPostsException();
      }
      if (negotiation.id != 0) {
        startDateController.text =
            DateFormat('dd/MM/yyyy').format(negotiation.startDay);
        endDateController.text =
            DateFormat('dd/MM/yyyy').format(negotiation.endDay);
        remunerationController.text = negotiation.salary.toString();
      }
    } else {
      throw Exception('Current user or other user is null');
    }
    setState(() {
      dataLoaded = true;
    });
  }

  void _acceptNegotiation() {
    setState(() {
      negotiation.state = NegotiationStatus.ACCEPTED.name;
    });
    NegotiationService().updateNegotiation(negotiation).then((_) {
      Navigator.of(context).pop(true);
    });
  }

  void _rejectNegotiation() {
    _deleteNegotiation();
  }

  void _deleteNegotiation() {
    NegotiationService().deleteNegotiation(negotiation.id).then((_) {
      Navigator.of(context).pop(true);
    });
  }

  @override
  void initState() {
    super.initState();
    loadNegotiationDetails = _loadNegotiationDetails();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          title: const Text('Negociación'),
          content: FutureBuilder<void>(
            future: loadNegotiationDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              } else if (snapshot.hasError) {
                if (snapshot.error is NoPostsException) {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                          child: Text(
                              'No puedes enviar una negociación debido a que no cuentas con ninguna publicación activa actualmente.')),
                    ],
                  );
                } else {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(child: Text('Error al cargar la información')),
                    ],
                  );
                }
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        negotiation.id == 0
                            ? const Text('Crea una nueva negociación')
                            : const Text(
                                'Detalles de la negociación existente'),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: startDateController,
                          decoration: const InputDecoration(
                            labelText: 'Fecha de inicio',
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: endDateController,
                          decoration: const InputDecoration(
                            labelText: 'Fecha de fin',
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: remunerationController,
                          decoration: const InputDecoration(
                            prefixText: 'S/ ',
                            labelText: 'Remuneración',
                            prefixIcon: Icon(Icons.monetization_on_outlined),
                          ),
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          actions: dataLoaded
              ? [
                  if (widget.currentUser?.userRole == 'W') ...[
                    if (negotiation.state ==
                        NegotiationStatus.PENDING.name) ...[
                      TextButton(
                        onPressed: _rejectNegotiation,
                        child: const Text('Rechazar'),
                      ),
                      TextButton(
                        onPressed: _acceptNegotiation,
                        child: const Text('Aceptar'),
                      ),
                    ] else if (negotiation.state ==
                        NegotiationStatus.ACCEPTED.name) ...[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ] else if (widget.currentUser?.userRole == 'E') ...[
                    if (negotiation.state ==
                        NegotiationStatus.PENDING.name) ...[
                      TextButton(
                        onPressed: _deleteNegotiation,
                        child: const Text('Eliminar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ] else if (negotiation.state ==
                        NegotiationStatus.ACCEPTED.name) ...[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ],
                ]
              : []);
    });
  }
}
