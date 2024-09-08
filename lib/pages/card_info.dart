import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(seconds: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Expences",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
          ),
          const Icon(
            Icons.more_horiz_outlined,
            size: 25,
          )
        ],
      ),
    );
  }
}
