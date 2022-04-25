object ConsultaPedidoView: TConsultaPedidoView
  Left = 0
  Top = 0
  Caption = 'Consulta pedido'
  ClientHeight = 54
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object EditNumeroPedido: TLabeledEdit
    Left = 20
    Top = 20
    Width = 121
    Height = 21
    EditLabel.Width = 87
    EditLabel.Height = 13
    EditLabel.Caption = 'N'#250'mero do pedido'
    NumbersOnly = True
    TabOrder = 0
    OnKeyDown = EditNumeroPedidoKeyDown
  end
  object ButtonSelecionar: TButton
    AlignWithMargins = True
    Left = 168
    Top = 3
    Width = 111
    Height = 48
    Align = alRight
    Caption = 'Selecionar'
    ModalResult = 1
    TabOrder = 1
    OnClick = ButtonSelecionarClick
  end
end
