unit Cliente.Model;

interface

uses
  Entities.Cliente, Cliente.Controller;

type
  TClienteModel = class
  private
    FController: TClienteController;
    FClienteList: TClienteList;

    function GetClienteList: TClienteList;
    function GetController: TClienteController;

    procedure CarregarClientes;
  protected
    property ClienteList: TClienteList read GetClienteList;
    property Controller: TClienteController read GetController;
  public
    destructor Destroy; override;

    function GetCliente(Codigo: Integer): TCliente;
  end;

implementation

uses
  System.SysUtils, FireDAC.Comp.Client, Utils;

{ TClienteModel }

procedure TClienteModel.CarregarClientes;
var
  AQuery: TFDQuery;
  ACliente: TCliente;
begin
  AQuery := Controller.GetQueryClientes;
  try
    AQuery.First;
    while not AQuery.Eof do
    begin
      ACliente := TCliente.Create;
      try
        ACliente.Codigo := AQuery.FieldByName('CODIGO').AsInteger;
        ACliente.Nome := AQuery.FieldByName('NOME').AsString;
        ACliente.Cidade := AQuery.FieldByName('CIDADE').AsString;
        ACliente.UF := AQuery.FieldByName('UF').AsString;

        ClienteList.Add(ACliente);
      except
        ACliente.Free;
        raise;
      end;
      AQuery.Next;
    end;    
  finally
    AQuery.Free
  end;
end;

destructor TClienteModel.Destroy;
begin
  FClienteList.Free;
  inherited;
end;

function TClienteModel.GetCliente(Codigo: Integer): TCliente;
var
  ACliente: TCliente;
begin
  Result := nil;
  
  for ACliente in ClienteList do
    if ACliente.Codigo = Codigo then
      Exit(TCliente(Utils.Clone(ACliente)));

  if not Assigned(Result) then
    raise Exception.Create(Format('Cliente de código %s não encontrado.', [Codigo.ToString]));
end;

function TClienteModel.GetClienteList: TClienteList;
begin
  if not Assigned(FClienteList) then
  begin
    FClienteList := TClienteList.Create;
    CarregarClientes;
  end;

  Result := FClienteList;
end;

function TClienteModel.GetController: TClienteController;
begin
  if not Assigned(FController) then
    FController := TClienteController.Create;

  Result := FController;
end;

end.
