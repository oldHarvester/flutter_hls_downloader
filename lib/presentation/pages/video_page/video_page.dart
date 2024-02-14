import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({
    super.key,
    required this.videoFile,
  });

  final File videoFile;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late final BetterPlayerController betterPlayerController;

  @override
  void initState() {
    betterPlayerController = BetterPlayerController(
      betterPlayerDataSource: BetterPlayerDataSource.file(
        widget.videoFile.path,
      ),
      const BetterPlayerConfiguration(
        autoPlay: true,
        autoDispose: true,
        startAt: Duration(seconds: 0),
      ),
      betterPlayerPlaylistConfiguration:
          const BetterPlayerPlaylistConfiguration(
        initialStartIndex: 3,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: BetterPlayer(
        controller: betterPlayerController,
      ),
    );
  }
}
