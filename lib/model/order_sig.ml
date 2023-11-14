open Orderid
open Instrumentid
open Accountid
open Common
open Validator
open CalendarLib

module type Order_sig = sig
  (* abstract types *)
  type line_item
  type t

  val create_line_item: 
    order_no: Orderno.t -> 
    isin: ISINCode.t -> 
    quantity: quantity -> 
    unit_price: unit_price -> 
    buy_sell: buy_sell -> 
    (line_item, string) validator_result

  val create_order: 
    order_no: Orderno.t -> 
    order_date: Calendar.t -> 
    account_no: Accountno.t ->
    line_items: line_item list -> 
    (t, string) validator_result
end

