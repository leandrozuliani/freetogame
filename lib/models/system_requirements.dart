class SystemRequirements {
  final String os;
  final String processor;
  final String memory;
  final String graphics;
  final String storage;

  SystemRequirements({
    required this.os,
    required this.processor,
    required this.memory,
    required this.graphics,
    required this.storage,
  });

  factory SystemRequirements.fromJson(Map<String, dynamic> json) {
    return SystemRequirements(
      os: json['os'],
      processor: json['processor'],
      memory: json['memory'],
      graphics: json['graphics'],
      storage: json['storage'],
    );
  }
}
