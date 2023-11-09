open Orderid
open Instrumentid
open Common
open CalendarLib
open Accountid

module Order = struct

  type line_item = {
    order_no: Orderno.t;
    isin: ISINCode.t;
    quantity: quantity;
    unit_price: unit_price;
    buySell: buy_sell;
  } 

  type order = {
    no: Orderno.t;
    order_date: Calendar.t;
    account_no: Accountno.t;
    items: line_item list;
  }

end