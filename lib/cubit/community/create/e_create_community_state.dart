part of 'create_community_cubit.dart';

enum ECreateCommunityState {
  initial,
  loading,
  loaded,
  error,
  saving,
  saved,
  addTopic,
  removeTpoic,
  addLink,
  removeLink
}

extension EAppStateHelper on ECreateCommunityState {
  T when<T>({
    required T Function() loading,
    required T Function() loaded,
    required T Function() erorr,
    required T Function() delete,
  }) {
    switch (this) {
      case ECreateCommunityState.loading:
        if (loading != null) {
          return loading.call();
        }
        break;
      case ECreateCommunityState.loaded:
        if (loaded != null) {
          return loaded.call();
        }
        break;
      case ECreateCommunityState.error:
        if (erorr != null) {
          return erorr.call();
        }
        break;

      default:
    }
    throw Exception('Invalid ECreateCommunityState');
  }

  T mayBeWhen<T>({
    required T Function() elseMaybe,
    T Function()? loading,
    T Function()? loaded,
    T Function()? erorr,
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
        break;
      case ECreateCommunityState.loaded:
        if (loaded != null) {
          return loaded.call();
        } else {
          return elseMaybe();
        }
        break;
      case ECreateCommunityState.error:
        if (erorr != null) {
          return erorr.call();
        } else {
          return elseMaybe();
        }
        break;

      case ECreateCommunityState.saving:
        if (saving != null) {
          return saving.call();
        } else {
          return elseMaybe();
        }
        break;
      case ECreateCommunityState.saved:
        if (saved != null) {
          return saved.call();
        } else {
          return elseMaybe();
        }
        break;
      default:
        return elseMaybe();
    }
  }
}
