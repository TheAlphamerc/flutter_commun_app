class Constants {
  static const String postImagePath = "post";

  static String createFilePath(String fileName) {
    final newPath = fileName.split("/").last;
    return "$postImagePath/${DateTime.now().toUtc().toIso8601String()}-$newPath";
  }
}
