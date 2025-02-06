unit UCadPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Mask, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids,UPedido,UProduto,UItemPedido,UCliente,
  Vcl.Imaging.jpeg;

type
  TCadPedido = class(TForm)
    PnlPrincipal: TPanel;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    LbProduto: TLabel;
    Label2: TLabel;
    EdtCodCliente: TEdit;
    EdtProduto: TEdit;
    EdtPrecoVenda: TEdit;
    EdtDesProduto: TEdit;
    EdtQuantidadePedido: TEdit;
    Label3: TLabel;
    LbResultValorPedido: TLabel;
    BtnCancelarPedido: TButton;
    BtnCarregarPedido: TButton;
    LbValorPedido: TLabel;
    BtnGrava: TButton;
    BtnFechar: TButton;
    Image1: TImage;
    EdtDesCli: TEdit;
    BtnCancel: TButton;
    BtnGravarPedido: TButton;
    procedure EdtCodClienteExit(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure EdtProdutoExit(Sender: TObject);
    procedure EdtQuantidadePedidoExit(Sender: TObject);
    procedure BtnGravaClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure EdtCodClienteChange(Sender: TObject);
    procedure BtnCarregarPedidoClick(Sender: TObject);
    procedure BtnCancelarPedidoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnGravarPedidoClick(Sender: TObject);
    procedure AlimentaGrid();
  private
    VInAlterando : Boolean;
    { Private declarations}
    function ApenasNumeros(const Texto: string): string;
    procedure LimparCampos;
  public

  Procedure CarregaDados;
  Procedure LimpaCamposProdutos;
  Procedure RecarregaDados;
  Procedure RecarregaDadosProdutos;
  Procedure BuscaTotalPedido;
    { Public declarations }
  end;

var
  CadPedido: TCadPedido;

implementation

uses UDamPedido, USelCarregaPedido,UGeral;

{$R *.dfm}

{ TCadPedido }

procedure TCadPedido.BtnCancelarPedidoClick(Sender: TObject);
begin
  SelCarregaPedido := TSelCarregaPedido.Create(Self);
  try
    SelCarregaPedido.VInDelete := true;
    if SelCarregaPedido.ShowModal = mrOk then
      ShowMessage('Atenção! Pedido Excluido com sucesso.')
    else
      ShowMessage('Atenção! Pedido não encontrado.');
  finally
    FreeAndNil(SelCarregaPedido)
  end;
end;

procedure TCadPedido.BtnCancelClick(Sender: TObject);
begin
  LimparCampos
end;

procedure TCadPedido.BtnCarregarPedidoClick(Sender: TObject);
begin
  SelCarregaPedido := TSelCarregaPedido.Create(Self);
  try
    if SelCarregaPedido.ShowModal = mrOk then
    begin
      DMPedido.PreparaItemPedido;
      AlimentaGrid;
      RecarregaDados;
      BuscaTotalPedido;
    end
    else
      ShowMessage('Atenção! Pedido não encontrado.');
  finally
    FreeAndNil(SelCarregaPedido)
  end;
end;

procedure TCadPedido.BtnFecharClick(Sender: TObject);
begin
  self.Close;
end;

procedure TCadPedido.EdtQuantidadePedidoExit(Sender: TObject);
var
  Value: Integer;
begin
  if not TryStrToInt(EdtQuantidadePedido.Text, Value) then
  begin
    ShowMessage('Por favor, insira apenas números.');
    EdtQuantidadePedido.Clear;
    EdtQuantidadePedido.SetFocus;
  end;
end;

procedure TCadPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DMPedido.Free;
end;

procedure TCadPedido.FormCreate(Sender: TObject);
begin
  InicializarInstancias;
  DMPedido   := TDMPedido.Create(self);
end;

procedure TCadPedido.BtnGravaClick(Sender: TObject);
begin
  if (EdtQuantidadePedido.Text = '') or (EdtProduto.Text = '') or (EdtCodCliente.Text = '') then
  begin
    ShowMessage('Por favor, preencha todos os campos.');
    Exit;
  end;

  // Verifica se o DataSet do MemItensPedido está ativo
  if not DMPedido.MemItensPedido.Active then
    DMPedido.MemItensPedido.Open;

  with DMPedido.MemItensPedido do
  begin
    if VInAlterando then
    begin
      Edit;
    end
    else
    begin
      Append;
    end;

    FieldByName('CodPro').AsInteger := StrToInt(EdtProduto.Text);
    FieldByName('DesPro').AsString := EdtDesProduto.Text;
    FieldByName('QtdPed').AsInteger := StrToInt(EdtQuantidadePedido.Text);
    FieldByName('VlrUni').AsFloat := StrToFloat(ApenasNumeros(EdtPrecoVenda.Text));
    FieldByName('VlrPro').AsFloat := StrToFloat(ApenasNumeros(EdtPrecoVenda.Text)) * StrToInt(EdtQuantidadePedido.Text);
    Post;
  end;

  LimpaCamposProdutos;
  VInAlterando := False;
end;


procedure TCadPedido.BtnGravarPedidoClick(Sender: TObject);
var
  FS: TFormatSettings;
begin
  FS := TFormatSettings.Create;
  FS.DecimalSeparator := '.'; // Garante o formato correto

  if DMPedido.MemItensPedido.IsEmpty then
  begin
    ShowMessage('Não há itens no pedido para confirmar.');
    Exit;
  end;

  DMPedido.FDConnection1.StartTransaction;
  try
    if uGeral.Pedido.CodPed = 0 then
    begin
      uGeral.Pedido.CodCli := StrToInt(EdtCodCliente.Text);
      UGeral.Pedido.Insert(DMPedido.FDConnection1);
    end;

    DMPedido.MemItensPedido.First;
    while not DMPedido.MemItensPedido.Eof do
    begin
      if DMPedido.MemItensPedido.FieldByName('CdItem').AsInteger = 0 then
      Begin
        UGeral.ItemPedido.CodPed := UGeral.Pedido.CodPed;
        UGeral.ItemPedido.CodPro := DMPedido.MemItensPedido.FieldByName('CodPro').AsInteger;
        UGeral.ItemPedido.VlrPro := StrToFloat(ApenasNumeros(DMPedido.MemItensPedido.FieldByName('VlrPro').AsString), FS);
        UGeral.ItemPedido.VlrUni := StrToFloat(ApenasNumeros(DMPedido.MemItensPedido.FieldByName('VlrUni').AsString), FS);
        UGeral.ItemPedido.QtdPed := DMPedido.MemItensPedido.FieldByName('QtdPed').AsInteger;

        UGeral.ItemPedido.Inserir(DMPedido.FDConnection1);
      End;
      DMPedido.MemItensPedido.Next;
    end;

    DMPedido.totalizaPedido();
    DMPedido.FDConnection1.Commit;
    ShowMessage('Pedido gravado com sucesso!');
    DMPedido.MemItensPedido.EmptyDataSet;

    //Limpa componentes e totaliza Pedido

    LimparCampos;
    BuscaTotalPedido;
  except
    on E: Exception do
    begin
      DMPedido.FDConnection1.Rollback;
      ShowMessage('Erro ao gravar pedido: ' + E.Message);
    end;
  end;
end;

Procedure TCadPedido.LimpaCamposProdutos;
begin
  //Procedure criada apenas para limpar os campos de produtos
  EdtProduto.Clear;
  EdtPrecoVenda.Clear;
  EdtDesProduto.Clear;
  EdtQuantidadePedido.Clear;
end;

procedure TCadPedido.RecarregaDados;
begin
  EdtCodCliente.Text := IntToStr(uGeral.Pedido.CodCli);
  EdtDesCli.Text     := uGeral.Cliente.DesCli;
  EdtCodCliente.Enabled := false;
end;

Procedure TCadPedido.BuscaTotalPedido;
var FS: TFormatSettings;
begin
  with DMPedido do
  begin
    with Qaux.SQL do
    begin
      clear;
      Qaux.close;
      Add('SELECT VlrTot');
      Add('FROM Pedidos');
      Add('WHERE CodPed = :CodPed ');
      Qaux.ParamByName('CodPed').Value := uGeral.Pedido.CodPed;
      Qaux.open;

      if not Qaux.IsEmpty then
      begin
        LbResultValorPedido.Caption := FormatCurr('R$ #,##0.00', Qaux.FieldByName('VlrTot').Value);
        FS := TFormatSettings.Create;
        FS.DecimalSeparator := '.';
        FS.ThousandSeparator := ',';

        LbResultValorPedido.Caption := FormatFloat('0.00', Qaux.FieldByName('VlrTot').Value, FS);
      end;
    end;
  end;
end;


procedure TCadPedido.Button1Click(Sender: TObject);
begin
  CadPedido.Free;
  Application.CreateForm(TCadPedido, CadPedido);
  CadPedido.Show;
end;

Procedure TCadPedido.RecarregaDadosProdutos;
var FS: TFormatSettings;
begin
  UGeral.ItemPedido.CodPro := DBGrid1.DataSource.DataSet.FieldByName('CodPro').AsInteger;
  UGeral.Produto.DesPro    := DBGrid1.DataSource.DataSet.FieldByName('DesPro').AsString;
  UGeral.ItemPedido.CdItem := DBGrid1.DataSource.DataSet.FieldByName('CdItem').AsInteger;
  UGeral.ItemPedido.VlrUni := DBGrid1.DataSource.DataSet.FieldByName('VlrUni').AsFloat;
  UGeral.ItemPedido.QtdPed := DBGrid1.DataSource.DataSet.FieldByName('QtdPed').AsInteger;

  EdtProduto.Text          := IntToStr(UGeral.ItemPedido.CodPro);
  EdtDesProduto.Text       := UGeral.Produto.DesPro;
  EdtQuantidadePedido.Text := FloatToStr(UGeral.ItemPedido.QtdPed);

  FS := TFormatSettings.Create;
  FS.DecimalSeparator := '.';
  FS.ThousandSeparator := ',';

  EdtPrecoVenda.Text := FormatFloat('0.00', UGeral.ItemPedido.VlrUni, FS);
end;

procedure TCadPedido.CarregaDados;
begin
  UGeral.ItemPedido.CodPro := UGeral.Produto.CodPro;
  UGeral.ItemPedido.CodPed := UGeral.Pedido.CodPed;
  if not VInAlterando then
    UGeral.ItemPedido.CdItem := 0;
  UGeral.ItemPedido.VlrPro := (StrToCurr(ApenasNumeros(EdtPrecoVenda.Text),TFormatSettings.Create('en-US')) * StrToInt(EdtQuantidadePedido.Text));
  UGeral.ItemPedido.VlrUni := StrToCurr(ApenasNumeros(EdtPrecoVenda.Text),TFormatSettings.Create('en-US'));
  UGeral.ItemPedido.QtdPed := StrToInt(EdtQuantidadePedido.Text);
end;

procedure TCadPedido.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Resposta: Integer;
begin
  with DMPedido do
  begin
    if key = VK_DELETE then
    begin
      if MessageDlg('Você deseja continuar?', mtConfirmation, [mbyes, mbNo], 0) = 6 then
        DeletaProduto(UGeral.Pedido.CodPed, DBGrid1.DataSource.DataSet.FieldByName('CdItem').AsInteger)
    end;

    if key = VK_RETURN then
    begin
      if MessageDlg('Você deseja alterar esse produto ?', mtConfirmation, [mbyes, mbNo], 0) = 6 then
      begin
        VInAlterando := true;
        RecarregaDadosProdutos;
      end;
    end;
  end;
end;

procedure TCadPedido.EdtCodClienteChange(Sender: TObject);
begin
  BtnCarregarPedido.Enabled := EdtCodCliente.Text = '';
  BtnCancelarPedido.Enabled := EdtCodCliente.Text = '';
end;

procedure TCadPedido.EdtCodClienteExit(Sender: TObject);
var
  Value: Integer;
begin
  if not (EdtCodCliente.Text <> '') then
    exit;

  if not TryStrToInt(EdtCodCliente.Text, Value) then
  begin
    ShowMessage('Por favor, insira apenas números.');
    EdtCodCliente.clear;
    EdtCodCliente.SetFocus;
    exit;
  end;

  with DMPedido do
  begin
   if not ValidaCliente(strtoint(EdtCodCliente.Text)) then
   begin
     ShowMessage('Atenção! Cliente não cadastrato.');
     EdtCodCliente.clear;
     EdtCodCliente.SetFocus;
     exit;
   end;

   EdtDesCli.Text := UGeral.Cliente.DesCli;
   EdtCodCliente.Enabled := false;
  end;
end;


procedure TCadPedido.EdtProdutoExit(Sender: TObject);
var FS: TFormatSettings;
begin
  if not (EdtProduto.Text <> '') then
    exit;

  with DMPedido do
  begin
   if not (ValidaProduto(strtoint(EdtProduto.Text))) then
   begin
     ShowMessage('Atenção! Produto não cadastrado.');
     EdtProduto.Clear;
     EdtProduto.SetFocus;
     exit;
   end
   else
   begin
     EdtDesProduto.Text := UGeral.Produto.DesPro;

     // Garante que a formatação seja feita corretamente

     FS := TFormatSettings.Create;
     FS.DecimalSeparator := '.';
     FS.ThousandSeparator := ',';

     EdtPrecoVenda.Text := FormatFloat('0.00', UGeral.Produto.PreVen, FS);
   end;
  end;
end;

function TCadPedido.ApenasNumeros(const Texto: string): string;
var
  FS: TFormatSettings;
  TempStr: string;
  I, PontoPos: Integer;
begin
  FS := TFormatSettings.Create;
  FS.DecimalSeparator := '.';
  FS.ThousandSeparator := ',';

  // Remove caracteres indesejados
  TempStr := Texto;
  TempStr := TempStr.Replace('R$', '', [rfReplaceAll]) // Remove "R$"
                    .Replace(',', '', [rfReplaceAll]) // Remove separador de milhar
                    .Replace('.', ',', [rfReplaceAll]) // Troca vírgula por ponto decimal
                    .Trim;

  // Garante que haja apenas um único ponto decimal
  PontoPos := Pos('.', TempStr);
  for I := Length(TempStr) downto 1 do
  begin
    if (TempStr[I] = '.') and (I <> PontoPos) then
      Delete(TempStr, I, 1);
  end;

  Result := TempStr;
end;

procedure TCadPedido.LimparCampos;
begin
  EdtCodCliente.Clear;
  EdtDesCli.Clear;
  EdtProduto.Clear;
  EdtPrecoVenda.Clear;
  EdtDesProduto.Clear;
  EdtQuantidadePedido.Clear;

  if Assigned(DMPedido.MemItensPedido) then
    DMPedido.MemItensPedido.EmptyDataSet;

  BtnCarregarPedido.Enabled := EdtCodCliente.Text = '';
  BtnCancelarPedido.Enabled := EdtCodCliente.Text = '';
  EdtCodCliente.Enabled := EdtCodCliente.Text = '';
  LbResultValorPedido.Caption := '';

  // Fecha e recria as instâncias do pedido
  FreeAndNil(Pedido);
  FreeAndNil(Produto);
  FreeAndNil(ItemPedido);
  FreeAndNil(Cliente);

  InicializarInstancias;
end;

procedure TCadPedido.AlimentaGrid();
begin
  // Transferir dados do TFDQuery para TFDMemTable
  DMPedido.MemItensPedido.EmptyDataSet;
  DMPedido.TabItemPedido.First;
  while not DMPedido.TabItemPedido.Eof do
  begin
    DMPedido.MemItensPedido.Append;
    DMPedido.MemItensPedido.FieldByName('CdItem').AsInteger := DMPedido.TabItemPedido.FieldByName('CdItem').AsInteger;
    DMPedido.MemItensPedido.FieldByName('CodPro').AsInteger := DMPedido.TabItemPedido.FieldByName('CodPro').AsInteger;
    DMPedido.MemItensPedido.FieldByName('DesPro').AsString := DMPedido.TabItemPedido.FieldByName('DesPro').AsString;
    DMPedido.MemItensPedido.FieldByName('QtdPed').AsInteger := DMPedido.TabItemPedido.FieldByName('QtdPed').AsInteger;
    DMPedido.MemItensPedido.FieldByName('VlrUni').AsFloat := DMPedido.TabItemPedido.FieldByName('VlrUni').AsFloat;
    DMPedido.MemItensPedido.FieldByName('VlrPro').AsFloat := DMPedido.TabItemPedido.FieldByName('VlrPro').AsFloat;
    DMPedido.MemItensPedido.Post;
    DMPedido.TabItemPedido.Next;
  end;
end;

end.
