unit UMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, Vcl.StdCtrls;

type
  TMenu = class(TForm)
    PnlPrincipal: TPanel;
    MainMenu1: TMainMenu;
    Cadastros: TMenuItem;
    Pedido: TMenuItem;
    Image1: TImage;
    BtnSair: TMenuItem;
    Outros1: TMenuItem;
    procedure PedidoClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure Outros1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Menu: TMenu;

implementation

{$R *.dfm}

uses UCadPedido,Usobre;

procedure TMenu.BtnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TMenu.Outros1Click(Sender: TObject);
begin
  FrmSobre := TFrmSobre.Create(Self);
  try
    FrmSobre.showmodal;
  finally
    FreeAndNil(FrmSobre)
  end;
end;

procedure TMenu.PedidoClick(Sender: TObject);
begin
  CadPedido := TCadPedido.Create(Self);
  try
    CadPedido.showmodal;
  finally
    FreeAndNil(CadPedido)
  end;
end;

end.
