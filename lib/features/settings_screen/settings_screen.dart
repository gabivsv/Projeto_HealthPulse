import 'package:flutter/material.dart';
import 'package:trabalho01/core/theme/app_theme.dart'; 
import '../../../../core/widgets/custom_bottom_nav.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool receiveNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Configurações",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.all(2), // espessura da borda
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green, // cor da borda
                  width: 3, // largura da borda
                ),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage("assets/images/homem_icon.jpg"),
              ),
            ),
          ),
        ],
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildButtonCard(
              icon: Icons.person,
              text: "Alterar Foto de Perfil",
              onTap: () {},
            ),

            const SizedBox(height: 15),

            _buildAccountManagementCard(),

            const SizedBox(height: 15),

            _buildNotificationsCard(),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(41, 227, 60, 1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Salvar",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Barra de navegação inferior
      bottomNavigationBar: CustomBottomNav(
      componentColor: widgetsColor,
      activeKey: 'config',
     onHomeTap: () => Navigator.pushNamed(context, '/home'),
     onTreinoTap: () => Navigator.pushNamed(context, '/treino'),
     onAtividadesTap: () => Navigator.pushNamed(context, '/atividades'),
     onConfigTap: () => Navigator.pushNamed(context, '/settings'),
    ),
      
    );
  }



  Widget _buildButtonCard({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color.fromRGBO(41, 227, 60, 1)),
            const SizedBox(width: 15),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountManagementCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.settings, color: const Color.fromRGBO(41, 227, 60, 1)),
              SizedBox(width: 10),
              Text(
                "Gerenciamento da Conta",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),
          const Text(
            "Alterar Senha:",
            style: TextStyle(color: Color.fromRGBO(41, 227, 60, 1)),
          ),
          const SizedBox(height: 5),

          TextField(
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade800,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 15),
          const Text(
            "Alterar E-mail:",
            style: TextStyle(color: Color.fromRGBO(41, 227, 60, 1)),
          ),
          const SizedBox(height: 5),

          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade800,
              hintText: "usuario@gmail.com",
              hintStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.notifications_active,
                color: const Color.fromRGBO(41, 227, 60, 1),
              ),
              SizedBox(width: 10),
              Text(
                "Preferência de Notificações",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Receber notificações\nsobre treinos",
                style: TextStyle(color: Colors.white70),
              ),
              Switch(
                value: receiveNotifications,
                activeColor: Colors.greenAccent,
                onChanged: (v) {
                  setState(() {
                    receiveNotifications = v;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
