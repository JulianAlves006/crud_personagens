import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/missao.dart';

class MissaoService{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _colecao =>
      firestore.collection('usuarios').doc(_uid).collection('missoes');

  Future<void> concluirMissao(String titulo) async{
    await _colecao.add(Missao(titulo: titulo).toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listarMissoes(){
    return _colecao.orderBy('concluidaEm', descending: true).snapshots();
  }
}
