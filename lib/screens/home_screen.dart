import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_medicine_checking_app/models/medicine_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FToast fToast;
  var prevMedicineNum = 0;
  var newMedicineNum = 0;

  // 2023.03.06
  // MedicineWidget의 instance를 보관하는 List이다.
  List<MedicineModel> medicineList = [];
  late String removedMedicineName;
  late String addedMedicineName;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _showToast(String alertMessage) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.blue,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.medication_outlined,
            color: Colors.white,
          ),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            alertMessage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // -----------------------------------------
    // 2023.03.08
    // addPostFrameCallback은 Build가 끝난 이후에
    // 지정된 콜백을 실행시켜 주지만, 이 방식은
    // 스크린이 충분히 다 그려지기 전에 실행되므로
    // 키보드가 내려가서 화면 상에서 인식되기 이전에
    // 실행된다. 이 때문에 Future.delayed()를 이용하여
    // 약간의 딜레이를 추가해 Toast가 원활하게 나오도록
    // 만들었다.
    // -----------------------------------------

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (prevMedicineNum == medicineList.length) return;

          newMedicineNum = medicineList.length;
          if (newMedicineNum == prevMedicineNum + 1) {
            _showToast("약 알람이 추가되었습니다.");
          } else if (newMedicineNum == prevMedicineNum - 1) {
            // 2023.03.08
            // 이름이 길 경우에 화면 바깥으로 Toast가 커지는 것에 대비해
            // 처리가 필요하다. 현재는 임시적으로 comment out 처리한다.
            // _showToast("$removedMedicineName의 알람이 제거되었습니다.");
            _showToast("약 알람이 제거되었습니다.");
          }

          prevMedicineNum = newMedicineNum;
        });
      },
    );

    // --------------------------------------------------------
    // 2023.03.07
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    // 키보드를 꺼내면 build method가 실행된다. 따라서,
    // 이 위치에서 키보드를 내릴 수 없음. (Build 중에 또 Build 실행)
    // 그리고, 여기서 _showToast를 하게 되면, build를 실행하는 중에
    // 또 다시 build를 요청하게 되므로 불가능하다.
    // build 이후에 콜백으로 진행되는 방식을 사용.
    // --------------------------------------------------------
    // newMedicineNum = medicineList.length;
    // if (newMedicineNum == prevMedicineNum + 1) {
    //   _showToast("약 알람이 추가되었습니다.");
    // } else if (newMedicineNum == prevMedicineNum - 1) {
    //   _showToast("약 알람이 제거되었습니다.");
    // }
    // prevMedicineNum = newMedicineNum;
    // --------------------------------------------------------

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Center(
          child: Text(
            '약은 먹고 다니냐?',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 30, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: addNewMedicine,
                  icon: const Icon(
                    Icons.add_box_outlined,
                    shadows: [
                      Shadow(
                        color: Colors.blueGrey,
                        offset: Offset(1.5, 1.5),
                        blurRadius: 3,
                      ),
                    ],
                    size: 50,
                    color: Colors.blue,
                  ),
                ),
                // const IconButton(
                //   padding: EdgeInsets.zero,
                //   onPressed: null,
                //   icon: Icon(
                //     shadows: [
                //       Shadow(
                //         color: Colors.blueGrey,
                //         offset: Offset(1.5, 1.5),
                //         blurRadius: 3,
                //       ),
                //     ],
                //     Icons.settings,
                //     size: 50,
                //     color: Colors.blue,
                //   ),
                // )
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                height: screenHeight * 0.7,
                width: screenWidth * 1,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(-0.1, -0.1),
                        blurRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(0.1, 0.1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: makeMedicineList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void addNewMedicine() {
    String medicineName = '';
    String medicineDescription = '';
    bool takeOnMorning = false;
    bool takeOnAfternoon = false;
    bool takeOnNight = false;

    showDialog(
      context: context,
      // 2023.03.06
      // Dialog 외부를 터치했을 때 Dialog를 끄는 옵션.
      // false이므로, 외부를 터치했을 때 꺼지지 않는다.
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Center(
              child: Text(
                '약 추가하기',
              ),
            ),
            content: SizedBox(
              height: 300,
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (nameInput) {
                      // 기존에는 setState를 사용했는데,
                      // 데이터를 바꾸는 것은 완료 버튼을 눌렀을 때만 시도하면 되기 때문에
                      // setState를 제거한다.
                      medicineName = nameInput;
                    },
                    decoration: const InputDecoration(
                      hintText: "약의 이름을 입력해주세요.",
                    ),
                  ),
                  TextField(
                    onChanged: (descriptionInput) {
                      medicineDescription = descriptionInput;
                    },
                    decoration: const InputDecoration(
                      hintText: "약에 대한 설명을 입력해주세요.",
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '아침',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Checkbox(
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                            value: takeOnMorning,
                            onChanged: (check) {
                              setState(() {
                                takeOnMorning = check!;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            '점심',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Checkbox(
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                            value: takeOnAfternoon,
                            onChanged: (check) {
                              setState(() {
                                takeOnAfternoon = check!;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            '저녁',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Checkbox(
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                            value: takeOnNight,
                            onChanged: (check) {
                              setState(() {
                                takeOnNight = check!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Center(
                    child: Text(
                      '알람 설정 기능 구현 예정입니다.',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  // ---------------------------------------
                  // 2023.03.06
                  // 취소를 누를 경우 변수 초기화.
                  // 다시 추가할 때 Default 값으로 보이게 됨.
                  // ---------------------------------------
                  // [Modified Comment]
                  // takeOn 변수들은 method 내에서 생성한 변수들이므로,
                  // 초기화하지 않아도 된다.
                  // ---------------------------------------
                  // takeOnMorning = false;
                  // takeOnAfternoon = false;
                  // takeOnNight = false;
                  // ---------------------------------------
                },
                child: const Text(
                  '취소',
                ),
              ),
              TextButton(
                onPressed: () {
                  // -------------------------------------------------------------------
                  // 2023.03.06
                  // this.setState()를 하면 현재 화면인 StatefulWidget을 다시 그릴 수 있다.
                  // this를 붙이지 않으면 현재 AlertDialog가 다시 그려지게 되므로,
                  // HomeScreen에서 추가된 약을 그릴 수 없다.
                  // -------------------------------------------------------------------

                  if (medicineName == '') {
                    // 약의 이름을 입력하지 않으면 return.
                    _showToast("약의 이름을 입력해주세요.");
                    return;

                    // -------------------------------------------
                    // 2023.03.07
                    // Toast without Build Context.
                    // Using this, the toast options can't be set.
                    // -------------------------------------------
                    // Fluttertoast.showToast(
                    //   msg: "This is a Toast",
                    //   backgroundColor: Colors.blue,
                    // );
                  }

                  FocusManager.instance.primaryFocus?.unfocus();

                  // if (MediaQuery.of(context).viewInsets.bottom > 0) {
                  //   FocusManager.instance.primaryFocus?.unfocus();
                  //   return;
                  // }

                  this.setState(() {
                    // -------------------------------------------------
                    // 2023.03.06
                    // takeOnMorning = this.takeOnMorning... 으로 했었는데,
                    // 여기서 this는 scope가 addNewMedicine 내가 아닌
                    // _HomeScreenState가 되므로, this를 붙이면 안된다.
                    // --------------------------------------------------

                    medicineList.add(
                      MedicineModel(
                        name: medicineName,
                        description: medicineDescription,
                        takeOnMorning: takeOnMorning,
                        takeOnAfternoon: takeOnAfternoon,
                        takeOnNight: takeOnMorning,
                      ),
                    );
                    Navigator.of(context).pop();
                  });
                },
                child: const Text(
                  '완료',
                ),
              )
            ],
          );
        });
      },
    );
  }

// medicineList
  ListView makeMedicineList() {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      itemCount: medicineList.length,
      // medicineList를 순회하면서 MedicineWidget을 추가한다.
      itemBuilder: (context, index) {
        return Card(
          shadowColor: Colors.blueGrey,
          elevation: 3,
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 0,
            ),
            child: ListTile(
              leading: const Icon(
                Icons.medication_outlined,
                size: 50,
                color: Colors.white,
              ),
              title: Text(
                medicineList[index].name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: Text(
                medicineList[index].description,
              ),
              subtitleTextStyle: TextStyle(
                color: Colors.grey.shade900,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              trailing: SizedBox(
                width: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            removedMedicineName = medicineList[index].name;
                            medicineList.removeAt(index);
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
    );
  }
}
