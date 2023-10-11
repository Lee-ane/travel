import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:travel/style/data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  dynamic images = [];
  String imgURL = '';
  Timer? timer;
  TextEditingController url = TextEditingController();

  Future<void> uploadImg() async {
    try {
      imgURL = await APIs().pickAndUploadImage();
      if (kDebugMode) {
        print(imgURL);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking and uploading image: $e');
      }
    }
  }

  Future<void> fetchData() async {
    images = await APIs().fetchPosts();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sH = MediaQuery.of(context).size.height;
    final sW = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xffdda15e),
        title: Container(
          width: sW * 0.7,
          height: sH * 0.05,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xff40916c)),
                  hintText: 'Search for it',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chat_outlined))
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: sW,
            child: MasonryGridView.count(
              shrinkWrap: true,
              itemCount: images.length,
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 20,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(images[index]['imageURL']),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            width: sW * 0.95,
            height: sH * 0.88,
            child: GestureDetector(
              onTap: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.info,
                  title: 'Share your image',
                  confirmBtnText: 'Accept',
                  onConfirmBtnTap: () {uploadImg();},
                  showCancelBtn: true,
                  cancelBtnText: 'Cancel',
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade300, blurRadius: 10)
                    ]),
                child: const Icon(Icons.add, size: 30),
              ),
            ),
          )
        ],
      ),
    );
  }
}
