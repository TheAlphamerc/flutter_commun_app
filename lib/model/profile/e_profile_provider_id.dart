part of 'profile_model.dart';

enum EProfileProviderId { Password, Google, Phone }
const _$EProfileProviderIdTypeMap = {
  EProfileProviderId.Password: 'password',
  EProfileProviderId.Google: "google.com",
  EProfileProviderId.Phone: "phone"
};

extension convert on EProfileProviderId {
  String encode() => _$EProfileProviderIdTypeMap[this];

  EProfileProviderId key(String value) => _decodeEProfileProviderId(value);

  EProfileProviderId _decodeEProfileProviderId(String value) {
    return _$EProfileProviderIdTypeMap.entries
        .singleWhere((element) => element.value == value, orElse: () => null)
        ?.key;
  }

  T when<T>({
    T Function() password,
    T Function() google,
    T Function() phone,
    T Function() elseMaybe,
  }) {
    switch (this) {
      case EProfileProviderId.Password:
        if (password != null) {
          return password.call();
        }
        break;
      case EProfileProviderId.Google:
        if (google != null) {
          return google.call();
        }
        break;
      case EProfileProviderId.Phone:
        if (phone != null) {
          return phone.call();
        }
        break;
      default:
    }
    if (elseMaybe != null) return elseMaybe.call();
  }

  T mayBeWhen<T>(
    T Function() elseMaybe, {
    T Function() password,
    T Function() google,
    T Function() phone,
  }) {
    switch (this) {
      case EProfileProviderId.Password:
        if (password != null) {
          return password.call();
        } else {
          return elseMaybe();
        }
        break;
      case EProfileProviderId.Google:
        if (google != null) {
          return google.call();
        } else {
          return elseMaybe();
        }
        break;
      case EProfileProviderId.Phone:
        if (phone != null) {
          return phone.call();
        } else {
          return elseMaybe();
        }
        break;
      default:
        return elseMaybe();
    }
  }
}
