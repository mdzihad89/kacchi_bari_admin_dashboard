import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashBoardInitial  extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final String totalNetPayableAmount;
  const DashboardLoaded( this.totalNetPayableAmount);

  @override
  List<Object?> get props => [ totalNetPayableAmount];
}

class DashboardFailure extends DashboardState {
  final String error;
  const DashboardFailure(this.error);

  @override
  List<Object?> get props => [error];
}