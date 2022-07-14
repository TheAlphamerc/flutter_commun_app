part of 'username_cubit.dart';

// ignore: constant_identifier_names
enum EUsernameState { AlreadyExists, Available, Error }

extension EUsernameStateHelpers on EUsernameState {
  T when<T>({
    required T Function() alreadyExists,
    required T Function() available,
    required T Function() accountCreated,
    required T Function() error,
  }) {
    switch (this) {
      case EUsernameState.AlreadyExists:
        return alreadyExists.call();

      case EUsernameState.Available:
        return available.call();
      case EUsernameState.Error:
        return error.call();
    }
  }
}
