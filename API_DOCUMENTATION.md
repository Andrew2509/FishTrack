# Fish Track - API Documentation

## 📡 Service Layer Documentation

### DetectionService

#### Overview

Service utama untuk deteksi kualitas ikan menggunakan teknologi AI.

#### Methods

##### `detectFishQuality(File imageFile)`

**Description**: Mendeteksi kualitas ikan dari gambar yang diberikan.

**Parameters**:

- `imageFile` (File): File gambar ikan yang akan dianalisis

**Returns**: `Future<FishDetection>`

**Example**:

```dart
final detectionService = DetectionService();
final result = await detectionService.detectFishQuality(imageFile);
print('Quality: ${result.quality}');
print('Score: ${result.freshnessScore}');
```

##### `preprocessImage(File imageFile)`

**Description**: Preprocessing gambar sebelum deteksi.

**Parameters**:

- `imageFile` (File): File gambar asli

**Returns**: `Future<File>`

##### `applyImageFilter(File imageFile, String filterType, Map<String, dynamic> settings)`

**Description**: Menerapkan filter pada gambar.

**Parameters**:

- `imageFile` (File): File gambar
- `filterType` (String): Jenis filter ('brightness', 'contrast', 'saturation', dll)
- `settings` (Map<String, dynamic>): Pengaturan filter

**Returns**: `Future<File>`

##### `enhanceImageQuality(File imageFile)`

**Description**: Meningkatkan kualitas gambar.

**Parameters**:

- `imageFile` (File): File gambar

**Returns**: `Future<File>`

##### `validateImageQuality(File imageFile)`

**Description**: Validasi kualitas gambar.

**Parameters**:

- `imageFile` (File): File gambar

**Returns**: `bool`

##### `getDetectionConfidence(FishDetection detection)`

**Description**: Menghitung tingkat kepercayaan deteksi.

**Parameters**:

- `detection` (FishDetection): Hasil deteksi

**Returns**: `double`

## 🗄️ Data Models

### FishDetection

#### Properties

```dart
class FishDetection {
  final String id;                    // Unique identifier
  final String imagePath;             // Path to image file
  final double freshnessScore;        // Score 0.0 - 1.0
  final String quality;               // Quality level text
  final DateTime timestamp;           // Detection timestamp
  final Map<String, double> detailedScores;  // Detailed analysis scores
  final String confidence;            // Confidence percentage
  final List<String> recommendations; // AI recommendations
}
```

#### Methods

- `toJson()`: Convert to JSON
- `fromJson(Map<String, dynamic> json)`: Create from JSON

### UserProfile

#### Properties

```dart
class UserProfile {
  final String id;                    // User ID
  final String name;                  // User name
  final String email;                 // User email
  final int totalPoints;              // Total points earned
  final int level;                    // Current level
  final List<String> badges;          // Earned badges
  final int totalDetections;          // Total detections made
  final int successfulDetections;     // Successful detections
  final double averageScore;          // Average detection score
  final DateTime joinDate;            // Account creation date
  final DateTime lastActive;          // Last activity date
  final Map<String, int> statistics;  // User statistics
}
```

#### Methods

- `toJson()`: Convert to JSON
- `fromJson(Map<String, dynamic> json)`: Create from JSON
- `copyWith(...)`: Create copy with modified fields

### AppSettings

#### Properties

```dart
class AppSettings {
  final bool isDarkMode;              // Dark mode enabled
  final bool notificationsEnabled;    // Notifications enabled
  final String language;              // App language
  final bool autoSave;                // Auto-save enabled
  final double detectionSensitivity;  // Detection sensitivity 0.0-1.0
  final bool showTutorial;            // Show tutorial
  final bool enableAR;                // AR mode enabled
  final bool enableSoundEffects;      // Sound effects enabled
  final String themeColor;            // Theme color
}
```

## 🔧 Provider Documentation

### AppProvider

#### Overview

Main provider untuk state management aplikasi.

#### Properties

- `userProfile`: Current user profile
- `appSettings`: App settings
- `detectionHistory`: List of detections
- `isLoading`: Loading state
- `error`: Error message

#### Methods

##### `initializeApp()`

**Description**: Initialize aplikasi dan load data.

**Returns**: `Future<void>`

##### `updateUserProfile(UserProfile newProfile)`

**Description**: Update user profile.

**Parameters**:

- `newProfile` (UserProfile): New profile data

**Returns**: `Future<void>`

##### `updateAppSettings(AppSettings newSettings)`

**Description**: Update app settings.

**Parameters**:

- `newSettings` (AppSettings): New settings

**Returns**: `Future<void>`

##### `toggleDarkMode()`

**Description**: Toggle dark mode.

**Returns**: `Future<void>`

##### `addDetection(FishDetection detection)`

**Description**: Add new detection to history.

**Parameters**:

- `detection` (FishDetection): Detection result

**Returns**: `Future<void>`

##### `addPoints(int points)`

**Description**: Add points to user.

**Parameters**:

- `points` (int): Points to add

**Returns**: `Future<void>`

##### `addBadge(String badgeId)`

**Description**: Add badge to user.

**Parameters**:

- `badgeId` (String): Badge identifier

**Returns**: `Future<void>`

##### `getStatistics()`

**Description**: Get user statistics.

**Returns**: `Map<String, dynamic>`

## 📊 Constants

### AppConstants

#### App Info

```dart
static const String appName = 'Fish Track';
static const String appVersion = '1.0.0';
static const String appDescription = 'Aplikasi Deteksi Kualitas Ikan Segar';
```

#### Colors

```dart
static const int primaryColorValue = 0xFF2196F3;
static const int secondaryColorValue = 0xFF03DAC6;
static const int accentColorValue = 0xFFFF6B6B;
static const int successColorValue = 0xFF4CAF50;
static const int warningColorValue = 0xFFFF9800;
static const int errorColorValue = 0xFFF44336;
```

#### Points System

```dart
static const int pointsPerDetection = 10;
static const int pointsPerSuccessfulDetection = 25;
static const int pointsPerPerfectScore = 50;
static const int pointsPerBadge = 100;
```

#### Level Thresholds

```dart
static const List<int> levelThresholds = [
  0, 100, 250, 500, 1000, 2000, 3500, 5000, 7500, 10000
];
```

#### Quality Levels

```dart
static const List<String> qualityLevels = [
  'Sangat Segar',
  'Segar',
  'Kurang Segar',
  'Tidak Segar'
];
```

#### Quality Thresholds

```dart
static const double excellentThreshold = 0.9;
static const double goodThreshold = 0.7;
static const double fairThreshold = 0.5;
static const double poorThreshold = 0.3;
```

## 🎨 Widget Documentation

### Custom Widgets

#### AnimatedBackground

**Description**: Latar belakang animasi dengan gelombang air dan ikan berenang.

**Properties**:

- None (stateless widget)

**Usage**:

```dart
AnimatedBackground()
```

#### FeaturedCard

**Description**: Kartu fitur dengan animasi hover.

**Properties**:

- `icon` (IconData): Icon untuk kartu
- `title` (String): Judul kartu
- `description` (String): Deskripsi kartu
- `onTap` (VoidCallback): Callback saat ditekan
- `gradient` (Gradient?): Gradien warna (optional)

#### QuickActionButton

**Description**: Tombol aksi cepat dengan animasi.

**Properties**:

- `icon` (IconData): Icon tombol
- `title` (String): Judul tombol
- `subtitle` (String): Subtitle tombol
- `onTap` (VoidCallback): Callback saat ditekan
- `gradient` (Gradient): Gradien warna

#### StatsOverview

**Description**: Overview statistik pengguna.

**Properties**:

- `userProfile` (UserProfile): Profil pengguna
- `statistics` (Map<String, dynamic>): Data statistik

#### DetectionResultWidget

**Description**: Widget hasil deteksi dengan animasi.

**Properties**:

- `detection` (FishDetection): Hasil deteksi
- `onRetry` (VoidCallback): Callback retry
- `onSave` (VoidCallback): Callback save

#### BadgeWidget

**Description**: Widget lencana dengan status unlock.

**Properties**:

- `badgeId` (String): ID lencana
- `isUnlocked` (bool): Status unlock
- `onTap` (VoidCallback): Callback saat ditekan

#### LevelProgressWidget

**Description**: Progress bar level dengan animasi.

**Properties**:

- `currentLevel` (int): Level saat ini
- `currentPoints` (int): Poin saat ini
- `levelThresholds` (List<int>): Threshold level

#### AchievementWidget

**Description**: Widget pencapaian dengan progress.

**Properties**:

- `title` (String): Judul pencapaian
- `description` (String): Deskripsi pencapaian
- `isUnlocked` (bool): Status unlock
- `progress` (double): Progress 0.0-1.0

## 🔄 State Management Flow

### 1. App Initialization

```
SplashScreen -> AppProvider.initializeApp() -> HomeScreen
```

### 2. Detection Flow

```
DetectionScreen -> DetectionService.detectFishQuality() ->
AppProvider.addDetection() -> Update Statistics
```

### 3. Settings Update

```
SettingsScreen -> AppProvider.updateAppSettings() ->
Save to SharedPreferences -> Update UI
```

### 4. Profile Update

```
ProfileScreen -> AppProvider.updateUserProfile() ->
Save to SharedPreferences -> Update UI
```

## 📱 Platform-Specific Features

### Android

- Camera permissions
- File system access
- Notification channels
- Background processing

### iOS

- Camera permissions
- Photo library access
- Push notifications
- Background app refresh

### Web

- Camera API
- File upload
- Local storage
- Service workers

## 🚀 Performance Optimization

### Image Processing

- Image compression
- Lazy loading
- Memory management
- Cache optimization

### Animation Performance

- Hardware acceleration
- Frame rate optimization
- Memory leak prevention
- Smooth transitions

### Data Management

- Efficient state updates
- Minimal rebuilds
- Memory optimization
- Database indexing

## 🔒 Security Considerations

### Data Protection

- Local data encryption
- Secure storage
- Privacy compliance
- Data anonymization

### API Security

- Input validation
- Error handling
- Rate limiting
- Authentication

## 📈 Analytics & Monitoring

### User Analytics

- Detection frequency
- Feature usage
- Performance metrics
- Error tracking

### App Performance

- Load times
- Memory usage
- Battery consumption
- Network usage

---

**Fish Track API Documentation** - Comprehensive guide for developers 🐟📚
