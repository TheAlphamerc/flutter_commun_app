enum PostAction {
  like,
  upVote,
  downVote,
  delete,
  modify,
  share,
  report,
  favourite,
  edit,
}
const _$PostActionTypeMap = {
  PostAction.like: 'like',
};

extension ActionHelper on PostAction {
  String? encode() => _$PostActionTypeMap[this];

  PostAction key(String value) => _decodePostAction(value);

  PostAction _decodePostAction(String value) {
    return _$PostActionTypeMap.entries
        .singleWhere((element) => element.value == value)
        .key;
  }

  T when<T>({
    T Function()? elseMaybe,
    T Function()? like,
    T Function()? upVote,
    T Function()? delete,
    T Function()? downVote,
    T Function()? modify,
    T Function()? share,
    T Function()? favourite,
    T Function()? edit,
    T Function()? report,
  }) {
    switch (this) {
      case PostAction.like:
        if (like != null) {
          return like.call();
        }
        break;
      case PostAction.upVote:
        if (upVote != null) {
          return upVote.call();
        }
        break;
      case PostAction.delete:
        if (delete != null) {
          return delete.call();
        }
        break;
      case PostAction.downVote:
        if (downVote != null) {
          return downVote.call();
        }
        break;
      case PostAction.modify:
        if (modify != null) {
          return modify.call();
        }
        break;
      case PostAction.share:
        if (share != null) {
          return share.call();
        }
        break;

      case PostAction.favourite:
        if (favourite != null) {
          return favourite.call();
        }
        break;
      case PostAction.edit:
        if (edit != null) {
          return edit.call();
        }
        break;
      case PostAction.report:
        if (report != null) {
          return report.call();
        }
        break;
      default:
    }
    if (elseMaybe != null) return elseMaybe.call();
    throw Exception("Unknown value: $this");
  }
}
