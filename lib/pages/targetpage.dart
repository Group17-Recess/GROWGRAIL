import 'package:flutter/material.dart';

class Targetpage extends StatelessWidget {
  const Targetpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        centerTitle: true,
        title:  const Text(
          'WHAT WOULD YOU WANT TO SAVE FOR?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:Colors.black,
            fontFamily: 'Anton',

          ),

        ),

      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.blueGrey,
            child: const Text(
          
              'Phone',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: 'Anton',
          
              ),


            ),
          ),
          Container(
            color: Colors.blueGrey,
            child:  const Text(
              'Shopping',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: 'Anton',

              ),
              ),
            ),

          

        ],
      ),

    );
  }
}