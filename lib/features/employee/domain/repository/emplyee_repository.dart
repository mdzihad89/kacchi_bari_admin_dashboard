import 'package:dartz/dartz.dart';
import 'package:kacchi_bari_admin_dashboard/features/employee/data/model/add_employee_request_dto.dart';
import 'package:kacchi_bari_admin_dashboard/features/employee/data/model/employee_model.dart';

import '../../../../core/network/failure.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, String>> addEmployee(AddEmployeeRequestDTO addEmployeeRequestDTO);
  //Future<Either<Failure, List<EmployeeModel>>> getAllEmployee(int page);
  Future<Either<Failure, List<EmployeeModel>>> getAllEmployee();
}