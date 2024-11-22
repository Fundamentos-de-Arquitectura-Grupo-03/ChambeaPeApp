import 'package:chambeape/presentation/shared/enums/enum.dart';
import 'package:get/get.dart';

String? customValidator(String? value, String field) {
  if (value == null || value.isEmpty || value.trim().isEmpty) {
    return 'Por favor ingresa tu $field';
  }
  return null;
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty || value.trim().isEmpty) {
    return 'Por favor ingresa tu correo';
  }
  final emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );
  if (!emailRegExp.hasMatch(value)) {
    return 'Por favor ingresa un correo válido';
  }
  return null;
}

String? dniValidator(String? value) {
  if (value == null || value.isEmpty || value.trim().isEmpty) {
    return 'Por favor ingresa tu DNI';
  }
  final dniRegExp = RegExp(
    r'^\d{8}$',
  );
  if (!dniRegExp.hasMatch(value)) {
    return 'Por favor ingresa un DNI válido';
  }
  return null;
}

String? birthDateValidator(String? value) {
  print(value);
  if (value == null || value.isEmpty || value.trim().isEmpty) {
    return 'Por favor ingresa tu fecha de nacimiento';
  }
  final birthDateRegExp = RegExp(
    r'^\d{2}/\d{2}/\d{4}$',
  );
  List<String> dateParts = value.split('/');
  if (dateParts.length != 3 || !birthDateRegExp.hasMatch(value)) {
    return 'Por favor ingresa una fecha de nacimiento válida';
  }

  int day = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int year = int.parse(dateParts[2]);

  DateTime birthDate = DateTime(year, month, day);
  DateTime eighteenYearsAgo = DateTime.now().subtract(Duration(days: 18 * 365));

  if (birthDate.isAfter(eighteenYearsAgo)) {
    return 'Debes ser mayor de edad';
  }

  return null;
}

String? negotiationDateValidator(String? value, int maxNegotiationDaysAhead, {required DateType dateType}) {
  if (value == null || value.isEmpty || value.trim().isEmpty) {
    return 'Por favor, ingresa una fecha válida';
  }
  final dateRegExp = RegExp(
    r'^\d{2}/\d{2}/\d{4}$',
  );
  List<String> dateParts = value.split('/');
  if (dateParts.length != 3 || !dateRegExp.hasMatch(value)) {
    return 'Por favor, ingresa una fecha válida';
  }

  int day = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int year = int.parse(dateParts[2]);

  DateTime selectedDate = DateTime(year, month, day);
  DateTime now = DateTime.now();
  Duration timeAheadFromNow = selectedDate.difference(DateTime(now.year, now.month, now.day));

  if(timeAheadFromNow.isNegative) {
    return 'La fecha seleccionada no puede ser anterior a la fecha actual';
  }

  if (dateType == DateType.start && timeAheadFromNow.inDays.isGreaterThan(maxNegotiationDaysAhead)) {
    return 'El inicio del trabajo debe realizarse como máximo en los próximos $maxNegotiationDaysAhead días';
  }

  return null;
}

String? remunerationValidator(String? value){
  if (value == null || value.isEmpty) {
    return 'Por favor, ingrese la remuneración';
  }
  return null;
}
