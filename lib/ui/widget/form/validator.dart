// ignore_for_file: unnecessary_raw_strings

import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';

class KValidator {
  static String? optional(String value) => null;

  static String? nameValidator(String? value) {
    if (value!.isEmpty) {
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
  }

  static String? emailValidator(String? value) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value!)) {
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
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return "Password field is required";
    }
    // else if (value.length < 8) {
    //   return "Invalid passwordLessThan";
    // }

    return null;
  }

  static String? urlValidator(String? value) {
    if (value!.isEmpty) {
      return null;
    } else if (!RegExp(
            r"^(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)")
        .hasMatch(value)) {
      return "Invalid Url format";
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value!.isEmpty) {
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
  }

  static String? canNotEmptyTextValidator(String? value) {
    if (value!.isEmpty) {
      return "Field can not be empty";
    }
    return null;
  }

  String? forgotPasswordValidators(String? value) {
    if (value!.isEmpty) {
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

    return null;
  }

  static String? buildValidators(String? value,
      {required FieldType choice, required BuildContext context}) {
    switch (choice) {
      case FieldType.name:
        return nameValidator(value);
      case FieldType.email:
        return emailValidator(value);
      case FieldType.password:
        return passwordValidator(value);
      case FieldType.url:
        return urlValidator(value);
      case FieldType.phone:
        return phoneValidator(value);
      case FieldType.text:
        return canNotEmptyTextValidator(value);
      case FieldType.confirmPassword:
        return passwordValidator(value);
      default:
        return null;
    }
  }
}
