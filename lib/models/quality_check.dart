enum CheckStatus {
  ok,
  warning,
  needsImprovement,
}

class QualityCheckResult {
  final String checkName;
  final CheckStatus status;
  final String feedback;
  final List<String> details;

  QualityCheckResult({
    required this.checkName,
    required this.status,
    required this.feedback,
    this.details = const [],
  });

  String get statusText {
    switch (status) {
      case CheckStatus.ok:
        return "OK";
      case CheckStatus.warning:
        return "Warning";
      case CheckStatus.needsImprovement:
        return "Needs Improvement";
    }
  }
}
