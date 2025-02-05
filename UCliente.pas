unit UCliente;

interface

uses
  System.SysUtils, FireDAC.Comp.Client;

type
  TCliente = class
  private
    FCodCli: Integer;
    FDesCli: string;
    FCodCid: Integer;
    FDsUF: string;
    function GetCodCli: Integer;
    function GetDesCli: string;
    function GetCodCid: Integer;
    function GetDsUF: string;
    procedure SetCodCli(Value: Integer);
    procedure SetDesCli(Value: string);
    procedure SetCodCid(Value: Integer);
    procedure SetDsUF(Value: string);
  public
    constructor Create(ACodCli: Integer; ADesCli: string; ACodCid: Integer; ADsUF: string);
    property CodCli: Integer read GetCodCli write SetCodCli;
    property DesCli: string read GetDesCli write SetDesCli;
    property CodCid: Integer read GetCodCid write SetCodCid;
    property DsUF: string read GetDsUF write SetDsUF;
    procedure Consultar(ADBQuery: TFDQuery);
  end;

implementation

constructor TCliente.Create(ACodCli: Integer; ADesCli: string; ACodCid: Integer; ADsUF: string);
begin
  FCodCli := ACodCli;
  FDesCli := ADesCli;
  FCodCid := ACodCid;
  FDsUF := ADsUF;
end;

function TCliente.GetCodCli: Integer;
begin
  Result := FCodCli;
end;

procedure TCliente.SetCodCli(Value: Integer);
begin
  FCodCli := Value;
end;

function TCliente.GetDesCli: string;
begin
  Result := FDesCli;
end;

procedure TCliente.SetDesCli(Value: string);
begin
  FDesCli := Value;
end;

function TCliente.GetCodCid: Integer;
begin
  Result := FCodCid;
end;

procedure TCliente.SetCodCid(Value: Integer);
begin
  FCodCid := Value;
end;

function TCliente.GetDsUF: string;
begin
  Result := FDsUF;
end;

procedure TCliente.SetDsUF(Value: string);
begin
  FDsUF := Value;
end;

procedure TCliente.Consultar(ADBQuery: TFDQuery);
begin
  if not ADBQuery.IsEmpty then
  begin
    FDesCli := ADBQuery.FieldByName('DesCli').AsString;
  end;
end;

end.

