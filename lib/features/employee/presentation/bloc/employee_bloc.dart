import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/emplyee_repository.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository employeeRepository;
  EmployeeBloc({required this.employeeRepository}) : super(EmployeeInitial()) {
    on<AddEmployeeEvent>(_onAddEmployee);
    on<FetchEmployeeEvent>(_onFetchEmployee);
  }

  Future<void> _onFetchEmployee(FetchEmployeeEvent event, Emitter<EmployeeState> emit) async {
    emit(EmployeeFetchLoading());
    // final result = await employeeRepository.getAllEmployee(event.page);
    final result = await employeeRepository.getAllEmployee();
    result.fold(
          (failure) => emit(EmployeeFetchFailure(failure.message)),
          (employeeList) => emit(EmployeeFetchSuccess(employeeList)),
    );


  }


  Future<void> _onAddEmployee(AddEmployeeEvent event, Emitter<EmployeeState> emit) async {
    emit(EmployeeAddLoading());
    final result = await employeeRepository.addEmployee(event.addEmployeeRequestDTO);

    result.fold(
          (failure) => emit(EmployeeAddFailure(failure.message)),
          (message) {
            emit(EmployeeAddSuccess(message));
            add(FetchEmployeeEvent());
          },
    );
  }

}