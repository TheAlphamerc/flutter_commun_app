part of 'create_community_cubit.dart';

enum ECreateCommunityState {
  initial,
  loading,
  loaded,
  error,
  saving,
  saved,
  addTopic,
  removeTopic,
  addLink,
  removeLink
}

extension EAppStateHelper on ECreateCommunityState {
  T when<T>({
    required T Function() loading,
    required T Function() loaded,
    required T Function() error,
    required T Function() delete,
  }) {
    switch (this) {
      case ECreateCommunityState.loading:
        return loading.call();
      case ECreateCommunityState.loaded:
        return loaded.call();
      case ECreateCommunityState.error:
        return error.call();

      default:
    }
    throw Exception('Invalid ECreateCommunityState');
  }

  T mayBeWhen<T>({
    required T Function() elseMaybe,
    T Function()? loading,
    T Function()? loaded,
    T Function()? error,
    T Function()? delete,
    T Function()? saving,
    T Function()? saved,
  }) {
    switch (this) {
      case ECreateCommunityState.loading:
        if (loading != null) {
          return loading.call();
        } else {
          return elseMaybe();
        }
      case ECreateCommunityState.loaded:
        if (loaded != null) {
          return loaded.call();
        } else {
          return elseMaybe();
        }
      case ECreateCommunityState.error:
        if (error != null) {
          return error.call();
        } else {
          return elseMaybe();
        }

      case ECreateCommunityState.saving:
        if (saving != null) {
          return saving.call();
        } else {
          return elseMaybe();
        }
      case ECreateCommunityState.saved:
        if (saved != null) {
          return saved.call();
        } else {
          return elseMaybe();
        }
      default:
        return elseMaybe();
    }
  }
}
