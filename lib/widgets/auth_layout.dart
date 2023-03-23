import 'package:echeckout/icons/custom_icons_icons.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.body,
    required this.title,
    required this.desc,
    required this.focusNodes,
    this.backFunc,
    this.photo,
  });
  final Widget body;
  final VoidCallback? backFunc;
  final String title;
  final dynamic desc;
  final List<FocusNode> focusNodes;
  final String? photo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        for (var fc in focusNodes) {
          fc.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 63,
                  bottom: photo == null ? 70 : 50,
                ),
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: backFunc ?? () => Navigator.of(context).pop(),
                  icon: const Icon(CustomIcons.arrow_back, size: 18),
                ),
              ),
              if (photo != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD8E8FF),
                        width: 6,
                      ),
                      image:
                          DecorationImage(image: NetworkImage(photo as String)),
                    ),
                    width: 66,
                    height: 66,
                  ),
                ),
              if (photo != null) const SizedBox(height: 19),
              Text(title, style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 10),
              desc.runtimeType == String
                  ? Text(
                      desc,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                    )
                  : desc as Widget,
              const SizedBox(height: 49),
              body,
            ],
          ),
        ),
      ),
    );
  }
}
