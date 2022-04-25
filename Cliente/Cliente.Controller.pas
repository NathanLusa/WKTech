unit Cliente.Controller;

interface

uses
  Entities.Cliente, FireDAC.Comp.Client;

type
  TClienteController = class
  private
  public
    function GetQueryClientes: TFDQuery;
  end;

implementation

uses
  DB.DataModuleConexao;

{ TClienteController }

function TClienteController.GetQueryClientes: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  try
    Result.Connection := DataModuleConexao.GetConnection;
    Result.SQL.Clear;
    Result.SQL.Add('SELECT * FROM CLIENTE');
    Result.Open;
  except
    Result.Free;
    raise;
  end;
end;

end.

