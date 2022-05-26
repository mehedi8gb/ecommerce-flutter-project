import 'package:app/src/ui/blocks/banners/banner_presets.dart';
import 'package:app/src/ui/blocks/banners/banner_top_slider.dart';
import 'package:app/src/ui/blocks/banners/top_icons.dart';
import 'package:app/src/ui/blocks/posts/post_card_list.dart';
import 'package:app/src/ui/blocks/posts/post_card_scroll.dart';
import 'package:app/src/ui/blocks/posts/post_list.dart';
import 'package:app/src/ui/blocks/posts/post_slider.dart';
import 'package:app/src/ui/blocks/products/product_grid.dart';
import 'package:app/src/ui/blocks/drawer.dart';
import 'package:app/src/ui/products/product_detail/cart_icon.dart';
import '../products/barcode_products.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../products/products/product_grid.dart';
import '../../functions.dart';
import '../../blocs/products_bloc.dart';
import '../checkout/cart/cart4.dart';
import '../home/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/app_state_model.dart';
import '../products/product_grid/product_item4.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../products/product_detail/product_detail.dart';
import '../products/products/products.dart';
import '../../models/blocks_model.dart' hide Image, Key, Theme;
import 'package:flutter/rendering.dart';
import './../../models/app_state_model.dart';
import './../../models/blocks_model.dart';
import './../../models/category_model.dart';
import './banners/banner_grid.dart';
import './banners/banner_list.dart';
import './banners/banner_scroll.dart';
import './banners/banner_slider.dart';
import './category/category_grid.dart';
import './category/category_list.dart';
import './category/category_scroll.dart';
import './category/category_slider.dart';
import './products/product_list.dart';
import './products/product_scroll.dart';
import './products/product_slider.dart';
import './stores/store_card_list.dart';
import './stores/store_card_scroll.dart';
import './stores/store_list.dart';
import './stores/store_slider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'category/category_list_tile.dart';
import 'category/category_presets.dart';

class Home2 extends StatefulWidget {
  final ProductsBloc productsBloc = ProductsBloc();
  Home2({Key? key}) : super(key: key);
  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> with TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();
  late Category selectedCategory;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.productsBloc.productsFilter['id'] = '0';
    widget.productsBloc.fetchAllProducts('0');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && !appStateModel.loadingHomeProducts) {
        appStateModel.loadMoreRecentProducts();
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse && (40 <= _scrollController.position.pixels &&
          !_scrollController.position.outOfRange)) {
        if (!_isVisible)
          setState(() {
            _isVisible = true;
          });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward && 40 >= _scrollController.position.pixels) {
        if (_isVisible)
          setState(() {
            _isVisible = false;
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
        return Scaffold(
          body: Scaffold(
            drawer: model.blocks.settings.appBarStyle.drawer ? MyDrawer() : null,
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Builder(
                builder: (context) {
                  return buildHomeTitle(context, model.blocks.settings.appBarStyle);
                }
              ),
              backgroundColor: _isVisible ? Theme.of(context).appBarTheme.color :  Colors.transparent,
              elevation: 0.0,
            ),
            body: CustomScrollView(
              controller: _scrollController,
              slivers: buildLisOfBlocks(model.blocks),
            ),
          ),
        );
      }
    );
  }


  List<Widget> buildLisOfCategoryBlocks(AsyncSnapshot<List<Product>> snapshot) {
    List<Widget> list = [];

    //list.add(addCategoryBanner());

    /// UnComment this if you use rounded corner category list in body.
    list.add(buildSubcategories());
    if (snapshot.data != null) {
      list.add(ProductGrid(products: snapshot.data!));

      list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                    height: 60,
                    child: StreamBuilder(
                        stream: widget.productsBloc.hasMoreItems,
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          return snapshot.hasData && snapshot.data == false
                              ? Container()
                              : Center(child: CircularProgressIndicator());
                        }
                      //child: Center(child: CircularProgressIndicator())
                    ))
              ]))));
    }

    return list;
  }

  Widget buildSubcategories() {
    List<Category> subCategories = appStateModel.blocks.categories
        .where((element) => element.parent == selectedCategory.id)
        .toList();
    return subCategories.length != 0
        ? SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
        height: 140,
        width: 120,
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: subCategories.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                height: 100,
                width: 100,
                child: Column(
                  children: <Widget>[
                    Card(
                      shape: StadiumBorder(),
                      margin: EdgeInsets.all(5.0),
                      clipBehavior: Clip.antiAlias,
                      elevation: 0,
                      child: InkWell(
                        onTap: () {
                          var filter = new Map<String, dynamic>();
                          filter['id'] =
                              subCategories[index].id.toString();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductsWidget(
                                      filter: filter,
                                      name: parseHtmlString(subCategories[index].name))));
                        },
                        child: Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 18 / 18,
                              child: subCategories[index].image != null
                                  ? Image.network(
                                subCategories[index].image,
                                fit: BoxFit.cover,
                              )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    InkWell(
                      onTap: () {
                        var filter = new Map<String, dynamic>();
                        filter['id'] = subCategories[index].id.toString();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductsWidget(
                                    filter: filter,
                                    name: subCategories[index].name)));
                      },
                      child: Text(
                        subCategories[index].name,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    )
        : SliverToBoxAdapter();
  }

  Widget addCategoryBanner() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 16.0, 10.0, 10.0),
        height: 170,
        width: 50,
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        child: Card(
          elevation: 0.5,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: CachedNetworkImage(
            imageUrl:
            selectedCategory.image.isNotEmpty ? selectedCategory.image : '',
            imageBuilder: (context, imageProvider) => Ink.image(
              child: InkWell(
                onTap: () => _categoryBannerClick(selectedCategory),
              ),
              image: imageProvider,
              fit: BoxFit.cover,
            ),
            placeholder: (context, url) => Container(color: Colors.black12),
            errorWidget: (context, url, error) =>
                Container(color: Colors.black12),
          ),
        ),
      ),
    );
  }

  _categoryBannerClick(Category selectedCategory) {
    var filter = new Map<String, dynamic>();
    filter['id'] = selectedCategory.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsWidget(
                filter: filter,
                name: selectedCategory.name)));

  }

  buildLisOfBlocks(BlocksModel snapshot) {
    List<Widget> list = [];

    for (var i = 0; i < snapshot.blocks.length; i++) {

      if (snapshot.blocks[i].blockType == BlockType.bannerGrid) {
        list.add(BannerGrid(block: snapshot.blocks[i]));
      }

      if (snapshot.blocks[i].blockType == BlockType.bannerList) {
        list.add(BannerList(block: snapshot.blocks[i]));
      }

      if (snapshot.blocks[i].blockType == BlockType.bannerScroll) {
        list.add(BannerScroll(block: snapshot.blocks[i]));
      }

      if (snapshot.blocks[i].blockType == BlockType.bannerSlider && i != 0) {
        list.add(BannerSlider(block: snapshot.blocks[i]));
      }

      if (snapshot.blocks[i].blockType == BlockType.bannerSlider && i == 0) {
        list.add(BannerTopSlider(block: snapshot.blocks[i]));
        list.add(ShapeIcons());
      }

      if (snapshot.blocks[i].blockType == BlockType.bannerPresets) {
        list.add(BannerPresets(block: snapshot.blocks[i]));
      }

      if (snapshot.blocks[i].blockType == BlockType.categoryGrid || snapshot.blocks[i].blockType == BlockType.categoryScroll || snapshot.blocks[i].blockType == BlockType.categoryList || snapshot.blocks[i].blockType == BlockType.categorySlider || snapshot.blocks[i].blockType == BlockType.categoryListTile || snapshot.blocks[i].blockType == BlockType.categoryPresets) {
        List<Category> categories = snapshot.categories.where((cat) => cat.parent == snapshot.blocks[i].linkId).toList();
        if(categories.length > 0) {
          if (snapshot.blocks[i].blockType == BlockType.categoryGrid) {
            list.add(CategoryGrid(block: snapshot.blocks[i], categories: categories));
          }

          if (snapshot.blocks[i].blockType == BlockType.categoryList) {
            list.add(CategoryList(block: snapshot.blocks[i], categories: categories));
          }

          if (snapshot.blocks[i].blockType == BlockType.categoryScroll) {
            list.add(CategoryScroll(block: snapshot.blocks[i], categories: categories));

          }

          if (snapshot.blocks[i].blockType == BlockType.categorySlider) {
            list.add(CategorySlider(block: snapshot.blocks[i], categories: categories));
          }

          if (snapshot.blocks[i].blockType == BlockType.categoryListTile) {
            list.add(CategoryListTile(block: snapshot.blocks[i], categories: categories));
          }

          if (snapshot.blocks[i].blockType == BlockType.categoryPresets) {
            list.add(CategoryPresets(block: snapshot.blocks[i], categories: categories));
          }
        }
      }

      if (snapshot.blocks[i].blockType == BlockType.brandGrid || snapshot.blocks[i].blockType == BlockType.brandScroll || snapshot.blocks[i].blockType == BlockType.brandList || snapshot.blocks[i].blockType == BlockType.brandSlider || snapshot.blocks[i].blockType == BlockType.brandListTile || snapshot.blocks[i].blockType == BlockType.brandPresets) {
        List<Category> categories = snapshot.brands.where((cat) => cat.parent == snapshot.blocks[i].linkId).toList();
        if(categories.length > 0) {
          if (snapshot.blocks[i].blockType == BlockType.brandGrid) {
            list.add(CategoryGrid(block: snapshot.blocks[i], categories: categories, type: 'brand'));
          }

          if (snapshot.blocks[i].blockType == BlockType.brandList) {
            list.add(CategoryList(block: snapshot.blocks[i], categories: categories, type: 'brand'));
          }

          if (snapshot.blocks[i].blockType == BlockType.brandScroll) {
            list.add(CategoryScroll(block: snapshot.blocks[i], categories: categories, type: 'brand'));
          }

          if (snapshot.blocks[i].blockType == BlockType.brandSlider) {
            list.add(CategorySlider(block: snapshot.blocks[i], categories: categories, type: 'brand'));
          }

          if (snapshot.blocks[i].blockType == BlockType.brandListTile) {
            list.add(CategoryListTile(block: snapshot.blocks[i], categories: categories, type: 'brand'));
          }

          if (snapshot.blocks[i].blockType == BlockType.brandPresets) {
            list.add(CategoryPresets(block: snapshot.blocks[i], categories: categories, type: 'brand'));
          }
        }
      }

      if (snapshot.blocks[i].posts.length > 0) {
        if (snapshot.blocks[i].blockType == BlockType.postList) {
          list.add(PostCard(posts: snapshot.blocks[i].posts, block: snapshot.blocks[i]));
        }

        if (snapshot.blocks[i].blockType == BlockType.postListTile) {
          list.add(PostList(posts: snapshot.blocks[i].posts, block: snapshot.blocks[i]));
        }

        if (snapshot.blocks[i].blockType == BlockType.postScroll) {
          list.add(PostCardScroll(posts: snapshot.blocks[i].posts, block: snapshot.blocks[i]));
        }

        if (snapshot.blocks[i].blockType == BlockType.postSlider) {
          list.add(PostSlider(posts: snapshot.blocks[i].posts, block: snapshot.blocks[i]));
        }
      }

      if (snapshot.blocks[i].stores.length > 0) {
        if (snapshot.blocks[i].blockType == BlockType.storeList) {
          list.add(StoreCard(stores: snapshot.blocks[i].stores, block: snapshot.blocks[i]));
        }

        if (snapshot.blocks[i].blockType == BlockType.storeListTile) {
          list.add(StoreList(stores: snapshot.blocks[i].stores, block: snapshot.blocks[i]));
        }

        if (snapshot.blocks[i].blockType == BlockType.storeScroll) {
          list.add(StoreCardScroll(stores: snapshot.blocks[i].stores, block: snapshot.blocks[i]));
        }

        if (snapshot.blocks[i].blockType == BlockType.storeSlider) {
          list.add(StoreSlider(stores: snapshot.blocks[i].stores, block: snapshot.blocks[i]));
        }
      }

      if (snapshot.blocks[i].products.length > 0) {

        if (snapshot.blocks[i].blockType == BlockType.productGrid) {
          list.add(ProductBlockGrid(products: snapshot.blocks[i].products, block: snapshot.blocks[i]));
        }

        if (snapshot.blocks[i].blockType == BlockType.productList) {
          list.add(ProductList(products: snapshot.blocks[i].products, block: snapshot.blocks[i]));
        }

        if (snapshot.blocks[i].blockType == BlockType.productScroll) {
          list.add(ProductCardScroll(products: snapshot.blocks[i].products, block: snapshot.blocks[i]));
        }

        if (snapshot.blocks[i].blockType == BlockType.productSlider) {
          list.add(ProductSlider(products: snapshot.blocks[i].products, block: snapshot.blocks[i]));
        }
      }

    }

    return list;
  }

  Widget buildRecentProductGridList(BlocksModel snapshot) {
    return SliverStaggeredGrid.count(
      crossAxisCount: 4,
      children: snapshot.recentProducts.map<Widget>((item) {
        return ProductItemCard(product: item);
      }).toList(),
      staggeredTiles: snapshot.recentProducts.map<StaggeredTile>((_) => StaggeredTile.fit(2))
          .toList(),
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
    );
  }

  onProductClick(product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(
        product: product
      );
    }));
  }

  onCategoryClick(Category category, List<Category> categories) {
    var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsWidget(
                filter: filter,
                name: category.name)));
  }

  Widget buildHomeTitle(BuildContext context, AppBarStyle appBarStyle) {
    switch ('STYLE1') {
      case 'STYLE1':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if(appBarStyle.drawer)
            Container(
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Icon(
                  Icons.reorder,
                  //color: (Theme.of(context).appBarTheme.backgroundColor == Colors.white || Theme.of(context).appBarTheme.iconTheme == null ) ? Theme.of(context).hintColor : Theme.of(context).appBarTheme.iconTheme!.color, //Theme.of(context).primaryIconTheme.color,Theme.of(context).hintColor,
                ),
              ),
            ),
            if(!appBarStyle.drawer)
              Container(
              child: InkWell(
                onTap: () => _scanBarCode(),
                child: Icon(
                  CupertinoIcons.barcode_viewfinder,
                  //color: (Theme.of(context).appBarTheme.backgroundColor == Colors.white || Theme.of(context).appBarTheme.iconTheme == null ) ? Theme.of(context).hintColor : Theme.of(context).appBarTheme.iconTheme!.color, //Theme.of(context).primaryIconTheme.color,Theme.of(context).hintColor,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  enableFeedback: false,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Search();
                    }));
                  },
                  child: Stack(
                    children: [
                      TextField(
                        showCursor: false,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: appStateModel.blocks.localeText.searchProducts,
                          hintStyle: TextStyle(
                            fontSize: 16,
                          ),
                          fillColor: Theme.of(context).appBarTheme.backgroundColor.toString() == 'Color(0xffffffff)' ? Theme.of(context).inputDecorationTheme.fillColor : Theme.of(context).brightness == Brightness.dark ? Theme.of(context).inputDecorationTheme.fillColor : Colors.white,
                          filled: true,
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Theme.of(context).focusColor,
                              width: 0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Theme.of(context).focusColor,
                              width: 0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Theme.of(context).focusColor,
                              width: 0,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(6),
                          prefixIcon: Icon(
                            CupertinoIcons.search,
                            size: 18,
                          ),
                        ),
                      ),
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        end: 0,
                        top: -4,
                        child: appBarStyle.drawer && appBarStyle.barcode ? IgnorePointer(
                          ignoring: false,
                          child: IconButton(
                              onPressed: () {
                                _scanBarCode();
                              },icon: Icon(CupertinoIcons.barcode_viewfinder, color: Theme.of(context).disabledColor,)
                          ),
                        ) : Container(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            CartIcon(),
          ],
        );
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Uncomment this comment search bar, If you want to put a logo instead of search bar
            /*Expanded(
          child: Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Image.asset('lib/assets/images/logo.png'),
          ),
        ),*/
            Container(
              child: InkWell(
                onTap: () => _scanBarCode(),
                child: Icon(
                  CupertinoIcons.barcode_viewfinder,
                  //color: (Theme.of(context).appBarTheme.backgroundColor == Colors.white || Theme.of(context).appBarTheme.iconTheme == null ) ? Theme.of(context).hintColor : Theme.of(context).appBarTheme.iconTheme!.color, //Theme.of(context).primaryIconTheme.color,Theme.of(context).hintColor,
                ),
              ),
            ),
            /*Container(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Account(),
                    fullscreenDialog: true,
                  ));
            },
            child: Icon(
              MStoreIcons.account_circle_line,
              color: Theme.of(context).appBarTheme.backgroundColor.toString() == 'Color(0xffffffff)' ? Theme.of(context).hintColor : Theme.of(context).primaryIconTheme.color, //Theme.of(context).primaryIconTheme.color,Theme.of(context).hintColor,
            ),
          ),
        ),*/
            Expanded(
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  enableFeedback: false,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Search();
                    }));
                  },
                  child: TextField(
                    showCursor: false,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: appStateModel.blocks.localeText.searchProducts,
                      hintStyle: TextStyle(
                        fontSize: 16,

                      ),
                      fillColor: Theme.of(context).appBarTheme.backgroundColor.toString() == 'Color(0xffffffff)' ? Theme.of(context).inputDecorationTheme.fillColor : Theme.of(context).brightness == Brightness.dark ? Theme.of(context).inputDecorationTheme.fillColor : Colors.white,
                      filled: true,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Theme.of(context).focusColor,
                          width: 0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Theme.of(context).focusColor,
                          width: 0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Theme.of(context).focusColor,
                          width: 0,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(6),
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            CartIcon(),
            /*InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Search();
            }));
          },
          child: Icon(FlutterIcons.search_fea),
        )*/
          ],
        );
    }
  }

  _scanBarCode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    if(barcodeScanRes != '-1'){
      showDialog(builder: (context) => FindBarCodeProduct(result: barcodeScanRes, context: context), context: context);
    }
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
