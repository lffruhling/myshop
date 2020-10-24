import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class ProductsFromScreen extends StatefulWidget {
  @override
  _ProductsFromScreenState createState() => _ProductsFromScreenState();
}

class _ProductsFromScreenState extends State<ProductsFromScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageURLFocusNode.addListener(_updateImage);
  }

  /*Metódo chamada quando o widget muda*/
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    /*Inicia o formulário caso ele não exista*/
    if (_formData.isEmpty) {
      /*Pega o produto via parametro da rota*/
      final product = ModalRoute.of(context).settings.arguments as Product;

      /*inicia o formulário com os dados se veio um produto por parametro*/
      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageURLController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // Liberar qualquer lixo que tenha ficado na memoria
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLFocusNode.removeListener(_updateImage);
    _imageURLFocusNode.dispose();
  }

  void _updateImage() {
    if (isValidImageUrl(_imageURLController.text)) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    var _isValid = _form.currentState.validate();

    if (!_isValid) {
      return;
    }

    /*Invoca metodo save nos campos do form para salvar os dados informados*/
    _form.currentState.save();

    /*Criar o Produto*/
    final product = Product(
      id: _formData['id'],
      title: _formData['title'],
      description: _formData['description'],
      price: _formData['price'],
      imageUrl: _formData['imageUrl'],
    );

    setState(() {
      _isLoading = true;
    });

    /*
    * Adiciona o produto;
    * Para usar o provider fora do build, obrigatoriamente o listen tem que ser false;
    * */
    final products = Provider.of<Products>(context, listen: false);

    try {
      if (_formData['id'] == null) {
        await products.addProduct(product);
      } else {
        await products.updateProduct(product);
      }
      Navigator.of(context).pop();
    } catch (err) {
      /*O retorno do erro do HTTP sempre é tipado como Null, neste caso o Dialog deve ser criado com a mesma tipagem*/
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Falha ao cadastrar o produto!'),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    /*
      * Forma convencional utilizando o then
      * */
    // products.addProduct(product).catchError((error) {
    //   /*O retorno do erro do HTTP sempre é tipado como Null, neste caso o Dialog deve ser criado com a mesma tipagem*/
    //   return showDialog<Null>(
    //       context: context,
    //       builder: (ctx) => AlertDialog(
    //         title: Text('Ocorreu um erro!'),
    //         content: Text('Falha ao cadastrar o produto!'),
    //         actions: [
    //           FlatButton(
    //             child: Text('Ok'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ],
    //       ));
    // }).then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   Navigator.of(context).pop();
    // });
  }

  bool isValidImageUrl(String url) {
    bool startsWithHttp = url.toLowerCase().startsWith('http://');
    bool startsWithHttps = url.toLowerCase().startsWith('https://');
    bool endWithHttpsPNG = url.toLowerCase().endsWith('.png');
    bool endWithHttpsJPG = url.toLowerCase().endsWith('.jpg');
    bool endWithHttpsJPeG = url.toLowerCase().endsWith('.jpeg');
    bool endWithHttpsINT = url.toLowerCase().endsWith('0');

    return (startsWithHttp || startsWithHttps) &&
        (endWithHttpsINT ||
            endWithHttpsJPeG ||
            endWithHttpsJPG ||
            endWithHttpsPNG);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produtos'),
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['title'],
                      decoration: InputDecoration(labelText: 'Título'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) => _formData['title'] = value,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Informa um título válido';
                        }

                        if (value.trim().length < 3) {
                          return 'Titulo deve ser maior que 3 caracteres';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price'].toString(),
                      decoration: InputDecoration(labelText: 'Preço'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value),
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        var newPrice = double.tryParse(value);
                        bool isInvalid = newPrice == null || newPrice <= 0;

                        if (isEmpty || isInvalid) {
                          return 'Preço inválido';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description'],
                      decoration: InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) => _formData['description'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = value.trim().length <= 10;

                        if (isEmpty || isInvalid) {
                          return 'Descricao inválido';
                        }

                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'URL da Imagem'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageURLFocusNode,
                            controller: _imageURLController,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) => _formData['imageUrl'] = value,
                            validator: (value) {
                              if (value.trim().isEmpty ||
                                  !isValidImageUrl(value)) {
                                return 'url inválida';
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(
                            top: 8,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: _imageURLController.text.isEmpty
                              ? Text('Informe a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageURLController.text,
                                    fit: BoxFit.cover,
                                    /*Sempre é bom definir um tamanho para a imagem
                            para não gerar erro no fittedBox*/
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
