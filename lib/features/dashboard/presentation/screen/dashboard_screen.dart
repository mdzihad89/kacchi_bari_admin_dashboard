import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kacchi_bari_admin_dashboard/core/common/drop_down_form_field.dart';
import 'package:kacchi_bari_admin_dashboard/features/branch/data/model/branch_dropdown_item.dart';
import 'package:kacchi_bari_admin_dashboard/features/branch/data/model/branch_model.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../branch/presentation/bloc/branch_bloc.dart';
import '../../../branch/presentation/bloc/branch_event.dart';
import '../../../branch/presentation/bloc/branch_state.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  BranchDropdownItem? _selectedBranch;
  TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<BranchBloc>().add(FetchBranchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  BlocConsumer<BranchBloc, BranchState>(
      listener: (context, state) {
        // if(state is BranchFetchSuccess){
        //   _selectedBranch = BranchDropdownItem(id: state.branches.first.id, name: state.branches.first.name);
        //   context.read<DashboardBloc>().add(FetchDashboardEvent(branchId: state.branches.first.id, date: DateTime.now().toIso8601String()));
        // }
      },
      builder: (context, state) {
        if (state is BranchFetchSuccess) {
          return Column(
            children: [
              SizedBox(
                height: 60,
                child:  Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Dashboard"),
                      const Spacer(),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: _dateController,
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
                            hintText: "Select Date",
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  _dateController.text = DateFormat.yMd().format(selectedDate);

                                }
                              });
                            },
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select Date";
                            }
                            return null;
                          },

                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 200,
                        child: DropdownButtonFormField<BranchDropdownItem>(
                          dropdownColor: ColorConstants.cardBackgroundColor,
                          selectedItemBuilder: (BuildContext context) {
                            return state.branches.map((branch) {
                              return Text(branch.name.toString(),
                                style:  Theme.of(context).textTheme.bodyMedium,
                              );
                            }).toList();
                          },
                          items: state.branches.map((BranchModel branch) {
                            return DropdownMenuItem<BranchDropdownItem>(
                              value:  BranchDropdownItem(id: branch.id, name: branch.name),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    branch.name.toString(),
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  )
                              ),
                            );
                          }).toList(),
                          value: _selectedBranch,
                          onChanged: ( branch) {
                            setState(() {
                              _selectedBranch = branch;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Please select Branch";
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
                          ),
                          padding: const EdgeInsets.all(0),
                          hint: Text("Select Branch", style: Theme.of(context).textTheme.bodyMedium,),

                        ),
                      ),
                      const SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {

                            context.read<DashboardBloc>().add(FetchDashboardEvent(branchId: _selectedBranch!.id, date: _dateController.text));

                          }
                        },

                        style: ElevatedButton.styleFrom(backgroundColor: ColorConstants.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          fixedSize: const Size(120, 45),
                        ),
                        child: Text(
                          "Submit",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: Row(
                  spacing: 30,
                  children: [
                    Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: ColorConstants. primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:  const EdgeInsets.all(20),
                        alignment: Alignment.center,
                        child:BlocConsumer<DashboardBloc, DashboardState>(
                          listener: (context, dashboardState) {
                          },
                          builder: (context, dashboardState) {
                            if (dashboardState is DashboardLoaded) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Total Sell", style: Theme.of(context).textTheme.bodyLarge,),
                                  const SizedBox(height: 10,),
                                  Text("${dashboardState.totalNetPayableAmount} TK", style: Theme.of(context).textTheme.bodyLarge,),
                                ],
                              );
                            } else if (dashboardState is DashboardLoading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (dashboardState is DashboardFailure) {
                              return Text(dashboardState.error, style: const TextStyle(color: Colors.red), maxLines: 1, overflow: TextOverflow.ellipsis,);
                            } else {
                              return Container();
                            }
                          },
                        )
                    ),
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: ColorConstants. primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:  const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      // child: Column(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   mainAxisAlignment:  MainAxisAlignment.center,
                      //   children: [
                      //     Text("Total Order", style: Theme.of(context).textTheme.bodyLarge,),
                      //     const SizedBox(height: 10,),
                      //     Text("00000", style: Theme.of(context).textTheme.bodyLarge,),
                      //   ],
                      // ),
                    ),

                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: ColorConstants. primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],

                ),
              )
            ],
          );
        } else if (state is BranchFetchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BranchFetchFailure) {
          return  Text(state.error, style: const TextStyle(color: Colors.red),maxLines: 1,overflow: TextOverflow.ellipsis,);
        } else {
          return Container();
        }
      },
    );
  }
}
