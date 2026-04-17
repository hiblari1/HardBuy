import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const HardBuyApp());
}

class HardBuyApp extends StatelessWidget {
  const HardBuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HardBuy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF7C4DFF),
        brightness: Brightness.dark,
        textTheme: GoogleFonts.googleSansTextTheme().copyWith(
          displaySmall: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
          headlineSmall: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
          titleLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
        ),
      ),
      home: const HardBuyHomePage(),
    );
  }
}

class Part {
  const Part({required this.name, required this.priceMad});

  final String name;
  final double priceMad;
}

class HardBuyHomePage extends StatefulWidget {
  const HardBuyHomePage({super.key});

  @override
  State<HardBuyHomePage> createState() => _HardBuyHomePageState();
}

class _HardBuyHomePageState extends State<HardBuyHomePage> {
  static const String _moneyKey = 'current_money_mad';
  static const double _goalMad = 18500;

  final TextEditingController _controller = TextEditingController();

  final List<Part> _parts = const <Part>[
    Part(name: 'AMD Ryzen 5 5600', priceMad: 1350),
    Part(name: 'AMD Radeon RX 6600 8GB', priceMad: 2550),
    Part(name: '16GB RAM (2x8) 3200 CL16', priceMad: 550),
    Part(name: 'MSI B550M PRO-VDH', priceMad: 1300),
    Part(name: '512GB NVMe SSD', priceMad: 450),
    Part(name: '550W 80+ Bronze PSU', priceMad: 500),
    Part(name: 'Micro-ATX Case', priceMad: 500),
  ];

  double _currentMoney = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentMoney = prefs.getDouble(_moneyKey) ?? 0;
    });
  }

  Future<void> _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_moneyKey, _currentMoney);
  }

  void _applyDelta() {
    final String input = _controller.text.trim();
    if (input.isEmpty) {
      return;
    }

    final double? delta = double.tryParse(input);
    if (delta == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Use a number like 90 or -90.')),
      );
      return;
    }

    setState(() {
      _currentMoney += delta;
      if (_currentMoney < 0) {
        _currentMoney = 0;
      }
    });

    _controller.clear();
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (_currentMoney / _goalMad).clamp(0, 1);

    return Scaffold(
      appBar: AppBar(title: const Text('HardBuy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text('PC Grind Tracker', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  LinearProgressIndicator(value: progress, minHeight: 12),
                  const SizedBox(height: 12),
                  Text('${(progress * 100).toStringAsFixed(1)}%'),
                  const SizedBox(height: 8),
                  Text('${_currentMoney.toStringAsFixed(0)} MAD / ${_goalMad.toStringAsFixed(0)} MAD'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: const InputDecoration(
                      labelText: 'how much money you got?',
                      hintText: '90 or -90',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _applyDelta(),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: _applyDelta,
                    icon: const Icon(Icons.savings),
                    label: const Text('Update total'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Parts (MAD)', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          ..._parts.map((Part part) {
            final bool affordable = _currentMoney >= part.priceMad;
            return Card(
              child: ListTile(
                title: Text(part.name),
                subtitle: Text('${part.priceMad.toStringAsFixed(0)} MAD'),
                trailing: Icon(
                  affordable ? Icons.check_circle : Icons.lock,
                  color: affordable ? Colors.greenAccent : Colors.orangeAccent,
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          Text(
            'Android-only build pipeline enabled in GitHub Actions.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
