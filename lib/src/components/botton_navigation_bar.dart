import 'package:flutter/material.dart';
import '../../enums.dart';


class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key key,
     @required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.map),
                onPressed: () {
                  Navigator.pushNamed(context, 'map');
                 },
              ),
            ],
          )),
    );
  }
}
