import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hls_parser_test/presentation/pages/app_directory_page/widgets/directory_page.dart';
import 'package:flutter_hls_parser_test/utils/functions.dart';

class DirectoryTile extends StatelessWidget {
  const DirectoryTile({
    super.key,
    required this.directory,
  });

  final Directory directory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DirectoryPage(
              directory: directory,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(
              Icons.folder,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                getCurrentPath(directory, directory.path),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
