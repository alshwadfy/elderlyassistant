import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../doctors/presentation/screens/appointments_screen.dart';
import '../../../doctors/presentation/screens/doctor_search_screen.dart';
import '../../../emergency/presentation/screens/emergency_screen.dart';
import '../../../emergency/presentation/screens/family_circle_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../reminders/presentation/screens/reminders_screen.dart';
import '../../../voice_assistant/presentation/screens/voice_assistant_screen.dart';
import 'home_tab_view.dart';

class AppShellRoutes {
  static const home = '/home';
  static const schedule = '/schedule';
  static const reminders = '/reminders';
  static const more = '/more';
  static const doctors = '/doctors';
  static const family = '/family';
  static const emergency = '/emergency';
  static const voice = '/voice';
}

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key});

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;
  bool _showHeader = true;

  static const _tabRoutes = [
    AppShellRoutes.home,
    AppShellRoutes.schedule,
    AppShellRoutes.reminders,
    AppShellRoutes.more,
  ];

  void _onTabTap(int index) {
    setState(() {
      _currentIndex = index;
      _showHeader = true;
    });
    _navigatorKey.currentState?.pushNamedAndRemoveUntil(
      _tabRoutes[index],
      (route) => false,
    );
  }

  void _syncChrome(String? name) {
    final hideHeader = name == AppShellRoutes.emergency;
    final tabIndex = switch (name) {
      AppShellRoutes.schedule => 1,
      AppShellRoutes.reminders => 2,
      AppShellRoutes.more => 3,
      _ => 0,
    };
    if (!mounted) return;
    if (_showHeader == !hideHeader && _currentIndex == tabIndex) return;
    setState(() {
      _showHeader = !hideHeader;
      _currentIndex = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showHeader ? AppColors.background : AppColors.emergencyBg,
      appBar: _showHeader ? const AppHeader() : null,
      body: Navigator(
        key: _navigatorKey,
        initialRoute: AppShellRoutes.home,
        onGenerateRoute: (settings) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _syncChrome(settings.name);
          });
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => _pageFor(settings.name),
          );
        },
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
      ),
    );
  }

  Widget _pageFor(String? name) {
    switch (name) {
      case AppShellRoutes.schedule:
        return const AppointmentsScreen();
      case AppShellRoutes.reminders:
        return const RemindersScreen();
      case AppShellRoutes.more:
        return const ProfileScreen();
      case AppShellRoutes.doctors:
        return const DoctorSearchScreen();
      case AppShellRoutes.family:
        return const FamilyCircleScreen();
      case AppShellRoutes.emergency:
        return const EmergencyScreen();
      case AppShellRoutes.voice:
        return const VoiceAssistantScreen();
      case AppShellRoutes.home:
      default:
        return const HomeTabView();
    }
  }
}
