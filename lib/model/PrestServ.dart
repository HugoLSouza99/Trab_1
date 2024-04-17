

class PrestServ {
  int? id;
  String? nome;
  String? email;
  int? telefone;
  /*Serviço? serviço;*/
  
  PrestServ({
     this.id,
     this.nome,
     this.email,
     this.telefone
  });
  
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
    };
  }

  @override
  String toString() {
    return 'Pessoa { nome: $nome, email: $email, telefone: $telefone}';
  }
}