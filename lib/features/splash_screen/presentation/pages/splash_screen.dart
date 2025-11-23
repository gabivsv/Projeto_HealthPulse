import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trabalho01/core/theme/app_theme.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    final controller = context.read<SplashController>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background_img.jpg', 
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.6), 
            colorBlendMode: BlendMode.darken,
          ),
          
          // Conteúdo centralizado
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Image.asset(
                'assets/images/icon_heartpulse.png', 
                color: baseGreen,
                width: 90,
                height: 90,
              ),
              const SizedBox(height: 20),
              const Text(
                'HealthPulse',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text( 
                  'Bem-vindo ao HealthPulse — um portal amigável para a sua jornada rumo a um estilo de vida mais saudável!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Botão Começar Agora
              ElevatedButton( 
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: baseGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Comece Agora',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Link para cadastro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Você não tem uma conta? ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  GestureDetector( 
                    onTap: () => controller.navigateToForm(context),
                    child: const Text(
                      'Cadastre-se',
                      style: TextStyle(
                        color: baseGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}