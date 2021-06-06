part of 'post_detail_cubit.dart';

enum EPostDetailState { loading, loaded, erorr, delete }

extension EAppStateHelper on EPostDetailState {
  T when<T>({
    @required T Function() loading,
    @required T Function() loaded,
    @required T Function() erorr,
    @required T Function() delete,
  }) {
    switch (this) {
      case EPostDetailState.loading:
        if (loading != null) {
          return loading.call();
        }
        break;
      case EPostDetailState.loaded:
        if (loaded != null) {
          return loaded.call();
        }
        break;
      case EPostDetailState.erorr:
        if (erorr != null) {
          return erorr.call();
        }
        break;
      case EPostDetailState.delete:
        if (delete != null) {
          return delete.call();
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
    T Function() delete,
  }) {
    switch (this) {
      case EPostDetailState.loading:
        if (loading != null) {
          return loading.call();
        } else {
          return elseMaybe();
        }
        break;
      case EPostDetailState.loaded:
        if (loaded != null) {
          return loaded.call();
        } else {
          return elseMaybe();
        }
        break;
      case EPostDetailState.erorr:
        if (erorr != null) {
          return erorr.call();
        } else {
          return elseMaybe();
        }
        break;
      case EPostDetailState.delete:
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
