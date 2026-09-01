import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

enum _ThemeOption { light, dark, system }

class _AppearanceScreenState extends State<AppearanceScreen> {
  _ThemeOption selectedTheme = _ThemeOption.light;
  int selectedAccent = 0;
  bool largeText = false;

  final accents = const [
    AppColors.green700,
    AppColors.emerald600,
    AppColors.lime500,
    AppColors.rose500,
  ];

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
          'Appearance',
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
            const _SectionLabel(label: 'Theme'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _ThemeCard(
                    label: 'Light',
                    icon: Icons.light_mode_outlined,
                    selected: selectedTheme == _ThemeOption.light,
                    onTap: () => setState(() => selectedTheme = _ThemeOption.light),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ThemeCard(
                    label: 'Dark',
                    icon: Icons.dark_mode_outlined,
                    selected: selectedTheme == _ThemeOption.dark,
                    onTap: () => setState(() => selectedTheme = _ThemeOption.dark),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ThemeCard(
                    label: 'System',
                    icon: Icons.smartphone_outlined,
                    selected: selectedTheme == _ThemeOption.system,
                    onTap: () => setState(() => selectedTheme = _ThemeOption.system),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const _SectionLabel(label: 'Accent color'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
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
                  for (int i = 0; i < accents.length; i++) ...[
                    if (i != 0) const SizedBox(width: 14),
                    GestureDetector(
                      onTap: () => setState(() => selectedAccent = i),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accents[i],
                          border: selectedAccent == i
                              ? Border.all(color: AppColors.stone600, width: 2.5)
                              : null,
                        ),
                        child: selectedAccent == i
                            ? const Icon(Icons.check, size: 18, color: Colors.white)
                            : null,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 22),
            const _SectionLabel(label: 'Text'),
            const SizedBox(height: 10),
            Container(
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
              child: Padding(
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
                      child: const Icon(Icons.format_size, size: 18, color: AppColors.green700),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        'Large text',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.green900,
                        ),
                      ),
                    ),
                    Switch.adaptive(
                      value: largeText,
                      onChanged: (v) => setState(() => largeText = v),
                      activeColor: AppColors.green700,
                    ),
                  ],
                ),
              ),
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

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: selected ? AppColors.green700 : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.green700 : AppColors.green100,
            width: 1.5,
          ),
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
            Icon(icon, size: 22, color: selected ? Colors.white : AppColors.green700),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.green900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}