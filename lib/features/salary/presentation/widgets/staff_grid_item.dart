import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kacchi_bari_admin_dashboard/core/constants/color_constants.dart';
import 'package:kacchi_bari_admin_dashboard/features/salary/data/model/staff_model.dart';

class StaffGridItem extends StatelessWidget {
  final StaffModel staffModel;

  const StaffGridItem({
    super.key,
    required this.staffModel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints) {
       double width = constraints.maxWidth;

        return InkWell(
          onTap: () {

            context.go('/staff/${staffModel.id}');



          },
          borderRadius: BorderRadius.circular(12),
          child: Card(
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
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      staffModel.staffImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: const Icon(Icons.person, size: 50, color: Colors.grey),
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
                             Icon(Icons.phone, size: width * 0.06, color: Colors.green),
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
                            Icon(Icons.attach_money, size: width * 0.06, color: Colors.orange),
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
                            Icon(Icons.calendar_today, size: width * 0.06, color: Colors.blue),
                            Text(
                              DateFormat.yMMMd().format(staffModel.joiningDate),
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
        );
      }
    );
  }
}
