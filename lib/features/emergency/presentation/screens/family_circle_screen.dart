import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/demo_snackbar.dart';
import '../../data/models/emergency_contact_model.dart';
import '../../providers/family_provider.dart';

class FamilyCircleScreen extends ConsumerStatefulWidget {
  const FamilyCircleScreen({super.key});

  @override
  ConsumerState<FamilyCircleScreen> createState() => _FamilyCircleScreenState();
}

class _FamilyCircleScreenState extends ConsumerState<FamilyCircleScreen>
    with SingleTickerProviderStateMixin {
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back',
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              const Expanded(
                child: Text(
                  'Family Circle',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.primary),
                tooltip: 'Add family member',
                onPressed: () {
                  showDemoSnackBar(context, 'Add contact will use the API later');
                },
              ),
            ],
          ),
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: contacts.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: AppColors.divider),
                  itemBuilder: (context, index) {
                    return _ContactTile(contact: contacts[index]);
                  },
                ),
                const Center(
                  child: Text(
                    'No recent calls',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact});

  final EmergencyContactModel contact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              contact.name.isNotEmpty ? contact.name[0] : '?',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${contact.relation} – ${contact.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.phone,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Call ${contact.name}',
            icon: const Icon(Icons.call_outlined, color: AppColors.primary),
            onPressed: () {
              showDemoSnackBar(context, 'Calling ${contact.name} (demo)');
            },
          ),
          IconButton(
            tooltip: 'Message ${contact.name}',
            icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
            onPressed: () {
              showDemoSnackBar(context, 'Message ${contact.name} (demo)');
            },
          ),
        ],
      ),
    );
  }
}
