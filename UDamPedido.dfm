object DMPedido: TDMPedido
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object TabPedido: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM Pedidos')
    Left = 24
    Top = 24
    object TabPedidoCodPed: TFDAutoIncField
      FieldName = 'CodPed'
      Origin = 'CodPed'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object TabPedidoCodCli: TIntegerField
      FieldName = 'CodCli'
      Origin = 'CodCli'
      Required = True
    end
    object TabPedidoVlrTot: TBCDField
      FieldName = 'VlrTot'
      Origin = 'VlrTot'
      Required = True
      Precision = 10
      Size = 2
    end
    object TabPedidoDtEmi: TDateField
      FieldName = 'DtEmi'
      Origin = 'DtEmi'
      Required = True
    end
  end
  object DSPedidos: TDataSource
    DataSet = TabPedido
    Left = 112
    Top = 24
  end
  object DsMemItemPedido: TDataSource
    DataSet = MemItensPedido
    Left = 112
    Top = 200
  end
  object TabItemPedido: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT I.Cditem,'
      '       I.CodPed,'
      '       I.CodPro,'
      '       P.DesPro,'
      '       I.VlrPro,'
      '       I.QtdPed,'
      '       I.VlrUni  '
      'FROM ItemPedido I'
      '     INNER JOIN Produtos P ON P.CodPro = i.CodPro'
      'WHERE I.CodPed = :CodPed        ')
    Left = 24
    Top = 88
    ParamData = <
      item
        Name = 'CodPed'
        DataType = ftInteger
      end>
    object TabItemPedidoCditem: TIntegerField
      DisplayLabel = 'Cod.Item'
      FieldName = 'Cditem'
      Origin = 'CdItem'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object TabItemPedidoCodPed: TIntegerField
      DisplayLabel = 'Cod.Pedido'
      FieldName = 'CodPed'
      Origin = 'CodPed'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Visible = False
    end
    object TabItemPedidoCodPro: TIntegerField
      DisplayLabel = 'Cod.Produto'
      FieldName = 'CodPro'
      Origin = 'CodPro'
      Required = True
    end
    object TabItemPedidoDesPro: TStringField
      AutoGenerateValue = arDefault
      DisplayLabel = 'Produto'
      DisplayWidth = 45
      FieldName = 'DesPro'
      Origin = 'DesPro'
      ProviderFlags = []
      ReadOnly = True
      Size = 255
    end
    object TabItemPedidoVlrUni: TBCDField
      DisplayLabel = 'Vlr.Unitario'
      DisplayWidth = 8
      FieldName = 'VlrUni'
      DisplayFormat = 'R$ #,##0.00'
      Precision = 10
      Size = 2
    end
    object TabItemPedidoVlrPro: TBCDField
      DisplayLabel = 'Vlr.Produto'
      FieldName = 'VlrPro'
      Origin = 'VlrPro'
      Required = True
      DisplayFormat = 'R$ #,##0.00'
      Precision = 10
      Size = 2
    end
    object TabItemPedidoQtdPed: TBCDField
      FieldName = 'QtdPed'
      Precision = 10
      Size = 2
    end
  end
  object qAux: TFDQuery
    Connection = FDConnection1
    Left = 24
    Top = 144
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=rafael'
      'User_Name=root'
      'Password=admin2025'
      'Server=localhost'
      'Port=3307'
      'DriverID=MySQL')
    Connected = True
    LoginPrompt = False
    Left = 544
    Top = 56
  end
  object DRIVER: TFDPhysMySQLDriverLink
    VendorLib = 
      'C:\Users\rafael.cazarini\Documents\Embarcadero\Studio\Projects\W' +
      'K-Rafael Cazarini\libmySQL.dll'
    Left = 544
    Top = 128
  end
  object MemItensPedido: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 24
    Top = 200
  end
  object DsItemPedido: TDataSource
    DataSet = TabItemPedido
    Left = 112
    Top = 88
  end
end
