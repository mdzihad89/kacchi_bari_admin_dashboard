import 'package:equatable/equatable.dart';

import '../../data/model/add_staff_dto.dart';
import '../../data/model/update_staff_dto.dart';

abstract class StaffEvent extends Equatable {
  const StaffEvent();

  @override
  List<Object?> get props => [];
}

class AddStaffEvent extends StaffEvent {
  final AddStaffDTO addStaffDTO;

  const AddStaffEvent( this.addStaffDTO);

  @override
  List<Object?> get props => [AddStaffDTO];
}

class FetchStaffEvent extends StaffEvent {}

class FetchPreviousStaffEvent extends StaffEvent {}

class UpdateStaffEvent extends StaffEvent {
  final UpdateStaffDTO updateStaffDTO;

  const UpdateStaffEvent(this.updateStaffDTO);

  @override
  List<Object?> get props => [updateStaffDTO];
}

class DeleteStaffEvent extends StaffEvent {
  final String staffId;

  const DeleteStaffEvent(this.staffId);

  @override
  List<Object?> get props => [staffId];
}


class CopyStaffEvent extends StaffEvent {
  final String staffId;
  final String joiningDate;
  final int basicSalary;

  const CopyStaffEvent({required this.staffId, required this.joiningDate, required this.basicSalary});

  @override
  List<Object?> get props => [staffId, joiningDate, basicSalary];
}

