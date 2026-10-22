import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/personagem.dart';

class PersonagemService{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // UID do usuário logado
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  // Os personagens pertencem ao usuário pelo caminho: usuarios/{uid}/personagens
  CollectionReference<Map<String, dynamic>> get _colecao =>
      firestore.collection('usuarios').doc(_uid).collection('personagens');

  Future<void> criarHeroi (Personagem p) async{
    await _colecao.add(p.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listarPersonagens(){
    // Sem .where: a subcoleção já contém só os personagens do usuário logado
    return _colecao.snapshots();
  }

  Future<void> tomarDano(String id, int novaVida) async{
    await _colecao.doc(id).update({'vida': novaVida});
  }

  Future<void> deletarPersonagem(String id) async{
    await _colecao.doc(id).delete();
  }


}