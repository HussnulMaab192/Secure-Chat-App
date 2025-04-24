import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider with ChangeNotifier {
  final SignUp _signUp;
  final SignIn _signIn;

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String _errorMessage = '';

  AuthProvider({
    required SignUp signUp,
    required SignIn signIn,
  })  : _signUp = signUp,
        _signIn = signIn;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Sign up
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    notifyListeners();

    final params = SignUpParams(
      username: username,
      email: email,
      password: password,
    );

    final result = await _signUp(params);

    result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (user) {
        _status = AuthStatus.authenticated;
        _user = user;
        _errorMessage = '';
        notifyListeners();
      },
    );
  }

  // Sign in
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    notifyListeners();

    final params = SignInParams(
      email: email,
      password: password,
    );

    final result = await _signIn(params);

    result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (token) {
        _status = AuthStatus.authenticated;
        _errorMessage = '';
        notifyListeners();
      },
    );
  }

  // Set user
  void setUser(User user) {
    _user = user;
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  // Sign out
  Future<void> signOut() async{
    _status = AuthStatus.unauthenticated;
    _user = null;
    notifyListeners();
  }

  // Set error
  void setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  // Reset error
  void resetError() {
    _errorMessage = '';
    notifyListeners();
  }
}
