import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/rafiq_emergency_bar.dart';
import '../../../../core/widgets/rafiq_sky_header.dart';
import '../../data/models/emergency_contact_model.dart';
import '../../../reminders/data/models/reminder_model.dart';
import '../../../reminders/providers/reminders_provider.dart';
import '../../providers/caregiver_requests_provider.dart';
import '../../providers/family_provider.dart';
import 'emergency_screen.dart';

/// My Family (`عائلتي` `#47:474`) & Add Contact (`إضافة جهة اتصال` `#47:611`),
/// plus Caregiver Link Approval (`docs/AGENTS.md` item 0).
class FamilyCircleScreen extends StatelessWidget {
  const FamilyCircleScreen({super.key});

  String _toArabicDigits(int value) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var out = value.toString();
    for (var i = 0; i < western.length; i++) {
      out = out.replaceAll(western[i], eastern[i]);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final contacts = context.watch<FamilyCubit>().state;
    final requests = context.watch<CaregiverRequestsCubit>().state;
    final requestsNotifier = context.read<CaregiverRequestsCubit>();
    final reminders = context.watch<RemindersCubit>().state;
    final remindersCubit = context.read<RemindersCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.background : AppColors.background;
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: 'عائلتي',
            subtitle: 'ترتيب الاتصال عند الطوارئ وجهات الاتصال الموثوقة',
            onBack: () => Navigator.of(context).maybePop(),
            backLabel: 'رجوع',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Priority Family Contacts (`الأولوية ١: ليلى` -> `٢: عمر` -> `٣: هدى` `#47:474`)
                  for (var i = 0; i < contacts.length; i++)
                    _FamilyPriorityCard(
                      contact: contacts[i],
                      priorityLabelAr:
                          'الأولوية ${_toArabicDigits(contacts[i].priorityOrder)}',
                      isDark: isDark,
                      onCall: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '📞 جارٍ الاتصال بـ ${contacts[i].name} (${contacts[i].phone})…',
                            ),
                          ),
                        );
                      },
                      onEdit: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AddContactScreen(
                              existingContact: contacts[i],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 8),

                  // Add Contact Button (`إضافة جهة اتصال` -> opens `#47:611`)
                  SizedBox(
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddContactScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: const Icon(Icons.person_add_alt_1_rounded, size: 22),
                      label: const Text(
                        'إضافة جهة اتصال',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Live Family Shared Medication Status (`ما يراه أفراد عائلتك الآن — ليلى، عمر، هدى`)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.sync_rounded,
                              color: AppColors.success,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'مشاركة الأدوية مع العائلة (مباشر)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'عند تسجيل أي جرعة بالصوت أو اللمس، يظهر تحديث فوري لدى ليلى (الابنة) وبقية العائلة:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        for (final rem in reminders.where(
                          (r) => r.type == 'medication',
                        )) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: rem.status == 'completed'
                                  ? (isDark
                                      ? AppColorsDark.successLight
                                      : AppColors.successLight)
                                  : (isDark
                                      ? AppColorsDark.surfaceVariant
                                      : const Color(0xFFF8FAFF)),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: rem.status == 'completed'
                                    ? AppColors.success
                                    : borderColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  rem.status == 'completed'
                                      ? Icons.check_circle_rounded
                                      : Icons.schedule_rounded,
                                  color: rem.status == 'completed'
                                      ? AppColors.success
                                      : primaryColor,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    rem.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  rem.status == 'completed'
                                      ? '✓ وصل لليلى (تم التناول)'
                                      : 'بانتظار الجرعة (${rem.repeatPattern})',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: rem.status == 'completed'
                                        ? AppColors.success
                                        : textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        OutlinedButton.icon(
                          onPressed: () {
                            remindersCubit.addReminder(
                              ReminderModel(
                                reminderId:
                                    'rem_family_${DateTime.now().millisecondsSinceEpoch}',
                                userId: 'user_01',
                                type: 'medication',
                                title: 'فيتامين د (أضافته ليلى – الابنة)',
                                scheduledTime: DateTime.now().add(
                                  const Duration(hours: 2),
                                ),
                                repeatPattern: '٦:٠٠ م • يوميًا',
                                status: 'pending',
                                dosage: '١ كبسولة',
                                instructions: 'أُضيف عن بُعد من تطبيق العائلة',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  '📲 أضافت ليلى (الابنة) «فيتامين د» — ظهر الآن في الرئيسية وأدويتي تلقائيًا!',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.bolt_rounded, size: 20),
                          label: const Text(
                            'محاكاة: ليلى (الابنة) تضيف دواءً من هاتفها',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Caregiver Access Approval Requests (`docs/AGENTS.md` item 0)
                  Text(
                    'طلبات ربط العائلة ومقدمي الرعاية',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final req in requests)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: primaryColor.withValues(
                                  alpha: 0.15,
                                ),
                                child: Icon(
                                  Icons.family_restroom_rounded,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      req.caregiverName,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '${req.role} • ${req.phone}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (req.status != 'pending')
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: req.status == 'approved'
                                        ? AppColors.successLight
                                        : AppColors.emergencyContainer,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    req.status == 'approved'
                                        ? 'تم القبول ✓'
                                        : 'مرفوض',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: req.status == 'approved'
                                          ? AppColors.success
                                          : AppColors.emergencyRed,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (req.status == 'pending') ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: () => requestsNotifier
                                          .approveRequest(req.requestId),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.success,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: const Text(
                                        'قبول الربط ✓',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 48,
                                    child: OutlinedButton(
                                      onPressed: () => requestsNotifier
                                          .declineRequest(req.requestId),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.emergencyRed,
                                        side: const BorderSide(
                                          color: AppColors.emergencyRed,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: const Text(
                                        'رفض',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                  const SizedBox(height: 14),
                  RafiqEmergencyButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EmergencyScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilyPriorityCard extends StatelessWidget {
  const _FamilyPriorityCard({
    required this.contact,
    required this.priorityLabelAr,
    required this.isDark,
    required this.onCall,
    required this.onEdit,
  });

  final EmergencyContactModel contact;
  final String priorityLabelAr;
  final bool isDark;
  final VoidCallback onCall;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  priorityLabelAr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onEdit,
                icon: Icon(Icons.edit_outlined, size: 18, color: primaryColor),
                label: Text(
                  'تعديل',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: primaryColor,
                child: Text(
                  contact.name.isNotEmpty ? contact.name.characters.first : 'ع',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${contact.name} · ${contact.relation}',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      contact.phone,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Semantics(
                button: true,
                label: 'اتصال بـ ${contact.name}',
                child: ElevatedButton.icon(
                  onPressed: onCall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(94, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.phone_rounded, size: 18),
                  label: const Text(
                    'اتصال',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Add / Edit Contact Screen (`إضافة جهة اتصال` `#47:611`).
class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key, this.existingContact});

  final EmergencyContactModel? existingContact;

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late String _selectedRelation;
  late bool _isEmergencyContact;

  static const List<String> _relations = [
    'الابنة',
    'الابن',
    'الزوجة / الزوج',
    'الأخت / الأخ',
    'الجارة / الجار',
    'مقدم رعاية',
  ];

  @override
  void initState() {
    super.initState();
    final existing = widget.existingContact;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _phoneController = TextEditingController(
      text: existing?.phone ?? '+20 10 ',
    );
    _selectedRelation = existing != null &&
            _relations.contains(existing.relation)
        ? existing.relation
        : _relations.first;
    _isEmergencyContact = existing?.isEmergencyContact ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال اسم جهة الاتصال')),
      );
      return;
    }

    final notifier = context.read<FamilyCubit>();
    if (widget.existingContact != null) {
      notifier.updateContact(
        widget.existingContact!.copyWith(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          relation: _selectedRelation,
          isEmergencyContact: _isEmergencyContact,
        ),
      );
    } else {
      notifier.addContact(
        name: _nameController.text.trim(),
        relation: _selectedRelation,
        phone: _phoneController.text.trim(),
        isEmergencyContact: _isEmergencyContact,
      );
    }
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColorsDark.background : AppColors.background;
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColors.rafiqPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          RafiqSkyHeader(
            title: widget.existingContact != null
                ? 'تعديل جهة الاتصال'
                : 'إضافة جهة اتصال',
            subtitle: 'أضف فردًا من العائلة للاتصال السريع والطوارئ',
            onBack: () => Navigator.of(context).maybePop(),
            backLabel: 'رجوع',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الاسم',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'مثال: سارة أحمد',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'رقم الهاتف',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: '+20 10 1234 5678',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'صلة القرابة',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedRelation,
                      items: _relations
                          .map(
                            (r) => DropdownMenuItem(
                              value: r,
                              child: Text(r),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedRelation = val);
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _isEmergencyContact,
                      activeThumbColor: Colors.white,
                      activeTrackColor: primaryColor,
                      onChanged: (val) {
                        setState(() => _isEmergencyContact = val);
                      },
                      title: Text(
                        'الاتصال في حالات الطوارئ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                      subtitle: const Text(
                        'يُدرج ضمن قائمة الاتصال المتسلسل عند طلب المساعدة',
                      ),
                    ),
                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'حفظ جهة الاتصال ✓',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
