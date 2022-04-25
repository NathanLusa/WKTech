unit Pedido.Controller;

interface

uses
  Entities.Pedido, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TPedidoController = class
  private
    function CriarPedido(Pedido: TPedido): Boolean;
    function AlterarPedido(Pedido: TPedido): Boolean;
    procedure CriarPedidoItem(NumeroPedido: Integer; PedidoItem: TPedidoItem);
  public
    function ExcluirPedido(NumeroPedido: Integer): Boolean;
    function GravarPedido(Pedido: TPedido): Boolean;
    function GetQueryPedidos: TFDQuery;
    function GetQueryItensPedidos: TFDQuery;
  end;

implementation

{ TPedidoController }

uses
  DB.DataModuleConexao;

function TPedidoController.AlterarPedido(Pedido: TPedido): Boolean;
var
  AQuery: TFDQuery;
  APedidoItem: TPedidoItem;
begin
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := DataModuleConexao.GetConnection;
    AQuery.SQL.Clear;
    AQuery.SQL.Add('UPDATE PEDIDO SET DATA_EMISSAO = :DATA_EMISSAO, ');
    AQuery.SQL.Add(' CLIENTE = :CLIENTE, VALOR_TOTAL = :VALOR_TOTAL WHERE NUMERO = :NUMERO ');
    AQuery.ParamByName('NUMERO').AsInteger := Pedido.Numero;
    AQuery.ParamByName('DATA_EMISSAO').AsDateTime := Pedido.DataEmissao;
    AQuery.ParamByName('CLIENTE').AsInteger := Pedido.Cliente.Codigo;
    AQuery.ParamByName('VALOR_TOTAL').AsFloat := Pedido.ValorTotal;
    AQuery.ExecSQL;

    AQuery.SQL.Clear;
    AQuery.SQL.Add('UPDATE PEDIDO_ITEM SET QUANTIDADE = :QUANTIDADE, VALOR_UNITARIO = :VALOR_UNITARIO, ');
    AQuery.SQL.Add(' VALOR_TOTAL = :VALOR_TOTAL WHERE ID = :ID ');
    for APedidoItem in Pedido.PedidoItemList do
    begin
      if APedidoItem.Id <= 0 then
        CriarPedidoItem(Pedido.Numero, APedidoItem)
      else
      begin
        AQuery.ParamByName('ID').AsInteger := APedidoItem.Id;
        AQuery.ParamByName('QUANTIDADE').AsFloat := APedidoItem.Quantidade;
        AQuery.ParamByName('VALOR_UNITARIO').AsFloat := APedidoItem.ValorUnitario;
        AQuery.ParamByName('VALOR_TOTAL').AsFloat := APedidoItem.ValorTotal;
        AQuery.ExecSQL;
      end;
    end;

    Result := True;
  finally
    AQuery.Free;
  end;
end;

function TPedidoController.CriarPedido(Pedido: TPedido): Boolean;
var
  AQuery: TFDQuery;
  APedidoItem: TPedidoItem;
begin
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := DataModuleConexao.GetConnection;
    AQuery.SQL.Clear;
    AQuery.SQL.Add('INSERT INTO PEDIDO(DATA_EMISSAO, CLIENTE, VALOR_TOTAL) ');
    AQuery.SQL.Add(' VALUES (:DATA_EMISSAO, :CLIENTE, :VALOR_TOTAL); ');
    AQuery.ParamByName('DATA_EMISSAO').AsDateTime := Pedido.DataEmissao;
    AQuery.ParamByName('CLIENTE').AsInteger := Pedido.Cliente.Codigo;
    AQuery.ParamByName('VALOR_TOTAL').AsFloat := Pedido.ValorTotal;
    AQuery.ExecSQL;

    AQuery.SQL.Clear;
    AQuery.SQL.Add(' SELECT LAST_INSERT_ID() AS LAST_ID; ');
    AQuery.Open;
    Pedido.Numero := AQuery.FieldByName('LAST_ID').AsInteger;

    for APedidoItem in Pedido.PedidoItemList do
      CriarPedidoItem(Pedido.Numero, APedidoItem);

    Result := True;
  finally
    AQuery.Free;
  end;
end;

procedure TPedidoController.CriarPedidoItem(NumeroPedido: Integer; PedidoItem: TPedidoItem);
var
  AQuery: TFDQuery;
begin
  if (not Assigned(PedidoItem)) or (NumeroPedido <= 0) then
    Exit;

  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := DataModuleConexao.GetConnection;
    AQuery.SQL.Clear;
    AQuery.SQL.Add('INSERT INTO PEDIDO_ITEM(PEDIDO, PRODUTO, QUANTIDADE, VALOR_UNITARIO, VALOR_TOTAL) ');
    AQuery.SQL.Add(' VALUES (:PEDIDO, :PRODUTO, :QUANTIDADE, :VALOR_UNITARIO, :VALOR_TOTAL) ');

    AQuery.ParamByName('PEDIDO').AsInteger := NumeroPedido;
    AQuery.ParamByName('PRODUTO').AsInteger := PedidoItem.Produto.Codigo;
    AQuery.ParamByName('QUANTIDADE').AsFloat := PedidoItem.Quantidade;
    AQuery.ParamByName('VALOR_UNITARIO').AsFloat := PedidoItem.ValorUnitario;
    AQuery.ParamByName('VALOR_TOTAL').AsFloat := PedidoItem.ValorTotal;
    AQuery.ExecSQL;

    AQuery.SQL.Clear;
    AQuery.SQL.Add(' SELECT LAST_INSERT_ID() AS LAST_ID; ');
    AQuery.Open;
    PedidoItem.Id := AQuery.FieldByName('LAST_ID').AsInteger;
  finally
    AQuery.Free;
  end;

end;

function TPedidoController.ExcluirPedido(NumeroPedido: Integer): Boolean;
var
  AQuery: TFDQuery;
begin
  DataModuleConexao.GetConnection.StartTransaction;
  try
    AQuery := TFDQuery.Create(nil);
    try
      AQuery.Connection := DataModuleConexao.GetConnection;
      AQuery.SQL.Clear;
      AQuery.SQL.Add('DELETE FROM PEDIDO_ITEM WHERE PEDIDO = :PEDIDO');
      AQuery.ParamByName('PEDIDO').AsInteger := NumeroPedido;
      AQuery.ExecSQL;

      AQuery.SQL.Clear;
      AQuery.SQL.Add('DELETE FROM PEDIDO WHERE NUMERO = :PEDIDO');
      AQuery.ParamByName('PEDIDO').AsInteger := NumeroPedido;
      AQuery.ExecSQL;
    finally
      AQuery.Free;
    end;

    DataModuleConexao.GetConnection.Commit;
    Result := True;
  except
    DataModuleConexao.GetConnection.Rollback;
    raise;
  end;
end;

function TPedidoController.GetQueryItensPedidos: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  try
    Result.Connection := DataModuleConexao.GetConnection;
    Result.SQL.Clear;
    Result.SQL.Add('SELECT * FROM PEDIDO_ITEM ORDER BY PEDIDO, ID');
    Result.Open;
  except
    Result.Free;
    raise;
  end;
end;

function TPedidoController.GetQueryPedidos: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  try
    Result.Connection := DataModuleConexao.GetConnection;
    Result.SQL.Clear;
    Result.SQL.Add('SELECT * FROM PEDIDO ORDER BY NUMERO ');
    Result.Open;
  except
    Result.Free;
    raise;
  end;
end;

function TPedidoController.GravarPedido(Pedido: TPedido): Boolean;
begin
  DataModuleConexao.GetConnection.StartTransaction;
  try
    if Pedido.Numero > 0 then
      Result := AlterarPedido(Pedido)
    else
      Result := CriarPedido(Pedido);

    DataModuleConexao.GetConnection.Commit;
  except
    DataModuleConexao.GetConnection.Rollback;
    raise;
  end;
end;

end.
