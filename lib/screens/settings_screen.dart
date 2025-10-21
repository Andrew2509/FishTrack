import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('Tampilan', [
                  _buildSwitchTile(
                    'Mode Gelap',
                    'Gunakan tema gelap',
                    appProvider.appSettings.isDarkMode,
                    (value) => appProvider.toggleDarkMode(),
                  ),
                  _buildDropdownTile(
                    'Warna Tema',
                    'Pilih warna tema aplikasi',
                    appProvider.appSettings.themeColor,
                    ['blue', 'green', 'purple', 'orange', 'red'],
                    (value) => _updateThemeColor(appProvider, value),
                  ),
                ]),
                const SizedBox(height: 30),

                _buildSection('Notifikasi', [
                  _buildSwitchTile(
                    'Notifikasi',
                    'Terima notifikasi dari aplikasi',
                    appProvider.appSettings.notificationsEnabled,
                    (value) => _updateNotifications(appProvider, value),
                  ),
                ]),
                const SizedBox(height: 30),

                _buildSection('Deteksi', [
                  _buildSliderTile(
                    'Sensitivitas Deteksi',
                    'Sesuaikan kepekaan deteksi',
                    appProvider.appSettings.detectionSensitivity,
                    (value) => _updateDetectionSensitivity(appProvider, value),
                  ),
                  _buildSwitchTile(
                    'Simpan Otomatis',
                    'Simpan hasil deteksi secara otomatis',
                    appProvider.appSettings.autoSave,
                    (value) => _updateAutoSave(appProvider, value),
                  ),
                ]),
                const SizedBox(height: 30),

                _buildSection('Fitur', [
                  // _buildSwitchTile(
                  //   'Mode AR',
                  //   'Gunakan Augmented Reality',
                  //   appProvider.appSettings.enableAR,
                  //   (value) => _updateAR(appProvider, value),
                  // ), // Temporarily disabled
                  _buildSwitchTile(
                    'Efek Suara',
                    'Mainkan efek suara',
                    appProvider.appSettings.enableSoundEffects,
                    (value) => _updateSoundEffects(appProvider, value),
                  ),
                ]),
                const SizedBox(height: 30),

                _buildSection('Aplikasi', [
                  _buildInfoTile('Versi', '1.0.0', Icons.info),
                  _buildInfoTile(
                    'Pembaruan Terakhir',
                    '17 Oktober 2024',
                    Icons.update,
                  ),
                  _buildActionTile(
                    'Reset Data',
                    'Hapus semua data aplikasi',
                    Icons.delete_forever,
                    Colors.red,
                    () => _showResetDialog(),
                  ),
                ]),
                const SizedBox(height: 30),

                _buildSection('Bantuan', [
                  _buildActionTile(
                    'Tutorial',
                    'Pelajari cara menggunakan aplikasi',
                    Icons.help,
                    Theme.of(context).colorScheme.primary,
                    () => _showTutorial(),
                  ),
                  _buildActionTile(
                    'Kontak Dukungan',
                    'Hubungi tim dukungan',
                    Icons.support_agent,
                    Theme.of(context).colorScheme.primary,
                    () => _contactSupport(),
                  ),
                  _buildActionTile(
                    'Tentang',
                    'Informasi tentang aplikasi',
                    Icons.info_outline,
                    Theme.of(context).colorScheme.primary,
                    () => _showAbout(),
                  ),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    String value,
    List<String> options,
    Function(String) onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option.toUpperCase()),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    String subtitle,
    double value,
    Function(double) onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          Text(
            '${(value * 100).toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _updateThemeColor(AppProvider appProvider, String color) {
    final newSettings = appProvider.appSettings.copyWith(themeColor: color);
    appProvider.updateAppSettings(newSettings);
  }

  void _updateNotifications(AppProvider appProvider, bool value) {
    final newSettings = appProvider.appSettings.copyWith(
      notificationsEnabled: value,
    );
    appProvider.updateAppSettings(newSettings);
  }

  void _updateDetectionSensitivity(AppProvider appProvider, double value) {
    final newSettings = appProvider.appSettings.copyWith(
      detectionSensitivity: value,
    );
    appProvider.updateAppSettings(newSettings);
  }

  void _updateAutoSave(AppProvider appProvider, bool value) {
    final newSettings = appProvider.appSettings.copyWith(autoSave: value);
    appProvider.updateAppSettings(newSettings);
  }

  // void _updateAR(AppProvider appProvider, bool value) {
  //   final newSettings = appProvider.appSettings.copyWith(enableAR: value);
  //   appProvider.updateAppSettings(newSettings);
  // } // Temporarily disabled

  void _updateSoundEffects(AppProvider appProvider, bool value) {
    final newSettings = appProvider.appSettings.copyWith(
      enableSoundEffects: value,
    );
    appProvider.updateAppSettings(newSettings);
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Data'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus semua data aplikasi? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetData();
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _resetData() {
    // Implement reset data functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data berhasil direset'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showTutorial() {
    // Navigate to tutorial screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tutorial akan segera tersedia')),
    );
  }

  void _contactSupport() {
    // Open contact support
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kontak dukungan akan segera tersedia')),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Aplikasi'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fish Track v1.0.0'),
            SizedBox(height: 8),
            Text('Aplikasi Deteksi Kualitas Ikan Segar'),
            SizedBox(height: 8),
            Text('Dibuat dengan Flutter'),
            SizedBox(height: 8),
            Text('© 2024 Fish Track Team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
