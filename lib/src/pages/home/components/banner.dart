

import 'package:flutter/material.dart';


class HomeBanner extends StatelessWidget {
  const HomeBanner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 90,
      width: double.infinity,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF4A3298),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: () {
          print("Click");
        },
          child: Row(
            children: [
              Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.white),
                children: [
                   TextSpan(
                    text: "Hablemos de algo\n",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: "Busca a tu contactos"),
                ],
              ),
              ),
              Container(
                margin: EdgeInsets.only(left: 50),
                child: Icon(Icons.notification_important)
              )
            ],
          ),
        
      ),
    );
  }
}