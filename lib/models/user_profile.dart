class UserProfile {
  final String id;
  final String name;
  final String email;
  final int totalPoints;
  final int level;
  final List<String> badges;
  final int totalDetections;
  final int successfulDetections;
  final double averageScore;
  final DateTime joinDate;
  final DateTime lastActive;
  final Map<String, int> statistics;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.totalPoints,
    required this.level,
    required this.badges,
    required this.totalDetections,
    required this.successfulDetections,
    required this.averageScore,
    required this.joinDate,
    required this.lastActive,
    required this.statistics,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'totalPoints': totalPoints,
      'level': level,
      'badges': badges,
      'totalDetections': totalDetections,
      'successfulDetections': successfulDetections,
      'averageScore': averageScore,
      'joinDate': joinDate.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'statistics': statistics,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      totalPoints: json['totalPoints'],
      level: json['level'],
      badges: List<String>.from(json['badges']),
      totalDetections: json['totalDetections'],
      successfulDetections: json['successfulDetections'],
      averageScore: json['averageScore'].toDouble(),
      joinDate: DateTime.parse(json['joinDate']),
      lastActive: DateTime.parse(json['lastActive']),
      statistics: Map<String, int>.from(json['statistics']),
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    int? totalPoints,
    int? level,
    List<String>? badges,
    int? totalDetections,
    int? successfulDetections,
    double? averageScore,
    DateTime? joinDate,
    DateTime? lastActive,
    Map<String, int>? statistics,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      totalDetections: totalDetections ?? this.totalDetections,
      successfulDetections: successfulDetections ?? this.successfulDetections,
      averageScore: averageScore ?? this.averageScore,
      joinDate: joinDate ?? this.joinDate,
      lastActive: lastActive ?? this.lastActive,
      statistics: statistics ?? this.statistics,
    );
  }
}
