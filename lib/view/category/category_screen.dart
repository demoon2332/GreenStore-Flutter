import 'package:flutter/material.dart';
import 'package:greenstore_flutter/view/constant_value.dart';
import '../../services/category_api.dart';
import 'package:sizer/sizer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  static const urlPrimary ='https://greenstore-api.herokuapp.com/';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
          color: successColorLight,
        padding: EdgeInsets.only(top: 36, bottom: 16, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Category",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.sp),
                ),
                SizedBox(height: 1.h),
              ],
            ),
            Expanded(
              child: showCategory(context),
              flex: 4,
            ),
          ],
        ),
      )),
    
    );
  }

  //TODO: Change to ListView.builder
  Widget showCategory(BuildContext context) {
    return FutureBuilder(
        future: CategoryApi.getAllCategories(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              var data = snapshot.data['data'];
              return GridView.builder(
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.7),
                itemBuilder:(context, index){
                  return Column(
                    children: [
                      showCategoryCard(context,data[index]['short_name'],data[index]['name'],data[index]['url']),
                      const SizedBox(height: 16,),
                    ],
                  );
                },
              );
            }
            else{
              return const Center(child: Text('Không có dữ liệu'),);
            }
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          else{
            return const Center(child: Text('Không có dữ liệu'),);
          }

        }
    );
  }

  Widget showCategoryCard(BuildContext context,String? shortName, String? name, String? url) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'cate_items', arguments: shortName!);
      },
      child: SizedBox(
        child: Card(
          // color: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          //shadowColor: Colors.green,
          elevation: 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child:
                ClipRRect(
                  child: Image.network(
                      urlPrimary+url!,
                      height: 150),
                  //fit: BoxFit.fill,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              ListTile(
                title: Text(name!, textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.amber),
              )
              )
            ],
          ),
        ),
      ),
    );
  }

}
