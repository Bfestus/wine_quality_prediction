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
      theme: ThemeData(primarySwatch: Colors.blue),
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
    final apiUrl = 'http://127.0.0.1:8000/predict'; // Replace with your API URL

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
        title: Text('Wine Quality Predictor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _fixedAcidityController,
                decoration: InputDecoration(labelText: 'Fixed Acidity (0-15)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _volatileAcidityController,
                decoration:
                    InputDecoration(labelText: 'Volatile Acidity (0-2)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _citricAcidController,
                decoration: InputDecoration(labelText: 'Citric Acid (0-1)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _alcoholController,
                decoration: InputDecoration(labelText: 'Alcohol (0-20)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _residualSugarController,
                decoration: InputDecoration(labelText: 'Residual Sugar (0-50)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _pHController,
                decoration: InputDecoration(labelText: 'pH (0-14)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _predictWineQuality,
                child: Text('Predict'),
              ),
              SizedBox(height: 20),
              Text(
                _predictionResult,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
