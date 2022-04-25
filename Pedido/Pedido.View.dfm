object PedidoVendaView: TPedidoVendaView
  Left = 0
  Top = 0
  Caption = 'Pedido de Venda'
  ClientHeight = 411
  ClientWidth = 690
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object panelPedido: TPanel
    Left = 0
    Top = 0
    Width = 690
    Height = 181
    Align = alTop
    TabOrder = 0
    DesignSize = (
      690
      181)
    object LabelDataEmissao: TLabel
      Left = 20
      Top = 85
      Width = 79
      Height = 13
      Caption = 'Data de emiss'#227'o'
    end
    object LabelValorUnitario: TLabel
      Left = 239
      Top = 139
      Width = 63
      Height = 13
      Caption = 'Valor unit'#225'rio'
    end
    object EditNumeroPedido: TLabeledEdit
      Left = 20
      Top = 20
      Width = 121
      Height = 21
      EditLabel.Width = 87
      EditLabel.Height = 13
      EditLabel.Caption = 'N'#250'mero do pedido'
      Enabled = False
      TabOrder = 0
    end
    object EditCliente: TLabeledEdit
      Left = 20
      Top = 60
      Width = 121
      Height = 21
      EditLabel.Width = 33
      EditLabel.Height = 13
      EditLabel.Caption = 'Cliente'
      TabOrder = 1
      OnChange = EditClienteChange
    end
    object ButtonCarregarPedido: TButton
      AlignWithMargins = True
      Left = 590
      Top = 143
      Width = 96
      Height = 32
      Margins.Left = 0
      Anchors = [akRight, akBottom]
      Caption = '&Carregar pedido'
      TabOrder = 8
      OnClick = ButtonCarregarPedidoClick
    end
    object ButtonCancelarPedido: TButton
      AlignWithMargins = True
      Left = 491
      Top = 143
      Width = 96
      Height = 32
      Margins.Left = 0
      Anchors = [akRight, akBottom]
      Caption = 'Ca&ncelar pedido'
      TabOrder = 7
      OnClick = ButtonCancelarPedidoClick
    end
    object EditDataEmissao: TDateTimePicker
      Left = 20
      Top = 100
      Width = 121
      Height = 21
      Date = 44675.000000000000000000
      Time = 0.469015231479716000
      TabOrder = 2
    end
    object EditProduto: TLabeledEdit
      Left = 20
      Top = 154
      Width = 121
      Height = 21
      Anchors = [akLeft, akBottom]
      EditLabel.Width = 38
      EditLabel.Height = 13
      EditLabel.Caption = 'Produto'
      TabOrder = 3
      OnExit = EditProdutoExit
    end
    object EditQuantidade: TLabeledEdit
      Left = 147
      Top = 154
      Width = 86
      Height = 21
      Anchors = [akLeft, akBottom]
      EditLabel.Width = 56
      EditLabel.Height = 13
      EditLabel.Caption = 'Quantidade'
      NumbersOnly = True
      TabOrder = 4
    end
    object ButtonAdicionar: TButton
      Left = 332
      Top = 143
      Width = 69
      Height = 32
      Margins.Left = 0
      Anchors = [akLeft, akBottom]
      Caption = '&Adicionar'
      TabOrder = 6
      OnClick = ButtonAdicionarClick
    end
    object EditValorUnitario: TMaskEdit
      Left = 239
      Top = 154
      Width = 90
      Height = 21
      TabOrder = 5
      Text = ''
    end
  end
  object panelButtons: TPanel
    Left = 0
    Top = 371
    Width = 690
    Height = 40
    Align = alBottom
    TabOrder = 2
    object LabelValorTotal: TLabel
      Left = 20
      Top = 6
      Width = 230
      Height = 25
      Caption = 'Total do pedido: R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object ButtonFechar: TButton
      AlignWithMargins = True
      Left = 611
      Top = 4
      Width = 75
      Height = 32
      Margins.Left = 0
      Align = alRight
      Caption = '&Fechar'
      ModalResult = 1
      TabOrder = 1
      OnClick = ButtonFecharClick
    end
    object ButtonGravarPedido: TButton
      AlignWithMargins = True
      Left = 512
      Top = 4
      Width = 96
      Height = 32
      Margins.Left = 0
      Align = alRight
      Caption = '&Gravar pedido'
      TabOrder = 0
      OnClick = ButtonGravarPedidoClick
    end
  end
  object GridProdutos: TDBGrid
    Left = 0
    Top = 181
    Width = 690
    Height = 190
    Align = alClient
    DataSource = DataSourceItens
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnKeyDown = GridProdutosKeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'PRODUTO'
        ReadOnly = True
        Title.Caption = 'Cod. produto'
        Width = 76
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PRODUTO_DESCRICAO'
        ReadOnly = True
        Title.Caption = 'Produto'
        Width = 207
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QUANTIDADE'
        Title.Caption = 'Quantidade'
        Width = 86
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VALOR_UNITARIO'
        Title.Caption = 'Valor unit'#225'rio'
        Width = 101
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VALOR_TOTAL'
        ReadOnly = True
        Title.Caption = 'Valor total'
        Width = 101
        Visible = True
      end>
  end
  object DataSourceItens: TDataSource
    DataSet = ClientDataSetItens
    Left = 488
    Top = 32
  end
  object ClientDataSetItens: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforePost = ClientDataSetItensBeforePost
    AfterPost = ClientDataSetItensAfterPost
    Left = 592
    Top = 40
    object ClientDataSetItensID: TIntegerField
      FieldName = 'ID'
    end
    object ClientDataSetItensPRODUTO: TIntegerField
      FieldName = 'PRODUTO'
    end
    object ClientDataSetItensPRODUTO_DESCRICAO: TStringField
      FieldName = 'PRODUTO_DESCRICAO'
      Size = 100
    end
    object ClientDataSetItensQUANTIDADE: TFloatField
      FieldName = 'QUANTIDADE'
    end
    object ClientDataSetItensVALOR_UNITARIO: TFloatField
      FieldName = 'VALOR_UNITARIO'
    end
    object ClientDataSetItensVALOR_TOTAL: TFloatField
      FieldName = 'VALOR_TOTAL'
    end
    object ClientDataSetItensEXCLUIR: TBooleanField
      FieldName = 'EXCLUIR'
    end
  end
end
