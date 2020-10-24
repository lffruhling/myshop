import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/Exceptions.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  final String _baseUrl =
      'https://flutter-myshop-6c9f1.firebaseio.com/products';

  List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoriteItens {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    final response = await http.get('${_baseUrl}.json');

    Map<String, dynamic> data = json.decode(response.body);

    /*Limpa lista antes de adicionar os produtos*/
    _items.clear();

    if (data != null) {
      data.forEach((productId, productData) {
        _items.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          ),
        );
      });
      notifyListeners();
    }

    /*
    * Retornar um valor vazio de Future, devido a usar async/await
    * aqui e não na tela de carregamento, ao exibir o loading
    * */
    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    /*
    * Método com Async/Await
    * Executa como se fosse de forma sincrona normal, porém espera até o retorno
    * do http, e carrega os dados pra dentro de response, mesma coisa como se
    * fosse um then()
    * */

    final response = await http.post(
      '${_baseUrl}.json',
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      }),
    );

    /*
    * Aguardou o retorno do http e tem os dados de response
    * Agora vai executar o add e depois o notify
    * */
    _items.add(Product(
      id: json.decode(response.body)['name'],
      title: newProduct.title,
      description: newProduct.description,
      price: newProduct.price,
      imageUrl: newProduct.imageUrl,
    ));
    /*
    * Método sem Async/Await
    * Retorna somente quand o then terminar de ser executado
    * */
    // return http.post(
    //   url,
    //   body: json.encode({
    //     'title': newProduct.title,
    //     'description': newProduct.description,
    //     'price': newProduct.price,
    //     'imageUrl': newProduct.imageUrl,
    //     'isFavorite': newProduct.isFavorite,
    //   }),
    // ).then((response) {
    //   _items.add(Product(
    //     id: json.decode(response.body)['name'],
    //     title: newProduct.title,
    //     description: newProduct.description,
    //     price: newProduct.price,
    //     imageUrl: newProduct.imageUrl,
    //   ));
    /*
    * Adiciona o produto e chama método para notificar ouvintes que a lista
    * foi alterada
    * */
    notifyListeners();
    // });
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }

    /*Retorna o indece do produtor encontrado*/
    final index = _items.indexWhere((prod) => prod.id == product.id);

    /*
    * Se for maior ou igual a 0 encontrou se for -1 não achou o produto na lista
    * */
    if (index >= 0) {
      /*
      * Encontrou o produto, a partir disso, troca os dados do produto
      * dentro do array e notifica os ouvintes
      * */
      await http.patch(
        '${_baseUrl}/${product.id}.json',
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async{
    /*Retorna o indece do produtor encontrado*/
    final index = _items.indexWhere((prod) => prod.id == id);

    /*
    * Se for maior ou igual a 0 encontrou se for -1 não achou o produto na lista
    * */
    if (index >= 0) {
      /*
      * Encontrou o produto, a partir disso, troca os dados do produto
      * dentro do array e notifica os ouvintes
      * */
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      /*Faz a chamada http*/
      final response = await http.delete('${_baseUrl}/${product.id}.json');

      /*Caso ocorra alguma falha ao remover o produto, adiciona ele novamente a lista*/
      if(response.statusCode >= 400){
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Falha ao exlcuir item');
      }


    }
  }

/*Utilizado para filtrar produtos na aplicação inteira*/
// bool _showFavoriteOnly = false;
//
// /*Retorna uma compia da lista e não a referencia da lista*/
// List<Product> get items {
//   /*Filtra Globalmente os produtos favoritos, caso a flag de favoritos esteja ativa*/
//   if(_showFavoriteOnly){
//     return _items.where((prod) => prod.isFavorite).toList();
//   }
//   return [ ..._items ];
// }
//
// void showFavoriteOnly(){
//   _showFavoriteOnly = true;
//   notifyListeners();
// }
//
// void showAll(){
//   _showFavoriteOnly = false;
//   notifyListeners();
// }

}
