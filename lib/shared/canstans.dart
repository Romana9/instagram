import 'package:flutter/material.dart';

const decorationTextfield = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
    ),
  ),
  filled: true,
  contentPadding: EdgeInsets.all(8),
);
