import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentPage extends StatefulWidget {
  final double totalCost;
  final String ticketType;
  final int ticketQuantity;
  final String additionalService;
  final int userId;
  final int reservationId;

  const PaymentPage({
    super.key,
    required this.totalCost,
    required this.ticketType,
    required this.ticketQuantity,
    required this.additionalService,
    required this.userId,
    required this.reservationId,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _paymentFormKey = GlobalKey<FormState>();
  String? _selectedPaymentMethod;

  Future<int?> _getEventId() async {
    final eventUrl = Uri.parse('http://10.0.2.2:8080/api/events/{id}'); // Ajusta la URL según tu API
    final response = await http.get(eventUrl);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['id']; // Ajusta según la estructura de tu respuesta
    } else {
      throw Exception('Error obteniendo el eventID: ${response.statusCode} - ${response.body}');
    }
  }

  Future<int?> _createTicket(int eventId) async {
    final ticketUrl = Uri.parse('http://10.0.2.2:8080/api/tickets');
    final ticketData = {
      'eventID': eventId,
      'price': widget.totalCost,
      'totalAvailable': widget.ticketQuantity,
      'category': widget.ticketType,
      'description': 'Ticket for event',
    };

    final response = await http.post(
      ticketUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ticketData),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['ticketID'];
    } else {
      throw Exception('Error creando el ticket: ${response.statusCode} - ${response.body}');
    }
  }

  Future<int?> _createReservation(int ticketId) async {
    final reservationUrl = 'http://10.0.2.2:8080/api/reservations';
    final reservationData = {
      'userId': widget.userId,
      'ticketId': ticketId,
      'quantity': widget.ticketQuantity,
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
      print('Failed to create reservation');
      return null;
    }
  }

  Future<void> _processPayment() async {
    final eventId = await _getEventId();
    if (eventId == null) {
      throw Exception('Error obteniendo el eventID');
    }

    final ticketId = await _createTicket(eventId);
    if (ticketId == null) {
      throw Exception('Error creando el ticket');
    }

    final reservationId = await _createReservation(ticketId);
    if (reservationId == null) {
      throw Exception('Error creando la reserva');
    }

    final url = Uri.parse('http://10.0.2.2:8080/api/payments');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'reservationId': reservationId,
      'amount': widget.totalCost,
      'paymentMethod': _selectedPaymentMethod,
      'statusId': 1, // Reemplazar con el ID de estado real
      'paymentDate': DateTime.now().toIso8601String(),
      'userId': widget.userId,
      'ticketId': ticketId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        // Pago exitoso
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Pago Completado'),
              content: const Text('Gracias por su registro, el pago se ha completado con éxito.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Error en el pago
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Error procesando el pago: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Manejo de errores
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error procesando el pago: $e'),
            actions: <Widget>[
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFA726)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Formulario de Pago',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _paymentFormKey,
          child: ListView(
            children: <Widget>[
              const Text(
                'Resumen de Registro',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildSummaryRow(
                'Ticket',
                '${widget.ticketQuantity}x ${widget.ticketType}',
                '20',
              ),
              const SizedBox(height: 10),
              _buildSummaryRow(
                'Servicios Adicionales',
                widget.additionalService,
                '50',
              ),
              const SizedBox(height: 10),
              _buildTotalRow(widget.totalCost.toString()),
              const SizedBox(height: 30),
              _buildPaymentMethodDropdown(),
              const SizedBox(height: 20),
              if (_selectedPaymentMethod == 'Visa') ...[
                _buildTextField(
                  'Nombre del Titular',
                  Icons.person,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Número de Tarjeta',
                  Icons.credit_card,
                  isNumber: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'CVV',
                  Icons.security,
                  isNumber: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Fecha de Expiración (MM/YY)',
                  Icons.date_range,
                  isNumber: true,
                ),
              ] else if (_selectedPaymentMethod == 'PayPal') ...[
                _buildTextField(
                  'Correo de PayPal',
                  Icons.email,
                  isEmail: true,
                ),
              ],
              const SizedBox(height: 30),
              _buildButtonRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, String price) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            initialValue: value,
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.black87),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: TextFormField(
            initialValue: price,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Precio',
              labelStyle: const TextStyle(color: Colors.black87),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String total) {
    return TextFormField(
      initialValue: total,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Total',
        labelStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildPaymentMethodDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Elija el Método de Pago',
        labelStyle: const TextStyle(color: Colors.black87),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: ['Visa', 'PayPal', 'Yape', 'Plin']
          .map((method) => DropdownMenuItem<String>(
        value: method,
        child: Text(method),
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor seleccione un método de pago';
        }
        return null;
      },
    );
  }

  Widget _buildTextField(
      String label,
      IconData icon, {
        bool isNumber = false,
        bool isEmail = false,
      }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        prefixIcon: Icon(icon, color: const Color(0xFFFFA726)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      keyboardType: isNumber
          ? TextInputType.number
          : isEmail
          ? TextInputType.emailAddress
          : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            minimumSize: const Size(120, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_paymentFormKey.currentState!.validate()) {
              try {
                await _processPayment();
              } catch (e) {
                // Manejo de errores
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: Text('Error procesando la reserva: $e'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Aceptar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFA726),
            minimumSize: const Size(120, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('Pagar'),
        ),
      ],
    );
  }
}