import 'package:trab_1/ServDetalhe.dart';
import 'package:trab_1/bd/banco_helper.dart';
import 'package:trab_1/model/PrestServ.dart';
import 'package:trab_1/model/Servico.dart';
import 'package:trab_1/model/cliente.dart';
import 'package:trab_1/pessoa_detalhe.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
   Widget build(BuildContext context) {
  var bdHelper = BancoHelper();
  final List<PrestServ> _dados = [];
  final List<Servico> _dadosServ = [];
  final List<cliente> _dadosCliente = [];

  void carregarPessoasSalvas() async {
    var r = await bdHelper.buscarPrestServ();
    
  void carregarServicosSalvos() async {
    var s = await bdHelper.buscarServ();

    void carregarClientesSalvos() async {
    var t = await bdHelper.buscarCliente();

    setState(() {
      _dados.clear();
      _dados.addAll(r);
      _dadosServ.addAll(s);
      _dadosCliente.addAll(t);
    });
  }

  Future<void> inserirRegistro() async {
    var rnd = Random();

    final nomePS = 'PrestServ ${rnd.nextInt(999999)}';
    final emailPS = 'PrestServ ${rnd.nextInt(999999)}';
    final telefonePS = rnd.nextInt(99);

    Map<String, dynamic> row = {
      BancoHelper.colunaNomePSer: nomePS,
      BancoHelper.colunaEmailPSer: emailPS,
      BancoHelper.colunaTelefonePSer: telefonePS
    };

    final id = await bdHelper.inserir(row);

    print(
        'Pessoa inserida com ID $id para $nomePS');

    carregarPessoasSalvas();
  }

  void removerTudo() async {
    await bdHelper.deletarTodos();
    carregarPessoasSalvas();
  }

   void removerTudoServ() async {
    await bdHelper.deletarTodos();
    carregarServicosSalvos();
  }
    void removerTudoCliente() async {
    await bdHelper.deletarTodos();
    carregarClientesSalvos();
  }

  @override
  void initState() {
    super.initState();
    carregarPessoasSalvas();
    carregarServicosSalvos();
    carregarClientesSalvos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Aplicativo de Prestação de Serviço'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _dados.length, 
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_dados[index].nome ?? 'Nome não informado'),
                        //Função do click/Toque
                        onTap: () async {
                          var param = _dados[index];
                         await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PessoaDetalhePS(
                                informacaoPessoaPS: param))
                              );
                              carregarPessoasSalvas();
                        },
                      );
                    },
                  ),
                ),
                  Expanded(
                  child: ListView.builder(
                    itemCount: _dadosServ.length, 
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_dadosServ[index].nome ?? 'Nome não informado'),
                        //Função do click/Toque
                        onTap: () async {
                          var param = _dadosServ[index];
                         await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServDetalhe(
                                informacaoServ: param))
                              );
                              carregarServicosSalvos();
                        },
                      );
                    },
                  ),
                ),  
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          removerTudo();
                        },
                        child: const Text('Deletar Tudo')),
                  ],
                ),
              ],
            ),
          ),
        ),        
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton(
              child: const Icon(Icons.person_add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PessoaDetalhePS(
                      informacaoPessoaPS: null,
                    ),
                  ),
                ).then((value) {
                  carregarPessoasSalvas();
                });
              },
            );   
          },
        ),
        ),
      );
  }
}
}
}
}