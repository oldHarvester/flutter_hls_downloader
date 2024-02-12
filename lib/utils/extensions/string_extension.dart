extension StringExtension on String {
  List<String> splitWithExclude(
      {required String pattern, required String excludePattern}) {
    var result = <String>[];
    var buffer = StringBuffer();
    bool isInQuotes = false;

    for (var i = 0; i < length; i++) {
      var char = this[i];

      if (char == excludePattern) {
        isInQuotes =
            !isInQuotes; // Переключаем состояние внутри/вне excludePattern
      }

      if (char == pattern && !isInQuotes) {
        // Если находим pattern вне excludePattern, добавляем элемент в результат
        result.add(buffer.toString().trim());
        buffer.clear(); // Очищаем буфер для следующего элемента
      } else {
        buffer.write(char); // Добавляем символ в буфер, включая кавычки
      }
    }

    // Добавляем последний элемент после обработки всей строки
    if (buffer.isNotEmpty) {
      result.add(buffer.toString().trim());
    }

    return result;
  }
}
