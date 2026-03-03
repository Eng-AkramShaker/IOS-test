import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar buildAppBar(BuildContext context, String title, {bool showBottom = false}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: showBottom == false
        ? null
        : Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 18),
              ),
            ),
          ),
    title: Text(
      title,
      style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
    ),
    centerTitle: true,
  );
}
