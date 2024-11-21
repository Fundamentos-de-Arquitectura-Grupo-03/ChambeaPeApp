import 'package:chambeape/infrastructure/models/users.dart';
import 'dart:io';
import 'package:chambeape/presentation/screens/0_login/widgets/custom_radio_list_tile.dart';
import 'package:chambeape/presentation/screens/0_login/widgets/image_picker_widget.dart';
import 'package:chambeape/presentation/shared/enums/enum.dart';
import 'package:chambeape/presentation/shared/utils/custom_validators.dart';
import 'package:chambeape/services/media/MediaService.dart';
import 'package:chambeape/services/users/user_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chambeape/presentation/shared/constants/tos.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dniController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  UserRole selectedUserRole = UserRole.W;
  File? selectedImage;
  Gender selectedGender = Gender.M;
  bool obscureText = true;
  bool tosAccepted = false;

  Future<File?> getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    } else {
      return null;
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );

    if (pickedDate != null) {
      birthDateController.text =
          '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year.toString()}';
    }
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Términos y Condiciones'),
          content: const Stack(
            children: [
              Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(termsAndConditions),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomRadioListTile(
                    groupValue: UserRole.W,
                    value1: UserRole.W,
                    label1: "Chambeador",
                    value2: UserRole.E,
                    label2: "Empleador",
                    radioName: "Tipo de Cuenta",
                    onChanged: (UserRole value) {
                      selectedUserRole = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                    ),
                    validator: (value) => customValidator(value, 'nombre'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Apellido',
                    ),
                    validator: (value) => customValidator(value, 'apellido'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: dniController,
                    decoration: const InputDecoration(
                      labelText: 'DNI',
                    ),
                    validator: (value) => dniValidator(value),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: birthDateController,
                    validator: birthDateValidator,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de nacimiento',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    onTap: () {
                      _selectDate();
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                    ),
                    validator: (value) => customValidator(value, 'teléfono'),
                  ),
                  const SizedBox(height: 10),
                  CustomRadioListTile(
                    groupValue: Gender.M,
                    value1: Gender.M,
                    label1: "Hombre",
                    value2: Gender.F,
                    label2: "Mujer",
                    radioName: "Género",
                    onChanged: (Gender value) {
                      selectedGender = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  ImagePickerWidget(
                    onTap: () async {
                      final image = await MediaService().getImageFromGallery();
                      setState(() {
                        selectedImage = image;
                      });
                    },
                    selectedImage: selectedImage,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                    ),
                    validator: (value) => emailValidator(value),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'Contraseña',
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
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Descripción',
                    ),
                    minLines: 3,
                    maxLines: null,
                    validator: (value) => customValidator(value, 'descripción'),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: tosAccepted,
                        onChanged: (value) {
                          setState(() {
                            tosAccepted = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'He leído y acepto los ',
                            style: const TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'términos y condiciones',
                                style: TextStyle(color: Colors.amber.shade700),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _showTermsDialog(context);
                                  },
                              ),
                              const TextSpan(
                                text: ' de ChambeaPe',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          selectedImage != null &&
                          tosAccepted) {
                        Uri profilePicUri = await MediaService()
                            .saveFileToGoogleCloud(selectedImage!);
                        List<String> dateParts =
                            birthDateController.text.split('/');
                        int day = int.parse(dateParts[0]);
                        int month = int.parse(dateParts[1]);
                        int year = int.parse(dateParts[2]);

                        DateTime birthDate = DateTime(year, month, day);
                        Users newUser = Users(
                          firstName: nameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          phoneNumber: phoneController.text,
                          birthdate: birthDate,
                          gender: selectedGender.toString().split('.').last,
                          profilePic: profilePicUri.toString(),
                          description: descriptionController.text,
                          userRole: selectedUserRole.toString().split('.').last,
                          dni: dniController.text,
                          password: passwordController.text,
                        );
                        UserService().postUser(newUser).then(
                          (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Usuario registrado'),
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Error al registrar usuario: ${error.message}'),
                            ),
                          );
                        });
                      } else if (tosAccepted == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Por favor acepta los términos y condiciones'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (selectedImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor selecciona una imagen'),
                          ),
                        );
                      }
                    },
                    child: const Text('Registrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
