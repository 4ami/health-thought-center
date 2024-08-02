import 'package:flutter/material.dart';
import 'package:ht_web/feature/landing/widget/content.dart';
import 'package:ht_web/conf/shared/drawer.dart';
import 'package:ht_web/conf/shared/footer.dart';
import 'package:ht_web/conf/shared/header.dart';

class DeskTop extends StatefulWidget {
  const DeskTop({super.key});

  @override
  State<DeskTop> createState() => _DeskTopState();
}

class _DeskTopState extends State<DeskTop> {
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
