import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({required this.title});

  final List<Map<String, String>> imgList = [
    {'image': 'assets/images/car.webp', 'caption': 'Save for Your Dream Car'},
    {'image': 'assets/images/moneygrow.jpg', 'caption': 'Grow your money with ease'},
    {'image': 'assets/images/laptop.jpg', 'caption': 'Own it with Pocket Change '},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: CarouselSlider.builder(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
          ),
          itemCount: imgList.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(imgList[index]['image']!, fit: BoxFit.cover),
                ),
                SizedBox(height: 10.0),
                Text(
                  imgList[index]['caption']!,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
