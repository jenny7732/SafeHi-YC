import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safehi_yc/service/audio_service.dart';
import 'package:safehi_yc/service/websocket_service.dart';
import 'package:safehi_yc/styles/app_colors.dart';
import 'package:safehi_yc/util/responsive.dart';
import 'package:safehi_yc/view/visit/visit_finish.dart';
import 'package:safehi_yc/view_model/user_view_model.dart';
import 'package:safehi_yc/widget/appbar/default_back_appbar.dart';
import 'package:safehi_yc/widget/button/bottom_one_btn.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:provider/provider.dart';

class VisitProcess extends StatefulWidget {
  final int reportId;

  const VisitProcess({super.key, required this.reportId});

  @override
  State<VisitProcess> createState() => _VisitProcessState();
}

class _VisitProcessState extends State<VisitProcess>
    with SingleTickerProviderStateMixin {
  final List<String> _sttTexts = [];
  final ScrollController _scrollController = ScrollController();

  final WebSocketService _ws = WebSocketService();
  late final AudioWebSocketRecorder _audio;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  StreamSubscription? _wsSub;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _audio = AudioWebSocketRecorder(ws: _ws);
    _setupConnection();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _setupConnection() async {
    try {
      await _ws.connect('ws://211.188.55.88:8085');
      debugPrint('✅ 서버 연결 성공');

      final email = context.read<UserViewModel>().user?.email ?? 'unknown';
      final metadata = {'reportid': widget.reportId, 'email': email};
      _ws.sendMessage(jsonEncode(metadata));
      debugPrint('[✅ 메타데이터 전송] $metadata');

      _wsSub = _ws.stream?.listen((message) {
        setState(() => _sttTexts.add(message.toString()));
        _scrollToBottom();
      });

      await _audio.initRecorder();
      await _audio.startRecording();
    } catch (e) {
      debugPrint('[WebSocket 오류] $e');
      _showDialog('오류 발생', e.toString());
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showDialog(String title, String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    _wsSub?.cancel();
    _audio.dispose();
    _ws.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors().background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.paddingHorizontal,
          ),
          child: Column(
            children: [
              const DefaultBackAppBar(title: '실시간 대화'),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          padding: EdgeInsets.all(responsive.itemSpacing),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade100,
                                AppColors().primary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors().primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.mic,
                            color: Colors.white,
                            size: responsive.iconSize,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '어르신의 말씀을 하나하나 담고 있어요 :)',
                        style: TextStyle(
                          color: AppColors().primary,
                          fontSize: responsive.fontBase + 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: responsive.screenHeight * 0.45,
                          minHeight: responsive.screenHeight * 0.45,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.itemSpacing,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          controller: _scrollController,
                          itemCount: _sttTexts.length,
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.itemSpacing,
                          ),
                          separatorBuilder:
                              (_, __) =>
                                  SizedBox(height: responsive.itemSpacing),
                          itemBuilder:
                              (context, index) =>
                                  _buildBubble(_sttTexts[index], responsive),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: responsive.paddingHorizontal),
        child: BottomOneButton(
          buttonText: '종료',
          onButtonTap: () async {
            WakelockPlus.disable();
            await _audio.stopRecording();
            _ws.disconnect();

            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VisitFinish()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBubble(String text, Responsive responsive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: responsive.itemSpacing),
          child: Icon(
            Icons.chat_bubble_outline,
            color: Colors.deepOrangeAccent.shade200,
            size: responsive.iconSize * 0.55,
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(responsive.itemSpacing * 0.85),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.deepOrangeAccent.shade100,
                width: 1,
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: responsive.fontBase,
                color: Colors.grey.shade900,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
