open Instrumentid
open Validator
open Common

module type Instrument_sig = sig
  (* abstract type *)
  type t

  type unit_price
  type coupon_rate
  type lot_size

  (* smart constructor for creating currency *)
  val ccy: isin: ISINCode.t -> name: Instrumentname.t -> (t, string) validator_result

  (* smart constructor for creating equity *)
  val equity: isin: ISINCode.t -> name: Instrumentname.t -> lot_size: lot_size -> unit_price: unit_price -> issue_date: CalendarLib.Calendar.t -> (t, string) validator_result

  (* smart constructor for creating fixed income *)
  val fixed_income: isin: ISINCode.t -> name: Instrumentname.t -> lot_size: lot_size -> issue_date: CalendarLib.Calendar.t -> maturity_date: CalendarLib.Calendar.t option -> coupon_rate: coupon_rate -> coupon_frequency: coupon_frequency -> (t, string) validator_result

  val get_instrument_type : t -> instrument_type

  val get_isin : t -> ISINCode.t

  val get_name : t -> Instrumentname.t
  
end
  
