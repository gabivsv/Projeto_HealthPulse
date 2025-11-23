import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:trabalho01/core/theme/app_theme.dart';
import 'package:trabalho01/core/services/notification_service.dart' show NotificationService, firebaseMessagingBackgroundHandler;
import 'package:trabalho01/features/settings_screen/settings_screen.dart';
import 'package:trabalho01/features/splash_screen/presentation/controller/splash_controller.dart';
import 'package:trabalho01/features/splash_screen/presentation/pages/splash_screen.dart'; 

import 'features/form_screen/presentation/controller/form_controller.dart';
import 'features/form_screen/presentation/pages/form_screen.dart';
import 'features/form_screen/presentation/pages/login_screen.dart';

import 'features/home/presentation/controller/home_controller.dart';
import 'features/home/presentation/pages/home_screen.dart';

import 'features/activity/presentation/controller/activity_controller.dart';
import 'features/activity/presentation/pages/activity_screen.dart';

import 'features/pulse_measurement/presentation/controller/pulse_controller.dart';
import 'features/pulse_measurement/presentation/pages/pulse_screen.dart';

import 'features/aluno/data/datasources/aluno_firebase_datasource.dart';
import 'features/aluno/data/repositories/aluno_repository_impl.dart';
import 'features/aluno/presentation/controller/aluno_controller.dart';
import 'features/aluno/presentation/pages/aluno_list_screen.dart';

import 'features/atividade/data/datasources/atividade_firebase_datasource.dart';
import 'features/atividade/data/repositories/atividade_repository_impl.dart';
import 'features/atividade/presentation/controller/atividade_controller.dart';
import 'features/atividade/presentation/pages/atividade_list_screen.dart';

import 'features/medicao/data/datasources/medicao_firebase_datasource.dart';
import 'features/medicao/data/repositories/medicao_repository_impl.dart';
import 'features/medicao/presentation/controller/medicao_controller.dart';
import 'features/medicao/presentation/pages/medicao_list_screen.dart';

import 'features/relatorios/presentation/pages/relatorios_screen.dart';

import 'firebase_options.dart' show DefaultFirebaseOptions; 

import 'features/authentication/data/datasources/auth_firebase_datasource.dart'; 
import 'features/form_screen/data/repositories/auth_repository_impl.dart'; 


// Ponto de entrada do aplicativo
void main() async {
  // Garante que o Flutter Binding esteja inicializado para chamadas nativas (Firebase)
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase usando as opções da plataforma
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, 
  );

  // Configurar handler de mensagens em background
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Inicializar serviço de notificações
  await NotificationService().initialize();
  
  runApp(const MyApp()); 
}

// Widget principal que configura o tema e as rotas
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Configuração da Injeção de Dependência ---
    
    // Auth
    final authDataSource = AuthFirebaseDataSource();
    final authRepository = AuthRepositoryImpl(authDataSource);
    
    // Aluno
    final alunoDataSource = AlunoFirebaseDataSource();
    final alunoRepository = AlunoRepositoryImpl(alunoDataSource);
    
    // Atividade
    final atividadeDataSource = AtividadeFirebaseDataSource();
    final atividadeRepository = AtividadeRepositoryImpl(atividadeDataSource);
    
    // Medição
    final medicaoDataSource = MedicaoFirebaseDataSource();
    final medicaoRepository = MedicaoRepositoryImpl(medicaoDataSource);
    
    // --- MultiProvider para injetar Controllers em todas as Rotas ---
    
    return MultiProvider(
      providers: [
        // Controller do Formulário (Recebe o Repositório via injeção para cadastro Firebase)
        ChangeNotifierProvider(
          create: (_) => FormController(
            authRepository: authRepository, 
          ),
        ),
        
        // Outros Controllers
        Provider<SplashController>(create: (_) => SplashController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => ActivityController()),
        ChangeNotifierProvider(create: (_) => PulseController()),
        
        // Controllers de CRUD
        ChangeNotifierProvider(create: (_) => AlunoController(alunoRepository)),
        ChangeNotifierProvider(create: (_) => AtividadeController(atividadeRepository)),
        ChangeNotifierProvider(create: (_) => MedicaoController(medicaoRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HealthPulse', 
        
        // Definição de Tema
        theme: ThemeData(
          primaryColor: baseGreen, 
          colorScheme: ColorScheme.fromSeed(seedColor: baseGreen),
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: baseGreen,
              foregroundColor: Colors.black,
            ),
          ),
        ),
        
        // Tela inicial
        initialRoute: '/home',

        // Mapa de Rotas
        routes: {
        
          '/splash': (context) => const SplashScreen(),
          '/home': (context) => const Home(),
          '/form': (context) => const FormScreen(),
          '/pulse': (context) => const PulseScreen(),
          '/activity': (context) => const ActivityScreen(),
          '/login': (context) => const LoginScreen(),
          '/alunos': (context) => const AlunoListScreen(),
          '/medicoes': (context) => const MedicaoListScreen(),
          '/relatorios': (context) => const RelatoriosScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/atividades': (context) => const AtividadeListScreen()
        },
      ),
    );
  }
}