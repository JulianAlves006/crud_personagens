import 'package:cloud_firestore/cloud_firestore.dart';

class Missao {
  String? id;
  String titulo;
  DateTime? concluidaEm;

  Missao({this.id, required this.titulo, this.concluidaEm});

  Map<String, dynamic> toMap(){
    return{
      'titulo': titulo,
      // Horário do servidor, para não depender do relógio do aparelho
      'concluidaEm': FieldValue.serverTimestamp(),
    };
  }

  factory Missao.fromMap(Map<String, dynamic> map, {String? id}){
    return Missao(
      id: id,
      titulo: map['titulo'] ?? '',
      // Enquanto o servidor não confirma, o timestamp chega nulo
      concluidaEm: (map['concluidaEm'] as Timestamp?)?.toDate(),
    );
  }
}
