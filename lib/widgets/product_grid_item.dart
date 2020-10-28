import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final theme = Theme.of(context);
    /*
    * Recebe o produto via provider
    * Com o listen false, ele recebe os produtos mas não fica "escutando" as
    * alterações em tempo real. Para receber as alterações é necessário envolver
    * o Iwdget com um Consumer; 
    * */

    final Product product = Provider.of(context, listen: false);
    final Cart cart = Provider.of(context, listen: false);
    final Auth auth = Provider.of(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_outline),
              onPressed: () {
                product.toggleFavorite(auth.token, auth.userId).catchError((onError) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(onError.toString()),
                      backgroundColor: theme.errorColor,
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Produto adicionado com sucesso!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'DESFAZER',
                  onPressed: (){
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
