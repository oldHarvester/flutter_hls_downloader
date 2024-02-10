import 'dart:io';

String checkLinks(String currentLink, String oldLink) {
  if (currentLink.startsWith("http")) {
    return currentLink;
  } else {
    String protocol;

    if (oldLink.contains("https://")) {
      protocol = "https://";
      oldLink = oldLink.replaceFirst("https://", '');
    } else {
      protocol = "http://";
      oldLink = oldLink.replaceFirst("http://", '');
    }

    final linkSegments = oldLink.split('/')..removeLast();
    return "$protocol${linkSegments.join('/')}/$currentLink";
  }
}

String getCurrentPath(Directory directory, String path) {
  final pathSegments = path.split('/');
  final includedDirectories = <String>[];
  var findDirectory = false;
  final directoryName = directory.path.split('/').last;

  if (directory.path == path) {
    return directoryName;
  }

  for (var path in pathSegments) {
    if (findDirectory) {
      includedDirectories.add(path);
    }
    if (path == directoryName) {
      findDirectory = true;
    }
  }

  return includedDirectories.join('/');
}
