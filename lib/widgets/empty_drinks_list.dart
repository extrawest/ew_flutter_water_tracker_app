import 'package:flutter/material.dart';

class EmptyDrinksList extends StatelessWidget {
  const EmptyDrinksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/glass-of-water.png', scale: 2,),
        Container(
          height: 100,
          margin: const EdgeInsets.only(left: 70, right: 70),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 100,
                offset: const Offset(0, -105),
              ),
            ],
          ),
        ),
        const Text('No drinks added today'),
      ],
    );
  }
}
