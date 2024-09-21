import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final double totalCost;
  final String ticketType;
  final int ticketQuantity;
  final String additionalService;

  const PaymentPage({
    super.key,
    required this.totalCost,
    required this.ticketType,
    required this.ticketQuantity,
    required this.additionalService,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _paymentFormKey = GlobalKey<FormState>();
  String? _selectedPaymentMethod;

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
                'Resumen de la inscripción',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildSummaryRow(
                'Entrada',
                '${widget.ticketQuantity}x ${widget.ticketType}',
                '20',
              ),
              const SizedBox(height: 10),
              _buildSummaryRow(
                'Servicios adicionales',
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
                  'Nombre del titular de la tarjeta',
                  Icons.person,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Número de tarjeta',
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
                  'Fecha de expiración (MM/AA)',
                  Icons.date_range,
                  isNumber: true,
                ),
              ] else if (_selectedPaymentMethod == 'PayPal') ...[
                _buildTextField(
                  'Correo electrónico de PayPal',
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
        labelText: 'Elige método de pago',
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
          onPressed: () {
            if (_paymentFormKey.currentState!.validate()) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Pago completado'),
                    content: const Text(
                        'Gracias por tu inscripción, el pago se ha completado con éxito.'),
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
