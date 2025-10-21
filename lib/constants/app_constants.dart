class AppConstants {
  // App Info
  static const String appName = 'Fish Track';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Aplikasi Deteksi Kualitas Ikan Segar';

  // Colors
  static const int primaryColorValue = 0xFF2196F3;
  static const int secondaryColorValue = 0xFF03DAC6;
  static const int accentColorValue = 0xFFFF6B6B;
  static const int successColorValue = 0xFF4CAF50;
  static const int warningColorValue = 0xFFFF9800;
  static const int errorColorValue = 0xFFF44336;

  // Points System
  static const int pointsPerDetection = 10;
  static const int pointsPerSuccessfulDetection = 25;
  static const int pointsPerPerfectScore = 50;
  static const int pointsPerBadge = 100;

  // Levels
  static const List<int> levelThresholds = [
    0,
    100,
    250,
    500,
    1000,
    2000,
    3500,
    5000,
    7500,
    10000,
  ];

  // Badges
  static const List<String> availableBadges = [
    'first_detection',
    'detection_master',
    'quality_expert',
    'speed_demon',
    'perfectionist',
    'explorer',
    'veteran',
    'legend',
  ];

  // Detection Quality Levels
  static const List<String> qualityLevels = [
    'Sangat Segar',
    'Segar',
    'Kurang Segar',
    'Tidak Segar',
  ];

  // Quality Score Thresholds
  static const double excellentThreshold = 0.9;
  static const double goodThreshold = 0.7;
  static const double fairThreshold = 0.5;
  static const double poorThreshold = 0.3;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // Database
  static const String databaseName = 'fish_track.db';
  static const int databaseVersion = 1;

  // Storage Keys
  static const String userProfileKey = 'user_profile';
  static const String appSettingsKey = 'app_settings';
  static const String detectionHistoryKey = 'detection_history';
  static const String pointsKey = 'user_points';
  static const String badgesKey = 'user_badges';

  // API Endpoints (jika diperlukan)
  static const String baseUrl = 'https://api.fishtrack.com';
  static const String detectionEndpoint = '/detect';
  static const String uploadEndpoint = '/upload';

  // File Paths
  static const String modelPath = 'assets/models/fish_quality_model.tflite';
  static const String labelsPath = 'assets/models/labels.txt';

  // Image Processing
  static const int maxImageSize = 1024;
  static const double imageQuality = 0.8;
  static const List<String> supportedFormats = ['jpg', 'jpeg', 'png', 'webp'];

  // Notifications
  static const String notificationChannelId = 'fish_track_notifications';
  static const String notificationChannelName = 'Fish Track Notifications';
  static const String notificationChannelDescription =
      'Notifications for Fish Track app';

  // AR Settings
  static const double arScale = 1.0;
  static const double arRotation = 0.0;
  static const String arModelPath = 'assets/models/fish_ar_model.glb';
}
