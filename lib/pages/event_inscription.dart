import 'package:flutter/material.dart';
import 'payment_page.dart';

class EventRegistrationPage extends StatefulWidget {
  final String eventName;

  EventRegistrationPage({required this.eventName});

  @override
  _EventRegistrationPageState createState() => _EventRegistrationPageState();
}

class _EventRegistrationPageState extends State<EventRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedTicketType;
  int? _selectedTicketQuantity = 1;
  String? _phoneNumber;
  String? _dni;
  String? _selectedAdditionalService;
  double _ticketPrice = 0.0;
  double _totalCost = 0.0;
  double _additionalServiceCost = 0.0;

  final Map<String, double> _ticketPrices = {
    'General': 50.0,
    'VIP': 100.0,
    'Premium': 150.0,
  };

  final Map<String, double> _additionalServicePrices = {
    'Ninguno': 0.0,
    'Comida y bebida': 20.0,
    'Estacionamiento': 10.0,
    'Transporte': 15.0,
  };

  void _updateTotalCost() {
    setState(() {
      _ticketPrice = _ticketPrices[_selectedTicketType] ?? 0.0;
      _additionalServiceCost = _additionalServicePrices[_selectedAdditionalService] ?? 0.0;
      _totalCost = (_ticketPrice * (_selectedTicketQuantity ?? 1)) + _additionalServiceCost;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscripción - ${widget.eventName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Tipo de entrada'),
                items: _ticketPrices.keys
                    .map((type) => DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) {
                  _selectedTicketType = value;
                  _updateTotalCost();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione el tipo de entrada';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Cantidad de entradas'),
                value: _selectedTicketQuantity,
                items: [1, 2, 3, 4, 5]
                    .map((quantity) => DropdownMenuItem<int>(
                  value: quantity,
                  child: Text(quantity.toString()),
                ))
                    .toList(),
                onChanged: (value) {
                  _selectedTicketQuantity = value;
                  _updateTotalCost();
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione la cantidad de entradas';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Número de teléfono'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  _phoneNumber = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su número de teléfono';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'DNI'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _dni = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su DNI';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Servicios adicionales'),
                items: _additionalServicePrices.keys
                    .map((service) => DropdownMenuItem<String>(
                  value: service,
                  child: Text(service),
                ))
                    .toList(),
                onChanged: (value) {
                  _selectedAdditionalService = value;
                  _updateTotalCost();
                },
              ),
              SizedBox(height: 20),
              Text(
                'Costo total: \$$_totalCost',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Inscripción completada'),
                          content: Text(
                              'Te has inscrito en el evento. Para finalizar tu registro, realiza el pago.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Pagar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentPage(
                                      totalCost: _totalCost,
                                      ticketType: _selectedTicketType!,
                                      ticketQuantity: _selectedTicketQuantity!,
                                      additionalService: _selectedAdditionalService ?? 'Ninguno',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Inscribirme'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}