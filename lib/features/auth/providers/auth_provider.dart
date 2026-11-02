import 'package:flutter_bloc/flutter_bloc.dart';

class AuthState {
  final bool isAuthenticated;
  final String? userName;
  final String? userEmail;
  final String userPhone;
  final String homeAddress;
  final bool isLoading;
  final String? error;
  final bool codeSent;

  const AuthState({
    this.isAuthenticated = false,
    this.userName = 'عادل أحمد',
    this.userEmail = 'adel.ahmed@rafiq.app',
    this.userPhone = '+20 10 1234 5678',
    this.homeAddress = '١٤ شارع الجلاء، مصر الجديدة، القاهرة',
    this.isLoading = false,
    this.error,
    this.codeSent = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? homeAddress,
    bool? isLoading,
    String? error,
    bool? codeSent,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      homeAddress: homeAddress ?? this.homeAddress,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      codeSent: codeSent ?? this.codeSent,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  Future<bool> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, error: null));
    await Future.delayed(const Duration(milliseconds: 300));

    if (email.trim().isEmpty || password.trim().isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'يرجى إدخال البريد الإلكتروني وكلمة المرور',
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userEmail: email.trim(),
        userName: state.userName ?? 'عادل أحمد',
      ),
    );
    return true;
  }

  Future<bool> loginWithGoogle() async {
    emit(state.copyWith(isLoading: true, error: null));
    await Future.delayed(const Duration(milliseconds: 300));
    emit(
      state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userEmail: 'adel.ahmed@gmail.com',
        userName: 'عادل أحمد',
      ),
    );
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    await Future.delayed(const Duration(milliseconds: 300));

    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'يرجى إكمال جميع الحقول المطلوبة',
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        isLoading: false,
        userName: name.trim(),
        userEmail: email.trim(),
        userPhone: phone.trim().isEmpty ? state.userPhone : phone.trim(),
        codeSent: true,
      ),
    );
    return true;
  }

  Future<bool> sendPasswordReset(String email) async {
    emit(state.copyWith(isLoading: true, error: null));
    await Future.delayed(const Duration(milliseconds: 300));
    if (email.trim().isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'يرجى إدخال البريد الإلكتروني لاستعادة كلمة المرور',
        ),
      );
      return false;
    }
    emit(state.copyWith(isLoading: false, userEmail: email.trim()));
    return true;
  }

  Future<bool> verifyCode(String code) async {
    emit(state.copyWith(isLoading: true, error: null));
    await Future.delayed(const Duration(milliseconds: 300));

    final trimmed = code.trim();
    if (trimmed.length < 4) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'يرجى إدخال رمز التحقق الصحيح (مثال: 123456)',
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        codeSent: false,
      ),
    );
    return true;
  }

  void updateProfile({
    required String name,
    required String phone,
    String? email,
    String? homeAddress,
  }) {
    emit(
      state.copyWith(
        userName: name.trim().isEmpty ? state.userName : name.trim(),
        userPhone: phone.trim().isEmpty ? state.userPhone : phone.trim(),
        userEmail: email?.trim().isNotEmpty == true
            ? email!.trim()
            : state.userEmail,
        homeAddress: homeAddress?.trim().isNotEmpty == true
            ? homeAddress!.trim()
            : state.homeAddress,
      ),
    );
  }

  void logout() {
    emit(const AuthState(isAuthenticated: false));
  }
}

typedef AuthNotifier = AuthCubit;
