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
  LblNome.Caption := '    Experiência Profissional Com mais de 8 anos de experiência na área de desenvolvimento de software, ' +
                     'atuando com linguagens como Progress, X++, Delphi e SQL. Durante este período, trabalhei diretamente ' +
                     'com clientes e consultores de negócios para identificar, desenvolver e implementar ' +
                     'soluções que atendam às necessidades específicas dos clientes.'+
                     'sempre buscando agregar valor aos processos de negócio.'+ #13 + #13 +
                     '    Nos últimos 2 anos, atuei como Coordenador de Desenvolvimento, '+
                     'liderando uma equipe de desenvolvedores em projetos estratégicos essenciais para o crescimento da empresa. '+
                     'Fui responsável pela gestão técnica e pessoal da equipe, incluindo a definição de metas, '+
                     'acompanhamento de desempenho, e promoção de um ambiente colaborativo. Além disso, '+
                     'conduzi iniciativas voltadas à melhoria contínua dos processos de desenvolvimento e à entrega de soluções.';
end;

end.
