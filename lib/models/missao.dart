import 'package:cloud_firestore/cloud_firestore.dart';

class Missao {
  String? id;
  String titulo;
  DateTime? concluidaEm;

  Missao({this.id, required this.titulo, this.concluidaEm});

  Map<String, dynamic> toMap(){
    return{
      'titulo': titulo,
      'concluidaEm': FieldValue.serverTimestamp(),
    };
  }

  factory Missao.fromMap(Map<String, dynamic> map, {String? id}){
    return Missao(
      id: id,
      titulo: map['titulo'] ?? '',
      concluidaEm: (map['concluidaEm'] as Timestamp?)?.toDate(),
    );
  }
}
