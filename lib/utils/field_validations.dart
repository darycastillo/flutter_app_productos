class FieldValidations {
  static emailField({required String value, String? textError}) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value) ? null : (textError ?? 'Correo inválido');
  }

  static passwordField({String? value}) => (value != null && value.length >= 6)
      ? null
      : 'La contraseña debe tener almenos 6 caracteres';
}
