import 'package:flutter/material.dart';
import 'package:ht_web/conf/shared/drawer.dart';
import 'package:ht_web/conf/shared/footer.dart';
import 'package:ht_web/conf/shared/header.dart';
import 'package:ht_web/feature/policy/widget/content.dart';

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
          PolicyContent(),
          Footer(),
        ],
      ),
    );
  }
}
