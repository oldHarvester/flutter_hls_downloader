import 'package:flutter/material.dart';
import 'package:flutter_hls_parser_test/models/master_playlist_model/master_playlist_model.dart';
import 'package:flutter_hls_parser_test/presentation/pages/download_list_page/download_list_page.dart';
import 'package:flutter_hls_parser_test/repositories/hls_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
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
                          onPressed: () async {
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
    );
  }
}
