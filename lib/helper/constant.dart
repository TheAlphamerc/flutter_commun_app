class Constants {
  static const String postImagePath = "post";

  static String createFilePath(String fileName, {String folderName}) {
    final newPath = fileName.split("/").last;
    return "$folderName/${DateTime.now().microsecondsSinceEpoch}$newPath";
  }
}
