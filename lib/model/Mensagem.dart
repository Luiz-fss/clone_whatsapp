

import 'package:cloud_firestore/cloud_firestore.dart';

class Mensagem{

  String _idUsuario; //identificador do usuario que está enviando a msg
  String _mensagem; //texto digitado
  String _urlImagem; //o usuario pode enviar tanto um texto como uma imagem
  String _tipo; //define se é uma msg ou a url da img
  Timestamp _time;

  Mensagem();

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map= {
      "idUsuario": this.idUsuario,
      "mensagem": this.mensagem,
      "urlImagem": this.urlImagem,
      "tipo": this.tipo,
      "time":this.time
    };
    return map;
  }


  Timestamp get time => _time;

  set time(Timestamp value) {
    _time = value;
  }



  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get urlImagem => _urlImagem;

  set urlImagem(String value) {
    _urlImagem = value;
  }

  String get mensagem => _mensagem;

  set mensagem(String value) {
    _mensagem = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }


}