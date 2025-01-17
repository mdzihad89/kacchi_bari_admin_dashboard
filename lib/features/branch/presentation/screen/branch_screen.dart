import 'dart:io';
import 'dart:typed_data';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kacchi_bari_admin_dashboard/core/common/textform_field.dart';
import 'package:kacchi_bari_admin_dashboard/core/constants/color_constants.dart';
import 'package:kacchi_bari_admin_dashboard/core/common/photo_card.dart';
import 'package:kacchi_bari_admin_dashboard/features/branch/data/model/branch_add_request_dto.dart';
import 'package:kacchi_bari_admin_dashboard/features/branch/presentation/bloc/branch_state.dart';
import 'package:kacchi_bari_admin_dashboard/features/employee/data/model/employee_model.dart';
import 'package:kacchi_bari_admin_dashboard/features/employee/presentation/bloc/employee_event.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../employee/data/model/employee_dropdown_item.dart';
import '../../../employee/presentation/bloc/employee_bloc.dart';
import '../../../employee/presentation/bloc/employee_state.dart';
import '../bloc/branch_bloc.dart';
import '../bloc/branch_event.dart';

class BranchScreen extends StatefulWidget {
  const BranchScreen({super.key});

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {


  @override
  void initState() {
    context.read<BranchBloc>().add(FetchBranchEvent());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Brances",
              style: GoogleFonts.inter(fontSize: 24, color: Colors.white),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final _formKey = GlobalKey<FormState>();
                    TextEditingController _branchNameController =
                        TextEditingController();
                    TextEditingController _branchAddressController =
                        TextEditingController();

                    TextEditingController _branchPhoneController =
                    TextEditingController();

                    Uint8List? imageBytes;
                    int? tableNumber;
                    String? managerId;
                    String? managerName;
                    return StatefulBuilder(builder: (context, setState) {
                      context.read<EmployeeBloc>().add(FetchEmployeeEvent());
                      return AlertDialog(
                        backgroundColor: ColorConstants.cardBackgroundColor,
                        title: Center(
                            child: Text(
                          "Branch",
                          style: Theme.of(context).textTheme.bodyMedium,
                        )),
                        content: BlocConsumer<BranchBloc, BranchState>(
                          builder: (context,state) {

                            if (state is BranchAddLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Container(
                                width: MediaQuery.sizeOf(context).width * 0.4,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: ColorConstants.backgroundColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Form(
                                  key: _formKey,
                                    child: ListView(
                                  scrollDirection: Axis.vertical,
                                  padding: const EdgeInsets.only(right: 15),
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        PhotoCard(
                                          levelText: "Branch",
                                          onImagePicked: (value) {
                                            imageBytes = value!;
                                          },
                                        ),
                                      ],
                                    ),
                                    CTextFormField(
                                        labelText: "Branch Name",
                                        validatorText: "Branch Name is required",
                                        textEditingController:
                                            _branchNameController),
                                    CTextFormField(
                                        labelText: "Branch Address",
                                        validatorText: "Branch Address is required",
                                        textEditingController: _branchAddressController),
                                    CTextFormField(
                                        labelText: "Branch Phone Number",
                                        validatorText: "Branch Phone Number is required",
                                        textEditingController: _branchPhoneController),
                                    BlocBuilder<EmployeeBloc, EmployeeState>(
                                      builder: (context, state) {
                                        if (state is EmployeeFetchLoading) {
                                          return Center(child: const CircularProgressIndicator());
                                        } else if (state is EmployeeFetchFailure) {
                                          return Text('Error: ${state.error}');
                                        } else if (state is EmployeeFetchSuccess) {

                                          return DropdownButtonFormField<EmployeeDropdownItem>(
                                            dropdownColor: ColorConstants.cardBackgroundColor,
                                              selectedItemBuilder: (BuildContext context) {
                                                return state.employees
                                                    .where((employee) => employee.role == 'manager')
                                                .map((employee) {
                                                  return Text(employee.name.toString(),
                                                  style:  Theme.of(context).textTheme.bodyMedium,
                                                  );
                                                }).toList();
                                              },
                                            items: state.employees
                                                .where((employee) => employee.role == 'manager')
                                                .map((EmployeeModel employee) {
                                              return DropdownMenuItem<EmployeeDropdownItem>(
                                                value:  EmployeeDropdownItem(id: employee.id, name: employee.name),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const CircleAvatar(
                                                            radius: 20,
                                                            // backgroundImage: NetworkImage(employee.image.toString()),
                                                          ),
                                                          const SizedBox(width: 20),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                employee.name.toString(),
                                                                style: Theme.of(context).textTheme.bodySmall,
                                                              ),
                                                              Text(
                                                                employee.email.toString(),
                                                                style: Theme.of(context).textTheme.bodySmall,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: ( employee) {
                                              managerId = employee!.id;
                                              managerName = employee.name;
                                            },
                                            validator: (value) {
                                              if (value == null) {
                                                return "Please select a manager";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: ColorConstants.primaryColor),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: ColorConstants.primaryColor),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.red),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: ColorConstants.primaryColor),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              labelText: 'Select a manager',
                                              labelStyle: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Table",
                                          style:
                                              Theme.of(context).textTheme.bodyLarge,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        CustomStepper(
                                            lowerLimit: 1,
                                            upperLimit: 19,
                                            stepValue: 1,
                                            iconSize: 30,
                                            value: 1,
                                            onValueChanged: (value) {
                                              tableNumber = value;
                                            }),
                                      ],
                                    )
                                  ],
                                )));
                          },
                          listener: (BuildContext context, BranchState state) {
                            if (state is BranchAddSuccess) {
                              Navigator.pop(context);
                              ElegantNotification.success(
                                title:  const Text("Success",style: TextStyle(color: Colors.black),),
                                width: 300,
                                height: 100,
                                description:  Text(state.message,style: const TextStyle(color: Colors.black)),
                              ).show(context);
                            }
                            else if(state is BranchAddFailure){
                              ElegantNotification.error(
                                title:  const Text("Error",style: TextStyle(color: Colors.black),),
                                description:  Text(state.error,style: const TextStyle(color: Colors.black,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                width: 300,
                                height: 100,
                              ).show(context);
                            }
                          },
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    ColorConstants.cardBackgroundColor),
                            child: Text(
                              "Cancel",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if(imageBytes != null && tableNumber != null){
                                  context.read<BranchBloc>().add(
                                      AddBranchEvent(
                                        BranchAddRequestDTO(
                                          name: _branchNameController.text,
                                          address: _branchAddressController.text,
                                          imageByte: imageBytes!,
                                          managerId: managerId!,
                                          managerName: managerName!,
                                          table: tableNumber!,
                                          branchPhoneNumber: _branchPhoneController.text
                                        )

                                  ),);
                                }else if(imageBytes == null){
                                  ElegantNotification.error(
                                    title:  const Text("Error",style: TextStyle(color: Colors.black),),
                                    description:  const Text("Please Select an Image",style: TextStyle(color: Colors.black,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                    width: 300,
                                    height: 100,
                                  ).show(context);
                                }else if(tableNumber == null) {
                                  ElegantNotification.error(
                                    title: const Text("Error",
                                      style: TextStyle(color: Colors.black),),
                                    description: const Text(
                                      "Please Select a Table Number",
                                      style: TextStyle(color: Colors.black,),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,),
                                    width: 300,
                                    height: 100,
                                  ).show(context);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.primaryColor),
                            child: Text(
                              "Create",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          )
                        ],
                      );
                    });
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
                fixedSize: Size(140, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              label: Text("Add New",
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  context.read<BranchBloc>().add(FetchBranchEvent());
                },
                icon: const Icon(
                  Icons.refresh,
                  size: 30,
                  color: Colors.white,
                ))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: BlocBuilder<BranchBloc,BranchState>(
              buildWhen: (previous, current) {
                if(current is BranchFetchSuccess || current is BranchFetchFailure || current is BranchFetchLoading){
                  return true;
                }
                return false;
              },
            builder: (context,state) {
            if(state is BranchFetchSuccess){
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorConstants.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(
                          label: Text(
                            "Image",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                      DataColumn(
                          label: Text(
                            "Name",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                      DataColumn(
                          label: Text(
                            "Manager",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                      DataColumn(
                          label: Text(
                            "Table",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                      DataColumn(
                          label: Text(
                            "Address",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                    ],
                    rows: [
                      ...state.branches.map((branch) {
                        return DataRow(cells: [
                          DataCell(
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: branch.image.isEmpty?const Icon(Icons.person):
                                Image.network(
                                  branch.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(branch.name,style: Theme.of(context).textTheme.bodySmall,)),
                          DataCell(Text(branch.managerName,style: Theme.of(context).textTheme.bodySmall,)),
                          DataCell(Text(branch.table.toString(),style: Theme.of(context).textTheme.bodySmall,)),
                          DataCell(Text(branch.address,style: Theme.of(context).textTheme.bodySmall,)),
                        ]);
                      })
                    ],
                  ),
                ),
              );
            }

            else if(state is BranchFetchLoading){
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(state is BranchFetchFailure){
              return Center(child: Text(state.error,style: Theme.of(context).textTheme.bodyMedium,));
            }else{
              return const SizedBox();
            }
            }
          ),
        )
      ],
    );
  }
}

class CustomStepper extends StatefulWidget {
  CustomStepper({
    super.key,
    required this.lowerLimit,
    required this.upperLimit,
    required this.stepValue,
    required this.iconSize,
    required this.value,
    required this.onValueChanged,
  });

  final int lowerLimit;
  final int upperLimit;
  final int stepValue;
  final double iconSize;
  int value;
  final ValueChanged<int> onValueChanged;

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedIconButton(
          icon: Icons.remove,
          color: Colors.red,
          iconSize: widget.iconSize,
          onPress: () {
            setState(() {
              widget.value = widget.value == widget.lowerLimit
                  ? widget.lowerLimit
                  : widget.value -= widget.stepValue;
              widget.onValueChanged(widget.value);
            });
          },
        ),
        Container(
          width: widget.iconSize,
          child: Text(
            '${widget.value}',
            style: TextStyle(
              fontSize: widget.iconSize * 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        RoundedIconButton(
          color: const Color(0xFF65A34A),
          icon: Icons.add,
          iconSize: widget.iconSize,
          onPress: () {
            setState(() {
              widget.value = widget.value == widget.upperLimit
                  ? widget.upperLimit
                  : widget.value += widget.stepValue;
              widget.onValueChanged(widget.value);
            });
          },
        ),
      ],
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton(
      {required this.icon,
      required this.onPress,
      required this.iconSize,
      required this.color});

  final Color color;
  final IconData icon;
  final VoidCallback onPress;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tightFor(width: iconSize, height: iconSize),
      elevation: 6.0,
      onPressed: onPress,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(iconSize * 0.2)),
      fillColor: color,
      child: Icon(
        icon,
        color: Colors.white,
        size: iconSize * 0.8,
      ),
    );
  }
}
