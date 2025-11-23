import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../controller/atividade_controller.dart';
import '../../domain/entities/atividade_entity.dart';
import '../../../aluno/presentation/controller/aluno_controller.dart';

class AtividadeFormScreen extends StatefulWidget {
  final AtividadeEntity? atividade;

  const AtividadeFormScreen({super.key, this.atividade});

  @override
  State<AtividadeFormScreen> createState() => _AtividadeFormScreenState();
}

class _AtividadeFormScreenState extends State<AtividadeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tipoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _duracaoController = TextEditingController();
  final _distanciaController = TextEditingController();
  final _caloriasController = TextEditingController();
  final _passosController = TextEditingController();
  DateTime? _dataInicio;
  DateTime? _dataFim;
  String? _selectedAlunoId;

  @override
  void initState() {
    super.initState();
    if (widget.atividade != null) {
      _tipoController.text = widget.atividade!.tipo;
      _descricaoController.text = widget.atividade!.descricao;
      _duracaoController.text = widget.atividade!.duracaoMinutos?.toString() ?? '';
      _distanciaController.text = widget.atividade!.distanciaKm?.toString() ?? '';
      _caloriasController.text = widget.atividade!.calorias?.toString() ?? '';
      _passosController.text = widget.atividade!.passos?.toString() ?? '';
      _dataInicio = widget.atividade!.dataInicio;
      _dataFim = widget.atividade!.dataFim;
      _selectedAlunoId = widget.atividade!.alunoId;
    }
  }

  @override
  void dispose() {
    _tipoController.dispose();
    _descricaoController.dispose();
    _duracaoController.dispose();
    _distanciaController.dispose();
    _caloriasController.dispose();
    _passosController.dispose();
    super.dispose();
  }

  Future<void> _selectDateInicio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color.fromRGBO(41, 227, 60, 1),
                onPrimary: Colors.black,
                surface: Color(0xFF1A1A1A),
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.black,
            ),
            child: child!,
          );
        },
      );
    if (picked != null) {
      setState(() {
        _dataInicio = picked;
      });
    }
  }

  Future<void> _selectDateFim(BuildContext context) async {
   final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color.fromRGBO(41, 227, 60, 1),
                onPrimary: Colors.black,
                surface: Color(0xFF1A1A1A),
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.black,
            ),
            child: child!,
          );
        },
      );
    if (picked != null) {
      setState(() {
        _dataFim = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dataInicio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione a data de início')),
      );
      return;
    }
    if (_selectedAlunoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um aluno')),
      );
      return;
    }

    final controller = context.read<AtividadeController>();
    final atividade = AtividadeEntity(
      id: widget.atividade?.id,
      alunoId: _selectedAlunoId!,
      tipo: _tipoController.text.trim(),
      descricao: _descricaoController.text.trim(),
      dataInicio: _dataInicio!,
      dataFim: _dataFim,
      duracaoMinutos: _duracaoController.text.trim().isEmpty ? null : double.tryParse(_duracaoController.text.trim()),
      distanciaKm: _distanciaController.text.trim().isEmpty ? null : double.tryParse(_distanciaController.text.trim()),
      calorias: _caloriasController.text.trim().isEmpty ? null : int.tryParse(_caloriasController.text.trim()),
      passos: _passosController.text.trim().isEmpty ? null : int.tryParse(_passosController.text.trim()),
      createdAt: widget.atividade?.createdAt ?? DateTime.now(),
    );

    bool success;
    if (widget.atividade == null) {
      success = await controller.createAtividade(atividade);
    } else {
      success = await controller.updateAtividade(widget.atividade!.id!, atividade);
    }

    if (success && mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.atividade == null ? 'Atividade criada com sucesso' : 'Atividade atualizada com sucesso')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.error ?? 'Erro ao salvar atividade')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final alunoController = context.watch<AlunoController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.atividade == null ? 'Nova Atividade' : 'Editar Atividade'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedAlunoId,
              decoration: const InputDecoration(
                labelText: 'Aluno *',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: baseGreen)),
              ),
              dropdownColor: widgetsColor,
              style: const TextStyle(color: Colors.white),
              items: alunoController.alunos.map((aluno) {
                return DropdownMenuItem<String>(
                  value: aluno.id,
                  child: Text(aluno.nome),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedAlunoId = value),
              validator: (value) => value == null ? 'Selecione um aluno' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tipoController,
              decoration: const InputDecoration(
                labelText: 'Tipo *',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: baseGreen)),
              ),
              style: const TextStyle(color: Colors.white),
              validator: (value) => value?.isEmpty ?? true ? 'Tipo é obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição *',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: baseGreen)),
              ),
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              validator: (value) => value?.isEmpty ?? true ? 'Descrição é obrigatória' : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Data de Início *', style: TextStyle(color: Colors.white70)),
              subtitle: Text(
                _dataInicio != null ? DateFormat('dd/MM/yyyy HH:mm').format(_dataInicio!) : 'Selecione a data',
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(Icons.calendar_today, color: baseGreen),
              onTap: () => _selectDateInicio(context),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Data de Fim (opcional)', style: TextStyle(color: Colors.white70)),
              subtitle: Text(
                _dataFim != null ? DateFormat('dd/MM/yyyy HH:mm').format(_dataFim!) : 'Selecione a data',
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(Icons.calendar_today, color: baseGreen),
              onTap: () => _selectDateFim(context),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _duracaoController,
              decoration: const InputDecoration(
                labelText: 'Duração (minutos) - opcional',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: baseGreen)),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _distanciaController,
              decoration: const InputDecoration(
                labelText: 'Distância (km) - opcional',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: baseGreen)),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _caloriasController,
              decoration: const InputDecoration(
                labelText: 'Calorias - opcional',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: baseGreen)),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passosController,
              decoration: const InputDecoration(
                labelText: 'Passos - opcional',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: baseGreen)),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}

