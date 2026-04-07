import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../widget/default_scaffold.dart';

class MqttScreen extends StatefulWidget {
  const MqttScreen({super.key});

  @override
  State<MqttScreen> createState() => _MqttScreenState();
}

class _MqttScreenState extends State<MqttScreen> {
  // MQTT Client
  MqttServerClient? client;

  // 상태
  bool isConnected = false;
  bool isConnecting = false;

  // 구독 리스트
  final List<String> subscribedTopics = [];

  // 메시지 리스트
  final List<ReceivedMqttMessage> messages = [];

  // Controllers
  final TextEditingController topicController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController subscribeTopicController = TextEditingController();

  // QoS 레벨
  MqttQos publishQos = MqttQos.atMostOnce;
  MqttQos subscribeQos = MqttQos.atMostOnce;

  @override
  void initState() {
    super.initState();
    _initializeMqttClient();
  }

  void _initializeMqttClient() {
    client = MqttServerClient('broker.hivemq.com', '');
    client!.port = 1883;
    client!.logging(on: false);
    client!.keepAlivePeriod = 20;
    client!.autoReconnect = true;
    client!.onDisconnected = _onDisconnected;
    client!.onConnected = _onConnected;
    client!.onSubscribed = _onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_devkit_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    client!.connectionMessage = connMessage;
  }

  Future<void> _connect() async {
    if (isConnected || isConnecting) return;

    setState(() => isConnecting = true);

    try {
      await client!.connect().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('연결 시간 초과');
        },
      );
    } on NoConnectionException catch (e) {
      if (mounted) {
        _showSnackBar('연결 실패: 브로커 응답 없음', isError: true);
      }
      client!.disconnect();
      setState(() => isConnecting = false);
    } on SocketException catch (e) {
      if (mounted) {
        _showSnackBar('네트워크 오류: ${e.message}', isError: true);
      }
      client!.disconnect();
      setState(() => isConnecting = false);
    } on TimeoutException catch (_) {
      if (mounted) {
        _showSnackBar('연결 시간 초과', isError: true);
      }
      client!.disconnect();
      setState(() => isConnecting = false);
    } catch (e) {
      if (mounted) {
        _showSnackBar('알 수 없는 오류: $e', isError: true);
      }
      client!.disconnect();
      setState(() => isConnecting = false);
    }
  }

  void _disconnect() {
    client?.disconnect();
  }

  void _onConnected() {
    if (mounted) {
      setState(() {
        isConnected = true;
        isConnecting = false;
      });
      _showSnackBar('MQTT 브로커 연결 성공!');

      // 메시지 수신 리스너
      client!.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final recMess = c[0].payload as MqttPublishMessage;

        // 안전한 UTF-8 디코딩
        String message;
        try {
          final bytes = recMess.payload.message;
          message = utf8.decode(bytes, allowMalformed: true);
        } catch (e) {
          // 디코딩 실패 시 원본 그대로
          message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        }

        if (mounted) {
          setState(() {
            messages.insert(0, ReceivedMqttMessage(
              topic: c[0].topic,
              message: message,
              timestamp: DateTime.now(),
            ));

            // 최대 50개만 유지
            if (messages.length > 50) {
              messages.removeLast();
            }
          });
        }
      });
    }
  }

  void _onDisconnected() {
    if (!mounted) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        isConnected = false;
        isConnecting = false;
        subscribedTopics.clear();
      });

      _showSnackBar('MQTT 브로커 연결 해제', isError: true);
    });
  }

  void _onSubscribed(String topic) {
    if (mounted) {
      setState(() {
        if (!subscribedTopics.contains(topic)) {
          subscribedTopics.add(topic);
        }
      });
      _showSnackBar('구독 성공: $topic');
    }
  }

  void _subscribe() {
    if (!isConnected) {
      _showSnackBar('먼저 브로커에 연결하세요', isError: true);
      return;
    }

    final topic = subscribeTopicController.text.trim();
    if (topic.isEmpty) {
      _showSnackBar('토픽을 입력하세요', isError: true);
      return;
    }

    if (subscribedTopics.contains(topic)) {
      _showSnackBar('이미 구독 중인 토픽입니다', isError: true);
      return;
    }

    client!.subscribe(topic, subscribeQos);
    subscribeTopicController.clear();
  }

  void _unsubscribe(String topic) {
    client!.unsubscribe(topic);
    setState(() {
      subscribedTopics.remove(topic);
    });
    _showSnackBar('구독 해제: $topic');
  }

  void _publish() {
    if (!isConnected) {
      _showSnackBar('먼저 브로커에 연결하세요', isError: true);
      return;
    }

    final topic = topicController.text.trim();
    final message = messageController.text.trim();

    if (topic.isEmpty || message.isEmpty) {
      _showSnackBar('토픽과 메시지를 입력하세요', isError: true);
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addUTF8String(message);

    client!.publishMessage(topic, publishQos, builder.payload!);

    _showSnackBar('메시지 발행 성공!');
    messageController.clear();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('SnackBar 표시 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultScaffold(
      appBar: AppBar(
        title: const Text('MQTT Client'),
        actions: [
          // 연결 상태 표시
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isConnected
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isConnected ? Colors.green : Colors.red,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isConnected ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isConnected ? '연결됨' : '연결 끊김',
                  style: TextStyle(
                    color: isConnected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 헤더
          Text(
            'MQTT Client',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'IoT & 실시간 메시징 프로토콜',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          // 브로커 정보
          _buildSection(
            theme: theme,
            icon: Icons.dns,
            title: '브로커 정보',
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  _buildInfoRow(theme, 'Host', 'broker.hivemq.com'),
                  _buildInfoRow(theme, 'Port', '1883'),
                  _buildInfoRow(theme, 'Protocol', 'MQTT 3.1.1'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 연결/해제 버튼
          _buildSection(
            theme: theme,
            icon: Icons.power_settings_new,
            title: '연결 관리',
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: isConnected || isConnecting ? null : _connect,
                    icon: isConnecting
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Icon(Icons.link),
                    label: Text(isConnecting ? '연결 중...' : '연결'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: !isConnected ? null : _disconnect,
                    icon: const Icon(Icons.link_off),
                    label: const Text('연결 해제'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 토픽 구독
          _buildSection(
            theme: theme,
            icon: Icons.notifications_active,
            title: '토픽 구독',
            child: Column(
              spacing: 12,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: subscribeTopicController,
                        decoration: InputDecoration(
                          hintText: '예: devkit/test',
                          prefixIcon: const Icon(Icons.topic),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        enabled: isConnected,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<MqttQos>(
                        value: subscribeQos,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: MqttQos.atMostOnce,
                            child: Text('QoS 0'),
                          ),
                          DropdownMenuItem(
                            value: MqttQos.atLeastOnce,
                            child: Text('QoS 1'),
                          ),
                          DropdownMenuItem(
                            value: MqttQos.exactlyOnce,
                            child: Text('QoS 2'),
                          ),
                        ],
                        onChanged: isConnected
                            ? (value) {
                          setState(() => subscribeQos = value!);
                        }
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: isConnected ? _subscribe : null,
                    icon: const Icon(Icons.add),
                    label: const Text('구독'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ),

                // 구독 중인 토픽 리스트
                if (subscribedTopics.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          '구독 중인 토픽 (${subscribedTopics.length})',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...subscribedTopics.map((topic) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.topic,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  topic,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => _unsubscribe(topic),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 메시지 발행
          _buildSection(
            theme: theme,
            icon: Icons.send,
            title: '메시지 발행',
            child: Column(
              spacing: 12,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: topicController,
                        decoration: InputDecoration(
                          hintText: '토픽',
                          prefixIcon: const Icon(Icons.topic),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        enabled: isConnected,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<MqttQos>(
                        value: publishQos,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: MqttQos.atMostOnce,
                            child: Text('QoS 0'),
                          ),
                          DropdownMenuItem(
                            value: MqttQos.atLeastOnce,
                            child: Text('QoS 1'),
                          ),
                          DropdownMenuItem(
                            value: MqttQos.exactlyOnce,
                            child: Text('QoS 2'),
                          ),
                        ],
                        onChanged: isConnected
                            ? (value) {
                          setState(() => publishQos = value!);
                        }
                            : null,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: '메시지 내용',
                    prefixIcon: const Icon(Icons.message),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: 3,
                  enabled: isConnected,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: isConnected ? _publish : null,
                    icon: const Icon(Icons.publish),
                    label: const Text('발행'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 수신 메시지
          _buildSection(
            theme: theme,
            icon: Icons.message,
            title: '수신 메시지 (${messages.length})',
            child: messages.isEmpty
                ? Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '수신된 메시지가 없습니다',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
                : Column(
              spacing: 8,
              children: messages.map((msg) => _buildMessageCard(theme, msg)).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // QoS 설명
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.tertiary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'QoS (Quality of Service) 레벨',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _buildQosInfo(theme, 'QoS 0', '최대 1회 전달 (Fire and Forget)'),
                _buildQosInfo(theme, 'QoS 1', '최소 1회 전달 (확인 응답 필요)'),
                _buildQosInfo(theme, 'QoS 2', '정확히 1회 전달 (2단계 확인)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageCard(ThemeData theme, ReceivedMqttMessage msg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  msg.topic,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _formatTime(msg.timestamp),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Text(
            msg.message,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildQosInfo(ThemeData theme, String level, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: theme.colorScheme.tertiary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: '$level: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    client?.disconnect();
    topicController.dispose();
    messageController.dispose();
    subscribeTopicController.dispose();
    super.dispose();
  }
}

// 메시지 모델
class ReceivedMqttMessage {
  final String topic;
  final String message;
  final DateTime timestamp;

  ReceivedMqttMessage({
    required this.topic,
    required this.message,
    required this.timestamp,
  });
}