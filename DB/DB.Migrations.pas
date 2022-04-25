unit DB.Migrations;

interface

uses
  FireDAC.Comp.Client, System.Classes, FireDAC.Stan.Param, FireDAC.DApt;

type
  TMigrations = class
  private
    FConnection: TFDConnection;

    procedure CriarTabelas;
    procedure CriarTabelaCliente;
    procedure CriarTabelaProduto;
    procedure CriarTabelaPedido;
    procedure CriarTabelaPedidoItem;

    procedure PopularTabelas;
    procedure PopularTabelaCliente;
    procedure PopularTabelaProduto;

    procedure ValidarConnection;
  protected
    property Connection: TFDConnection read FConnection write FConnection;
  public
    constructor Create(DBConnection: TFDConnection); overload;

    procedure CriarDatabase;
  end;

implementation

uses
  System.SysUtils;

{ TMigrations }

constructor TMigrations.Create(DBConnection: TFDConnection);
begin
  inherited Create;
  Connection := DBConnection;
end;

procedure TMigrations.CriarDatabase;
begin
  ValidarConnection;
  CriarTabelas;
  PopularTabelas;
end;

procedure TMigrations.CriarTabelaCliente;
var
  AQuery: TFDQuery;
begin
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := Connection;
    AQuery.SQL.Clear;
    AQuery.SQL.Add('CREATE TABLE IF NOT EXISTS CLIENTE ( ');
    AQuery.SQL.Add('  	CODIGO INTEGER NOT NULL AUTO_INCREMENT, ');
    AQuery.SQL.Add('    NOME VARCHAR(150) NOT NULL, ');
    AQuery.SQL.Add('    CIDADE VARCHAR(100) NOT NULL, ');
    AQuery.SQL.Add('    UF VARCHAR(2) NOT NULL, ');
    AQuery.SQL.Add('  	PRIMARY KEY (CODIGO) ) ');
    AQuery.ExecSQL;
  finally
    AQuery.Free;
  end;
end;

procedure TMigrations.CriarTabelaPedido;
var
  AQuery: TFDQuery;
begin
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := Connection;
    AQuery.SQL.Clear;
    AQuery.SQL.Add('CREATE TABLE IF NOT EXISTS PEDIDO ( ');
    AQuery.SQL.Add('  	NUMERO INTEGER NOT NULL AUTO_INCREMENT, ');
    AQuery.SQL.Add('    DATA_EMISSAO DATETIME NOT NULL, ');
    AQuery.SQL.Add('    VALOR_TOTAL FLOAT NOT NULL, ');
    AQuery.SQL.Add('  	CLIENTE INTEGER NOT NULL, ');
    AQuery.SQL.Add('  	PRIMARY KEY (NUMERO), ');
    AQuery.SQL.Add('    FOREIGN KEY (CLIENTE) REFERENCES CLIENTE (CODIGO) );');
    AQuery.ExecSQL;
  finally
    AQuery.Free;
  end;
end;

procedure TMigrations.CriarTabelaPedidoItem;
var
  AQuery: TFDQuery;
begin
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := Connection;
    AQuery.SQL.Clear;
    AQuery.SQL.Add('CREATE TABLE IF NOT EXISTS PEDIDO_ITEM ( ');
    AQuery.SQL.Add('  	ID INTEGER NOT NULL AUTO_INCREMENT, ');
    AQuery.SQL.Add('  	PEDIDO INTEGER NOT NULL, ');
    AQuery.SQL.Add('  	PRODUTO INTEGER NOT NULL, ');
    AQuery.SQL.Add('    QUANTIDADE FLOAT NOT NULL, ');
    AQuery.SQL.Add('    VALOR_UNITARIO FLOAT NOT NULL, ');
    AQuery.SQL.Add('    VALOR_TOTAL FLOAT NOT NULL, ');
    AQuery.SQL.Add('  	PRIMARY KEY (ID), ');
    AQuery.SQL.Add('    FOREIGN KEY (PEDIDO) REFERENCES PEDIDO (NUMERO), ');
    AQuery.SQL.Add('    FOREIGN KEY (PRODUTO) REFERENCES PRODUTO (CODIGO) );');
    AQuery.ExecSQL;
  finally
    AQuery.Free;
  end;
end;

procedure TMigrations.CriarTabelaProduto;
var
  AQuery: TFDQuery;
begin
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := Connection;
    AQuery.SQL.Clear;
    AQuery.SQL.Add('CREATE TABLE IF NOT EXISTS PRODUTO ( ');
    AQuery.SQL.Add('  	CODIGO INTEGER NOT NULL AUTO_INCREMENT, ');
    AQuery.SQL.Add('    DESCRICAO VARCHAR(150) NOT NULL, ');
    AQuery.SQL.Add('    PRECO_VENDA DECIMAL(12,2) NOT NULL, ');
    AQuery.SQL.Add('  	PRIMARY KEY (CODIGO) ) ');
    AQuery.ExecSQL;
  finally
    AQuery.Free;
  end;
end;

procedure TMigrations.CriarTabelas;
begin
  Connection.StartTransaction;
  try
    CriarTabelaCliente;
    CriarTabelaProduto;
    CriarTabelaPedido;
    CriarTabelaPedidoItem;

    Connection.Commit;
  except
    Connection.Rollback;
    raise;
  end;
end;

procedure TMigrations.PopularTabelaCliente;
var
  AQuery: TFDQuery;
begin
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := Connection;
    AQuery.SQL.Clear;
    AQuery.SQL.Add('SELECT 1 FROM CLIENTE ');
    AQuery.Open;

    if AQuery.RecordCount > 0 then
      Exit;

    AQuery.SQL.Clear;
    AQuery.SQL.Add('INSERT INTO CLIENTE (NOME, UF, CIDADE) VALUES');
    AQuery.SQL.Add('(''Taio Hurley'', ''PA'', ''Bagre''), ');
    AQuery.SQL.Add('(''Shivani Ramsay'', ''PA'', ''Baião''), ');
    AQuery.SQL.Add('(''Rex Kemp'', ''PA'', ''Bannach''), ');
    AQuery.SQL.Add('(''Debbie Robbins'', ''PA'', ''Barcarena''), ');
    AQuery.SQL.Add('(''Shereen Robbins'', ''PA'', ''Belém''), ');
    AQuery.SQL.Add('(''Safaa Burt'', ''PA'', ''Belterra''), ');
    AQuery.SQL.Add('(''Shereen Christensen'', ''PA'', ''Benevides''), ');
    AQuery.SQL.Add('(''Matt Waters'', ''PA'', ''Bonito''), ');
    AQuery.SQL.Add('(''Rima Li'', ''PA'', ''Bragança''), ');
    AQuery.SQL.Add('(''Waseem Hussain'', ''PA'', ''Breves''), ');
    AQuery.SQL.Add('(''Tyrell Stuart'', ''PA'', ''Bujaru''), ');
    AQuery.SQL.Add('(''Shereen Young'', ''PA'', ''Curionópolis''), ');
    AQuery.SQL.Add('(''Kelsey-Ann Bowers'', ''PA'', ''Curralinho''), ');
    AQuery.SQL.Add('(''Milly Edge'', ''PA'', ''Capanema''), ');
    AQuery.SQL.Add('(''Melanie Beck'', ''PA'', ''Castanhal''), ');
    AQuery.SQL.Add('(''Harvey Ochoa'', ''PA'', ''Chaves''), ');
    AQuery.SQL.Add('(''Kelsey Shaffer'', ''PA'', ''Colares''), ');
    AQuery.SQL.Add('(''Raul Branch'', ''PA'', ''Cametá''), ');
    AQuery.SQL.Add('(''Olivia-Rose Young'', ''PA'', ''Bom Jesus do Tocantins''), ');
    AQuery.SQL.Add('(''Habibah Shaffer'', ''PA'', ''Brasil Novo''), ');
    AQuery.SQL.Add('(''Isla-Rae Pickett'', ''PA'', ''Brejo Grande do Araguaia''); ');
    AQuery.ExecSQL;
  finally
    AQuery.Free;
  end;
end;

procedure TMigrations.PopularTabelaProduto;
var
  AQuery: TFDQuery;
begin
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := Connection;
    AQuery.SQL.Clear;
    AQuery.SQL.Add('SELECT 1 FROM PRODUTO ');
    AQuery.Open;

    if AQuery.RecordCount > 0 then
      Exit;

    AQuery.SQL.Clear;
    AQuery.SQL.Add('INSERT INTO PRODUTO (DESCRICAO, PRECO_VENDA) VALUES ');
    AQuery.SQL.Add(' (''Biscoitos'', 1.50), ');
    AQuery.SQL.Add(' (''Bisnaguinha'', 3.00), ');
    AQuery.SQL.Add(' (''Broinha de milho'', 7.50), ');
    AQuery.SQL.Add(' (''Pães de queijo'', 4.00), ');
    AQuery.SQL.Add(' (''Pão de cachorro-quente'', 7.50), ');
    AQuery.SQL.Add(' (''Pão de forma'', 9.50), ');
    AQuery.SQL.Add(' (''Pão de hambúrguer'', 10.60), ');
    AQuery.SQL.Add(' (''Água sanitária'', 8.00), ');
    AQuery.SQL.Add(' (''Alvejante'', 1.00), ');
    AQuery.SQL.Add(' (''Amaciante'', 2.00), ');
    AQuery.SQL.Add(' (''Desinfetante'', 5.00), ');
    AQuery.SQL.Add(' (''Detergente'', 6.00), ');
    AQuery.SQL.Add(' (''Escovinhas'', 3.00), ');
    AQuery.SQL.Add(' (''Esponja de aço'', 7.00), ');
    AQuery.SQL.Add(' (''Luvas de borracha'', 7.00), ');
    AQuery.SQL.Add(' (''Pá'', 50.00), ');
    AQuery.SQL.Add(' (''Pano de chão'', 6.00), ');
    AQuery.SQL.Add(' (''Pano de prato'', 10.00), ');
    AQuery.SQL.Add(' (''Rodo'', 13.00), ');
    AQuery.SQL.Add(' (''Sabão em barra'', 20.00), ');
    AQuery.SQL.Add(' (''Sabão em pó'', 21.00), ');
    AQuery.SQL.Add(' (''Vassoura'', 6.00); ');
    AQuery.ExecSQL;
  finally
    AQuery.Free;
  end;
end;

procedure TMigrations.PopularTabelas;
begin
  Connection.StartTransaction;
  try
    PopularTabelaCliente;
    PopularTabelaProduto;

    Connection.Commit;
  except
    Connection.Rollback;
    raise;
  end;
end;

procedure TMigrations.ValidarConnection;
begin
  if not Assigned(Connection) then
    raise Exception.Create('Conexão não configurada.');
end;

end.
