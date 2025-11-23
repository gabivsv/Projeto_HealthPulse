import 'package:flutter/material.dart';
import 'package:trabalho01/core/theme/app_theme.dart'; 
import '../controller/activity_controller.dart'; 
import 'package:provider/provider.dart';

import '../widgets/activity_area_graph.dart';
import '../widgets/activity_stat_item.dart';
import '../widgets/activity_plan_card.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
 
String _formatDate(DateTime date) {
  const Map<int, String> months = {
    1: 'janeiro', 2: 'fevereiro', 3: 'março', 4: 'abril', 5: 'maio', 6: 'junho',
    7: 'julho', 8: 'agosto', 9: 'setembro', 10: 'outubro', 11: 'novembro', 12: 'dezembro',
  };
  return '${date.day} de ${months[date.month]} de ${date.year}';
}

// Classe principal de montagem da tela
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    // Observa o controlador para dados e estado
    final controller = context.watch<ActivityController>();
    final grayComponentColor = const Color(0xFF282A2C); 
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.black, 
      appBar: AppBar(
        backgroundColor: Colors.black, 
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Atividade'), 
        centerTitle: true, 
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector( 
              child: CircleAvatar(
                backgroundImage: const AssetImage('assets/images/profile.png'), 
                backgroundColor: baseGreen.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
      
      // Corpo principal com rolagem vertical
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              const Text(
                'Hoje', 
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(today), 
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              _buildDateNavigation(controller), // Abas de navegação de data
              
              const SizedBox(height: 30),

              ActivityAreaGraph(
                backgroundColor: Colors.black,
                stepsValue: controller.currentSteps, 
                graphPoints: controller.graphPoints, 
              ),
              
              const SizedBox(height: 15),
              
              _buildDetailStats(), 

              const SizedBox(height: 40),
              
              const Text(
                'Plano Diário', 
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              
              SizedBox(
                height: 120, 
                child: _buildDayPlanCards(grayComponentColor), 
              ),
              const SizedBox(height: 30), 
            ],
          ),
        ),
      ),
      // Barra de navegação inferior
      bottomNavigationBar: CustomBottomNav(
      componentColor: widgetsColor,
      activeKey: 'atividades',
      onHomeTap: () => Navigator.pushNamed(context, '/home'),
      onTreinoTap: () => Navigator.pushNamed(context, '/atividades'),
      onAtividadesTap: () => Navigator.pushNamed(context, '/activity'),
      onConfigTap: () => Navigator.pushNamed(context, '/settings'),

    ),
    );
  }

  // Constrói os botões de navegação de data
  Widget _buildDateNavigation(ActivityController controller) {
    final views = ['Dia', 'Semana', 'Mês', 'Ano']; 
    return SingleChildScrollView( 
      scrollDirection: Axis.horizontal, 
      child: Row(
        children: views.map((view) {
          final isSelected = controller.currentView == view;
          return GestureDetector(
            onTap: () => controller.setView(view), 
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(right: 20),
              decoration: isSelected
                  ? BoxDecoration(
                      color: baseGreen, 
                      borderRadius: BorderRadius.circular(15),
                    )
                  : null, 
              child: Text(
                view,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white54,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildDetailStats() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ActivityStatItem(value: '8.42', label: 'Distância'), 
        ActivityStatItem(value: '1.540', label: 'Calorias'), 
        ActivityStatItem(value: '3:24', label: 'Tempo'), 
      ],
    );
  }

  Widget _buildDayPlanCards(Color cardColor) {
    final List<Map<String, dynamic>> plans = [
      {'iconPath': 'assets/icons/icon5.png', 'title': 'Treino', 'duration': '2 horas', 'isColored': true},
      {'iconPath': 'assets/icons/icon6.png', 'title': 'Dormindo', 'duration': '9 horas', 'isColored': true},
      {'iconPath': 'assets/icons/icon7.png', 'title': 'Corrida', 'duration': '10 km', 'isColored': true},
      {'iconPath': 'assets/icons/icon8.png', 'title': 'Água', 'duration': '3 l', 'isColored': true},
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return ActivityPlanCard( 
          iconPath: plan['iconPath'], 
          title: plan['title'],
          duration: plan['duration'],
          isLast: index == plans.length - 1,
          cardColor: cardColor, 
          iconColor: plan['isColored'] ? baseGreen : Colors.white, 
        );
      },
    );
  }
}