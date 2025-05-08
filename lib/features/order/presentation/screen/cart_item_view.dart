import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';
import '../../data/model/order_response_model.dart';

class CartItemView extends StatelessWidget {
  final Cart cart;
  const CartItemView({
    super.key,
    required this.cart
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cart.productName,
              style: const TextStyle(
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity: ${cart.quantity}',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Price: ${cart.unitPrice} Tk',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: ${cart.unitPrice} Tk',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: ColorConstants.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}