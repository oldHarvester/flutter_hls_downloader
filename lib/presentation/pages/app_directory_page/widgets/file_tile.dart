import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hls_parser_test/utils/functions.dart';

class FileTile extends StatelessWidget {
  const FileTile({
    super.key,
    required this.file,
    required this.currentDirectory,
  });

  final File file;
  final Directory currentDirectory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Icon(
            Icons.file_open_rounded,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              getCurrentPath(
                currentDirectory,
                file.path,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
