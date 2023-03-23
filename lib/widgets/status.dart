import 'package:flutter/material.dart';

class Status extends StatelessWidget {
  const Status(
    this.status, {
    super.key,
    this.padding = const EdgeInsets.only(
      bottom: 2,
      left: 11,
      right: 11,
    ),
    this.fontSize = 10,
    this.height = 20,
  });
  final String status;
  final EdgeInsets? padding;
  final double fontSize;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
          color: status == 'Pending'
              ? const Color(0xFFFFFBEF)
              : status == 'Active'
                  ? const Color(0x1f1566d8)
                  : status == 'Completed' || status == 'Credit'
                      ? const Color(0x1f008e13)
                      : status == 'Rejected'
                          ? const Color(0x4f000000)
                          : status == 'Review'
                              ? const Color(0x1f17a2b8)
                              : status == 'Cancelled'
                                  ? const Color(0x4dcccccc)
                                  : const Color(0x1fff0000),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: padding,
        height: height,
        alignment: Alignment.center,
        child: Text(
          status,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: fontSize,
            color: status == 'Pending'
                ? const Color(0xffE4AB00)
                : status == 'Active'
                    ? const Color(0xff1566d8)
                    : status == 'Completed' || status == 'Credit'
                        ? const Color(0xff008e13)
                        : status == 'Rejected'
                            ? const Color(0xff000000)
                            : status == 'Review'
                                ? const Color(0xff17a2b8)
                                : status == 'Cancelled'
                                    ? const Color(0xFF949494)
                                    : const Color(0xffff0000),
          ),
        ),
      ),
    );
  }
}
