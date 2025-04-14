import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kacchi_bari_admin_dashboard/core/constants/color_constants.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_model.dart';
import 'package:super_banners/super_banners.dart';

import '../../../../core/common/textform_field.dart';
import '../bloc/staff_bloc.dart';
import '../bloc/staff_event.dart';
import '../bloc/staff_state.dart';

class StaffGridItem extends StatelessWidget {
  final StaffModel staffModel;

  const StaffGridItem({
    super.key,
    required this.staffModel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      return InkWell(
        onTap: () {
          context.go('/staff/${staffModel.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Card(
              color: ColorConstants.cardBackgroundColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        staffModel.staffImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: const Icon(Icons.person,
                                size: 50, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            staffModel.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.09,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            staffModel.designation,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: width * 0.06,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.phone,
                                  size: width * 0.06, color: Colors.green),
                              Text(
                                staffModel.phone,
                                style: TextStyle(
                                  fontSize: width * 0.06,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.attach_money,
                                  size: width * 0.06, color: Colors.orange),
                              Text(
                                "${staffModel.basicSalary} Tk",
                                style: TextStyle(
                                  fontSize: width * 0.06,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.calendar_today,
                                  size: width * 0.06, color: Colors.blue),
                              Text(
                                DateFormat.yMMMd()
                                    .format(staffModel.joiningDate),
                                style: TextStyle(
                                  fontSize: width * 0.06,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (staffModel.status == true)
              Align(
                alignment: Alignment.topRight,
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                  onSelected: (String value) {
                    if (value == 'edit') {
                      context.go('/staff/edit/${staffModel.id}/');
                    } else if (value == 'delete') {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: const Text("Delete "),
                                    content: BlocConsumer<StaffBloc,
                                        StaffState>(
                                      listener: (context, state) {
                                        if (state is StaffDeleteSuccess) {
                                          ElegantNotification.success(
                                            title: const Text(
                                              "Success",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            description: Text(
                                              state.message,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              maxLines: 1,
                                            ),
                                            width: 300,
                                            height: 100,
                                          ).show(context);
                                          Navigator.pop(context);
                                        } else
                                        if (state is StaffDeleteFailure) {
                                          ElegantNotification.error(
                                            title: const Text(
                                              "Error",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            description: Text(
                                              state.error,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            width: 300,
                                            height: 100,
                                          ).show(context);
                                          Navigator.pop(context);
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state is StaffDeleteLoading) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return const Text(
                                            "Are you sure you want to delete this Staff?");
                                      },
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<StaffBloc>()
                                              .add(
                                              DeleteStaffEvent(staffModel.id));
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  );
                                });
                          });
                    } else if (value == 'copyProfile') {
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController _joiningDateController =
                          TextEditingController();
                          TextEditingController _basicSalaryController =
                          TextEditingController();
                           GlobalKey <FormState> _formKey = GlobalKey<FormState>();

                           String? joiningDate;
                          return AlertDialog(
                            title: const Text("Copy Profile"),
                            content: StatefulBuilder(
                              builder: (context, setState) {
                                return BlocConsumer<StaffBloc, StaffState>(
                                  listener: (context, state) {
                                    if (state is StaffCopySuccess) {
                                      ElegantNotification.success(
                                        title: const Text(
                                          "Success",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        description: const Text(
                                          "Profile Copied Successfully",
                                          style: TextStyle(
                                              color: Colors.black),
                                          maxLines: 1,
                                        ),
                                        width: 300,
                                        height: 100,
                                      ).show(context);
                                      Navigator.pop(context);
                                    } else if (state is StaffCopyFailure) {
                                      ElegantNotification.error(
                                        title: const Text(
                                          "Error",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        description: Text(
                                          state.error,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        width: 300,
                                        height: 100,
                                      ).show(context);
                                      Navigator.pop(context);
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is StaffCopyLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CTextFormField(
                                            validatorText:
                                            "Please enter joining date",
                                            textEditingController:
                                            _joiningDateController,
                                            labelText: "Joining Date",
                                            readOnly: true,
                                            onTap: () async {
                                              await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now(),
                                              ).then((selectedDate) {
                                                if (selectedDate != null) {
                                                  _joiningDateController.text =
                                                      DateFormat.yMMMd()
                                                          .format(selectedDate);
                                                   joiningDate = selectedDate.toUtc().toIso8601String();
                                                }
                                              });
                                            },
                                          ),
                                          CTextFormField(
                                            validatorText:
                                            "Please enter basic salary",
                                            textEditingController:
                                            _basicSalaryController,
                                            labelText: "Basic Salary",
                                            onChanged: (value) {},
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel")),
                              TextButton(
                                  onPressed: () {
                                   if(_formKey.currentState!.validate()){
                                     context
                                         .read<StaffBloc>()
                                         .add(CopyStaffEvent(
                                       basicSalary: int.tryParse(
                                           _basicSalaryController.text)!,
                                       joiningDate:joiningDate!, staffId:staffModel.id,));
                                   }

                                    },
                                  child: Text(
                                    "Copy",
                                    style: TextStyle(
                                        color: ColorConstants.primaryColor),
                                  ))
                            ],
                          );
                        },
                      );
                    }
                  },
                  offset: const Offset(-100, 0),
                  itemBuilder: (BuildContext context) =>
                  [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                    const PopupMenuItem(
                      value: 'copyProfile',
                      child: Text('Copy Profile'),
                    ),
                  ],
                ),
              ),
            if (staffModel.status == false)
              const CornerBanner(
                bannerPosition: CornerBannerPosition.topLeft,
                bannerColor: ColorConstants.primaryColor,
                child: Text("Archived"),
              )
          ],
        ),
      );
    });
  }
}
