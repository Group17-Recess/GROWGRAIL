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
      backgroundColor: Colors.white, // Set background to white
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Remove app bar color
        elevation: 0, // No elevation
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          color: Colors.lightBlueAccent, // Sky blue background for GrowGrail
          child: const Text(
            'GrowGrail',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text(
              'Login/Signup',
              style: TextStyle(color: Colors.black),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
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
                height: 300.0, // Reduced height for profile images
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
              items: imgList.map((item) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40, // Reduced radius for profile images
                      backgroundImage: AssetImage(item['image']!),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                item['caption']!,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                "Today: ${item['progress']}%",
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: LinearProgressIndicator(
                                value: double.parse(item['progress']!) / 100,
                                minHeight: 6,
                                backgroundColor: Colors.grey.shade300,
                                color: Colors.lightBlueAccent, // Sky blue color for progress bar
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center-align saving tips section
                children: [
                  const Text(
                    'Saving Tips',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Reduced size
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Here are some tips to help you save more effectively:',
                    style: TextStyle(fontSize: 14, color: Colors.grey), // Reduced size
                  ),
                  const SizedBox(height: 10),
                  _buildSavingTip('Set a budget and stick to it.'),
                  _buildSavingTip('Track your expenses regularly.'),
                  _buildSavingTip('Automate your savings.'),
                  _buildSavingTip('Cut down on unnecessary expenses.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingTip(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, // Center-align each tip
        children: [
          const Icon(Icons.check_circle, color: Colors.lightBlueAccent, size: 20), // Sky blue color for icons
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 14, color: Colors.black), // Reduced size
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
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
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
