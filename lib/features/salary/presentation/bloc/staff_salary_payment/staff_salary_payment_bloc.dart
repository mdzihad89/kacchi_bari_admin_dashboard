

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kacchi_bari_admin_dashboard/core/app/app_helper.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/presentation/bloc/staff_salary_payment/staff_salary_payemnt_event.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/presentation/bloc/staff_salary_payment/staff_salary_payment_state.dart';

import '../../../data/model/staff_salary_payment_model.dart';
import '../../../domain/staff_repository.dart';

class StaffSalaryPaymentBloc extends Bloc<StaffSalaryPaymentEvent, StaffSalaryPaymentState> {
  final StaffRepository staffRepository;
  List<StaffSalaryPaymentModel> staffSalaryPaymentList = [];


  StaffSalaryPaymentBloc({required this.staffRepository}) : super(StaffSalaryPaymentInitial()){
    on<GetAllStaffSalaryPaymentByStaffId>( _onGetAllStaffSalaryPaymentByStaffId);
    on<AddStaffSalaryPayment>( _onAddStaffSalaryPayment);
    on<DeleteStaffSalaryPayment>( _onDeleteStaffSalaryPayment);
    on<UpdateStaffSalaryPayment>( _onUpdateStaffSalaryPayment);
    on<FetchSingleStaffEvent>( _onFetchSingleStaffEvent);
    on<FetchStaffSalaryReport>( _onFetchStaffSalaryReport);
    on<AddLeaveEvent>( _onAddLeaveEvent);
    on<RemoveLeaveEvent>( _onRemoveLeaveEvent);
    on<ExitDateUpdateEvent>( _onExitDateUpdateEvent);
    on<DownloadSalaryReportEvent> ( _onDownloadSalaryReportEvent);

  }

  void _onGetAllStaffSalaryPaymentByStaffId(GetAllStaffSalaryPaymentByStaffId event, Emitter<StaffSalaryPaymentState> emit) async {
    emit( StaffSalaryPaymentLoading());

    final staffSalaryResult = await staffRepository.fetchAllStaffSalaryByStaffId(event.staffId);
    staffSalaryResult.fold(
      (failure) => emit(StaffSalaryPaymentError( failure.message)),
      (staffSalary) {

        staffSalaryPaymentList = staffSalary;
        emit(StaffSalaryPaymentLoaded(staffSalaryPaymentList));
      },
    );
  }

  void _onAddStaffSalaryPayment(AddStaffSalaryPayment event, Emitter<StaffSalaryPaymentState> emit) async {
    emit(StaffSalaryPaymentOperationLoading());
    final staffSalaryResult = await staffRepository.createStaffSalary(event.staffSalaryPaymentDto);
    staffSalaryResult.fold(
          (failure) => emit(StaffSalaryPaymentError(failure.message)),
          (staffSalary) {
        staffSalaryPaymentList.insert(0, staffSalary);
        emit( StaffSalaryPaymentOperationSuccess());
        emit(StaffSalaryPaymentLoaded(staffSalaryPaymentList));
      },
    );
  }

  void _onDeleteStaffSalaryPayment(DeleteStaffSalaryPayment event, Emitter<StaffSalaryPaymentState> emit) async {
    emit(StaffSalaryPaymentOperationLoading());
    final staffSalaryResult = await staffRepository.deleteStaffSalaryPayment(event.staffSalaryId);
    staffSalaryResult.fold(
          (failure) => emit(StaffSalaryPaymentError(failure.message)),
          (isDeleted) {
          staffSalaryPaymentList.removeWhere((staffSalary) => staffSalary.id == event.staffSalaryId);
          emit( StaffSalaryPaymentOperationSuccess());
          emit(StaffSalaryPaymentLoaded(staffSalaryPaymentList));
      },
    );
  }

  void _onUpdateStaffSalaryPayment(UpdateStaffSalaryPayment event, Emitter<StaffSalaryPaymentState> emit) async {
    emit(StaffSalaryPaymentOperationLoading());
    final staffSalaryResult = await staffRepository.updateStaffSalaryPayment(event.staffSalaryId, event.staffSalaryPaymentDto);
    staffSalaryResult.fold(
          (failure) => emit(StaffSalaryPaymentError(failure.message)),
          (staffSalary) {
        final index = staffSalaryPaymentList.indexWhere((element) => element.id == event.staffSalaryId);
        if (index != -1) {
          staffSalaryPaymentList[index] = staffSalary;
        }
        emit( StaffSalaryPaymentOperationSuccess());
        emit(StaffSalaryPaymentLoaded(staffSalaryPaymentList));
      },
    );
  }

  void _onFetchSingleStaffEvent(FetchSingleStaffEvent event, Emitter<StaffSalaryPaymentState> emit) async {
    emit(StaffFetchSingleLoading());
    final staffResult = await staffRepository.fetchStaffById(event.staffId);
    staffResult.fold(
          (failure) => emit(StaffFetchSingleFailure(failure.message)),
          (staff) => emit(StaffFetchSingleSuccess(staff)),
    );
  }

  void _onFetchStaffSalaryReport(FetchStaffSalaryReport event, Emitter<StaffSalaryPaymentState> emit) async {
    emit(StaffSalaryReportLoading());
    final staffSalaryResult = await staffRepository.getStaffSalaryReport(event.staffSalaryReportDTO);
    staffSalaryResult.fold(
          (failure) => emit(StaffSalaryReportFailure(failure.message)),
          (staffSalaryReport) {
        emit(StaffSalaryReportSuccess(staffSalaryReport));
      },
    );
  }


  void _onAddLeaveEvent(AddLeaveEvent event, Emitter<StaffSalaryPaymentState> emit) async {
    emit(AddLeaveEventLoading());
    final staffSalaryResult = await staffRepository.addLeaveDays(event.addLeaveDto);
    staffSalaryResult.fold(
          (failure) => emit(AddLeaveEventFailure(failure.message)),
          (message) {
            emit( AddLeaveEventSuccess(message));
      },
    );
  }


  void _onRemoveLeaveEvent(RemoveLeaveEvent event, Emitter<StaffSalaryPaymentState> emit) async {

    final staffSalaryResult = await staffRepository.removeLeaveDay(event.staffId, event.leaveDate);
    staffSalaryResult.fold(
          (failure) => emit(AddLeaveEventFailure(failure.message)),
          (message) {
            emit( AddLeaveEventSuccess(message));
      },
    );
  }

  void _onExitDateUpdateEvent(ExitDateUpdateEvent event, Emitter<StaffSalaryPaymentState> emit) async {
    emit(ExitDateUpdateLoading());
    final staffSalaryResult = await staffRepository.exitDateUpdate(event.staffId, event.exitDate);
    staffSalaryResult.fold(
          (failure) => emit(ExitDateUpdateFailure(failure.message)),
          (message) {
            emit( ExitDateUpdateSuccess(message));
      },
    );
  }

  void _onDownloadSalaryReportEvent(DownloadSalaryReportEvent event, Emitter<StaffSalaryPaymentState> emit) async {
    emit(StaffSalaryReportDownloadLoading());
    try{
       await AppHelper.generateAndDownloadReportPdf(
        event.staffSalaryReportModel,
        event.leaveDates,
        event.staffSalaryPaymentList,);
      emit(StaffSalaryReportDownloadSuccess());

    }catch(e){
      emit(StaffSalaryReportDownloadFailure(e.toString()));
    }
  }
}