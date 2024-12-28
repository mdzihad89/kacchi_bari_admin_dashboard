
import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:kacchi_bari_admin_dashboard/core/network/failure.dart';
import 'package:kacchi_bari_admin_dashboard/features/auth/data/model/login_request_dto.dart';
import 'package:kacchi_bari_admin_dashboard/features/auth/data/model/user_model.dart';
import 'package:kacchi_bari_admin_dashboard/features/auth/domain/repository/auth_repository.dart';
import '../../../../core/app/app_prefs.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/error_handle.dart';

class AuthRepositoryImpl extends AuthRepository{
  final ApiService _apiService;
  final AppPreferences _appPref;
  AuthRepositoryImpl(this._apiService, this._appPref);



  @override
  Future<Either<Failure, User>> signInWithEmailPassword(LoginRequestDto loginRequestDto) async{
    try{
      final response = await _apiService.post(endPoint: "user/login", data: loginRequestDto.toJson());
      final data = userFromJson(jsonEncode(response.data));
     _appPref.saveCredential (data.token!);
     return Right(data);
    }catch(error){

      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<bool> signOut() async{
   await _appPref.removeCredential();
    return Future.value(true);
  }

}