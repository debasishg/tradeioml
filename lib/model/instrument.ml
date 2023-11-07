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

  type instrument_base = {
    isin: ISINCode.t;
    name: Instrumentname.t;
    lot_size: lot_size;
  }

  module Ccy = struct
    type t = {
      base: instrument_base;
      instrument_type: instrument_type;
    }
  end

  module Equity = struct
    type t = {
      base: instrument_base;
      instrument_type: instrument_type;
      issue_date: CalendarLib.Calendar.t;
      unit_price: unit_price;
    }
  end

  module FixedIncome = struct
    type t = {
      base: instrument_base;
      instrument_type: instrument_type;
      issue_date: CalendarLib.Calendar.t;
      maturity_date: CalendarLib.Calendar.t option;
      coupon_rate: coupon_rate;
      coupon_frequency: coupon_frequency;
    }
  end

  type t = 
    | Ccy of Ccy.t
    | Equity of Equity.t
    | FixedIncome of FixedIncome.t

  let build_instrument_base isin name lot_size = {
    isin;
    name;
    lot_size;
  }

  let validate_base ~isin ~name ~lot_size = 
    let open Validator in
    let valid = build build_instrument_base 
    |> keep isin
    |> keep name
    |> keep lot_size in
    match valid with
    | Ok base -> Ok base
    | Error e -> Error e

  let ccy ~isin ~name = 
    let valid = validate_base ~isin ~name ~lot_size: 1 in
    match valid with
    | Ok base -> Ok (Ccy { base = base; instrument_type = CCY })
    | Error e -> Error e 


  let equity ~isin ~name ~lot_size ~unit_price ~issue_date = 
    let valid = validate_base ~isin ~name ~lot_size in
    match valid with
    | Ok base -> Ok (
        Equity { 
          base = base; 
          instrument_type = Equity; 
          issue_date = issue_date; 
          unit_price = unit_price 
        }
      )
    | Error e -> Error e 


  let fixed_income ~isin ~name ~lot_size ~issue_date ~maturity_date ~coupon_rate ~coupon_frequency = 
    let valid = validate_base ~isin ~name ~lot_size in
    match valid with
    | Ok base -> Ok (
        FixedIncome { 
          base = base; 
          instrument_type = FixedIncome; 
          issue_date = issue_date; 
          maturity_date = maturity_date;
          coupon_rate = coupon_rate;
          coupon_frequency = coupon_frequency;
        }
      )
    | Error e -> Error e 

  let get_instrument_type = function
    | Ccy _ -> CCY
    | Equity _ -> Equity
    | FixedIncome _ -> FixedIncome

  let get_isin = function
    | Ccy ccy -> ccy.base.isin
    | Equity equity -> equity.base.isin
    | FixedIncome fixed_income -> fixed_income.base.isin

  let get_name = function
    | Ccy ccy -> ccy.base.name
    | Equity equity -> equity.base.name
    | FixedIncome fixed_income -> fixed_income.base.name

end