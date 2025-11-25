import 'package:flutter/material.dart';

void main() {
  runApp(const UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const ConverterScreen(),
    );
  }
}

enum ConversionType { length, temperature, volume, time }

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final lengthUnits = ["Meters", "Kilometers", "Feet", "Yards", "Miles"];
  final temperatureUnits = ["Celsius", "Fahrenheit", "Kelvin"];
  final volumeUnits = ["Milliliters", "Liters", "Cups", "Pints", "Gallons"];
  final timeUnits = ["Seconds", "Minutes", "Hours", "Days"];

  ConversionType conversionType = ConversionType.length;
  String inputValue = "";
  String? inputUnit;
  String? outputUnit;

  List<String> get units {
    switch (conversionType) {
      case ConversionType.length:
        return lengthUnits;
      case ConversionType.temperature:
        return temperatureUnits;
      case ConversionType.volume:
        return volumeUnits;
      case ConversionType.time:
        return timeUnits;
    }
  }

  @override
  void initState() {
    super.initState();
    inputUnit = units.first;
    outputUnit = units.last;
  }

  void resetUnits() {
    setState(() {
      inputUnit = units.first;
      outputUnit = units.last;
      inputValue = "";
    });
  }

  double convert(double value) {
    switch (conversionType) {
      case ConversionType.length:
        return convertLength(value);
      case ConversionType.temperature:
        return convertTemperature(value);
      case ConversionType.volume:
        return convertVolume(value);
      case ConversionType.time:
        return convertTime(value);
    }
  }

  double convertLength(double value) {
    double valueInMeters;
    switch (inputUnit) {
      case "Meters":
        valueInMeters = value;
        break;
      case "Kilometers":
        valueInMeters = value * 1000;
        break;
      case "Feet":
        valueInMeters = value * 0.3048;
        break;
      case "Yards":
        valueInMeters = value * 0.9144;
        break;
      case "Miles":
        valueInMeters = value * 1609.34;
        break;
      default:
        valueInMeters = value;
    }

    switch (outputUnit) {
      case "Meters":
        return valueInMeters;
      case "Kilometers":
        return valueInMeters / 1000;
      case "Feet":
        return valueInMeters / 0.3048;
      case "Yards":
        return valueInMeters / 0.9144;
      case "Miles":
        return valueInMeters / 1609.34;
      default:
        return valueInMeters;
    }
  }

  double convertTemperature(double value) {
    double valueInCelsius;
    switch (inputUnit) {
      case "Celsius":
        valueInCelsius = value;
        break;
      case "Fahrenheit":
        valueInCelsius = (value - 32) * 5 / 9;
        break;
      case "Kelvin":
        valueInCelsius = value - 273.15;
        break;
      default:
        valueInCelsius = value;
    }

    switch (outputUnit) {
      case "Celsius":
        return valueInCelsius;
      case "Fahrenheit":
        return valueInCelsius * 9 / 5 + 32;
      case "Kelvin":
        return valueInCelsius + 273.15;
      default:
        return valueInCelsius;
    }
  }

  double convertVolume(double value) {
    double valueInML;
    switch (inputUnit) {
      case "Milliliters":
        valueInML = value;
        break;
      case "Liters":
        valueInML = value * 1000;
        break;
      case "Cups":
        valueInML = value * 240;
        break;
      case "Pints":
        valueInML = value * 473.176;
        break;
      case "Gallons":
        valueInML = value * 3785.41;
        break;
      default:
        valueInML = value;
    }

    switch (outputUnit) {
      case "Milliliters":
        return valueInML;
      case "Liters":
        return valueInML / 1000;
      case "Cups":
        return valueInML / 240;
      case "Pints":
        return valueInML / 473.176;
      case "Gallons":
        return valueInML / 3785.41;
      default:
        return valueInML;
    }
  }

  double convertTime(double value) {
    double valueInSeconds;
    switch (inputUnit) {
      case "Seconds":
        valueInSeconds = value;
        break;
      case "Minutes":
        valueInSeconds = value * 60;
        break;
      case "Hours":
        valueInSeconds = value * 3600;
        break;
      case "Days":
        valueInSeconds = value * 86400;
        break;
      default:
        valueInSeconds = value;
    }

    switch (outputUnit) {
      case "Seconds":
        return valueInSeconds;
      case "Minutes":
        return valueInSeconds / 60;
      case "Hours":
        return valueInSeconds / 3600;
      case "Days":
        return valueInSeconds / 86400;
      default:
        return valueInSeconds;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double result = convert(double.tryParse(inputValue) ?? 0);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Converter', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Conversion Type Chips
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: ConversionType.values.map((type) {
                    final isSelected = type == conversionType;
                    return ChoiceChip(
                      label: Text(
                        type.name.capitalize(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            conversionType = type;
                            resetUnits();
                          });
                        }
                      },
                      selectedColor: colorScheme.primaryContainer,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Input Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Enter value',
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      onChanged: (value) =>
                          setState(() => inputValue = value),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: inputUnit,
                      decoration: InputDecoration(
                        labelText: 'From Unit',
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      items: units
                          .map((unit) =>
                          DropdownMenuItem(value: unit, child: Text(unit)))
                          .toList(),
                      onChanged: (value) => setState(() => inputUnit = value),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Output Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: outputUnit,
                      decoration: InputDecoration(
                        labelText: 'To Unit',
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      items: units
                          .map((unit) =>
                          DropdownMenuItem(value: unit, child: Text(unit)))
                          .toList(),
                      onChanged: (value) => setState(() => outputUnit = value),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      result.toStringAsFixed(4),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}