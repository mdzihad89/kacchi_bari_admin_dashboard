import 'dart:ui';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paged_datatable/paged_datatable.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../service_locator.dart';
import '../../../branch/data/model/branch_model.dart';
import '../../../branch/presentation/bloc/branch_bloc.dart';
import '../../../branch/presentation/bloc/branch_state.dart';
import '../../data/model/order_filter_model.dart';
import '../../data/model/order_response_model.dart';
import '../../data/order_repo_impl.dart';
import 'cart_item_view.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final tableController = PagedDataTableController<String, Order>();
  List<String> paymentMode = ["Cash", "Bkash", "Nagad"];
  List<String> paymentStatus = ["Done", "Pending"];
  List<String> orderTypes = ["Dine In", "Take Away", "Delivery", "Pre Order"];

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<BranchBloc, BranchState>(
      builder: (context, state) {
        if (state is BranchFetchSuccess) {
          return PagedDataTableTheme(
            data: PagedDataTableThemeData(
              selectedRow: Colors.grey[700],
              rowColor: (index) =>
              index.isEven ? Colors.grey[900] : Colors.grey[850],
              backgroundColor: Colors.black,
              headerTextStyle:
              const TextStyle(color: Colors.white, fontSize: 14),
              cellTextStyle: const TextStyle(color: Colors.white),
              footerTextStyle: const TextStyle(color: Colors.white),
              horizontalScrollbarVisibility: true,
              verticalScrollbarVisibility: true,
              cellPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
            ),
            child: PagedDataTable<String, Order>(
              controller: tableController,
              initialPageSize: 20,
              fixedColumnCount: 3,
              configuration: const PagedDataTableConfiguration(),
              pageSizes: const [20, 30, 40, 50],
              fetcher: (pageSize, sortModel, filterModel, pageToken) async {
                final branchModel = filterModel["branchId"] as BranchModel?;
                final branchId = branchModel?.id;
                OrderFilter orderFilter = OrderFilter(
                  branchId: branchId,
                  pageLimit: pageSize.toString(),
                  paymentStatus: filterModel["paymentStatus"],
                  paymentMode: filterModel["paymentMode"],
                  orderDate: filterModel["orderDate"] != null
                      ? (filterModel["orderDate"] as DateTime)
                      .toUtc()
                      .toIso8601String()
                      : null,
                  invoiceNumber: filterModel["invoiceNumber"],
                  customerPhoneNumber: filterModel["customerPhoneNumber"],
                  pageToken: pageToken,

                  serialNumber: filterModel["serialNumber"],
                  orderType: filterModel["orderType"],
                );

                OrderRepositoryImpl orderRepository =
                instance<OrderRepositoryImpl>();
                final orderResult =
                await orderRepository.getAllOrder(orderFilter);

                return orderResult.fold(
                      (failure) {
                    ElegantNotification.error(
                      title: const Text("Error",
                          style: TextStyle(color: Colors.black)),
                      description: Text(failure.message,
                          style: const TextStyle(color: Colors.black),
                          maxLines: 1),
                      width: 300,
                      height: 100,
                    ).show(context);

                    return (List<Order>.empty(), null);
                  },
                      (orderResponse) =>
                  (orderResponse.orders, orderResponse.nextPageToken),
                );
              },
              filters: [
                DropdownTableFilter<BranchModel>(
                  items: state.branches
                      .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                  )).toList(growable: false),
                  chipFormatter: (value) => value.name,
                  id: "branchId",
                  name: "Branch",
                  decoration: InputDecoration(
                    hintText: "Select Branch",
                    border: const OutlineInputBorder(),
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    labelText: "Branch",
                  ),
                ),
                DropdownTableFilter<String>(
                  items: orderTypes
                      .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )))
                      .toList(growable: false),
                  chipFormatter: (value) =>
                  'Order Type is ${value.toLowerCase()}',
                  id: "orderType",
                  name: "OrderType",
                  decoration: InputDecoration(
                    hintText: "Select OrderType",
                    border: OutlineInputBorder(),
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    labelText: "Order Type",
                  ),
                ),
                TextTableFilter(
                  id: "invoiceNumber",
                  chipFormatter: (value) => 'Invoice has "$value"',
                  name: "Invoice Number",
                  decoration: InputDecoration(
                    hintText: "Type invoice number",
                    border: OutlineInputBorder(),
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    labelText: "Invoice Number",
                  ),
                ),
                TextTableFilter(
                  id: "serialNumber",
                  chipFormatter: (value) => 'Token has "$value"',
                  name: "Token Number",
                  decoration: InputDecoration(
                    hintText: "Type token number",
                    border: OutlineInputBorder(),
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    labelText: "Token Number",
                  ),
                ),
                TextTableFilter(
                  id: "customerPhoneNumber",
                  chipFormatter: (value) => 'Phone Number has "$value"',
                  name: "Phone Number",
                  decoration: InputDecoration(
                    hintText: "Type phone number",
                    border: OutlineInputBorder(),
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    labelText: "Phone Number",
                  ),
                ),
                DateTimePickerTableFilter(
                  id: "orderDate",
                  name: "Order Date",
                  chipFormatter: (date) =>
                  "Date is ${DateFormat('dd/MM/yyyy').format(date)}",
                  initialValue: null,
                  firstDate:
                  DateTime.now().subtract(const Duration(days: 1825)),
                  lastDate: DateTime.now(),
                  dateFormat: DateFormat('dd/MM/yyyy'),
                  inputDecoration: InputDecoration(
                    hintText: "Select order date",
                    border: const OutlineInputBorder(),
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    labelText: "Order Date",
                  ),
                ),
                DropdownTableFilter<String>(
                  items: paymentMode
                      .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )))
                      .toList(growable: false),
                  chipFormatter: (value) =>
                  'Payment Mode is ${value.toLowerCase()}',
                  id: "paymentMode",
                  name: "Payment Mode",
                  decoration: InputDecoration(
                    hintText: "Select payment mode",
                    border: OutlineInputBorder(),
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    labelText: "Payment Mode",
                  ),
                ),
                DropdownTableFilter<String>(
                  items: paymentStatus
                      .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )))
                      .toList(growable: false),
                  chipFormatter: (value) =>
                  'Payment Status is ${value.toLowerCase()}',
                  id: "paymentStatus",
                  name: "Payment Status",
                  decoration: InputDecoration(
                    hintText: "Select payment status",
                    border: OutlineInputBorder(),
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    labelText: "Payment Status",
                  ),
                ),
              ],
              filterBarChild: PopupMenuButton(
                  icon: const Icon(Icons.more_vert_outlined),
                  itemBuilder: (context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      child: const Text("Delete Order"),
                      onTap: () async {
                        if (tableController.selectedItems.isNotEmpty){
                          showDialog(context: context,
                            builder: (context) {
                              bool isLoading = false;
                            return BackdropFilter(
                              filter:  ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: StatefulBuilder(
                                builder: (context,setState) {
                                  return AlertDialog(
                                    title:  const Center(child: Text("Delete Order")),
                                    content: isLoading==true? const Center(child: CircularProgressIndicator(),): const Text("Are you sure you want to delete this orders?",),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel")),
                                      TextButton(
                                          onPressed: () async{

                                            final orderRepository = instance<OrderRepositoryImpl>();
                                            List<String> selectedOrderIds = tableController.selectedItems.map((e) => e.id).whereType<String>().toList();

                                            setState(() {
                                              isLoading = true;
                                            });
                                            final result = await orderRepository.deleteOrder(selectedOrderIds);
                                            setState(() {
                                              isLoading = false;
                                            });
                                            result.fold((failure) {
                                                ElegantNotification.error(
                                                  title: const Text("Error",
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  description: Text(failure.message,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                      maxLines: 1),
                                                  width: 300,
                                                  height: 100,
                                                ).show(context);
                                              }, (success) {
                                                ElegantNotification.success(
                                                  title: const Text("Success",
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  description:
                                                  const Text("Order deleted successfully",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      maxLines: 1),
                                                  width: 300,
                                                  height: 100,
                                                ).show(context);
                                                Navigator.pop(context);
                                                tableController.refresh();
                                              },
                                            );
                                          },
                                          child: const Text("Delete"))
                                    ],

                                  );
                                }
                              ),
                            );
                          },);
                        }else{
                          ElegantNotification.error(
                            title: const Text("Error",
                                style: TextStyle(color: Colors.black)),
                            description: const Text("Select at least one order",
                                style: TextStyle(color: Colors.black),
                                maxLines: 1),
                            width: 300,
                            height: 100,
                          ).show(context);
                        }
                      },
                    ),
                  ]),
              columns: [
                RowSelectorColumn(),
                TableColumn(
                  title: const Text("Invoice"),
                  cellBuilder: (context, item, index) =>
                      Text(item.invoiceNumber),
                  size: const FixedColumnSize(120),
                ),
                TableColumn(
                  title: const Text("Order Date"),
                  cellBuilder: (context, item, index) => Text(
                      DateFormat('dd-MM-yyyy h:mm a').format(item.orderDate)),
                  size: const FixedColumnSize(200),
                ),
                TableColumn(
                  title: const Text("Branch"),
                  cellBuilder: (context, item, index) =>
                      Text(item.branchName),
                  size: const FixedColumnSize(150),
                ),
                TableColumn(
                  title: const Text("SubTotal"),
                  cellBuilder: (context, item, index) =>
                      Text("${item.subtotalAmount} Tk"),
                  size: const FixedColumnSize(100),
                ),
                TableColumn(
                  title: const Text("Discount"),
                  cellBuilder: (context, item, index) =>
                      Text("${item.discountAmount} Tk"),
                  size: const FixedColumnSize(100),
                ),
                TableColumn(
                  title: const Text("Net Payable"),
                  cellBuilder: (context, item, index) =>
                      Text("${item.netPayableAmount} Tk"),
                  size: const FixedColumnSize(100),
                ),
                TableColumn(
                  title: const Text("Paid"),
                  cellBuilder: (context, item, index) =>
                      Text("${item.paidAmount} Tk"),
                  size: const FixedColumnSize(100),
                ),
                TableColumn(
                  title: const Text("Change Amount"),
                  cellBuilder: (context, item, index) => Text(
                    "${item.changeAmount} Tk",
                    style: TextStyle(
                        color: item.changeAmount < 0
                            ? Colors.red
                            : Colors.white),
                  ),
                  size: const FixedColumnSize(100),
                ),
                TableColumn(
                  title: const Text("Payment Status"),
                  cellBuilder: (context, item, index) => Text(
                    item.paymentStatus,
                    style: TextStyle(
                        color: item.paymentStatus == "Pending"
                            ? Colors.red
                            : Colors.white),
                  ),
                  size: const FixedColumnSize(100),
                ),
                TableColumn(
                  title: const Text("Order Type"),
                  cellBuilder: (context, item, index) => Text(item.orderType),
                  size: const FixedColumnSize(100),
                ),
                TableColumn(
                  title: const Text("Order Status"),
                  cellBuilder: (context, item, index) => Text(
                    item.orderStatus,
                    style: TextStyle(
                        color: item.orderStatus == "Pending"
                            ? Colors.red
                            : Colors.white),
                  ),
                  size: const FixedColumnSize(100),
                ),
                TableColumnIconButton(
                    title: const Text("Cart Item"),
                    size: const FixedColumnSize(100),
                    onPressed: (item, index) async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: AlertDialog(
                                title:
                                const Center(child: Text("Cart Items")),
                                titleTextStyle:
                                Theme.of(context).textTheme.bodyLarge,
                                content: SizedBox(
                                  width: 350,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: item.cartItems.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: CartItemView(
                                          cart: item.cartItems[index],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Close"))
                                ],
                              ),
                            );
                          },
                          barrierDismissible: true);
                    },
                    icon: Icons.remove_red_eye,
                    iconColor: ColorConstants.primaryColor,
                    iconSize: 18),
                TableColumn(
                  title: const Text("Payment Mode"),
                  cellBuilder: (context, item, index) =>
                      Text(item.paymentMode),
                  size: const FixedColumnSize(100),
                ),
                TableColumn(
                  title: const Text("Table"),
                  cellBuilder: (context, item, index) =>
                      Text(item.tableNumber),
                  size: const FixedColumnSize(100),
                ),
                TableColumn(
                  title: const Text("Token"),
                  cellBuilder: (context, item, index) =>
                      Text(item.serialNumber),
                  size: const FixedColumnSize(100),
                ),
                TableColumn(
                  title: const Text("Deliver Time"),
                  cellBuilder: (context, item, index) =>
                      Text(item.deliveryDateAndTime),
                  size: const FixedColumnSize(200),
                ),
                TableColumn(
                  title: const Text("Delivery Fee"),
                  cellBuilder: (context, item, index) =>
                      Text("${item.deliveryFee} Tk"),
                  size: const FixedColumnSize(100),
                ),
                TableColumn(
                  title: const Text("Deliver Address"),
                  cellBuilder: (context, item, index) => Text(
                    item.deliveryAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  size: const FixedColumnSize(250),
                  format:
                  const AlignColumnFormat(alignment: Alignment.center),
                  onTap: (item, index) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: AlertDialog(
                              title: const Center(
                                  child: Text("Delivery Address")),
                              content: Text(item.deliveryAddress),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Close"))
                              ],
                            ),
                          );
                        });
                  },
                ),
                TableColumn(
                  title: const Text("Deliver Boy"),
                  cellBuilder: (context, item, index) => Text(
                    item.deliveryBoyName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  size: const FixedColumnSize(150),
                  format:
                  const AlignColumnFormat(alignment: Alignment.center),
                ),
                TableColumn(
                  title: const Text("Customer Number"),
                  cellBuilder: (context, item, index) =>
                      Text(item.customerPhoneNumber),
                  size: const FixedColumnSize(150),
                  onTap: (item, index) {
                    Clipboard.setData(
                        ClipboardData(text: item.customerPhoneNumber));
                  },
                ),
                TableColumn(
                  title: const Text("Customer Name"),
                  cellBuilder: (context, item, index) => Text(
                    item.customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  size: const FixedColumnSize(200),
                ),
                TableColumn(
                  title: const Text("Note"),
                  cellBuilder: (context, item, index) => Text(
                    item.note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  size: const FixedColumnSize(150),
                  onTap: (item, index) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: AlertDialog(
                              title: const Center(child: Text("Note")),
                              content: Text(item.note),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Close"))
                              ],
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
          );
        }
        else if (state is BranchFetchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BranchFetchFailure) {
          return Center(
            child: Text(
              state.error,
              style: const TextStyle(color: Colors.red),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        } else {
          return Container();
        }

      },
    );
  }
}
