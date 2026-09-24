# HealthPulse

Aplicativo acadêmico desenvolvido com **Flutter** para acompanhar atividades físicas, medições e indicadores de saúde em um único ambiente.

O projeto foi desenvolvido em colaboração por [Gabriela Vieira](https://github.com/gabivsv ) e [Iago Bacci](https://github.com/iagobacci ), como parte das atividades da disciplina de Desenvolvimento Mobile.

> ⚠️ **Aviso:** o HealthPulse é um protótipo educacional. Ele não substitui avaliação médica, acompanhamento profissional ou sistemas destinados ao uso clínico.

## 🩺 Sobre o projeto

O HealthPulse permite que usuários registrem atividades físicas e medições manualmente, acompanhem seu histórico e visualizem relatórios de desempenho. O aplicativo também possui um fluxo específico para personal trainers gerenciarem seus alunos.

Os dados são armazenados e sincronizados com serviços do Firebase, incluindo autenticação, Cloud Firestore e notificações. A localização pode ser registrada no momento do cadastro de uma atividade ou medição.

## Funcionalidades

### 🔐 Autenticação e cadastro

- Cadastro de usuários com nome, e-mail, senha e gênero;
- opção de cadastro como personal trainer;
- vinculação de aluno a um personal trainer por código;
- login com e-mail e senha;
- validação de credenciais e mensagens de erro;
- opção de lembrar a senha;
- preferência para receber notificações;
- encerramento de sessão.

### 👥 Gerenciamento de alunos

Usuários com perfil de personal trainer podem:

- visualizar seus alunos;
- cadastrar novos alunos;
- editar dados dos alunos;
- excluir alunos mediante confirmação;
- consultar atividades, medições e relatórios de um aluno específico.

Os dados cadastrais podem incluir nome, e-mail, senha, telefone, data de nascimento, gênero, peso e altura.

### 🏃 Registro de atividades

O aplicativo permite registrar atividades físicas com informações como:

- tipo de atividade;
- descrição;
- data e horário;
- duração;
- distância;
- calorias;
- quantidade de passos;
- latitude e longitude obtidas durante o registro.

Também há uma visão resumida do progresso diário, semanal, mensal ou anual, com indicadores de atividades e passos.

### ❤️ Registro de medições

As medições são informadas manualmente pelo usuário e podem incluir:

- batimentos cardíacos em BPM;
- pressão arterial sistólica;
- pressão arterial diastólica;
- temperatura;
- data e horário;
- localização;
- observações.

O aplicativo apresenta um histórico cronológico das medições registradas.

### 📊 Relatórios e gráficos

A área de relatórios apresenta informações como:

- total de atividades;
- total de medições;
- média de batimentos cardíacos;
- evolução dos batimentos em gráfico de linhas;
- distribuição de atividades por tipo;
- resumo do desempenho do usuário.

A tela inicial também exibe informações de perfil, como peso, altura e idade, além de um resumo da média semanal de batimentos.

### ⚙️ Perfil e configurações

O usuário pode atualizar informações como:

- foto de perfil;
- e-mail;
- senha;
- peso;
- altura;
- data de nascimento;
- preferência de notificações.

### 🔔 Notificações

O aplicativo possui suporte a notificações locais e notificações push. Um exemplo de uso é informar que uma atividade foi registrada com sucesso.

## Tecnologias utilizadas

- **Flutter** e **Dart** para desenvolvimento multiplataforma;
- **Firebase Authentication** para autenticação;
- **Cloud Firestore** para armazenamento e sincronização de dados;
- **Firebase Storage** para armazenamento de arquivos;
- **Firebase Cloud Messaging** para notificações push;
- **Flutter Local Notifications** para notificações locais;
- **Provider** para gerenciamento de estado;
- **FL Chart** para criação de gráficos;
- **Geolocator** para registro de localização;
- **Intl** para formatação de datas e valores;
- **Timezone** para configuração de notificações;
- **Flutter Test** e **Flutter Lints** para testes e qualidade do código.

## 💻 Plataformas

O projeto possui estrutura para execução em:

- Android;
- iOS;
- Web;
- Windows;
- Linux;
- macOS.

Alguns recursos podem exigir configurações específicas em cada plataforma, especialmente notificações, Firebase, armazenamento e localização.

##  📁  Estrutura do projeto

```text
healthpulse-flutter/
├── android/
├── assets/
│   ├── icons/
│   └── images/
├── ios/
├── lib/
│   ├── core/
│   │   ├── services/
│   │   ├── theme/
│   │   └── widgets/
│   ├── features/
│   │   ├── activity/
│   │   ├── aluno/
│   │   ├── authentication/
│   │   ├── atividade/
│   │   ├── form_screen/
│   │   ├── home/
│   │   ├── medicao/
│   │   ├── pulse_measurement/
│   │   ├── relatorios/
│   │   └── settings_screen/
│   ├── firebase_options.dart
│   └── main.dart
├── linux/
├── macos/
├── web/
├── windows/
├── firebase.json
├── firestore.rules
├── pubspec.yaml
└── README.md
```
## 👩🏻‍💻 Autoria

Projeto desenvolvido em colaboração por:

- [Gabriela Vieira](https://github.com/gabivsv)
- [Iago Bacci](https://github.com/iagobacci)

Projeto acadêmico desenvolvido durante a disciplina de **Desenvolvimento Mobile — IFSP**.

---

## 📄 Licença

Este projeto foi desenvolvido para fins acadêmicos.
