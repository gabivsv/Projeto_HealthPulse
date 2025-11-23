import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trabalho01/features/form_screen/data/repositories/auth_repository_impl.dart'; 

class FormController extends ChangeNotifier {
  // Variáveis do formulário
  String? email;
  String? nome;
  String? genero;
  String? senha;
  bool lembrarSenha = false;
  bool notificacoes = false;
  
  // Variáveis de Login
  String? loginEmail;
  String? loginPassword; 

  final AuthRepositoryImpl authRepository; 
  
  FormController({required this.authRepository}); 

  // Setters
  void setNome(String? value) { nome = value; }
  void setEmail(String? value) { email = value; }
  void setSenha(String? value) { senha = value; }
  void setLoginEmail(String? value) { loginEmail = value; }
  void setLoginPassword(String? value) { loginPassword = value; }
  void setLembrarSenha(bool? value) { lembrarSenha = value ?? false; notifyListeners(); }
  void setNotificacoes(bool value) { notificacoes = value; notifyListeners(); }
  void setGenero(String? value) { genero = value; notifyListeners(); }


  // Lógica de submissão e cadastro no Firebase
  void handleSubmit(BuildContext context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save(); 
      
      try {
        // 1. Chamada de Autenticação para Cadastro (cria o Auth User)
        await authRepository.registerNewUser(
          email: email!, 
          nome: nome!,
          senha: senha!,
          genero: genero,
          lembrarSenha: lembrarSenha,
          notificacoes: notificacoes,
        );

        // 2. Sucesso: Exibe o diálogo de sucesso
        if (!context.mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Cadastrado com sucesso!"),
            content: Text(
              "Nome: $nome\nEmail: $email\nGênero: $genero\nLembrar senha: ${lembrarSenha ? "Sim" : "Não"}\nNotificações: ${notificacoes ? "Sim" : "Não"}",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); 
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(
                      context, 
                      '/home',
                      arguments: nome,
                  ); 
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } on FirebaseAuthException catch (e) {
        // Tratamento de Erros de AUTENTICAÇÃO (Auth)
        if (!context.mounted) return;
        String message;
        if (e.code == 'email-already-in-use') {
          message = 'Erro: Este e-mail já está sendo usado.';
        } else if (e.code == 'invalid-email') {
          message = 'Erro: O formato do e-mail é inválido.';
        } else if (e.code == 'weak-password') {
          message = 'Erro: A senha é muito fraca (mínimo 6 caracteres).';
        } else {
          message = 'Erro de autenticação: ${e.message ?? e.code}.';
        }
        showDialog(
          context: context,
          builder: (_) => AlertDialog(title: const Text("Falha na Autenticação"), content: Text(message)),
        );
      } on FirebaseException catch (e) {
        // Tratamento de Erros de FIRESTORE (DB) - Permissão Negada
        if (!context.mounted) return;
        String message = 'Erro de Banco de Dados: ${e.code}. Verifique as Regras de Segurança.';
        showDialog(
          context: context,
          builder: (_) => AlertDialog(title: const Text("Falha no Banco de Dados"), content: Text(message)),
        );
      } catch (e) {
        // Erro Geral - Mostra a mensagem real do erro para debug
        if (!context.mounted) return;
        String errorMessage = 'Não foi possível concluir o cadastro.';
        if (e is Exception) {
          errorMessage = 'Erro: ${e.toString()}';
        } else if (e is Error) {
          errorMessage = 'Erro: ${e.toString()}';
        }
        // Log do erro para debug (pode ser visto no console)
        debugPrint('Erro no cadastro: $e');
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Erro Inesperado"), 
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  // Lógica de Login (SignIn)
  Future<void> handleLogin(BuildContext context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      
      try {
        // Chamada de Autenticação para Login
        // Assumimos que o signIn retorna UserEntity
        final userEntity = await authRepository.signIn(
            loginEmail!,
            loginPassword!,
        );

        // Sucesso: Redireciona para a Home com o nome do usuário
        if (!context.mounted) return;
        Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: userEntity.nome, // Passa o nome do usuário logado
        );

      } on FirebaseAuthException catch (e) {
         if (!context.mounted) return;
         String message = 'Falha no login. Verifique suas credenciais.';
         if (e.code == 'user-not-found' || e.code == 'wrong-password') {
             message = 'Usuário ou senha inválidos.';
         } else if (e.code == 'invalid-email') {
             message = 'O formato do e-mail é inválido.';
         }
         showDialog(context: context, builder: (_) => AlertDialog(title: const Text("Erro de Login"), content: Text(message)),);
      } catch (e) {
          if (!context.mounted) return;
          showDialog(context: context, builder: (_) => const AlertDialog(title: Text("Erro Inesperado"), content: Text("Não foi possível realizar o login.")),);
      }
    }
  }
}