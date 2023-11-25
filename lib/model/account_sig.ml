open Common
open Accountid
open Validator

module type Account_sig = sig
  (* abstract types *)
  type t
  type account_no = Accountno.t
  type account_name = Accountname.t
  
  (* smart constructor to create a validated trading account *)
  val create_trading_account: 
    no: account_no -> name: account_name -> trading_currency: currency -> account_open_date: CalendarLib.Calendar.t -> (t, string) validator_result

  (* smart constructor to create a validated settlement account *)
  val create_settlement_account: 
    no: account_no -> name: account_name -> settlement_currency: currency -> account_open_date: CalendarLib.Calendar.t -> (t, string) validator_result
  
  (* smart constructor to create a validated trading and settlement account *)
  val create_both_account: 
    no: account_no -> name: account_name -> trading_currency: currency -> settlement_currency: currency -> account_open_date: CalendarLib.Calendar.t -> (t, string) validator_result
  
  (* close an account *)
  val close: account: t -> date_of_close: CalendarLib.Calendar.t -> (t, string) Result.t
  
  (* get the account type *)
  val get_account_type: t -> Common.account_type
  
  (* get the trading and settlement currency *)
  val get_trading_and_settlement_currency: t -> currency option * currency option
  
  (* get the account number *)
  val get_account_no: t -> account_no 
  
  (* get the account name *)
  val get_account_name: t -> account_name 
end