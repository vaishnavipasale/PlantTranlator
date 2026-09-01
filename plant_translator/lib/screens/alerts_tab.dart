import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum AlertUrgency { urgent, soon, fine }

class PlantAlert {
  const PlantAlert({
    required this.plantName,
    required this.message,
    required this.urgency,
    required this.timeAgo,
  });

  final String plantName;
  final String message;
  final AlertUrgency urgency;
  final String timeAgo;
}

class AlertsTab extends StatefulWidget {
  const AlertsTab({super.key});

  @override
  State<AlertsTab> createState() => _AlertsTabState();
}

class _AlertsTabState extends State<AlertsTab> {
  // Placeholder data — swap for real alerts from your backend/AI voice
  // generation pipeline.
  final List<PlantAlert> _alerts = const [
    PlantAlert(
      plantName: 'Fiddle Leaf Fig',
      message:
          "It's been 6 days and my soil is bone dry, 12% moisture. My leaves are starting to curl. Could you water me today?",
      urgency: AlertUrgency.urgent,
      timeAgo: '2h ago',
    ),
    PlantAlert(
      plantName: 'Snake Plant',
      message: "Doing okay for now, but check on me by Friday — soil's getting a little dry.",
      urgency: AlertUrgency.soon,
      timeAgo: '5h ago',
    ),
    PlantAlert(
      plantName: 'Pothos',
      message: 'Thanks for the water yesterday! Feeling great, no need to check on me for a while.',
      urgency: AlertUrgency.fine,
      timeAgo: '1d ago',
    ),
    PlantAlert(
      plantName: 'Calathea',
      message: "My leaves are curling a bit — might be low humidity. Could you mist me or move me away from the vent?",
      urgency: AlertUrgency.soon,
      timeAgo: '1d ago',
    ),
    PlantAlert(
      plantName: 'Monstera',
      message: 'New leaf unfurled today! Everything is going great, keep doing what you\'re doing.',
      urgency: AlertUrgency.fine,
      timeAgo: '3d ago',
    ),
  ];

  int get _urgentCount => _alerts.where((a) => a.urgency == AlertUrgency.urgent).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green50,
      body: SafeArea(
        child: _alerts.isEmpty
            ? const _EmptyAlerts()
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                children: [
                  _AlertsHeader(urgentCount: _urgentCount, total: _alerts.length),
                  const SizedBox(height: 18),
                  for (final alert in _alerts) ...[
                    _AlertCard(alert: alert),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
      ),
    );
  }
}

class _AlertsHeader extends StatelessWidget {
  const _AlertsHeader({required this.urgentCount, required this.total});

  final int urgentCount;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plant Alerts',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.green900,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                urgentCount > 0
                    ? '$urgentCount plant${urgentCount == 1 ? '' : 's'} need attention now'
                    : 'Everything is under control',
                style: TextStyle(fontSize: 13, color: AppColors.stone600),
              ),
            ],
          ),
        ),
        if (urgentCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.rose500.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.priority_high, size: 15, color: AppColors.rose600),
                const SizedBox(width: 4),
                Text(
                  '$urgentCount',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.rose600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final PlantAlert alert;

  _UrgencyStyle get _style {
    switch (alert.urgency) {
      case AlertUrgency.urgent:
        return _UrgencyStyle(
          bg: AppColors.rose500.withOpacity(0.08),
          border: AppColors.rose500.withOpacity(0.35),
          accent: AppColors.rose600,
          icon: Icons.water_drop,
          label: 'Needs water',
        );
      case AlertUrgency.soon:
        return _UrgencyStyle(
          bg: AppColors.lime400.withOpacity(0.12),
          border: AppColors.lime500.withOpacity(0.4),
          accent: const Color(0xFF8A6D1D),
          icon: Icons.schedule,
          label: 'Check soon',
        );
      case AlertUrgency.fine:
        return _UrgencyStyle(
          bg: Colors.white,
          border: AppColors.green100,
          accent: AppColors.green600,
          icon: Icons.check_circle_outline,
          label: 'All good',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: style.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.stone400.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: style.accent.withOpacity(0.15),
                ),
                child: Icon(style.icon, size: 17, color: style.accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  alert.plantName,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: style.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  style.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: style.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '"${alert.message}"',
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              fontStyle: FontStyle.italic,
              color: AppColors.stone800.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: AppColors.stone400),
              const SizedBox(width: 4),
              Text(
                alert.timeAgo,
                style: TextStyle(fontSize: 11, color: AppColors.stone400),
              ),
              const Spacer(),
              if (alert.urgency != AlertUrgency.fine)
                TextButton(
                  onPressed: () {
                    // TODO: mark plant as watered / cared for
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: style.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'I watered you!',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UrgencyStyle {
  const _UrgencyStyle({
    required this.bg,
    required this.border,
    required this.accent,
    required this.icon,
    required this.label,
  });

  final Color bg;
  final Color border;
  final Color accent;
  final IconData icon;
  final String label;
}

class _EmptyAlerts extends StatelessWidget {
  const _EmptyAlerts();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.green100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.notifications_none_outlined, size: 44, color: AppColors.green600),
            ),
            const SizedBox(height: 18),
            Text(
              'No alerts yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.green900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your plants will speak up here when they need water or attention',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.stone600),
            ),
          ],
        ),
      ),
    );
  }
}