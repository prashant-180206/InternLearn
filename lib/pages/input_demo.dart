import 'package:flutter/material.dart';

class InputDemo extends StatefulWidget {
  const InputDemo({super.key});

  @override
  State<InputDemo> createState() => _InputDemoState();
}

class _InputDemoState extends State<InputDemo> {
  String inputText = '';
  bool checkboxValue = false;
  bool checkboxtileValue = false;
  bool switchValue = false;
  String radioValue = '';
  double sliderValue = 0;
  final TextEditingController inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Demo')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter something',
                border: OutlineInputBorder(),
              ),
              controller: inputController,
            ),
            Checkbox(
              value: checkboxValue,
              onChanged: (bool? value) {
                setState(() {
                  checkboxValue = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Accept Terms and Conditions'),
              value: checkboxtileValue,
              onChanged: (bool? value) {
                setState(() {
                  checkboxtileValue = value ?? false;
                });
              },
            ),
            Switch(
              value: switchValue,
              onChanged: (bool value) {
                setState(() {
                  switchValue = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: switchValue,
              onChanged: (bool value) {
                setState(() {
                  switchValue = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  inputText = inputController.text;
                });
              },
              child: Text('Submit'),
            ),

            RadioGroup(
              groupValue: radioValue,
              onChanged: (value) => setState(() {
                radioValue = value!;
              }),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Text('Option 1'),
                    value: 'Option 1',
                  ),
                  RadioListTile<String>(
                    title: Text('Option 2'),
                    value: 'Option 2',
                  ),
                  RadioListTile<String>(
                    title: Text('Option 3'),
                    value: 'Option 3',
                  ),
                ],
              ),
            ),
            Slider(
              value: sliderValue,
              onChanged: (val) {
                setState(() {
                  sliderValue = val;
                });
              },
              min: 0,
              max: 100,
              divisions: 100,

            ),
            Text('Slider value: $sliderValue'),

            Text('You entered: $inputText'),
            Text('Checkbox is ${checkboxValue ? "checked" : "unchecked"}'),
            Text(
              'CheckboxListTile is ${checkboxtileValue ? "checked" : "unchecked"}',
            ),
            Text('Switch is ${switchValue ? "on" : "off"}'),
            Text('Radio is $radioValue'),
          ],
        ),
      ),
    );
  }
}
