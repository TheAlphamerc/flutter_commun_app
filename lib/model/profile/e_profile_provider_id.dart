part of 'profile_model.dart';

// ignore: constant_identifier_names
enum EProfileProviderId { Password, Google, Phone }
const _$EProfileProviderIdTypeMap = {
  EProfileProviderId.Password: 'password',
  EProfileProviderId.Google: "google.com",
  EProfileProviderId.Phone: "phone"
};

extension EProfileProviderIdHelper on EProfileProviderId {
  String? encode() => _$EProfileProviderIdTypeMap[this];

  EProfileProviderId key(String? value) => _decodeEProfileProviderId(value);

  EProfileProviderId _decodeEProfileProviderId(String? value) {
    return _$EProfileProviderIdTypeMap.entries
        .singleWhere((element) => element.value == value)
        .key;
  }

  T when<T>({
    required T Function() password,
    required T Function() google,
    required T Function() phone,
    required T Function() elseMaybe,
  }) {
    switch (this) {
      case EProfileProviderId.Password:
        return password.call();
      case EProfileProviderId.Google:
        return google.call();
      case EProfileProviderId.Phone:
        return phone.call();
      default:
    }
    if (elseMaybe != null) return elseMaybe.call();

    throw Exception("Unknown value: $this");
  }

  T mayBeWhen<T>(
    T Function() elseMaybe, {
    T Function()? password,
    T Function()? google,
    T Function()? phone,
  }) {
    switch (this) {
      case EProfileProviderId.Password:
        if (password != null) {
          return password.call();
        } else {
          return elseMaybe();
        }
      case EProfileProviderId.Google:
        if (google != null) {
          return google.call();
        } else {
          return elseMaybe();
        }
      case EProfileProviderId.Phone:
        if (phone != null) {
          return phone.call();
        } else {
          return elseMaybe();
        }
      default:
        return elseMaybe();
    }
  }
}
