import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {

  TextEditingController _controllerNome = TextEditingController();
  File _imagem;
  String _idUsuarioLogado;
  bool _subindoImagem=false;
  String _urlImagemRecuperada;



  Future _recuperarImagem(String origem) async{
    File imagemSelecionada;
    switch(origem){
      case "camera":
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria":
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagem = imagemSelecionada;
      if(_imagem != null){
        _subindoImagem = true;
        _uploadImagem();
      }
    });

  }

  Future _uploadImagem()async{
    FirebaseStorage storage = FirebaseStorage.instance;
    //pega a referencia
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz.child("perfil").child(_idUsuarioLogado +".jpg");
    //upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

    //controlar progresso do upload
    task.events.listen((StorageTaskEvent storageEvent){
      if(storageEvent.type == StorageTaskEventType.progress){
        setState(() {
          _subindoImagem=true;
        });

      } else if(storageEvent.type == StorageTaskEventType.success){
        setState(() {
          _subindoImagem=false;
        });
      }

    });
    //Recuperar a Url
    task.onComplete.then((StorageTaskSnapshot snapshot){
    _recuperarUrlImagem(snapshot);
    });
  }
  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot)async{
    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestore( url );

    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  _atualizarUrlImagemFirestore(String url){
    Firestore db = Firestore.instance;

    Map<String,dynamic> dadosAtualizar = {
      "urlImagem": url
    };

    db.collection("usuarios")
    .document(_idUsuarioLogado)
    .updateData(dadosAtualizar);
  }
  _atualizarNomeFirestore(){
    String nome = _controllerNome.text;
    Firestore db = Firestore.instance;
    Map<String,dynamic> dadosAtualizarNome = {
      "nome": nome
    };

    db.collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData(dadosAtualizarNome);
  }
  
  _recuperarDadosUsuario()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    //recuperar dados do usuario
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios").document(_idUsuarioLogado).get();

    Map<String, dynamic> dadosRecuperados = snapshot.data;
    _controllerNome.text = dadosRecuperados["nome"];
    if(dadosRecuperados["urlImagem"] != null){
      setState(() {
        _urlImagemRecuperada = dadosRecuperados["urlImagem"];
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDadosUsuario();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //carregando
                Container(
                  padding: EdgeInsets.all(16),
                  child: _subindoImagem
                      ? CircularProgressIndicator()
                      : Container(),
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundImage: _urlImagemRecuperada !=null
                      ? NetworkImage(_urlImagemRecuperada)
                      :null,
                  backgroundColor: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Câmera"),
                      onPressed: (){
                        _recuperarImagem("camera");
                      },
                    ),
                    FlatButton(
                      child: Text("Galeria"),
                      onPressed: (){
                        _recuperarImagem("galeria");
                      },
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        //preenchendo com uma cor sólida
                        filled: true,
                        //ao definir um filled como true podemos usar o fillColor
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 16,bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    /*arredondando o botão*/
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _atualizarNomeFirestore();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
