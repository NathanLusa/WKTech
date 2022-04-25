unit Produto.Controller;

interface

uses
  Entities.Produto, FireDAC.Comp.Client;

type
  TProdutoController = class
  private
  public
    function GetQueryProdutos: TFDQuery;
  end;

implementation

uses
  DB.DataModuleConexao;

{ TProdutoController }

function TProdutoController.GetQueryProdutos: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  try
    Result.Connection := DataModuleConexao.GetConnection;
    Result.SQL.Clear;
    Result.SQL.Add('SELECT * FROM PRODUTO');
    Result.Open;
  except
    Result.Free;
    raise;
  end;
end;

end.

