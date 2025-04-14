import 'dart:typed_data';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_model.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/update_staff_dto.dart';

import '../../../../core/common/photo_card.dart';
import '../../../../core/common/textform_field.dart';
import '../../../../core/constants/color_constants.dart';
import '../bloc/staff_bloc.dart';
import '../bloc/staff_event.dart';
import '../bloc/staff_salary_payment/staff_salary_payemnt_event.dart';
import '../bloc/staff_salary_payment/staff_salary_payment_bloc.dart';
import '../bloc/staff_salary_payment/staff_salary_payment_state.dart';
import '../bloc/staff_state.dart';
import 'add_staff_screen.dart';

class EditStaffScreen extends StatefulWidget {
  final String staffId;

  const EditStaffScreen({super.key, required this.staffId});

  @override
  State<EditStaffScreen> createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends State<EditStaffScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController(
  );
  final TextEditingController _fatherNameController = TextEditingController(
  );
  final TextEditingController _phoneController = TextEditingController(
  );
  final TextEditingController _addressController = TextEditingController(
  );
  final TextEditingController _nidOrBirthCertificateNumberController = TextEditingController(
  );
  final TextEditingController _birthdateController = TextEditingController(
  );
  final TextEditingController _designationController = TextEditingController(
  );

  final TextEditingController _basicSalaryController = TextEditingController(
  );

  final TextEditingController _guardianNumberController = TextEditingController(
  );

  Uint8List? _staffImageBytes;
  Uint8List ? _staffAttachmentBytes;


  @override
  void initState() {

    context .read<StaffSalaryPaymentBloc>().add(FetchSingleStaffEvent(
      staffId: widget.staffId,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffSalaryPaymentBloc, StaffSalaryPaymentState>(
  builder: (context, state) {

    if( state is StaffFetchSingleLoading){
      return const Center(child: CircularProgressIndicator());
    }
    if( state is StaffFetchSingleFailure){
      return Center(child: Text(state.error));
    }
    if( state is StaffFetchSingleSuccess){
      _nameController.text = state.staff.name;
      _fatherNameController.text = state.staff.fatherName;
      _phoneController.text = state.staff.phone;
      _addressController.text = state.staff.address;
      _nidOrBirthCertificateNumberController.text = state.staff.nidOrBirthCertificateNumber;
      _birthdateController.text = state.staff.birthdate;
      _designationController.text = state.staff.designation;
      _basicSalaryController.text = state.staff.basicSalary.toString();
      _guardianNumberController.text = state.staff.guardianNumber;
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,color: ColorConstants.primaryColor,),
                    onPressed: () {
                      context.go('/staff');
                    },
                  ),

                  Stack(
                    children: [
                      Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:  Border.all(
                              color: ColorConstants.primaryColor,
                              width: 2,
                            ),

                            image:  DecorationImage(
                              image: _staffImageBytes != null
                                  ? MemoryImage(_staffImageBytes!)
                                  : NetworkImage(state.staff.staffImage) as ImageProvider,
                              fit: BoxFit.cover,
                            )
                        ),
                      ),
                      SizedBox(
                        height: 130,
                        width: 130,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            onPressed: () async{
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                allowMultiple: false,
                              );

                              if (result != null && result.files.isNotEmpty) {
                                Uint8List fileBytes = result.files.first.bytes!;
                                setState(() {
                                  _staffImageBytes = fileBytes;
                                });
                              }


                            },
                            icon: Icon(
                              Icons.edit,
                              color: ColorConstants.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: DashedBorderContainer(
                      child: InkWell(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowMultiple: false,
                            allowedExtensions: ['jpg', 'png', 'jpeg'],
                          );

                          if (result != null && result.files.isNotEmpty) {
                            Uint8List fileBytes = result.files.first.bytes!;
                            setState(() {
                              _staffAttachmentBytes = fileBytes;
                            });
                          }
                        },
                        child: Container(
                            height: 130,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: _staffAttachmentBytes == null ? Image.network(state.staff.staffAttachment,fit: BoxFit.fitHeight,) :
                            Image.memory(_staffAttachmentBytes!,fit: BoxFit.fitHeight,)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: CTextFormField(
                      validatorText: "Please enter your name",
                      textEditingController: _nameController,
                      labelText: "Name",
                      onChanged: (value) {},
                    ),
                  ),
                  Expanded(
                    child: CTextFormField(
                      validatorText: "Please enter Father's name",
                      textEditingController: _fatherNameController,
                      labelText: "Father's Name",
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: CTextFormField(
                      validatorText: "Please enter your guardian's Number",
                      textEditingController: _guardianNumberController,
                      labelText: "Gauardian Number",
                      onChanged: (value) {},
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  Expanded(
                    child: CTextFormField(
                      validatorText: "Please enter phone number",
                      textEditingController: _phoneController,
                      labelText: "Phone Number",
                      onChanged: (value) {},
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],

                    ),
                  ),
                ],
              ),
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: CTextFormField(
                      validatorText: "Please enter your address",
                      textEditingController: _addressController,
                      labelText: "Address",
                      onChanged: (value) {},
                    ),
                  ),
                  Expanded(
                    child: CTextFormField(
                      validatorText: "Please enter nid number",
                      textEditingController: _nidOrBirthCertificateNumberController,
                      labelText: "NID/Birth Certificate Number",
                      onChanged: (value) {},
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: CTextFormField(
                      validatorText: "Please enter birthdate",
                      textEditingController: _birthdateController,
                      labelText: "Birthdate",
                      onChanged: (value) {},
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            _birthdateController.text = DateFormat.yMMMd().format(selectedDate);
                          }
                        });
                      },

                    ),
                  ),
                  Expanded(
                    child: CTextFormField(
                      validatorText: "Please enter designation",
                      textEditingController: _designationController,
                      labelText: "Designation",
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: CTextFormField(
                      validatorText: "Please enter basic salary",
                      textEditingController: _basicSalaryController,

                      labelText: "Basic Salary",
                      onChanged: (value) {},
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ],
              ),
              BlocConsumer<StaffBloc, StaffState>(
                listener: (context, state) {
                  if(state is StaffUpdateSuccess){
                    ElegantNotification.success(
                      title: const Text(
                        "Success", style: TextStyle(color: Colors.black),),
                      description: const Text("Staff Updated successfully",
                        style: TextStyle(color: Colors.black),),
                      width: 300,
                      height: 100,
                    ).show(context);
                    context.pop();
                  }
                  if(state is StaffUpdateFailure){
                    ElegantNotification.error(
                      title: const Text(
                        "Error", style: TextStyle(color: Colors.black),),
                      description: Text(state.error,
                        style: const TextStyle(color: Colors.black),maxLines: 1,overflow: TextOverflow.ellipsis,),
                      width: 300,
                      height: 100,
                    ).show(context);
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () async {

                      if(_formKey.currentState!.validate()){
                        UpdateStaffDTO updateStaffDTO=UpdateStaffDTO(
                            staffId: widget.staffId,
                            name: _nameController.text,
                            fatherName: _fatherNameController.text,
                            phone: _phoneController.text,
                            address: _addressController.text,
                            nidOrBirthCertificateNumber: _nidOrBirthCertificateNumberController.text,
                            birthdate: _birthdateController.text,
                            designation: _designationController.text,
                            basicSalary: _basicSalaryController.text,
                            guardianNumber: _guardianNumberController.text,
                            staffImage: _staffImageBytes,
                            staffAttachment: _staffAttachmentBytes
                        );

                        context.read<StaffBloc>().add(UpdateStaffEvent(updateStaffDTO));

                      }

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.primaryColor,
                      fixedSize:  const Size(200, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child:
                    state is StaffUpdateLoading?const Center(child: CircularProgressIndicator(color: Colors.white,),):
                    Text(
                      "Update Staff",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox();

  },
);
  }
}
