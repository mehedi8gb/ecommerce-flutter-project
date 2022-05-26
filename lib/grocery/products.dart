import 'package:app/grocery/shopping_cart.dart';
import 'package:app/src/blocs/products_bloc.dart';
import 'package:app/src/models/product_model.dart';
import 'package:app/src/ui/products/product_grid/products_widgets/grouped_products.dart';
import 'package:app/src/ui/products/product_grid/products_widgets/variations_products.dart';
import 'package:flutter/material.dart';
import 'package:app/src/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'add_to_cart_button.dart';

class GroceryProductsScroll extends StatefulWidget {
  final ProductsBloc productsBloc = ProductsBloc();
  final Map<String, dynamic> filter;
  final String? name;
  GroceryProductsScroll({Key? key, required this.filter, this.name}) : super(key: key);
  @override
  State<GroceryProductsScroll> createState() => _GroceryProductsScrollState();
}

class _GroceryProductsScrollState extends State<GroceryProductsScroll> {

  @override
  void initState() {
    super.initState();
    if(widget.filter['id'] == null) {
      widget.filter['id'] = '0';
    }
    widget.productsBloc.productsFilter = widget.filter;

    widget.productsBloc.fetchAllProducts(widget.productsBloc.productsFilter['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Producrs'),
      ),
      body: StreamBuilder(
          stream: widget.productsBloc.allProducts,
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      height: 230,
                      child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 1.9,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SingleProduct(product: snapshot.data![index]);
                          }
                      ),
                    ))
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
      ),
    );
  }
}

class GroceryProductsGrid extends StatefulWidget {
  final ProductsBloc productsBloc = ProductsBloc();
  final Map<String, dynamic> filter;
  final String? name;
  GroceryProductsGrid({Key? key, required this.filter, this.name}) : super(key: key);
  @override
  State<GroceryProductsGrid> createState() => _GroceryProductsGridState();
}

class _GroceryProductsGridState extends State<GroceryProductsGrid> {

  @override
  void initState() {
    super.initState();
    if(widget.filter['id'] == null) {
      widget.filter['id'] = '0';
    }
    widget.productsBloc.productsFilter = widget.filter;

    widget.productsBloc.fetchAllProducts(widget.productsBloc.productsFilter['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Producrs'),
      ),
      body: StreamBuilder(
          stream: widget.productsBloc.allProducts,
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
              return CustomScrollView(
                slivers: [
                  SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.55,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return SingleProduct(product: snapshot.data![index]);
                        },
                        childCount: snapshot.data!.length,
                      ),
                  ),
                ],
              );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}

class SingleProduct extends StatelessWidget {

  final Product product;

  const SingleProduct({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    int percentOff = 0;
    if ((!product.salePrice.isNaN && product.salePrice != 0)) {
      percentOff = (((product.regularPrice - product.salePrice) / product.regularPrice) * 100).round();
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        /*side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 0,
        ),*/
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(imageUrl: product.images[0].src),
                  percentOff != 0 ? Positioned(
                    top: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Card(elevation: 0, color: Theme.of(context).colorScheme.secondary, child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                        child: Text(percentOff.toString() + '% OFF', style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.onSecondary
                        ),),
                      ),),
                    ),
                  ) : Container(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Wrap(
                  children: [
                    product.salePrice != 0 ? Text(parseHtmlString(product.formattedSalesPrice!), style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12
                    )) : Text(parseHtmlString(product.formattedPrice!), style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12
                    )),
                    SizedBox(width: 2),
                    if(product.salePrice != 0)
                      Text(parseHtmlString(product.formattedPrice!), style: Theme.of(context).textTheme.caption!.copyWith(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 10
                      )),
                  ],
                ),
              ),
              //Spacer(),
              SizedBox(height: 4),
              AddToCartButton(product: product)
            ],
          ),
        ],
      ),
    );
  }
}





