unit USelCarregaPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,ugeral;

type
  TSelCarregaPedido = class(TForm)
    Panel1: TPanel;
    BtnGrava: TButton;
    BtnFechar: TButton;
    EdtPedido: TEdit;
    Label2: TLabel;
    procedure BtnFecharClick(Sender: TObject);
    procedure EdtPedidoExit(Sender: TObject);
    procedure BtnGravaClick(Sender: TObject);
  private
    { Private declarations }
  public
    VInDelete : Boolean;
    { Public declarations }
  end;

var
  SelCarregaPedido: TSelCarregaPedido;

implementation

 uses UDamPedido;

{$R *.dfm}

procedure TSelCarregaPedido.BtnFecharClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  self.Close;
end;

procedure TSelCarregaPedido.BtnGravaClick(Sender: TObject);
begin
  if EdtPedido.Text = '' then
  begin
    ModalResult := mrCancel;
    exit;
  end;

  with DMPedido do
  begin
    if VInDelete then
    begin
      ugeral.Pedido.CodPed := StrToInt(EdtPedido.Text);
      ugeral.Pedido.Delete(DMPedido.FDConnection1);
    end;
  end;
end;

procedure TSelCarregaPedido.EdtPedidoExit(Sender: TObject);
var
  Value : integer;
begin
  if EdtPedido.Text = '' then
    exit;

  if not TryStrToInt(EdtPedido.Text, Value) then
  begin
    ShowMessage('Por favor, insira apenas números.');
    EdtPedido.clear;
    EdtPedido.SetFocus;
    exit;
  end;

  with DMPedido do
  begin
    if ValidaPedido(StrToInt(EdtPedido.Text)) then
    begin
      ShowMessage('Atenção! Esse Pedido não existe.');
      EdtPedido.Clear;
      EdtPedido.SetFocus;
      exit;
    end;
    CarregaDadosPedido(StrToInt(EdtPedido.Text));
  end;
end;
end.
