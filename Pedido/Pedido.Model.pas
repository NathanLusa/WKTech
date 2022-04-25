unit Pedido.Model;

interface

uses
  Entities.Pedido, Pedido.Controller, Cliente.Model, Produto.Model;

type
  TPedidoModel = class
  private
    FController: TPedidoController;
    FPedidoList: TPedidoList;
    FClienteModel: TClienteModel;
    FProdutoModel: TProdutoModel;

    procedure CarregarItensPedidos;

    function GetController: TPedidoController;
    function GetPedidoList: TPedidoList;
    function GetClienteModel: TClienteModel;
    function GetProdutoModel: TProdutoModel;
  protected
    property Controller: TPedidoController read GetController;
    property PedidoList: TPedidoList read GetPedidoList;
    property ClienteModel: TClienteModel read GetClienteModel;
    property ProdutoModel: TProdutoModel read GetProdutoModel;
  public
    destructor Destroy; override;

    procedure CarregarPedidos;
    procedure ExcluirPedido(NumeroPedido: Integer);
    procedure GravarPedido(Pedido: TPedido);
    procedure RemoverItemPedido(NumeroPedido, IdItemPedido: Integer);

    function GetPedido(NumeroPedido: Integer): TPedido;
  end;

implementation

uses
  FireDAC.Comp.Client, System.SysUtils, Utils;

{ TPedidoModel }

procedure TPedidoModel.CarregarItensPedidos;
var
  AQuery: TFDQuery;
  APedido: TPedido;
  APedidoItem: TPedidoItem;
begin
  AQuery := Controller.GetQueryItensPedidos;
  try
    for APedido in PedidoList do
    begin
      AQuery.Filtered := False;
      AQuery.Filter := 'PEDIDO = ' + APedido.Numero.ToString;
      AQuery.Filtered := True;

      AQuery.First;
      while not AQuery.Eof do
      begin
        APedidoItem := TPedidoItem.Create;
        try
          APedidoItem.Id := AQuery.FieldByName('ID').AsInteger;
          APedidoItem.Produto := ProdutoModel.GetProduto(AQuery.FieldByName('PRODUTO').AsInteger);
          APedidoItem.Quantidade := AQuery.FieldByName('QUANTIDADE').AsFloat;
          APedidoItem.ValorUnitario := AQuery.FieldByName('VALOR_UNITARIO').AsFloat;
          APedidoItem.ValorTotal := AQuery.FieldByName('VALOR_TOTAL').AsFloat;

          APedido.PedidoItemList.Add(APedidoItem);
        except
          APedidoItem.Free;
          raise;
        end;
        AQuery.Next;
      end;
    end;
   finally
    AQuery.Free;
  end;
end;

procedure TPedidoModel.CarregarPedidos;
var
  AQuery: TFDQuery;
  APedido: TPedido;
begin
  AQuery := Controller.GetQueryPedidos;
  try
    AQuery.First;
    while not AQuery.Eof do
    begin
      APedido := TPedido.Create;
      try
        APedido.Numero := AQuery.FieldByName('NUMERO').AsInteger;
        APedido.DataEmissao := AQuery.FieldByName('DATA_EMISSAO').AsDateTime;
        APedido.ValorTotal := AQuery.FieldByName('VALOR_TOTAL').AsFloat;
        APedido.Cliente := ClienteModel.GetCliente(AQuery.FieldByName('CLIENTE').AsInteger);

        PedidoList.Add(APedido);
      except
        APedido.Free;
        raise;
      end;
      AQuery.Next;
    end;
  finally
    AQuery.Free;
  end;

  CarregarItensPedidos;
end;

destructor TPedidoModel.Destroy;
begin
  FController.Free;
  FPedidoList.Free;
  FClienteModel.Free;
  FProdutoModel.Free;
  inherited;
end;

procedure TPedidoModel.ExcluirPedido(NumeroPedido: Integer);
begin
  if Controller.ExcluirPedido(NumeroPedido) then
    PedidoList.RemoverPedido(NumeroPedido);
end;

function TPedidoModel.GetClienteModel: TClienteModel;
begin
  if not Assigned(FClienteModel) then
    FClienteModel := TClienteModel.Create;

  Result := FClienteModel;
end;

function TPedidoModel.GetController: TPedidoController;
begin
  if not Assigned(FController) then
    FController := TPedidoController.Create;

  Result := FController;
end;

function TPedidoModel.GetPedido(NumeroPedido: Integer): TPedido;
var
  APedido: TPedido;
begin
  Result := nil;
  for APedido in PedidoList do
    if APedido.Numero = NumeroPedido then
      Exit(TPedido(Utils.Clone(APedido)));
end;

function TPedidoModel.GetPedidoList: TPedidoList;
begin
  if not Assigned(FPedidoList) then
    FPedidoList := TPedidoList.Create;

  Result := FPedidoList;
end;

function TPedidoModel.GetProdutoModel: TProdutoModel;
begin
  if not Assigned(FProdutoModel) then
    FProdutoModel := TProdutoModel.Create;

  Result := FProdutoModel;
end;

procedure TPedidoModel.GravarPedido(Pedido: TPedido);
begin
  if not Assigned(Pedido) then
    Exit;

  if Controller.GravarPedido(Pedido) then
    PedidoList.SetPedido(Pedido);
end;

procedure TPedidoModel.RemoverItemPedido(NumeroPedido, IdItemPedido: Integer);
var
  APedido: TPedido;
begin
  APedido := GetPedido(NumeroPedido);
  try
    if Assigned(APedido) then
      if APedido.PedidoItemList.RemoverItem(IdItemPedido) then
        GravarPedido(APedido);
  except
    APedido.Free;
    raise;
  end;
end;

end.
