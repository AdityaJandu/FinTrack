class AppValidator {
  String? validateUserName(value) {
    if (value!.isEmpty) {
      return 'Please enter an e-Mail';
    }

    return null;
  }

  String? validateEmail(value) {
    if (value!.isEmpty) {
      return 'Please enter an e-Mail';
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhoneNumber(value) {
    if (value!.isEmpty) {
      return 'Please enter an e-Mail';
    }

    if (value.length != 10) {
      return 'Please enter a password';
    }
    return null;
  }

  String? validatePassword(value) {
    if (value!.isEmpty) {
      return 'Please enter password';
    }

    return null;
  }

  String? validateTitle(value) {
    if (value!.isEmpty) {
      return 'Please fill details';
    }

    return null;
  }
}
