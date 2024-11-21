import 'package:chambeape/config/utils/login_user_data.dart';
import 'package:chambeape/infrastructure/models/negotiation_state.dart';
import 'package:chambeape/infrastructure/models/login/login_response.dart';
import 'package:chambeape/presentation/screens/4_deals/widgets/deal_card.dart';
import 'package:chambeape/services/negotiation/negotiation_service.dart';
import 'package:flutter/material.dart';

class DealView extends StatefulWidget {
  static const String routeName = 'deal_view';

  const DealView({super.key});

  @override
  State<DealView> createState() => _DealViewState();
}

class _DealViewState extends State<DealView> {
  LoginResponse user = LoginData().user;
  Future<List<NegotiationState>>? futureContracts;

  @override
  void initState() {
    super.initState();
    LoginData().loadSession().then((value) {
      setState(() {
        user = value;
        futureContracts =
            NegotiationService().getAllNegotiationsAndPostsByUserId(user.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Negociaciones'),
      ),
      body: futureContracts == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<NegotiationState>>(
              future: futureContracts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No negotiations found.'));
                } else {
                  return DealCardWidget(
                    negotiations: snapshot.data!,
                  );
                }
              },
            ),
    );
  }
}
