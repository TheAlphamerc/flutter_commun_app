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
    required T Function() error,
    required T Function() delete,
  }) {
    switch (this) {
      case ECommunityFeedState.loading:
        return loading.call();
      case ECommunityFeedState.loaded:
        return loaded.call();
      case ECommunityFeedState.error:
        return error.call();
      case ECommunityFeedState.delete:
        return delete.call();
      default:
    }
    throw Exception('Invalid ECommunityFeedState');
  }

  T mayBeWhen<T>({
    required T Function() elseMaybe,
    T Function()? loading,
    T Function()? loaded,
    T Function()? error,
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

      case ECommunityFeedState.loading:
        if (loading != null) {
          return loading.call();
        } else {
          return elseMaybe();
        }
      case ECommunityFeedState.loaded:
        if (loaded != null) {
          return loaded.call();
        } else {
          return elseMaybe();
        }
      case ECommunityFeedState.error:
        if (error != null) {
          return error.call();
        } else {
          return elseMaybe();
        }
      case ECommunityFeedState.delete:
        if (delete != null) {
          return delete.call();
        } else {
          return elseMaybe();
        }
      default:
        return elseMaybe();
    }
  }
}
