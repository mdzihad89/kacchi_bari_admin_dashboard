import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';





class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}
class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Order",
              style: GoogleFonts.inter(fontSize: 24, color: Colors.white),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {

              },
              icon: const Icon(
                Icons.refresh,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
