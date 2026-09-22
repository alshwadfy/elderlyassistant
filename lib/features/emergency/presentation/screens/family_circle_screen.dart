import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';
import '../../providers/family_provider.dart';

class FamilyCircleScreen extends ConsumerStatefulWidget {
  const FamilyCircleScreen({super.key});

  @override
  ConsumerState<FamilyCircleScreen> createState() => _FamilyCircleScreenState();
}

class _FamilyCircleScreenState extends ConsumerState<FamilyCircleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(familyProvider);

    return Scaffold(
      appBar: const AppHeader(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Family Circle',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 32),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Contacts'),
                  Tab(text: 'Recent'),
                ],
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Contacts Tab
                    ListView.separated(
                      itemCount: contacts.length,
                      separatorBuilder: (context, index) => const Divider(color: AppColors.divider),
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return _buildContactTile(contact);
                      },
                    ),
                    // Recent Tab
                    const Center(child: Text('No recent calls', style: TextStyle(color: AppColors.textSecondary))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile(var contact) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryContainer,
            child: Icon(Icons.person, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${contact.relation} – ${contact.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.phone,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call_outlined, color: AppColors.primary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
