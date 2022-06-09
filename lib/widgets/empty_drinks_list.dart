import 'package:flutter/material.dart';
import 'package:water_tracker/common/app_constants.dart';

class EmptyDrinksList extends StatelessWidget {
  const EmptyDrinksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(ImagesPath.GLASS_OF_WATER_IMAGE, scale: 2,),
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
        Text('No drinks added today', style: Theme.of(context).textTheme.headline6,),
      ],
    );
  }
}
