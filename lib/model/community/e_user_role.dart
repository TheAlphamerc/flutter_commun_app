part of 'community_model.dart';

enum MemberRole { admin, user, moderator, notDefine }
const _$GroupMemberRoleTypeMap = {
  MemberRole.admin: 'admin',
  MemberRole.user: 'user',
  MemberRole.moderator: 'moderator',
  MemberRole.notDefine: '',
};

const _$GroupMemberRoleTypeName = {
  MemberRole.admin: 'Admin',
  MemberRole.user: 'User',
  MemberRole.moderator: 'Moderator',
  MemberRole.notDefine: '',
};

extension GroupMemberRoleEnumHelper on MemberRole {
  String? encode() => _$GroupMemberRoleTypeMap[this];
  String? name() {
    return _$GroupMemberRoleTypeName[this];
  }

  MemberRole key(String value) => decodeGroupMemberRole(value);

  MemberRole decodeGroupMemberRole(String value) {
    return _$GroupMemberRoleTypeMap.entries
        .singleWhere((element) => element.value == value)
        .key;
  }

  T when<T>({
    required T Function() admin,
    required T Function() user,
    required T Function() moderator,
    required T Function() notDefine,
  }) {
    switch (this) {
      case MemberRole.admin:
        if (admin != null) {
          return admin.call();
        }
        break;
      case MemberRole.user:
        if (user != null) {
          return user.call();
        }
        break;
      case MemberRole.moderator:
        if (moderator != null) {
          return moderator.call();
        }
        break;
      case MemberRole.notDefine:
        if (notDefine != null) {
          return notDefine.call();
        }
        break;
      default:
    }
    throw Exception("Unknown value: $this");
  }

  T mayBeWhen<T>({
    required T Function() elseMaybe,
    T Function()? admin,
    T Function()? user,
    T Function()? moderator,
    T Function()? notDefine,
  }) {
    switch (this) {
      case MemberRole.admin:
        if (admin != null) {
          return admin.call();
        } else {
          return elseMaybe.call();
        }
        break;
      case MemberRole.user:
        if (user != null) {
          return user.call();
        } else {
          return elseMaybe.call();
        }
        break;
      case MemberRole.moderator:
        if (moderator != null) {
          return moderator.call();
        } else {
          return elseMaybe.call();
        }
        break;
      case MemberRole.notDefine:
        if (notDefine != null) {
          return notDefine.call();
        } else {
          return elseMaybe.call();
        }
        break;
      default:
        return elseMaybe.call();
    }
  }
}
