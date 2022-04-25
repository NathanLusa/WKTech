unit Entities.Pedido;

interface

uses
  System.Generics.Collections, Entities.Cliente, Entities.Produto;

type
  TPedidoItem = class
  private
    FId: Integer;
    FProduto: TProduto;
    FQuantidade: Double;
    FValorUnitario: Double;
    FValorTotal: Double;
  public
    property Id: Integer read FId write FId;
    property Produto: TProduto read FProduto write FProduto;
    property Quantidade: Double read FQuantidade write FQuantidade;
    property ValorUnitario: Double read FValorUnitario write FValorUnitario;
    property ValorTotal: Double read FValorTotal write FValorTotal;
  end;

  TPedidoItemList = class(TObjectList<TPedidoItem>)
  public
    function RemoverItem(IdItemPedido: Integer): Boolean;
  end;

  TPedido = class
  private
    FNumero: Integer;
    FDataEmissao: TDate;
    FCliente: TCliente;
    FValorTotal: Double;
    FPedidoItemList: TPedidoItemList;

    function GetPedidoItemList: TPedidoItemList;
    function GetCliente: TCliente;

    procedure SetCliente(const Value: TCliente);
  public
    destructor Destoy;

    property Numero: Integer read FNumero write FNumero;
    property DataEmissao: TDate read FDataEmissao write FDataEmissao;
    property Cliente: TCliente read GetCliente write SetCliente;
    property ValorTotal: Double read FValorTotal write FValorTotal;
    property PedidoItemList: TPedidoItemList read GetPedidoItemList;
  end;

  TPedidoList = class(TObjectList<TPedido>)
  public
    procedure RemoverPedido(NumeroPedido: Integer);
    procedure SetPedido(Pedido: TPedido);
  end;

implementation

{ TPedido }

destructor TPedido.Destoy;
begin
  FPedidoItemList.Free;
  FCliente.Free;
end;

function TPedido.GetCliente: TCliente;
begin
  if not Assigned(FCliente) then
    FCliente := TCliente.Create;

  Result := FCliente;
end;

function TPedido.GetPedidoItemList: TPedidoItemList;
begin
  if not Assigned(FPedidoItemList) then
    FPedidoItemList := TPedidoItemList.Create;

  Result := FPedidoItemList;
end;

procedure TPedido.SetCliente(const Value: TCliente);
begin
  FCliente.Free;
  FCliente := Value;
end;

{ TPedidoList }

procedure TPedidoList.RemoverPedido(NumeroPedido: Integer);
var
  APedido: TPedido;
begin
  for APedido in Self do
    if APedido.Numero = NumeroPedido then
    begin
      Self.Remove(APedido);
      Exit;
    end;
end;

procedure TPedidoList.SetPedido(Pedido: TPedido);
var
  APedido: TPedido;
begin
  for APedido in Self do
    if APedido.Numero = Pedido.Numero then
    begin
      Self.Remove(APedido);
      Break;
    end;

  Self.Add(Pedido);
end;

{ TPedidoItemList }

function TPedidoItemList.RemoverItem(IdItemPedido: Integer): Boolean;
var
  APedidoItem: TPedidoItem;
begin
  Result := False;
  for APedidoItem in Self do
    if APedidoItem.Id = IdItemPedido then
    begin
      Self.Remove(APedidoItem);
      Exit(True);
    end;
end;

end.
