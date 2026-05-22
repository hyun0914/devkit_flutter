import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../widget/default_scaffold.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isLoading = false;
  String? _error;

  // 샘플 오디오 (공개 도메인)
  static const _sampleUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadAudio() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await _player.setUrl(_sampleUrl);
    } catch (e) {
      setState(() => _error = '오디오 로드 실패: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(title: const Text('오디오 재생 (just_audio)')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'just_audio',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '오디오 스트리밍 & 파일 재생',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),

            const SizedBox(height: 32),

            // 플레이어 카드
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // 앨범 아트
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.music_note_rounded,
                      size: 60,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'SoundHelix Song 1',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'SoundHelix',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                  ),

                  const SizedBox(height: 24),

                  if (_isLoading)
                    const CircularProgressIndicator()
                  else if (_error != null)
                    Column(
                      children: [
                        Text(_error!,
                            style: TextStyle(color: theme.colorScheme.error),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        TextButton(
                            onPressed: _loadAudio,
                            child: const Text('다시 시도')),
                      ],
                    )
                  else ...[
                    // 프로그레스
                    StreamBuilder<Duration>(
                      stream: _player.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final duration = _player.duration ?? Duration.zero;
                        final progress = duration.inMilliseconds > 0
                            ? position.inMilliseconds /
                                duration.inMilliseconds
                            : 0.0;

                        return Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8),
                              ),
                              child: Slider(
                                value: progress.clamp(0.0, 1.0),
                                onChanged: (v) {
                                  final target = Duration(
                                    milliseconds:
                                        (v * duration.inMilliseconds).toInt(),
                                  );
                                  _player.seek(target);
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_formatDuration(position),
                                      style: theme.textTheme.bodySmall),
                                  Text(_formatDuration(duration),
                                      style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // 컨트롤 버튼
                    StreamBuilder<PlayerState>(
                      stream: _player.playerStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        final playing = state?.playing ?? false;
                        final processingState =
                            state?.processingState ?? ProcessingState.idle;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 뒤로 10초
                            IconButton(
                              icon: const Icon(Icons.replay_10_rounded),
                              iconSize: 36,
                              onPressed: () {
                                final pos = _player.position;
                                _player.seek(Duration(
                                    seconds:
                                        (pos.inSeconds - 10).clamp(0, 9999)));
                              },
                            ),

                            const SizedBox(width: 8),

                            // 재생/일시정지
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: processingState ==
                                        ProcessingState.loading ||
                                    processingState ==
                                        ProcessingState.buffering
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            color: Colors.white, strokeWidth: 2),
                                      )
                                    : Icon(
                                        playing
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        color: Colors.white,
                                      ),
                                iconSize: 40,
                                onPressed: playing
                                    ? _player.pause
                                    : _player.play,
                              ),
                            ),

                            const SizedBox(width: 8),

                            // 앞으로 10초
                            IconButton(
                              icon: const Icon(Icons.forward_10_rounded),
                              iconSize: 36,
                              onPressed: () {
                                final pos = _player.position;
                                final dur =
                                    _player.duration?.inSeconds ?? 9999;
                                _player.seek(Duration(
                                    seconds:
                                        (pos.inSeconds + 10).clamp(0, dur)));
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // 볼륨
                    Row(
                      children: [
                        const Icon(Icons.volume_down_rounded, size: 20),
                        Expanded(
                          child: StreamBuilder<double>(
                            stream: _player.volumeStream,
                            builder: (context, snapshot) {
                              final volume = snapshot.data ?? 1.0;
                              return Slider(
                                value: volume,
                                onChanged: (v) => _player.setVolume(v),
                              );
                            },
                          ),
                        ),
                        const Icon(Icons.volume_up_rounded, size: 20),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 주요 기능
            _buildSectionHeader(theme, '주요 기능'),
            const SizedBox(height: 12),
            _buildCodeBlock(theme, '''// URL에서 로드
await player.setUrl('https://...');

// 파일에서 로드
await player.setFilePath('/path/to/file.mp3');

// 재생 / 일시정지 / 정지
player.play();
player.pause();
player.stop();

// 위치 이동
player.seek(Duration(seconds: 30));

// 반복 재생
player.setLoopMode(LoopMode.one);

// 재생 속도
player.setSpeed(1.5);'''),
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
