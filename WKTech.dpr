program WKTech;

uses
  Vcl.Forms,
  Pedido.View in 'Pedido\Pedido.View.pas' {PedidoVendaView},
  DB.DataModuleConexao in 'DB\DB.DataModuleConexao.pas' {DataModuleConexao: TDataModule},
  Entities.Cliente in 'Entities\Entities.Cliente.pas',
  Entities.Pedido in 'Entities\Entities.Pedido.pas',
  Entities.Produto in 'Entities\Entities.Produto.pas',
  Pedido.Model in 'Pedido\Pedido.Model.pas',
  Pedido.Controller in 'Pedido\Pedido.Controller.pas',
  Cliente.Model in 'Cliente\Cliente.Model.pas',
  Cliente.Controller in 'Cliente\Cliente.Controller.pas',
  Produto.Controller in 'Produto\Produto.Controller.pas',
  Produto.Model in 'Produto\Produto.Model.pas',
  Utils in 'Utils.pas',
  ConsultaPedido.View in 'ConsultaPedido.View.pas' {ConsultaPedidoView},
  DB.Migrations in 'DB\DB.Migrations.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPedidoVendaView, PedidoVendaView);
  Application.CreateForm(TDataModuleConexao, DataModuleConexao);
  Application.Run;
end.
