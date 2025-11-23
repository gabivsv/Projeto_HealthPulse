import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/form_controller.dart'; // Reutiliza o FormController para a lógica
import 'package:trabalho01/core/theme/app_theme.dart'; // Para baseGreen

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    // Usamos read para acessar métodos de ação (handleLogin, setLoginEmail/Password)
    final controller = context.read<FormController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Entrar:",
            style: TextStyle(
              color: Color.fromARGB(255, 144, 146, 144),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(106, 0, 0, 0),
        centerTitle: true,
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Header: Ícone e Título ---
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icon_heartpulse.png',
                  color: baseGreen,
                  width: 90,
                  height: 90,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Acesse sua conta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            const SizedBox(height: 50),

            // --- Formulário de Login ---
            Form(
              key: formKey, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Insira suas credenciais:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo Email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Email:",
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? 'Por favor, insira seu email.' : null,
                    onSaved: (value) => controller.setLoginEmail(value), // Salva o email no controller
                  ),

                  const SizedBox(height: 20),

                  // Campo Senha
                  TextFormField(
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Senha:",
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? 'Por favor, insira sua senha.' : null,
                    onSaved: (value) => controller.setLoginPassword(value), // Salva a senha no controller
                  ),

                  const SizedBox(height: 40),

                  // Botão de Login
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: baseGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      onPressed: () => controller.handleLogin(context, formKey), // Chama a lógica de login
                      child: const Text(
                        "Entrar",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}