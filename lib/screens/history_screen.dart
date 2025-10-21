import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/app_provider.dart';
import '../models/fish_detection.dart';
import '../widgets/detection_history_card.dart';
import '../widgets/statistics_chart.dart';
import '../constants/app_constants.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';
  String _sortBy = 'date';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Deteksi'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Riwayat', icon: Icon(Icons.history)),
            Tab(text: 'Statistik', icon: Icon(Icons.analytics)),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _onFilterChanged,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('Semua')),
              const PopupMenuItem(
                value: 'excellent',
                child: Text('Sangat Segar'),
              ),
              const PopupMenuItem(value: 'good', child: Text('Segar')),
              const PopupMenuItem(value: 'fair', child: Text('Kurang Segar')),
              const PopupMenuItem(value: 'poor', child: Text('Tidak Segar')),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildHistoryTab(), _buildStatisticsTab()],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final filteredHistory = _filterDetections(appProvider.detectionHistory);
        final sortedHistory = _sortDetections(filteredHistory);

        if (sortedHistory.isEmpty) {
          return _buildEmptyState();
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
            itemCount: sortedHistory.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: AppConstants.mediumAnimation,
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: DetectionHistoryCard(
                      detection: sortedHistory[index],
                      onTap: () => _showDetectionDetails(sortedHistory[index]),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStatisticsTab() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final statistics = appProvider.getStatistics();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Cards
              _buildOverviewCards(statistics),
              const SizedBox(height: 30),

              // Quality Distribution Chart
              _buildQualityDistributionChart(statistics),
              const SizedBox(height: 30),

              // Weekly Statistics
              _buildWeeklyStatistics(statistics),
              const SizedBox(height: 30),

              // Detailed Analysis
              _buildDetailedAnalysis(statistics),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'Belum Ada Riwayat Deteksi',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai deteksi ikan untuk melihat riwayat di sini',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Mulai Deteksi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(Map<String, dynamic> statistics) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Deteksi',
            '${statistics['totalDetections']}',
            Icons.visibility,
            Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Berhasil',
            '${statistics['successfulDetections']}',
            Icons.check_circle,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQualityDistributionChart(Map<String, dynamic> statistics) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribusi Kualitas',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          StatisticsChart(
            data:
                (statistics['qualityDistribution'] as Map<String, dynamic>?) ??
                <String, dynamic>{},
            chartType: ChartType.pie,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatistics(Map<String, dynamic> statistics) {
    final weeklyStats =
        (statistics['weeklyStats'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        <Map<String, dynamic>>[];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik Mingguan',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          StatisticsChart(
            data: Map.fromEntries(
              weeklyStats.asMap().entries.map((entry) {
                final dayNames = [
                  'Sen',
                  'Sel',
                  'Rab',
                  'Kam',
                  'Jum',
                  'Sab',
                  'Min',
                ];
                return MapEntry(
                  dayNames[entry.value['day']],
                  entry.value['count'],
                );
              }),
            ),
            chartType: ChartType.bar,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedAnalysis(Map<String, dynamic> statistics) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analisis Detail',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildAnalysisItem(
            'Skor Rata-rata',
            '${((statistics['averageScore'] as double? ?? 0.0) * 100).toStringAsFixed(1)}%',
            Icons.trending_up,
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildAnalysisItem(
            'Tingkat Keberhasilan',
            '${((statistics['successfulDetections'] as int? ?? 0) / ((statistics['totalDetections'] as int? ?? 1)) * 100).toStringAsFixed(1)}%',
            Icons.check_circle,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildAnalysisItem(
            'Total Poin',
            '${Provider.of<AppProvider>(context, listen: false).userProfile?.totalPoints ?? 0}',
            Icons.stars,
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<FishDetection> _filterDetections(List<FishDetection> detections) {
    if (_selectedFilter == 'all') return detections;

    return detections.where((detection) {
      switch (_selectedFilter) {
        case 'excellent':
          return detection.freshnessScore >= 0.8;
        case 'good':
          return detection.freshnessScore >= 0.6 &&
              detection.freshnessScore < 0.8;
        case 'fair':
          return detection.freshnessScore >= 0.4 &&
              detection.freshnessScore < 0.6;
        case 'poor':
          return detection.freshnessScore < 0.4;
        default:
          return true;
      }
    }).toList();
  }

  List<FishDetection> _sortDetections(List<FishDetection> detections) {
    switch (_sortBy) {
      case 'date':
        detections.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        break;
      case 'score':
        detections.sort((a, b) => b.freshnessScore.compareTo(a.freshnessScore));
        break;
      case 'quality':
        detections.sort((a, b) => a.quality.compareTo(b.quality));
        break;
    }
    return detections;
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _showDetectionDetails(FishDetection detection) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Deteksi',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      // Add detailed detection information here
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
