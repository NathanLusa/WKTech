unit Pedido.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, Vcl.ComCtrls, System.UITypes,
  Pedido.Model, Entities.Pedido, Cliente.Model, Produto.Model, Datasnap.DBClient,
  Entities.Produto;

type
  TPedidoVendaView = class(TForm)
    panelPedido: TPanel;
    panelButtons: TPanel;
    ButtonFechar: TButton;
    ButtonGravarPedido: TButton;
    GridProdutos: TDBGrid;
    EditNumeroPedido: TLabeledEdit;
    EditCliente: TLabeledEdit;
    ButtonCarregarPedido: TButton;
    ButtonCancelarPedido: TButton;
    EditDataEmissao: TDateTimePicker;
    LabelDataEmissao: TLabel;
    LabelValorTotal: TLabel;
    EditProduto: TLabeledEdit;
    EditQuantidade: TLabeledEdit;
    ButtonAdicionar: TButton;
    EditValorUnitario: TMaskEdit;
    LabelValorUnitario: TLabel;
    DataSourceItens: TDataSource;
    ClientDataSetItens: TClientDataSet;
    ClientDataSetItensQUANTIDADE: TFloatField;
    ClientDataSetItensVALOR_UNITARIO: TFloatField;
    ClientDataSetItensVALOR_TOTAL: TFloatField;
    ClientDataSetItensID: TIntegerField;
    ClientDataSetItensPRODUTO: TIntegerField;
    ClientDataSetItensPRODUTO_DESCRICAO: TStringField;
    ClientDataSetItensEXCLUIR: TBooleanField;
    procedure EditClienteChange(Sender: TObject);
    procedure ButtonCancelarPedidoClick(Sender: TObject);
    procedure ButtonCarregarPedidoClick(Sender: TObject);
    procedure ButtonAdicionarClick(Sender: TObject);
    procedure ButtonGravarPedidoClick(Sender: TObject);
    procedure ClientDataSetItensBeforePost(DataSet: TDataSet);
    procedure ClientDataSetItensAfterPost(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure EditProdutoExit(Sender: TObject);
    procedure ButtonFecharClick(Sender: TObject);
    procedure GridProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FPedidoModel: TPedidoModel;
    FClienteModel: TClienteModel;
    FProdutoModel: TProdutoModel;

    procedure CarregarPedido; overload;
    procedure CarregarPedido(NumeroPedido: Integer); overload;
    procedure ControlarBotoesPedido;
    procedure SetLabelValorTotal;

    function GetValorTotal: Double;
    function GetConsultaPedido: Integer;

    function GetPedidoModel: TPedidoModel;
    function GetClienteModel: TClienteModel;
    function GetProdutoModel: TProdutoModel;
  protected
    property PedidoModel: TPedidoModel read GetPedidoModel;
    property ClienteModel: TClienteModel read GetClienteModel;
    property ProdutoModel: TProdutoModel read GetProdutoModel;
  public
    destructor Destroy; override;
  end;

var
  PedidoVendaView: TPedidoVendaView;

implementation

{$R *.dfm}

uses
  ConsultaPedido.View;

procedure TPedidoVendaView.ButtonAdicionarClick(Sender: TObject);
var
  AProduto: TProduto;
begin
  AProduto := ProdutoModel.GetProduto(StrToIntDef(EditProduto.Text, 0));
  try
    if not Assigned(AProduto) then
      Exit;

    if StrToFloatDef(EditQuantidade.Text, 0) <= 0 then
      raise Exception.Create('Informe uma quantidade maior que zero.');

    if StrToFloatDef(EditValorUnitario.Text, 0) <= 0 then
      raise Exception.Create('Informe um valor unitário maior que zero.');

    ClientDataSetItens.Append;
    ClientDataSetItens.FieldByName('ID').AsInteger := 0;
    ClientDataSetItens.FieldByName('PRODUTO').AsInteger := AProduto.Codigo;
    ClientDataSetItens.FieldByName('PRODUTO_DESCRICAO').AsString := AProduto.Descricao;
    ClientDataSetItens.FieldByName('QUANTIDADE').AsFloat := StrToFloatDef(EditQuantidade.Text, 0);
    ClientDataSetItens.FieldByName('VALOR_UNITARIO').AsFloat := StrToFloatDef(EditValorUnitario.Text, 0);
    ClientDataSetItens.FieldByName('VALOR_TOTAL').AsFloat :=
      ClientDataSetItens.FieldByName('QUANTIDADE').AsFloat *
      ClientDataSetItens.FieldByName('VALOR_UNITARIO').AsFloat;
    ClientDataSetItens.FieldByName('EXCLUIR').AsBoolean := False;
    ClientDataSetItens.Post;

    EditQuantidade.Clear;
    EditValorUnitario.Clear;
    EditProduto.Clear;
  finally
    AProduto.Free;
  end;
end;

procedure TPedidoVendaView.ButtonCancelarPedidoClick(Sender: TObject);
var
  ANumeroPedido: Integer;
begin
  ANumeroPedido := GetConsultaPedido;
  if ANumeroPedido <= 0 then
    raise Exception.Create('Informe o número do pedido.');

  PedidoModel.ExcluirPedido(ANumeroPedido);
  ShowMessage('Pedido cancelado!');
end;

procedure TPedidoVendaView.ButtonCarregarPedidoClick(Sender: TObject);
begin
  CarregarPedido;
end;

procedure TPedidoVendaView.ButtonFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TPedidoVendaView.ButtonGravarPedidoClick(Sender: TObject);
var
  APedido: TPedido;
  APedidoItem: TPedidoItem;
begin
  APedido := TPedido.Create;
  try
    APedido.Numero := StrToIntDef(EditNumeroPedido.Text, 0);
    APedido.DataEmissao := EditDataEmissao.DateTime;
    APedido.Cliente := ClienteModel.GetCliente(StrToIntDef(EditCliente.Text, 0));
    APedido.ValorTotal := GetValorTotal;

    ClientDataSetItens.DisableControls;
    try
      ClientDataSetItens.First;
      while not ClientDataSetItens.Eof do
      begin
        APedidoItem := TPedidoItem.Create;
        try
          APedidoItem.Id := ClientDataSetItens.FieldByName('ID').AsInteger;
          APedidoItem.Produto := ProdutoModel.GetProduto(ClientDataSetItens.FieldByName('PRODUTO').AsInteger);
          APedidoItem.Quantidade := ClientDataSetItens.FieldByName('QUANTIDADE').AsFloat;
          APedidoItem.ValorUnitario := ClientDataSetItens.FieldByName('VALOR_UNITARIO').AsFloat;
          APedidoItem.ValorTotal := ClientDataSetItens.FieldByName('VALOR_TOTAL').AsFloat;

          APedido.PedidoItemList.Add(APedidoItem);
        except
          APedidoItem.Free;
          raise;
        end;

        ClientDataSetItens.Next;
      end;
    finally
      ClientDataSetItens.EnableControls;
    end;

    PedidoModel.GravarPedido(APedido);
    EditNumeroPedido.Text := APedido.Numero.ToString;
    ShowMessage('Pedido gravado com sucesso!');
  except
    APedido.Free;
    raise;
  end;
end;

procedure TPedidoVendaView.CarregarPedido;
begin
  CarregarPedido(GetConsultaPedido);
end;

procedure TPedidoVendaView.CarregarPedido(NumeroPedido: Integer);
var
  APedido: TPedido;
  APedidoItem: TPedidoItem;
begin
  ClientDataSetItens.EmptyDataSet;

  APedido := PedidoModel.GetPedido(NumeroPedido);
  if not Assigned(APedido) then
    raise Exception.Create('Pedido não encontrado.');

  EditNumeroPedido.Text := APedido.Numero.ToString;
  EditDataEmissao.DateTime := APedido.DataEmissao;
  EditCliente.Text := APedido.Cliente.Codigo.ToString;

  for APedidoItem in APedido.PedidoItemList do
  begin
    ClientDataSetItens.Append;
    ClientDataSetItens.FieldByName('ID').AsInteger := APedidoItem.Id;
    ClientDataSetItens.FieldByName('PRODUTO').AsInteger := APedidoItem.Produto.Codigo;
    ClientDataSetItens.FieldByName('PRODUTO_DESCRICAO').AsString := APedidoItem.Produto.Descricao;
    ClientDataSetItens.FieldByName('QUANTIDADE').AsFloat := APedidoItem.Quantidade;
    ClientDataSetItens.FieldByName('VALOR_UNITARIO').AsFloat := APedidoItem.ValorUnitario;
    ClientDataSetItens.FieldByName('VALOR_TOTAL').AsFloat := APedidoItem.ValorTotal;
    ClientDataSetItens.FieldByName('EXCLUIR').AsBoolean := False;
    ClientDataSetItens.Post;
  end;

  SetLabelValorTotal;
end;

procedure TPedidoVendaView.ClientDataSetItensAfterPost(DataSet: TDataSet);
begin
  inherited;
  SetLabelValorTotal;
end;

procedure TPedidoVendaView.ClientDataSetItensBeforePost(DataSet: TDataSet);
begin
  if ClientDataSetItens.FieldByName('QUANTIDADE').AsFloat <= 0 then
    raise Exception.Create('Informe uma quantidade maior que zero.');

  if ClientDataSetItens.FieldByName('VALOR_UNITARIO').AsFloat <= 0 then
    raise Exception.Create('Informe um valor unitário maior que zero.');

  ClientDataSetItens.FieldByName('VALOR_TOTAL').AsFloat :=
    ClientDataSetItens.FieldByName('QUANTIDADE').AsFloat *
    ClientDataSetItens.FieldByName('VALOR_UNITARIO').AsFloat;
end;

procedure TPedidoVendaView.ControlarBotoesPedido;
var
  AHabilitarBotoesPedidos: Boolean;
begin
  AHabilitarBotoesPedidos := EditCliente.Text = '';
  ButtonCancelarPedido.Visible := AHabilitarBotoesPedidos;
  ButtonCarregarPedido.Visible := AHabilitarBotoesPedidos;
end;

destructor TPedidoVendaView.Destroy;
begin
  FPedidoModel.Free;
  FClienteModel.Free;
  FProdutoModel.Free;
  inherited;
end;

procedure TPedidoVendaView.EditClienteChange(Sender: TObject);
begin
  ControlarBotoesPedido;
end;

procedure TPedidoVendaView.EditProdutoExit(Sender: TObject);
var
  AProduto: TProduto;
begin
  if EditProduto.Text = '' then
    Exit;

  AProduto := ProdutoModel.GetProduto(StrToIntDef(EditProduto.Text, 0));
  try
    if Assigned(AProduto) then
      EditValorUnitario.Text := AProduto.PrecoVenda.ToString;
  finally
    AProduto.Free;
  end;
end;

procedure TPedidoVendaView.FormShow(Sender: TObject);
begin
  ControlarBotoesPedido;

  ClientDataSetItens.CreateDataSet;
  ClientDataSetItens.Active := True;
  ClientDataSetItens.Filter := 'EXCLUIR = 0';
  ClientDataSetItens.Filtered := True;
end;

function TPedidoVendaView.GetPedidoModel: TPedidoModel;
begin
  if not Assigned(FPedidoModel) then
  begin
    FPedidoModel := TPedidoModel.Create;
    FPedidoModel.CarregarPedidos;
  end;

  Result := FPedidoModel;
end;

function TPedidoVendaView.GetClienteModel: TClienteModel;
begin
  if not Assigned(FClienteModel) then
    FClienteModel := TClienteModel.Create;

  Result := FClienteModel;
end;

function TPedidoVendaView.GetConsultaPedido: Integer;
var
  AConsultaPedidoView: TConsultaPedidoView;
begin
  Result := 0;

  AConsultaPedidoView := TConsultaPedidoView.Create(nil);
  try
    if AConsultaPedidoView.ShowModal = mrOk then
      Exit(AConsultaPedidoView.NumeroPedido);

    Abort;
  finally
    AConsultaPedidoView.Free;
  end;
end;

function TPedidoVendaView.GetProdutoModel: TProdutoModel;
begin
  if not Assigned(FProdutoModel) then
    FProdutoModel := TProdutoModel.Create;

  Result := FProdutoModel;
end;

function TPedidoVendaView.GetValorTotal: Double;
begin
  Result := 0;
  ClientDataSetItens.DisableControls;
  try
    ClientDataSetItens.First;
    while not ClientDataSetItens.Eof do
    begin
      Result := Result + ClientDataSetItens.FieldByName('VALOR_TOTAL').AsFloat;

      ClientDataSetItens.Next;
    end;
  finally
    ClientDataSetItens.EnableControls;
  end;
end;

procedure TPedidoVendaView.GridProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    if MessageDlg('Deseja realmente excluir esse produto?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      if ClientDataSetItens.FieldByName('ID').AsInteger > 0 then
        PedidoModel.RemoverItemPedido(StrToIntDef(EditNumeroPedido.Text, 0), ClientDataSetItens.FieldByName('ID').AsInteger);

      ClientDataSetItens.Delete;
    end;
end;

procedure TPedidoVendaView.SetLabelValorTotal;
begin
  LabelValorTotal.Caption := System.SysUtils.Format('Total do pedido: R$ %s', [FormatFloat('#0.00', GetValorTotal)]);
end;

end.
