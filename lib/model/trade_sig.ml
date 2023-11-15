open Taxfee
open Accountid
open Instrumentid
open Common
open CalendarLib
open Market
open Validator

module type Trade_sig = sig
  module TaxFeeForTrade : TaxFee
  type t
  type money

  (* create a validated trade *)
  val create_trade: 
    account_no: Accountno.t 
    -> isin: ISINCode.t 
    -> market: market 
    -> buy_sell: buy_sell 
    -> unit_price: unit_price 
    -> quantity: quantity
    -> trade_date: Calendar.t 
    -> value_date: Calendar.t option -> (t, string) validator_result

  (* decorate a trade with tax/fees and net amount *)
  val with_tax_fees: t -> t

  (* get the principal amount of the trade *)
  val principal: t -> money

  (* get the net amount of the trade *)
  val net_amount: t -> money

  val tax_fees: t -> (TaxFeeForTrade.t * money) list
  
end