import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_theme.dart';
import '../controller/medicao_controller.dart';
import '../../domain/entities/medicao_entity.dart';
import '../../../aluno/presentation/controller/aluno_controller.dart';

class MedicaoFormScreen extends StatefulWidget {
  final MedicaoEntity? medicao;

  const MedicaoFormScreen({super.key, this.medicao});

  @override
  State<MedicaoFormScreen> createState() => _MedicaoFormScreenState();
}

class _MedicaoFormScreenState extends State<MedicaoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _batimentosController = TextEditingController();
  final _pressaoSistolicaController = TextEditingController();
  final _pressaoDiastolicaController = TextEditingController();
  final _temperaturaController = TextEditingController();
  final _observacoesController = TextEditingController();
  DateTime? _dataMedicao;
  String? _selectedAlunoId;
  double? _latitude;
  double? _longitude;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.medicao != null) {
      _batimentosController.text = widget.medicao!.batimentosPorMinuto.toString();
      _pressaoSistolicaController.text = widget.medicao!.pressaoSistolica?.toString() ?? '';
      _pressaoDiastolicaController.text = widget.medicao!.pressaoDiastolica?.toString() ?? '';
      _temperaturaController.text = widget.medicao!.temperatura?.toString() ?? '';
      _observacoesController.text = widget.medicao!.observacoes ?? '';
      _dataMedicao = widget.medicao!.dataMedicao;
      _selectedAlunoId = widget.medicao!.alunoId;
      _latitude = widget.medicao!.latitude;
      _longitude = widget.medicao!.longitude;
    } else {
      _dataMedicao = DateTime.now();
    }
  }

  @override
  void dispose() {
    _batimentosController.dispose();
    _pressaoSistolicaController.dispose();
    _pressaoDiastolicaController.dispose();
    _temperaturaController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Serviços de localização estão desabilitados')),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permissão de localização negada')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permissão de localização negada permanentemente')),
          );
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Localização obtida: ${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao obter localização: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
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
        _dataMedicao = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dataMedicao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione a data da medição')),
      );
      return;
    }
    if (_selectedAlunoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um aluno')),
      );
      return;
    }

    final controller = context.read<MedicaoController>();
    final medicao = MedicaoEntity(
      id: widget.medicao?.id,
      alunoId: _selectedAlunoId!,
      batimentosPorMinuto: int.parse(_batimentosController.text.trim()),
      pressaoSistolica: _pressaoSistolicaController.text.trim().isEmpty ? null : double.tryParse(_pressaoSistolicaController.text.trim()),
      pressaoDiastolica: _pressaoDiastolicaController.text.trim().isEmpty ? null : double.tryParse(_pressaoDiastolicaController.text.trim()),
      temperatura: _temperaturaController.text.trim().isEmpty ? null : double.tryParse(_temperaturaController.text.trim()),
      latitude: _latitude,
      longitude: _longitude,
      observacoes: _observacoesController.text.trim().isEmpty ? null : _observacoesController.text.trim(),
      dataMedicao: _dataMedicao!,
      createdAt: widget.medicao?.createdAt ?? DateTime.now(),
    );

    bool success;
    if (widget.medicao == null) {
      success = await controller.createMedicao(medicao);
    } else {
      success = await controller.updateMedicao(widget.medicao!.id!, medicao);
    }

    if (success && mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.medicao == null ? 'Medição criada com sucesso' : 'Medição atualizada com sucesso')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.error ?? 'Erro ao salvar medição')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final alunoController = context.watch<AlunoController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.medicao == null ? 'Nova Medição' : 'Editar Medição'),
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
              controller: _batimentosController,
              decoration: const InputDecoration(
                labelText: 'Batimentos por Minuto *',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: baseGreen)),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Batimentos é obrigatório';
                if (int.tryParse(value!) == null) return 'Digite um número válido';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _pressaoSistolicaController,
                    decoration: const InputDecoration(
                      labelText: 'Pressão Sistólica (opcional)',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: baseGreen)),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _pressaoDiastolicaController,
                    decoration: const InputDecoration(
                      labelText: 'Pressão Diastólica (opcional)',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: baseGreen)),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _temperaturaController,
              decoration: const InputDecoration(
                labelText: 'Temperatura (°C) - opcional',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: baseGreen)),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Data da Medição *', style: TextStyle(color: Colors.white70)),
              subtitle: Text(
                _dataMedicao != null ? DateFormat('dd/MM/yyyy HH:mm').format(_dataMedicao!) : 'Selecione a data',
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(Icons.calendar_today, color: baseGreen),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Localização (GPS)', style: TextStyle(color: Colors.white70)),
              subtitle: Text(
                _latitude != null && _longitude != null
                    ? '${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}'
                    : 'Não capturada',
                style: const TextStyle(color: Colors.white),
              ),
              trailing: _isLoadingLocation
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: baseGreen, strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.location_on, color: baseGreen),
                      onPressed: _getCurrentLocation,
                    ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _observacoesController,
              decoration: const InputDecoration(
                labelText: 'Observações (opcional)',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: baseGreen)),
              ),
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              child: const Text(
                'Salvar', 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

