import 'package:flutter/material.dart';
import '../convert/price_convert.dart';
import 'package:provider/provider.dart';

// MODELS
import '../models/DAO/user_dao.dart';
import '../models/export_models.dart';
import '../repository/MemFavRepos.dart';

//SERVICES
import '../repository/MemCartRepos.dart';
import '../services/category_items_api.dart';
import 'items/product_card.dart';
import '../services/product_api.dart';
import '../services/ratings api.dart';

//CONVERT
import '../convert/avg_ratings.dart';



class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const urlPrimary = 'https://cryptic-caverns-40086.herokuapp.com/';

  @override
  Widget build(BuildContext context) {
    final pid = ModalRoute.of(context)!.settings.arguments as String;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Chi tiết sản phẩm',
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: const IconThemeData(
              color: Colors.green,
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Expanded(
                child: FutureBuilder(
                    future: ProductApi.getProductDetails(pid),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          var data = snapshot.data['data'];
                          Product product = Product.fromJson(data);
                          return ListView(
                            primary: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              buildHeadingProductDetails(product),
                              const SizedBox(
                                height: 20,
                              ),
                              buildFavoriteButton(context, product),
                              const SizedBox(
                                height: 20,
                              ),
                              Divider(color: Colors.grey[300], thickness: 6),
                              const SizedBox(
                                height: 12,
                              ),
                              buildRelativeProducts(),
                              const SizedBox(
                                height: 20,
                              ),
                              Divider(color: Colors.grey[300], thickness: 6),
                              const SizedBox(
                                height: 12,
                              ),
                              buildProductDetails(product.details!),
                              const SizedBox(
                                height: 20,
                              ),
                              Divider(color: Colors.grey[300], thickness: 6),
                              const SizedBox(
                                height: 12,
                              ),
                              buildRatings(pid),
                              const SizedBox(
                                height: 20,
                              ),
                              Divider(color: Colors.grey[300], thickness: 6),
                            ],
                          );
                        } else {
                          return const Center(child: Text('Không có dữ liệu'));
                        }
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return const Center(
                            child: Text('Đã có lỗi khi tải dữ liệu'));
                      }
                    }),
              ),
              const SizedBox(height: 8),
              buildAddToCartButton(pid),
            ]),
          )),
    );
  }

  Widget buildRatingButton(BuildContext context, String pid) {
    return InkWell(
      onTap: () {
        //TODO: Navigate ratings
        Navigator.pushNamed(context, 'ratings',arguments: pid);
      },
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: Colors.white,
            border: Border.all(
              color: Colors.green,
            ),
          ),
          child: const Center(
              child: Text(
            'XEM ĐÁNH GIÁ',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14),
          )),
        ),
      ),
    );
  }

  Widget buildRatings(String pid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Đánh giá',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder(
                  future: RatingsApi.getRatings(pid),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        var data = snapshot.data['data'];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: AvgRatings.getAvgRatingsFromJson(data),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 48,
                                    color: Colors.black),
                              ),
                              const WidgetSpan(
                                child: Icon(Icons.star,
                                    color: Colors.yellow, size: 48),
                              )
                            ])),
                            const SizedBox(height: 10),
                            Text(data.length.toString() + " đánh giá"),
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
              flex: 2,
            ),
            Expanded(
              child: buildRatingButton(context,pid),
              flex: 2,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildProductDetails(String? detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chi tiết sản phẩm',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 16),
        Text(
          detail!,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget buildRelativeProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sản phẩm liên quan',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 16),
        FutureBuilder(
            future: CategoryItemsApi.getProductsByCategory('veg'),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  var data = snapshot.data['data'];
                  return SizedBox(
                    height: 250,
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          Product product = Product.fromJson(data[index]);

                          return ProductCard.getProductCard(context, product);
                        }),
                  );
                } else {
                  return const Center(child: Text('Không có dữ liệu'));
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Text('Đã có lỗi khi tải dữ liệu');
              }
            })
      ],
    );
  }

  Widget buildAddToCartButton(String pid) {
    var uid = Provider.of<UserDao>(context, listen: false);
    var prod = Provider.of<MemCartRepos>(context, listen: false);

    return SizedBox(
      height: 45,
      width: double.infinity,
      child: InkWell(
        onTap: () {
          //TODO: Update cart
          prod.addOneItemQuality(uid.userId()!,pid);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thêm sản phẩm vào giỏ hàng thành công')));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: Colors.green,
            border: Border.all(
              color: Colors.green,
            ),
          ),
          child: const Center(
              child: Text(
            'THÊM VÀO GIỎ HÀNG',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
          )),
        ),
      ),
    );
  }

  Widget buildFavoriteButton(BuildContext context, Product product){
    var memFavRepos = Provider.of<MemFavRepos>(context, listen: false);
    return InkWell(
      onTap: () {
        //TODO: Add to favourite
        memFavRepos.addProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: const Text('Đã thêm vào danh sách yêu thích'),));
      },
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: Colors.white,
            border: Border.all(
              color: Colors.green,
            ),
          ),
          child: const Center(
              child: Text(
                'THÊM VÀO DANH SÁCH YÊU THÍCH',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14),
              )),
        ),
      ),
    );
  }

  Widget buildHeadingProductDetails(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.network(
          urlPrimary + product.url!,
        ),
        const SizedBox(height: 16,),
        Text(
          PriceConvert.convertToVnd(product.price!),
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green, fontSize: 24),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          product.title!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(
          height: 10,
        ),
        RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Xuất xứ: ',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          TextSpan(
            text: product.country,
            style: const TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ])),
        const SizedBox(
          height: 10,
        ),
        RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Thương hiệu: ',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          TextSpan(
            text: product.brand,
            style: const TextStyle(
                fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ])),
      ],
    );
  }
}
