import 'package:flutter/material.dart';
import 'package:flutter_hls_parser_test/models/segment_playlist_model/segment_playlist_parsed_model.dart';
import 'package:flutter_hls_parser_test/presentation/pages/app_directory_page/widgets/directory_page.dart';
import 'package:flutter_hls_parser_test/presentation/pages/download_list_page/widgets/segment_tile.dart';
import 'package:path_provider/path_provider.dart';

class DownloadListPage extends StatelessWidget {
  const DownloadListPage({
    super.key,
    required this.segmentsData,
  });

  final SegmentPlaylistParsedModel segmentsData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
        actions: [
          IconButton(
            onPressed: () async {
              final directory = await getApplicationDocumentsDirectory();
              if (context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return DirectoryPage(
                        directory: directory,
                      );
                    },
                  ),
                );
              }
            },
            icon: const Icon(Icons.folder),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              segmentsData.segments.length,
              (index) {
                final segment = segmentsData.segments.elementAt(index);
                return SegmentTile(
                  segment: segment,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
