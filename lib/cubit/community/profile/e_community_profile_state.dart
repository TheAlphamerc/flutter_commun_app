part of 'community_profile_cubit.dart';

enum EcommunityProfileState { initial, loaded, loadingMore }
const _$EcommunityProfileStateTypeMap = {
  EcommunityProfileState.initial: 'initial'
};

extension EcommunityProfileStateHelper on EcommunityProfileState {
  String? encode() => _$EcommunityProfileStateTypeMap[this];

  EcommunityProfileState key(String value) =>
      decodeEcommunityProfileState(value);

  EcommunityProfileState decodeEcommunityProfileState(String value) {
    return _$EcommunityProfileStateTypeMap.entries
        .singleWhere((element) => element.value == value)
        .key;
  }

  T when<T>({
    required T Function() initial,
  }) {
    switch (this) {
      case EcommunityProfileState.initial:
        return initial.call();
      default:
    }
    throw Exception('Invalid EcommunityProfileState');
  }

  T mayBeWhen<T>({
    required T Function() elseMaybe,
    T Function()? initial,
    T Function()? loaded,
    T Function()? loadingMore,
  }) {
    switch (this) {
      case EcommunityProfileState.initial:
        if (initial != null) {
          return initial.call();
        } else {
          return elseMaybe();
        }
      case EcommunityProfileState.loaded:
        if (loaded != null) {
          return loaded.call();
        } else {
          return elseMaybe();
        }
      case EcommunityProfileState.loadingMore:
        if (loadingMore != null) {
          return loadingMore.call();
        } else {
          return elseMaybe();
        }
      default:
        return elseMaybe();
    }
  }
}
