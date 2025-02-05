unit UItemPedido;

interface

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client;

type
  TItemPedido = class
  private
    FCdItem: Integer;
    FCodPed: Integer;
    FCodPro: Integer;
    FVlrPro: Double;
    FVlrUni: Double;
    FQtdPed: Integer;
  public
    constructor Create; overload;
    constructor Create(aCodPed, aCodPro,aQtdPed: Integer; aVlrPro, aVlrUni: Double); overload;

    procedure Inserir(ADBConnection: TFDConnection);
    procedure Alterar(ADBConnection: TFDConnection);
    procedure Consultar(ADBQuery: TFDQuery);

    property CdItem: Integer read FCdItem write FCdItem;
    property CodPed: Integer read FCodPed write FCodPed;
    property CodPro: Integer read FCodPro write FCodPro;
    property VlrPro: Double read FVlrPro write FVlrPro;
    property VlrUni: Double read FVlrUni write FVlrUni;
    property QtdPed: Integer read FQtdPed write FQtdPed;
  end;

implementation

{ TItemPedido }

constructor TItemPedido.Create;
begin
  // Construtor vazio
end;

constructor TItemPedido.Create(aCodPed, aCodPro,aQtdPed: Integer; aVlrPro, aVlrUni: Double);
begin
  FCodPed := aCodPed;
  FCodPro := aCodPro;
  FVlrPro := aVlrPro;
  FVlrUni := aVlrUni;
  FQtdPed := aQtdPed;
end;

procedure TItemPedido.Inserir(ADBConnection: TFDConnection);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := ADBConnection;
    with Query.SQL do
    begin
      Clear;
      Add('INSERT INTO ItemPedido (CodPed,');
      Add('                        CodPro,');
      Add('                        VlrPro,');
      Add('                        VlrUni,');
      Add('                        QtdPed)');
      Add('VALUES (:CodPed,');
      Add('        :CodPro,');
      Add('        :VlrPro,');
      Add('        :VlrUni,');
      Add('        :QtdPed)');
      Query.ParamByName('CodPed').AsInteger := FCodPed;
      Query.ParamByName('CodPro').AsInteger := FCodPro;
      Query.ParamByName('VlrPro').AsFloat := FVlrPro;
      Query.ParamByName('VlrUni').AsFloat := FVlrUni;
      Query.ParamByName('QtdPed').AsFloat := FQtdPed;
      Query.ExecSQL;

      Query.close;
      Clear;
      Add('SELECT COALESCE(MAX(CdItem), 0) AS CdItem');
      Add('FROM ItemPedido');
      Add('WHERE CodPed = :CodPed');
      Query.ParamByName('CodPed').AsInteger := FCodPed;
      Query.Open;

      FCdItem := Query.FieldByName('CdItem').AsInteger;
    end;
  finally
    Query.Free;
  end;
end;

procedure TItemPedido.Alterar(ADBConnection: TFDConnection);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := ADBConnection;
    with Query.SQL do
    begin
      Add('UPDATE ItemPedido');
      Add('SET CodPro = :CodPro,');
      Add('    VlrPro = :VlrPro, ');
      Add('    VlrUni = :VlrUni,');
      Add('    QtdPed = :QtdPed');
      Add('WHERE CdItem = :CdItem');

      Query.ParamByName('CdItem').AsInteger := FCdItem;
      Query.ParamByName('CodPro').AsInteger := FCodPro;
      Query.ParamByName('VlrPro').AsFloat := FVlrPro;
      Query.ParamByName('VlrUni').AsFloat := FVlrUni;
      Query.ParamByName('QtdPed').AsFloat := FQtdPed;
      Query.ExecSQL;
    end;
  finally
    Query.Free;
  end;
end;

procedure TItemPedido.Consultar(ADBQuery: TFDQuery);
begin
  if not ADBQuery.IsEmpty then
  begin
    FCdItem := ADBQuery.FieldByName('CdItem').AsInteger;
    FCodPed := ADBQuery.FieldByName('CodPed').AsInteger;
    FCodPro := ADBQuery.FieldByName('CodPro').AsInteger;
    FVlrPro := ADBQuery.FieldByName('VlrPro').AsFloat;
    FVlrUni := ADBQuery.FieldByName('VlrUni').AsFloat;
    FQtdPed := ADBQuery.FieldByName('QtdPed').AsInteger;
  end;
end;

end.

