import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  time(Icons.timer_rounded),
  area(Icons.square_foot_rounded),
  mass(Icons.monitor_weight_rounded),
  speed(Icons.speed_rounded),
  data(Icons.storage_rounded),
  energy(Icons.bolt_rounded),
  pressure(Icons.compress_rounded),
  tipCalculator(Icons.receipt_long_rounded);

  final IconData icon;
  const ConversionType(this.icon);

  String get displayName {
    switch (this) {
      case ConversionType.tipCalculator:
        return 'Tip Calculator';
      default:
        return name.capitalize();
    }
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final Map<ConversionType, List<String>> _unitsMap = {
    ConversionType.length: [
      'Meters',
      'Kilometers',
      'Centimeters',
      'Millimeters',
      'Inches',
      'Feet',
      'Yards',
      'Miles',
      'Nautical Miles',
    ],
    ConversionType.temperature: ['Celsius', 'Fahrenheit', 'Kelvin'],
    ConversionType.volume: [
      'Liters',
      'Milliliters',
      'Cubic Meters',
      'Cubic Centimeters',
      'Gallons',
      'Quarts',
      'Pints',
      'Cups',
      'Fluid Ounces',
      'Tablespoons',
      'Teaspoons',
    ],
    ConversionType.time: [
      'Seconds',
      'Minutes',
      'Hours',
      'Days',
      'Weeks',
      'Months',
      'Years',
      'Milliseconds',
      'Microseconds',
      'Nanoseconds',
    ],
    ConversionType.area: [
      'Square Meters',
      'Square Kilometers',
      'Square Centimeters',
      'Square Millimeters',
      'Square Inches',
      'Square Feet',
      'Square Yards',
      'Square Miles',
      'Acres',
      'Hectares',
    ],
    ConversionType.mass: [
      'Grams',
      'Kilograms',
      'Milligrams',
      'Metric Tons',
      'Pounds',
      'Ounces',
      'Stones',
    ],
    ConversionType.speed: [
      'Meters/Second',
      'Kilometers/Hour',
      'Miles/Hour',
      'Knots',
      'Mach',
    ],
    ConversionType.data: [
      'Bits',
      'Bytes',
      'Kilobits',
      'Kilobytes',
      'Megabits',
      'Megabytes',
      'Gigabits',
      'Gigabytes',
      'Terabits',
      'Terabytes',
    ],
    ConversionType.energy: [
      'Joules',
      'Kilojoules',
      'Calories',
      'Kilocalories',
      'Watt-hours',
      'Kilowatt-hours',
    ],
    ConversionType.pressure: [
      'Pascals',
      'Kilopascals',
      'Bar',
      'PSI',
      'Atmospheres',
      'Torr',
    ],
    ConversionType.tipCalculator: [],
  };

  ConversionType _type = ConversionType.length;
  String _input = '';
  String? _fromUnit;
  String? _toUnit;

  // Tip Calculator controllers
  final _billController = TextEditingController();
  final _tipController = TextEditingController();
  final _peopleController = TextEditingController();

  // Area Calculator controllers
  final _dim1Controller = TextEditingController();
  final _dim2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resetUnits();
  }

  @override
  void dispose() {
    _billController.dispose();
    _tipController.dispose();
    _peopleController.dispose();
    _dim1Controller.dispose();
    _dim2Controller.dispose();
    super.dispose();
  }

  void _resetUnits() {
    final units = _unitsMap[_type]!;
    if (units.isNotEmpty) {
      _fromUnit = units.first;
      _toUnit = units.length > 1 ? units[1] : units.first;
    } else {
      _fromUnit = null;
      _toUnit = null;
    }
    _input = '';
    _billController.clear();
    _tipController.text = '15';
    _peopleController.text = '1';
    _dim1Controller.clear();
    _dim2Controller.clear();
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
      case ConversionType.area:
        return _convertArea(value);
      case ConversionType.mass:
        return _convertMass(value);
      case ConversionType.speed:
        return _convertSpeed(value);
      case ConversionType.data:
        return _convertData(value);
      case ConversionType.energy:
        return _convertEnergy(value);
      case ConversionType.pressure:
        return _convertPressure(value);
      case ConversionType.tipCalculator:
        return 0;
    }
  }

  double _convertLength(double value) {
    final Map<String, double> mMap = {
      'Meters': 1.0,
      'Kilometers': 1000.0,
      'Centimeters': 0.01,
      'Millimeters': 0.001,
      'Inches': 0.0254,
      'Feet': 0.3048,
      'Yards': 0.9144,
      'Miles': 1609.344,
      'Nautical Miles': 1852.0,
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
    final Map<String, double> mlMap = {
      'Liters': 1000.0,
      'Milliliters': 1.0,
      'Cubic Meters': 1000000.0,
      'Cubic Centimeters': 1.0,
      'Gallons': 3785.41,
      'Quarts': 946.353,
      'Pints': 473.176,
      'Cups': 240.0,
      'Fluid Ounces': 29.5735,
      'Tablespoons': 14.7868,
      'Teaspoons': 4.92892,
    };
    final inMl = value * (mlMap[_fromUnit] ?? 1.0);
    return inMl / (mlMap[_toUnit] ?? 1.0);
  }

  double _convertTime(double value) {
    final Map<String, double> sMap = {
      'Seconds': 1.0,
      'Minutes': 60.0,
      'Hours': 3600.0,
      'Days': 86400.0,
      'Weeks': 604800.0,
      'Months': 2592000.0,
      'Years': 31536000.0,
      'Milliseconds': 0.001,
      'Microseconds': 0.000001,
      'Nanoseconds': 0.000000001,
    };
    final inSeconds = value * (sMap[_fromUnit] ?? 1.0);
    return inSeconds / (sMap[_toUnit] ?? 1.0);
  }

  double _convertArea(double value) {
    final Map<String, double> sqMMap = {
      'Square Meters': 1.0,
      'Square Kilometers': 1000000.0,
      'Square Centimeters': 0.0001,
      'Square Millimeters': 0.000001,
      'Square Inches': 0.00064516,
      'Square Feet': 0.092903,
      'Square Yards': 0.836127,
      'Square Miles': 2589988.11,
      'Acres': 4046.86,
      'Hectares': 10000.0,
    };
    final inSqM = value * (sqMMap[_fromUnit] ?? 1.0);
    return inSqM / (sqMMap[_toUnit] ?? 1.0);
  }

  double _convertMass(double value) {
    final Map<String, double> gMap = {
      'Grams': 1.0,
      'Kilograms': 1000.0,
      'Milligrams': 0.001,
      'Metric Tons': 1000000.0,
      'Pounds': 453.592,
      'Ounces': 28.3495,
      'Stones': 6350.29,
    };
    final inGrams = value * (gMap[_fromUnit] ?? 1.0);
    return inGrams / (gMap[_toUnit] ?? 1.0);
  }

  double _convertSpeed(double value) {
    final Map<String, double> msMap = {
      'Meters/Second': 1.0,
      'Kilometers/Hour': 0.277778,
      'Miles/Hour': 0.44704,
      'Knots': 0.514444,
      'Mach': 343.0,
    };
    final inMs = value * (msMap[_fromUnit] ?? 1.0);
    return inMs / (msMap[_toUnit] ?? 1.0);
  }

  double _convertData(double value) {
    final Map<String, double> bitMap = {
      'Bits': 1.0,
      'Bytes': 8.0,
      'Kilobits': 1000.0,
      'Kilobytes': 8000.0,
      'Megabits': 1000000.0,
      'Megabytes': 8000000.0,
      'Gigabits': 1000000000.0,
      'Gigabytes': 8000000000.0,
      'Terabits': 1000000000000.0,
      'Terabytes': 8000000000000.0,
    };
    final inBits = value * (bitMap[_fromUnit] ?? 1.0);
    return inBits / (bitMap[_toUnit] ?? 1.0);
  }

  double _convertEnergy(double value) {
    final Map<String, double> jMap = {
      'Joules': 1.0,
      'Kilojoules': 1000.0,
      'Calories': 4.184,
      'Kilocalories': 4184.0,
      'Watt-hours': 3600.0,
      'Kilowatt-hours': 3600000.0,
    };
    final inJoules = value * (jMap[_fromUnit] ?? 1.0);
    return inJoules / (jMap[_toUnit] ?? 1.0);
  }

  double _convertPressure(double value) {
    final Map<String, double> pMap = {
      'Pascals': 1.0,
      'Kilopascals': 1000.0,
      'Bar': 100000.0,
      'PSI': 6894.76,
      'Atmospheres': 101325.0,
      'Torr': 133.322,
    };
    final inPascals = value * (pMap[_fromUnit] ?? 1.0);
    return inPascals / (pMap[_toUnit] ?? 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final result = _type == ConversionType.tipCalculator
        ? 0.0
        : _convert(double.tryParse(_input) ?? 0);

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
                    if (_type == ConversionType.tipCalculator)
                      _buildTipCalculator(colorScheme, theme)
                    else ...[
                      _buildUnitSelectors(colorScheme),
                      const SizedBox(height: 32),
                      _buildConversionCard(colorScheme, theme, result),
                    ],
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
              label: Text(type.displayName),
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

  Widget _buildTipCalculator(ColorScheme colorScheme, ThemeData theme) {
    final bill = double.tryParse(_billController.text) ?? 0.0;
    final tipPct = double.tryParse(_tipController.text) ?? 0.0;
    final people = int.tryParse(_peopleController.text) ?? 1;

    final tipAmount = bill * (tipPct / 100);
    final total = bill + tipAmount;
    final perPerson = people > 0 ? total / people : total;

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
            _buildCalculatorField(
              controller: _billController,
              label: 'Bill Amount',
              icon: Icons.attach_money_rounded,
              onChanged: (_) => setState(() {}),
              colorScheme: colorScheme,
              theme: theme,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCalculatorField(
                    controller: _tipController,
                    label: 'Tip %',
                    icon: Icons.percent_rounded,
                    onChanged: (_) => setState(() {}),
                    colorScheme: colorScheme,
                    theme: theme,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCalculatorField(
                    controller: _peopleController,
                    label: 'People',
                    icon: Icons.people_rounded,
                    onChanged: (_) => setState(() {}),
                    colorScheme: colorScheme,
                    theme: theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildResultRow(
              'Tip Amount',
              '\$${tipAmount.toStringAsFixed(2)}',
              colorScheme,
              theme,
            ),
            const Divider(height: 32),
            _buildResultRow(
              'Total Bill',
              '\$${total.toStringAsFixed(2)}',
              colorScheme,
              theme,
              isTotal: true,
            ),
            const SizedBox(height: 8),
            _buildResultRow(
              'Per Person',
              '\$${perPerson.toStringAsFixed(2)}',
              colorScheme,
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ValueChanged<String> onChanged,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: colorScheme.surface,
      ),
    );
  }

  Widget _buildResultRow(
    String label,
    String value,
    ColorScheme colorScheme,
    ThemeData theme, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: isTotal ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 24 : 20,
          ),
        ),
      ],
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
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final text = newValue.text;
                  if (text.isEmpty) return newValue;
                  if (text.split('.').length > 2) return oldValue;
                  return newValue;
                }),
              ],
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
                  duration: const Duration(milliseconds: 200),
                  reverseDuration: const Duration(milliseconds: 0),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                  child: Text(
                    result
                        .toStringAsFixed(10)
                        .replaceFirst(RegExp(r'0+$'), '')
                        .replaceFirst(RegExp(r'\.$'), ''),
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
