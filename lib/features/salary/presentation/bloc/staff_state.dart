import 'package:equatable/equatable.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_model.dart';

abstract class StaffState extends Equatable {
  const StaffState();

  @override
  List<Object?> get props => [];
}

class StaffInitial extends StaffState {}

class StaffAddLoading extends StaffState {}
class StaffAddSuccess extends StaffState {
  const StaffAddSuccess();

  @override
  List<Object?> get props => [];
}
class StaffAddFailure extends StaffState {
  final String error;
  const StaffAddFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class StaffFetchLoading extends StaffState {}
class StaffFetchSuccess extends StaffState {
  final List<StaffModel> staffs;
  const StaffFetchSuccess(this.staffs);

  @override
  List<Object?> get props => [staffs];
}
class StaffFetchFailure extends StaffState {
  final String error;
  const StaffFetchFailure(this.error);

  @override
  List<Object?> get props => [error];
}

