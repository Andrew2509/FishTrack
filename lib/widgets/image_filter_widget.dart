import 'package:flutter/material.dart';

class ImageFilterWidget extends StatefulWidget {
  final String selectedFilter;
  final Map<String, dynamic> filterSettings;
  final Function(String, Map<String, dynamic>) onFilterChanged;
  final VoidCallback onApplyFilter;

  const ImageFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.filterSettings,
    required this.onFilterChanged,
    required this.onApplyFilter,
  });

  @override
  State<ImageFilterWidget> createState() => _ImageFilterWidgetState();
}

class _ImageFilterWidgetState extends State<ImageFilterWidget> {
  final List<FilterOption> _filters = [
    FilterOption(
      id: 'none',
      name: 'Tanpa Filter',
      icon: Icons.image,
      description: 'Gambar asli tanpa filter',
    ),
    FilterOption(
      id: 'brightness',
      name: 'Kecerahan',
      icon: Icons.brightness_6,
      description: 'Sesuaikan kecerahan gambar',
      settings: {'brightness': 0.0},
    ),
    FilterOption(
      id: 'contrast',
      name: 'Kontras',
      icon: Icons.contrast,
      description: 'Tingkatkan kontras gambar',
      settings: {'contrast': 1.0},
    ),
    FilterOption(
      id: 'saturation',
      name: 'Saturasi',
      icon: Icons.palette,
      description: 'Sesuaikan saturasi warna',
      settings: {'saturation': 1.0},
    ),
    FilterOption(
      id: 'sharpen',
      name: 'Ketajaman',
      icon: Icons.center_focus_strong,
      description: 'Tingkatkan ketajaman gambar',
      settings: {'sharpen': 0.0},
    ),
    FilterOption(
      id: 'enhance',
      name: 'Peningkatan',
      icon: Icons.auto_awesome,
      description: 'Peningkatan otomatis kualitas',
      settings: {'enhance': true},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            'Filter Gambar',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Filter Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected = widget.selectedFilter == filter.id;

              return GestureDetector(
                onTap: () => _selectFilter(filter),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.outline.withOpacity(0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        filter.icon,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.7),
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        filter.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Filter Settings
          if (widget.selectedFilter != 'none' &&
              widget.selectedFilter != 'enhance')
            _buildFilterSettings(),

          const SizedBox(height: 16),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onApplyFilter,
              icon: const Icon(Icons.check),
              label: const Text('Terapkan Filter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSettings() {
    final filter = _filters.firstWhere((f) => f.id == widget.selectedFilter);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengaturan ${filter.name}',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (filter.id == 'brightness')
            _buildBrightnessSlider()
          else if (filter.id == 'contrast')
            _buildContrastSlider()
          else if (filter.id == 'saturation')
            _buildSaturationSlider()
          else if (filter.id == 'sharpen')
            _buildSharpenSlider(),
        ],
      ),
    );
  }

  Widget _buildBrightnessSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kecerahan'),
            Text(
              '${((widget.filterSettings['brightness'] ?? 0.0) * 100).round()}%',
            ),
          ],
        ),
        Slider(
          value: (widget.filterSettings['brightness'] ?? 0.0).clamp(-1.0, 1.0),
          min: -1.0,
          max: 1.0,
          divisions: 20,
          onChanged: (value) {
            widget.onFilterChanged(widget.selectedFilter, {
              ...widget.filterSettings,
              'brightness': value,
            });
          },
        ),
      ],
    );
  }

  Widget _buildContrastSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kontras'),
            Text(
              '${((widget.filterSettings['contrast'] ?? 1.0) * 100).round()}%',
            ),
          ],
        ),
        Slider(
          value: (widget.filterSettings['contrast'] ?? 1.0).clamp(0.0, 2.0),
          min: 0.0,
          max: 2.0,
          divisions: 20,
          onChanged: (value) {
            widget.onFilterChanged(widget.selectedFilter, {
              ...widget.filterSettings,
              'contrast': value,
            });
          },
        ),
      ],
    );
  }

  Widget _buildSaturationSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Saturasi'),
            Text(
              '${((widget.filterSettings['saturation'] ?? 1.0) * 100).round()}%',
            ),
          ],
        ),
        Slider(
          value: (widget.filterSettings['saturation'] ?? 1.0).clamp(0.0, 2.0),
          min: 0.0,
          max: 2.0,
          divisions: 20,
          onChanged: (value) {
            widget.onFilterChanged(widget.selectedFilter, {
              ...widget.filterSettings,
              'saturation': value,
            });
          },
        ),
      ],
    );
  }

  Widget _buildSharpenSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ketajaman'),
            Text(
              '${((widget.filterSettings['sharpen'] ?? 0.0) * 100).round()}%',
            ),
          ],
        ),
        Slider(
          value: (widget.filterSettings['sharpen'] ?? 0.0).clamp(0.0, 1.0),
          min: 0.0,
          max: 1.0,
          divisions: 10,
          onChanged: (value) {
            widget.onFilterChanged(widget.selectedFilter, {
              ...widget.filterSettings,
              'sharpen': value,
            });
          },
        ),
      ],
    );
  }

  void _selectFilter(FilterOption filter) {
    widget.onFilterChanged(filter.id, filter.settings ?? {});
  }
}

class FilterOption {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final Map<String, dynamic>? settings;

  FilterOption({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    this.settings,
  });
}
