import 'package:flutter/material.dart';
import 'package:ht_web/feature/landing/widget/content.dart';
import 'package:ht_web/conf/shared/drawer.dart';
import 'package:ht_web/conf/shared/footer.dart';
import 'package:ht_web/conf/shared/header.dart';

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
          SliverList(delegate: SliverChildListDelegate.fixed([Content()])),
          Footer(),
        ],
      ),
    );
  }
}
