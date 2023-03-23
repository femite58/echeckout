class TextTransform {
  static capitalize(String? txt) {
    return txt == null || txt.isEmpty
        ? txt
        : txt
            .trim()
            .toLowerCase()
            .split(' ')
            .map((e) => e.replaceFirst(e[0], e[0].toUpperCase()))
            .join(' ');
  }
}
