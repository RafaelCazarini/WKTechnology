unit UPedido;

interface

uses
  System.SysUtils, FireDAC.Comp.Client;

type
  TPedido = class
  private
    FCodPed: Integer;
    FCodCli: Integer;
    FVlrTot: Currency;
  public
    constructor Create; overload;

    procedure Insert(ADBConnection: TFDConnection);
    procedure Delete(ADBConnection: TFDConnection);
    procedure Consultar(ADBQuery: TFDQuery);

    property CodPed: Integer read FCodPed write FCodPed;
    property CodCli: Integer read FCodCli write FCodCli;
    property VlrTot: Currency read FVlrTot write FVlrTot;
  end;

implementation

{ TPedido }

procedure TPedido.Insert(ADBConnection: TFDConnection);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := ADBConnection;
    with Query.SQL do
    begin
      Add('INSERT INTO Pedidos (CodCli,');
      Add('                     VlrTot,');
      Add('                     DtEmi)');
      Add('VALUES (:CodCli,');
      Add('        :VlrTot,');
      Add('        curdate())');
      Query.ParamByName('CodCli').AsInteger := FCodCli;
      Query.ParamByName('VlrTot').AsCurrency := FVlrTot;
      Query.ExecSQL;

      // Obtém o ID gerado (CodPed)
      Query.SQL.Text := 'SELECT LAST_INSERT_ID() AS CodPed';
      Query.Open;

    if not Query.IsEmpty then
      FCodPed := Query.FieldByName('CodPed').AsInteger;

    end;
  finally
    Query.Free;
  end;
end;

constructor TPedido.Create;
begin
  // Construtor vazio
end;

procedure TPedido.Delete(ADBConnection: TFDConnection);
var
  Query: TFDQuery;
begin
  if FCodPed = 0 then
    raise Exception.Create('Código do pedido inválido para exclusão.');

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := ADBConnection;

    // Primeiro exclui os itens relacionados ao pedido
    Query.SQL.Text := 'DELETE FROM ItemPedido WHERE CodPed = :CodPed';
    Query.ParamByName('CodPed').AsInteger := FCodPed;
    Query.ExecSQL;

    //exclui o pedido
    Query.SQL.Text := 'DELETE FROM Pedidos WHERE CodPed = :CodPed';
    Query.ParamByName('CodPed').AsInteger := FCodPed;
    Query.ExecSQL;

    // Reseta o CodPed após exclusão para nao passar dar problema
    FCodPed := 0;

  finally
    Query.Free;
  end;
end;

procedure TPedido.Consultar(ADBQuery: TFDQuery);
begin
  if not ADBQuery.IsEmpty then
  begin
    FCodPed := ADBQuery.FieldByName('CodPed').AsInteger;
    FVlrTot := ADBQuery.FieldByName('VlrTot').AsFloat;
    FCodCli := ADBQuery.FieldByName('CodCli').AsInteger;
  end;
end;

end.

