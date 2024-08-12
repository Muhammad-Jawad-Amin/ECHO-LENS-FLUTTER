class Validators {
  static final RegExp _emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );

  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  static final RegExp _nameRegex = RegExp(
    r'^[A-Za-z]+(?:[-\s][A-Za-z]+)*$',
  );

  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return _passwordRegex.hasMatch(password);
  }

  static bool isValidName(String name) {
    return _nameRegex.hasMatch(name);
  }
}
