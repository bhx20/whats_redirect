import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:redirect/app/module/saver/saver_controller.dart';

import '../../reusable/generated_scaffold.dart';

class SaverView extends StatelessWidget {
  const SaverView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaverController>(
      init: SaverController(),
      builder: (c) {
        return AppScaffold(appBar: _topBar(c), body: Container());
      },
    );
  }

  AppBar _topBar(SaverController c) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      title: const Text(
        'What\'s Saver',
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1daa61)),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.refresh, color: Color(0xff54656f)),
        )
      ],
    );
  }
}
