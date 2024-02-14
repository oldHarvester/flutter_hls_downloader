import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hls_parser_test/presentation/pages/video_page/video_page.dart';

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
    final fileName = widget.file.path.split('/').last;
    final fileNameExtension = fileName.split('.').last;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          fileName,
        ),
        actions: [
          if (fileNameExtension == "m3u8")
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VideoPage(videoFile: widget.file),
                  ),
                );
              },
              icon: Icon(
                Icons.play_arrow,
                color: Colors.green.shade700,
              ),
            )
        ],
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  fileContent.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        fileContent[index],
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
