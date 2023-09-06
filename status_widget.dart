import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final String sex;
  final int age;

  StatusWidget({required this.sex,
      required this.age,});

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildButton(context, '0', 'Treatments'),
            buildDivider(),
            buildButton(context, age.toString(), 'Age'),
            buildDivider(),
            buildButton(context, sex, 'Sex'),
          ],
        ),
  );

  Widget buildDivider() => const SizedBox(height: 24, child: VerticalDivider());
  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical:4),
        onPressed: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w300),
            )
          ],
        ),
      );
}
