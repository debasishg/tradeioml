open Trade_sig
open Accountid
open Instrumentid
open Common
open CalendarLib
open Market
open Validator
open List
open Taxfee

module Trade(TaxFeeForMarket: TaxFee) : Trade_sig = struct
  module TaxFeeForTrade = TaxFeeForMarket

  type money = float

  type t = {
    account_no: Accountno.t;
    isin: ISINCode.t;
    market: market;
    buy_sell: buy_sell;
    unit_price: unit_price;
    quantity: quantity;
    trade_date: Calendar.t;
    value_date: Calendar.t option;
    tax_fees: (TaxFeeForTrade.t * money) list;
    net_amount: money option;
  }

  let create_trade ~account_no ~isin ~market ~buy_sell ~unit_price ~quantity ~trade_date ~value_date = failwith "TODO"

  let principal t = t.unit_price *. t.quantity

  let net_amount t: money = 
    principal t +. (List.fold_left (fun acc (_, v) -> acc +. v) 0. t.tax_fees)

  let tax_fees t = t.tax_fees

  let value_as t tax_fee = 
    let tax_fee_rate = List.assoc tax_fee TaxFeeForTrade.tax_fee_rates in
    tax_fee_rate *. (principal t) 

  let tax_fee_calculate t tax_fee_ids: (TaxFeeForTrade.t * money) list = 
    List.map (fun tax_fee_id -> (tax_fee_id, value_as t tax_fee_id)) tax_fee_ids

  let with_tax_fees t = match (t.tax_fees, t.net_amount) with
    | ([], None) -> 
      let ids = TaxFeeForTrade.tax_fees t.market in 
      let tax_fee_values = tax_fee_calculate t ids in
      { t with tax_fees = tax_fee_values; net_amount = Some(net_amount t) }
    | _ -> t
end