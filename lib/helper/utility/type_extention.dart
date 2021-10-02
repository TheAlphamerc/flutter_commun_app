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
