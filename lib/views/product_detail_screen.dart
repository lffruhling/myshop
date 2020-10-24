import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context).settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: Text(
                'R\$ ${product.price}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}