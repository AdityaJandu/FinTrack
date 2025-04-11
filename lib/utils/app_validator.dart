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

  String? validateNotEmpty(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  String? validatePositiveNumber(String? value, {String fieldName = 'Value'}) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number for $fieldName';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number for $fieldName';
    }
    if (number <= 0) {
      return '$fieldName must be greater than zero';
    }
    return null;
  }

  String? validateTitle(String? value) {
    String? notEmpty = validateNotEmpty(value, fieldName: 'Title');
    if (notEmpty != null) {
      return notEmpty;
    }
    if (value!.length < 3) {
      return 'Title must be at least 3 characters';
    }
    return null;
  }
}
