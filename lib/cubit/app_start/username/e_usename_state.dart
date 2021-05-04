part of 'username_cubit.dart';

// ignore: constant_identifier_names
enum EUsernameState { AlreadyExists, Available, Error }

extension EUsernameStateHelpers on EUsernameState {
  T when<T>({
    T Function() alreadyExists,
    @required T Function() elseMaybe,
    T Function() available,
    T Function() accountCreated,
  }) {
    switch (this) {
      case EUsernameState.AlreadyExists:
        if (alreadyExists != null) {
          return alreadyExists.call();
        } else {
          if (elseMaybe != null) return elseMaybe.call();
        }
        break;
      case EUsernameState.Available:
        if (available != null) {
          return available.call();
        } else {
          if (elseMaybe != null) return elseMaybe.call();
        }
        break;
      default:
        return elseMaybe();
    }
    return null;
  }
}
