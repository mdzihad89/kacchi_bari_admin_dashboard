

import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class FetchDashboardEvent extends DashboardEvent {
  final String branchId;
  final String  date;

  const FetchDashboardEvent({required this.branchId, required this.date});
  @override
  List<Object?> get props => [branchId, date];

}


class FetchTopSellingItemsEvent extends DashboardEvent {
  final String branchId;
  final String date;

  const FetchTopSellingItemsEvent({required this.branchId, required this.date});
  @override
  List<Object?> get props => [branchId, date];

}