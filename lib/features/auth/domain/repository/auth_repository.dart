
import 'package:dartz/dartz.dart';
import 'package:kacchi_bari_admin_dashboard/features/auth/data/model/login_request_dto.dart';

import '../../../../core/network/failure.dart';
import '../../data/model/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithEmailPassword(LoginRequestDto loginRequestDto);
  Future<bool> signOut();

}