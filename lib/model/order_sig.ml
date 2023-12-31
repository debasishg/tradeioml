open Orderid
open Instrumentid
open Accountid
open Common
open Validator
open CalendarLib
open Lineitem

module type Order_sig = sig

  (* abstract types *)
  type t

  val create_line_item: 
    order_no: Orderno.t -> 
    isin: ISINCode.t -> 
    quantity: quantity -> 
    unit_price: unit_price -> 
    buy_sell: buy_sell -> 
    (line_item, string) validator_result

  val create_order: 
    no: Orderno.t -> 
    order_date: Calendar.t -> 
    account_no: Accountno.t ->
    items: line_item list -> 
    (t, string) validator_result

  val order_no: t -> Orderno.t

  val line_items: t -> line_item list

  val account_no: t -> Accountno.t

  val isin: line_item -> ISINCode.t
end

