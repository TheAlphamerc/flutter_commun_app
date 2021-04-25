part of 'username_cubit.dart';

enum EUsernameState { AlreadyExists, Available, UsernameCreated, Error }

extension EUsernameStateHelpers on EUsernameState {
  T when<T>({
    T Function() alreadyExists,
    @required T Function() elseMaybe,
    T Function() available,
    T Function() usernameCreated,
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
      case EUsernameState.UsernameCreated:
        if (usernameCreated != null) {
          return usernameCreated.call();
        } else {
          if (elseMaybe != null) return elseMaybe.call();
        }
        break;
      default:
        return elseMaybe();
    }
  }
}
