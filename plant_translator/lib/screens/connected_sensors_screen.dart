import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ConnectedSensorsScreen extends StatelessWidget {
  const ConnectedSensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sensors = [
      (
        Icons.water_drop_outlined,
        'Soil Moisture Pro',
        'Monstera · Living room',
        true,
        '92%',
      ),
      (
        Icons.wb_sunny_outlined,
        'Light Sensor',
        'Fiddle Leaf Fig · Office',
        true,
        '78%',
      ),
      (
        Icons.thermostat_outlined,
        'Climate Tracker',
        'Snake Plant · Bedroom',
        false,
        null,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.stone50,
      appBar: AppBar(
        backgroundColor: AppColors.stone50,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.green900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Connected sensors',
          style: TextStyle(
            color: AppColors.green900,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
          children: [
            for (final s in sensors) ...[
              _SensorCard(
                icon: s.$1,
                name: s.$2,
                subtitle: s.$3,
                connected: s.$4,
                battery: s.$5,
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.green700,
                  side: const BorderSide(color: AppColors.green100, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Add a sensor',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SensorCard extends StatelessWidget {
  const _SensorCard({
    required this.icon,
    required this.name,
    required this.subtitle,
    required this.connected,
    required this.battery,
  });

  final IconData icon;
  final String name;
  final String subtitle;
  final bool connected;
  final String? battery;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.green100),
        boxShadow: [
          BoxShadow(
            color: AppColors.stone400.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: connected
                  ? AppColors.green100
                  : AppColors.stone100,
            ),
            child: Icon(
              icon,
              size: 22,
              color: connected ? AppColors.green700 : AppColors.stone400,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.stone600),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: connected ? AppColors.emerald600 : AppColors.stone400,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      connected ? 'Connected' : 'Offline',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: connected ? AppColors.emerald600 : AppColors.stone400,
                      ),
                    ),
                    if (battery != null) ...[
                      const SizedBox(width: 10),
                      const Icon(Icons.battery_std, size: 13, color: AppColors.stone400),
                      const SizedBox(width: 2),
                      Text(
                        battery!,
                        style: const TextStyle(fontSize: 11.5, color: AppColors.stone600),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: connected,
            onChanged: (_) {},
            activeColor: AppColors.green700,
          ),
        ],
      ),
    );
  }
}