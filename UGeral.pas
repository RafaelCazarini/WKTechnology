unit UGeral;

interface

uses
  UProduto, UPedido, UItemPedido, UCliente;

var
  Pedido: TPedido;
  Produto: TProduto;
  ItemPedido: TItemPedido;
  Cliente: TCliente;

procedure InicializarInstancias;

implementation

procedure InicializarInstancias;
begin
  Pedido     := TPedido.Create;
  Produto    := TProduto.Create(0,'',0,0);
  ItemPedido := TItemPedido.Create;
  Cliente    := TCliente.Create(0,'',0,'');
end;

end.

