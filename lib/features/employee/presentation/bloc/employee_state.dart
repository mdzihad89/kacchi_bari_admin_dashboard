import 'package:equatable/equatable.dart';
import 'package:kacchi_bari_admin_dashboard/features/employee/data/model/employee_model.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeAddLoading extends EmployeeState {}

class EmployeeAddSuccess extends EmployeeState {
  final String message;
  const EmployeeAddSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EmployeeAddFailure extends EmployeeState {
  final String error;
  const EmployeeAddFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class EmployeeFetchLoading extends EmployeeState {}

class EmployeeFetchSuccess extends EmployeeState {
  final List<EmployeeModel> employees;
  const EmployeeFetchSuccess(this.employees);

  @override
  List<Object?> get props => [employees];
}

class EmployeeFetchFailure extends EmployeeState {
  final String error;
  const EmployeeFetchFailure(this.error);

  @override
  List<Object?> get props => [error];
}