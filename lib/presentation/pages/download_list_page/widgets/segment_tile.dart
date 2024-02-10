import 'package:flutter/material.dart';
import 'package:flutter_hls_parser_test/models/segment_playlist_model/segment_playlist_parsed_model.dart';
import 'package:flutter_hls_parser_test/repositories/hls_repository.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SegmentTile extends HookConsumerWidget {
  const SegmentTile({
    super.key,
    required this.segment,
  });

  final HlsSegment segment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = useState(0.0);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(segment.videoLink),
          const SizedBox(
            height: 8,
          ),
          LinearProgressIndicator(
            value: progress.value,
            backgroundColor: Colors.grey,
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              ref.read(hlsRepositoryProvider).downloadSegment(
                segment,
                onDownloadProgressChanges: (currentProgress) {
                  progress.value = currentProgress;
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
