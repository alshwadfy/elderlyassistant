import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  final String? userName;
  final String? userEmail;
  final bool isLoading;
  final String? error;
  final bool codeSent;

  const AuthState({
    this.isAuthenticated = false,
    this.userName,
    this.userEmail,
    this.isLoading = false,
    this.error,
    this.codeSent = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userName,
    String? userEmail,
    bool? isLoading,
    String? error,
    bool? codeSent,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      codeSent: codeSent ?? this.codeSent,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 400));

    if (email.trim().isEmpty || password.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Please enter email and password',
      );
      return false;
    }

    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      userEmail: email,
      userName: 'Adel',
    );
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 400));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Please complete all required fields',
      );
      return false;
    }

    state = state.copyWith(
      isLoading: false,
      userName: name,
      userEmail: email,
      codeSent: true,
    );
    return true;
  }

  Future<bool> verifyCode(String code) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 400));

    if (code.trim() != '1234' && code.trim().length != 4) {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid code. Demo code is 1234',
      );
      return false;
    }

    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      codeSent: false,
    );
    return true;
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
