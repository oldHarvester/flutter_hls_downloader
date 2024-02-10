import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hls_parser_test/presentation/pages/app_directory_page/widgets/directory_tile.dart';
import 'package:flutter_hls_parser_test/presentation/pages/app_directory_page/widgets/file_tile.dart';
import 'package:flutter_hls_parser_test/utils/functions.dart';

class DirectoryPage extends StatelessWidget {
  const DirectoryPage({
    super.key,
    required this.directory,
  });

  final Directory directory;

  @override
  Widget build(BuildContext context) {
    final directoryFiles = directory.listSync();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getCurrentPath(directory, directory.path),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            directoryFiles.length,
            (index) {
              final fileEntity = directoryFiles[index];
              if (fileEntity is File) {
                return FileTile(
                  file: fileEntity,
                  currentDirectory: directory,
                );
              }
              return DirectoryTile(
                directory: fileEntity as Directory,
              );
            },
          ),
        ),
      ),
    );
  }
}
