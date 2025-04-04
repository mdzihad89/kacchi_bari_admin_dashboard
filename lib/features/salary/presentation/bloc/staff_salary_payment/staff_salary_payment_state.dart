

import 'package:equatable/equatable.dart';

import '../../../data/model/staff_salary_payment_model.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_model.dart';

import '../../../data/model/staff_salary_report_model.dart';

class StaffSalaryPaymentState extends Equatable {
  const StaffSalaryPaymentState();

  @override
  List<Object> get props => [];
}

class StaffSalaryPaymentInitial extends StaffSalaryPaymentState {}

class StaffSalaryPaymentLoading extends StaffSalaryPaymentState {}

class StaffSalaryPaymentLoaded extends StaffSalaryPaymentState {
  final List<StaffSalaryPaymentModel>  staffSalaryPaymentList;

  const StaffSalaryPaymentLoaded(this.staffSalaryPaymentList);

  @override
  List<Object> get props => [staffSalaryPaymentList];
}

class StaffSalaryPaymentError extends StaffSalaryPaymentState {
  final String message;

  const StaffSalaryPaymentError(this.message);

  @override
  List<Object> get props => [message];
}

class StaffSalaryPaymentOperationLoading extends StaffSalaryPaymentState {}

class StaffSalaryPaymentOperationError extends StaffSalaryPaymentState {
  final String message;

  const StaffSalaryPaymentOperationError(this.message);

  @override
  List<Object> get props => [message];
}

class StaffSalaryPaymentOperationSuccess extends StaffSalaryPaymentState {}

class StaffFetchSingleLoading extends StaffSalaryPaymentState {}
class StaffFetchSingleSuccess extends StaffSalaryPaymentState {
  final StaffModel staff;
  const StaffFetchSingleSuccess(this.staff);

  @override
  List<Object> get props => [staff];
}
class StaffFetchSingleFailure extends StaffSalaryPaymentState {
  final String error;
  const StaffFetchSingleFailure(this.error);

  @override
  List<Object> get props => [error];
}

class StaffSalaryReportLoading extends StaffSalaryPaymentState {}
class StaffSalaryReportSuccess extends StaffSalaryPaymentState {
  final StaffSalaryReportModel  staffSalaryReport;
  const StaffSalaryReportSuccess(this.staffSalaryReport);

  @override
  List<Object> get props => [staffSalaryReport];
}
class StaffSalaryReportFailure extends StaffSalaryPaymentState {
  final String error;
  const StaffSalaryReportFailure(this.error);

  @override
  List<Object> get props => [error];
}

class AddLeaveEventSuccess extends StaffSalaryPaymentState {
  final String message;
  const AddLeaveEventSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AddLeaveEventFailure extends StaffSalaryPaymentState {
  final String error;
  const AddLeaveEventFailure(this.error);

  @override
  List<Object> get props => [error];
}

 class AddLeaveEventLoading extends StaffSalaryPaymentState {}

