import 'package:chambeape/infrastructure/models/login/login_response.dart';
import 'package:chambeape/infrastructure/models/negotiation_state.dart';
import 'package:chambeape/infrastructure/models/users.dart';
import 'package:chambeape/presentation/screens/4_deals/widgets/deal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:chambeape/config/utils/login_user_data.dart';
import 'package:chambeape/services/negotiation/negotiation_service.dart';

class DealCardWidget extends StatefulWidget {
  final List<NegotiationState> negotiations;

  const DealCardWidget({
    super.key,
    required this.negotiations,
  });

  @override
  State<DealCardWidget> createState() => _DealCardWidgetState();
}

class _DealCardWidgetState extends State<DealCardWidget> {
  LoginResponse? user;
  late Future<void> _futureNegotiations;

  List<NegotiationState> acceptedNegotiations = [];
  List<NegotiationState> pendingNegotiations = [];

  @override
  void initState() {
    super.initState();
    _futureNegotiations = _loadSessionAndNegotiations();
  }

  Future<void> _loadSessionAndNegotiations() async {
    final loginResponse = await LoginData().loadSession();
    setState(() {
      user = loginResponse;
    });

    _updateNegotiations();
  }

  void _updateNegotiations() {
    acceptedNegotiations = widget.negotiations
        .where((negotiation) => negotiation.state == 'ACCEPTED')
        .toList();

    pendingNegotiations = widget.negotiations
        .where((negotiation) => negotiation.state == 'PENDING')
        .toList();
  }

  Future<void> _refreshNegotiations() async {
    final updatedNegotiations =
        await NegotiationService().getAllNegotiationsAndPostsByUserId(user!.id);
    setState(() {
      widget.negotiations.clear();
      widget.negotiations.addAll(updatedNegotiations);
      _updateNegotiations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<void>(
      future: _futureNegotiations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          if (acceptedNegotiations.isEmpty && pendingNegotiations.isEmpty) {
            return Center(
              child: Text(
                'No tienes ninguna negociación registrada',
                style: textTheme.bodyMedium,
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                if (pendingNegotiations.isNotEmpty) ...[
                  Text('Pendientes', style: textTheme.titleMedium),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pendingNegotiations.length,
                    itemBuilder: (context, index) {
                      final negotiation = pendingNegotiations[index];
                      return _PostCard(
                        negotiation: negotiation,
                        textTheme: textTheme,
                        user: user,
                        refreshNegotiations: _refreshNegotiations,
                      );
                    },
                  ),
                ],
                if (acceptedNegotiations.isNotEmpty) ...[
                  Text('Aceptadas', style: textTheme.titleMedium),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: acceptedNegotiations.length,
                    itemBuilder: (context, index) {
                      final negotiation = acceptedNegotiations[index];
                      return _PostCard(
                        negotiation: negotiation,
                        textTheme: textTheme,
                        user: user,
                        refreshNegotiations: _refreshNegotiations,
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        }
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.negotiation,
    required this.textTheme,
    required this.user,
    required this.refreshNegotiations,
  });

  final NegotiationState negotiation;
  final TextTheme textTheme;
  final LoginResponse? user;
  final VoidCallback refreshNegotiations;

  @override
  Widget build(BuildContext context) {
    final post = negotiation.post;
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
                  backgroundImage: NetworkImage(post.imgUrl),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        post.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _DealButton(
                            onPressed: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  Users otherUser;
                                  Users currentUser;
                                  if (user?.userRole == 'W') {
                                    otherUser = Users(
                                      id: negotiation.employerId,
                                      firstName: '',
                                      lastName: '',
                                      email: '',
                                      phoneNumber: '',
                                      birthdate: DateTime.now(),
                                      gender: '',
                                      profilePic: '',
                                      description: '',
                                      userRole: 'E',
                                      dni: '',
                                    );
                                    currentUser = Users(
                                      id: user?.id,
                                      firstName: '',
                                      lastName: '',
                                      email: '',
                                      phoneNumber: '',
                                      birthdate: user!.birthdate,
                                      profilePic: '',
                                      gender: '',
                                      description: '',
                                      userRole: 'W',
                                      dni: '',
                                    );
                                  } else {
                                    otherUser = Users(
                                      id: negotiation.workerId,
                                      firstName: '',
                                      lastName: '',
                                      email: '',
                                      phoneNumber: '',
                                      birthdate: DateTime.now(),
                                      profilePic: '',
                                      description: '',
                                      userRole: 'W',
                                      dni: '',
                                      gender: '',
                                    );
                                    currentUser = Users(
                                      id: user?.id,
                                      firstName: '',
                                      lastName: '',
                                      email: '',
                                      phoneNumber: '',
                                      birthdate: user!.birthdate,
                                      profilePic: '',
                                      gender: '',
                                      description: '',
                                      userRole: 'E',
                                      dni: '',
                                    );
                                  }
                                  return DealDialog(
                                    currentUser: currentUser,
                                    otherUser: otherUser,
                                  );
                                },
                              );
                              if (result == true) {
                                refreshNegotiations();
                              }
                            },
                            text: 'Ver',
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

class _DealButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  final buttonStyle = ButtonStyle(
    minimumSize: WidgetStateProperty.resolveWith(
      (states) => const Size(110, 30),
    ),
  );

  _DealButton({
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
