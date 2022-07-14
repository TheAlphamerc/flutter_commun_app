// ignore_for_file: dead_code

part of 'post_feed_cubit.dart';

enum EPostFeedState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

const _$EAppStateTypeMap = {EPostFeedState.loading: 'loading'};

extension EAppStateHelper on EPostFeedState {
  String? encode() => _$EAppStateTypeMap[this];

  EPostFeedState key(String value) => decodeEAppState(value);

  EPostFeedState decodeEAppState(String value) {
    return _$EAppStateTypeMap.entries
        .singleWhere((element) => element.value == value)
        .key;
  }

  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function() loaded,
    required T Function() error,
  }) {
    switch (this) {
      case EPostFeedState.initial:
        return initial.call();
        break;
      case EPostFeedState.loading:
        return loading.call();
        break;
      case EPostFeedState.loaded:
        return loaded.call();
        break;
      case EPostFeedState.error:
        return error.call();
        break;
      default:
    }
    throw Exception("Unknown EPostFeedState");
  }

  T mayBeWhen<T>({
    required T Function() elseMaybe,
    T Function()? initial,
    T Function()? loading,
    T Function()? loaded,
    T Function()? loadingMore,
    T Function()? error,
  }) {
    switch (this) {
      case EPostFeedState.loading:
        if (loading != null) {
          return loading.call();
        } else {
          return elseMaybe();
        }
        break;
      case EPostFeedState.initial:
        if (initial != null) {
          return initial.call();
        } else {
          return elseMaybe();
        }
        break;
      case EPostFeedState.loaded:
        if (loaded != null) {
          return loaded.call();
        } else {
          return elseMaybe();
        }
        break;
      case EPostFeedState.error:
        if (error != null) {
          return error.call();
        } else {
          return elseMaybe();
        }
        break;
      case EPostFeedState.loadingMore:
        if (loadingMore != null) {
          return loadingMore.call();
        } else {
          return elseMaybe();
        }
        break;
      default:
        return elseMaybe();
    }
  }
}
