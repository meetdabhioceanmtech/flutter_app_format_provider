import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ExtendedSizeBox on num {
  SizedBox get sHeight => SizedBox(height: h);
  SizedBox get sWidth => SizedBox(width: w);
}
