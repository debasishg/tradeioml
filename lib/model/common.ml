(* some sample currencies for the time being *)
type currency = USD | JPY | INR | GBP

let string_to_currency = function
  | "USD" -> USD
  | "JPY" -> JPY
  | "INR" -> INR
  | "GBP" -> GBP
  | _ -> failwith "Invalid currency"

(* account_type will be trading, settlement or both *)
type account_type = 
  | Trading of currency           (* with trading currency *)
  | Settlement of currency        (* with settlement currency *)
  | Both of currency * currency   (* with trading and settlement currency *)

let string_to_account_type = function
  | "Trading" -> Trading USD
  | "Settlement" -> Settlement USD
  | "Both" -> Both (USD, USD)
  | _ -> failwith "Invalid account type"

(* account_id is a string *)

(* instrument types that would be traded *)
type instrument_type = 
  | CCY
  | Equity
  | FixedIncome 

(* coupon frequency for fixed income *)
type coupon_frequency = 
  | Annual 
  | SemiAnnual 

(* buy/sell *)
type buy_sell = 
  | Buy 
  | Sell 

(* unit price for the instrument *)
type quantity = float

(* unit price for the instrument *)
type unit_price = float

type tax_fee_id =
  | TradeTax
  | Commission
  | VAT
  | Surcharge
