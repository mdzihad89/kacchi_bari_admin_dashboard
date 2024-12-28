import 'package:equatable/equatable.dart';
import 'package:kacchi_bari_admin_dashboard/features/employee/data/model/add_employee_request_dto.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

class AddEmployeeEvent extends EmployeeEvent {
  final AddEmployeeRequestDTO addEmployeeRequestDTO;

  const AddEmployeeEvent( this.addEmployeeRequestDTO);

  @override
  List<Object?> get props => [addEmployeeRequestDTO];
}

class FetchEmployeeEvent extends EmployeeEvent {
}

