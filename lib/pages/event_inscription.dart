import 'package:eventra_app/pages/mp_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'payment_page.dart';

class EventRegistrationPage extends StatefulWidget {
  final String eventName;
  final bool isAdmin;
  final int userId;
  final int eventId;

  const EventRegistrationPage({
    super.key,
    required this.eventName,
    required this.userId,
    required this.eventId,
    required this.isAdmin,
  });

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

  Future<int?> _createTicket() async {
    final ticketUrl = 'http://10.0.2.2:8080/api/tickets';
    final ticketData = {
      'eventID': widget.eventId,
      'price': _ticketPrice,
      'totalAvailable': _selectedTicketQuantity,
      'category': _selectedTicketType,
      'description': 'Ticket for ${widget.eventName}',
    };

    final response = await http.post(
      Uri.parse(ticketUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ticketData),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['ticketID'];
    } else {
      print('Failed to create ticket: ${response.body}');
      return null;
    }
  }

  Future<int?> _createReservation(int ticketId) async {
    final reservationUrl = 'http://10.0.2.2:8080/api/reservations';
    final reservationData = {
      'userId': widget.userId,
      'ticketId': ticketId,
      'quantity': _selectedTicketQuantity,
      'reservationDate': DateTime.now().toIso8601String(),
    };

    final response = await http.post(
      Uri.parse(reservationUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reservationData),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['reservationId'];
    } else {
      print('Failed to create reservation: ${response.body}');
      return null;
    }
  }

  Future<String?> _getPaymentLink(int reservationId) async{
    final paymentUrl = 'http://10.0.2.2:8080/api/payments/process-payment';
    final paymentData = {
      'reservationId': reservationId,
      'amount': _selectedTicketQuantity,
      'paymentMethod': 'Visa', // Puedes cambiar esto según tu lógica
      'statusId': 1, // Puedes ajustar este valor según lo necesites
      'paymentDate': DateTime.now().toIso8601String(), // Fecha actual
    };

    final response = await http.post(
      Uri.parse(paymentUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(paymentData),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['sandboxInitPoint'];
    } else {
      print('Failed to get payment form: ${response.body}');
      return null;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Inscripción - ${widget.eventName}',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildDropdownField(
                label: 'Tipo de entrada',
                items: _ticketPrices.keys.map((type) => DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                )).toList(),
                value: _selectedTicketType,
                onChanged: (value) {
                  _selectedTicketType = value;
                  _updateTotalCost();
                },
              ),
              const SizedBox(height: 20),
              _buildDropdownField(
                label: 'Cantidad de entradas',
                items: [1, 2, 3, 4, 5].map((quantity) => DropdownMenuItem<int>(
                  value: quantity,
                  child: Text(quantity.toString()),
                )).toList(),
                value: _selectedTicketQuantity,
                onChanged: (value) {
                  _selectedTicketQuantity = value;
                  _updateTotalCost();
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Número de teléfono',
                onChanged: (value) {
                  _phoneNumber = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su número de teléfono';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'DNI',
                onChanged: (value) {
                  _dni = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su DNI';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              _buildDropdownField(
                label: 'Servicios adicionales',
                items: _additionalServicePrices.keys.map((service) => DropdownMenuItem<String>(
                  value: service,
                  child: Text(service),
                )).toList(),
                value: _selectedAdditionalService,
                onChanged: (value) {
                  _selectedAdditionalService = value;
                  _updateTotalCost();
                },
              ),
              const SizedBox(height: 30),
              Text(
                'Costo total: \$$_totalCost',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final ticketId = await _createTicket();
                      if (ticketId != null) {
                        final reservationId = await _createReservation(ticketId);
                        if (reservationId != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Inscripción completada'),
                                content: const Text('Te has inscrito en el evento. Para finalizar tu registro, realiza el pago.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Pagar'),
                                    onPressed: () async {
                                      var urlResponse = await _getPaymentLink(reservationId);
                                      print(urlResponse);
                                      if(context.mounted){
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>
                                            MpPage(url: urlResponse, isAdmin: widget.isAdmin, userId: widget.userId,)));

                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to create reservation')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to create ticket')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: const Color(0xFFFFA726),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Inscribirme',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required void Function(String) onChanged,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFA726), width: 2),
        ),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required List<DropdownMenuItem<T>> items,
    required T? value,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFA726), width: 2),
        ),
      ),
      items: items,
      value: value,
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor seleccione una opción';
        }
        return null;
      },
    );
  }
}