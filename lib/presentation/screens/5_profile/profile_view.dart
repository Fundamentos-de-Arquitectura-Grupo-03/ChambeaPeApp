import 'package:chambeape/config/utils/login_user_data.dart';
import 'package:chambeape/infrastructure/models/users.dart';
import 'package:chambeape/presentation/screens/5_profile/widgets/profile_connect_button.dart';
import 'package:chambeape/presentation/screens/5_profile/widgets/profile_description.dart';
import 'package:chambeape/presentation/screens/5_profile/widgets/profile_my_works.dart';
import 'package:chambeape/presentation/screens/screens.dart';
import 'package:chambeape/services/users/user_service.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  final int userId;

  const ProfileView({
    super.key,
    this.userId = 0,
  });

  static const String routeName = 'profile_view';

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isCurrentUser = false;
  late Users profileUser;

  int userIdToUse = 0;

  Future<Users> _loadUserById() async {
    if (widget.userId != 0) {
      var user = await UserService().getUserById(widget.userId);
      profileUser = user;
      return user;
    } else {
      var session = await LoginData().loadSession();
      var userId = session.id;
      return await UserService().getUserById(userId);
    }
  }

  Future<bool> _isCurrentUserFunc() async {
    var session = await LoginData().loadSession();
    var isCurrentUser = session.id == widget.userId || widget.userId == 0;
    return isCurrentUser;
  }

  Future<int> _getUserId() async {
    if (widget.userId != 0) {
      return widget.userId;
    } else {
      var session = await LoginData().loadSession();
      return session.id;
    }
  }

  @override
  void initState() {
    super.initState();
    _isCurrentUserFunc().then((value) {
      setState(() {
        isCurrentUser = value;
      });
    });
    _getUserId().then((value) {
      setState(() {
        userIdToUse = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          if (isCurrentUser)
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, OptionsView.routeName);
              },
              icon: const Icon(Icons.settings_outlined, size: 30),
            ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: FutureBuilder<Users>(
          future: _loadUserById(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Error al cargar los datos del usuario'));
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              return SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.profilePic),
                      ),
                      const SizedBox(height: 10),
                      Text('${user.firstName} ${user.lastName}',
                          style: text.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      if (!isCurrentUser) ConnectButton(text: text, user: user),
                      const SizedBox(height: 10),
                      Description(user: user, text: text),
                      const SizedBox(height: 20),
                      MyWorksDefault(
                          text: text,
                          userId: userIdToUse,
                          isCurrentUser: isCurrentUser),
                    ]),
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No existen datos del usuario'));
            }
          },
        ),
      ),
    );
  }
}
