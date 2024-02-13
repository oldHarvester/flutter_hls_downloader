import 'dart:io';

import 'package:flutter/material.dart';

class FileDetailsPage extends StatefulWidget {
  const FileDetailsPage({super.key, required this.file});
  final File file;

  @override
  State<FileDetailsPage> createState() => _FileDetailsPageState();
}

class _FileDetailsPageState extends State<FileDetailsPage> {
  final List<String> fileContent = [];
  bool hasError = false;

  @override
  void initState() {
    widget.file.readAsLines().then(
      (value) {
        setState(() {
          fileContent.addAll(value);
        });
      },
    ).catchError(
      (error, stackTrace) {
        setState(() {
          hasError = true;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.file.path.split('/').last,
        ),
      ),
      body: hasError
          ? const Center(
              child: Text(
                "Error when trying to read this file",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: List.generate(
                  fileContent.length,
                  (index) {
                    return Text(
                      fileContent[index],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
