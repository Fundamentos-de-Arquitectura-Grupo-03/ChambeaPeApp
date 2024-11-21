import 'package:chambeape/presentation/screens/0_login/register_view.dart';
import 'package:chambeape/presentation/shared/custom_navbar.dart';
import 'package:chambeape/presentation/shared/utils/custom_validators.dart';
import 'package:chambeape/services/login/login_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const String routeName = 'login_view';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        await login(emailController.text, passwordController.text);
        if (context.mounted) {
          context.goNamed(CustomNavbar.routeName);
        }
      } catch (e) {
        // TODO Implementar la funcionalidad de mostrar un mensaje de error aquí
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Agregar el logo de la aplicación
                  Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'assets/images/logo_white_letters.png'
                        : 'assets/images/logo.png',
                    width: 200,
                    height: 200,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Ingresa tu correo',
                    ),
                    validator: (value) => emailValidator(value),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'Ingresa tu contraseña',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ))),
                    obscureText: obscureText,
                    validator: (value) => customValidator(value, 'contraseña'),
                  ),
                  const SizedBox(height: 10),
                  LoginButton(
                    text: 'Iniciar sesión',
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 10),
                  LoginButton(
                    text: 'Registrarse',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterView(),
                          ));
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO Implementar la funcionalidad de recuperación de contraseña aquí
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.amber.shade700,
                    ),
                    child: const Text('¿Olvidaste tu contraseña?'),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 45,
          color: Colors.amber.shade700,
          child: Text(
            '© ${DateTime.now().year} DigitalDart Todos los derechos reservados',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const LoginButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      child: Text(text),
    );
  }
}
