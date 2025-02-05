unit UProduto;

interface

uses
  System.SysUtils;

type
  TProduto = class
  private
    FCodPro: Integer;
    FDesPro: string;
    FPreVen: Double;
    FQtdPed: Integer;
    function GetCodPro: Integer;
    function GetDesPro: string;
    function GetPreVen: Double;
    function GetQtdPed: Integer;
    procedure SetDesPro(Value: string);
    procedure SetCodPro(Value: Integer);
    procedure SetPreVen(Value: Double);
    procedure SetQtdPed(Value: Integer);
  public
    constructor Create(ACodPro: Integer; ADesPro: string; APreVen: Double; AQtdPed: Integer);
    property CodPro: Integer read GetCodPro write SetCodPro;
    property DesPro: string read GetDesPro write SetDesPro;
    property PreVen: Double read GetPreVen write SetPreVen;
    property QtdPed: Integer read GetQtdPed write SetQtdPed;
  end;

implementation

constructor TProduto.Create(ACodPro: Integer; ADesPro: string; APreVen: Double; AQtdPed: Integer);
begin
  FCodPro := ACodPro;
  FDesPro := ADesPro;
  FPreVen := APreVen;
  FQtdPed := AQtdPed;
end;

function TProduto.GetCodPro: Integer;
begin
  Result := FCodPro;
end;

procedure TProduto.SetCodPro(Value: Integer);
begin
  FCodPro := Value;
end;

function TProduto.GetDesPro: string;
begin
  Result := FDesPro;
end;

procedure TProduto.SetDesPro(Value: string);
begin
  FDesPro := Value;
end;

function TProduto.GetPreVen: Double;
begin
  Result := FPreVen;
end;

procedure TProduto.SetPreVen(Value: Double);
begin
  FPreVen := Value;
end;

function TProduto.GetQtdPed: Integer;
begin
  Result := FQtdPed;
end;

procedure TProduto.SetQtdPed(Value: Integer);
begin
  FQtdPed := Value;
end;

end.

