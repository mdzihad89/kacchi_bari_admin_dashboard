

import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class FetchDashboardEvent extends DashboardEvent {
  final String branchId;
  final String  localStartTime;
  final String  localEndTime;

  const FetchDashboardEvent({required this.branchId, required this.localStartTime, required this.localEndTime});
  @override
  List<Object?> get props => [branchId,  localStartTime, localEndTime];

}

