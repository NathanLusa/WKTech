unit ConsultaPedido.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TConsultaPedidoView = class(TForm)
    EditNumeroPedido: TLabeledEdit;
    ButtonSelecionar: TButton;
    procedure ButtonSelecionarClick(Sender: TObject);
    procedure EditNumeroPedidoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FNumeroPedido: Integer;
  public
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
  end;

implementation

{$R *.dfm}

procedure TConsultaPedidoView.ButtonSelecionarClick(Sender: TObject);
begin
  NumeroPedido := StrToIntDef(EditNumeroPedido.Text, 0);
  ModalResult := mrOk;
end;

procedure TConsultaPedidoView.EditNumeroPedidoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ButtonSelecionarClick(nil);
end;

end.
