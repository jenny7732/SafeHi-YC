import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'websocket_service.dart';

class AudioWebSocketRecorder {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final WebSocketService ws;

  bool _isRecording = false;
  StreamController<Uint8List>? _streamController;
  StreamSubscription<Uint8List>? _subscription;

  AudioWebSocketRecorder({required this.ws});

  // 1) 마이크 권한 및 초기화
  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    debugPrint('🎤 마이크 권한 상태: $status');

    if (status != PermissionStatus.granted) {
      throw Exception('마이크 권한이 없습니다.');
    }

    await _recorder.openRecorder();
    debugPrint('🎤 마이크 열기 성공');
  }

  // 2) 녹음 시작
  Future<void> startRecording() async {
    if (_isRecording) {
      debugPrint('이미 녹음 중입니다.');
      return;
    }

    _streamController = StreamController<Uint8List>();

    await _recorder.startRecorder(
      toStream: _streamController!.sink,
      codec: Codec.pcm16,
      sampleRate: 16000,
      numChannels: 1,
      audioSource: AudioSource.microphone,
    );

    _subscription = _streamController!.stream.listen((audioBytes) {
      if (audioBytes.isNotEmpty) {
        ws.sendBinary(audioBytes);
      }
    });

    _isRecording = true;
    debugPrint('🎙️ 오디오 녹음 & WebSocket 전송 시작');
  }

  // 3) 녹음 중지
  Future<void> stopRecording() async {
    if (!_isRecording) return;
    _isRecording = false;

    await _subscription?.cancel();
    await _streamController?.close();
    _subscription = null;
    _streamController = null;

    try {
      await _recorder.stopRecorder();
      debugPrint('🛑 오디오 녹음 중지');
    } catch (e) {
      debugPrint('❌ 오디오 녹음 중지 오류: $e');
    }
  }

  // 4) 정리
  Future<void> dispose() async {
    await stopRecording();
    await _recorder.closeRecorder();
    debugPrint('🧹 마이크 정리 완료');
  }
}
