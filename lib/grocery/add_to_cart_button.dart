import 'package:app/grocery/grouped_poducts.dart';
import 'package:app/grocery/shopping_cart.dart';
import 'package:app/grocery/variations.dart';
import 'package:app/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class AddToCartButton extends StatefulWidget {
  AddToCartButton({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {

    return context.watch<ShoppingCart>().cart.cartContents.any((element) => element.productId == widget.product.id) ? ButtonBar(
      alignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      buttonPadding: EdgeInsets.all(0),
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: new ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4)),
              ),
              padding: EdgeInsets.all(0),
              elevation: 0,
              //primary: Colors.grey.withOpacity(0.3),
              //onPrimary: isDark ? Colors.white : Colors.black,
            ),
            child: new Icon(Icons.remove, size: 18),
            onPressed: () async {
              if(widget.product.type == 'grouped' || widget.product.type == 'variable') {
                _bottomSheet(context);
              } else {
                setState(() {
                  loading = true;
                });
                await context.read<ShoppingCart>().decreaseQty(context, widget.product.id);
                setState(() {
                  loading = false;
                });
              }
            },
          ),
        ),
        SizedBox(
          height: 30,
          width: 30,
          child: new ElevatedButton(
            //elevation: 0,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              padding: EdgeInsets.all(0),
              elevation: 0,
              //primary: Theme.of(context).buttonColor
            ),
            child: loading ? SizedBox(
              child: CircularProgressIndicator(strokeWidth: 2, valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.of(context)
                      .buttonTheme
                      .colorScheme!
                      .onPrimary)),
              height: 16.0,
              width: 16.0,
            ) :  SizedBox(
              width: 20.0,
              child: Text(
                context.read<ShoppingCart>().cart.cartContents.firstWhere((element) => element.productId == widget.product.id).quantity.toString(), textAlign: TextAlign.center,
              ),
            ),
            onPressed: () {

            },
          ),
        ),
        SizedBox(
          height: 30,
          width: 30,
          child: new ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4)),
              ),
              padding: EdgeInsets.all(0),
              elevation: 0,
              //primary: Theme.of(context).buttonColor
            ),
            child: new Icon(Icons.add, size: 18),
            onPressed: () async {
              if(widget.product.type == 'grouped' || widget.product.type == 'variable') {
              _bottomSheet(context);
              } else {
                setState(() {
                  loading = true;
                });
                await context.read<ShoppingCart>().increaseQty(context, widget.product.id);
                setState(() {
                  loading = false;
                });
              }
            },
          ),
        ),
      ],
    ) : Center(
      child: Container(
        height: 30,
        //width: 30,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(80, 20),
            elevation: 0,
            //primary: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
          ),
          onPressed: () async {
            if(widget.product.type == 'grouped' || widget.product.type == 'variable') {
              _bottomSheet(context);
            } else {
              setState(() {
                loading = true;
              });
              await context.read<ShoppingCart>().addToCart(context, productId: widget.product.id);
              setState(() {
                loading = false;
              });
            }
          },
          child: loading ? SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2, valueColor: new AlwaysStoppedAnimation<Color>(
                Theme.of(context)
                    .buttonTheme
                    .colorScheme!
                    .onPrimary)),
            height: 16.0,
            width: 16.0,
          ) : Text('ADD', style: TextStyle(fontSize: 12),),
        ),
      ),
    );


    return context.watch<ShoppingCart>().cart.cartContents.any((element) => element.productId == widget.product.id) ? Padding(
      padding: const EdgeInsets.all(0.0),
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        buttonPadding: EdgeInsets.all(0), // this will take space as minimum as posible(to center)
        children: <Widget>[
          SizedBox(
            height: 30,
            width: 40,
            child: new ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                padding: EdgeInsets.all(0),
                elevation: 0,
                //primary: Colors.grey.withOpacity(0.3),
                //onPrimary: isDark ? Colors.white : Colors.black,
              ),
              child: new Icon(Icons.remove, size: 18),
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await context.read<ShoppingCart>().decreaseQty(context, widget.product.id);
                setState(() {
                  loading = false;
                });
              },
            ),
          ),
          SizedBox(
            height: 30,
            width: 30,
            child: new TextButton(
              //elevation: 0,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                padding: EdgeInsets.all(0),
                elevation: 0,
                //primary: Theme.of(context).buttonColor
              ),
              child: loading ? SizedBox(
                child: CircularProgressIndicator(strokeWidth: 2),
                height: 16.0,
                width: 16.0,
              ) :  SizedBox(
                width: 20.0,
                child: Text(
                  context.read<ShoppingCart>().cart.cartContents.singleWhere((element) => element.productId == widget.product.id).quantity.toString(), textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              onPressed: () {

              },
            ),
          ),
          SizedBox(
            height: 30,
            width: 40,
            child: new ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                padding: EdgeInsets.all(0),
                elevation: 0,
                //primary: Theme.of(context).buttonColor
              ),
              child: new Icon(Icons.add, size: 18),
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await context.read<ShoppingCart>().increaseQty(context, widget.product.id);
                setState(() {
                  loading = false;
                });
              },
            ),
          ),
        ],
      ),
    ) : Align(
      alignment: Alignment.bottomCenter,
      child: Center(
        child: Container(
          height: 30,
          //width: 30,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(30),
              elevation: 0,
              //primary: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
              ),
            ),
            onPressed: () async {
              setState(() {
                loading = true;
              });
              await context.read<ShoppingCart>().addToCart(context, productId: widget.product.id);
              setState(() {
                loading = false;
              });
            },
            child: loading ? SizedBox(
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white,),
              height: 12.0,
              width: 12.0,
            ) : Text('ADD'),
          ),
        ),
      ),
    );
  }

  void _bottomSheet(BuildContext cnt) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          //color: Colors.amber,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        child: Text(widget.product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                if (widget.product.type == 'variable') Expanded(
                  child: ListView.builder
                    (
                      itemCount: widget.product.availableVariations.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return VariationProduct(context: cnt, id: widget.product.id, variation: widget.product.availableVariations[Index]);
                      }
                  ),
                ) else widget.product.children.length > 0 ? Expanded(
                  child: ListView.builder
                    (
                      itemCount: widget.product.children.length,
                      itemBuilder: (BuildContext cntx, int Index) {
                        return GroupedProduct(context: cntx, id: widget.product.id, product: widget.product.children[Index]);
                      }
                  ),
                ) : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}