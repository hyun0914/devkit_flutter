import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../widget/default_scaffold.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _showControls = true;
  String? _error;

  static const _sampleUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initPlayer() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(_sampleUrl),
      );
      _controller = controller;
      await controller.initialize();
      controller.addListener(() => setState(() {}));
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = '영상 로드 실패: $e';
      });
    }
  }

  void _togglePlay() {
    final controller = _controller;
    if (controller == null) return;
    controller.value.isPlaying ? controller.pause() : controller.play();
    setState(() {});
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = _controller;

    return DefaultScaffold(
      appBar: AppBar(title: const Text('비디오 재생 (video_player)')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'video_player',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '네트워크 / 로컬 영상 재생',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),

            const SizedBox(height: 20),

            // 비디오 플레이어
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : _error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.white54, size: 48),
                                const SizedBox(height: 8),
                                Text(_error!,
                                    style: const TextStyle(
                                        color: Colors.white54, fontSize: 12),
                                    textAlign: TextAlign.center),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: _initPlayer,
                                  child: const Text('다시 시도',
                                      style:
                                          TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: _toggleControls,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                VideoPlayer(controller!),

                                // 컨트롤 오버레이
                                if (_showControls)
                                  Container(
                                    color: Colors.black38,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        // 프로그레스 바
                                        VideoProgressIndicator(
                                          controller,
                                          allowScrubbing: true,
                                          colors: VideoProgressColors(
                                            playedColor:
                                                theme.colorScheme.primary,
                                            bufferedColor: Colors.white38,
                                            backgroundColor:
                                                Colors.white12,
                                          ),
                                        ),

                                        // 시간 & 버튼
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 4, 12, 8),
                                          child: Row(
                                            children: [
                                              Text(
                                                _formatDuration(controller
                                                    .value.position),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                              const Text(' / ',
                                                  style: TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 12)),
                                              Text(
                                                _formatDuration(controller
                                                    .value.duration),
                                                style: const TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 12),
                                              ),
                                              const Spacer(),
                                              // 반복
                                              IconButton(
                                                icon: Icon(
                                                  controller.value.isLooping
                                                      ? Icons.repeat_one_rounded
                                                      : Icons.repeat_rounded,
                                                  color: controller
                                                          .value.isLooping
                                                      ? theme.colorScheme
                                                          .primary
                                                      : Colors.white54,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  controller.setLooping(
                                                      !controller
                                                          .value.isLooping);
                                                },
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // 재생/일시정지 버튼
                                if (_showControls)
                                  GestureDetector(
                                    onTap: _togglePlay,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        color: Colors.black45,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        controller.value.isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
              ),
            ),

            const SizedBox(height: 8),
            Text(
              '화면을 탭하면 컨트롤이 표시/숨겨집니다',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // 주요 기능
            _buildSectionHeader(theme, '주요 기능'),
            const SizedBox(height: 12),
            _buildCodeBlock(theme, '''// 네트워크 영상
final controller = VideoPlayerController.networkUrl(
  Uri.parse('https://example.com/video.mp4'),
);

// 로컬 파일
final controller = VideoPlayerController.file(File(path));

// 앱 번들 에셋
final controller = VideoPlayerController.asset(
  'assets/video.mp4',
);

await controller.initialize();

// 재생 / 일시정지
controller.play();
controller.pause();

// 위치 이동
controller.seekTo(Duration(seconds: 30));

// 반복
controller.setLooping(true);

// 볼륨
controller.setVolume(0.5);'''),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeBlock(ThemeData theme, String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Text(
        code,
        style: theme.textTheme.bodySmall
            ?.copyWith(fontFamily: 'monospace', height: 1.6),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
