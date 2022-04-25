object DataModuleConexao: TDataModuleConexao
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 254
  Width = 426
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database='
      'User_Name=root'
      'Password='
      'Server=localhost'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 72
    Top = 40
  end
  object FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink
    Left = 72
    Top = 192
  end
  object FDTransaction: TFDTransaction
    Connection = FDConnection
    Left = 88
    Top = 120
  end
end
