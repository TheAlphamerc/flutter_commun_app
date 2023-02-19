import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension OptionHelper<T> on Option<T> {
  T? get valueOrDefault => fold(() => null, (a) => a);
}

extension StringHelper on String? {
  String? takeOnly(int value) {
    if (this != null && this!.length >= value) {
      return this!.substring(0, value);
    } else {
      return this;
    }
  }

  bool get isNotNullEmpty => this != null && this!.isNotEmpty;

  String get toPostTime {
    if (this == null || this!.isEmpty) {
      return '';
    }
    final dt = DateTime.parse(this!).toLocal();
    final dat =
        '${DateFormat.jm().format(dt)} - ${DateFormat("dd MMM yy").format(dt)}';
    return dat;
  }

  String get toHMTime {
    if (this == null || this!.isEmpty) {
      return '';
    }
    final dt = DateTime.parse(this!).toLocal();
    final dat = DateFormat("hh:mm:ss").format(dt);
    return dat;
  }

  String get toCommentTime {
    if (this == null || this!.isEmpty) {
      return '';
    }
    final dt = DateTime.parse(this!).toLocal();
    final dat = DateFormat.jm().format(dt);
    return dat;
  }

  DateTime? get toDateTime => this == null ? null : DateTime.tryParse(this!);
}

extension ListHelper<T> on List<T>? {
  Option<List<T>> get value {
    if (this != null && this!.isNotEmpty) {
      return some(this!);
    } else {
      return none();
    }
  }

  /// Check if list is not null and not empty
  bool get notNullAndEmpty => this != null && this!.isNotEmpty;

  bool get isNotNullEmpty => this != null && this!.isNotEmpty;

  /// Returns the absolute value of the list or empty list
  /// ```dart
  /// final list1 = null;
  /// final result = list1 ?? [];
  /// print(result); // []
  /// ```
  /// OR
  ///
  /// ```dart
  /// final list1 = null;
  /// final list2 = lis1.getAbsoluteOrEmpty;
  /// print(result); // []
  /// ```
  /// Both above examples will return the same result.
  /// ```dart
  List<T> get getAbsoluteOrEmpty =>
      value.fold(() => <T>[], (a) => List<T>.from(a));

  /// Returns the absolute value of the list or null value.
  /// ```dart
  /// final list1 = [1, 2, 3];
  /// final result = List<int>.from(list1);
  /// print(result); // [1, 2, 3]
  ///
  /// OR
  ///
  /// final list1 = [1, 2, 3];
  /// final result = lis1.getAbsoluteOrNull;
  /// print(result); // [1, 2, 3]
  /// ```
  /// Both above examples will return the same result.
  List<T>? get getAbsoluteOrNull =>
      value.fold(() => null, (a) => List<T>.from(a));

  Widget on({
    Widget Function()? nul,
    Widget Function()? empty,
    Widget Function()? value,
  }) {
    if (this == null) {
      return nul!.call();
    } else if (this!.isEmpty) {
      return empty!.call();
    } else {
      return value!.call();
    }
  }
}

extension DateTimeExtension on DateTime? {
  String? format([String pattern = 'dd/MM/yyyy']) {
    if (this == null) {
      return null;
    }
    return DateFormat(pattern).format(this!);
  }
}
