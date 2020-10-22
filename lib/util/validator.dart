class Validator {
  static String emailValidator(String value) {
    const Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return "Email format is invalid";
    } else {
      return null;
    }
  }

  static String commentValidator(String value) {
    if (value.isEmpty) {
      return 'Comment can\'t be empty';
    } else {
      return null;
    }
  }

  static String pwdValidator(String value) {
    if (value.length < 8) {
      return "Password must be longer than 8 characters";
    } else {
      return null;
    }
  }

  static String pinValidator(String value) {
    if (value.length < 4) {
      return "Pin is incorrect";
    } else {
      return null;
    }
  }

  static String mobileValidator(String value) {
    String patttern = r'(^0\d{9}|d{10}$)';
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid mobile number (Malaysia)';
    }
    return null;
  }

  static String ageValidator(String value) {
    String patttern = r'(^(0?[1-9]|[1-9][0-9]|[1][1-9][1-9]|120)$)';
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return 'Please enter age';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid age';
    }
    return null;
  }

  static String nricValidator(String value) {
    String patttern =
        r'(([[0-9]{2})(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01]))([0-9]{2})([0-9]{4})';
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return 'Please enter NRIC number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid NRIC number';
    }
    return null;
  }

  static String foodNameValidator(String value) {
    if (value.length < 30) {
      if (value.isEmpty) {
        return 'Food name can\'t be empty';
      } else {
        return null;
      }
    }
    return 'Food name cannot be longer than 30 characters';
  }

  static String usernameValidator(String value) {
    if (value.isEmpty) {
      return 'username can\'t be empty';
    } else {
      return null;
    }
  }

  static String addressValidator(String value) {
    if (value.isEmpty) {
      return 'Address field cannot be empty';
    } else {
      return null;
    }
  }

  static String bankNameValidator(String value) {
    if (value.isEmpty) {
      return 'Bank Name field cannot be empty';
    } else {
      return null;
    }
  }

  static String bankAccValidator(String value) {
    if (value.isEmpty) {
      return 'Bank Account field cannot be empty';
    } else {
      return null;
    }
  }

}

class MobileValidator {
  static String malaysiaMobilePattern = r'^(((\+)?6)?01)[0-46-9]\-*[0-9]{7,8}$';
  // static String _mmobileNonCountry = r'^(01)[0-46-9]\-*\d{7,8}$';

  static String Function(String) mobileValidator = (String value) {
    // String pattern = r'(^0\d{9}|d{10}$)';
    RegExp regExp = RegExp(malaysiaMobilePattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid mobile number (Malaysia)';
    }
    return null;
  };

  /// transform mobile into full format
  /// return null if RegExp not match
  static String mobileTransform(String value) {
    value = value.replaceAll(r'\-*', '');
    RegExp regExp = RegExp(malaysiaMobilePattern);
    if (value.isEmpty) {
      return null;
    } else if (!regExp.hasMatch(value)) {
      return null;
    }
    if(value.substring(0, 2) == '+6') return value;
    if(value.substring(0, 1) == '6') return '+'+value;
    return '+6'+value;
  }

  // static Map<String, String Function(String)> mobileValidator = {
  //   '+60': (String value) {
  //     String pattern = r'(^\d{9,10}$)';
  //     RegExp regExp = RegExp(pattern);
  //     if (value.isEmpty) {
  //       return 'Please enter mobile number';
  //     } else if (!regExp.hasMatch(value)) {
  //       return 'Please enter a valid mobile number';
  //     }
  //     return null;
  //   },
  //   '+65': (String value) {
  //     String pattern = r'(^\d{8}$)';
  //     RegExp regExp = RegExp(pattern);
  //     if (value.isEmpty) {
  //       return 'Please enter mobile number';
  //     } else if (!regExp.hasMatch(value)) {
  //       return 'Please enter a valid mobile number';
  //     }
  //     return null;
  //   }
  // };
}