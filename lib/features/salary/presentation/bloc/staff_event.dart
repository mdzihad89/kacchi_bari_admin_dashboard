import 'package:equatable/equatable.dart';

import '../../data/model/add_staff_dto.dart';

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

