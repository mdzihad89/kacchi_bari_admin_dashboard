

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/presentation/bloc/staff_event.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/presentation/bloc/staff_state.dart';
import '../../data/model/staff_model.dart';
import '../../domain/staff_repository.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  final StaffRepository staffRepository;
  List<StaffModel> staffList = [];
  StaffBloc({required this.staffRepository}) : super(StaffInitial()) {
    on<AddStaffEvent>(_onAddStaff);
    on<FetchStaffEvent>(_onFetchStaff);
  }

  Future<void> _onAddStaff(AddStaffEvent event, Emitter<StaffState> emit) async {
    emit(StaffAddLoading());
    final result = await staffRepository.addStaff(event.addStaffDTO);
    result.fold(
          (failure) => emit(StaffAddFailure(failure.message)),
          (staffModel) {
            staffList.insert(0, staffModel);
            emit(const StaffAddSuccess());
            emit(StaffFetchSuccess(staffList));
      },
    );
  }

  Future<void> _onFetchStaff(FetchStaffEvent event, Emitter<StaffState> emit) async {
    emit(StaffFetchLoading());
    final result = await staffRepository.fetchAllStaff();
    result.fold(
          (failure) => emit(StaffFetchFailure(failure.message)),
          (staffs){
            staffList = staffs;
            emit(StaffFetchSuccess(staffList));},
    );
  }


  }