import 'package:elegant_notification/elegant_notification.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kacchi_bari_admin_dashboard/core/constants/color_constants.dart';

import '../../../../core/common/photo_card.dart';
import '../../../../core/common/textform_field.dart';
import '../../data/model/add_staff_dto.dart';
import '../bloc/staff_bloc.dart';
import '../bloc/staff_event.dart';
import '../bloc/staff_state.dart';

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
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
  final TextEditingController _joiningDateController = TextEditingController(
  );
  final TextEditingController _basicSalaryController = TextEditingController(
  );

  final TextEditingController _guardianNumberController = TextEditingController(
  );



  Uint8List? _staffImageBytes;
  Uint8List ? _staffAttachmentBytes;
  String ? joiningDate;

  @override
  Widget build(BuildContext context) {
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
                  icon: Icon(Icons.arrow_back,color: ColorConstants.primaryColor,),
                  onPressed: () {
                    context.go('/staff');
                  },
                ),
                PhotoCard(
                  levelText: "Photo",
                  onImagePicked: (imageBytes) {
                    setState(() {
                      _staffImageBytes = imageBytes;
                    });
                  },
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
                        child: _staffAttachmentBytes == null ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            const Icon(
                                Icons.cloud_done_outlined, color: Colors.grey,
                                size: 50),
                            Text("Click here to add file", style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium),
                          ],
                        ) :    Image.memory(_staffAttachmentBytes!,fit: BoxFit.fitHeight,),
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
                    validatorText: "Please enter joining date",
                    textEditingController: _joiningDateController,
                    labelText: "Joining Date",
                    readOnly: true,
                    onTap: () async{
                    await  showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          _joiningDateController.text = DateFormat.yMMMd().format(selectedDate);
                          joiningDate = selectedDate.toUtc().toIso8601String();
                        }
                      });
                    },

                  ),
                ),
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
                if(state is StaffAddSuccess){
                  ElegantNotification.success(
                    title: const Text(
                      "Success", style: TextStyle(color: Colors.black),),
                    description: const Text("Staff added successfully",
                      style: TextStyle(color: Colors.black),),
                    width: 300,
                    height: 100,
                  ).show(context);
                  context.pop();
                }
                if(state is StaffAddFailure){
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
                    if (_staffAttachmentBytes == null) {
                      ElegantNotification.error(
                        title: const Text(
                          "Error", style: TextStyle(color: Colors.black),),
                        description: const Text("Please add attachment",
                          style: TextStyle(color: Colors.black),),
                        width: 300,
                        height: 100,
                      ).show(context);
                    } else if (_staffImageBytes == null) {
                      ElegantNotification.error(
                        title: const Text(
                          "Error", style: TextStyle(color: Colors.black),),
                        description: const Text("Please add staff photo",
                          style: TextStyle(color: Colors.black),),
                        width: 300,
                        height: 100,
                      ).show(context);
                    } else if (_formKey.currentState!.validate()) {
                      final AddStaffDTO addStaffDTO = AddStaffDTO(
                        name: _nameController.text,
                        fatherName: _fatherNameController.text,
                        guardianNumber: _guardianNumberController.text,
                        phone: _phoneController.text,
                        address: _addressController.text,
                        nidOrBirthCertificateNumber: _nidOrBirthCertificateNumberController.text,
                        birthdate: _birthdateController.text,
                        designation: _designationController.text,
                        joiningDate: joiningDate!,
                        basicSalary: _basicSalaryController.text,
                        staffImage: _staffImageBytes!,
                        staffAttachment: _staffAttachmentBytes!,
                      );

                      context.read<StaffBloc>().add(AddStaffEvent(addStaffDTO));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor,
                    fixedSize: const Size(140, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: state is StaffAddLoading?const Center(child: CircularProgressIndicator(color: Colors.white,),): Text(
                    "Add Staff",
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
}


class DashedBorderContainer extends StatelessWidget {
  final Widget child;

  const DashedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(),
      child: child,
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = ColorConstants.primaryColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5.0;
    const double dashSpace = 5.0;
    double startX = 3;

    // Top side
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Right side
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Bottom side
    startX = 3;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Left side
    startY = 3;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}