class Constants {
  static const String postImagePath = "post";
  static const String community = "community";

  static String createFilePath(String fileName, {String folderName}) {
    final newPath = fileName.split("/").last;
    return "$folderName/${DateTime.now().microsecondsSinceEpoch}$newPath";
  }
}
