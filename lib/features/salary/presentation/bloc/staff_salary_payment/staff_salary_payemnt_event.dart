
import 'package:equatable/equatable.dart';

import '../../../data/model/staff_add_leave_dto.dart';
import '../../../data/model/staff_salary_payment_dto.dart';
import '../../../data/model/staff_salary_payment_model.dart';
import '../../../data/model/staff_salary_report_dto.dart';
import '../../../data/model/staff_salary_report_model.dart';

abstract class StaffSalaryPaymentEvent extends Equatable {
  const StaffSalaryPaymentEvent();
}

class GetAllStaffSalaryPaymentByStaffId extends StaffSalaryPaymentEvent {
  final String staffId;
  const GetAllStaffSalaryPaymentByStaffId({required this.staffId});
  @override
  List<Object> get props => [];
}

class AddStaffSalaryPayment extends StaffSalaryPaymentEvent {

  final StaffSalaryPaymentDto staffSalaryPaymentDto;

  const AddStaffSalaryPayment({required this.staffSalaryPaymentDto});

  @override
  List<Object> get props => [staffSalaryPaymentDto];
}

class DeleteStaffSalaryPayment extends StaffSalaryPaymentEvent {
  final String staffSalaryId;
  const DeleteStaffSalaryPayment({required this.staffSalaryId});

  @override
  List<Object> get props => [staffSalaryId];
}

class UpdateStaffSalaryPayment extends StaffSalaryPaymentEvent {
  final String staffSalaryId;
  final StaffSalaryPaymentDto staffSalaryPaymentDto;

  const UpdateStaffSalaryPayment({required this.staffSalaryId,  required this.staffSalaryPaymentDto });

  @override
  List<Object> get props => [staffSalaryId, staffSalaryPaymentDto];
}


class FetchSingleStaffEvent extends StaffSalaryPaymentEvent {
  final String staffId;

  const FetchSingleStaffEvent({required this.staffId});

  @override
  List<Object?> get props => [staffId];
}


class FetchStaffSalaryReport extends StaffSalaryPaymentEvent {
  final StaffSalaryReportDTO staffSalaryReportDTO;

  const FetchStaffSalaryReport({required this.staffSalaryReportDTO});

  @override
  List<Object?> get props => [staffSalaryReportDTO];
}

class AddLeaveEvent extends StaffSalaryPaymentEvent {
  final AddLeaveDto addLeaveDto;
  const AddLeaveEvent({required this.addLeaveDto});

  @override
  List<Object?> get props => [addLeaveDto];
}

//Remove leave event
class RemoveLeaveEvent extends StaffSalaryPaymentEvent {
  final String staffId;
  final String leaveDate;
  const RemoveLeaveEvent({required this.staffId, required this.leaveDate});

  @override
  List<Object?> get props => [staffId, leaveDate];
}


//Exit date update event
class ExitDateUpdateEvent extends StaffSalaryPaymentEvent {
  final String staffId;
  final String exitDate;
  const ExitDateUpdateEvent({required this.staffId, required this.exitDate});

  @override
  List<Object?> get props => [staffId, exitDate];
}



class DownloadSalaryReportEvent extends StaffSalaryPaymentEvent {

  final StaffSalaryReportModel staffSalaryReportModel;
  final List<DateTime> leaveDates;
  final List<StaffSalaryPaymentModel> staffSalaryPaymentList;

  const DownloadSalaryReportEvent( {
    required this.staffSalaryReportModel,
    required this.leaveDates,
    required this.staffSalaryPaymentList,
  });
  @override
  List<Object?> get props => [
    staffSalaryReportModel,
    leaveDates,
    staffSalaryPaymentList,
  ];
}


