import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/socket/socket_providers.dart';
import '../../../../core/widgets/accessibility_floating_button.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/connection_status_banner.dart';
import '../../../doctors/presentation/screens/doctor_search_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../reminders/presentation/screens/reminders_screen.dart';
import 'home_tab_view.dart';

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SocketCubit>().connect();
      }
    });
  }

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final socketState = context.watch<SocketCubit>().state;
    final pages = <Widget>[
      HomeTabView(onSwitchTab: _switchTab),
      DoctorSearchScreen(onBackToHome: () => _switchTab(0)),
      RemindersScreen(onBackToHome: () => _switchTab(0)),
      ProfileScreen(onBackToHome: () => _switchTab(0)),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              ConnectionStatusBanner(
                state: socketState,
                onRetry: () => context.read<SocketCubit>().retryConnect(),
              ),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: pages,
                ),
              ),
            ],
          ),
          const AccessibilityFloatingButton(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _switchTab,
      ),
    );
  }
}
