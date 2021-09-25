part of 'post_model.dart';

// ignore: constant_identifier_names
enum AttachmentType { Video, Image, Document, Poll, Quiz, Question, None }

// value used for calculation
const _$PostTypeMap = {
  AttachmentType.Video: "Video",
  AttachmentType.Image: "Image",
  AttachmentType.Quiz: "Quiz",
  AttachmentType.Poll: "Poll",
  AttachmentType.None: "None",
  AttachmentType.Question: "Question",
  AttachmentType.Document: "Document",
};

// Value to display on ui
const _$PostTypeMapLabel = {
  AttachmentType.Video: "Video",
  AttachmentType.Image: "Image",
  AttachmentType.Quiz: "Quiz",
  AttachmentType.Poll: "Poll",
  AttachmentType.None: "None",
  AttachmentType.Question: "Question",
  AttachmentType.Document: "Document"
};

const _$PostTypeFileUploadLabel = {
  AttachmentType.Video: "videos",
  AttachmentType.Image: "images",
  AttachmentType.Document: "document",
  AttachmentType.Quiz: "quiz",
  AttachmentType.Poll: "poll",
  AttachmentType.Question: "question",
  AttachmentType.None: "none",
};

AttachmentType decodePostType(String value) {
  return _$PostTypeMap.entries
      .singleWhere((element) => element.value == value)
      .key;
}

AttachmentType decodeFileUploadKey(String value) {
  return _$PostTypeMap.entries
      .singleWhere((element) => element.value == value)
      .key;
}

extension AttachmentTypeHelper on AttachmentType {
  String? encode() => _$PostTypeMap[this];
  String? get value => _$PostTypeMapLabel[this];
  String? get fileUploadKey => _$PostTypeFileUploadLabel[this];
  AttachmentType key(String value) => decodePostType(value);
  T map<T>({
    required T Function() image,
    required T Function() video,
    required T Function() poll,
    required T Function() quiz,
    required T Function() document,
    required T Function() question,
    required T Function() recording,
    required T Function() elseMaybe,
  }) {
    switch (this) {
      case AttachmentType.Video:
        return video.call();
      case AttachmentType.Image:
        return image.call();
      case AttachmentType.Quiz:
        return quiz.call();
      case AttachmentType.Poll:
        return poll.call();
      case AttachmentType.Document:
        return document.call();
      case AttachmentType.Question:
        return question.call();
      default:
        return elseMaybe.call();
    }
  }

  // when({
  //   Function() image,
  //   Function() video,
  //   Function() poll,
  //   Function() quiz,
  //   Function() document,
  //   Function() question,
  //   Function() elseMaybe,
  // }) {
  //   switch (this) {
  //     case AttachmentType.Video:
  //       if (video != null) {
  //         video.call();
  //       } else {
  //         if (elseMaybe != null) elseMaybe.call();
  //       }
  //     case AttachmentType.Image:
  //       if (image != null) {
  //         image.call();
  //       } else {
  //         if (elseMaybe != null) elseMaybe.call();
  //       }
  //     case AttachmentType.Quiz:
  //       if (quiz != null) {
  //         quiz.call();
  //       } else {
  //         if (elseMaybe != null) elseMaybe.call();
  //       }
  //     case AttachmentType.Poll:
  //       if (poll != null) {
  //         poll.call();
  //       } else {
  //         if (elseMaybe != null) elseMaybe.call();
  //       }
  //     case AttachmentType.Document:
  //       if (document != null) {
  //         document.call();
  //       } else {
  //         if (elseMaybe != null) elseMaybe.call();
  //       }
  //     case AttachmentType.Question:
  //       if (question != null) {
  //         question.call();
  //       } else {
  //         if (elseMaybe != null) elseMaybe.call();
  //       }
  //     default:
  //       if (elseMaybe != null) elseMaybe.call();
  //   }
  // }

  T whenMaybe<T>(
    T Function() elseMaybe, {
    T Function()? image,
    T Function()? video,
    T Function()? poll,
    T Function()? quiz,
    T Function()? document,
    T Function()? question,
  }) {
    switch (this) {
      case AttachmentType.Video:
        if (video != null) {
          return video.call();
        } else {
          return elseMaybe.call();
        }
      case AttachmentType.Image:
        if (image != null) {
          return image.call();
        } else {
          return elseMaybe.call();
        }
      case AttachmentType.Quiz:
        if (quiz != null) {
          return quiz.call();
        } else {
          return elseMaybe.call();
        }
      case AttachmentType.Poll:
        if (poll != null) {
          return poll.call();
        } else {
          return elseMaybe.call();
        }
      case AttachmentType.Document:
        if (document != null) {
          return document.call();
        } else {
          return elseMaybe.call();
        }
      case AttachmentType.Question:
        if (question != null) {
          return question.call();
        } else {
          return elseMaybe.call();
        }
      default:
        return elseMaybe.call();
    }
  }
}
