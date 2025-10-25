import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterquiz/features/auth/auth_repository.dart';
import 'package:flutterquiz/features/auth/cubits/auth_cubit.dart';

sealed class SignInState {
  const SignInState();
}

final class SignInInitial extends SignInState {
  const SignInInitial();
}

final class SignInProgress extends SignInState {
  const SignInProgress(this.authProvider);

  final AuthProviders authProvider;
}

final class SignInSuccess extends SignInState {
  const SignInSuccess({
    required this.authProvider,
    required this.user,
    required this.isNewUser,
  });

  final User user;
  final AuthProviders authProvider;
  final bool isNewUser;
}

final class SignInFailure extends SignInState {
  const SignInFailure(this.errorMessage, this.authProvider);

  final String errorMessage;
  final AuthProviders authProvider;
}

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._authRepository) : super(const SignInInitial());
  final AuthRepository _authRepository;

  //to signIn user
  void signInUser(
    AuthProviders authProvider, {
    String email = '',
    String verificationId = '',
    String smsCode = '',
    String password = '',
    String? appLanguage,
  }) {
    print('🎮 [SignInCubit] Starting sign-in process...');
    print('🎮 [SignInCubit] Provider: ${authProvider.name}');
    print('🎮 [SignInCubit] Email: $email');
    print('🎮 [SignInCubit] Password length: ${password.length}');
    print('🎮 [SignInCubit] SMS Code provided: ${smsCode.isNotEmpty}');
    print('🎮 [SignInCubit] Verification ID provided: ${verificationId.isNotEmpty}');
    
    emit(SignInProgress(authProvider));
    print('🎮 [SignInCubit] Emitted SignInProgress state');

    _authRepository
        .signInUser(
          authProvider,
          email: email,
          password: password,
          smsCode: smsCode,
          verificationId: verificationId,
          appLanguage: appLanguage,
        )
        .then((v) async {
          print('🎮 [SignInCubit] ✅ Sign-in repository call successful');
          
          await FirebaseAnalytics.instance.logLogin(
            loginMethod: authProvider.name,
          );
          print('🎮 [SignInCubit] 📊 Analytics logged');

          emit(
            SignInSuccess(
              user: v.user,
              authProvider: authProvider,
              isNewUser: v.isNewUser,
            ),
          );
          print('🎮 [SignInCubit] ✅ Emitted SignInSuccess state');
        })
        .catchError((dynamic e) {
          print('🎮 [SignInCubit] ❌ Sign-in failed with error: $e');
          print('🎮 [SignInCubit] ❌ Error type: ${e.runtimeType}');
          emit(SignInFailure(e.toString(), authProvider));
          print('🎮 [SignInCubit] ❌ Emitted SignInFailure state');
        });
  }
}
