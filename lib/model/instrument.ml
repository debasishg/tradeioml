open Base
open Instrumentid
open Instrument_sig
open Common

module Instrument : Instrument_sig = struct
  (* unit price for the instrument *)
  type unit_price = float

  (* coupon rate for fixed income *)
  type coupon_rate = float

  (* lot size for the instrument *)
  type lot_size = int

  (* the basic attributes of an instrument *)
  type instrument_base = {
    isin: ISINCode.t;
    name: Instrumentname.t;
    lot_size: lot_size;
  }

  (* Attributes specific to instrument types *)

  (* Currency *)
  module Ccy = struct
    type t = {
      instrument_type: instrument_type;
    }
  end

  (* Equity - stocks *)
  module Equity = struct
    type t = {
      instrument_type: instrument_type;
      issue_date: CalendarLib.Calendar.t;
      unit_price: unit_price;
    }
  end

  (* Fixed Income - bonds *)
  module FixedIncome = struct
    type t = {
      instrument_type: instrument_type;
      issue_maturity_date: CalendarLib.Calendar.t * CalendarLib.Calendar.t option;
      (*
      issue_date: CalendarLib.Calendar.t;
      maturity_date: CalendarLib.Calendar.t option;
      *)
      coupon_rate: coupon_rate;
      coupon_frequency: coupon_frequency;
    }
  end

  type custom = 
    | Ccy of Ccy.t
    | Equity of Equity.t
    | FixedIncome of FixedIncome.t

  type t = {
    base: instrument_base;
    custom: custom;
  }

  let build_instrument_base isin name lot_size = {
    isin;
    name;
    lot_size;
  }

  let validate_lot_size =
    let open Validator in
    int_min 1 "Must be > 0"

  (* [isin] and [name] come validated via the newtypes *)
  (* just need to validate [lot_size] *)
  let validate_base ~isin ~name ~lot_size = 
    let open Validator in
    let valid = build build_instrument_base 
    |> keep isin
    |> keep name
    |> validate lot_size validate_lot_size in
    match valid with
    | Ok base -> Ok base
    | Error e -> Error e

  let validate_issue_maturity_date =
    let open Tvalidator in
    TradingValidator.date_order "Issue date must be before maturity date"

  let build_fixed_income (instrument_type: instrument_type) (issue_maturity_date: CalendarLib.Calendar.t * CalendarLib.Calendar.t option) (coupon_rate: coupon_rate) (coupon_frequency: coupon_frequency) = FixedIncome {
    instrument_type; 
    issue_maturity_date; 
    coupon_rate;
    coupon_frequency;
  }

  let validate_fixed_income (instrument_type: instrument_type) (issue_maturity_date: CalendarLib.Calendar.t * CalendarLib.Calendar.t option) (coupon_rate: coupon_rate) (coupon_frequency: coupon_frequency) =
    let open Validator in
    let valid = build build_fixed_income
    |> keep instrument_type
    |> validate issue_maturity_date validate_issue_maturity_date 
    |> keep coupon_rate
    |> keep coupon_frequency in
    match valid with
    | Ok _ -> Ok ()
    | Error e -> Error e

  let ccy ~isin ~name = 
    let valid = validate_base ~isin ~name ~lot_size: 1 in
    match valid with
    | Ok base -> Ok { base = base; custom = Ccy { instrument_type = CCY } }
    | Error e -> Error e 

  let equity ~isin ~name ~lot_size ~unit_price ~issue_date = 
    let valid = validate_base ~isin ~name ~lot_size in
    match valid with
    | Ok base -> Ok {
        base = base;
        custom = Equity { 
          instrument_type = Equity; 
          issue_date = issue_date; 
          unit_price = unit_price 
        }
      }
    | Error e -> Error e 


  let fixed_income ~isin ~name ~lot_size ~issue_maturity_date ~coupon_rate ~coupon_frequency = 
    let valid = validate_base ~isin ~name ~lot_size in
      match valid with
      | Ok base -> 
        let validcustom = validate_fixed_income FixedIncome issue_maturity_date coupon_rate coupon_frequency in
        (match validcustom with
        | Error e -> Error e
        | Ok _ -> Ok {
            base = base;
            custom = FixedIncome { 
              instrument_type = FixedIncome; 
              issue_maturity_date = issue_maturity_date; 
              coupon_rate = coupon_rate;
              coupon_frequency = coupon_frequency;
            }
        })
      | Error e -> Error e

  let get_instrument_type instrument = 
    match instrument.custom with
    | Ccy ccy -> ccy.instrument_type
    | Equity equity -> equity.instrument_type
    | FixedIncome fixed_income -> fixed_income.instrument_type

  let get_isin instrument = instrument.base.isin

  let get_name instrument = instrument.base.name

  let get_unit_price instrument = 
    match instrument.custom with
    | Ccy _ -> None
    | Equity equity -> Some equity.unit_price
    | FixedIncome _ -> None

  let get_lot_size instrument = instrument.base.lot_size

  let get_issue_maturity_date instrument = 
    match instrument.custom with
    | Ccy _ -> None
    | Equity equity -> Some (equity.issue_date, None)
    | FixedIncome fixed_income -> Some fixed_income.issue_maturity_date

  let get_coupon_rate instrument = 
    match instrument.custom with
    | Ccy _ -> None
    | Equity _ -> None
    | FixedIncome fixed_income -> Some fixed_income.coupon_rate

  let get_coupon_frequency instrument = 
    match instrument.custom with
    | Ccy _ -> None
    | Equity _ -> None
    | FixedIncome fixed_income -> Some fixed_income.coupon_frequency

end