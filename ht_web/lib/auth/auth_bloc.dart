import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/auth/event/auth_event.dart';
import 'package:ht_web/auth/state/auth_state.dart';
import 'package:ht_web/business/auth/repository/auth_exception.dart';
import 'package:ht_web/business/auth/repository/auth_repo.dart';
import 'package:ht_web/conf/shared/secure_storage.dart';

class AuthBLOC extends Bloc<AuthEvent, AuthState> {
  final AuthRepo repo = AuthRepo.instance;
  AuthBLOC() : super(const AuthState()) {
    on<AuthInintEvent>((event, emit) {
      emit(state.clear());
    });

    on<AuthRegister>((event, emit) async {
      try {
        emit(state.copyWith(event: const AuthPending()));
        final Map<String, String> res = await repo.register(
          fullName: event.fname,
          email: event.email,
          password: event.pass,
        );
        log('Register Complete');
        emit(state.copyWith(
          event: const AuthRegisterSuccess(),
          fname: res['full_name'],
          email: res['email'],
          role: res['role'],
        ));
      } on AuthenticationException catch (e) {
        log('[AuthBLOC Error]: (Register).\n${e.reason}');
        emit(state.copyWith(event: AuthException(message: e.reason)));
      } catch (e) {
        log('[AuthBLOC Error]: (Register).\n$e');
        emit(state.copyWith(
            event: const AuthException(message: 'Something Goes Wrong!')));
      }
    });

    on<AuthLogin>((event, emit) async {
      try {
        emit(state.copyWith(event: const AuthPending()));
        final Map<String, String> res = await repo.login(
          email: event.email,
          pass: event.pass,
        );

        await SecureStorage.instance.write(
          token: res['token'] ?? '',
          refToken: res['refreshToken'] ?? '',
        );

        emit(state.copyWith(
          event: const AuthLoginSuccess(),
          token: res['token'],
          refToken: res['refreshToken'],
        ));
      } on AuthenticationException catch (e) {
        log('[AuthBLOC Error]: (Login).\n${e.reason}');
        emit(state.copyWith(event: AuthException(message: e.reason)));
      } catch (e) {
        log('[AuthBLOC Error]: (Login).\n$e');
        emit(state.copyWith(
            event: const AuthException(message: 'Something Goes Wrong!')));
      }
    });

    on<RefreshToken>((event, emit) async {
      try {
        emit(state.copyWith(event: const AuthPending()));

        final cred = await SecureStorage.instance.read();
        final String refreshToken = cred['refToken'] ?? 'NULL';
        final String token =
            await repo.refreshToken(refreshToken: refreshToken);
        await SecureStorage.instance
            .write(refToken: cred['refToken']!, token: token);

        emit(state.copyWith(token: token, event: const RefreshTokenSuccess()));
      } on AuthenticationException catch (e) {
        log('[AuthBLOC Error]: (Refresh Token).\n${e.reason}');
        emit(state.copyWith(event: AuthException(message: e.reason)));
      } catch (e) {
        log('[AuthBLOC Error]: (Refresh Token).\n$e');
        emit(state.copyWith(
            event: const AuthException(message: 'Something Goes Wrong!')));
      }
    });

    on<TokenExpiredOrNull>(
      (event, emit) => emit(state.copyWith(event: const TokenExpiredOrNull())),
    );

    on<SignOut>((event, emit) async {
      await SecureStorage.instance.clear();
      emit(state.clear());
      emit(state.copyWith(event: const SignOut()));
    });
  }
}
