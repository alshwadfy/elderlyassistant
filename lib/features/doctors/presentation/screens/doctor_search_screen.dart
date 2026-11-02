import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/rafiq_emergency_bar.dart';
import '../../../../core/widgets/rafiq_sky_header.dart';
import '../../../emergency/presentation/screens/emergency_screen.dart';
import '../../../way_home/presentation/screens/way_home_screen.dart';
import '../../data/models/doctor_model.dart';
import '../../providers/doctors_provider.dart';
import 'appointments_screen.dart';

/// Nearby Hospitals (`المستشفيات القريبة`) matching Figma `#2:337` & `#2:401`
/// and Sequence Diagram 2 (`GET /api/hospitals/nearby`).
class DoctorSearchScreen extends StatefulWidget {
  const DoctorSearchScreen({super.key, this.onBackToHome});

  final VoidCallback? onBackToHome;

  @override
  State<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = 'الكل';

  static const List<String> _specialties = [
    'الكل',
    'عام',
    'القلب',
    'العيون',
    'العظام',
    'الأسنان',
    'الجلدية',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    context.read<DoctorsCubit>().filterBySpecialtyOrQuery(
          specialty: _selectedSpecialty,
          query: _searchController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final hospitals = context.watch<DoctorsCubit>().state;
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
            title: 'المستشفيات القريبة',
            subtitle: 'ابحث بالتخصص أو اختر من القائمة',
            onBack: widget.onBackToHome ??
                (Navigator.of(context).canPop()
                    ? () => Navigator.of(context).maybePop()
                    : null),
            backLabel: 'الرئيسية',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search Input (`ابحث عن مستشفى أو تخصص…` `#2:409`)
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => _applyFilter(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن مستشفى أو تخصص…',
                      prefixIcon: Icon(Icons.search_rounded, color: primaryColor),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                _applyFilter();
                              },
                              icon: const Icon(Icons.clear_rounded),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Specialty Filter Chips (`الكل`, `عام`, `القلب`, `العيون`, `العظام`, `الأسنان`, `الجلدية` `#2:413`)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final spec in _specialties)
                          Padding(
                            padding: const EdgeInsetsDirectional.only(end: 8),
                            child: Semantics(
                              button: true,
                              selected: _selectedSpecialty == spec,
                              label: 'تخصص $spec',
                              child: ChoiceChip(
                                label: Text(
                                  spec,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: _selectedSpecialty == spec
                                        ? Colors.white
                                        : textPrimary,
                                  ),
                                ),
                                selected: _selectedSpecialty == spec,
                                selectedColor: primaryColor,
                                backgroundColor: surfaceColor,
                                side: BorderSide(
                                  color: _selectedSpecialty == spec
                                      ? primaryColor
                                      : borderColor,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                onSelected: (_) {
                                  setState(() => _selectedSpecialty = spec);
                                  _applyFilter();
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Quick Link to Next Visit (`زيارتي القادمة` `#10:2945`)
                  Semantics(
                    button: true,
                    label: 'عرض زيارتي القادمة في مستشفى الأمل',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AppointmentsScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColorsDark.primaryContainer
                                : AppColors.rafiqPrimaryTint,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.45),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.event_available_rounded,
                                color: primaryColor,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'زيارتي القادمة · مستشفى الأمل',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '٢٩ أكتوبر ٢٠٢٦ · ١٠:٠٠ ص · المرافق: فاطمة أحمد',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Hospital Cards (`مستشفى الأمل`, `مستشفى الرعاية`, `مستشفى النور` `#2:345` / `#2:436`)
                  if (hospitals.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                      ),
                      child: Text(
                        'لا توجد مستشفيات مطابقة لهذا التخصص حاليًا.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: textSecondary,
                        ),
                      ),
                    )
                  else
                    for (final hospital in hospitals)
                      _HospitalCard(
                        hospital: hospital,
                        isDark: isDark,
                        onOpenVisitPlan: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AppointmentsScreen(),
                            ),
                          );
                        },
                        onOpenDirections: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const WayHomeScreen(),
                            ),
                          );
                        },
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

class _HospitalCard extends StatelessWidget {
  const _HospitalCard({
    required this.hospital,
    required this.isDark,
    required this.onOpenVisitPlan,
    required this.onOpenDirections,
  });

  final DoctorModel hospital;
  final bool isDark;
  final VoidCallback onOpenVisitPlan;
  final VoidCallback onOpenDirections;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColorsDark.surface : AppColors.surface;
    final borderColor = isDark ? AppColorsDark.cardBorder : AppColors.cardBorder;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final primaryColor = isDark
        ? AppColorsDark.rafiqAccentBlue
        : AppColors.rafiqPrimary;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor, width: 1.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.local_hospital_rounded,
                  color: primaryColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hospital.distanceLabelAr.isNotEmpty
                          ? hospital.distanceLabelAr
                          : '${hospital.distanceKm} كم • ${hospital.estimatedMinutes} دقائق',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final spec in hospital.specialties)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColorsDark.surfaceVariant
                        : const Color(0xFFF3F6FF),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    spec,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '📞 جارٍ الاتصال بـ ${hospital.name} (${hospital.phone})…',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColorsDark.primary
                          : AppColors.rafiqPrimary,
                      foregroundColor: Colors.white,
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
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: onOpenVisitPlan,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textPrimary,
                      side: BorderSide(color: borderColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: primaryColor,
                    ),
                    label: const Text(
                      'تفاصيل الزيارة',
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
      ),
    );
  }
}
