class AttendanceStats {
  final int present;
  final int absent;
  final int cancelled;
  final int targetPercent;

  AttendanceStats({
    required this.present,
    required this.absent,
    required this.cancelled,
    required this.targetPercent,
  });

  int get total => present + absent;
  double get percent => total == 0 ? 0 : (present / total) * 100;
  int get safeLeaves => total == 0 ? 0 : (present - (targetPercent * total / 100)).floor();
  bool get isSafe => total == 0 || percent >= targetPercent;
  int get classesNeeded =>
      total == 0
          ? 0
          : ((targetPercent * total - 100 * present) / (100 - targetPercent)).ceil().clamp(0, 999);

  bool get isDanger => !isSafe;
}

class AttendanceService {
  static AttendanceStats calculate({
    required int present,
    required int absent,
    required int cancelled,
    required int targetPercent,
  }) {
    return AttendanceStats(
      present: present,
      absent: absent,
      cancelled: cancelled,
      targetPercent: targetPercent,
    );
  }
}
