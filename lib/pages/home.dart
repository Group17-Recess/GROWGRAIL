import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'login_page.dart'; // Import your login page here

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, String>> imgList = [
    {
      'image': 'images/person3.webp',
      'caption': 'You are all set to build wealth',
      'progress': '40'
    },
    {
      'image': 'images/person4.webp',
      'caption': 'Save consistently with ease',
      'progress': '20'
    },
    {
      'image': 'images/moneygrow.jpg',
      'caption': 'Grow your money with ease',
      'progress': '10'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          color: Color(0xFF06E7C2), // Green background for GrowGrail
          child: Text(
            'GrowGrail',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text(
              'Login/Signup',
              style: TextStyle(color: Colors.black),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 300.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
              items: imgList.map((item) => _buildCarouselItem(item)).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFF4FCFC).withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saving Tips',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Here are some tips to help you save more effectively:',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    _buildSavingTip('Set a budget and stick to it.'),
                    _buildSavingTip('Track your expenses regularly.'),
                    _buildSavingTip('Automate your savings.'),
                    _buildSavingTip('Cut down on unnecessary expenses.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(Map<String, String> item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage(item['image']!),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['caption']!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Today: ${item['progress']}%",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 5),
                LinearProgressIndicator(
                  value: double.parse(item['progress']!) / 100,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade300,
                  color: Color(0xFF06E7C2), // Green color for progress bar
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingTip(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF06E7C2), // Blue background for circle
            ),
            child: Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text("Search result for '$query'"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Search suggestions for '$query'"),
    );
  }
}
