object SelCarregaPedido: TSelCarregaPedido
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Carrega Pedido'
  ClientHeight = 108
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 336
    Height = 65
    Align = alCustom
    TabOrder = 0
    DesignSize = (
      336
      65)
    object Label2: TLabel
      Left = 37
      Top = 25
      Width = 62
      Height = 15
      Anchors = []
      Caption = 'Cod.Pedido'
    end
    object EdtPedido: TEdit
      Left = 108
      Top = 22
      Width = 121
      Height = 23
      TabOrder = 0
      OnExit = EdtPedidoExit
    end
  end
  object BtnGrava: TButton
    Left = 188
    Top = 81
    Width = 75
    Height = 25
    Caption = '&Ok'
    ModalResult = 1
    TabOrder = 1
    OnClick = BtnGravaClick
  end
  object BtnFechar: TButton
    Left = 269
    Top = 81
    Width = 75
    Height = 25
    Caption = '&Fechar'
    TabOrder = 2
    OnClick = BtnFecharClick
  end
end
