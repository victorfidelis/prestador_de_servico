extension StringExtensions on String {
  String reverse() {
    var reverseValue = '';
    for (int i = (length - 1); i >= 0; i--) {
      reverseValue += this[i];
    }
    return reverseValue;
  }
}
