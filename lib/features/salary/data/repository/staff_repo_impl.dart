
 import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:kacchi_bari_admin_dashboard/core/network/failure.dart';

import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/add_staff_dto.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_add_leave_dto.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_model.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_salary_payment_dto.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_salary_payment_model.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_salary_report_dto.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_salary_report_model.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/update_staff_dto.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/network/error_handle.dart';
import '../../domain/staff_repository.dart';

class StaffRepoImpl implements StaffRepository {

   final ApiService _apiService;

  StaffRepoImpl(this._apiService);
  @override
  Future<Either<Failure, StaffModel>> addStaff(AddStaffDTO addStaffDTO) async{
    try {
      final response = await _apiService.multiPartPost(endPoint: "staff/create-staff", data: addStaffDTO.toMap());
      final staffModel = StaffModel.fromJson(response.data);
      return Right(staffModel);


    }catch(error){
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, List<StaffModel>>> fetchAllStaff() async{

    try{
      final response = await _apiService.get(endPoint: "staff/get-all-staff");
      final data = (response.data as List).map((e) => StaffModel.fromJson(e)).toList();
      return Right(data);
    }catch(error){
      print(error.toString());
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, StaffSalaryPaymentModel>> createStaffSalary(StaffSalaryPaymentDto staffSalaryPaymentDto) async{

    try {
      final response = await _apiService.post(endPoint: "staff/create-staff-salary", data: staffSalaryPaymentDto.toJson());
      final staffSalaryModel = StaffSalaryPaymentModel.fromJson(response.data);
      return Right(staffSalaryModel);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteStaffSalaryPayment(String staffSalaryId)async {

    try {
      _apiService.delete(endPoint: "staff/delete-staff-salary-payment", params: {"id": staffSalaryId});
      return const Right(true);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, List<StaffSalaryPaymentModel>>> fetchAllStaffSalaryByStaffId(String staffId)async {

    try {
      final response = await _apiService.get(endPoint: "staff/get-all-salary-payment-by-staff-id", params: { "staffId": staffId});
      final data = (response.data as List).map((e) => StaffSalaryPaymentModel.fromJson(e)).toList();
      return Right(data);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, StaffSalaryPaymentModel>> updateStaffSalaryPayment(String staffSalaryId, StaffSalaryPaymentDto staffSalaryPaymentDto)async {

    try {
      final response = await _apiService.put(endPoint: "staff/update-staff-salary-payment", data: staffSalaryPaymentDto.toJson(), params: {"id": staffSalaryId});
      final staffSalaryModel = StaffSalaryPaymentModel.fromJson(response.data);
      return Right(staffSalaryModel);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, StaffModel>> fetchStaffById(String staffId)async {

    try {
      final response = await _apiService.get(endPoint: "staff/get-staff-by-id", params: {"id": staffId});
      final staffModel = StaffModel.fromJson(response.data);
      return Right(staffModel);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, StaffSalaryReportModel>> getStaffSalaryReport(StaffSalaryReportDTO staffSalaryReportDTO) async{

    try {
      final response = await _apiService.post(endPoint: "staff/get-salary-report-by-staff-id", data: staffSalaryReportDTO.toJson());
      final staffSalaryReportModel = StaffSalaryReportModel.fromJson(response.data);
      return Right(staffSalaryReportModel);
    } catch (error) {
      log(error.toString());
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, String>> addLeaveDays(AddLeaveDto addLeaveDto) async{
    try {
      final response = await _apiService.put(endPoint: "staff/add-leave-days", data: addLeaveDto.toJson());
      return Right(response.data["message"]);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, String>> removeLeaveDay(String staffId, String leaveDate) async{

    try {
      final response = await _apiService.put(endPoint: "staff/remove-leave-day",data:  {"staffId": staffId, "leaveDate": leaveDate});
      return Right(response.data["message"]);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, String>> exitDateUpdate(String staffId, String exitDate) async{

    try {
      final response = await _apiService.put(endPoint: "staff/update-exit-date", data: {"staffId": staffId, "exitDate": exitDate});
      return Right(response.data["message"]);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, List<StaffModel>>> fetchAllPreviousStaff() async{

    try {
      final response = await _apiService.get(endPoint: "staff/get-all-previous-staff");
      final data = (response.data as List).map((e) => StaffModel.fromJson(e)).toList();
      return Right(data);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, StaffModel>> updateStaff(UpdateStaffDTO updateStaffDTO)async {

    try {
      final response = await _apiService.multiPartPut(endPoint: "staff/update-staff", data: updateStaffDTO.toMap());
      final staffModel = StaffModel.fromJson(response.data);
      return Right(staffModel);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, String>> deleteStaff(String staffId) async{
    try {

      final response = await _apiService.delete(endPoint: "staff/delete-staff", params: {"id": staffId});
      return Right(response.data["message"]);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }

  }

  @override
  Future<Either<Failure, StaffModel>> copyStaff(String staffId, String joiningDate, int basicSalary) async{

    try {

      final response = await _apiService.post(endPoint: "staff/copy-profile", data:  {"staffId": staffId, "joiningDate": joiningDate, "basicSalary": basicSalary});
      final staffModel = StaffModel.fromJson(response.data);
      return Right(staffModel);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }


  }


}