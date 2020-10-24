import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';

class OrderBUtton extends StatefulWidget {
  const OrderBUtton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderBUttonState createState() => _OrderBUttonState();
}

class _OrderBUttonState extends State<OrderBUtton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('COMPRAR'),
      textColor: Theme.of(context).primaryColor,
      /*Marca que o retorno do onPresse é async e vai ter algo que pode demorar a acontecer*/
      onPressed: widget.cart.itemsCount == 0 ? null : () async {

        /*Habilita loagind*/
        setState(() {
          _isLoading = true;
        });
        /*Processa pedido no servidor*/
        await Provider.of<Orders>(context, listen: false).addOrder(widget.cart);
        /*Caso tudo ok, remove loading*/
        setState(() {
          _isLoading = false;
        });
        widget.cart.clear();
      },
    );
  }
}