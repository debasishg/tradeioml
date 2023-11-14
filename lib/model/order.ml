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
    buy_sell: buy_sell;
  } 

  type t = {
    no: Orderno.t;
    order_date: Calendar.t;
    account_no: Accountno.t;
    items: line_item list;
  }

  let build_line_item order_no isin quantity unit_price buy_sell = {
    order_no;
    isin;
    quantity;
    unit_price;
    buy_sell;
  }

  let build_order no order_date account_no items = {
    no;
    order_date;
    account_no;
    items;
  }

  let validate_order ~no ~order_date ~account_no ~items = 
    let open Validator in
    let open Tvalidator in
    let valid = build build_order
    |> keep no
    |> validate order_date (TradingValidator.date_in_future "Order date cannot be in the future")
    |> keep account_no
    |> validate items (list_is_not_empty "Line item list cannot be empty") in
    match valid with
    | Ok o -> Ok o
    | Error e -> Error e

  let validate_line_item ~order_no ~isin ~quantity ~unit_price ~buy_sell = 
    let open Validator in
    let open Tvalidator in
    let valid = build build_line_item
    |> keep order_no
    |> keep isin
    |> validate quantity (TradingValidator.float_min 1.0 "Quantity must be > 0")
    |> validate unit_price (TradingValidator.float_min 1.0 "Unit price must be > 0")
    |> keep buy_sell in
    match valid with
    | Ok li -> Ok li
    | Error e -> Error e

  let create_line_item ~order_no ~isin ~quantity ~unit_price ~buy_sell =
    validate_line_item ~order_no ~isin ~quantity ~unit_price ~buy_sell 

  let create_order ~no ~order_date ~account_no ~items =
    validate_order ~no ~order_date ~account_no ~items

end