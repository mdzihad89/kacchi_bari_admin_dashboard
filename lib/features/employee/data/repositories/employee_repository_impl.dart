import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:kacchi_bari_admin_dashboard/core/network/failure.dart';
import 'package:kacchi_bari_admin_dashboard/features/employee/data/model/add_employee_request_dto.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/error_handle.dart';
import '../../domain/repository/emplyee_repository.dart';
import '../model/employee_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final ApiService _apiService;


  EmployeeRepositoryImpl( this._apiService);

  @override
  Future<Either<Failure, String>> addEmployee(AddEmployeeRequestDTO addEmployeeRequestDTO) async{

   try {
     final response = await _apiService.multiPartPost(endPoint: "user/register", data: addEmployeeRequestDTO.toMap());
     final message =  response.data['message'];
      return  Right(message);
   }catch(error){
     return Left(ErrorHandler.handle(error).failure);
   }
  }

  @override
  Future<Either<Failure,  List<EmployeeModel>>> getAllEmployee( ) async{
   try{
     //final response = await _apiService.get(endPoint: "user/all-user", params: {"page": page.toString()});
     final response = await _apiService.get(endPoint: "user/all-user");
      final data = (response.data as List).map((e) => EmployeeModel.fromJson(e)).toList();
      return Right(data);
   }catch(error){
     return Left(ErrorHandler.handle(error).failure);
   }

  }

}