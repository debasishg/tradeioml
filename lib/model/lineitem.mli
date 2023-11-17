  open Common

  type line_item = {
    order_no: Orderid.Orderno.t;
    isin: Instrumentid.ISINCode.t;
    quantity: quantity;
    unit_price: unit_price;
    buy_sell: buy_sell;
  } [@@deriving fields ~getters]
