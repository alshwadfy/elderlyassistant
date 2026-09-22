import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  final String? userName;
  final String? userPhone;
  final bool isLoading;
  final String? error;
  final bool codeSent;

  const AuthState({
    this.isAuthenticated = false,
    this.userName,
    this.userPhone,
    this.isLoading = false,
    this.error,
    this.codeSent = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userName,
    String? userPhone,
    bool? isLoading,
    String? error,
    bool? codeSent,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      codeSent: codeSent ?? this.codeSent,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<bool> login(String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 600));

    if (phone.trim().isEmpty || password.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'رجاء أدخل رقم الهاتف وكلمة المرور / Please enter phone and password',
      );
      return false;
    }

    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      userPhone: phone,
      userName: 'جدي العزيز / Dear User',
    );
    return true;
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String emergencyContact,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 600));

    if (name.isEmpty || phone.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'يرجى إكمال البيانات / Please complete all fields',
      );
      return false;
    }

    state = state.copyWith(
      isLoading: false,
      userName: name,
      userPhone: phone,
      codeSent: true,
    );
    return true;
  }

  Future<bool> verifyCode(String code) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 500));

    if (code.trim() != '1234' && code.trim().length != 4) {
      state = state.copyWith(
        isLoading: false,
        error: 'رمز التحقق غير صحيح (جرب 1234) / Invalid code (Try 1234)',
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
