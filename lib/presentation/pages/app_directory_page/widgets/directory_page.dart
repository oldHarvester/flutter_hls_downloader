import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hls_parser_test/presentation/pages/app_directory_page/widgets/directory_tile.dart';
import 'package:flutter_hls_parser_test/presentation/pages/app_directory_page/widgets/file_tile.dart';
import 'package:flutter_hls_parser_test/presentation/pages/file_details_page/file_details_page.dart';
import 'package:flutter_hls_parser_test/utils/functions.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({
    super.key,
    required this.directory,
  });

  final Directory directory;

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  bool isSelectMode = false;
  Set<int> selectedIndexes = {};
  bool selectAll = false;
  List<FileSystemEntity> directoryFiles = [];

  @override
  void initState() {
    directoryFiles = widget.directory.listSync();
    super.initState();
  }

  void onLongPress(int index) {
    if (!isSelectMode) {
      setState(() {
        isSelectMode = true;
        selectedIndexes.add(index);
      });
    }
  }

  void onSelectAll(bool select) {
    if (select) {
      selectAll = true;
      selectedIndexes = {};
      for (var i = 0; i < directoryFiles.length; i++) {
        selectedIndexes.add(i);
      }
    } else {
      selectAll = false;
      selectedIndexes = {};
    }
    setState(() {});
  }

  void onPressedInSelectMode(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });
  }

  Future<void> onRemove() async {
    final sortedIndexes = selectedIndexes.toList()..sort();
    for (var i = sortedIndexes.length - 1; i >= 0; i--) {
      await directoryFiles[i].delete(recursive: true);
      directoryFiles.removeAt(i);
    }
    setState(() {
      isSelectMode = false;
      selectAll = false;
      selectedIndexes = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isSelectMode ? false : true,
        flexibleSpace: FlexibleSpaceBar(
          background: isSelectMode
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: selectAll,
                          onChanged: (value) {
                            if (value != null) {
                              onSelectAll(value);
                            }
                          },
                        ),
                        Center(
                          child: Text(
                            selectedIndexes.length.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
        ),
        centerTitle: isSelectMode ? true : false,
        title: Text(
          getCurrentPath(widget.directory, widget.directory.path),
        ),
        actions: [
          if (isSelectMode)
            IconButton(
              onPressed: onRemove,
              icon: const Icon(
                Icons.delete_outline_outlined,
              ),
            ),
          if (isSelectMode)
            IconButton(
              onPressed: () {
                setState(() {
                  selectedIndexes.clear();
                  isSelectMode = false;
                });
              },
              icon: const Icon(Icons.cancel),
            ),
        ],
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
                  currentDirectory: widget.directory,
                  isSelected: isSelectMode && selectedIndexes.contains(index),
                  onLongPress: () => onLongPress(index),
                  onPressed: isSelectMode
                      ? () => onPressedInSelectMode(index)
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  FileDetailsPage(file: fileEntity),
                            ),
                          );
                        },
                );
              }
              return DirectoryTile(
                directory: fileEntity as Directory,
                isSelected: isSelectMode && selectedIndexes.contains(index),
                onLongPress: () => onLongPress(index),
                onPressed: isSelectMode
                    ? () => onPressedInSelectMode(index)
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DirectoryPage(
                              directory: fileEntity,
                            ),
                          ),
                        );
                      },
              );
            },
          ),
        ),
      ),
    );
  }
}
