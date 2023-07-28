import 'package:flutter/material.dart';


class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const RoundButton({Key? key ,
    required this.title,
    required this.onTap,
    this.loading = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 140,
        decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(strokeWidth: 3,color: Colors.white)
              : Text(title, style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w400,color: Colors.white),),),
      ),
    );
  }
}