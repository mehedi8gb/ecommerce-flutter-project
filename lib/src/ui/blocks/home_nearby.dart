import 'package:app/src/ui/blocks/banners/banner_presets.dart';
import 'package:app/src/ui/blocks/block_page.dart';
import 'package:app/src/ui/blocks/place_selector.dart';
import 'package:app/src/ui/blocks/posts/post_card_list.dart';
import 'package:app/src/ui/blocks/posts/post_card_scroll.dart';
import 'package:app/src/ui/blocks/posts/post_list.dart';
import 'package:app/src/ui/blocks/posts/post_slider.dart';
import 'package:app/src/ui/blocks/products/product_grid.dart';
import 'package:app/src/ui/blocks/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './../../ui/products/products/product_grid.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../ui/blocks/app_bar.dart';
import 'category/category_presets.dart';
import './../../models/category_model.dart';
import './../../models/vendor/store_state_model.dart';
import './../../ui/home/place_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../models/app_state_model.dart';
import './../../models/blocks_model.dart';
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
import 'package:flutter/cupertino.dart';

import 'category/category_list_tile.dart';

class HomeNearBy extends StatefulWidget {
  final Map<String, dynamic>? filter;
  final StoreStateModel model = StoreStateModel();

  HomeNearBy({Key? key, this.filter}) : super(key: key);

  @override
  _HomeNearByState createState() => _HomeNearByState();
}

class _HomeNearByState extends State<HomeNearBy> {
  ScrollController _scrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();
  @override
  void initState() {
    super.initState();
    /*if (widget.filter != null) {
      widget.model.filter = widget.filter!;
    }
    widget.model.getAllStores();*/
    _scrollController.addListener(_loadMoreItems);
  }

  _loadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && !appStateModel.loadingHomeProducts) {
        appStateModel.loadMoreRecentProducts();
      }
    });

  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMoreItems);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppStateModel().blocks.settings.appBarStyle.drawer ? MyDrawer() : null,
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            return (model.blocks.blocks.isNotEmpty || model.blocks.recentProducts.isNotEmpty) ? CustomScrollView(
              controller: _scrollController,
              slivers: buildLisOfBlocks(model.blocks),
            ): CustomScrollView(
              slivers: [
                buildSliverAppBar(),
                SliverToBoxAdapter(child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(child: CircularProgressIndicator()),
                )),
              ],
            );
          }
      ),
    );
  }

  SliverAppBar buildSliverAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      floating: true,
      snap: false,
      titleSpacing: 0,
      elevation: 1.0,
      centerTitle: false,
      title: Container(),
    );
  }

  _onTapAddress() async {
    if(appStateModel.blocks.settings.customLocation) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PlaceSelector();
      }));
    } else {
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PlacePickerHome();
      }));
      setState(() {});
      /*widget.model.getAllStores();*/
      await appStateModel.updateAllBlocks();
      setState(() {});
    }
  }


  buildLisOfBlocks(BlocksModel snapshot) {
    List<Widget> list = [];

    list.add(CustomSliverAppBar(appBarStyle: snapshot.settings.appBarStyle, onTapAddress: _onTapAddress));

    //list.addAll(buildAllLisOfBlocks(snapshot.blocks));

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

      if (snapshot.blocks[i].blockType == BlockType.bannerSlider) {
        list.add(BannerSlider(block: snapshot.blocks[i]));
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
            list.add(CategoryGrid(block: snapshot.blocks[i], categories: categories));
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

    if (snapshot.recentProducts != null && snapshot.recentProducts.length > 0 && snapshot.settings.homePageProducts) {
      list.add(buildRecentProductGridList(snapshot));
      list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                    height: 60,
                    child: ScopedModelDescendant<AppStateModel>(
                        builder: (context, child, model) {
                          if (model.blocks.recentProducts.length > 0 && model.hasMoreRecentItem == false) {
                            return Center(
                              child: Text(
                                model.blocks.localeText.noMoreProducts,
                              ),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }))
              ]))));
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


}
