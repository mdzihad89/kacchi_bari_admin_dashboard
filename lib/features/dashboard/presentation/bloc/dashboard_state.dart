import 'package:equatable/equatable.dart';

import '../../data/model/order_report_model.dart';
import '../../data/model/top_selling_item.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashBoardInitial  extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final OrderReport orderReport;
  const DashboardLoaded( this.orderReport);

  @override
  List<Object?> get props => [ orderReport];
}

class DashboardFailure extends DashboardState {
  final String error;
  const DashboardFailure(this.error);

  @override
  List<Object?> get props => [error];
}

