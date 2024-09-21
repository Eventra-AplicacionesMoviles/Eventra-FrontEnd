import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final double totalCost;
  final String ticketType;
  final int ticketQuantity;
  final String additionalService;

  PaymentPage({
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
        title: Text('Formulario de Pago'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _paymentFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Resumen de la inscripción',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: '${widget.ticketQuantity}x ${widget.ticketType}',
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Entrada',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      initialValue: '20',
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Precio',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: widget.additionalService,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Servicios adicionales',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      initialValue: '50',
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Precio',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: widget.totalCost.toString(),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Total',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Elige método de pago'),
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
              ),
              SizedBox(height: 20),
              if (_selectedPaymentMethod == 'Visa') ...[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nombre del titular de la tarjeta'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del titular de la tarjeta';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Número de tarjeta'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el número de tarjeta';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'CVV'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el CVV';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Fecha de expiración (MM/AA)'),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fecha de expiración';
                    }
                    return null;
                  },
                ),
              ] else if (_selectedPaymentMethod == 'PayPal') ...[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Correo electrónico de PayPal'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el correo electrónico de PayPal';
                    }
                    return null;
                  },
                ),
              ],
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_paymentFormKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Pago completado'),
                              content: Text(
                                  'Gracias por tu inscripción, el pago se ha completado con éxito.'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Aceptar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop(); // Cierra ambas vistas
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Pagar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
