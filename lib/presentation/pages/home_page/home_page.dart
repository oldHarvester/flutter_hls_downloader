import 'package:flutter/material.dart';
import 'package:flutter_hls_parser_test/models/master_playlist_model/master_playlist_model.dart';
import 'package:flutter_hls_parser_test/presentation/pages/app_directory_page/widgets/directory_page.dart';
import 'package:flutter_hls_parser_test/repositories/hls_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../download_list_page/download_list_page.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? url;

  MasterPlaylistModel? playlistData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final appDir = await getApplicationDocumentsDirectory();
              if (context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DirectoryPage(directory: appDir),
                  ),
                );
              }
            },
            icon: const Icon(Icons.folder),
          )
        ],
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("Parse"),
                  onPressed: () async {
                    final hlsEntry =
                        await ref.read(hlsRepositoryProvider).fetchHlsEntry();

                    url = hlsEntry.master;
                    playlistData = await ref
                        .read(hlsRepositoryProvider)
                        .fetchDataFromMasterPlaylist(url!);
                    setState(() {});
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                AnimatedOpacity(
                  opacity: playlistData == null ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: (playlistData?.resolutions ?? {})
                          .map(
                            (resolutionData) => TextButton(
                              onLongPress: () async {
                                final data = await ref
                                    .read(hlsRepositoryProvider)
                                    .fetchDataFromResolutionPlaylist(
                                        resolutionData);

                                if (context.mounted) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return DownloadListPage(
                                          segmentsData: data,
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                              onPressed: () async {
                                if (playlistData != null) {
                                  final segmentsToDownload = await ref
                                      .read(hlsRepositoryProvider)
                                      .checkSegments(
                                        masterPlaylistData: playlistData!,
                                        hlsResolution: resolutionData,
                                      );
                                  if (segmentsToDownload.isNotEmpty) {
                                    ref
                                        .read(hlsRepositoryProvider)
                                        .downloadHlsVideo(
                                          segments: segmentsToDownload,
                                        );
                                  }
                                }
                              },
                              child: Text(
                                resolutionData.resolution.title
                                    .replaceFirst('/', ''),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
