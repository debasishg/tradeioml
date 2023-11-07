open Base 
open CalendarLib
open Calendar
open Accountid
open Account_sig
open Common

module Account : Account_sig = struct
  (* implementation of an account *)
  
  (* hidden implementation for the base parts of an account *)
  type account_base = {
    no: Accountno.t;
    name: Accountname.t;
    date_of_open: CalendarLib.Calendar.t;
    date_of_close: CalendarLib.Calendar.t option;
  }
  
  (* the abstract representation of the account *)
  type t = {
    base: account_base;
    account_type: Common.account_type;
  }
  
  (* the concrete representations of account no and account name *)
  (* hidden as part of the account representation *)
  type account_no = Accountno.t
  type account_name = Accountname.t

  let build_account_base no name date_of_open date_of_close = 
    {
      no;
      name;
      date_of_open;
      date_of_close
    }

  let validator_account_open_date =
    let open Tvalidator in
    TradingValidator.date_in_future "Cannot be in future"

  let validate_base ~no ~name ~account_open_date ~account_close_date = 
    let open Validator in
    let valid = build build_account_base
    |> keep no
    |> keep name
    |> validate account_open_date validator_account_open_date 
    |> keep account_close_date in
    match valid with
    | Ok base -> Ok base
    | Error e -> Error e

  let create_trading_account ~no ~name ~trading_currency ~account_open_date = 
    let valid = validate_base ~no ~name ~account_open_date ~account_close_date:None in
    match valid with
    | Ok base -> Ok { base; account_type = Trading trading_currency }
    | Error e -> Error e 

  let create_settlement_account ~no ~name ~settlement_currency ~account_open_date = 
    let valid = validate_base ~no ~name ~account_open_date ~account_close_date:None in
    match valid with
    | Ok base -> Ok { base; account_type = Settlement settlement_currency }
    | Error e -> Error e 
  
  let create_both_account ~no ~name ~trading_currency ~settlement_currency ~account_open_date = 
    let valid = validate_base ~no ~name ~account_open_date ~account_close_date:None in
    match valid with
    | Ok base -> Ok { base; account_type = Both (trading_currency, settlement_currency) }
    | Error e -> Error e 
  
  let validate_close ~account: t ~date_of_close = match t.base.date_of_close with 
    | Some _ -> Error "Account is already closed"
    | None ->  match compare t.base.date_of_open date_of_close with
      | 0 -> Error "Account open and close date cannot be the same"
      | 1 -> Error "Account open date cannot be after close date"
      | _ -> Ok t
  
  let close ~account: t ~date_of_close =
    let open Result in
    validate_close ~account: t ~date_of_close >>= fun _ ->
    Ok { 
      t with base = { 
        t.base with date_of_close = Some date_of_close 
      } 
    }

  let get_account_type t = t.account_type
  
  let get_account_no t = t.base.no 
  
  let get_account_name t = t.base.name 
  
  let get_trading_and_settlement_currency = function
    | { base = _ ; account_type = Trading trading_currency } -> (Some trading_currency, None)
    | { base = _ ; account_type = Settlement settlement_currency } -> (None, Some settlement_currency)
    | { base = _ ; account_type = Both (trading_currency, settlement_currency) } -> (Some trading_currency, Some settlement_currency)
end  