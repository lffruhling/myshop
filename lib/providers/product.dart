import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/Exceptions.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  final String _baseUrl =
      'https://flutter-myshop-6c9f1.firebaseio.com/products';

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite(){
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite() async{
    _toggleFavorite();

    try{
      /*Faz a chamada http*/
      final response = await http.patch(
        '${_baseUrl}/${id}.json',
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );

      /*Caso ocorra alguma falha ao remover o produto, adiciona ele novamente a lista*/
      if(response.statusCode >= 400){
        _toggleFavorite();
        return Future.error('Falha ao marcar item como favorito!');
      }
    }catch (error){
      _toggleFavorite();
    }

  }
}
