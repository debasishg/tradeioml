open Executionid
open Accountid
open CalendarLib

module Execution = struct
  type execution = {
    refno: ExecutionRefNo.t;
    account_no: Accountno.t;
    line_item: Lineitem.line_item;
    market: Market.market;
    date_of_execution: Calendar.t;
    exchange_ref_no: string option;
  }

  let from_order (order: Order.Order.t) (market: Market.market) : execution list = 
    List.map (fun item -> {
      refno = ExecutionRefNo.of_string_unsafe "abc";
      account_no = Order.Order.account_no order;
      line_item = item;
      market = market;
      date_of_execution = Calendar.now ();
      exchange_ref_no = None;
    }) (Order.Order.line_items order)

end
