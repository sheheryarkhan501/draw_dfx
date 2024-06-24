double pixelsPerInch = 4;

extension PixelToInches on double {
  double get toInches {
    return this / pixelsPerInch;
  }

  String get toStringAsInches {
    return "${(this / pixelsPerInch).toStringAsFixed(1)}\"";
  }

  double get toPixels {
    return this * pixelsPerInch;
  }
}
