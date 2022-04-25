unit DB.DataModuleConexao;

interface

uses
  System.Classes, FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, IniFiles;

type
  TDataModuleConexao = class(TDataModule)
    FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
    FDConnection: TFDConnection;
    FDTransaction: TFDTransaction;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure Configurar;
  public
    function GetConnection: TFDConnection;
  end;

var
  DataModuleConexao: TDataModuleConexao;

implementation

uses
  Winapi.Windows, DB.Migrations, System.SysUtils, Vcl.Forms;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModuleConexao }

procedure TDataModuleConexao.Configurar;
const
  INI_FILE_NAME = 'config.ini';
var
  AMigrations: TMigrations;
  AIniFile: TIniFile;
  APasta: String;
begin
  APasta := ExtractFilePath(Application.ExeName);

  if not FileExists(APasta + INI_FILE_NAME) then
    raise Exception.Create('Arquivo "' + INI_FILE_NAME + '" não encontrado na pasta do sistema.');

  AIniFile := TIniFile.Create(APasta + INI_FILE_NAME);
  try
    FDConnection.Params.Clear;
    FDConnection.Params.Add('Database=' + AIniFile.ReadString('conexao', 'Database', ''));
    FDConnection.Params.Add('Password=' + AIniFile.ReadString('conexao', 'Password', ''));
    FDConnection.Params.Add('User_Name=' + AIniFile.ReadString('conexao', 'User', ''));
    FDConnection.Params.Add('Server=' + AIniFile.ReadString('conexao', 'Hostname', ''));
    FDConnection.Params.Add('Port=' + AIniFile.ReadString('conexao', 'Port', ''));
    FDConnection.Params.Add('DriverID=MySQL');
  finally
    AIniFile.Free;
  end;

  try
    FDConnection.Connected := True;
    AMigrations := TMigrations.Create(FDConnection);
    try
      AMigrations.CriarDatabase;
    finally
      AMigrations.Free;
    end;
  except on e:Exception do
    begin
      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TDataModuleConexao.DataModuleCreate(Sender: TObject);
begin
  Configurar;
end;

function TDataModuleConexao.GetConnection: TFDConnection;
begin
  Result := FDConnection;
end;

end.
