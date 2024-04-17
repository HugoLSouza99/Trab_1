import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final BancoHelper bdHelper = BancoHelper();
  late List<PrestServ> _dados;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _dados = [];
    _searchController = TextEditingController();
    carregarDados();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void carregarDados() async {
    await bdHelper.iniciarBD();
    List<PrestServ> dados = await bdHelper.buscarPrestServ();
    setState(() {
      _dados = dados;
    });
  }

  List<PrestServ> filtrarDados(String query) {
    return _dados.where((item) {
      final nomeLowerCase = item.nome.toLowerCase();
      final queryLowerCase = query.toLowerCase();
      return nomeLowerCase.contains(queryLowerCase);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Example'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {}); // Rebuild the UI with the new query
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search for a person',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchController.text.isEmpty
                  ? _dados.length
                  : filtrarDados(_searchController.text).length,
              itemBuilder: (context, index) {
                final filteredData = filtrarDados(_searchController.text);
                final item = filteredData[index];
                return ListTile(
                  title: Text(item.nome),
                  subtitle: Text(item.tipoServico),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BancoHelper {
  static const arquivoDoBancoDeDados = 'nossoBD.db';
  static const arquivoDoBancoDeDadosVersao = 1;

  static const tabela = 'prestadorServiço';
  static const colunaIdPSer = 'id';
  static const colunaNomePSer = 'nome';
  static const colunaEmailPSer = 'email';
  static const colunaTelefonePSer = 'telefone';
  static const colunaTipoServico = 'tipoServico';

  late Database _bancoDeDados;

  Future<void> iniciarBD() async {
    String caminhoBD = await getDatabasesPath();
    _bancoDeDados = await openDatabase(
      join(caminhoBD, arquivoDoBancoDeDados),
      version: arquivoDoBancoDeDadosVersao,
      onCreate: (db, version) {
        // Database creation logic if it doesn't exist
        // You can define your table creation queries here
      },
      onUpgrade: (db, oldVersion, newVersion) {
        // Database upgrade logic if needed
      },
    );
  }

  Future<List<PrestServ>> buscarPrestServ() async {
    List<Map<String, dynamic>> results = await _bancoDeDados.query(tabela);
    return results.map((item) => PrestServ.fromMap(item)).toList();
  }
  
  getDatabasesPath() {}
  
  openDatabase(String join, {required int version, required Null Function(dynamic db, dynamic version) onCreate, required Null Function(dynamic db, dynamic oldVersion, dynamic newVersion) onUpgrade}) {}
}

class Database {
  query(String tabela) {}
}

class PrestServ {
  final int id;
  final String nome;
  final String email;
  final String telefone;
  final String tipoServico;

  PrestServ({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.tipoServico,
  });

  factory PrestServ.fromMap(Map<String, dynamic> map) {
    return PrestServ(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      telefone: map['telefone'],
      tipoServico: map['tipoServico'],
    );
  }
}