import 'package:app/src/blocs/blocks_bloc.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/blocks_model.dart';
import 'package:app/src/models/category_model.dart';
import 'package:app/src/ui/blocks/banners/banner_grid.dart';
import 'package:app/src/ui/blocks/banners/banner_list.dart';
import 'package:app/src/ui/blocks/banners/banner_presets.dart';
import 'package:app/src/ui/blocks/banners/banner_scroll.dart';
import 'package:app/src/ui/blocks/banners/banner_slider.dart';
import 'package:app/src/ui/blocks/category/category_grid.dart';
import 'package:app/src/ui/blocks/category/category_list.dart';
import 'package:app/src/ui/blocks/category/category_list_tile.dart';
import 'package:app/src/ui/blocks/category/category_presets.dart';
import 'package:app/src/ui/blocks/category/category_scroll.dart';
import 'package:app/src/ui/blocks/category/category_slider.dart';
import 'package:app/src/ui/blocks/posts/post_card_list.dart';
import 'package:app/src/ui/blocks/posts/post_card_scroll.dart';
import 'package:app/src/ui/blocks/posts/post_list.dart';
import 'package:app/src/ui/blocks/posts/post_slider.dart';
import 'package:app/src/ui/blocks/products/product_grid.dart';
import 'package:app/src/ui/blocks/products/product_list.dart';
import 'package:app/src/ui/blocks/products/product_scroll.dart';
import 'package:app/src/ui/blocks/products/product_slider.dart';
import 'package:app/src/ui/blocks/stores/store_card_scroll.dart';
import 'package:app/src/ui/blocks/stores/store_slider.dart';
import 'package:app/src/ui/vendor/ui/stores/store_list/store_card_list.dart';
import 'package:app/src/ui/vendor/ui/stores/store_list/store_list.dart';
import 'package:flutter/material.dart';

class BlockPage extends StatefulWidget {
  final Child child;
  final blocksBloc = BlocksBloc();

  BlockPage({Key? key, required this.child}) : super(key: key);
  @override
  _BlockPageState createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {

  @override
  void initState() {
    widget.blocksBloc.getBlocks(widget.child.linkId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.child.title),
      ),
      body: StreamBuilder<List<Block>>(
        stream: widget.blocksBloc.allBlocks,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.length > 0) {
            return CustomScrollView(
              slivers: buildAllLisOfBlocks(snapshot.data!),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }

  buildAllLisOfBlocks(List<Block> blocks) {
    List<Widget> list = [];

    AppStateModel appStateModel = AppStateModel();

    for (var i = 0; i < blocks.length; i++) {

      if (blocks[i].blockType == BlockType.bannerGrid) {
        list.add(BannerGrid(block: blocks[i]));
      }

      if (blocks[i].blockType == BlockType.bannerList) {
        list.add(BannerList(block: blocks[i]));
      }

      if (blocks[i].blockType == BlockType.bannerScroll) {
        list.add(BannerScroll(block: blocks[i]));
      }

      if (blocks[i].blockType == BlockType.bannerSlider) {
        list.add(BannerSlider(block: blocks[i]));
      }

      if (blocks[i].blockType == BlockType.bannerPresets) {
        list.add(BannerPresets(block: blocks[i]));
      }

      if (blocks[i].blockType == BlockType.categoryGrid || blocks[i].blockType == BlockType.categoryScroll || blocks[i].blockType == BlockType.categoryList || blocks[i].blockType == BlockType.categorySlider || blocks[i].blockType == BlockType.categoryListTile || blocks[i].blockType == BlockType.categoryPresets) {
        List<Category> categories = appStateModel.blocks.categories.where((cat) => cat.parent == blocks[i].linkId).toList();
        if(categories.length > 0) {
          if (blocks[i].blockType == BlockType.categoryGrid) {
            list.add(CategoryGrid(block: blocks[i], categories: categories));
          }

          if (blocks[i].blockType == BlockType.categoryList) {
            list.add(CategoryList(block: blocks[i], categories: categories));
          }

          if (blocks[i].blockType == BlockType.categoryScroll) {
            list.add(CategoryScroll(block: blocks[i], categories: categories));

          }

          if (blocks[i].blockType == BlockType.categorySlider) {
            list.add(CategorySlider(block: blocks[i], categories: categories));
          }

          if (blocks[i].blockType == BlockType.categoryListTile) {
            list.add(CategoryListTile(block: blocks[i], categories: categories));
          }

          if (blocks[i].blockType == BlockType.categoryPresets) {
            list.add(CategoryPresets(block: blocks[i], categories: categories));
          }
        }
      }

      if (blocks[i].blockType == BlockType.brandGrid || blocks[i].blockType == BlockType.brandScroll || blocks[i].blockType == BlockType.brandList || blocks[i].blockType == BlockType.brandSlider || blocks[i].blockType == BlockType.brandListTile || blocks[i].blockType == BlockType.brandPresets) {
        List<Category> categories = appStateModel.blocks.brands.where((cat) => cat.parent == blocks[i].linkId).toList();
        if(categories.length > 0) {
          if (blocks[i].blockType == BlockType.brandGrid) {
            list.add(CategoryGrid(block: blocks[i], categories: categories, type: 'brand'));
          }

          if (blocks[i].blockType == BlockType.brandList) {
            list.add(CategoryList(block: blocks[i], categories: categories, type: 'brand'));
          }

          if (blocks[i].blockType == BlockType.brandScroll) {
            list.add(CategoryScroll(block: blocks[i], categories: categories, type: 'brand'));
          }

          if (blocks[i].blockType == BlockType.brandSlider) {
            list.add(CategorySlider(block: blocks[i], categories: categories, type: 'brand'));
          }

          if (blocks[i].blockType == BlockType.brandListTile) {
            list.add(CategoryListTile(block: blocks[i], categories: categories, type: 'brand'));
          }

          if (blocks[i].blockType == BlockType.brandPresets) {
            list.add(CategoryPresets(block: blocks[i], categories: categories, type: 'brand'));
          }
        }
      }

      if (blocks[i].posts.length > 0) {
        if (blocks[i].blockType == BlockType.postList) {
          list.add(PostCard(posts: blocks[i].posts, block: blocks[i]));
        }

        if (blocks[i].blockType == BlockType.postListTile) {
          list.add(PostList(posts: blocks[i].posts, block: blocks[i]));
        }

        if (blocks[i].blockType == BlockType.postScroll) {
          list.add(PostCardScroll(posts: blocks[i].posts, block: blocks[i]));
        }

        if (blocks[i].blockType == BlockType.postSlider) {
          list.add(PostSlider(posts: blocks[i].posts, block: blocks[i]));
        }
      }

      if (blocks[i].stores.length > 0) {
        if (blocks[i].blockType == BlockType.storeList) {
          list.add(StoreCard(stores: blocks[i].stores, block: blocks[i]));
        }

        if (blocks[i].blockType == BlockType.storeListTile) {
          list.add(StoreList(stores: blocks[i].stores, block: blocks[i]));
        }

        if (blocks[i].blockType == BlockType.storeScroll) {
          list.add(StoreCardScroll(stores: blocks[i].stores, block: blocks[i]));
        }

        if (blocks[i].blockType == BlockType.storeSlider) {
          list.add(StoreSlider(stores: blocks[i].stores, block: blocks[i]));
        }
      }

      if (blocks[i].products.length > 0) {

        if (blocks[i].blockType == BlockType.productGrid) {
          list.add(ProductBlockGrid(products: blocks[i].products, block: blocks[i]));
        }

        if (blocks[i].blockType == BlockType.productList) {
          list.add(ProductList(products: blocks[i].products, block: blocks[i]));
        }

        if (blocks[i].blockType == BlockType.productScroll) {
          list.add(ProductCardScroll(products: blocks[i].products, block: blocks[i]));
        }

        if (blocks[i].blockType == BlockType.productSlider) {
          list.add(ProductSlider(products: blocks[i].products, block: blocks[i]));
        }

      }

    }

    return list;
  }
}



