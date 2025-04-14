

import 'package:dartz/dartz.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_add_leave_dto.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_model.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_salary_payment_dto.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_salary_payment_model.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/update_staff_dto.dart';

import '../../../core/network/failure.dart';
import '../data/model/add_staff_dto.dart';
import '../data/model/staff_salary_report_dto.dart';
import '../data/model/staff_salary_report_model.dart';

abstract class StaffRepository {
  Future<Either<Failure, StaffModel>> addStaff(AddStaffDTO addStaffDTO);
  Future<Either<Failure, StaffModel>> updateStaff( UpdateStaffDTO updateStaffDTO);
  Future<Either<Failure, StaffModel>> copyStaff( String staffId, String joiningDate, int basicSalary);
  Future<Either<Failure, String>> deleteStaff(String staffId);
  Future<Either<Failure, List<StaffModel>>> fetchAllStaff();
  Future<Either<Failure, List<StaffModel>>> fetchAllPreviousStaff();
  Future<Either<Failure, StaffModel>> fetchStaffById(String staffId);
  Future<Either<Failure, StaffSalaryPaymentModel>> createStaffSalary(StaffSalaryPaymentDto staffSalaryPaymentDto);
  Future<Either<Failure, List<StaffSalaryPaymentModel>>> fetchAllStaffSalaryByStaffId(String staffId);
  Future<Either<Failure, StaffSalaryPaymentModel>> updateStaffSalaryPayment(String staffSalaryId, StaffSalaryPaymentDto staffSalaryPaymentDto);
  Future<Either<Failure, bool>> deleteStaffSalaryPayment(String staffSalaryId);
  Future<Either<Failure, StaffSalaryReportModel>> getStaffSalaryReport(StaffSalaryReportDTO staffSalaryReportDTO);
  Future<Either<Failure, String>> addLeaveDays(AddLeaveDto addLeaveDto);
  Future<Either<Failure, String>> removeLeaveDay(String staffId, String leaveDate);
  Future<Either<Failure, String>> exitDateUpdate(String staffId, String exitDate);






}