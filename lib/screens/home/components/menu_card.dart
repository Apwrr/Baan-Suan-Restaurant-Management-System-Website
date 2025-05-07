import 'package:animation_2/components/fav_btn.dart';
import 'package:animation_2/components/price.dart';
import 'package:animation_2/models/Menu.dart';
import 'package:animation_2/screens/deatils/Details_Menu.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({
    Key? key,
    required this.menu,
    required this.press,
  }) : super(key: key);

  final Menu menu;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: const BorderRadius.all(
            Radius.circular(defaultPadding * 1.25),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (menu.imagePath != null)
              Hero(
                tag: menu.nameTh ?? 'defaultTag',
                child: Image.asset(menu.imagePath!),
              ),
            if (menu.nameTh != null)
              Text(
                menu.nameTh!,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            /*Text(
              "Food",
              style: Theme.of(context).textTheme.caption,
            ),*/
            if (menu.price != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Price(amount: menu.price!),
                  //FavBtn(),
                ],
              )
          ],
        ),
      ),
    );
  }
}
