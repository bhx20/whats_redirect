import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:redirect/app/core/app_typography.dart';
import 'package:redirect/app/module/redirect/redirect_controller.dart';

import '../../core/app_colors.dart';
import '../../model/user_number_model.dart';
import '../../reusable/app_field/app_feild.dart';
import '../../reusable/dialog/redirect_dialog.dart';
import '../../reusable/generated_scaffold.dart';
import '../../reusable/loader/simmer.dart';

class RedirectView extends StatelessWidget {
  const RedirectView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RedirectController>(
      init: RedirectController(),
      builder: (c) {
        return AppScaffold(
          appBar: _topBar(c),
          floatingActionButton: Obx(() {
            if (c.userNumberList.isNotEmpty) {
              return FloatingActionButton(
                onPressed: () {
                  AppDialog().redirect(context);
                },
                elevation: 3,
                backgroundColor: AppColors.xff1DAB61,
                child: Center(
                  child: Image.asset(
                    "assets/add.png",
                    height: 14.h,
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
          body: Obx(() {
            if (c.userNumberList.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: SingleChildScrollView(
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
                              hintText: "Search Contact",
                              keyboardType: TextInputType.text,
                              numFormater: const [],
                              onChanged: (value) {
                                c.filterUserList(value);
                              },
                              onSubmitted: (value) {
                                c.filterUserList(value);
                              },
                            ),
                            _buildFilterList(c),
                          ],
                        ),
                      ),
                      if (c.filteredUserNumberList.isNotEmpty)
                        if (c.loading.isFalse)
                          _buildContactList(c.filteredUserNumberList)
                        else
                          _buildLoader()
                      else
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 40.h, horizontal: 10.w),
                          child: Text(
                            'No contacts found.\nTry adjusting your search or filter.',
                            style: typo.get12.textColor(AppColors.xff7b7a78),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ],
                  ),
                ),
              );
            } else {
              return SizedBox(
                width: Get.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "It looks like there are no contacts in your list at "
                        "the moment. You might be new to the app or have "
                        "deleted all your contacts. Start your new journey "
                        "by tapping the button below to Add and "
                        "begin building your list!",
                        textAlign: TextAlign.center,
                        style: typo.w500.get10,
                      ),
                      GestureDetector(
                        onTap: () {
                          AppDialog().redirect(context);
                        },
                        child: Container(
                          height: 30.h,
                          width: 100.w,
                          margin: EdgeInsets.symmetric(vertical: 15.h),
                          decoration: BoxDecoration(
                              color: AppColors.xff1DAB61,
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Text(
                              "Add",
                              style: typo.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          }),
        );
      },
    );
  }

  Widget _buildLoader() {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
            15,
            (i) => SimmerLoader(
                  margin: EdgeInsets.symmetric(horizontal: 10.w)
                      .copyWith(bottom: 10.h),
                )),
      ),
    );
  }

  Padding _buildContactList(List<UserNumber> contact) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: contact.length,
        itemBuilder: (context, index) {
          var formatter = DateFormat('dd/MM/yyyy');
          String formattedTime = DateFormat('hh:mm a')
              .format(contact[index].createdAt ?? DateTime.now());
          String formattedDate =
              formatter.format(contact[index].createdAt ?? DateTime.now());

          return Slidable(
            key: ValueKey(contact[index].number),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  flex: 1,
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(100)),
                  onPressed: (context) {
                    AppDialog().redirect(context, data: contact[index]);
                  },
                  backgroundColor: AppColors.xffdbfed4,
                  foregroundColor: AppColors.xff1DAB61,
                  icon: Icons.edit,
                ),
                SlidableAction(
                  flex: 1,
                  onPressed: (context) {
                    AppDialog().deleteDialog(context, data: contact[index]);
                  },
                  backgroundColor: AppColors.xff1DAB61,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
              ],
            ),
            child:
                _buildNumberTile(contact, index, formattedTime, formattedDate),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 15.h,
          );
        },
      ),
    );
  }

  Widget _buildFilterList(RedirectController c) {
    return Row(
      children: List.generate(
        c.filterList.length,
        (index) => GestureDetector(
          onTap: () {
            c.selectedCategory(index);
            c.filteredUserNumberList.value = c.getFilteredList();
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

  Widget _buildNumberTile(List<UserNumber> contact, int index,
      String formattedTime, String formattedDate) {
    var data = contact[index];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GestureDetector(
        onTap: () {
          Get.find<RedirectController>()
              .launchWhatsApp(contact[index].number ?? "", saveOnDB: false);
        },
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.xfff6f5f3,
                    child: data.imageUrl != null
                        ? ClipOval(child: Image.memory(data.imageUrl!))
                        : Icon(
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
                        data.userName ?? " ",
                        selectionColor: Colors.white,
                        maxLines: 1,
                        style: typo.w700.get14,
                      ),
                      Text(
                        data.number ?? " ",
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
        'What\'s Redirect',
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1daa61)),
      ),
      actions: [
        Obx(() {
          if (c.userNumberList.isNotEmpty) {
            return IconButton(
              onPressed: c.getUserNumber,
              icon: const Icon(Icons.refresh, color: Color(0xff54656f)),
            );
          } else {
            return const SizedBox();
          }
        })
      ],
    );
  }
}
