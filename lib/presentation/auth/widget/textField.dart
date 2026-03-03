import 'package:flutter/material.dart';

Widget buildTextField({
  required String label,
  required String hint,
  required TextEditingController controller,
  required IconData icon,
  bool obscureText = false,
  Widget? suffixIcon,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ],
  );
}
