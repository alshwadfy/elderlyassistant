import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/demo_snackbar.dart';
import '../../data/models/emergency_contact_model.dart';
import '../../providers/family_provider.dart';

import '../../data/models/caregiver_request_model.dart';
import '../../providers/caregiver_requests_provider.dart';

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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(familyProvider);
    final caregiverRequests = ref.watch(caregiverRequestsProvider);
    final pendingCount =
        caregiverRequests.where((r) => r.status == 'pending').length;

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
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            tabs: [
              const Tab(text: 'Contacts'),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Requests'),
                    if (pendingCount > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.emergency,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$pendingCount',
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Tab(text: 'Recent'),
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
                _CaregiverRequestsList(requests: caregiverRequests),
                const Center(
                  child: Text(
                    'No recent calls',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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
                    fontWeight: FontWeight.w600,
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

class _CaregiverRequestsList extends ConsumerWidget {
  const _CaregiverRequestsList({required this.requests});

  final List<CaregiverRequestModel> requests;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (requests.isEmpty) {
      return const Center(
        child: Text(
          'No pending caregiver access requests',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        return _CaregiverRequestCard(req: req);
      },
    );
  }
}

class _CaregiverRequestCard extends ConsumerWidget {
  const _CaregiverRequestCard({required this.req});

  final CaregiverRequestModel req;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPending = req.status == 'pending';
    final isApproved = req.status == 'approved';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: isApproved
                      ? AppColors.successContainer
                      : req.status == 'declined'
                          ? AppColors.emergencyContainer
                          : AppColors.primaryContainer,
                  child: Icon(
                    Icons.medical_services_outlined,
                    color: isApproved
                        ? AppColors.success
                        : req.status == 'declined'
                            ? AppColors.emergency
                            : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req.caregiverName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${req.role} • ${req.phone}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isPending)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isApproved
                          ? AppColors.successContainer
                          : AppColors.emergencyContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isApproved ? 'Approved' : 'Declined',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isApproved
                            ? AppColors.success
                            : AppColors.emergency,
                      ),
                    ),
                  ),
              ],
            ),
            if (isPending) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref
                            .read(caregiverRequestsProvider.notifier)
                            .declineRequest(req.requestId);
                        showDemoSnackBar(
                          context,
                          'Access request from ${req.caregiverName} declined',
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        foregroundColor: AppColors.emergency,
                        side: const BorderSide(color: AppColors.emergency),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(caregiverRequestsProvider.notifier)
                            .approveRequest(req.requestId);
                        showDemoSnackBar(
                          context,
                          'Access granted to ${req.caregiverName}',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        backgroundColor: AppColors.success,
                      ),
                      child: const Text('Approve'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
