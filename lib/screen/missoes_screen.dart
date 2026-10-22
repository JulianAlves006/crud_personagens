import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/missao.dart';
import '../services/missao_service.dart';

const _fundo = Color(0xFF14100C);
const _pergaminho = Color(0xFF241B13);
const _borda = Color(0xFF5A452A);
const _ouro = Color(0xFFD4A94A);
const _textoClaro = Color(0xFFEADBB8);

class MissoesScreen extends StatefulWidget {
  const MissoesScreen({super.key});

  @override
  State<MissoesScreen> createState() => _MissoesScreenState();
}

class _MissoesScreenState extends State<MissoesScreen> {
  final MissaoService _service = MissaoService();
  final TextEditingController _tituloController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  Future<void> _concluirMissao() async {
    final titulo = _tituloController.text.trim();
    if (titulo.isEmpty) return;

    await _service.concluirMissao(titulo);
    _tituloController.clear();
  }

  String _formatarData(DateTime? data) {
    if (data == null) return 'registrando...';
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(data.day)}/${dois(data.month)}/${data.year} '
        '${dois(data.hour)}:${dois(data.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1D12),
        foregroundColor: _ouro,
        title: const Text(
          'DIÁRIO DE MISSÕES',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A1D12), _fundo],
          ),
        ),
        child: Column(
          children: [
            _formulario(),
            Expanded(child: _listaMissoes()),
          ],
        ),
      ),
    );
  }

  Widget _formulario() {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _pergaminho,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borda, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 8)],
      ),
      child: Column(
        children: [
          TextField(
            controller: _tituloController,
            style: const TextStyle(color: _textoClaro),
            decoration: const InputDecoration(
              labelText: 'Missão concluída (ex: Derrotar o dragão)',
              prefixIcon: Icon(Icons.flag, color: _ouro),
            ),
            onSubmitted: (_) => _concluirMissao(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _concluirMissao,
              icon: const Icon(Icons.task_alt),
              label: const Text(
                'REGISTRAR MISSÃO',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B1E1E),
                foregroundColor: _textoClaro,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: _ouro, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaMissoes() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _service.listarMissoes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Erro: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent)),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: _ouro));
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(
            child: Text(
              'Nenhuma missão concluída ainda...',
              style: TextStyle(
                  color: _borda, fontStyle: FontStyle.italic, fontSize: 15),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final m = Missao.fromMap(doc.data(), id: doc.id);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _pergaminho,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borda, width: 2),
              ),
              child: ListTile(
                leading: const Icon(Icons.emoji_events, color: _ouro),
                title: Text(m.titulo,
                    style: const TextStyle(
                        color: _textoClaro, fontWeight: FontWeight.bold)),
                subtitle: Text('Concluída em ${_formatarData(m.concluidaEm)}',
                    style: const TextStyle(color: Color(0xFFB59A6A))),
              ),
            );
          },
        );
      },
    );
  }
}
