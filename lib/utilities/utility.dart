import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utility {
  FToast fToast = FToast();
  late BuildContext context;
  List<String> alertMessage = [
    "약 알람이 추가되었습니다.",
    "약 알람이 제거되었습니다.",
    "성공적으로 수정되었습니다.",
    "약의 이름을 입력해주세요.",
    "먼저 아침 체크박스를 눌러주세요.",
    "먼저 점심 체크박스를 눌러주세요.",
    "먼저 저녁 체크박스를 눌러주세요.",
    "한 개 이상의 알람을 설정해주세요.",
    "수정된 내용이 없습니다.",
  ];

  void injectContext(BuildContext context) {
    this.context = context;
  }

  // context 주입
  void showToast(int type) {
    fToast.init(context);

    late ToastGravity location;
    late Color backgroundColor;

    // Success
    if (type >= 0 && type <= 2) {
      location = ToastGravity.BOTTOM;
      backgroundColor = Colors.blue;
    }
    // Warning
    else if (type >= 3) {
      location = ToastGravity.BOTTOM;
      backgroundColor = Colors.grey;
    }

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.3, 0.3),
            blurStyle: BlurStyle.inner,
          ),
        ],
        color: backgroundColor,
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
            alertMessage[type],
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
      gravity: location,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
