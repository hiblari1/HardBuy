import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF9D7BFF),
        textTheme: GoogleFonts.googleSansTextTheme().copyWith(
          displayLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
          displayMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
          displaySmall: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
          headlineLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
          headlineMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
          headlineSmall: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
          titleLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
        ),
      ),
      home: const HardBuyHomePage(),
    );
  }
}

class ShopLink {
  const ShopLink({required this.name, required this.url});

  final String name;
  final String url;
}

class Part {
  const Part({
    required this.name,
    required this.compatible,
    required this.shops,
  });

  final String name;
  final bool compatible;
  final List<ShopLink> shops;
}

class Peripheral {
  const Peripheral({
    required this.type,
    required this.model,
    required this.reason,
  });

  final String type;
  final String model;
  final String reason;
}

class HardBuyHomePage extends StatefulWidget {
  const HardBuyHomePage({super.key});

  @override
  State<HardBuyHomePage> createState() => _HardBuyHomePageState();
}

class _HardBuyHomePageState extends State<HardBuyHomePage> {
  static const String _lockedEmail = 'kinanbourguiba7@gmail.com';
  static const String _prefsCurrentMoney = 'current_money_mad';
  static const double _goal = 18500;

  final TextEditingController _moneyInputController = TextEditingController();

  double _currentMoney = 0;

  final List<Part> _parts = const <Part>[
    Part(
      name: 'CPU: AMD Ryzen 5 5600',
      compatible: true,
      shops: <ShopLink>[
        ShopLink(name: 'SetupGame.ma', url: 'https://www.google.com/search?q=site:setupgame.ma+AMD+Ryzen+5+5600'),
        ShopLink(name: 'UltraPC.ma', url: 'https://www.google.com/search?q=site:ultrapc.ma+AMD+Ryzen+5+5600'),
      ],
    ),
    Part(
      name: 'GPU: AMD Radeon RX 6600 8GB',
      compatible: true,
      shops: <ShopLink>[
        ShopLink(name: 'CasaConfig.ma', url: 'https://www.google.com/search?q=site:casaconfig.ma+RX+6600+8GB'),
        ShopLink(name: 'Crenova.ma', url: 'https://www.google.com/search?q=site:crenova.ma+RX+6600+8GB'),
      ],
    ),
    Part(
      name: 'RAM: 16GB (2x8GB) DDR4 3200MHz CL16',
      compatible: true,
      shops: <ShopLink>[
        ShopLink(name: 'UltraPC.ma', url: 'https://www.google.com/search?q=site:ultrapc.ma+16GB+2x8+3200+CL16'),
        ShopLink(name: 'SetupGame.ma', url: 'https://www.google.com/search?q=site:setupgame.ma+16GB+2x8+3200+CL16'),
      ],
    ),
    Part(
      name: 'Motherboard: MSI B550M PRO-VDH',
      compatible: true,
      shops: <ShopLink>[
        ShopLink(name: 'SetupGame.ma', url: 'https://www.google.com/search?q=site:setupgame.ma+MSI+B550M+PRO-VDH'),
        ShopLink(name: 'UltraPC.ma', url: 'https://www.google.com/search?q=site:ultrapc.ma+MSI+B550M+PRO-VDH'),
      ],
    ),
    Part(
      name: 'Storage: 512GB NVMe SSD',
      compatible: true,
      shops: <ShopLink>[
        ShopLink(name: 'UltraPC.ma', url: 'https://www.google.com/search?q=site:ultrapc.ma+512GB+NVMe+SSD'),
        ShopLink(name: 'SetupGame.ma', url: 'https://www.google.com/search?q=site:setupgame.ma+512GB+NVMe+SSD'),
      ],
    ),
    Part(
      name: 'PSU: 550W 80+ Bronze',
      compatible: true,
      shops: <ShopLink>[
        ShopLink(name: 'UltraPC.ma', url: 'https://www.google.com/search?q=site:ultrapc.ma+550W+80+Bronze+PSU'),
        ShopLink(name: 'SetupGame.ma', url: 'https://www.google.com/search?q=site:setupgame.ma+550W+80+Bronze+PSU'),
      ],
    ),
    Part(
      name: 'Case: Micro-ATX Case',
      compatible: true,
      shops: <ShopLink>[
        ShopLink(name: 'UltraPC.ma', url: 'https://www.google.com/search?q=site:ultrapc.ma+Micro-ATX+Case'),
        ShopLink(name: 'SetupGame.ma', url: 'https://www.google.com/search?q=site:setupgame.ma+Micro-ATX+Case'),
      ],
    ),
  ];

  final List<Peripheral> _peripherals = const <Peripheral>[
    Peripheral(
      type: 'Keyboard',
      model: 'Wooting 80HE',
      reason: 'Rapid Trigger + Hall Effect keys are excellent for competitive FPS.',
    ),
    Peripheral(
      type: 'Mouse',
      model: 'Logitech G Pro X Superlight 2',
      reason: 'Top-tier lightweight wireless mouse with very reliable esports performance.',
    ),
    Peripheral(
      type: 'Monitor',
      model: 'BenQ ZOWIE XL2566X+ (1080p, high refresh)',
      reason: '1080p keeps FPS high on RX 6600 and delivers smoother competitive gameplay.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadMoney();
  }

  @override
  void dispose() {
    _moneyInputController.dispose();
    super.dispose();
  }

  Future<void> _loadMoney() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentMoney = prefs.getDouble(_prefsCurrentMoney) ?? 0;
    });
  }

  Future<void> _saveMoney() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefsCurrentMoney, _currentMoney);
  }

  void _applyMoneyDelta() {
    final String raw = _moneyInputController.text.trim();
    if (raw.isEmpty) {
      return;
    }

    final double? delta = double.tryParse(raw);
    if (delta == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid number, e.g. 90 or -90.')),
      );
      return;
    }

    setState(() {
      _currentMoney += delta;
      if (_currentMoney < 0) {
        _currentMoney = 0;
      }
    });
    _saveMoney();
    _moneyInputController.clear();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open: $url')),
      );
    }
  }

  void _showBuyNowNotice() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buy now (Safety limitation)'),
          content: const Text(
            'Fully automatic checkout is not enabled for security reasons. '
            'Use the shop links and complete payment manually.',
          ),
          actions: <Widget>[
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (_currentMoney / _goal).clamp(0, 1);
    final int percentage = (progress * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('HardBuy'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            'PC Grind Tracker',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Connected account: $_lockedEmail',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 13,
                        ),
                        Center(
                          child: Text(
                            '$percentage%',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$_currentMoney MAD / $_goal MAD',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _moneyInputController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: InputDecoration(
                      labelText: 'how much money you got?',
                      hintText: 'e.g. 90 or -90',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onSubmitted: (_) => _applyMoneyDelta(),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _applyMoneyDelta,
                    icon: const Icon(Icons.savings),
                    label: const Text('Update total'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _launchUrl('https://www.paypal.com/signin'),
                    icon: const Icon(Icons.account_balance_wallet),
                    label: const Text('Connect your PayPal'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('PC Parts', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          ..._parts.map((Part part) {
            return Card(
              child: ExpansionTile(
                title: Text(part.name),
                subtitle: Text(part.compatible ? 'Compatibility: Works together' : 'Compatibility: Mismatch'),
                trailing: Icon(
                  part.compatible ? Icons.check_circle : Icons.cancel,
                  color: part.compatible ? Colors.greenAccent : Colors.redAccent,
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: part.shops.map((ShopLink shop) {
                        return OutlinedButton.icon(
                          onPressed: () => _launchUrl(shop.url),
                          icon: const Icon(Icons.storefront),
                          label: Text(shop.name),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => _launchUrl('https://www.pcpartpicker.com/list/'),
            icon: const Icon(Icons.view_in_ar),
            label: const Text('Preview full build in 3D'),
          ),
          const SizedBox(height: 20),
          Text('Peripherals', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          ..._peripherals.map((Peripheral peripheral) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.devices),
                title: Text('${peripheral.type}: ${peripheral.model}'),
                subtitle: Text(peripheral.reason),
              ),
            );
          }),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: _showBuyNowNotice,
            icon: const Icon(Icons.shopping_cart_checkout),
            label: const Text('Buy now'),
          ),
          const SizedBox(height: 20),
          Text(
            'Cross-platform target: Android, Linux (AppImage), macOS, Windows.\n'
            'This build includes local persistence; cloud sync can be wired to a backend.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
