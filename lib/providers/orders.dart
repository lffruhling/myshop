import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/cart_item.dart';
import 'package:shop/providers/order.dart';

class Orders with ChangeNotifier {
  final String _baseUrl = 'https://flutter-myshop-6c9f1.firebaseio.com/orders';
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    final response = await http.get('${_baseUrl}.json');

    Map<String, dynamic> data = json.decode(response.body);
    List<Order> loadedItems = [];

    /*Limpa lista antes de adicionar os pedidos*/
    loadedItems.clear();

    if (data != null) {
      data.forEach((ordertId, ordertData) {
        loadedItems.add(Order(
          id: ordertId,
          total: ordertData['total'],
          date: DateTime.parse(ordertData['date']),
          products: (ordertData['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              productId: item['productId'],
              title: item['title'],
              quantity: item['quantity'],
              price: item['price'],
            );
          }).toList(),
        ));
      });
      notifyListeners();
    }

    /*Altera ordenação dos pedidos para o mas novo primeiro*/
    _items = loadedItems.reversed.toList();

    /*
    * Retornar um valor vazio de Future, devido a usar async/await
    * aqui e não na tela de carregamento, ao exibir o loading
    * */
    return Future.value();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      "$_baseUrl.json",
      body: json.encode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList(),
      }),
    );

    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );

    notifyListeners();
  }
}
