import 'package:flutter/material.dart';

class FiltersPage extends StatefulWidget {
  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  double _priceValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Filtros',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/user_profile.png'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ubicación
            Text('Ubicación', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                _buildFilterButton('Actual', Icons.location_on, Colors.blue),
                SizedBox(width: 10),
                _buildFilterButton('Buscar ubicación', Icons.search, Colors.orange),
              ],
            ),
            SizedBox(height: 20),


            Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                _buildFilterButton('Hoy', null, Colors.blue),
                SizedBox(width: 10),
                _buildFilterButton('Mañana', null, Colors.orange),
                SizedBox(width: 10),
                _buildFilterButton('Esta semana', null, Colors.orange),
                SizedBox(width: 10),
                _buildFilterButton('Elegir fecha', Icons.calendar_today, Colors.orange),
              ],
            ),
            SizedBox(height: 20),


            Text('Tiempo del día', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                _buildFilterButton('Mañana', null, Colors.blue),
                SizedBox(width: 10),
                _buildFilterButton('Tarde', null, Colors.orange),
                SizedBox(width: 10),
                _buildFilterButton('Elegir hora', Icons.access_time, Colors.orange),
              ],
            ),
            SizedBox(height: 20),


            Text('Precio', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Free'),
                Expanded(
                  child: Slider(
                    value: _priceValue,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    onChanged: (value) {
                      setState(() {
                        _priceValue = value;
                      });
                    },
                  ),
                ),
                Text('${_priceValue.round()}'),
              ],
            ),
            SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _priceValue = 0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    minimumSize: Size(150, 50),
                  ),
                  child: Text('Borrar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: Size(150, 50),
                  ),
                  child: Text('Aplicar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildFilterButton(String text, IconData? icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: icon != null ? Icon(icon, size: 16) : SizedBox.shrink(),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(100, 40),
      ),
    );
  }
}
