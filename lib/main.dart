import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double fahTemp = 0.00, celTemp = 0.00;
  bool isFah = true;
  var fahController = TextEditingController();
  var celController = TextEditingController();
  List<String> history = []; // List to store the conversion history

  // Converts temperatures based on the input and updates the history list
  void convertTemperature() {
    setState(() {
      if (isFah) {
        fahTemp = double.tryParse(fahController.text) ?? 0.0;
        celTemp = convert(fahTemp, true);
        celController.text = celTemp.toStringAsFixed(2);
        history.add('F: ${fahTemp.toStringAsFixed(2)} °F → C: ${celTemp.toStringAsFixed(2)} °C');
      } else {
        celTemp = double.tryParse(celController.text) ?? 0.0;
        fahTemp = convert(celTemp, false);
        fahController.text = fahTemp.toStringAsFixed(2);
        history.add('C: ${celTemp.toStringAsFixed(2)} °C → F: ${fahTemp.toStringAsFixed(2)} °F');
      }
    });
  }

  // Function to convert temperatures between Fahrenheit and Celsius
  double convert(double temp, bool isF) {
    return isF ? (temp - 32) * (5 / 9) : (temp * 9 / 5) + 32;
  }

  // Toggles between Fahrenheit and Celsius conversion mode
  void toggleConversionMode() {
    setState(() {
      isFah = !isFah;
      fahController.clear();
      celController.clear();
    });
  }

  // Clears the conversion history
  void clearHistory() {
    setState(() {
      history.clear();
    });
  }

  // Determines the appropriate icon based on the temperature
  Widget getTemperatureIcon(double temp, bool isCelsius) {
    if (isCelsius && temp <= 0 || !isCelsius && temp <= 32) {
      return Icon(Icons.ac_unit, color: Colors.blue); // Cold - Snowflake icon
    } else if (isCelsius && temp >= 30 || !isCelsius && temp >= 86) {
      return Icon(Icons.wb_sunny, color: Colors.red); // Hot - Sun icon
    } else {
      return Icon(Icons.thermostat, color: Colors.orange); // Moderate - Thermometer icon
    }
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Temperature Converter';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        backgroundColor: const Color(0xFF86A873),
        appBar: AppBar(
          title: const Text(appTitle),
          backgroundColor: const Color(0xFFBB9F06),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: clearHistory,
              tooltip: 'Clear History',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Celsius',
                          style: TextStyle(
                            color: Color(0xFFEFEFD0),
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: celController,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            suffixText: '°C',
                          ),
                          onChanged: (_) => isFah = false,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz, color: Color(0xFFEFEFD0)),
                    onPressed: toggleConversionMode,
                    tooltip: 'Swap Conversion',
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Fahrenheit',
                          style: TextStyle(
                            color: Color(0xFFEFEFD0),
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: fahController,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                          decoration: const InputDecoration(
                            suffixText: '°F',
                          ),
                          onChanged: (_) => isFah = true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              // Convert Button
              ElevatedButton(
                onPressed: convertTemperature,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBB9F06),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                ),
                child: const Text(
                    'Convert',
                style: const TextStyle(
                  fontSize: 18
                ),),
              ),
              const SizedBox(height: 20),
              // Display Conversion History
              Expanded(
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    double value = double.tryParse(
                      history[index].split(':')[1].split('→')[0].trim().split(' ')[0],
                    ) ??
                        0.0;
                    return Card(
                      color: const Color(0xFFBB9F06),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: getTemperatureIcon(value, isFah),
                        title: Text(
                          history[index],
                          style: const TextStyle(
                            fontSize: 25,
                            color: Color(0xFFEFEFD0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
