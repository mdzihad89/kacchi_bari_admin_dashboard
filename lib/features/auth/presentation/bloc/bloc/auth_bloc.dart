
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kacchi_bari_admin_dashboard/features/auth/domain/repository/auth_repository.dart';
import 'package:kacchi_bari_admin_dashboard/features/auth/presentation/bloc/event/auth_event.dart';
import 'package:kacchi_bari_admin_dashboard/features/auth/presentation/bloc/state/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent ,AuthState>{
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()){
    on<SignInWithEmailPassword>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.signInWithEmailPassword(event.loginRequestDto);
      result.fold(
            (failure) => emit(AuthError(failure.message)),
            (user) => emit(Authenticated(user)),
      );
    });


    on<SignOutRequested>((event, emit) async {
      final result = await authRepository.signOut();
      if(result){
        emit(UnAuthenticated());
      }else{
        emit(const AuthError("Sign Out Failed"));
      }
    });
  }






}