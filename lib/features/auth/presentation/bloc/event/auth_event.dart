import 'package:equatable/equatable.dart';

import '../../../data/model/login_request_dto.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class SignInWithEmailPassword extends AuthEvent {
  final LoginRequestDto loginRequestDto;
  const SignInWithEmailPassword({required this.loginRequestDto});
}

class SignOutRequested extends AuthEvent {}