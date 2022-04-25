unit Entities.Cliente;

interface

uses
  System.Generics.Collections;

type
  TCliente = class
  private
    FCodigo: Integer;
    FNome: String;
    FCidade: String;
    FUF: String;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Nome: String read FNome write FNome;
    property Cidade: String read FCidade write FCidade;
    property UF: String read FUF write FUF;
  end;

  TClienteList = TObjectList<TCliente>;

implementation

end.
