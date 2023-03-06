import 'package:flutter/material.dart';

class MedicineWidget extends StatelessWidget {
  final String name;

  const MedicineWidget({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.medication_outlined,
                  size: 50,
                  color: Colors.white,
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 50,
            ),
            const Column(
              children: [
                IconButton(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  onPressed: null,
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
