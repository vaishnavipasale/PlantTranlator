import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool wateringReminders = true;
  bool healthAlerts = true;
  bool weeklyDigest = false;
  bool sensorAlerts = true;
  bool communityActivity = false;
  bool tipsAndTricks = true;
  bool pushEnabled = true;
  bool emailEnabled = false;

  @override
  Widget build(BuildContext context) {
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
          'Notifications',
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
            const _SectionLabel(label: 'Delivery'),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _ToggleTile(
                  icon: Icons.notifications_active_outlined,
                  label: 'Push notifications',
                  value: pushEnabled,
                  onChanged: (v) => setState(() => pushEnabled = v),
                ),
                _ToggleTile(
                  icon: Icons.email_outlined,
                  label: 'Email notifications',
                  value: emailEnabled,
                  onChanged: (v) => setState(() => emailEnabled = v),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const _SectionLabel(label: 'Plant care'),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _ToggleTile(
                  icon: Icons.water_drop_outlined,
                  label: 'Watering reminders',
                  value: wateringReminders,
                  onChanged: (v) => setState(() => wateringReminders = v),
                ),
                _ToggleTile(
                  icon: Icons.favorite_border,
                  label: 'Health alerts',
                  value: healthAlerts,
                  onChanged: (v) => setState(() => healthAlerts = v),
                ),
                _ToggleTile(
                  icon: Icons.sensors_outlined,
                  label: 'Sensor alerts',
                  value: sensorAlerts,
                  onChanged: (v) => setState(() => sensorAlerts = v),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const _SectionLabel(label: 'Updates'),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _ToggleTile(
                  icon: Icons.summarize_outlined,
                  label: 'Weekly digest',
                  value: weeklyDigest,
                  onChanged: (v) => setState(() => weeklyDigest = v),
                ),
                _ToggleTile(
                  icon: Icons.groups_outlined,
                  label: 'Community activity',
                  value: communityActivity,
                  onChanged: (v) => setState(() => communityActivity = v),
                ),
                _ToggleTile(
                  icon: Icons.lightbulb_outline,
                  label: 'Tips & tricks',
                  value: tipsAndTricks,
                  onChanged: (v) => setState(() => tipsAndTricks = v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: AppColors.stone600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              const Divider(height: 1, indent: 60, color: AppColors.stone100),
          ],
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.green100,
            ),
            child: Icon(icon, size: 18, color: AppColors.green700),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: AppColors.green900,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.green700,
          ),
        ],
      ),
    );
  }
}