

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
    on<FetchPreviousStaffEvent>( _onFetchPreviousStaff);
    on<UpdateStaffEvent>(_onUpdateStaff);
    on<DeleteStaffEvent>(_onDeleteStaff);
    on<CopyStaffEvent>( _onCopyStaff);
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

  Future<void> _onFetchPreviousStaff(FetchPreviousStaffEvent event, Emitter<StaffState> emit) async {
    emit(StaffFetchLoading());
    final result = await staffRepository.fetchAllPreviousStaff();
    result.fold(
          (failure) => emit(StaffFetchFailure(failure.message)),
          (staffs) {
        emit(StaffFetchSuccess(staffs));
      },
    );
  }

  Future<void> _onUpdateStaff(UpdateStaffEvent event, Emitter<StaffState> emit) async {
    emit(StaffUpdateLoading());
    final result = await staffRepository.updateStaff(event.updateStaffDTO);
    result.fold(
          (failure) => emit(StaffUpdateFailure(failure.message)),
          (staffModel) {
        int index = staffList.indexWhere((staff) => staff.id == staffModel.id);
        if (index != -1) {
          staffList[index] = staffModel;
        }
        emit(const StaffUpdateSuccess());
        emit(StaffFetchSuccess(staffList));
      },
    );
  }

  Future<void> _onDeleteStaff(DeleteStaffEvent event, Emitter<StaffState> emit) async {
    emit(StaffDeleteLoading());
    final result = await staffRepository.deleteStaff(event.staffId);
    result.fold(
          (failure) => emit(StaffFetchFailure(failure.message)),
          (message) {
        staffList.removeWhere((staff) => staff.id == event.staffId);
        emit( StaffDeleteSuccess(message));
        emit(StaffFetchSuccess(staffList));
      },
    );
  }

  Future<void> _onCopyStaff(CopyStaffEvent event, Emitter<StaffState> emit) async {
    emit(StaffCopyLoading());
    final result = await staffRepository.copyStaff(event.staffId, event.joiningDate, event.basicSalary);
    result.fold(
          (failure) => emit(StaffCopyFailure(failure.message)),
          (staffModel) {
        staffList.insert(0, staffModel);
        emit( StaffCopySuccess());
        emit(StaffFetchSuccess(staffList));
      },
    );
  }

}