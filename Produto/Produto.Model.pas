unit Produto.Model;

interface

uses
  Entities.Produto, Produto.Controller;

type
  TProdutoModel = class
  private
    FController: TProdutoController;
    FProdutoList: TProdutoList;

    function GetProdutoList: TProdutoList;
    function GetController: TProdutoController;

    procedure CarregarProdutos;
  protected
    property ProdutoList: TProdutoList read GetProdutoList;
    property Controller: TProdutoController read GetController;
  public
    destructor Destroy; override;

    function GetProduto(Codigo: Integer): TProduto;
  end;

implementation

uses
  System.SysUtils, FireDAC.Comp.Client, Utils;

{ TProdutoModel }

procedure TProdutoModel.CarregarProdutos;
var
  AQuery: TFDQuery;
  AProduto: TProduto;
begin
  AQuery := Controller.GetQueryProdutos;
  try
    AQuery.First;
    while not AQuery.Eof do
    begin
      AProduto := TProduto.Create;
      try
        AProduto.Codigo := AQuery.FieldByName('CODIGO').AsInteger;
        AProduto.Descricao := AQuery.FieldByName('DESCRICAO').AsString;
        AProduto.PrecoVenda := AQuery.FieldByName('PRECO_VENDA').AsFloat;

        ProdutoList.Add(AProduto);
      except
        AProduto.Free;
        raise;
      end;
      AQuery.Next;
    end;    
  finally
    AQuery.Free
  end;
end;

destructor TProdutoModel.Destroy;
begin
  FProdutoList.Free;
  FController.Free;
  inherited;
end;

function TProdutoModel.GetProduto(Codigo: Integer): TProduto;
var
  AProduto: TProduto;
begin
  Result := nil;
  
  for AProduto in ProdutoList do
    if AProduto.Codigo = Codigo then
      Exit(TProduto(Utils.Clone(AProduto)));

  if not Assigned(Result) then
    raise Exception.Create(Format('Produto de código %s não encontrado.', [Codigo.ToString]));
end;

function TProdutoModel.GetProdutoList: TProdutoList;
begin
  if not Assigned(FProdutoList) then
  begin
    FProdutoList := TProdutoList.Create;
    CarregarProdutos;
  end;

  Result := FProdutoList;
end;

function TProdutoModel.GetController: TProdutoController;
begin
  if not Assigned(FController) then
    FController := TProdutoController.Create;

  Result := FController;
end;

end.
