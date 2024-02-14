import 'dart:io';
import 'package:flutter/material.dart';

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

String hlsUrlToLocal(Directory appDir, String url, [bool addFile = false]) {
  final urlSegments = url.split('/')
    ..removeAt(0)
    ..removeAt(1);
  return "${addFile ? "file://" : ""}${appDir.path}${urlSegments.join('/')}";
}

String asciiToHex(String input) {
  return "0x${input.codeUnits.map((unit) => unit.toRadixString(16)).join()}";
}

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
