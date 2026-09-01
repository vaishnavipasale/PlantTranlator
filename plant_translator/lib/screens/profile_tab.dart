import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'edit_profile_screen.dart';
import 'notifications_screen.dart';
import 'connected_sensors_screen.dart';
import 'appearance_screen.dart';
import 'help_support_screen.dart';
import 'about_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stone50,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
          children: [
            const _ProfileHeader(),
            const SizedBox(height: 20),
            const _StatsRow(),
            const SizedBox(height: 26),
            const _SectionLabel(label: 'Account'),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.person_outline,
                  label: 'Edit profile',
                  onTap: () => _push(context, const EditProfileScreen()),
                ),
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onTap: () => _push(context, const NotificationsScreen()),
                ),
                _SettingsTile(
                  icon: Icons.sensors_outlined,
                  label: 'Connected sensors',
                  onTap: () => _push(context, const ConnectedSensorsScreen()),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const _SectionLabel(label: 'App'),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.palette_outlined,
                  label: 'Appearance',
                  onTap: () => _push(context, const AppearanceScreen()),
                ),
                _SettingsTile(
                  icon: Icons.help_outline,
                  label: 'Help & support',
                  onTap: () => _push(context, const HelpSupportScreen()),
                ),
                _SettingsTile(
                  icon: Icons.info_outline,
                  label: 'About',
                  onTap: () => _push(context, const AboutScreen()),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.logout,
                  label: 'Log out',
                  labelColor: AppColors.rose600,
                  iconColor: AppColors.rose600,
                  iconBg: AppColors.rose500,
                  iconBgOpacity: 0.12,
                  showChevron: false,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.green700, AppColors.emerald600],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.green900.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                  border: Border.all(color: AppColors.lime400, width: 2.5),
                ),
                child: const Icon(Icons.eco, size: 44, color: AppColors.lime400),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lime500,
                    border: Border.all(color: AppColors.green700, width: 3),
                  ),
                  child: const Icon(Icons.edit, size: 14, color: AppColors.green900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Alex Rivera',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Plant parent since March',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    final stats = [
      (Icons.eco_outlined, '7', 'Plants', AppColors.green600),
      (Icons.favorite_border, '82%', 'Health', AppColors.emerald600),
      (Icons.local_fire_department_outlined, '14', 'Streak', AppColors.lime500),
    ];
    return Row(
      children: [
        for (int i = 0; i < stats.length; i++) ...[
          if (i != 0) const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.green100),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.stone400.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(stats[i].$1, color: stats[i].$4, size: 22),
                  const SizedBox(height: 8),
                  Text(
                    stats[i].$2,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.green900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stats[i].$3,
                    style: const TextStyle(fontSize: 11, color: AppColors.stone600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
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

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.labelColor,
    this.iconColor,
    this.iconBg,
    this.iconBgOpacity = 1,
    this.showChevron = true,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color? labelColor;
  final Color? iconColor;
  final Color? iconBg;
  final double iconBgOpacity;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (iconBg ?? AppColors.green100).withOpacity(iconBgOpacity),
              ),
              child: Icon(icon, size: 18, color: iconColor ?? AppColors.green700),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: labelColor ?? AppColors.green900,
                ),
              ),
            ),
            if (showChevron)
              const Icon(Icons.chevron_right, size: 18, color: AppColors.stone400),
          ],
        ),
      ),
    );
  }
}