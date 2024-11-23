import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(WineQualityApp());
}

class WineQualityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wine Quality Predictor',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Arial',
      ),
      home: PredictionScreen(),
    );
  }
}

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  // Controllers for each input field
  final _fixedAcidityController = TextEditingController();
  final _volatileAcidityController = TextEditingController();
  final _citricAcidController = TextEditingController();
  final _alcoholController = TextEditingController();
  final _residualSugarController = TextEditingController();
  final _pHController = TextEditingController();

  String _predictionResult = "";

  // Function to call the FastAPI endpoint
  Future<void> _predictWineQuality() async {
    final apiUrl =
        'https://winequality-ewyy.onrender.com/predict'; // Replace with your API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fixed_acidity": double.parse(_fixedAcidityController.text),
          "volatile_acidity": double.parse(_volatileAcidityController.text),
          "citric_acid": double.parse(_citricAcidController.text),
          "alcohol": double.parse(_alcoholController.text),
          "residual_sugar": double.parse(_residualSugarController.text),
          "pH": double.parse(_pHController.text),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _predictionResult = "Predicted Quality: ${data['prediction']}";
        });
      } else {
        setState(() {
          _predictionResult = "Error: ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      setState(() {
        _predictionResult = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wine Quality Predictor',
          style: TextStyle(
            color: Colors.white, // Makes the title text white
            fontWeight: FontWeight.bold, // Makes the text bold
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 194, 110, 143),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 183, 153, 170),
              const Color.fromARGB(255, 231, 229, 234)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter Wine Features',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                ..._buildInputFields(),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 150, // Set the desired width of the button
                    child: ElevatedButton(
                      onPressed: _predictWineQuality,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 194, 110, 143), // Button color
                        padding: EdgeInsets.symmetric(
                            vertical: 12), // Adjusted height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Predict',
                        style: TextStyle(
                          fontSize: 18, // Font size
                          color: Colors.white, // Text color
                          fontWeight: FontWeight.bold, // Text bold
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_predictionResult.isNotEmpty)
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _predictionResult,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInputFields() {
    final inputFields = [
      {"label": "Fixed Acidity (0-15)", "controller": _fixedAcidityController},
      {
        "label": "Volatile Acidity (0-2)",
        "controller": _volatileAcidityController
      },
      {"label": "Citric Acid (0-1)", "controller": _citricAcidController},
      {"label": "Alcohol (0-20)", "controller": _alcoholController},
      {
        "label": "Residual Sugar (0-50)",
        "controller": _residualSugarController
      },
      {"label": "pH (0-14)", "controller": _pHController},
    ];

    return inputFields.map((field) {
      return Card(
        margin: EdgeInsets.only(bottom: 16),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: field['controller'] as TextEditingController,
            decoration: InputDecoration(
              labelText: field['label'] as String,
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      );
    }).toList();
  }
}
