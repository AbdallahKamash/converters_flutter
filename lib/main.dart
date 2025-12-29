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
      title: 'Precision Converter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displaySmall: TextStyle(fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          displaySmall: TextStyle(fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const ConverterScreen(),
    );
  }
}

enum ConversionType {
  length(Icons.straighten_rounded),
  temperature(Icons.thermostat_rounded),
  volume(Icons.opacity_rounded),
  time(Icons.timer_rounded);

  final IconData icon;
  const ConversionType(this.icon);
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final Map<ConversionType, List<String>> _unitsMap = {
    ConversionType.length: ['Meters', 'Kilometers', 'Feet', 'Yards', 'Miles'],
    ConversionType.temperature: ['Celsius', 'Fahrenheit', 'Kelvin'],
    ConversionType.volume: [
      'Milliliters',
      'Liters',
      'Cups',
      'Pints',
      'Gallons',
    ],
    ConversionType.time: ['Seconds', 'Minutes', 'Hours', 'Days'],
  };

  ConversionType _type = ConversionType.length;
  String _input = '';
  String? _fromUnit;
  String? _toUnit;

  @override
  void initState() {
    super.initState();
    _resetUnits();
  }

  void _resetUnits() {
    final units = _unitsMap[_type]!;
    _fromUnit = units.first;
    _toUnit = units.length > 1 ? units[1] : units.first;
    _input = '';
  }

  double _convert(double value) {
    switch (_type) {
      case ConversionType.length:
        return _convertLength(value);
      case ConversionType.temperature:
        return _convertTemperature(value);
      case ConversionType.volume:
        return _convertVolume(value);
      case ConversionType.time:
        return _convertTime(value);
    }
  }

  double _convertLength(double value) {
    final mMap = {
      'Meters': 1.0,
      'Kilometers': 1000.0,
      'Feet': 0.3048,
      'Yards': 0.9144,
      'Miles': 1609.34,
    };
    final inMeters = value * (mMap[_fromUnit] ?? 1.0);
    return inMeters / (mMap[_toUnit] ?? 1.0);
  }

  double _convertTemperature(double value) {
    double celsius;
    if (_fromUnit == 'Fahrenheit') {
      celsius = (value - 32) * 5 / 9;
    } else if (_fromUnit == 'Kelvin') {
      celsius = value - 273.15;
    } else {
      celsius = value;
    }

    if (_toUnit == 'Fahrenheit') {
      return celsius * 9 / 5 + 32;
    } else if (_toUnit == 'Kelvin') {
      return celsius + 273.15;
    }
    return celsius;
  }

  double _convertVolume(double value) {
    final mlMap = {
      'Milliliters': 1.0,
      'Liters': 1000.0,
      'Cups': 240.0,
      'Pints': 473.176,
      'Gallons': 3785.41,
    };
    final inMl = value * (mlMap[_fromUnit] ?? 1.0);
    return inMl / (mlMap[_toUnit] ?? 1.0);
  }

  double _convertTime(double value) {
    final sMap = {
      'Seconds': 1.0,
      'Minutes': 60.0,
      'Hours': 3600.0,
      'Days': 86400.0,
    };
    final inSeconds = value * (sMap[_fromUnit] ?? 1.0);
    return inSeconds / (sMap[_toUnit] ?? 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final result = _convert(double.tryParse(_input) ?? 0);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Precision Converter'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withValues(alpha: 0.0),
              colorScheme.surface.withValues(alpha: 0.2),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTypeSelector(colorScheme),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    _buildUnitSelectors(colorScheme),
                    const SizedBox(height: 32),
                    _buildConversionCard(colorScheme, theme, result),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector(ColorScheme colorScheme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ConversionType.values.map((type) {
          final isSelected = _type == type;
          return Padding(
            padding: EdgeInsets.only(right: 12, left: type.index == 0 ? 12 : 0),
            child: ChoiceChip(
              avatar: Icon(
                type.icon,
                size: 18,
                color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
              ),
              label: Text(type.name.capitalize()),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _type = type;
                    _resetUnits();
                  });
                }
              },
              showCheckmark: false,
              selectedColor: colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConversionCard(
    ColorScheme colorScheme,
    ThemeData theme,
    double result,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      color: colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            TextField(
              textAlign: TextAlign.center,
              style: theme.textTheme.displaySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                border: InputBorder.none,
                suffixText: _fromUnit,
                suffixStyle: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (value) => setState(() => _input = value),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_downward_rounded,
                  color: colorScheme.primary,
                ),
              ),
            ),
            Column(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    result.toStringAsFixed(result == result.toInt() ? 0 : 4),
                    key: ValueKey(result),
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _toUnit ?? '',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitSelectors(ColorScheme colorScheme) {
    final units = _unitsMap[_type]!;
    return Row(
      children: [
        Expanded(
          child: _buildDropdown(
            label: 'From',
            value: _fromUnit,
            items: units,
            onChanged: (val) => setState(() => _fromUnit = val),
            colorScheme: colorScheme,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDropdown(
            label: 'To',
            value: _toUnit,
            items: units,
            onChanged: (val) => setState(() => _toUnit = val),
            colorScheme: colorScheme,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required ColorScheme colorScheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: colorScheme.primary,
              ),
              items: items
                  .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
