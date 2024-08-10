import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:redirect/app/core/app_typography.dart';
import 'package:redirect/app/module/redirect/redirect_controller.dart';
import '../../core/app_colors.dart';
import '../../reusable/app_field/app_feild.dart';
import '../../reusable/dialog/redirect_dialog.dart';
import '../../reusable/generated_scaffold.dart';

class RedirectView extends StatelessWidget {
  const RedirectView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: RedirectController(),
        builder: (c) {
          return AppScaffold(
              appBar: _topBar(c),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  AppDialog().redirect(context);
                },
                elevation: 3,
                backgroundColor: AppColors.xff1DAB61,
                child: Center(
                    child: Image.asset(
                  "assets/add.png",
                  height: 14.h,
                )),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          children: [
                            AppTextField(
                              prefix: Transform.scale(
                                scale: 0.7,
                                child: Image.asset(
                                  "assets/ai_logo.png",
                                  height: 10.h,
                                  width: 10.h,
                                ),
                              ),
                              controller: c.searchController,
                              hintText: "Search Number",
                            ),
                            _buildFilterList(c),
                          ],
                        ),
                      ),
                      Obx(() {
                        if (c.userNumberList.isNotEmpty) {
                          if (c.loading.isFalse) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: c.userNumberList.length,
                                itemBuilder: (context, index) {
                                  var formatter = DateFormat('dd/MM/yyyy');
                                  String formattedTime = DateFormat('hh:mm a')
                                      .format(
                                          c.userNumberList[index].createdAt ??
                                              DateTime.now());
                                  String formattedDate = formatter.format(
                                      c.userNumberList[index].createdAt ??
                                          DateTime.now());

                                  return Slidable(
                                      key: const ValueKey(0),
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            flex: 1,
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                                    left: Radius.circular(100)),
                                            onPressed: (context) {
                                              AppDialog().redirect(context,
                                                  data:
                                                      c.userNumberList[index]);
                                            },
                                            backgroundColor:
                                                AppColors.xffdbfed4,
                                            foregroundColor:
                                                AppColors.xff1DAB61,
                                            icon: Icons.edit,
                                          ),
                                          SlidableAction(
                                            flex: 1,
                                            onPressed: (context) {
                                              AppDialog().deleteDialog(context,
                                                  data:
                                                      c.userNumberList[index]);
                                            },
                                            backgroundColor:
                                                AppColors.xff1DAB61,
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                          ),
                                        ],
                                      ),
                                      child: _buildNumberTile(c, index,
                                          formattedTime, formattedDate));
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 15.h,
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xff1daa61),
                              ),
                            );
                          }
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      // _redirectField(c)
                    ],
                  ),
                ),
              ));
        });
  }

  Row _buildFilterList(RedirectController c) {
    return Row(
      children: List.generate(
        c.filterList.length,
        (index) => GestureDetector(
          onTap: () {
            c.selectedCategory(index);
            c.update();
          },
          child: Container(
            decoration: BoxDecoration(
                color: c.selectedCategory.value == index
                    ? AppColors.xffdbfed4
                    : AppColors.xfff6f5f3,
                borderRadius: BorderRadius.circular(100)),
            margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 3.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            child: Center(
                child: Text(
              c.filterList[index],
              style: typo.w500.textColor(
                c.selectedCategory.value == index
                    ? AppColors.xff185E3C
                    : AppColors.xff7b7a78,
              ),
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberTile(RedirectController c, int index, String formattedTime,
      String formattedDate) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GestureDetector(
        onTap: () {
          c.launchWhatsApp(c.userNumberList[index].number ?? "",
              saveOnDB: false);
        },
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.xfff6f5f3,
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.xff7b7a78,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Unknown",
                        selectionColor: Colors.white,
                        maxLines: 1,
                        style: typo.w700.get14,
                      ),
                      Text(
                        c.userNumberList[index].number ?? " ",
                        selectionColor: Colors.white,
                        maxLines: 1,
                        style: typo.get11.textColor(AppColors.xff7b7a78),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    formattedTime,
                    selectionColor: Colors.white,
                    style: typo.get10.textColor(AppColors.xff7b7a78),
                  ),
                  Text(
                    formattedDate,
                    selectionColor: Colors.white,
                    style: typo.get10.textColor(AppColors.xff7b7a78),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _topBar(RedirectController c) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      title: const Text(
        'WhatsApp Redirect',
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1daa61)),
      ),
      actions: [
        IconButton(
            onPressed: c.getUserNumber,
            icon: const Icon(Icons.refresh, color: Color(0xff54656f)))
      ],
    );
  }
}
