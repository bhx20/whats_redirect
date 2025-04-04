import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redirect/app/controller/status_controller.dart';

import '../../core/app_typography.dart';
import '../../core/constants.dart';

showStatusManu({required FutureOr<void> Function() action}) {
  var c = Get.find<StatusController>();
  final RenderBox renderBox =
      menuKey.currentContext!.findRenderObject() as RenderBox;
  final Offset position = renderBox.localToGlobal(Offset.zero);

  showMenu(
    context: Get.context!,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy + renderBox.size.height + 15,
      position.dx + renderBox.size.width,
      0,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    elevation: 0.5,
    items: c.items.asMap().entries.map((entry) {
      int index = entry.key;
      var item = entry.value;

      return PopupMenuItem<int>(
        value: index + 1,
        onTap: () {
          c.reportStatus();
        },
        child: SizedBox(
          width: 100,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  item.title,
                  style: typo.get12,
                  textAlign: TextAlign.center, // Ensure text is centered
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  ).whenComplete(action);
}
