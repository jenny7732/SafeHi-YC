class PreviousRecord {
  final int reportId;
  final int reportStatus;
  final String visitTime;
  final TargetInfo target;

  PreviousRecord({
    required this.reportId,
    required this.reportStatus,
    required this.visitTime,
    required this.target,
  });

  factory PreviousRecord.fromJson(Map<String, dynamic> json) {
    return PreviousRecord(
      reportId: json['reportid'] ?? 0,
      reportStatus: json['reportstatue'] ?? 0,
      visitTime: json['visittime'] ?? '',
      target: TargetInfo.fromJson(json['targetInfo'] ?? {}),
    );
  }
}

class TargetInfo {
  final int targetId;
  final String targetName;
  final String address1;
  final String address2;
  final String phone;
  final int gender;
  final int age;

  TargetInfo({
    required this.targetId,
    required this.targetName,
    required this.address1,
    required this.address2,
    required this.phone,
    required this.gender,
    required this.age,
  });

  factory TargetInfo.fromJson(Map<String, dynamic> json) {
    return TargetInfo(
      targetId: json['targetid'] ?? 0,
      targetName: json['targetname'] ?? '이름없음',
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      phone: json['targetcallnum'] ?? json['callnum'] ?? '',
      gender: json['gender'] ?? 0,
      age: json['age'] ?? 0,
    );
  }
}
