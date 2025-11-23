import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trabalho01/features/form_screen/presentation/controller/form_controller.dart'; 

class FormScreen extends StatelessWidget { 
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos read para ações e watch para obter o estado
    final controller = context.read<FormController>();
    final state = context.watch<FormController>();
    final formKey = GlobalKey<FormState>();
    const Color neonGreen = Color(0xFF29E33C);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text("Cadastre-se:", style: TextStyle(color: Color.fromARGB(255, 144, 146, 144), fontSize: 20, fontWeight: FontWeight.bold)),
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
                Image.asset('assets/images/icon_heartpulse.png', color: neonGreen, width: 90, height: 90),
                const SizedBox(height: 16),
                RichText(textAlign: TextAlign.center, text: const TextSpan(children: [TextSpan(text: "Bem-Vindo ao ", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),), TextSpan(text: "HealthPulse!", style: TextStyle(color: neonGreen, fontSize: 30, fontWeight: FontWeight.bold),),],),),
                const SizedBox(height: 8),
                const Text("Vamos começar:", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.normal), textAlign: TextAlign.center,),
              ],
            ),

            const SizedBox(height: 30),

            // --- Formulário de Cadastro ---
            Form(
              key: formKey, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Preencha seus dados:", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 20),

                  // Campo Nome
                  TextFormField(
                    initialValue: state.nome, 
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: "Nome:", labelStyle: TextStyle(color: Colors.white70), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),),
                    validator: (value) => (value == null || value.isEmpty) ? 'Por favor, insira seu nome:' : null,
                    // CORREÇÃO: Passando o valor para o setter do controller
                    onSaved: (value) => controller.nome = value, 
                    onChanged: controller.setNome, 
                  ),

                  const SizedBox(height: 20),
                  
                  // Campo Email
                  TextFormField(
                    initialValue: state.email, 
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: "Email:", labelStyle: TextStyle(color: Colors.white70), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Por favor, insira seu email:';
                      if (!value.contains('@') || !value.contains('.')) return 'Insira um email válido.';
                      return null;
                    },
                    onSaved: (value) => controller.email = value, // Salva o valor final
                    onChanged: controller.setEmail, // Salva o valor durante a digitação
                  ),

                  const SizedBox(height: 20),

                  // Campo Senha
                  TextFormField(
                    initialValue: state.senha, 
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: "Senha:", labelStyle: TextStyle(color: Colors.white70), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Por favor, insira sua senha:';
                      if (value.length < 6) return 'A senha deve ter no mínimo 6 caracteres.';
                      return null;
                    },
                    // CORREÇÃO: Passando o valor para o setter do controller (resolve o erro de getter)
                    onSaved: (value) => controller.senha = value, // Salva o valor final
                    onChanged: controller.setSenha, // Salva o valor durante a digitação
                  ),

                  const SizedBox(height: 20),

                  // Seleção de Gênero (Mantida, pois onChanged já chama o setter corretamente)
                  DropdownButtonFormField<String>(
                    initialValue: state.genero, 
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: Colors.grey[900],
                    decoration: const InputDecoration(labelText: "Gênero", labelStyle: TextStyle(color: Colors.white70), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),),
                    items: const [ DropdownMenuItem(value: "Masculino", child: Text("Masculino")), DropdownMenuItem(value: "Feminino", child: Text("Feminino")), DropdownMenuItem(value: "Prefiro não informar", child: Text("Prefiro não informar")),],
                    onChanged: controller.setGenero,
                    validator: (value) => (value == null) ? 'Selecione um gênero' : null,
                  ),

                  const SizedBox(height: 20),

                  // Checkbox para lembrar senha
                  Consumer<FormController>(builder: (context, c, child) => Row(children: [
                        Checkbox(value: c.lembrarSenha, activeColor: neonGreen, onChanged: controller.setLembrarSenha),
                        const Text("Lembrar senha", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),

                  // Switch para notificações
                  Consumer<FormController>(builder: (context, c, child) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text("Receber notificações?", style: TextStyle(color: Colors.white)),
                        Switch(value: c.notificacoes, activeThumbColor: Colors.greenAccent, onChanged: (value) => controller.setNotificacoes(value)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botão concluir
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: neonGreen),
                      onPressed: () => controller.handleSubmit(context, formKey),
                      child: const Text(
                        "Concluir",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
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