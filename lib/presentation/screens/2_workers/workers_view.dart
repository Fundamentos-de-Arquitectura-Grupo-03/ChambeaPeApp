import 'package:chambeape/infrastructure/models/workers.dart';
import 'package:chambeape/presentation/shared/widgets/user_card_widget.dart';
import 'package:chambeape/services/users/worker_service.dart';
import 'package:flutter/material.dart';

class WorkersView extends StatefulWidget {
  const WorkersView({super.key});

  static const String routeName = 'workers_view';

  @override
  State<WorkersView> createState() => _WorkersViewState();
}

class _WorkersViewState extends State<WorkersView> {
  late Future<List<Workers>> futureWorkers;

  @override
  void initState() {
    super.initState();
    futureWorkers = getWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Workers>>(
        future: futureWorkers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Workers worker = snapshot.data![index];
                return UserCardWidget(worker: worker);
              },
            );
          }
        },
      ),
    );
  }
}
