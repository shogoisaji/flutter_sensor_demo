import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SensorPage(),
    );
  }
}

class SensorPage extends StatefulWidget {
  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  double _sliderValue = 1;
  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;
  MagnetometerEvent? _magnetometerEvent;
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel(); // 既存のタイマーをキャンセル
    _timer = Timer.periodic(Duration(milliseconds: (_sliderValue * 1000).toInt()), (timer) {
      setState(() {}); // センサーデータを更新
    });
  }

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((event) {
      _accelerometerEvent = event;
    });
    gyroscopeEvents.listen((event) {
      _gyroscopeEvent = event;
    });
    magnetometerEvents.listen((event) {
      _magnetometerEvent = event;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String format(double? value) => value?.toStringAsFixed(1) ?? "-";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Data Get Interval: ${_sliderValue.toStringAsFixed(1)}s'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72.0),
            child: Slider(
              min: 0.1,
              max: 1.0,
              divisions: 9,
              value: _sliderValue,
              label: '${_sliderValue.toStringAsFixed(1)}s',
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                });
                _startTimer();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text('Accelerometer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                    'X: ${format(_accelerometerEvent?.x)}\nY: ${format(_accelerometerEvent?.y)}\nZ: ${format(_accelerometerEvent?.z)}',
                    style: TextStyle(fontSize: 24)),
                const SizedBox(
                  height: 20,
                ),
                const Text('Gyroscope', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                    'X: ${format(_gyroscopeEvent?.x)}\nY: ${format(_gyroscopeEvent?.y)}\nZ: ${format(_gyroscopeEvent?.z)}',
                    style: TextStyle(fontSize: 24)),
                const SizedBox(
                  height: 20,
                ),
                const Text('Magnetometer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                    'X: ${format(_magnetometerEvent?.x)}\nY: ${format(_magnetometerEvent?.y)}\nZ: ${format(_magnetometerEvent?.z)}',
                    style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
