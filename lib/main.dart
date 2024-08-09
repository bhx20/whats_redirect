import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:redirect/sql_helper.dart';
import 'package:url_launcher/url_launcher.dart';

List<UserNumber> userNumberFromJson(String str) =>
    List<UserNumber>.from(json.decode(str).map((x) => UserNumber.fromJson(x)));

class UserNumber {
  int? dbId;
  DateTime? createdAt;
  String? number;

  UserNumber({
    this.dbId,
    this.createdAt,
    this.number,
  });

  factory UserNumber.fromJson(Map<String, dynamic> json) => UserNumber(
        dbId: json["dbId"],
        createdAt: json["CreatedAt"] == null
            ? null
            : DateTime.parse(json["CreatedAt"]),
        number: json["Number"],
      );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.instance.initDataBase();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Redirect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _phoneController = TextEditingController();

  final dbHelper = DbHelper.instance;
  bool loading = false;
  List<UserNumber> userNumberList = <UserNumber>[];

  @override
  void initState() {
    super.initState();
    getUserNumber();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _launchWhatsApp(String phoneNumber,
      {bool saveOnDB = true}) async {
    var androidUrl = "whatsapp://send?phone=+91$phoneNumber&text=";

    try {
      await launchUrl(Uri.parse(androidUrl));
      if (saveOnDB) {
        if (phoneNumber.isNotEmpty) {
          await saveUserNumberToDB(phoneNumber);
          getUserNumber();
        }
      }

      _phoneController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  Future<void> getUserNumber() async {
    setState(() {
      loading = true;
    });
    var userdata = await dbHelper.queryAll("USER_NUMBER");
    String userdataJson = jsonEncode(userdata);
    List<UserNumber> userList = userNumberFromJson(userdataJson);
    userNumberList = userList;
    userNumberList.sort((a, b) {
      DateTime? dateA = a.createdAt;
      DateTime? dateB = b.createdAt;
      return dateA!.compareTo(dateB!);
    });
    userNumberList = userNumberList.reversed.toList();
    setState(() {
      loading = false;
    });
  }

  Future<void> saveUserNumberToDB(String number) async {
    Map<String, dynamic> row = {
      "CreatedAt": DateTime.now().toString(),
      "Number": number,
    };
    dbHelper.insert("USER_NUMBER", row);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    bool isKeyboardOpen = bottomInsets != 0;
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/bg.png",
            color: const Color(0xffefe3d6),
            fit: BoxFit.cover,
          ),
          Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.transparent,
              appBar: _topBar(),
              body: Column(
                children: [
                  Expanded(
                      child: userNumberList.isNotEmpty
                          ? loading == false
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ListView.separated(
                                    itemCount: userNumberList.length,
                                    itemBuilder: (context, index) {
                                      var formatter = DateFormat('dd/MM/yyyy');
                                      String formattedTime =
                                          DateFormat('hh:mm a').format(
                                              userNumberList[index].createdAt ??
                                                  DateTime.now());
                                      String formattedDate = formatter.format(
                                          userNumberList[index].createdAt ??
                                              DateTime.now());

                                      return Slidable(
                                          key: const ValueKey(0),
                                          endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                flex: 1,
                                                borderRadius: const BorderRadius
                                                    .horizontal(
                                                    left: Radius.circular(100)),
                                                onPressed: (context) {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return _dialog(
                                                        userNumberList[index],
                                                      );
                                                    },
                                                  );
                                                },
                                                backgroundColor:
                                                    Colors.blueGrey,
                                                foregroundColor: Colors.white,
                                                icon: Icons.edit,
                                              ),
                                              SlidableAction(
                                                flex: 1,
                                                onPressed: (context) {
                                                  dbHelper.deleteQuery(
                                                      "USER_NUMBER",
                                                      userNumberList[index]
                                                              .dbId ??
                                                          0,
                                                      "dbId");
                                                  getUserNumber();
                                                },
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                icon: Icons.delete,
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              _launchWhatsApp(
                                                  userNumberList[index]
                                                          .number ??
                                                      "",
                                                  saveOnDB: false);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      width: 0.5)),
                                              padding: const EdgeInsets.all(8),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        const CircleAvatar(
                                                          backgroundColor:
                                                              Color(0xff1daa61),
                                                          child: Icon(
                                                            Icons
                                                                .person_rounded,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          userNumberList[index]
                                                                  .number ??
                                                              " ",
                                                          selectionColor:
                                                              Colors.white,
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          formattedTime,
                                                          selectionColor:
                                                              Colors.white,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          formattedDate,
                                                          selectionColor:
                                                              Colors.white,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(
                                        height: 10,
                                      );
                                    },
                                  ),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xff1daa61),
                                  ),
                                )
                          : const SizedBox.shrink()),
                  _redirectField()
                ],
              )),
        ],
      ),
    );
  }

  AppBar _topBar() {
    return AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text(
          'WhatsApp Redirect',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1daa61)),
        ),
        actions: [
          IconButton(
              onPressed: getUserNumber,
              icon: const Icon(Icons.refresh, color: Color(0xff54656f)))
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 0,
            color: Colors.grey.withOpacity(0.2),
          ),
        ));
  }

  Padding _redirectField() {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    bool isKeyboardOpen = bottomInsets != 0;
    return Padding(
      padding: isKeyboardOpen == true
          ? const EdgeInsets.only(bottom: 50, right: 5, left: 5, top: 10)
          : const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: TextFieldWithBoxShadow(
              controller: _phoneController,
              hintText: "Phone Number",
              onSubmitted: _launchWhatsApp,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              String phoneNumber = _phoneController.text;
              _launchWhatsApp(phoneNumber);
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: const BoxDecoration(
                color: Color(0xff1daa61),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFD7CBCB),
                    offset: Offset(0.5, 0.5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  _dialog(UserNumber data) {
    TextEditingController dialogController =
        TextEditingController(text: data.number);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
        width: 400,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 1),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/bg.png",
                color: const Color(0xffefe3d6),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Edit Number',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1daa61)),
                  ),
                  const SizedBox(height: 10.0),
                  TextFieldWithBoxShadow(
                    prefix: const Icon(Icons.person),
                    controller: dialogController,
                    hintText: "Phone Number",
                  ),
                  const SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () {
                      Map<String, dynamic> row = {
                        "Number": dialogController.text,
                      };
                      dbHelper.update("USER_NUMBER", data.dbId ?? 0, row);
                      getUserNumber();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color(0xff1daa61)),
                      child: const Center(
                          child: Text(
                        'Submit',
                        style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      )),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//==============================================================================
//  ** Helper Widgets  **
//==============================================================================

class TextFieldWithBoxShadow extends StatelessWidget {
  final String? errorText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final void Function(String)? onSubmitted;

  const TextFieldWithBoxShadow({
    super.key,
    this.errorText,
    this.hintText = "",
    this.controller,
    this.keyboardType,
    this.prefix,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFD7CBCB),
              offset: Offset(0.5, 0.5),
            ),
          ],
          borderRadius: BorderRadius.circular(
            100.0,
          )),
      child: TextField(
        keyboardType: TextInputType.number,
        cursorColor: const Color(0xff1daa61),
        onSubmitted: onSubmitted,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 10,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          prefixIcon: prefix,
          hintStyle: const TextStyle(color: Color(0xff54656f)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFDCD6D6), width: 0.15),
              borderRadius: BorderRadius.all(Radius.circular(100))),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFDCD6D6), width: 0.15),
              borderRadius: BorderRadius.all(Radius.circular(100))),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFDCD6D6), width: 0.15),
              borderRadius: BorderRadius.all(Radius.circular(100))),
        ),
        controller: controller,
      ),
    );
  }
}
