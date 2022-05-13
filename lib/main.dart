import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart' as intl;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter circular time selector Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter circular time selector'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: SafeArea(
        child: Center(
            child: SleekCircularSlider(
          onChange: (double value) {
            setState(() {
              _date = printDateFromValue(value);
            });
          },
          onChangeEnd: (double value) {
            setState(() {
              _date = printDateFromValue(value);
            });
            // TODO : show RTSP video from this timestamp
          },
          appearance: appearance,
          min: 0,
          max: 86400,
          initialValue: _value,
          innerWidget: (d) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Shown timestamp',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                GestureDetector(
                  onTap: () {
                    DatePicker.showTimePicker(context,
                        showTitleActions: true,
                        currentTime: _date, onConfirm: (date) {
                      setState(() {
                        _date = date;
                        _value = printValueFromDate(date);
                      });
                      // TODO : show RTSP video from this timestamp
                    });
                  },
                  child: Text(
                    '${intl.NumberFormat('00').format(_date.hour)}:${intl.NumberFormat('00').format(_date.minute)}:${intl.NumberFormat('00').format(_date.second)}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 50.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        )),
      )),
    );
  }

  DateTime printDateFromValue(double value) {
    int hours = value ~/ 3600;
    int minutes = (value - (hours * 3600)) ~/ 60;
    int seconds = (value - (hours * 3600) - (minutes * 60)).floor();

    DateTime returnDate =
        DateTime(_date.year, _date.month, _date.day, hours, minutes, seconds);

    return returnDate;
  }

  double printValueFromDate(DateTime date) {
    double returnValue =
        ((date.hour * 3600) + (date.minute * 60) + date.second).toDouble();

    return returnValue;
  }
}

final customColors = CustomSliderColors(
    dotColor: HexColor('#FFFFFF'),
    trackColor: HexColor('#E9585A'),
    progressBarColors: [Colors.transparent, Colors.transparent],
    shadowColor: Colors.transparent,
    shadowMaxOpacity: 0);
final CircularSliderAppearance appearance = CircularSliderAppearance(
    customWidths: CustomSliderWidths(
        trackWidth: 40, progressBarWidth: 60, shadowWidth: 0),
    customColors: customColors,
    startAngle: 270,
    angleRange: 360,
    size: 350.0);
