import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class GymScreen extends StatelessWidget {
  const GymScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Gerenciar Atividades",
          style: TextStyle(color: Colors.white),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/images/profile.png"),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // TÍTULO
            const Text(
              "Musculação",
              style: TextStyle(
                color: baseGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // ÍCONE GRANDE
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[900],
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 70,
                  color: baseGreen,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // LISTA DE EXERCÍCIOS
            _buildExerciseItem("Leg Press 45º", "4x12"),
            _buildExerciseItem("Cadeira Extensora", "4x12"),
            _buildExerciseItem("Agachamento Hack", "3x15"),
            _buildExerciseItem("Cadeira Abdutora", "4x12"),
            _buildExerciseItem("Remada Alta Cross", "4x12"),

            const SizedBox(height: 40),

            // BOTÃO SALVAR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: baseGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Salvar",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- CARD DO EXERCÍCIO ---
  Widget _buildExerciseItem(String name, String series) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        color: Color(0xff1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          // Nome do exercício
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),

          Row(
            children: [
              // Séries
              Text(
                series,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(width: 10),

              // Ícone de editar
              const Icon(
                Icons.edit,
                color: baseGreen,
                size: 20,
              ),
            ],
          )
        ],
      ),
    );
  }
}
