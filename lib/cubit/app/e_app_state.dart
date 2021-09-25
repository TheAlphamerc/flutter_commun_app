// import 'package:freezed_annotation/freezed_annotation.dart';
part of 'app_cubit.dart';

enum EAppState {
  loggedIn,
  loggedOut,
  notDetermined,
}
const _$EAppStateTypeMap = {EAppState.loggedIn: 'loggedIn'};

extension EAppStateHelper on EAppState {
  String? encode() => _$EAppStateTypeMap[this];

  EAppState key(String value) => decodeEAppState(value);

  EAppState decodeEAppState(String value) {
    return _$EAppStateTypeMap.entries
        .singleWhere((element) => element.value == value)
        .key;
  }

  T when<T>({
    required T Function() loggedIn,
    required T Function() loggedOut,
    required T Function() notDetermined,
  }) {
    switch (this) {
      case EAppState.loggedIn:
        return loggedIn.call();
      case EAppState.loggedOut:
        return loggedOut.call();
      case EAppState.notDetermined:
        return notDetermined.call();
      default:
    }
    throw Exception('Invalid EAppState');
  }

  T mayBeWhen<T>({
    required T Function() elseMaybe,
    T Function()? loggedIn,
    T Function()? loggedOut,
    T Function()? notDetermined,
  }) {
    switch (this) {
      case EAppState.loggedIn:
        if (loggedIn != null) {
          return loggedIn.call();
        } else {
          return elseMaybe();
        }
      case EAppState.loggedOut:
        if (loggedOut != null) {
          return loggedOut.call();
        } else {
          return elseMaybe();
        }
      case EAppState.notDetermined:
        if (notDetermined != null) {
          return notDetermined.call();
        } else {
          return elseMaybe();
        }
      default:
        return elseMaybe();
    }
  }
}
