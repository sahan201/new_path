// lib/screens/utilities_screen.dart
import 'package:flutter/material.dart';

class UtilitiesScreen extends StatefulWidget {
  const UtilitiesScreen({super.key});

  @override
  State<UtilitiesScreen> createState() => _UtilitiesScreenState();
}

class _UtilitiesScreenState extends State<UtilitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Travel Utilities',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildUtilityCard(
            'Weather Forecast',
            'Check weather at your destination',
            Icons.wb_sunny,
            Colors.orange,
            () => _openWeatherScreen(),
          ),
          const SizedBox(height: 15),
          _buildUtilityCard(
            'Currency Converter',
            'Convert currencies in real-time',
            Icons.attach_money,
            Colors.green,
            () => _openCurrencyConverter(),
          ),
          const SizedBox(height: 15),
          _buildUtilityCard(
            'Language Translator',
            'Translate phrases and text',
            Icons.translate,
            Colors.blue,
            () => _openTranslator(),
          ),
          const SizedBox(height: 15),
          _buildUtilityCard(
            'Emergency Contacts',
            'Important numbers by country',
            Icons.emergency,
            Colors.red,
            () => _openEmergencyContacts(),
          ),
          const SizedBox(height: 15),
          _buildUtilityCard(
            'Common Phrases',
            'Learn basic travel phrases',
            Icons.chat_bubble,
            Colors.purple,
            () => _openCommonPhrases(),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _openWeatherScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WeatherScreen()),
    );
  }

  void _openCurrencyConverter() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CurrencyConverterScreen()),
    );
  }

  void _openTranslator() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TranslatorScreen()),
    );
  }

  void _openEmergencyContacts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmergencyContactsScreen()),
    );
  }

  void _openCommonPhrases() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CommonPhrasesScreen()),
    );
  }
}

// Weather Screen
class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wb_sunny, size: 100, color: Colors.orange[300]),
            const SizedBox(height: 20),
            const Text(
              '28°C',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const Text('Sunny', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            const Text('Semarang, Indonesia'),
            const SizedBox(height: 30),
            Text(
              'Note: Connect Weather API for real data',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// Currency Converter Screen
class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'IDR';
  double _result = 0;

  final Map<String, double> _rates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'JPY': 110.0,
    'IDR': 14500.0,
    'AUD': 1.35,
    'CAD': 1.25,
  };

  void _convert() {
    if (_amountController.text.isEmpty) return;
    
    final amount = double.tryParse(_amountController.text) ?? 0;
    final fromRate = _rates[_fromCurrency] ?? 1.0;
    final toRate = _rates[_toCurrency] ?? 1.0;
    
    setState(() {
      _result = (amount / fromRate) * toRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                prefixIcon: const Icon(Icons.money),
              ),
              onChanged: (_) => _convert(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fromCurrency,
                    decoration: InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    items: _rates.keys.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _fromCurrency = value!);
                      _convert();
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _toCurrency,
                    decoration: InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    items: _rates.keys.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _toCurrency = value!);
                      _convert();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF8CB369).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text(
                    'Result',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_result.toStringAsFixed(2)} $_toCurrency',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8CB369),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Translator Screen
class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _textController = TextEditingController();
  String _translatedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translator'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Enter text to translate',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _translatedText = 'Translation: ${_textController.text}\n\n(Connect Google Translate API for real translations)';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8CB369),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('Translate'),
            ),
            const SizedBox(height: 20),
            if (_translatedText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(_translatedText),
              ),
          ],
        ),
      ),
    );
  }
}

// Emergency Contacts Screen
class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = [
      {'name': 'Police', 'number': '110', 'icon': Icons.local_police, 'color': Colors.blue},
      {'name': 'Ambulance', 'number': '118', 'icon': Icons.local_hospital, 'color': Colors.red},
      {'name': 'Fire Department', 'number': '113', 'icon': Icons.fire_truck, 'color': Colors.orange},
      {'name': 'Tourist Police', 'number': '1500', 'icon': Icons.support_agent, 'color': Colors.green},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (contact['color'] as Color).withOpacity(0.2),
                child: Icon(contact['icon'] as IconData, color: contact['color'] as Color),
              ),
              title: Text(
                contact['name'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(contact['number'] as String),
              trailing: IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling ${contact['number']}...')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// Common Phrases Screen
class CommonPhrasesScreen extends StatelessWidget {
  const CommonPhrasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phrases = [
      {
        'category': 'Greetings',
        'phrases': ['Hello - Halo', 'Goodbye - Selamat tinggal', 'Thank you - Terima kasih', 'Please - Tolong']
      },
      {
        'category': 'Directions',
        'phrases': ['Where is...? - Di mana...?', 'How far? - Berapa jauh?', 'Left - Kiri', 'Right - Kanan']
      },
      {
        'category': 'Dining',
        'phrases': ['Menu please - Menu, tolong', 'Water - Air', 'Bill please - Bon, tolong', 'Delicious - Enak']
      },
      {
        'category': 'Emergency',
        'phrases': ['Help! - Tolong!', 'Emergency - Darurat', 'I need a doctor - Saya perlu dokter']
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Common Phrases'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: phrases.length,
        itemBuilder: (context, index) {
          final category = phrases[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ExpansionTile(
              title: Text(
                category['category'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: (category['phrases'] as List<String>).map((phrase) {
                return ListTile(
                  title: Text(phrase),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up, color: Color(0xFF8CB369)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Playing: $phrase')),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}