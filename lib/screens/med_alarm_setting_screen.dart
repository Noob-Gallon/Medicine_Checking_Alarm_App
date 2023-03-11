import 'package:flutter/material.dart';
import 'package:my_medicine_checking_app/models/alarm_information.dart';
import 'package:my_medicine_checking_app/utilities/utility.dart';

class MedAlarmSettingScreen extends StatefulWidget {
  const MedAlarmSettingScreen({
    super.key,
    required this.sectionDivider,
    this.alarmInformation,
  });

  // sectionDivider는 CreationPage인지, EditPage인지를 구분하는 역할을 한다.
  // 0 : Creation (sectionDivivder와 AlarmInformation, null이 같이 전달된다. null은 안줘도 되나?)
  // 1 : Edit (sectionDivider와 AlarmInformation이 같이 전달된다.)
  final int sectionDivider;
  final AlarmInformation? alarmInformation;

  @override
  State<MedAlarmSettingScreen> createState() => _MedAlarmSettingScreenState();
}

class _MedAlarmSettingScreenState extends State<MedAlarmSettingScreen> {
  // 2023.03.08
  // 0 : takeOnMorning
  // 1 : takeOnAfternoon
  // 2 : takeOnNight
  List<bool> isTakeOn = [false, false, false];
  String medicineName = '';

  // 2023.03.09
  // 시간 출력에 12H, 24H 설정을 지원해야 함.
  // [modified]
  // 기존에는 TimeOfDay 형식으로 했지만,
  // 이를 String 형식으로 수정함.
  // Local DB 에서 데이터를 가져오는 과정에서
  // 문제점이 있었기 때문에, String으로 통일함.
  // List<TimeOfDay?> pickedTimes = [
  //   const TimeOfDay(hour: 9, minute: 0),
  //   const TimeOfDay(hour: 14, minute: 0),
  //   const TimeOfDay(hour: 20, minute: 0),
  // ];
  List<String> pickedTimes = [
    "09:00",
    "14:00",
    "20:00",
  ];

  Map<String, String>? resultData;
  Utility util = Utility();

  // Property 선언 구간
  // ------------------------------------------------------------------------- //

  // 2023.03.09
  // initialize util to use toastMessage at first.
  @override
  void initState() {
    super.initState();
    // utility(Toast)에 context 주입
    util.injectContext(context);

    // 2023.03.10
    // if sectionDivdier is 1, this page is edit page.
    // initialize on alarm setting.
    if (widget.sectionDivider == 1) {
      medicineName = widget.alarmInformation!.medicineName!;

      for (var i = 0; i <= 2; i++) {
        if (widget.alarmInformation!.isTakeOn![i] == true) {
          isTakeOn[i] = true;
          pickedTimes[i] = widget.alarmInformation!.pickedTimes![i];
        }
      }
    }
  }

  // 2023.03.10
  // pickedTimes가 TimeOfDay에서 String을 보관하도록 바뀌었기 때문에
  // 시간의 String을 TimeOfDay로 바꾸는데 사용하기 위한 메서드이다.
  TimeOfDay convertStringToTime(String strTime) {
    String hour = strTime.substring(0, 1);
    String minute = strTime.substring(3, 4);

    // 만약, 앞자리가 0이라면 0을 떼어낸다.
    if (hour.startsWith('0')) {
      hour = hour.substring(1);
    }

    // int.parse를 통해 String을 int로 바꾸고,
    // TimeOfDay로 바꾸어 반환한다.
    return TimeOfDay(hour: int.parse(hour), minute: int.parse(minute));
  }

  String convertTimetoString(TimeOfDay time) {
    return time.toString().substring(10, 15);
  }

  Widget buildCheckBox(String name, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        Checkbox(
          activeColor: Colors.blue,
          checkColor: Colors.white,
          value: isTakeOn[index],
          onChanged: (check) {
            setState(() {
              isTakeOn[index] = check!;
            });
          },
        ),
      ],
    );
  }

// 2023.03.09
// screenWidth와 screenHeigh는 추후에 전역적으로 사용할 수 있도록
// data class로 만들고, import해서 사용할 수 있도록 해보자.
  Widget buildAlarmCard(String name, double screenWidth, double screenHeight) {
    late int index;
    late TimeOfDay? pickedTime;

    switch (name) {
      case '아침 알람':
        index = 0;
        break;
      case '점심 알람':
        index = 1;
        break;
      case '저녁 알람':
        index = 2;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.08,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 2023.03.09
                // 아침, 점심, 저녁에 약을 먹는지에 따라
                // 출력하는 아이콘을 다르게 만든다.
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: isTakeOn[index]
                      ? const Icon(
                          Icons.alarm_on,
                          size: 50,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.alarm_off,
                          size: 50,
                          color: Colors.white,
                        ),
                ),
                isTakeOn[index]
                    ? Text(
                        pickedTimes[index].toString().substring(10, 15),
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'OFF',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: isTakeOn[index]
                        ? () async {
                            pickedTime = await showTimePicker(
                              context: context,
                              initialTime:
                                  convertStringToTime(pickedTimes[index]),
                            );

                            if (pickedTime != null) {
                              pickedTimes[index] =
                                  convertTimetoString(pickedTime!);
                              setState(() {});
                            }
                          }
                        : () {
                            util.showToast(index + 4);
                          },
                    child: const Text('설정'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // 2023.03.09
      // Set this property to avoid bottom overflow
      // cause by the keyboard pop-uping.
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '약은 먹고 다니냐?',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight * 0.05,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            height: screenHeight * 0.07,
            width: screenWidth * 0.2,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.alarm,
                    size: 50,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: screenHeight * 0.7,
                width: screenWidth * 0.8,
                decoration: const BoxDecoration(),
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: false,
                      initialValue: medicineName,
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
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildCheckBox('아침', 0),
                        buildCheckBox('점심', 1),
                        buildCheckBox('저녁', 2)
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    Column(
                      children: [
                        buildAlarmCard('아침 알람', screenWidth, screenHeight),
                        buildAlarmCard('점심 알람', screenWidth, screenHeight),
                        buildAlarmCard('저녁 알람', screenWidth, screenHeight),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('취소'),
                        ),
                        SizedBox(
                          width: screenWidth * 0.05,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // 2023.03.09
                            // 바뀐 상태를 출력해주고, 정말 이렇게 할건지 확인하는 dialog 설정.
                            // 데이터 전달은 데이터 전달을 위한 data class를 세팅하고, 이를 전달.
                            if (medicineName == '') {
                              util.showToast(3);
                              return;
                            }

                            // 2023.03.10
                            // 사용자가 알람을 의도적으로 모두 끄길 원하는 상황이
                            // 생길 수도 있기 때문에, 해당 if문은 comment out 처리함.
                            // else if (isTakeOn[0] == false &&
                            //     isTakeOn[1] == false &&
                            //     isTakeOn[2] == false) {
                            //   util.showToast(7);
                            //   return;
                            // }

                            // 2023.03.10
                            // 수정된 내용이 있는지 없는지를 체크,
                            // 만약 수정된 내용이 없다면 showToast를 띄우고
                            // 수정할 내용이 필요하다고 안내한다.
                            if (widget.sectionDivider == 1) {
                              if (widget.alarmInformation!.medicineName ==
                                      medicineName &&
                                  widget.alarmInformation!.isTakeOn![0] ==
                                      isTakeOn[0] &&
                                  widget.alarmInformation!.isTakeOn![1] ==
                                      isTakeOn[1] &&
                                  widget.alarmInformation!.isTakeOn![2] ==
                                      isTakeOn[2] &&
                                  widget.alarmInformation!.pickedTimes![0] ==
                                      pickedTimes[0] &&
                                  widget.alarmInformation!.pickedTimes![1] ==
                                      pickedTimes[1] &&
                                  widget.alarmInformation!.pickedTimes![2] ==
                                      pickedTimes[2]) {
                                util.showToast(8);
                                return;
                              }
                            }

                            var result = AlarmInformation(
                              medicineName: medicineName,
                              isTakeOn: isTakeOn,
                              pickedTimes: pickedTimes,
                            );

                            Navigator.of(context).pop(result);
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
