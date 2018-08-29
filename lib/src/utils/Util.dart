import 'dart:async';

/// Merges list of stream into one stream
Stream<T> merge<T>(List<Stream<T>> streams) {
  int _open = streams.length;
  var c = new StreamController<T>();
  for (var stream in streams) {
    stream.listen(c.add)
      ..onError(c.addError)
      ..onDone(() {
        if (--_open == 0) {
          c.close();
        }
      });
  }
  return c.stream;
}

/// Splits string based on desied lenght
Iterable<String> split(String str, int length) sync* {
  int last = 0;
  while (last < str.length && ((last + length) < str.length)) {
    yield str.substring(last, last + length);
    last += length;
  }
  yield str.substring(last, str.length);
}

/// Splits string based on number of wanted substrings
Iterable<String> splitEqually(String str, int pieces) {
  int len = (str.length / pieces).round();

  return split(str, len);
}

/// Gets [Symbol]s 'name'
String getSymbolName(Symbol symbol) {
  return symbol
      .toString()
      .substring(6)
      .replaceAll("\"", "")
      .replaceAll("(", "")
      .replaceAll(")", "");
}

Iterable<List<T>> partition<T>(List<T> lst, int len) sync* {
  for (var i = 0; i < lst.length; i += len) yield lst.sublist(i, i + len);
}

// Divides list into equal pieces
Stream<List<T>> chunk<T>(List<T> list, int chunkSize) async* {
  int len = list.length;
  for (var i = 0; i < len; i += chunkSize) {
    int size = i + chunkSize;
    yield list.sublist(i, size > len ? len : size);
  }
}
