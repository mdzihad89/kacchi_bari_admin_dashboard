import 'dart:async';
import 'dart:developer';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kacchi_bari_admin_dashboard/core/app/app_helper.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/presentation/bloc/staff_bloc.dart';
import '../../../../core/common/textform_field.dart';
import '../../../../core/constants/color_constants.dart';
import '../../data/model/staff_add_leave_dto.dart';
import '../../data/model/staff_salary_payment_dto.dart';
import '../../data/model/staff_salary_payment_model.dart';
import '../../data/model/staff_salary_report_dto.dart';
import '../bloc/staff_event.dart';
import '../bloc/staff_salary_payment/staff_salary_payemnt_event.dart';
import '../bloc/staff_salary_payment/staff_salary_payment_bloc.dart';
import '../bloc/staff_salary_payment/staff_salary_payment_state.dart';

class StaffDetailsScreen extends StatefulWidget {
  final String staffId;

  const StaffDetailsScreen({super.key, required this.staffId});

  @override
  State<StaffDetailsScreen> createState() => _StaffDetailsScreenState();
}

class _StaffDetailsScreenState extends State<StaffDetailsScreen> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _leaveDateController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController _exitDateController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _leaveFormKey = GlobalKey<FormState>();
  List<StaffSalaryPaymentModel> _filterStaffPaymentList = [];
  String? paymentDate;
  Timer? _debounce;
  DateTime? salaryPayStartDate;
  StaffSalaryPaymentModel? _selectedStaffSalaryPaymentModel;
  String? _exitDate;
  bool notFoundClick = false;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _filterStaffPaymentList = context
            .read<StaffSalaryPaymentBloc>()
            .staffSalaryPaymentList
            .where((staffSalaryPayment) {
          return staffSalaryPayment.payAmount
              .toString()
              .contains(query.toLowerCase());
        }).toList();
      });
    });
  }

  @override
  void initState() {
    context.read<StaffSalaryPaymentBloc>().add(FetchSingleStaffEvent(staffId: widget.staffId));
    super.initState();
  }

  List<String> leaveDays = [];
  bool pdfGenerateLoading = false;

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  GlobalKey attachmentKey = GlobalKey();
  GlobalKey dpKey = GlobalKey();

  List<DateTime> leaveDates = [];
  List<StaffSalaryPaymentModel> staffSalaryPaymentList = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
                flex: 5,
                child: BlocBuilder<StaffSalaryPaymentBloc,
                    StaffSalaryPaymentState>(
                  buildWhen: (previous, current) {
                    return current is StaffFetchSingleSuccess ||
                        current is StaffFetchSingleLoading ||
                        current is StaffFetchSingleSuccess ||
                        current is StaffFetchSingleFailure;
                  },
                  builder: (context, state) {
                    if (state is StaffFetchSingleLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is StaffFetchSingleFailure) {
                      return Center(
                        child: Text(
                          state.error,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    } else if (state is StaffFetchSingleSuccess) {
                      context.read<StaffSalaryPaymentBloc>().add(
                          GetAllStaffSalaryPaymentByStaffId(
                              staffId: widget.staffId));
                      leaveDates = state.staff.leaveDays ?? [];

                      final staffModel = state.staff;
                      salaryPayStartDate = state.staff.joiningDate;

                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  InkWell(
                                    key: dpKey,
                                    onTap: () {
                                      _scaleDialog(
                                          staffModel.staffImage, dpKey);
                                    },
                                    child: Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              staffModel.staffImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Id : ${staffModel.icId}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Name : ${staffModel.name}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Father Name : ${staffModel.fatherName}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Guardian Number : ${staffModel.guardianNumber}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Number : ${staffModel.phone}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Address : ${staffModel.address}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Nid/Bc : ${staffModel.nidOrBirthCertificateNumber}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Join Date : ${DateFormat.yMMMd().format(staffModel.joiningDate)}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Salary : ${staffModel.basicSalary} Tk",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Designation : ${staffModel.designation}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Attachment :  ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      InkWell(
                                        key: attachmentKey,
                                        onTap: () {
                                          _scaleDialog(
                                              staffModel.staffAttachment,
                                              attachmentKey);
                                        },
                                        borderRadius: BorderRadius.circular(50),
                                        child: Icon(Icons.remove_red_eye),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Exit Date : ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        staffModel.exitDate == null &&
                                                notFoundClick == false
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    notFoundClick = true;
                                                  });
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Text(
                                                  "Not Found",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              )
                                            : notFoundClick == true &&
                                                    staffModel.exitDate == null
                                                ? BlocConsumer<
                                                    StaffSalaryPaymentBloc,
                                                    StaffSalaryPaymentState>(
                                                    listener: (context, state) {
                                                      if (state
                                                          is ExitDateUpdateSuccess) {
                                                        ElegantNotification
                                                            .success(
                                                          title: const Text(
                                                            "Success",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          description: Text(
                                                            state.message,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                            maxLines: 1,
                                                          ),
                                                          width: 300,
                                                          height: 100,
                                                        ).show(context);
                                                        _exitDateController
                                                            .clear();
                                                        _exitDate = null;
                                                        context
                                                            .read<
                                                                StaffSalaryPaymentBloc>()
                                                            .add(FetchSingleStaffEvent(
                                                                staffId: widget
                                                                    .staffId));
                                                        context
                                                            .read<StaffBloc>()
                                                            .add(
                                                                FetchStaffEvent());
                                                      } else if (state
                                                          is ExitDateUpdateFailure) {
                                                        ElegantNotification
                                                            .error(
                                                          title: const Text(
                                                            "Error",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          description: Text(
                                                            state.error,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          width: 300,
                                                          height: 100,
                                                        ).show(context);
                                                      }
                                                    },
                                                    builder: (context, state) {
                                                      if (state
                                                          is ExitDateUpdateLoading) {
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.white,
                                                          ),
                                                        );
                                                      }
                                                      return Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 150,
                                                            child: TextField(
                                                                decoration:
                                                                    InputDecoration(
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                            color:
                                                                                ColorConstants.primaryColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                            color:
                                                                                ColorConstants.primaryColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  errorBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                            color:
                                                                                Colors.red),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                            color:
                                                                                ColorConstants.primaryColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  hintText:
                                                                      "Exit Date",
                                                                  hintStyle: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium,
                                                                ),
                                                                controller:
                                                                    _exitDateController,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium,
                                                                readOnly: true,
                                                                maxLines: 1,
                                                                onTap:
                                                                    () async {
                                                                  await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        DateTime
                                                                            .now(),
                                                                    firstDate: salaryPayStartDate ??
                                                                        DateTime(
                                                                            2025),
                                                                    lastDate:
                                                                        DateTime
                                                                            .now(),
                                                                  ).then(
                                                                      (selectedDate) {
                                                                    if (selectedDate !=
                                                                        null) {
                                                                      _exitDateController
                                                                          .text = DateFormat
                                                                              .yMMMd()
                                                                          .format(
                                                                              selectedDate);
                                                                      _exitDate = selectedDate
                                                                          .toUtc()
                                                                          .toIso8601String();
                                                                    }
                                                                  });
                                                                }),
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                if (_exitDateController
                                                                    .text
                                                                    .isEmpty) {
                                                                  ElegantNotification
                                                                      .error(
                                                                    title:
                                                                        const Text(
                                                                      "Error",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    description:
                                                                        const Text(
                                                                      "Exit date is required",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                      maxLines:
                                                                          1,
                                                                    ),
                                                                    width: 300,
                                                                    height: 100,
                                                                  ).show(
                                                                      context);
                                                                } else {
                                                                  context
                                                                      .read<
                                                                          StaffSalaryPaymentBloc>()
                                                                      .add(
                                                                        ExitDateUpdateEvent(
                                                                            staffId:
                                                                                widget.staffId,
                                                                            exitDate: _exitDate!),
                                                                      );
                                                                }
                                                              },
                                                              icon: Icon(
                                                                Icons.add,
                                                                color: ColorConstants
                                                                    .primaryColor,
                                                              ))
                                                        ],
                                                      );
                                                    },
                                                  )
                                                : Text(
                                                    DateFormat.yMMMd().format(
                                                        staffModel.exitDate!),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                spacing: 10,
                                children: [
                                  staffModel.status == true
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 10,
                                          children: [
                                            Expanded(
                                              child: Form(
                                                key: _leaveFormKey,
                                                child: CTextFormField(
                                                  labelText: "Leave Date",
                                                  validatorText:
                                                      "Date is required",
                                                  textEditingController:
                                                      _leaveDateController,
                                                  readOnly: true,
                                                  onTap: () async {
                                                    await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate:
                                                          salaryPayStartDate ??
                                                              DateTime(2025),
                                                      lastDate: DateTime.now(),
                                                    ).then((selectedDate) {
                                                      if (selectedDate !=
                                                          null) {
                                                        _leaveDateController
                                                            .text = DateFormat
                                                                .yMMMd()
                                                            .format(
                                                                selectedDate);
                                                        leaveDays.add(selectedDate
                                                            .toUtc()
                                                            .toIso8601String());
                                                        // log(paymentDate.toString());
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: BlocConsumer<
                                                  StaffSalaryPaymentBloc,
                                                  StaffSalaryPaymentState>(
                                                listener: (context, state) {
                                                  if (state
                                                      is AddLeaveEventSuccess) {
                                                    context
                                                        .read<
                                                            StaffSalaryPaymentBloc>()
                                                        .add(
                                                            FetchSingleStaffEvent(
                                                                staffId: widget
                                                                    .staffId));
                                                    ElegantNotification.success(
                                                      title: const Text(
                                                        "Success",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      description: Text(
                                                        state.message,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        maxLines: 1,
                                                      ),
                                                      width: 300,
                                                      height: 100,
                                                    ).show(context);

                                                    _leaveDateController
                                                        .clear();
                                                    leaveDays.clear();
                                                  } else if (state
                                                      is AddLeaveEventFailure) {
                                                    ElegantNotification.error(
                                                      title: const Text(
                                                        "Error",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      description: Text(
                                                        state.error,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      width: 300,
                                                      height: 100,
                                                    ).show(context);

                                                    _leaveDateController
                                                        .clear();
                                                    leaveDays.clear();
                                                  }
                                                },
                                                builder: (context, state) {
                                                  if (state
                                                      is AddLeaveEventLoading) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  }
                                                  return FloatingActionButton(
                                                    heroTag: "leave",
                                                    onPressed: () {
                                                      if (_leaveFormKey
                                                          .currentState!
                                                          .validate()) {
                                                        AddLeaveDto
                                                            addLeaveDto =
                                                            AddLeaveDto(
                                                          staffId:
                                                              widget.staffId,
                                                          leaveDays: leaveDays,
                                                        );
                                                        context
                                                            .read<
                                                                StaffSalaryPaymentBloc>()
                                                            .add(AddLeaveEvent(
                                                                addLeaveDto:
                                                                    addLeaveDto));
                                                      }
                                                    },
                                                    backgroundColor:
                                                        ColorConstants
                                                            .primaryColor,
                                                    child: const Icon(Icons.add,
                                                        color: Colors.white),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                  Expanded(
                                    flex: 2,
                                    child: ListView.builder(
                                      itemCount: staffModel.leaveDays!.length,
                                      itemBuilder: (context, index) {
                                        final leaveDates = DateFormat.yMMMd()
                                            .format(
                                                staffModel.leaveDays![index]);
                                        return Slidable(
                                          startActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            extentRatio: 0.50,
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Remove Day"),
                                                          content: const Text(
                                                              "Are you sure you want to remove this day?"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  "Cancel"),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                context
                                                                    .read<
                                                                        StaffSalaryPaymentBloc>()
                                                                    .add(
                                                                      RemoveLeaveEvent(
                                                                          staffId: widget
                                                                              .staffId,
                                                                          leaveDate: staffModel
                                                                              .leaveDays![index]
                                                                              .toUtc()
                                                                              .toIso8601String()),
                                                                    );
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  "Remove"),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                icon: Icons.delete,
                                                label: 'Remove',
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              leaveDates,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Report",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                      InkWell(
                                        child: Icon(Icons.remove_red_eye),
                                        borderRadius: BorderRadius.circular(50),
                                        onTap: () {
                                          StaffSalaryReportDTO
                                              staffSalaryReportDTO =
                                              StaffSalaryReportDTO(
                                            staffId: widget.staffId,
                                            reportDate: DateTime.now()
                                                .toUtc()
                                                .toIso8601String(),
                                          );
                                          context
                                              .read<StaffSalaryPaymentBloc>()
                                              .add(FetchStaffSalaryReport(
                                                  staffSalaryReportDTO:
                                                      staffSalaryReportDTO));
                                        },
                                      )
                                    ],
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: BlocBuilder<StaffSalaryPaymentBloc,
                                          StaffSalaryPaymentState>(
                                        buildWhen: (previous, current) {
                                          return current
                                                  is StaffSalaryReportLoading ||
                                              current
                                                  is StaffSalaryReportSuccess ||
                                              current
                                                  is StaffSalaryReportFailure;
                                        },
                                        builder: (context, state) {
                                          if (state
                                              is StaffSalaryReportLoading) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (state
                                              is StaffSalaryReportFailure) {
                                            return Center(
                                              child: Text(
                                                state.error,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            );
                                          } else if (state
                                              is StaffSalaryReportSuccess) {
                                            return Column(
                                              children: [
                                                Row(
                                                  spacing: 10,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        spacing: 10,
                                                        children: [
                                                          Text(
                                                            "Report Date : ${DateFormat.yMMMd().format(state.staffSalaryReport.reportDate)}",
                                                          ),
                                                          Text(
                                                              "Total Days : ${state.staffSalaryReport.totalDays} Days"),
                                                          Text(
                                                              "Leave Days : ${state.staffSalaryReport.leaveDays} Days"),
                                                          Text(
                                                              "WorkDays : ${state.staffSalaryReport.workedDays} Days"),
                                                          Text(
                                                            "Status : ${state.staffSalaryReport.status}",
                                                            style: TextStyle(
                                                                color: state.staffSalaryReport
                                                                            .status ==
                                                                        "Paid"
                                                                    ? Colors
                                                                        .green
                                                                    : state.staffSalaryReport.status ==
                                                                            "Due"
                                                                        ? Colors
                                                                            .red
                                                                        : ColorConstants
                                                                            .primaryColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                      spacing: 10,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "Per Day Salary : ${state.staffSalaryReport.perDaySalary} Tk"),
                                                        Text(
                                                            "Payable: ${state.staffSalaryReport.payableAmount} Tk"),
                                                        Text(
                                                            "Total Paid : ${state.staffSalaryReport.totalPaid} Tk"),
                                                        Text(
                                                          "Net Amount : ${state.staffSalaryReport.netAmount} Tk",
                                                        ),
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                                SizedBox(height: 20,),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          ColorConstants
                                                              .primaryColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      fixedSize: Size(180, 40),
                                                    ),
                                                    onPressed: () async {
                                                      context
                                                          .read<
                                                              StaffSalaryPaymentBloc>()
                                                          .add(
                                                              DownloadSalaryReportEvent(
                                                            leaveDates:
                                                                leaveDates,
                                                            staffSalaryPaymentList:
                                                                staffSalaryPaymentList,
                                                            staffSalaryReportModel:
                                                                state
                                                                    .staffSalaryReport,
                                                          ));
                                                    },
                                                    child: BlocConsumer<
                                                        StaffSalaryPaymentBloc,
                                                        StaffSalaryPaymentState>(
                                                      listener: (context, state) {

                                                        if( state is StaffSalaryReportDownloadSuccess) {
                                                          ElegantNotification
                                                              .success(
                                                            title: const Text(
                                                              "Success",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            description:
                                                            const Text(
                                                              "Report Downloaded",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              maxLines: 1,
                                                            ),
                                                            width: 300,
                                                            height: 100,
                                                          ).show(context);
                                                        }

                                                        if (state
                                                            is StaffSalaryReportDownloadFailure) {
                                                          ElegantNotification
                                                              .error(
                                                            title: const Text(
                                                              "Error",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            description: Text(
                                                              state.error,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            width: 300,
                                                            height: 100,
                                                          ).show(context);
                                                        }

                                                      },
                                                      builder: (context, state) {

                                                        if(state is StaffSalaryReportDownloadLoading){
                                                           return const Center(child:  CircularProgressIndicator(
                                                             color: Colors.white,
                                                           ),);
                                                        }
                                                        return Text("Download Report");
                                                      },
                                                    ))
                                              ],
                                            );
                                          }

                                          return const SizedBox();
                                        },
                                      ))
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                )),
            Expanded(
                flex: 3,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CTextFormField(
                              labelText: "Date",
                              validatorText: "Date is required",
                              textEditingController: _dateController,
                              readOnly: true,
                              onTap: () async {
                                await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate:
                                      salaryPayStartDate ?? DateTime(2025),
                                  lastDate: DateTime.now(),
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    _dateController.text =
                                        DateFormat.yMMMd().format(selectedDate);
                                    paymentDate = selectedDate.toUtc().toIso8601String();
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CTextFormField(
                              labelText: "Amount",
                              validatorText: "Amount is required",
                              textEditingController: _amountController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 50,
                            child: BlocConsumer<StaffSalaryPaymentBloc,
                                StaffSalaryPaymentState>(
                              listener: (context, state) {
                                if (state
                                    is StaffSalaryPaymentOperationSuccess) {
                                  ElegantNotification.success(
                                    title: const Text(
                                      "Success",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    description: const Text(
                                      "Operation Successful",
                                      style: TextStyle(color: Colors.black),
                                      maxLines: 1,
                                    ),
                                    width: 300,
                                    height: 100,
                                  ).show(context);
                                  _dateController.clear();
                                  _amountController.clear();
                                  paymentDate = null;
                                  _selectedStaffSalaryPaymentModel = null;
                                } else if (state
                                    is StaffSalaryPaymentOperationError) {
                                  ElegantNotification.error(
                                    title: const Text(
                                      "Error",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    description: Text(
                                      state.message,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    width: 300,
                                    height: 100,
                                  ).show(context);
                                }
                              },
                              builder: (context, state) {
                                return FloatingActionButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (_selectedStaffSalaryPaymentModel != null) {
                                        StaffSalaryPaymentDto staffSalaryPaymentDto =
                                            StaffSalaryPaymentDto(
                                          staffId: widget.staffId,
                                          payAmount: int.parse(_amountController.text),
                                          paymentDate: paymentDate!,
                                        );
                                        context
                                            .read<StaffSalaryPaymentBloc>()
                                            .add(
                                              UpdateStaffSalaryPayment(
                                                  staffSalaryId:
                                                      _selectedStaffSalaryPaymentModel!
                                                          .id,
                                                  staffSalaryPaymentDto:
                                                      staffSalaryPaymentDto),
                                            );
                                      } else {
                                        StaffSalaryPaymentDto
                                            staffSalaryPaymentDto =
                                            StaffSalaryPaymentDto(
                                          staffId: widget.staffId,
                                          payAmount:
                                              int.parse(_amountController.text),
                                          paymentDate: paymentDate!,
                                        );
                                        context
                                            .read<StaffSalaryPaymentBloc>()
                                            .add(AddStaffSalaryPayment(
                                                staffSalaryPaymentDto:
                                                    staffSalaryPaymentDto));
                                      }
                                    }
                                  },
                                  backgroundColor: ColorConstants.primaryColor,
                                  child: state
                                          is StaffSalaryPaymentOperationLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.add,
                                          color: Colors.white),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      maxLines: 1,
                      controller: searchController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: ColorConstants.primaryColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: ColorConstants.primaryColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: ColorConstants.primaryColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Search here ..."),
                      style: Theme.of(context).textTheme.bodyMedium,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        _onSearchChanged(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                        child: BlocBuilder<StaffSalaryPaymentBloc,
                            StaffSalaryPaymentState>(
                      buildWhen: (previous, current) {
                        return current is StaffSalaryPaymentLoaded;
                      },
                      builder: (context, state) {
                        if (state is StaffSalaryPaymentLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is StaffSalaryPaymentError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        } else if (state is StaffSalaryPaymentLoaded) {
                          final staffPaymentToShow =
                              searchController.text.isEmpty
                                  ? state.staffSalaryPaymentList
                                  : _filterStaffPaymentList;
                          staffSalaryPaymentList = state.staffSalaryPaymentList;

                          if (staffPaymentToShow.isEmpty) {
                            return Center(
                              child: Text(
                                "No payment found",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          } else {
                            return ListView.builder(
                                itemCount: staffPaymentToShow.length,
                                itemBuilder: (context, index) {
                                  final staffPaymentModel =
                                      staffPaymentToShow[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Slidable(
                                      startActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        extentRatio: 0.50,
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Edit Contact"),
                                                    content: const Text(
                                                        "Are you sure you want to edit this contact?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _selectedStaffSalaryPaymentModel =
                                                                staffPaymentModel;
                                                            _dateController
                                                                .text = DateFormat
                                                                    .yMMMd()
                                                                .format(staffPaymentModel
                                                                    .paymentDate);
                                                            paymentDate =
                                                                staffPaymentModel
                                                                    .paymentDate
                                                                    .toIso8601String();
                                                            _amountController
                                                                    .text =
                                                                staffPaymentModel
                                                                    .payAmount
                                                                    .toString();
                                                          });

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text("Edit"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            icon: Icons.edit,
                                            label: 'Edit',
                                          ),
                                          SlidableAction(
                                            onPressed: (context) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Delete Contact"),
                                                      content: const Text(
                                                          "Are you sure you want to delete this contact?"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Cancel"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            context
                                                                .read<
                                                                    StaffSalaryPaymentBloc>()
                                                                .add(DeleteStaffSalaryPayment(
                                                                    staffSalaryId:
                                                                        staffPaymentModel
                                                                            .id));
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Delete"),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Text(
                                            "${staffPaymentModel.payAmount.toString()} Tk",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        subtitle: Text(
                                          DateFormat.yMMMd().format(
                                              staffPaymentModel.paymentDate),
                                        ),
                                        tileColor:
                                            ColorConstants.cardBackgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      //   child: StaffGridItem(
                                    ),
                                  );
                                });
                          }
                        }
                        return const SizedBox();
                      },
                    ))
                  ],
                ))
          ],
        ),
        Positioned(
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: ColorConstants.primaryColor,
            ),
            onPressed: () {
              context.go('/staff');
            },
          ),
        ),
      ],
    );
  }

  Widget dialogBox(BuildContext context, String imageUrl) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero, // Remove padding
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Dialog(
        backgroundColor: Colors.transparent, // Remove default dialog background
        insetPadding: EdgeInsets.zero, // Fullscreen
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scaleDialog(String imageUrl, GlobalKey widgetKey) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        RenderBox? boxs =
            widgetKey.currentContext!.findRenderObject() as RenderBox?;
        Offset posit = boxs!.localToGlobal(Offset.zero);

        return Transform.scale(
            scale: curve,
            child: dialogBox(context, imageUrl),
            origin: posit,
            alignment: AlignmentGeometry.lerp(null, null, 2));
      },
      transitionDuration: const Duration(milliseconds: 900),
    );
  }
}
