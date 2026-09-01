import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          'About',
          style: TextStyle(
            color: AppColors.green900,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.green700, AppColors.emerald600],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.green900.withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.eco, size: 40, color: AppColors.lime400),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Sprout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.green900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Version 2.4.1 (build 118)',
                    style: TextStyle(fontSize: 12.5, color: AppColors.stone600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _SettingsCard(
              children: [
                _LinkTile(icon: Icons.description_outlined, label: 'Terms of service'),
                _LinkTile(icon: Icons.privacy_tip_outlined, label: 'Privacy policy'),
                _LinkTile(icon: Icons.gavel_outlined, label: 'Open-source licenses'),
              ],
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              children: [
                _LinkTile(icon: Icons.star_outline, label: 'Rate the app'),
                _LinkTile(icon: Icons.share_outlined, label: 'Share with a friend'),
              ],
            ),
            const SizedBox(height: 28),
            const Center(
              child: Text(
                'Made with 🌱 by the Sprout team',
                style: TextStyle(fontSize: 12, color: AppColors.stone400),
              ),
            ),
          ],
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

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
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
            const Icon(Icons.chevron_right, size: 18, color: AppColors.stone400),
          ],
        ),
      ),
    );
  }
}