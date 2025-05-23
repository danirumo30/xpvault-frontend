class ValidationService {
  static String? emailValidation(String? email) {
    if (email == null) {
      return "You must complete the field";
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(email)) {
      return "The indicated email is not valid";
    }
    return null;
  }

  static String? passwordValidation(String? password) {
    if (password == null) {
      return "You must complete the field";
    } else if (password.length < 6 ||
        !RegExp(r'^(?=.*[!@#\$%\^])').hasMatch(password)) {
      return "Minimum of 6 characters and at least one special character among these !@#\$%^";
    }
    return null;
  }

  static String? verificationCodeValidation(String? code) {
    if (code == null) {
      return "You must complete the field";
    } else if (code.length != 6) {
      return "Invalid verification code";
    }
    return null;
  }
}