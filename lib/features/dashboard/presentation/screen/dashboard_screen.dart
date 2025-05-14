import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
  String? localStartTime;
  String? localEndTime;

  @override
  void initState() {
    context.read<BranchBloc>().add(FetchBranchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchBloc, BranchState>(
      builder: (context, state) {
        if (state is BranchFetchSuccess) {
          return Column(
            spacing: 10,
            children: [
              SizedBox(
                height: 60,
                child: Form(
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
                                _dateController.text = DateFormat.yMMMd().format(selectedDate);

                                 final startTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  6,
                                  0,
                                );
                                localStartTime = startTime.toUtc().toIso8601String();
                                localEndTime = startTime.add(const Duration(days: 1)).toUtc().toIso8601String();

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
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 200,
                        child: DropdownButtonFormField<BranchDropdownItem>(
                          dropdownColor: ColorConstants.cardBackgroundColor,
                          selectedItemBuilder: (BuildContext context) {
                            return state.branches.map((branch) {
                              return Text(
                                branch.name.toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              );
                            }).toList();
                          },
                          items: state.branches.map((BranchModel branch) {
                            return DropdownMenuItem<BranchDropdownItem>(
                              value: BranchDropdownItem(
                                  id: branch.id, name: branch.name),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    branch.name.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )),
                            );
                          }).toList(),
                          value: _selectedBranch,
                          onChanged: (branch) {
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
                          ),
                          padding: const EdgeInsets.all(0),
                          hint: Text(
                            "Select Branch",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                           context.read<DashboardBloc>().add(FetchDashboardEvent(branchId: _selectedBranch!.id, localStartTime: localStartTime!,localEndTime: localEndTime!));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.primaryColor,
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
              Expanded(
                  child: Row(
                    spacing: 10,
                children: [
                   SizedBox(
                    width: 200,
                    child: Column(
                      spacing: 10,
                      children: [
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: ColorConstants.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(20),
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Total Sell",
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    BlocConsumer<DashboardBloc, DashboardState>(
                                        listener: (context, state) {
                                      if (state is DashboardFailure) {
                                        ElegantNotification.error(
                                          title: const Text(
                                            "Error",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          description: Text(
                                            state.error,
                                            style: const TextStyle(color: Colors.black),
                                            maxLines: 2,
                                          ),
                                          width: 300,
                                          height: 100,
                                        ).show(context);
                                      }
                                    }, builder: (context, state) {
                                      if (state is DashboardLoaded) {
                                        return Text(
                                          "${state.orderReport.totalNetPayableAmount} TK",
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        );
                                      } else if (state is DashboardLoading) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                      return const SizedBox();
                                    }),
                                  ],
                                ),
                              ),
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: ColorConstants.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                alignment: Alignment.center,
                                child: BlocBuilder<DashboardBloc, DashboardState>(
                                    builder: (context, state) {
                                      if (state is DashboardLoaded) {
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("Subtotal: ${state.orderReport.totalSubtotalAmount}TK",
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                            Text("Discount : ${state.orderReport.totalDiscountAmount} TK",
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                          ],
                                        );
                                      } else if (state is DashboardLoading) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                      return const SizedBox();
                                    })
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ColorConstants.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment:  Alignment.center,

                                  child:BlocBuilder<DashboardBloc, DashboardState>(
                                      builder: (context, state) {
                                        if (state is DashboardLoaded) {
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("Total Order : ${state.orderReport.totalOrders.toString()}",
                                                style: Theme.of(context).textTheme.bodyLarge,
                                              ),
                                              ...state.orderReport.orderTypeCounts.map((e) => Text(
                                                "${e.orderType} : ${e.orderCount}",
                                                style: Theme.of(context).textTheme.bodyMedium,
                                              )),
                                            ],
                                          );
                                        } else if (state is DashboardLoading) {
                                          return const Center(child: CircularProgressIndicator());
                                        }
                                        return const SizedBox();
                                      }) ,
                                ),
                              ),
                      ],
                    ),
                  ),
                   Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorConstants.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                "Total Sold Items",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Divider(
                                color: Colors.white,
                              ),
                              Expanded(
                                child: BlocBuilder<DashboardBloc, DashboardState>(
                                  builder: (context, state) {
                                    if(state is DashboardLoaded){
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              "🍖 Mutton : ${state.orderReport.soldItems.muttonPiece}",
                                              style: Theme.of(context).textTheme.bodyLarge,
                                            ),
                                            Text(
                                              "🍗 Chicken : ${state.orderReport.soldItems.chickenPiece}",
                                              style: Theme.of(context).textTheme.bodyLarge,
                                            ),
                                            Text(
                                              "🍮 Firni : ${state.orderReport.soldItems.firniPiece}",
                                              style: Theme.of(context).textTheme.bodyLarge,
                                            ),
                                            Text(
                                              "🥤 Borhani : ${(state.orderReport.soldItems.borhaniMl/1000).toStringAsFixed(2)} Liter",
                                              style: Theme.of(context).textTheme.bodyLarge,
                                            ),

                                            if (state.orderReport.soldItems.extraRice.isNotEmpty) ...[
                                              Text(
                                                "🍛 Extra Rice",
                                                style: Theme.of(context).textTheme.bodyLarge,
                                              ),
                                              ...state.orderReport.soldItems.extraRice.entries.map(
                                                    (e) => Padding(
                                                  padding: const EdgeInsets.only(left: 20),
                                                  child: Text("• ${e.key} Tk x ${e.value}"),
                                                ),
                                              ),
                                             ],
                                            if (state.orderReport.soldItems.badamSharbat.isNotEmpty) ...[
                                              Text(
                                                "🥛 Badam Sharbat",
                                                style: Theme.of(context).textTheme.bodyLarge,
                                              ),
                                              ...state.orderReport.soldItems.badamSharbat.entries.map(
                                                    (e) => Padding(
                                                  padding: const EdgeInsets.only(left: 20),
                                                  child: Text("• ${e.key} Tk x ${e.value}"),
                                                ),
                                              ),
                                            ],
                                            if (state.orderReport.soldItems.doi.isNotEmpty) ...[
                                              Text(
                                                "🧁 Doi",
                                                style: Theme.of(context).textTheme.bodyLarge,
                                              ),
                                              ...state.orderReport.soldItems.doi.entries.map(
                                                    (e) => Padding(
                                                  padding: const EdgeInsets.only(left: 20),
                                                  child: Text("• ${e.key} Tk x ${e.value}"),
                                                ),
                                              ),
                                            ],

                                            if (state.orderReport.soldItems.softDrinks.isNotEmpty) ...[
                                              Text(
                                                "🧃 Soft Drinks",
                                                style: Theme.of(context).textTheme.bodyLarge,
                                              ),
                                              ...state.orderReport.soldItems.softDrinks.entries.map(
                                                    (e) => Padding(
                                                      padding: const EdgeInsets.only(left: 20),
                                                      child: Text("• ${e.key} Tk x ${e.value}"),
                                                    ),
                                              ),
                                            ],
                                            if (state.orderReport.soldItems.water.isNotEmpty) ...[
                                              Text(
                                                "💧 Water",
                                                style: Theme.of(context).textTheme.bodyLarge,
                                              ),
                                              ...state.orderReport.soldItems.water.entries.map(
                                                    (e) => Padding(
                                                      padding: const EdgeInsets.only(left: 20),
                                                      child: Text("• ${e.key} Tk x ${e.value}"),
                                                    ),
                                              ),
                                            ],


                                            if (state.orderReport.soldItems.jorda.isNotEmpty) ...[
                                              Text(
                                                "🍬 Jorda",
                                                style: Theme.of(context).textTheme.bodyLarge,
                                              ),
                                              ...state.orderReport.soldItems.jorda.entries.map(
                                                    (e) => Padding(
                                                  padding: const EdgeInsets.only(left: 20),
                                                  child: Text("• ${e.key} Tk x ${e.value}"),
                                                ),
                                              ),
                                            ],

                                          ],
                                        ),
                                      );
                                    }else if(state is DashboardLoading){
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    return const SizedBox();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                   Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorConstants.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                "Top Selling Items",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Divider(
                                color: Colors.white,
                              ),
                              Expanded(
                                child: BlocBuilder<DashboardBloc, DashboardState>(
                                  builder: (context, state) {
                                    if (state is DashboardLoaded) {
                                      return ListView(
                                        children: state.orderReport.topSellingItems.map((item) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Material(
                                              child: ListTile(
                                                title: Text(item.productName),
                                                trailing: Text(item.totalQuantity.toString(),style: Theme.of(context).textTheme.bodyMedium ),
                                                subtitle: Text("${item.unitPrice} TK", ),
                                                titleTextStyle:  Theme.of(context).textTheme.bodySmall,
                                                subtitleTextStyle:  Theme.of(context).textTheme.bodyMedium,
                                                tileColor: Colors.black,

                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    } else if (state is DashboardLoading) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    return const SizedBox();
                                  },
                                ),

                              )
                            ],
                          ),
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
          return Text(
            state.error,
            style: const TextStyle(color: Colors.red),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
