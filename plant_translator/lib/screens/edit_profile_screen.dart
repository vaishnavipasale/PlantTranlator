import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'Alex Rivera');
  final _bioController = TextEditingController(text: 'Plant parent since March');
  final _emailController = TextEditingController(text: 'alex.rivera@email.com');
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated'),
        backgroundColor: AppColors.green700,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).pop();
  }

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
          'Edit profile',
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
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.green700, AppColors.emerald600],
                      ),
                      border: Border.all(color: AppColors.lime400, width: 2.5),
                    ),
                    child: const Icon(Icons.eco, size: 46, color: AppColors.lime400),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {},
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.lime500,
                          border: Border.all(color: AppColors.stone50, width: 3),
                        ),
                        child: const Icon(Icons.camera_alt, size: 15, color: AppColors.green900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _FieldCard(
              label: 'Name',
              child: TextField(
                controller: _nameController,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.green900,
                ),
                decoration: const InputDecoration.collapsed(hintText: 'Your name'),
              ),
            ),
            const SizedBox(height: 12),
            _FieldCard(
              label: 'Bio',
              child: TextField(
                controller: _bioController,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.green900,
                ),
                decoration: const InputDecoration.collapsed(hintText: 'A short bio'),
              ),
            ),
            const SizedBox(height: 12),
            _FieldCard(
              label: 'Email',
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.green900,
                ),
                decoration: const InputDecoration.collapsed(hintText: 'you@email.com'),
              ),
            ),
            const SizedBox(height: 12),
            _FieldCard(
              label: 'Phone (optional)',
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.green900,
                ),
                decoration: const InputDecoration.collapsed(hintText: 'Add a phone number'),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green700,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Save changes',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.stone600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}