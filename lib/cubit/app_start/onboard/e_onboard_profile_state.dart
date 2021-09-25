part of 'onboard_profile_cubit.dart';

enum EOnboardProfileState {
  // ignore: constant_identifier_names
  Updated,
  // ignore: constant_identifier_names
  Error,
  // ignore: constant_identifier_names
  ImageAdded,
}

extension EOnboardProfileState1Helper on EOnboardProfileState {
  T when<T>({
    required T Function() error,
    required T Function() updated,
  }) {
    switch (this) {
      case EOnboardProfileState.Updated:
        return updated.call();

      case EOnboardProfileState.Error:
        return error.call();

      default:
    }
    throw Exception('Unknown EOnboardProfileState : $this');
  }

  T mayBeWhen<T>({
    required T Function() elseMaybe,
    T Function()? error,
    T Function()? updated,
  }) {
    switch (this) {
      case EOnboardProfileState.Updated:
        if (updated != null) {
          return updated.call();
        } else {
          return elseMaybe();
        }

      case EOnboardProfileState.Error:
        if (error != null) {
          return error.call();
        } else {
          return elseMaybe();
        }

      default:
        return elseMaybe();
    }
  }
}
