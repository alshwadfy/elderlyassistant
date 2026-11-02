import 'package:flutter_bloc/flutter_bloc.dart';

class WayHomeStep {
  const WayHomeStep({
    required this.instructionAr,
    required this.subInstructionAr,
    required this.distanceMeters,
    required this.minutesRemaining,
    required this.progress,
  });

  final String instructionAr;
  final String subInstructionAr;
  final int distanceMeters;
  final int minutesRemaining;
  final double progress;
}

class WayHomeState {
  const WayHomeState({
    this.currentStepIndex = 0,
    this.isVoiceGuidanceActive = false,
    this.zoomLevel = 1.0,
  });

  final int currentStepIndex;
  final bool isVoiceGuidanceActive;
  final double zoomLevel;

  static const List<WayHomeStep> routeSteps = [
    WayHomeStep(
      instructionAr: 'امشِ للأمام ١٠٠ متر',
      subInstructionAr: 'ثم انعطف يمينًا · خطوة بخطوة',
      distanceMeters: 600,
      minutesRemaining: 8,
      progress: 0.0,
    ),
    WayHomeStep(
      instructionAr: 'انعطف يمينًا نحو حديقة الحي',
      subInstructionAr: 'استمر في المشي ٢٠٠ متر بمحاذاة الحديقة',
      distanceMeters: 420,
      minutesRemaining: 5,
      progress: 0.35,
    ),
    WayHomeStep(
      instructionAr: 'استمر للأمام نحو شارع الجلاء',
      subInstructionAr: 'المنزل قريب جدًا بعد المبنى القادم',
      distanceMeters: 180,
      minutesRemaining: 2,
      progress: 0.72,
    ),
    WayHomeStep(
      instructionAr: 'وصلت إلى المنزل بسلام ✓',
      subInstructionAr: '١٤ شارع الجلاء، مصر الجديدة · الحمد لله على السلامة',
      distanceMeters: 0,
      minutesRemaining: 0,
      progress: 1.0,
    ),
  ];

  WayHomeStep get currentStep => routeSteps[currentStepIndex];
  bool get hasArrived => currentStepIndex >= routeSteps.length - 1;

  String get distanceSummaryAr {
    if (hasArrived) return 'وصلت الآن · ٠ متر';
    return '٨ دقائق · ٦٠٠ متر'
        .replaceFirst('٨', _toArabicDigits(currentStep.minutesRemaining))
        .replaceFirst('٦٠٠', _toArabicDigits(currentStep.distanceMeters));
  }

  static String _toArabicDigits(int number) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var str = number.toString();
    for (var i = 0; i < western.length; i++) {
      str = str.replaceAll(western[i], eastern[i]);
    }
    return str;
  }

  WayHomeState copyWith({
    int? currentStepIndex,
    bool? isVoiceGuidanceActive,
    double? zoomLevel,
  }) {
    return WayHomeState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      isVoiceGuidanceActive:
          isVoiceGuidanceActive ?? this.isVoiceGuidanceActive,
      zoomLevel: zoomLevel ?? this.zoomLevel,
    );
  }
}

class WayHomeCubit extends Cubit<WayHomeState> {
  WayHomeCubit() : super(const WayHomeState());

  void toggleVoiceGuidance() {
    emit(state.copyWith(isVoiceGuidanceActive: !state.isVoiceGuidanceActive));
  }

  void advanceStep() {
    if (state.currentStepIndex < WayHomeState.routeSteps.length - 1) {
      emit(state.copyWith(currentStepIndex: state.currentStepIndex + 1));
    } else {
      emit(state.copyWith(currentStepIndex: 0));
    }
  }

  void resetRoute() {
    emit(
      const WayHomeState(
        currentStepIndex: 0,
        isVoiceGuidanceActive: false,
        zoomLevel: 1.0,
      ),
    );
  }
}

typedef WayHomeNotifier = WayHomeCubit;
