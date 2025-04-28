import 'package:flutter/material.dart';
import '../models/appliance.dart';

class SimulateScreen extends StatefulWidget {
  final List<Appliance> appliances;

  const SimulateScreen({super.key, required this.appliances});

  @override
  _SimulateScreenState createState() => _SimulateScreenState();
}

class _SimulateScreenState extends State<SimulateScreen> {
  Appliance? _selectedAppliance;
  final TextEditingController _hoursPerDayController = TextEditingController();
  final TextEditingController _daysPerMonthController = TextEditingController();
  final TextEditingController _tariffController = TextEditingController();

  double? _costResult;

  void _calculateCost() {
    if (_selectedAppliance == null) {
      _showError('Selecione um eletrodoméstico.');
      return;
    }

    final hoursPerDay = double.tryParse(_hoursPerDayController.text);
    final daysPerMonth = int.tryParse(_daysPerMonthController.text);
    final tariff = double.tryParse(_tariffController.text);

    if (hoursPerDay == null || daysPerMonth == null || tariff == null) {
      _showError('Preencha todos os campos corretamente.');
      return;
    }

    final energyConsumption = _selectedAppliance!.power / 1000 * hoursPerDay * daysPerMonth; // consumo kWh
    final cost = energyConsumption * tariff;

    setState(() {
      _costResult = cost;
    });
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simular Custo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<Appliance>(
                hint: const Text('Selecione o eletrodoméstico'),
                value: _selectedAppliance,
                isExpanded: true,
                onChanged: (Appliance? newValue) {
                  setState(() {
                    _selectedAppliance = newValue;
                  });
                },
                items: widget.appliances.map((appliance) {
                  return DropdownMenuItem(
                    value: appliance,
                    child: Text('${appliance.name} (${appliance.power} W)'),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _hoursPerDayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Horas por dia',
                ),
              ),
              TextField(
                controller: _daysPerMonthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Dias por mês',
                ),
              ),
              TextField(
                controller: _tariffController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tarifa (R\$ por kWh)',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateCost,
                child: const Text('Calcular Custo'),
              ),
              const SizedBox(height: 20),
              if (_costResult != null)
                Text(
                  'Custo estimado: R\$ ${_costResult!.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
