import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../controller/atividade_controller.dart';
import 'atividade_form_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trabalho01/core/theme/app_theme.dart'; 
import '../../../../core/widgets/custom_bottom_nav.dart';
import 'package:trabalho01/features/gym_screen/gym_screen.dart';

class AtividadeListScreen extends StatefulWidget {
  const AtividadeListScreen({super.key});

  @override
  State<AtividadeListScreen> createState() => _AtividadeListScreenState();
}

class _AtividadeListScreenState extends State<AtividadeListScreen> {
  final List<String> alunos = ['Selecionar Aluno', 'João', 'Maria', 'Carlos'];
  String selectedAluno = 'Selecionar Aluno';

  final List<_ActivityCardModel> atividades = [
    _ActivityCardModel('Musculação', '2 horas', Icons.fitness_center),
    _ActivityCardModel('Boxe', '1 hora', Icons.sports_mma),
    _ActivityCardModel('Corrida', '40 min', Icons.directions_run),
    _ActivityCardModel('Yoga', '30 min', Icons.self_improvement),
  ];

  final List<double> _steps = [3000, 4200, 5200, 6100, 7200, 7654];
  final DateTime today = DateTime.now();
  final TextEditingController _obsController = TextEditingController();

  int _currentActivityIndex = 0;

  @override
  void dispose() {
    _obsController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) => DateFormat('dd/MM/yy').format(d);

  @override
  Widget build(BuildContext context) {
    final cardRadius = 14.0;
    final neonGreen = const Color.fromRGBO(41, 227, 60, 1);
    final panel = const Color(0xFF121212);
    final widgetPanel = const Color(0xFF161616);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Gerenciar Atividades', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.all(2),
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ),
          )
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: widgetPanel,
                borderRadius: BorderRadius.circular(30),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedAluno,
                  dropdownColor: widgetPanel,
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: neonGreen,
                  items: alunos.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                  onChanged: (v) => setState(() => selectedAluno = v ?? alunos.first),
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text('Atividades', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),

            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: atividades.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final a = atividades[i];
                  final selected = i == _currentActivityIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _currentActivityIndex = i);

                      final activity = atividades[i].title;

                      if(activity == "Musculação"){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GymScreen(),
                          ),
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 120,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: panel,
                        borderRadius: BorderRadius.circular(cardRadius),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: neonGreen.withOpacity(0.12),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                )
                              ]
                            : null,
                        border: selected ? Border.all(color: neonGreen, width: 1.5) : null,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: selected ? neonGreen : Colors.white12,
                            child: Icon(a.icon,
                                color: selected ? Colors.black : neonGreen, size: 18),
                          ),
                          const Spacer(),
                          Text(a.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(a.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // Gráfico + passos
            Container(
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineTouchData: LineTouchData(enabled: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _steps.asMap().entries
                                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                                      .toList(),
                                  isCurved: true,
                                  color: neonGreen,
                                  barWidth: 3,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(show: true, color: neonGreen.withOpacity(0.12)),
                                )
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          left: 100 + (_steps.length - 1) * 16.0,
                          top: 18,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('14%',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 177, 44),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ),
                              const SizedBox(height: 1),
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 247, 51, 37),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white24,
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Positioned(
                          bottom: 4,
                          left: 180,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_steps.last.toInt()}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              const Text('Passos', style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _smallInfoItem('Data', _formatDate(today)),
                      const SizedBox(width:40),
                      _smallInfoItem('320', 'Calorias'),
                      const SizedBox(width:40),
                      _smallInfoItem('45:07', 'Tempo'),
                    ],
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: _obsController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: widgetPanel,
                      hintText: 'Observações:',
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNav(
      componentColor: widgetsColor,
      activeKey: 'treino',
      onHomeTap: () => Navigator.pushNamed(context, '/home'),
      onTreinoTap: () => Navigator.pushNamed(context, '/atividades'),
      onAtividadesTap: () => Navigator.pushNamed(context, '/activity'),
      onConfigTap: () => Navigator.pushNamed(context, '/settings'),

    ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: baseGreen,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AtividadeFormScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _smallInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _ActivityCardModel {
  final String title;
  final String subtitle;
  final IconData icon;
  _ActivityCardModel(this.title, this.subtitle, this.icon);
}



/*

class AtividadeListScreen extends StatefulWidget {
  const AtividadeListScreen({super.key});

  @override
  State<AtividadeListScreen> createState() => _AtividadeListScreenState();
}

class _AtividadeListScreenState extends State<AtividadeListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AtividadeController>().loadAtividades();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AtividadeController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Atividades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AtividadeFormScreen(),
                ),
              );
              if (result == true) {
                controller.loadAtividades();
              }
            },
          ),
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator(color: baseGreen))
          : controller.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => controller.loadAtividades(),
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                )
              : controller.atividades.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma atividade cadastrada',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.atividades.length,
                      itemBuilder: (context, index) {
                        final atividade = controller.atividades[index];
                        return Card(
                          color: widgetsColor,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(
                              atividade.tipo,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  atividade.descricao,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(atividade.dataInicio)}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                if (atividade.duracaoMinutos != null)
                                  Text(
                                    'Duração: ${atividade.duracaoMinutos!.toStringAsFixed(0)} min',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                if (atividade.calorias != null)
                                  Text(
                                    'Calorias: ${atividade.calorias}',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: baseGreen),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AtividadeFormScreen(atividade: atividade),
                                      ),
                                    );
                                    if (result == true) {
                                      controller.loadAtividades();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirmar exclusão'),
                                        content: Text('Deseja realmente excluir esta atividade?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true && context.mounted) {
                                      final success = await controller.deleteAtividade(atividade.id!);
                                      if (success && context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Atividade excluída com sucesso')),
                                        );
                                      } else if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(controller.error ?? 'Erro ao excluir atividade')),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

*/