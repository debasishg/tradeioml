open Trade_sig
open Accountid
open Instrumentid
open Common
open CalendarLib
open Market
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
  } [@@deriving fields ~getters]

  let build_trade account_no isin market buy_sell unit_price quantity trade_date value_date = {
    account_no;
    isin;
    market;
    buy_sell;
    unit_price;
    quantity;
    trade_date;
    value_date;
    tax_fees = [];
    net_amount = None;
  }

  (*
  let validate_trade_value_date =
    let open Tvalidator in
    TradingValidator.date_order "Trade date must be before value date"
  *)

  let validate_trade ~account_no ~isin ~market ~buy_sell ~unit_price ~quantity ~trade_date ~value_date = 
    let open Validator in 
    let open Tvalidator in 
    let valid = build build_trade 
    |> keep account_no
    |> keep isin
    |> keep market
    |> keep buy_sell
    |> validate unit_price (TradingValidator.float_min 1.0 "Unit price must be > 0")
    |> validate quantity (TradingValidator.float_min 1.0 "Quantity must be > 0")
    |> keep trade_date
    |> keep value_date in
    match valid with
    | Ok trade -> Ok trade
    | Error e  -> Error e 


  let create_trade ~account_no ~isin ~market ~buy_sell ~unit_price ~quantity ~trade_date ~value_date = 
    validate_trade ~account_no ~isin ~market ~buy_sell ~unit_price ~quantity ~trade_date ~value_date

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