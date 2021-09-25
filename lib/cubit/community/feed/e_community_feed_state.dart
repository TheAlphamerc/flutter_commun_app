part of 'community_feed_cubit.dart';

enum ECommunityFeedState {
  initial,
  loading,
  loaded,
  error,
  delete,
  communityJoined
}

extension EAppStateHelper on ECommunityFeedState {
  T when<T>({
    required T Function() loading,
    required T Function() loaded,
    required T Function() erorr,
    required T Function() delete,
  }) {
    switch (this) {
      case ECommunityFeedState.loading:
        if (loading != null) {
          return loading.call();
        }
        break;
      case ECommunityFeedState.loaded:
        if (loaded != null) {
          return loaded.call();
        }
        break;
      case ECommunityFeedState.error:
        if (erorr != null) {
          return erorr.call();
        }
        break;
      case ECommunityFeedState.delete:
        if (delete != null) {
          return delete.call();
        }
        break;
      default:
    }
    throw Exception('Invalid ECommunityFeedState');
  }

  T mayBeWhen<T>({
    required T Function() elseMaybe,
    T Function()? loading,
    T Function()? loaded,
    T Function()? erorr,
    T Function()? delete,
    T Function()? savingComment,
    T Function()? saved,
    T Function()? initial,
  }) {
    switch (this) {
      case ECommunityFeedState.initial:
        if (initial != null) {
          return initial();
        } else {
          return elseMaybe();
        }
        break;
      case ECommunityFeedState.loading:
        if (loading != null) {
          return loading.call();
        } else {
          return elseMaybe();
        }
        break;
      case ECommunityFeedState.loaded:
        if (loaded != null) {
          return loaded.call();
        } else {
          return elseMaybe();
        }
        break;
      case ECommunityFeedState.error:
        if (erorr != null) {
          return erorr.call();
        } else {
          return elseMaybe();
        }
        break;
      case ECommunityFeedState.delete:
        if (delete != null) {
          return delete.call();
        } else {
          return elseMaybe();
        }
        break;
      default:
        return elseMaybe();
    }
  }
}
