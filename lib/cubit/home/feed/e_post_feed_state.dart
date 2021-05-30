part of 'post_feed_cubit.dart';

enum EPostFeedState {
  loading,
  loaded,
  erorr,
}
const _$EAppStateTypeMap = {EPostFeedState.loading: 'loading'};

extension EAppStateHelper on EPostFeedState {
  String encode() => _$EAppStateTypeMap[this];

  EPostFeedState key(String value) => decodeEAppState(value);

  EPostFeedState decodeEAppState(String value) {
    return _$EAppStateTypeMap.entries
        .singleWhere((element) => element.value == value, orElse: () => null)
        ?.key;
  }

  T when<T>({
    @required T Function() loading,
    @required T Function() loaded,
    @required T Function() erorr,
  }) {
    switch (this) {
      case EPostFeedState.loading:
        if (loading != null) {
          return loading.call();
        }
        break;
      case EPostFeedState.loaded:
        if (loaded != null) {
          return loaded.call();
        }
        break;
      case EPostFeedState.erorr:
        if (erorr != null) {
          return erorr.call();
        }
        break;
      default:
    }
    return null;
  }

  T mayBeWhen<T>({
    @required T Function() elseMaybe,
    T Function() loading,
    T Function() loaded,
    T Function() erorr,
  }) {
    switch (this) {
      case EPostFeedState.loading:
        if (loading != null) {
          return loading.call();
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
      case EPostFeedState.erorr:
        if (erorr != null) {
          return erorr.call();
        } else {
          return elseMaybe();
        }
        break;
      default:
        return elseMaybe();
    }
  }
}
