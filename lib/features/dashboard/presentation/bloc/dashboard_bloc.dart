
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kacchi_bari_admin_dashboard/features/dashboard/domain/dashboard_repository.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {

  final DashboardRepository dashboardRepository;

  DashboardBloc({required this.dashboardRepository}) : super(DashBoardInitial()){
    on<FetchDashboardEvent>(_onFetchDashboard);
  }

  Future<void> _onFetchDashboard(FetchDashboardEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    final result = await dashboardRepository.getSumOfNetPayable(event.branchId, event.localStartTime, event.localEndTime);
    result.fold(
          (failure) => emit(DashboardFailure(failure.message)),
          (orderReport) => emit(DashboardLoaded(orderReport)),
    );
  }



}