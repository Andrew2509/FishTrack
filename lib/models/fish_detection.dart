class FishDetection {
  final String id;
  final String imagePath;
  final double freshnessScore;
  final String quality;
  final DateTime timestamp;
  final Map<String, double> detailedScores;
  final String confidence;
  final List<String> recommendations;

  FishDetection({
    required this.id,
    required this.imagePath,
    required this.freshnessScore,
    required this.quality,
    required this.timestamp,
    required this.detailedScores,
    required this.confidence,
    required this.recommendations,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'freshnessScore': freshnessScore,
      'quality': quality,
      'timestamp': timestamp.toIso8601String(),
      'detailedScores': detailedScores,
      'confidence': confidence,
      'recommendations': recommendations,
    };
  }

  factory FishDetection.fromJson(Map<String, dynamic> json) {
    return FishDetection(
      id: json['id'],
      imagePath: json['imagePath'],
      freshnessScore: json['freshnessScore'].toDouble(),
      quality: json['quality'],
      timestamp: DateTime.parse(json['timestamp']),
      detailedScores: Map<String, double>.from(json['detailedScores']),
      confidence: json['confidence'],
      recommendations: List<String>.from(json['recommendations']),
    );
  }
}
