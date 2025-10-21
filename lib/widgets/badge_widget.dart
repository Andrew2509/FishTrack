import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final String badgeId;
  final bool isUnlocked;
  final VoidCallback onTap;

  const BadgeWidget({
    super.key,
    required this.badgeId,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnlocked
              ? _getBadgeColor().withOpacity(0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? _getBadgeColor()
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: isUnlocked ? 2 : 1,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: _getBadgeColor().withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? _getBadgeColor()
                    : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: _getBadgeColor().withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                _getBadgeIcon(),
                color: isUnlocked
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _getBadgeName(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isUnlocked
                    ? _getBadgeColor()
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              _getBadgeDescription(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (isUnlocked) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getBadgeColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'DIPEROLEH',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getBadgeName() {
    switch (badgeId) {
      case 'first_detection':
        return 'Deteksi Pertama';
      case 'detection_master':
        return 'Master Deteksi';
      case 'quality_expert':
        return 'Ahli Kualitas';
      case 'speed_demon':
        return 'Deteksi Cepat';
      case 'perfectionist':
        return 'Perfeksionis';
      case 'explorer':
        return 'Penjelajah';
      case 'veteran':
        return 'Veteran';
      case 'legend':
        return 'Legenda';
      default:
        return 'Lencana';
    }
  }

  String _getBadgeDescription() {
    switch (badgeId) {
      case 'first_detection':
        return 'Lakukan deteksi pertama';
      case 'detection_master':
        return 'Lakukan 10 deteksi';
      case 'quality_expert':
        return 'Skor rata-rata 80%+';
      case 'speed_demon':
        return 'Deteksi dalam 5 detik';
      case 'perfectionist':
        return '10 deteksi sempurna';
      case 'explorer':
        return 'Gunakan semua fitur';
      case 'veteran':
        return '100 deteksi';
      case 'legend':
        return '1000 deteksi';
      default:
        return 'Lencana khusus';
    }
  }

  IconData _getBadgeIcon() {
    switch (badgeId) {
      case 'first_detection':
        return Icons.visibility;
      case 'detection_master':
        return Icons.auto_awesome;
      case 'quality_expert':
        return Icons.star;
      case 'speed_demon':
        return Icons.speed;
      case 'perfectionist':
        return Icons.check_circle;
      case 'explorer':
        return Icons.explore;
      case 'veteran':
        return Icons.military_tech;
      case 'legend':
        return Icons.emoji_events;
      default:
        return Icons.emoji_events;
    }
  }

  Color _getBadgeColor() {
    switch (badgeId) {
      case 'first_detection':
        return Colors.blue;
      case 'detection_master':
        return Colors.green;
      case 'quality_expert':
        return Colors.amber;
      case 'speed_demon':
        return Colors.red;
      case 'perfectionist':
        return Colors.purple;
      case 'explorer':
        return Colors.teal;
      case 'veteran':
        return Colors.orange;
      case 'legend':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}
