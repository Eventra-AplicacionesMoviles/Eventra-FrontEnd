import 'package:flutter/material.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Filtros',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/user_profile.png'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Ubicación'),
            _buildLocationFilter(),

            _buildSectionTitle('Fecha'),
            _buildDateFilter(),

            _buildSectionTitle('Tiempo del día'),
            _buildTimeOfDayFilter(),

            _buildSectionTitle('Precio'),
            _buildPriceSlider(),

            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildLocationFilter() {
    return _buildCard(
      child: Row(
        children: [
          Expanded(
            child: _buildFilterButton(
              text: 'Actual',
              icon: Icons.location_on,
              color: Colors.blue.shade600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildFilterButton(
              text: 'Buscar ubicación',
              icon: Icons.search,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter() {
    return _buildCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildFilterButton(text: 'Hoy', icon: null, color: Colors.blue.shade600)),
              const SizedBox(width: 10),
              Expanded(child: _buildFilterButton(text: 'Mañana', icon: null, color: Colors.blue.shade400)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildFilterButton(text: 'Esta semana', icon: null, color: Colors.blue.shade400)),
              const SizedBox(width: 10),
              Expanded(child: _buildFilterButton(text: 'Elegir fecha', icon: Icons.calendar_today, color: Colors.blue.shade400)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOfDayFilter() {
    return _buildCard(
      child: Row(
        children: [
          Expanded(child: _buildFilterButton(text: 'Mañana', icon: null, color: Colors.blue.shade600)),
          const SizedBox(width: 10),
          Expanded(child: _buildFilterButton(text: 'Tarde', icon: null, color: Colors.blue.shade400)),
          const SizedBox(width: 10),
          Expanded(child: _buildFilterButton(text: 'Elegir hora', icon: Icons.access_time, color: Colors.blue.shade400)),
        ],
      ),
    );
  }

  Widget _buildPriceSlider() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Precio',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Free', style: TextStyle(color: Colors.black54)),
              Expanded(
                child: Slider(
                  value: _priceValue,
                  min: 0,
                  max: 400,
                  divisions: 10,
                  activeColor: Colors.blue.shade600,
                  inactiveColor: Colors.blue.shade100,
                  onChanged: (value) {
                    setState(() {
                      _priceValue = value;
                    });
                  },
                ),
              ),
              Text(
                '${_priceValue.round()}',
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _priceValue = 0;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade700,
              foregroundColor: Colors.white,
              minimumSize: const Size(150, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Borrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              foregroundColor: Colors.white,
              minimumSize: const Size(150, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({required String text, IconData? icon, required Color color}) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: icon != null ? Icon(icon, size: 18, color: Colors.white) : const SizedBox.shrink(),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(100, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}
