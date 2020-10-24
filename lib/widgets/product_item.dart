import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Remover Produto'),
                    content: Text('Deseja realmente remover este Produtor?'),
                    actions: [
                      FlatButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text('Cancelar'),
                      ),
                      FlatButton(
                        child: Text('Sim'),
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ],
                  ),
                ).then((value) async {
                  scaffold.hideCurrentSnackBar();
                  if (value) {
                    try{
                      await Provider.of<Products>(context, listen: false)
                          .deleteProduct(product.id);
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text('Produto removido com sucesso!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } catch (error){
                      /*
                      * Scafflod e theme devem ser declaradas fora do await,
                      * pois dentro não tem mais acesso ao contexto da aplicação
                      * */
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                          backgroundColor: theme.errorColor,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }

                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
