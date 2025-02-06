unit UDamPedido;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MySQLDef, FireDAC.Comp.UI,
  FireDAC.Phys.MySQL, FireDAC.Comp.DataSet,IniFiles,Vcl.Dialogs,UPedido,UProduto,UItemPedido;

type
  TDMPedido = class(TDataModule)
    TabPedido: TFDQuery;
    DSPedidos: TDataSource;
    DsMemItemPedido: TDataSource;
    TabItemPedido: TFDQuery;
    qAux: TFDQuery;
    FDConnection1: TFDConnection;
    DRIVER: TFDPhysMySQLDriverLink;
    TabPedidoCodPed: TFDAutoIncField;
    TabPedidoCodCli: TIntegerField;
    TabPedidoVlrTot: TBCDField;
    TabPedidoDtEmi: TDateField;
    TabItemPedidoCditem: TIntegerField;
    TabItemPedidoCodPed: TIntegerField;
    TabItemPedidoCodPro: TIntegerField;
    TabItemPedidoDesPro: TStringField;
    TabItemPedidoVlrPro: TBCDField;
    TabItemPedidoQtdPed: TBCDField;
    TabItemPedidoVlrUni: TBCDField;
    MemItensPedido: TFDMemTable;
    DsItemPedido: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
   VCodPed : Integer;
   Pedido  : TPedido;
   Produto : TProduto;
   ItemPedido : TItemPedido;
   function ValidaProduto (PProduto : Integer) : boolean;
   function ValidaPedido(PPedido: Integer): Boolean;
   function ValidaCliente(PCliente: Integer): Boolean;
   procedure CarregaDadosCliente(PCliente : Integer);

   procedure CarregaDadosProdutos (PProduto : Integer);
   procedure CarregaDadosPedido(PPedido : Integer);
   Procedure DeletaProduto(PCodPed,PCdItem : Integer);
   procedure GravaPedido(PCliente: Integer);
   procedure TotalizaPedido;
   procedure PreparaItemPedido;

    { Public declarations }
  end;

var
  DMPedido   : TDMPedido;

implementation

uses UGeral;


{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMPedido }

function TDMPedido.ValidaProduto(PProduto: Integer): boolean;
begin
  result := false;
  with qaux.SQL do
  begin
    clear;
    qaux.close;
    add('SELECT 1');
    add('FROM Produtos P');
    add('WHERE P.CodPro = :CodPro');
    qaux.ParamByName('CodPro').Value := PProduto;
    qaux.open;

    result := not qAux.IsEmpty;

    if result then
      CarregaDadosProdutos(PProduto);
  end;
end;

procedure TDMPedido.CarregaDadosProdutos(PProduto : Integer);
begin
  with qaux.SQL do
  begin
    clear;
    qaux.close;
    add('SELECT DesPro,');
    add('       PreVen');
    add('FROM Produtos P');
    add('WHERE P.CodPro = :CodPro');
    qaux.ParamByName('CodPro').Value := PProduto;
    qaux.open;

    UGeral.Produto.CodPro := PProduto;
    UGeral.Produto.DesPro := qaux.FieldByName('DesPro').AsString;
    UGeral.Produto.PreVen := qaux.FieldByName('PreVen').AsFloat;
  end;
end;

procedure TDMPedido.CarregaDadosPedido(PPedido : Integer);
begin
  with qaux.SQL do
  begin
    clear;
    qaux.close;
    add('SELECT PD.CodPed,');
    add('       PD.CodCli,');
    add('       PD.VlrTot,');
    add('       CL.DesCli');
    add('FROM Pedidos PD ');
    add('     INNER JOIN Clientes CL ON (CL.CodCli = PD.CodCli) ');
    add('WHERE PD.CodPed = :CodPed');
    qaux.ParamByName('CodPed').Value := PPedido;
    qaux.open;
    UGeral.Pedido.Consultar(qaux);
    UGeral.Cliente.Consultar(qaux);
  end;
end;

function TDMPedido.ValidaCliente(PCliente: Integer): Boolean;
begin
  with qaux.SQL do
  begin
    clear;
    qaux.close;
    add('SELECT 1');
    add('FROM Clientes C');
    add('WHERE C.CodCli = :CodCli');
    qaux.ParamByName('CodCli').Value := PCliente;
    qaux.open;

    result := not qaux.IsEmpty;
    if Result then
      CarregaDadosCliente(PCliente);
  end;
end;

procedure TDMPedido.CarregaDadosCliente(PCliente : Integer);
begin
  with qaux.SQL do
  begin
    clear;
    qaux.close;
    add('SELECT CodCli,');
    add('       DesCli');
    add('FROM Clientes P');
    add('WHERE P.CodCli = :CodCli');
    qaux.ParamByName('CodCli').Value := PCliente;
    qaux.open;

    UGeral.Cliente.CodCli := PCliente;
    UGeral.Cliente.DesCli := qaux.FieldByName('DesCli').AsString;
  end;
end;

function TDMPedido.ValidaPedido(PPedido: Integer): Boolean;
begin
  with qaux.SQL do
  begin
    clear;
    qaux.close;
    add('SELECT 1');
    add('FROM Pedidos PD');
    add('WHERE PD.CodPed = :CodPed');
    qaux.ParamByName('CodPed').Value := PPedido;
    qaux.open;

    result := qaux.IsEmpty;
  end;
end;


procedure TDMPedido.GravaPedido(PCliente: Integer);
begin
  UGeral.Pedido.CodCli := PCliente;
  with DMPedido do
  begin
    UGeral.Pedido.Insert(FDConnection1);
  end;
end;

procedure TDMPedido.PreparaItemPedido;
begin
  TabItemPedido.Close;
  TabItemPedido.ParamByName('CodPed').Value := UGeral.Pedido.CodPed;
  TabItemPedido.open;
end;

procedure TDMPedido.TotalizaPedido;
begin
  with qaux.SQL do
  begin
    clear;
    qaux.close;
    add('Call SPTotalizaEAtualizaPedido(:CodPed);');
    qaux.ParamByName('CodPed').Value :=  UGeral.Pedido.CodPed;
    qaux.ExecSQL;
  end;
end;

procedure TDMPedido.DataModuleCreate(Sender: TObject);
var
  Ini: TIniFile;
  vServidor,
  vUsername,
  vPort,
  vPassword,
  vDatabase,
  VDriver,
  vDll  : String;
  vIdleTime: Integer;
begin
  Try
    Ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+'Config.ini');
    vDatabase := Ini.ReadString('Login','Database','');
    vServidor := Ini.ReadString('Login','Server','');
    vUsername := Ini.ReadString('Login','Username','');
    vPort     := Ini.ReadString('Login','Port','');
    vPassword := Ini.ReadString('Login','Password','');
    vDll       := Ini.ReadString('Login','Dll','');

    vIdleTime := Ini.ReadInteger('Login', 'IdleTime', 60000); //Padrão é 1 minuto

    If (vServidor = '') OR (vDataBase = '') Then
    Begin
      Exit;
    End
    else
    begin
      FDConnection1.LoginPrompt := False;
      FDConnection1.Params.Clear;
      FDConnection1.Params.Add('DriverID=MySQL');
      FDConnection1.Params.Add('Server='+vServidor);
      FDConnection1.Params.Add('Database='+vDatabase);
      FDConnection1.Params.Add('User_Name='+vUsername);
      FDConnection1.Params.Add('Password='+vPassword);
      FDConnection1.Params.Add('Port='+vPort);
      DRIVER.VendorLib := ExtractFilePath(ParamStr(0))+'libmySQL.dll';
      FDConnection1.Connected := True;
    end;
  Except
    ON E: Exception Do
     ShowMessage('Erro inicialização, erro: ' + E.Message);
  End;

    // Criando a estrutura do MemItensPedido
  with MemItensPedido do
  begin
    Close;
    FieldDefs.Clear;

    FieldDefs.Add('CdItem', ftInteger);
    FieldDefs.Add('CodPro', ftInteger);
    FieldDefs.Add('DesPro', ftString, 80);
    FieldDefs.Add('QtdPed', ftInteger);
    FieldDefs.Add('VlrUni', ftFloat);
    FieldDefs.Add('VlrPro', ftFloat);

    CreateDataSet;

    FieldByName('CdItem').Visible := False;
    FieldByName('CodPro').DisplayLabel := 'Produto';
    FieldByName('DesPro').DisplayLabel := 'Descrição';

    FieldByName('QtdPed').DisplayLabel := 'Quantidade';
    FieldByName('VlrUni').DisplayLabel := 'Valor Unitário';
    FieldByName('VlrPro').DisplayLabel := 'Valor Total';
  end;

end;

procedure TDMPedido.DataModuleDestroy(Sender: TObject);
begin
  MemItensPedido.Close;
end;

Procedure TDMPedido.DeletaProduto(PCodPed,PCdItem : Integer);
begin
  with qaux.SQL do
  begin
    clear;
    qaux.close;
    add('DELETE FROM ItemPedido');
    add('WHERE CdItem = :CdItem');
    add('AND CodPed = :CodPed');
    qaux.ParamByName('CdItem').Value := PCdItem;
    qaux.ParamByName('CodPed').Value := PCodPed;
    qaux.ExecSQL;
  end;
  PreparaItemPedido;
end;


end.
