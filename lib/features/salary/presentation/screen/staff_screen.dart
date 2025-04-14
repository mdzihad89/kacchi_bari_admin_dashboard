import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_model.dart';

import '../../../../core/common/textform_field.dart';
import '../../../../core/constants/color_constants.dart';
import '../bloc/staff_bloc.dart';
import '../bloc/staff_event.dart';
import '../bloc/staff_state.dart';
import '../widgets/staff_grid_item.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {

  TextEditingController searchController = TextEditingController();

  bool archived = false;

  @override
  void initState() {
     context.read<StaffBloc>().add(FetchStaffEvent());
    super.initState();
  }



  Timer? _debounce;
  List<StaffModel> _filterStaffList = [];
  List<StaffModel> archivedList= [];

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        if(archived==true){
          _filterStaffList = archivedList.where((staff) {
                return staff.name.toLowerCase().contains(query.toLowerCase());
              }).toList();
        }else{
          _filterStaffList =
              context.read<StaffBloc>().staffList.where((staff) {
                return staff.name.toLowerCase().contains(query.toLowerCase());
              }).toList();
        }
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Staff",
              style: GoogleFonts.inter(fontSize: 24, color: Colors.white),
            ),
            const Spacer(),
            SizedBox(
              width: 200,
              child: TextField(
                maxLines: 1,
                controller: searchController,
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
                  hintText: "Search here ..."
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (value) {
                  _onSearchChanged(value);
                },
              ),
            ),
            const SizedBox(
              width: 20,
            ),
           if(archived==false) ElevatedButton.icon(
              onPressed: () {

                context.go('/staff/create');
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
            Switch(
              value: archived,
              onChanged: (value) {
                setState(() {
                  archived = value;
                });

                if(archived==true){
                  context.read<StaffBloc>().add(FetchPreviousStaffEvent());
                }else{
                  context.read<StaffBloc>().add(FetchStaffEvent());
                }
              },
            ),

            const SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  if(archived==true){
                    context.read<StaffBloc>().add(FetchPreviousStaffEvent());
                  }else{
                    context.read<StaffBloc>().add(FetchStaffEvent());
                  }
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
            child: BlocBuilder<StaffBloc, StaffState>(
              builder: (context, state) {

                if (state is StaffFetchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is StaffFetchFailure) {
                  return Center(
                    child: Text(
                      state.error,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                } else if (state is StaffFetchSuccess) {
                  if(archived==true){
                    archivedList = state.staffs;
                  }

                  final staffToShow = searchController.text.isEmpty
                      ? state.staffs
                      : _filterStaffList;

                  return GridView.builder(
                    itemCount: staffToShow.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final staffModel = staffToShow[index];
                      return StaffGridItem(
                        staffModel: staffModel,
                      );
                    },
                  );
                }else{
                  return const SizedBox();
                }

              },
            ))
      ],
    );
  }
}
