part of 'community_model.dart';

enum ESocialLinkType {
  twitter,
  facebook,
  youtube,
  instagram,
  linkedin,
  github,
  other,
}
const _$ESocialLinkTypeTypeMap = {
  ESocialLinkType.twitter: 'Twitter',
  ESocialLinkType.facebook: 'Facebook',
  ESocialLinkType.github: 'Github',
  ESocialLinkType.instagram: 'Instagram',
  ESocialLinkType.linkedin: 'LinkedIn',
  ESocialLinkType.youtube: 'Youtube',
  ESocialLinkType.other: 'Website',
};

extension ESocialLinkTypeHelper on ESocialLinkType {
  String encode() => _$ESocialLinkTypeTypeMap[this];

  ESocialLinkType key(String value) => decodeESocialLinkType(value);

  ESocialLinkType decodeESocialLinkType(String value) {
    return _$ESocialLinkTypeTypeMap.entries
        .singleWhere((element) => element.value == value, orElse: () => null)
        ?.key;
  }

  T when<T>({
    @required T Function() twitter,
    @required T Function() facebook,
    @required T Function() youtube,
    @required T Function() instagram,
    @required T Function() github,
    @required T Function() linkedin,
    @required T Function() other,
  }) {
    switch (this) {
      case ESocialLinkType.twitter:
        return twitter.call();
        break;
      case ESocialLinkType.facebook:
        return facebook.call();
        break;

      case ESocialLinkType.youtube:
        return youtube.call();
        break;
      case ESocialLinkType.instagram:
        return instagram.call();
        break;
      case ESocialLinkType.github:
        return github.call();
        break;
      case ESocialLinkType.linkedin:
        return linkedin.call();
        break;
      case ESocialLinkType.other:
        return other.call();
        break;

      default:
    }
    return null;
  }

  T mayBeWhen<T>({
    @required T Function() elseMaybe,
    T Function() twitter,
    T Function() facebook,
    T Function() youtube,
    T Function() instagram,
    T Function() github,
    T Function() linkedin,
    T Function() other,
  }) {
    switch (this) {
      case ESocialLinkType.twitter:
        if (twitter != null) {
          return twitter.call();
        } else {
          return elseMaybe();
        }
        break;
      case ESocialLinkType.facebook:
        if (facebook != null) {
          return facebook.call();
        } else {
          return elseMaybe();
        }
        break;

      case ESocialLinkType.youtube:
        if (youtube != null) {
          return youtube.call();
        } else {
          return elseMaybe();
        }
        break;
      case ESocialLinkType.instagram:
        if (instagram != null) {
          return instagram.call();
        } else {
          return elseMaybe();
        }
        break;
      case ESocialLinkType.github:
        if (github != null) {
          return github.call();
        } else {
          return elseMaybe();
        }
        break;
      case ESocialLinkType.linkedin:
        if (linkedin != null) {
          return linkedin.call();
        } else {
          return elseMaybe();
        }
        break;
      case ESocialLinkType.other:
        if (other != null) {
          return other.call();
        } else {
          return elseMaybe();
        }
        break;

      default:
        return elseMaybe();
    }
  }
}
