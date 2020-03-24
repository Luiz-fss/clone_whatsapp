
import 'package:cloud_firestore/cloud_firestore.dart';

class Conversa{

  String _idRemetente;
  String _idDestinatario;
  String _nome;
  String _mensagem;
  String _caminhoFoto;
  String _tipoMensagem;


  Conversa();

  Map<String,dynamic> toMap(){
    Map<String, dynamic> map = {
      "idRemetente":this.idRemetente,
      "idDestinatario":this.idDestinatario,
      "nome":this.nome,
      "mensagem": this.mensagem,
      "caminhoFoto": this.caminhoFoto,
      "tipoMensagem": this.tipoMensagem
    };
    return map;
  }

  salvar()async{
    /*
    *  +conversas
    *   +idRemetente
    *     +ultima conversa
    *       +destinatario*/
    Firestore db = Firestore.instance;
    await db.collection("conversas")
    .document(this.idRemetente)
    .collection("ultima_conversa")
    .document(this.idDestinatario)
    .setData(this.toMap());
  }

  String get idRemetente => _idRemetente;

  set idRemetente(String value) {
    _idRemetente = value;
  } //get e set


  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get mensagem => _mensagem;

  String get caminhoFoto => _caminhoFoto;

  set caminhoFoto(String value) {
    _caminhoFoto = value;
  }

  set mensagem(String value) {
    _mensagem = value;
  }

  String get idDestinatario => _idDestinatario;

  String get tipoMensagem => _tipoMensagem;

  set tipoMensagem(String value) {
    _tipoMensagem = value;
  }

  set idDestinatario(String value) {
    _idDestinatario = value;
  }


}