import 'dart:developer';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kacchi_bari_admin_dashboard/core/common/photo_card.dart';
import 'package:kacchi_bari_admin_dashboard/core/common/textform_field.dart';
import '../../../../core/constants/color_constants.dart';
import '../../data/model/add_employee_request_dto.dart';
import '../../data/model/employee_model.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {


  @override
  void initState() {
    context.read<EmployeeBloc>().add( FetchEmployeeEvent());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Employee",
              style: GoogleFonts.inter(fontSize: 24, color: Colors.white),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    String? role;
                    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                    TextEditingController _nameController = TextEditingController();
                    TextEditingController _emailController = TextEditingController();
                    TextEditingController _phoneNumberController = TextEditingController();
                    TextEditingController _passwordController = TextEditingController();
                    Uint8List? imagePath;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          backgroundColor: ColorConstants.cardBackgroundColor,
                          title: Center(
                            child: Text(
                              "Employee",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          content: BlocConsumer<EmployeeBloc, EmployeeState>(
                            builder: (context, state) {
                              if (state is EmployeeAddLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Container(
                                width: MediaQuery.sizeOf(context).width * 0.4,
                                padding: const EdgeInsets.all(20),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          PhotoCard(
                                            levelText: "Employee",
                                            onImagePicked: (value) {
                                               imagePath = value!;
                                            },
                                          ),
                                        ],
                                      ),
                                      CTextFormField(
                                        labelText: "Enter Name",
                                        validatorText: "Name can't be empty",
                                        textEditingController: _nameController,
                                      ),
                                      CTextFormField(
                                        labelText: "Enter Email",
                                        validatorText: "Email can't be empty",
                                        textEditingController: _emailController,
                                      ),
                                      CTextFormField(
                                        labelText: "Enter Phone Number",
                                        validatorText:
                                            "Phone Number can't be empty",
                                        textEditingController:
                                            _phoneNumberController,
                                      ),
                                      CTextFormField(
                                        labelText: "Enter Password",
                                        validatorText:
                                            "Password can't be empty",
                                        textEditingController:
                                            _passwordController,
                                      ),
                                      DropdownButtonFormField(
                                        value: role,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        dropdownColor: Colors.black,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants
                                                    .primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants
                                                    .primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants
                                                    .primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          labelText: "Select Role",
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return "Role can't be empty";
                                          }
                                          return null;
                                        },
                                        items: const [
                                          DropdownMenuItem(
                                            value: "manager",
                                            child: Text("Manager"),
                                          ),
                                          DropdownMenuItem(
                                            value: "waiter",
                                            child: Text("Waiter"),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            role = value as String;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            listener: (BuildContext context, EmployeeState state) {
                              if (state is EmployeeAddSuccess) {
                                Navigator.pop(context);
                                ElegantNotification.success(
                                  title:  const Text("Success",style: TextStyle(color: Colors.black),),
                                  width: 300,
                                  height: 100,
                                  description:  Text(state.message,style: const TextStyle(color: Colors.black)),
                                ).show(context);
                              }
                              else if(state is EmployeeAddFailure){
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
                                  final addEmployeeRequestDTO = AddEmployeeRequestDTO(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    mobile: _phoneNumberController.text,
                                    password: _passwordController.text,
                                    role: role!,
                                    imageByte: imagePath,
                                  );
                                  context.read<EmployeeBloc>().add(AddEmployeeEvent(addEmployeeRequestDTO));
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
                      },
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
                fixedSize: const Size(140, 40),
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
                // context.read<EmployeeBloc>().add(const FetchEmployeeEvent(1));
                 context.read<EmployeeBloc>().add( FetchEmployeeEvent());
              },
              icon: const Icon(
                Icons.refresh,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: BlocBuilder<EmployeeBloc,EmployeeState>(
            buildWhen: (previous, current) {
              if(current is EmployeeFetchSuccess || current is EmployeeFetchFailure || current is EmployeeFetchLoading){
                return true;
              }
              return false;
            },
            builder: (context,state) {
             if(state is EmployeeFetchSuccess){
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
                         DataColumn(label: Text("Image",style: Theme.of(context).textTheme.bodyMedium,)),
                         DataColumn(label: Text("Name",style: Theme.of(context).textTheme.bodyMedium,)),
                         DataColumn(label: Text("Email",style: Theme.of(context).textTheme.bodyMedium,)),
                         DataColumn(label: Text("Mobile",style: Theme.of(context).textTheme.bodyMedium,)),
                         DataColumn(label: Text("Role",style: Theme.of(context).textTheme.bodyMedium,)),
                       ],
                       rows: [
                          for(EmployeeModel employee in state.employees)
                            DataRow(
                              cells: [
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
                                      child: employee.image.isEmpty?const Icon(Icons.person):
                                      Image.network(
                                        employee.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(employee.name)),
                                DataCell(Text(employee.email)),
                                DataCell(Text(employee.mobile)),
                                DataCell(Text(employee.role)),
                              ],
                            )

                       ]
                   ),
                 )
               );
             }else if(state is EmployeeFetchLoading){
               return const Center(child: CircularProgressIndicator(),);
             }
             else if(state is EmployeeFetchFailure){
               return Center(child: Text(state.error,style: Theme.of(context).textTheme.bodyMedium,));
             }else{
               return const SizedBox();
             }
            },
          
          ),
        )
      ],
    );
  }
}

// class EmployeeDataSource extends DataTableSource{
//   int _currentPage = 1;
//   final List<EmployeeModel> _employees ;
//  final BuildContext context;
//
//   EmployeeDataSource(this._employees,this.context);
//   @override
//   DataRow? getRow(int index) {
//     if (index >= _employees.length) {
//       _currentPage++;
//       context.read<EmployeeBloc>().add(FetchEmployeeEvent(_currentPage));
//       return null;
//     }
//     final employee = _employees[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         DataCell(Text(employee.name)),
//         DataCell(Text(employee.email)),
//         DataCell(Text(employee.mobile)),
//         DataCell(Text(employee.role)),
//       ],
//     );
//   }
//   @override
//   bool get isRowCountApproximate => false;
//
//
//   @override
//   int get rowCount => _employees.length;
//
//   @override
//   int get selectedRowCount => 0;
//
// }