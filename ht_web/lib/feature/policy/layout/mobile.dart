import 'package:flutter/material.dart';
import 'package:ht_web/conf/shared/drawer.dart';
import 'package:ht_web/conf/shared/footer.dart';
import 'package:ht_web/conf/shared/header.dart';
import 'package:ht_web/feature/policy/widget/content.dart';

class Mobile extends StatefulWidget {
  const Mobile({super.key});

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          Header(),
          PolicyContent(),
          Footer(),
        ],
      ),
    );
  }
}
