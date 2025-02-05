unit uSobre;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFrmSobre = class(TForm)
    PnlPrincipal: TPanel;
    LblNome: TLabel;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSobre: TFrmSobre;

implementation

{$R *.dfm}

procedure TFrmSobre.FormShow(Sender: TObject);
begin
  LblNome.Caption := '    Experi�ncia Profissional Com mais de 8 anos de experi�ncia na �rea de desenvolvimento de software, ' +
                     'atuando com linguagens como Progress, X++, Delphi e SQL. Durante este per�odo, trabalhei diretamente ' +
                     'com clientes e consultores de neg�cios para identificar, desenvolver e implementar ' +
                     'solu��es que atendam �s necessidades espec�ficas dos clientes.'+
                     'sempre buscando agregar valor aos processos de neg�cio.'+ #13 + #13 +
                     '    Nos �ltimos 2 anos, atuei como Coordenador de Desenvolvimento, '+
                     'liderando uma equipe de desenvolvedores em projetos estrat�gicos essenciais para o crescimento da empresa. '+
                     'Fui respons�vel pela gest�o t�cnica e pessoal da equipe, incluindo a defini��o de metas, '+
                     'acompanhamento de desempenho, e promo��o de um ambiente colaborativo. Al�m disso, '+
                     'conduzi iniciativas voltadas � melhoria cont�nua dos processos de desenvolvimento e � entrega de solu��es.';
end;

end.
