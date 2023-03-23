class SizeConverter {
  static String convert(size) {
    double sz = double.parse(size.toString());
    if (sz < 1024) {
      return '${sz}Bytes';
    } else if (sz / 1024 < 1024) {
      return '${(sz / 1024).toStringAsFixed(1)}KB';
    } else if (sz / (1024 * 1024) < 1024) {
      return '${(sz / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(sz / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }
}
