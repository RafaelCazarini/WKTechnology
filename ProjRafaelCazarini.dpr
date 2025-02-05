program ProjRafaelCazarini;

uses
  Vcl.Forms,
  UMenu in 'UMenu.pas' {Menu},
  UCadPedido in 'UCadPedido.pas' {CadPedido},
  UDamPedido in 'UDamPedido.pas' {DMPedido: TDataModule},
  USelCarregaPedido in 'USelCarregaPedido.pas' {SelCarregaPedido},
  UPedido in 'UPedido.pas',
  UProduto in 'UProduto.pas',
  UItemPedido in 'UItemPedido.pas',
  UGeral in 'UGeral.pas',
  uSobre in 'uSobre.pas' {FrmSobre},
  UCliente in 'UCliente.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMenu, Menu);
  Application.Run;
end.
