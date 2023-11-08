open Instrumentid
open Validator
open Common

module type Instrument_sig = sig
  (* abstract types *)
  type t

  type unit_price
  type coupon_rate
  type lot_size

  (* smart constructor for creating currency *)
  (* the arguments that you pass to the smart constructor are domain types and not strings *)
  (* and these types are validated when you create them via [of_string]. Hence there is *)
  (* no way you can pass an invalid representation of an isin or a name to the constructor *)
  val ccy: isin: ISINCode.t -> name: Instrumentname.t -> (t, string) validator_result

  (* smart constructor for creating equity *)
  val equity: isin: ISINCode.t -> name: Instrumentname.t -> lot_size: lot_size -> unit_price: unit_price -> issue_date: CalendarLib.Calendar.t -> (t, string) validator_result

  (* smart constructor for creating fixed income *)
  val fixed_income: isin: ISINCode.t -> name: Instrumentname.t -> lot_size: lot_size -> issue_date: CalendarLib.Calendar.t -> maturity_date: CalendarLib.Calendar.t option -> coupon_rate: coupon_rate -> coupon_frequency: coupon_frequency -> (t, string) validator_result

  val get_instrument_type : t -> instrument_type

  val get_isin : t -> ISINCode.t

  val get_name : t -> Instrumentname.t

  val get_unit_price : t -> unit_price option

  val get_lot_size : t -> lot_size 

  val get_issue_date : t -> CalendarLib.Calendar.t option

  val get_maturity_date : t -> CalendarLib.Calendar.t option

  val get_coupon_rate : t -> coupon_rate option

  val get_coupon_frequency : t -> coupon_frequency option
  
end
  
