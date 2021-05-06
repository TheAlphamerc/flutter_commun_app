import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';

class KValidator {
  static String Function(String) buildValidators(
      BuildContext context, FieldType choice) {
    // final "Invalid =" AppLocalizations.of(context);
    final String Function(String) optional = (String val) => null;

    final String Function(String) emailValidators = (String value) {
      if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return "Invalid email format";
      }
      if (value.isEmpty) {
        return "email field can not be empty";
      }
      if (!value.startsWith(RegExp(r'[A-Za-z]'))) {
        return "Invalid email format";
      }
      if (value.length > 42) {
        return "email length is too long";
      }
      if (value.length < 6) {
        return "email length is too short";
      }
      if (!value.contains("@")) {
        return "Invalid email format";
      }
      return null;
    };

    final String Function(String) urlValidators = (String value) {
      if (value.isEmpty) {
        return null;
      } else if (!RegExp(
              r"^(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)")
          .hasMatch(value)) {
        return "Invalid Url format";
      }
      return null;
    };

    final String Function(String) nameValidators = (String value) {
      if (value.isEmpty) {
        return "Name field can not be empty";
      }
      if (value.length > 32) {
        return "Name length can not be greter then 32";
      }
      // ignore: unnecessary_raw_strings
      if (!value.startsWith(RegExp(r'[A-za-z]'))) {
        return "Invalid name format";
      }
      if (value.length < 3) {
        return "Name length can not be lesser then 3 charater";
      }
      // ignore: unnecessary_raw_strings
      if (value.contains(RegExp(r'[0-9]'))) {
        return "Invalid name format";
      }

      return null;
    };

    String Function(String) phoneValidtors = (String value) {
      if (value.isEmpty) {
        return "Mobile field can not be empty";
      }
      if (value.length < 10) {
        return "Mobile field length can not be lesser then 10 character";
      }
      if (value.contains(RegExp(r'[A-Z]')) ||
          value.contains(RegExp(r'[a-z]')) ||
          value.contains(".")) {
        return "Invalid mobile format";
      }
      if (value.length > 10) {
        return "Mobile field length can not be greter then 10";
      }
      if (!RegExp(r"[0-9]{10}").hasMatch(value)) {
        return "Invalid mobile field";
      }
      if (!value.startsWith(RegExp(r"[0-9]"))) {
        return "Invalid mobile field";
      }
      return null;
    };

    String Function(String) passwordValidators = (String value) {
      if (value.isEmpty) {
        return "Password field is required";
      }
      // else if (value.length < 8) {
      //   return "Invalid passwordLessThan";
      // }

      return null;
    };

    String Function(String) confirmPasswordValidators = (String value) {
      if (value.isEmpty) {
        return "Invalid fieldEmptyText";
      } else if (value.length < 8) {
        return "Invalid passwordLessThan";
      }

      return null;
    };
    String Function(String) canNotEmptyTextValidator = (String value) {
      if (value.isEmpty) {
        return "Field can not be empty";
      }
      // else if (value.length < 8) {
      //   return "Invalid passwordLessThan";
      // }

      return null;
    };
    String Function(String) forgotPasswordValidators = (String value) {
      if (value.isEmpty) {
        return "Invalid fieldEmptyText";
      }
      //For Number

      if (value.startsWith(RegExp(r"[0-9]"))) {
        if (!RegExp(r"^[0-9]{10}").hasMatch(value)) {
          return "Invalid invalidPhoneNumber";
        }
        if (value.length < 10) {
          return "Invalid phoneNumberMustBeLess";
        }
        if (value.length > 10) {
          return "Invalid invalidPhoneNumber";
        }

        if (value.contains(RegExp(r'[A-Z]')) ||
            value.contains(RegExp(r'[a-z]')) ||
            value.contains(".com")) {
          return "Invalid onlyTenDigits";
        }

        return null;
      }

      //for email
      if (!value.startsWith(RegExp(r'[A-Z][a-z]'))) {
        if (!RegExp(
                r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
            .hasMatch(value)) {
          return "Invalid invalidEmail";
        }
        if (value.length > 32) {
          return "Invalid emailMustBeLessThan";
        }
        if (value.length < 6) {
          return "Invalid emailIsShort";
        }
        // if (!value.contains("@")) {
        //   return "Invalid invalidEmail";
        // }
        // if (!value.contains(".com")) {
        //   return "Invalid invalidEmail";
        // }

        return null;
      }

      return null;
    };

    if (choice == FieldType.name) return nameValidators;
    if (choice == FieldType.url) return urlValidators;
    if (choice == FieldType.email) return emailValidators;
    if (choice == FieldType.password) return passwordValidators;
    if (choice == FieldType.phone) return phoneValidtors;
    if (choice == FieldType.confirmPassword) return confirmPasswordValidators;
    if (choice == FieldType.reset) return forgotPasswordValidators;
    if (choice == FieldType.text) return canNotEmptyTextValidator;
    if (choice == FieldType.optional) return optional;

    return nameValidators;
  }
}
