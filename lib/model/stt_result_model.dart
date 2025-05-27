class SttResult {
  final int reportId;
  final String sttFileName;
  final String startTime;

  SttResult({
    required this.reportId,
    required this.sttFileName,
    required this.startTime,
  });

  factory SttResult.fromJson(Map<String, dynamic> json) {
    return SttResult(
      reportId: int.tryParse(json['reportid'].toString()) ?? 0,
      sttFileName: json['stt_file_name'] ?? '',
      startTime: json['startTime'] ?? '',
    );
  }
}
