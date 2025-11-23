import 'package:flutter/material.dart';
import 'package:trabalho01/features/pulse_measurement/presentation/pages/pulse_screen.dart';
import 'package:trabalho01/features/medicao/presentation/pages/medicao_form_screen.dart';


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Histórico',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.png'),
              radius: 18,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(context),
            const SizedBox(height: 16),
            Expanded(child: _buildHistoryList()),
            const SizedBox(height: 16),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
  return GestureDetector(
    onTap: () async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color.fromRGBO(41, 227, 60, 1),
                onPrimary: Colors.black,
                surface: Color(0xFF1A1A1A),
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.black,
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        print("Data selecionada: $picked");
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Selecionar Data",
            style: TextStyle(
              color: Color.fromRGBO(41, 227, 60, 1),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(
            Icons.calendar_today,
            color: Color.fromRGBO(41, 227, 60, 1),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildHistoryList() {
    final data = [
      {"date": "12/11/2025", "weight": "72,5 kg", "fat": "19%", "bpm": "78"},
      {"date": "05/11/2025", "weight": "73,2 kg", "fat": "20%", "bpm": "81"},
      {"date": "30/10/2025", "weight": "74,0 kg", "fat": "21%", "bpm": "85"},
      {"date": "17/10/2025", "weight": "76,8 kg", "fat": "24%", "bpm": "89"},
      {"date": "29/09/2025", "weight": "79,0 kg", "fat": "27%", "bpm": "93"},
    ];

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["date"]!,
                style: const TextStyle(
                  color: Color.fromRGBO(128, 249, 136, 10),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Peso: ${item['weight']} | Gordura: ${item['fat']} | BPM: ${item['bpm']}",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(41, 227, 60, 1),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MedicaoFormScreen(),
                ),
              );
            },
            child: const Text(
              '+ Adicionar Medição',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Limpar Histórico',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
