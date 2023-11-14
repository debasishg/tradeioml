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

  val create_trade: 
    account_no: Accountno.t 
    -> isin: ISINCode.t 
    -> market: market 
    -> buy_sell: buy_sell 
    -> unit_price: unit_price 
    -> quantity: quantity
    -> trade_date: Calendar.t 
    -> value_date: Calendar.t option -> (t, string) validator_result

  val with_tax_fees: t -> t

  val principal: t -> money

  val net_amount: t -> money
  
end