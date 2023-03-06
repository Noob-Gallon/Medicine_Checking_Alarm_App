import 'package:flutter/material.dart';
import 'package:my_medicine_checking_app/models/medicine_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 2023.03.06
  // MedicineWidget의 instance를 보관하는 List이다.
  List<MedicineModel> medicineList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: addNewMedicine,
                  icon: const Icon(
                    Icons.add_box_outlined,
                    size: 50,
                    color: Colors.blue,
                  ),
                ),
                const IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: null,
                  icon: Icon(
                    Icons.settings,
                    size: 50,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                height: 650,
                width: 400,
                child: makeMedicineList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void deleteMedicineFromList() {}

  void addNewMedicine() {
    late String medicineName;
    late String medicineDescription;
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
            title: const Text(
              '추가할 약의 정보를 입력해주세요.',
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '아침',
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
                      '알람 설정 기능 구현 예정...',
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
                  // [내용 수정]
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
                  // 2023.03.06
                  // this.setState()를 하면 현재 화면인 StatefulWidget을 다시 그릴 수 있다.
                  // this를 붙이지 않으면 현재 AlertDialog가 다시 그려지게 되므로,
                  // HomeScreen에서 추가된 약을 그릴 수 없다.
                  this.setState(() {
                    // 2023.03.06
                    // this.takeOnMorning... 으로 했었는데,
                    // 여기서 this는 scope가 addNewMedicine 내가 아닌
                    // _HomeScreenState가 되므로, this를 붙이면 안된다.
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
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 0,
            ),
            child: ListTile(
              title: Text(
                medicineList[index].name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: Text(
                medicineList[index].description,
              ),
              subtitleTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              leading: const Icon(
                Icons.medication_outlined,
                size: 50,
                color: Colors.white,
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
