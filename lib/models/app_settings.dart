class AppSettings {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String language;
  final bool autoSave;
  final double detectionSensitivity;
  final bool showTutorial;
  // final bool enableAR; // Temporarily disabled
  final bool enableSoundEffects;
  final String themeColor;

  AppSettings({
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.language,
    required this.autoSave,
    required this.detectionSensitivity,
    required this.showTutorial,
    // required this.enableAR, // Temporarily disabled
    required this.enableSoundEffects,
    required this.themeColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'notificationsEnabled': notificationsEnabled,
      'language': language,
      'autoSave': autoSave,
      'detectionSensitivity': detectionSensitivity,
      'showTutorial': showTutorial,
      // 'enableAR': enableAR, // Temporarily disabled
      'enableSoundEffects': enableSoundEffects,
      'themeColor': themeColor,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isDarkMode: json['isDarkMode'] ?? false,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      language: json['language'] ?? 'id',
      autoSave: json['autoSave'] ?? true,
      detectionSensitivity: json['detectionSensitivity']?.toDouble() ?? 0.5,
      showTutorial: json['showTutorial'] ?? true,
      // enableAR: json['enableAR'] ?? false, // Temporarily disabled
      enableSoundEffects: json['enableSoundEffects'] ?? true,
      themeColor: json['themeColor'] ?? 'blue',
    );
  }

  AppSettings copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    String? language,
    bool? autoSave,
    double? detectionSensitivity,
    bool? showTutorial,
    // bool? enableAR, // Temporarily disabled
    bool? enableSoundEffects,
    String? themeColor,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      autoSave: autoSave ?? this.autoSave,
      detectionSensitivity: detectionSensitivity ?? this.detectionSensitivity,
      showTutorial: showTutorial ?? this.showTutorial,
      // enableAR: enableAR ?? this.enableAR, // Temporarily disabled
      enableSoundEffects: enableSoundEffects ?? this.enableSoundEffects,
      themeColor: themeColor ?? this.themeColor,
    );
  }
}
