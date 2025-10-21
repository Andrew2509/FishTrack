import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_profile.dart';
import '../models/app_settings.dart';
import '../models/fish_detection.dart';
import '../constants/app_constants.dart';

class AppProvider extends ChangeNotifier {
  UserProfile? _userProfile;
  AppSettings _appSettings = AppSettings(
    isDarkMode: false,
    notificationsEnabled: true,
    language: 'id',
    autoSave: true,
    detectionSensitivity: 0.5,
    showTutorial: true,
    // enableAR: false, // Temporarily disabled
    enableSoundEffects: true,
    themeColor: 'blue',
  );
  List<FishDetection> _detectionHistory = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  UserProfile? get userProfile => _userProfile;
  AppSettings get appSettings => _appSettings;
  List<FishDetection> get detectionHistory => _detectionHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isDarkMode => _appSettings.isDarkMode;

  // Initialize app
  Future<void> initializeApp() async {
    _setLoading(true);
    try {
      await _loadUserProfile();
      await _loadAppSettings();
      await _loadDetectionHistory();
    } catch (e) {
      _setError('Gagal menginisialisasi aplikasi: $e');
    } finally {
      _setLoading(false);
    }
  }

  // User Profile Methods
  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(AppConstants.userProfileKey);

      if (profileJson != null) {
        _userProfile = UserProfile.fromJson(json.decode(profileJson));
      } else {
        // Create default profile
        _userProfile = UserProfile(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Pengguna Baru',
          email: 'user@fishtrack.com',
          totalPoints: 0,
          level: 1,
          badges: [],
          totalDetections: 0,
          successfulDetections: 0,
          averageScore: 0.0,
          joinDate: DateTime.now(),
          lastActive: DateTime.now(),
          statistics: {},
        );
        await _saveUserProfile();
      }
    } catch (e) {
      _setError('Gagal memuat profil pengguna: $e');
    }
  }

  Future<void> _saveUserProfile() async {
    if (_userProfile != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          AppConstants.userProfileKey,
          json.encode(_userProfile!.toJson()),
        );
      } catch (e) {
        _setError('Gagal menyimpan profil pengguna: $e');
      }
    }
  }

  Future<void> updateUserProfile(UserProfile newProfile) async {
    _userProfile = newProfile;
    await _saveUserProfile();
    notifyListeners();
  }

  // App Settings Methods
  Future<void> _loadAppSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(AppConstants.appSettingsKey);

      if (settingsJson != null) {
        _appSettings = AppSettings.fromJson(json.decode(settingsJson));
      }
    } catch (e) {
      _setError('Gagal memuat pengaturan aplikasi: $e');
    }
  }

  Future<void> updateAppSettings(AppSettings newSettings) async {
    _appSettings = newSettings;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.appSettingsKey,
        json.encode(_appSettings.toJson()),
      );
      notifyListeners();
    } catch (e) {
      _setError('Gagal menyimpan pengaturan: $e');
    }
  }

  Future<void> toggleDarkMode() async {
    final newSettings = _appSettings.copyWith(
      isDarkMode: !_appSettings.isDarkMode,
    );
    await updateAppSettings(newSettings);
  }

  // Detection History Methods
  Future<void> _loadDetectionHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(AppConstants.detectionHistoryKey);

      if (historyJson != null) {
        final List<dynamic> historyList = json.decode(historyJson);
        _detectionHistory = historyList
            .map((item) => FishDetection.fromJson(item))
            .toList();
      }
    } catch (e) {
      _setError('Gagal memuat riwayat deteksi: $e');
    }
  }

  Future<void> addDetection(FishDetection detection) async {
    _detectionHistory.insert(0, detection);

    // Update user statistics
    if (_userProfile != null) {
      final newTotalDetections = _userProfile!.totalDetections + 1;
      final newSuccessfulDetections = detection.freshnessScore > 0.7
          ? _userProfile!.successfulDetections + 1
          : _userProfile!.successfulDetections;

      final newAverageScore =
          _detectionHistory
              .map((d) => d.freshnessScore)
              .reduce((a, b) => a + b) /
          _detectionHistory.length;

      final newProfile = _userProfile!.copyWith(
        totalDetections: newTotalDetections,
        successfulDetections: newSuccessfulDetections,
        averageScore: newAverageScore,
        lastActive: DateTime.now(),
      );

      await updateUserProfile(newProfile);
    }

    await _saveDetectionHistory();
    notifyListeners();
  }

  Future<void> _saveDetectionHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = json.encode(
        _detectionHistory.map((detection) => detection.toJson()).toList(),
      );
      await prefs.setString(AppConstants.detectionHistoryKey, historyJson);
    } catch (e) {
      _setError('Gagal menyimpan riwayat deteksi: $e');
    }
  }

  // Points and Level System
  Future<void> addPoints(int points) async {
    if (_userProfile != null) {
      final newTotalPoints = _userProfile!.totalPoints + points;
      final newLevel = _calculateLevel(newTotalPoints);

      final newProfile = _userProfile!.copyWith(
        totalPoints: newTotalPoints,
        level: newLevel,
      );

      await updateUserProfile(newProfile);
    }
  }

  int _calculateLevel(int totalPoints) {
    for (int i = AppConstants.levelThresholds.length - 1; i >= 0; i--) {
      if (totalPoints >= AppConstants.levelThresholds[i]) {
        return i + 1;
      }
    }
    return 1;
  }

  Future<void> addBadge(String badgeId) async {
    if (_userProfile != null && !_userProfile!.badges.contains(badgeId)) {
      final newBadges = List<String>.from(_userProfile!.badges)..add(badgeId);
      final newProfile = _userProfile!.copyWith(badges: newBadges);
      await updateUserProfile(newProfile);
    }
  }

  // Utility Methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Statistics
  Map<String, dynamic> getStatistics() {
    if (_detectionHistory.isEmpty) {
      return {
        'totalDetections': 0,
        'successfulDetections': 0,
        'averageScore': 0.0,
        'qualityDistribution': <String, dynamic>{},
        'weeklyStats': [],
      };
    }

    final qualityDistribution = <String, int>{};
    for (final detection in _detectionHistory) {
      qualityDistribution[detection.quality] =
          (qualityDistribution[detection.quality] ?? 0) + 1;
    }

    return {
      'totalDetections': _detectionHistory.length,
      'successfulDetections': _detectionHistory
          .where((d) => d.freshnessScore > 0.7)
          .length,
      'averageScore':
          _detectionHistory
              .map((d) => d.freshnessScore)
              .reduce((a, b) => a + b) /
          _detectionHistory.length,
      'qualityDistribution': Map<String, dynamic>.from(qualityDistribution),
      'weeklyStats': _getWeeklyStats(),
    };
  }

  List<Map<String, dynamic>> _getWeeklyStats() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final weeklyDetections = _detectionHistory
        .where((d) => d.timestamp.isAfter(weekAgo))
        .toList();

    final Map<int, int> dailyCounts = {};
    for (int i = 0; i < 7; i++) {
      dailyCounts[i] = 0;
    }

    for (final detection in weeklyDetections) {
      final dayOfWeek = detection.timestamp.weekday - 1;
      dailyCounts[dayOfWeek] = (dailyCounts[dayOfWeek] ?? 0) + 1;
    }

    return dailyCounts.entries
        .map((entry) => {'day': entry.key, 'count': entry.value})
        .toList();
  }
}
