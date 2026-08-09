import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_shimmer.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 24),
        ),
      ),
      body: profileAsync.when(
        data: (user) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Avatar & Name Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(
                        user.name.firstname[0].toUpperCase() + user.name.lastname[0].toUpperCase(),
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${user.name.firstname} ${user.name.lastname}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${user.username}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Contact Info Card
              _ProfileSection(
                title: 'Contact Information',
                children: [
                  _ProfileTile(icon: Icons.email_outlined, title: 'Email', subtitle: user.email),
                  const Divider(height: 1, color: AppColors.borderSubtle),
                  _ProfileTile(icon: Icons.phone_outlined, title: 'Phone', subtitle: user.phone),
                ],
              ),
              const SizedBox(height: 24),
              
              // Address Card
              _ProfileSection(
                title: 'Shipping Address',
                children: [
                  _ProfileTile(
                    icon: Icons.location_on_outlined, 
                    title: 'Home', 
                    subtitle: '${user.address.street}\n${user.address.city}, ${user.address.zipcode}',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Actions
              _ProfileSection(
                title: 'Account',
                children: [
                  const _ProfileTile(icon: Icons.shopping_bag_outlined, title: 'Order History', isAction: true),
                  const Divider(height: 1, color: AppColors.borderSubtle),
                  const _ProfileTile(icon: Icons.settings_outlined, title: 'Settings', isAction: true),
                  const Divider(height: 1, color: AppColors.borderSubtle),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.error),
                    title: Text(
                      'Log Out',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      ref.read(authProvider.notifier).logout();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        loading: () => const _ProfileShimmer(),
        error: (err, stack) => Center(child: Text('Error loading profile: $err')),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isAction;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.isAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: subtitle != null ? Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)) : null,
      trailing: isAction ? const Icon(Icons.chevron_right, color: AppColors.borderSubtle) : null,
      onTap: isAction ? () {} : null,
    );
  }
}

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const AppShimmer(width: 96, height: 96, borderRadius: 48),
          const SizedBox(height: 16),
          const AppShimmer(width: 150, height: 24),
          const SizedBox(height: 4),
          const AppShimmer(width: 100, height: 16),
          const SizedBox(height: 32),
          AppShimmer(width: double.infinity, height: 140, borderRadius: 12),
          const SizedBox(height: 24),
          AppShimmer(width: double.infinity, height: 80, borderRadius: 12),
          const SizedBox(height: 24),
          AppShimmer(width: double.infinity, height: 200, borderRadius: 12),
        ],
      ),
    );
  }
}
