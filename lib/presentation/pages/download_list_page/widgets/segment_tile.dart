import 'package:flutter/material.dart';
import 'package:flutter_hls_parser_test/models/segment_playlist_model/segment_playlist_parsed_model.dart';
import 'package:flutter_hls_parser_test/repositories/hls_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

enum SegmentStatus {
  loaded,
  notLoaded;
}

final segmentStateProvider =
    AutoDisposeFutureProviderFamily<SegmentStatus, HlsSegment>(
  (ref, segment) async {
    final appDir = await getApplicationDocumentsDirectory();
    final isLoaded = await ref
        .read(hlsRepositoryProvider)
        .isFileExist(segment.absolutePath(appDir.path));
    return isLoaded ? SegmentStatus.loaded : SegmentStatus.notLoaded;
  },
);

class SegmentTile extends ConsumerStatefulWidget {
  const SegmentTile({
    super.key,
    required this.segment,
  });

  final HlsSegment segment;

  @override
  ConsumerState<SegmentTile> createState() => _SegmentTileState();
}

class _SegmentTileState extends ConsumerState<SegmentTile> {
  var progress = 0.0;
  @override
  Widget build(BuildContext context) {
    final segmentState = ref.watch(segmentStateProvider(widget.segment));

    segmentState.whenData(
      (value) {
        if (value == SegmentStatus.loaded) {
          setState(() {
            progress = 1.0;
          });
        }
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.segment.link),
          const SizedBox(
            height: 8,
          ),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: segmentState.isLoading ||
                    (segmentState.hasValue &&
                        segmentState.value == SegmentStatus.loaded)
                ? null
                : () {
                    ref.read(hlsRepositoryProvider).downloadSegment(
                      widget.segment,
                      onDownloadProgressChanges: (currentProgress) {
                        setState(() {
                          progress = currentProgress;
                        });
                      },
                    );
                  },
            child: const Text(
              'Download',
            ),
          ),
        ],
      ),
    );
  }
}
