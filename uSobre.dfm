object FrmSobre: TFrmSobre
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Sobre'
  ClientHeight = 299
  ClientWidth = 366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PnlPrincipal: TPanel
    Left = 0
    Top = 0
    Width = 366
    Height = 299
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 88
    ExplicitTop = 112
    ExplicitWidth = 185
    ExplicitHeight = 41
    object LblNome: TLabel
      Left = 15
      Top = 48
      Width = 339
      Height = 217
      AutoSize = False
      WordWrap = True
    end
    object Label1: TLabel
      Left = 96
      Top = 16
      Width = 181
      Height = 19
      Caption = 'Rafael Truzzi Cazarini'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
