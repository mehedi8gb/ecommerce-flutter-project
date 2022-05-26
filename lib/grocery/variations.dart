import 'package:app/grocery/variation_add_to_cart_button.dart';
import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VariationProduct extends StatefulWidget {

  VariationProduct({
    Key? key,
    required this.id,
    required this.variation,
    required this.context
  }) : super(key: key);

  final int id;
  final AvailableVariation variation;
  final BuildContext context;
  final model = AppStateModel();

  @override
  _VariationProductState createState() => _VariationProductState();
}

class _VariationProductState extends State<VariationProduct> {

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: leadingIcon(),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(parseHtmlString(getTitle())),
          SizedBox(height: 4),
          _variationPrice()
        ],
      ),
      trailing: SizedBox(width: 120, child: VariationAddToCartButton(context: widget.context, id: widget.id, variation: widget.variation)),
    );
  }

  getTitle() {
    var name = '';
    for (var value in widget.variation.option) {
      if(value.value != null)
        name = name + value.value + ' ';
    }
    return name;
  }

  Container leadingIcon() {
    return Container(
      width: 45,
      height: 45,
      child: CachedNetworkImage(
        imageUrl: widget.variation.image.url.isNotEmpty ? widget.variation.image.url : '',
        imageBuilder: (context, imageProvider) => Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          margin: EdgeInsets.all(0.0),
          //shape: StadiumBorder(),
          child: Ink.image(
            child: InkWell(
              onTap: () {
                //onCategoryClick(category);
              },
            ),
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
        placeholder: (context, url) => Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          //shape: StadiumBorder(),
        ),
        errorWidget: (context, url, error) => Card(
          elevation: 0.0,
          color: Colors.white,
          //shape: StadiumBorder(),
        ),
      ),
    );
  }

  _variationPrice() {
    if(widget.variation.formattedPrice != null && widget.variation.formattedSalesPrice == null) {
      return Text(parseHtmlString(widget.variation.formattedPrice!), style: TextStyle(
        fontWeight: FontWeight.w600,
      ));
    } else if(widget.variation.formattedPrice != null && widget.variation.formattedSalesPrice != null) {
      return Row(
        children: [
          Text(parseHtmlString(widget.variation.formattedSalesPrice!), style: TextStyle(
            fontWeight: FontWeight.w600,
          )),
          SizedBox(width: 4),
          Text(parseHtmlString(widget.variation.formattedPrice!), style: TextStyle(
              fontSize: 10,
              decoration: TextDecoration.lineThrough
          )),
        ],
      );
    }
  }
}