// lib/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _steelController = TextEditingController();
  final _boltController = TextEditingController();
  final _weldController = TextEditingController();
  final _brController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFactors();
  }

  Future<void> _loadFactors() async {
    final prefs = await SharedPreferences.getInstance();
    _steelController.text = (prefs.getDouble('phi_steel') ?? 0.90).toStringAsFixed(2);
    _boltController.text = (prefs.getDouble('phi_bolt') ?? 0.80).toStringAsFixed(2);
    _weldController.text = (prefs.getDouble('phi_weld') ?? 0.67).toStringAsFixed(2);
    _brController.text = (prefs.getDouble('phi_br') ?? 0.67).toStringAsFixed(2);
  }

  Future<void> _saveFactors() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('phi_steel', double.tryParse(_steelController.text) ?? 0.90);
    await prefs.setDouble('phi_bolt', double.tryParse(_boltController.text) ?? 0.80);
    await prefs.setDouble('phi_weld', double.tryParse(_weldController.text) ?? 0.67);
    await prefs.setDouble('phi_br', double.tryParse(_brController.text) ?? 0.67);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Factors saved')));
  }

  @override
  void dispose() {
    _steelController.dispose();
    _boltController.dispose();
    _weldController.dispose();
    _brController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildField('Steel φ', _steelController),
            _buildField('Bolt φ', _boltController),
            _buildField('Weld φ', _weldController),
            _buildField('BR φ', _brController),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveFactors,
              icon: const Icon(Icons.save),
              label: const Text('Save Factors'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
