import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:redirect/app/controller/redirect_controller.dart';
import 'package:redirect/app/core/app_typography.dart';

import '../../core/app_colors.dart';
import '../../model/local.dart';
import '../../model/user_number_model.dart';
import '../../reusable/app_field/app_feild.dart';
import '../../reusable/dialog/delete_dialog.dart';
import '../../reusable/dialog/redirect_dialog.dart';
import '../../reusable/generated_scaffold.dart';
import '../../reusable/loader/simmer.dart';
import '../../reusable/menu/dashboard_manu.dart';

class RedirectView extends StatefulWidget {
  const RedirectView({super.key});

  @override
  State<RedirectView> createState() => _RedirectViewState();
}

class _RedirectViewState extends State<RedirectView> {
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
                  redirect(context);
                },
                elevation: 3,
                backgroundColor: appColors.xff1DAB61,
                child: Center(
                    child: Image.asset(
                  "assets/add.png",
                  height: 12.h,
                )),
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
                              prefix: Icon(Icons.search),
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
                      Column(
                        children: [
                          ListTile(
                            title: Text("Light Mode"),
                            leading: Obx(() => Radio(
                                  value: ThemeMode.light,
                                  groupValue: c.themeService.themeMode.value,
                                  onChanged: (value) =>
                                      c.setTheme(ThemeMode.light),
                                )),
                          ),
                          ListTile(
                            title: Text("Dark Mode"),
                            leading: Obx(() => Radio(
                                  value: ThemeMode.dark,
                                  groupValue: c.themeService.themeMode.value,
                                  onChanged: (value) =>
                                      c.setTheme(ThemeMode.dark),
                                )),
                          ),
                          ListTile(
                            title: Text("System Default"),
                            leading: Obx(() => Radio(
                                  value: ThemeMode.system,
                                  groupValue: c.themeService.themeMode.value,
                                  onChanged: (value) =>
                                      c.setTheme(ThemeMode.system),
                                )),
                          ),
                        ],
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
                            style: typo.get12.textColor(appColors.xff7b7a78),
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
                          redirect(context);
                        },
                        child: Container(
                          height: 30.h,
                          width: 100.w,
                          margin: EdgeInsets.symmetric(vertical: 15.h),
                          decoration: BoxDecoration(
                              color: appColors.xff1DAB61,
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Text(
                              "Add",
                              style: typo.white.bold,
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
            (i) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w)
                      .copyWith(bottom: 10.h, top: 10.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              child: SimmerLoader(
                                radius: 100,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SimmerLoader(
                                  height: 18,
                                  width: 100,
                                  radius: 0,
                                ),
                                SizedBox(height: 8.w),
                                SimmerLoader(
                                  height: 8,
                                  width: 150,
                                  radius: 0,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SimmerLoader(
                            height: 12,
                            width: 55,
                            radius: 0,
                          ),
                          SizedBox(height: 8.w),
                          SimmerLoader(
                            height: 12,
                            width: 80,
                            radius: 0,
                          )
                        ],
                      )
                    ],
                  ),
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
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  flex: 1,
                  onPressed: (context) {
                    Get.find<RedirectController>()
                        .launchSMS(contact[index].number ?? "");
                  },
                  backgroundColor: appColors.secondarySlideBg,
                  foregroundColor: appColors.secondarySlideTitle,
                  icon: Icons.chat,
                ),
                SlidableAction(
                  flex: 1,
                  borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(100)),
                  onPressed: (context) {
                    Get.find<RedirectController>()
                        .launchPhoneDial(contact[index].number ?? "");
                  },
                  backgroundColor: appColors.primarySlideBg,
                  foregroundColor: appColors.primarySlideTitle,
                  icon: Icons.call,
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  flex: 1,
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(100)),
                  onPressed: (context) {
                    redirect(context, data: contact[index]);
                  },
                  backgroundColor: appColors.primarySlideBg,
                  foregroundColor: appColors.primarySlideTitle,
                  icon: Icons.edit,
                ),
                SlidableAction(
                  flex: 1,
                  onPressed: (context) {
                    deleteDialog(context, data: contact[index]);
                  },
                  backgroundColor: appColors.secondarySlideBg,
                  foregroundColor: appColors.secondarySlideTitle,
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
                    ? appColors.filterBg
                    : appColors.unfocusedFilterBg,
                borderRadius: BorderRadius.circular(100)),
            margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 3.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            child: Center(
                child: Text(
              c.filterList[index],
              style: typo.w500.textColor(
                c.selectedCategory.value == index
                    ? appColors.filterTitle
                    : appColors.unfocusedFilterTitle,
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
    Color hexToColor(String hexCode) {
      return Color(
          int.parse(hexCode.replaceFirst('#', ''), radix: 16) + 0xFF000000);
    }

    Color leadingColor = hexToColor(contact[index].leadingColor ?? "C4A5ED");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GestureDetector(
        onTap: () {
          NumberData data = NumberData(
              number: contact[index].number ?? "",
              origin: contact[index].origin ?? "",
              code: contact[index].code ?? "");
          Get.find<RedirectController>().launchWhatsApp(data, saveOnDB: false);
        },
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: leadingColor.withOpacity(0.3),
                    child: data.imageUrl != null
                        ? ClipOval(child: Image.memory(data.imageUrl!))
                        : data.userName == "Unknown"
                            ? Icon(
                                Icons.person_rounded,
                                color: leadingColor,
                                size: 24,
                              )
                            : Text(
                                data.userName?[0] ?? "",
                                style: typo.get20.bold.textColor(leadingColor),
                              ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.userName ?? "Unknown",
                        maxLines: 1,
                        style: typo.w500.get14,
                      ),
                      Text(
                        "${data.code} ${data.number ?? " "}",
                        maxLines: 1,
                        style: typo.get11.textColor(appColors.xff7b7a78),
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
                    style: typo.get10.textColor(appColors.xff7b7a78),
                  ),
                  Text(
                    formattedDate,
                    style: typo.get10.textColor(appColors.xff7b7a78),
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
      title: Text(
        'What\'s Redirect',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: [
        Obx(() {
          if (c.userNumberList.isNotEmpty) {
            return IconButton(
              onPressed: showDashBoardManu,
              icon: const Icon(Icons.more_vert_rounded),
            );
          } else {
            return const SizedBox();
          }
        })
      ],
    );
  }
}
