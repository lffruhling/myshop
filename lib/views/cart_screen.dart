import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/widgets/cart_item_widget.dart';
import 'package:shop/widgets/order_button.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(25),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Chip(
                      label: Text(
                        'R\$ ${cart.totalAmount}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    Spacer(),
                    OrderBUtton(cart: cart),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.itemsCount,
                itemBuilder: (ctx, index) => CartItemWidget(cartItems[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

