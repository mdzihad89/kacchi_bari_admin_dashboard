import 'package:flutter/services.dart';
import '../../features/salary/data/model/staff_salary_payment_model.dart';
import '../../features/salary/data/model/staff_salary_report_model.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AppHelper {
  static Future<void> generateAndDownloadReportPdf(
    StaffSalaryReportModel staffSalaryReportModel,
    List<DateTime> leaveDates,
    List<StaffSalaryPaymentModel> staffSalaryPaymentList,
  ) async {
    final water_mark_bytes = await rootBundle.load('assets/water_mark.png');
    final water_mark = pw.MemoryImage(water_mark_bytes.buffer.asUint8List());
    String footer = await rootBundle.loadString('assets/footer.svg');
    String header = await rootBundle.loadString('assets/header.svg');

    final staffDp = pw.MemoryImage(
      (await http.get(Uri.parse(staffSalaryReportModel.staffImage))).bodyBytes,
    );

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin:
              pw.EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 120),
          pageFormat: PdfPageFormat.a4,
          buildBackground: (context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Column(
                children: [
                  pw.SizedBox(height: 20),
                  pw.SvgImage(svg: header),
                  pw.Expanded(
                    child: pw.Center(
                      child: pw.Opacity(
                          opacity: 0.15,
                          child: pw.Padding(
                            padding: pw.EdgeInsets.only(right: 20),
                            child: pw.Image(water_mark),
                          )),
                    ),
                  ),
                  pw.SvgImage(svg: footer),
                ],
              ),
            );
          },
        ),
        build: (context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Report Title & Date

                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    // crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              "Salary Report",
                              style: pw.TextStyle(
                                  fontSize: 24, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              "Report Date: ${DateFormat.yMMMd().format(staffSalaryReportModel.reportDate)}",
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ]),
                    ]),
                pw.Divider(),
                pw.SizedBox(height: 10),
                // Staff Info Row: Details on the left and staff image on the right
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("ID: ${staffSalaryReportModel.icId}",
                              style: pw.TextStyle(fontSize: 12)),
                          pw.SizedBox(height: 10),
                          pw.Text("Name: ${staffSalaryReportModel.staffName}",
                              style: pw.TextStyle(fontSize: 12)),
                          pw.SizedBox(height: 10),
                          pw.Text(
                              "Designation: ${staffSalaryReportModel.staffDesignation}",
                              style: pw.TextStyle(fontSize: 12)),
                          pw.SizedBox(height: 10),
                          pw.Text(
                            "Joining Date: ${DateFormat.yMMMd().format(staffSalaryReportModel.reportDate)}",
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.SizedBox(height: 10),
                          if (staffSalaryReportModel.exitDate != null)
                            pw.Text(
                              "Resign Date:  ${DateFormat.yMMMd().format(staffSalaryReportModel.exitDate!)}",
                              style: pw.TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                    // Staff image
                    pw.Expanded(
                      fit: pw.FlexFit.loose,
                      flex: 2,
                      child: pw.Container(
                        height: 100,
                        width: 100,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          color: PdfColors.grey300,
                          border: pw.Border.all(
                              color: PdfColors.amberAccent400, width: 2),
                        ),
                        child: pw.ClipOval(
                          child: pw.Image(
                            staffDp,
                            fit: pw.BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                pw.SizedBox(height: 20),
                // Salary Details Table Title:
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Salary Details",
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.normal),
                      ),
                      pw.SizedBox(height: 10),
                      // Salary Details Table:
                      pw.Table(
                        border: pw.TableBorder.all(
                            color: PdfColors.grey, width: 0.5),
                        columnWidths: {
                          0: pw.FlexColumnWidth(2),
                          1: pw.FlexColumnWidth(1),
                        },
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text("Basic Salary"),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text(
                                    "${staffSalaryReportModel.basicSalary} Tk"),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text("Per Day Salary"),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text(
                                    "${staffSalaryReportModel.perDaySalary} Tk"),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text("Total Days"),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text(
                                    " ${staffSalaryReportModel.totalDays}"),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text("Leave Days"),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text(
                                    "${staffSalaryReportModel.leaveDays}"),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text("Worked Days"),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text(
                                    "${staffSalaryReportModel.workedDays}"),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text("Payable Amount"),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text(
                                    "${staffSalaryReportModel.payableAmount} Tk"),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text("Total Paid"),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text(
                                    "${staffSalaryReportModel.totalPaid} Tk"),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child:
                                    pw.Text("${staffSalaryReportModel.status}",style: pw.TextStyle(
                                      color: staffSalaryReportModel.status=="Paid"?PdfColors.green:staffSalaryReportModel.status=="Due"?PdfColors.red: PdfColors.amberAccent400,
                                      fontWeight:  pw.FontWeight.bold,
                                    )),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Text(
                                    "${double.tryParse(staffSalaryReportModel.netAmount)!.abs()} Tk"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]),
                pw.SizedBox(height: 20),
                if (leaveDates.isNotEmpty)
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Leave Dates",
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.normal),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                            leaveDates
                                .map((date) => DateFormat.yMMMd().format(date))
                                .join('-'),
                            style: pw.TextStyle(fontSize: 12)),
                      ]),
                if (staffSalaryPaymentList.isNotEmpty) pw.SizedBox(height: 30),
                if (staffSalaryPaymentList.isNotEmpty)
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Paid Amount",
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.normal),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Table(
                          border: pw.TableBorder.all(
                              color: PdfColors.grey, width: 0.5),
                          columnWidths: {
                            0: pw.FlexColumnWidth(2),
                            1: pw.FlexColumnWidth(1),
                          },
                          children: [
                            pw.TableRow(
                              decoration: pw.BoxDecoration(color: PdfColors.grey300),
                              children: [
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(8),
                                  child: pw.Text(
                                    "Date",
                                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                  ),
                                ),
                                pw.Padding(
                                  padding: pw.EdgeInsets.all(8),
                                  child: pw.Text(
                                    "Amount",
                                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ...  staffSalaryPaymentList.map((payment) {
                              return pw.TableRow(
                                children: [
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(8),
                                    child: pw.Text(DateFormat.yMMMd()
                                        .format(payment.paymentDate)),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.all(8),
                                    child: pw.Text("${payment.payAmount} Tk"),
                                  ),
                                ],
                              );
                            })
                          ]
                        ),
                      ]),
              ],
            ),
          ];
        },
      ),
    );

    //download pdf using printing package
    await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: '${staffSalaryReportModel.staffName}.pdf');
  }
}
