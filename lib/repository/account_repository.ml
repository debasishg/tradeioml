open Model
open Account_repository_sig
open Schema
open Petrol
open Petrol.Postgres
open Common
open Account
open Accountid

module Account_Repository(Conn : Caqti_lwt.CONNECTION) : Account_Repository_sig = struct
  let query_by_no no = failwith "not implemented"

  let query_all =
      Query.select Expr.[no; name; account_type; date_of_open; trading_currency; settlement_currency] ~from:accounts
      |> Request.make_many
      |> Petrol.collect_list (module Conn)
      |> Lwt_result.map (List.map (fun (no, (name, (account_type, (date_of_open, (trading_currency, (settlement_currency, ())))))) ->

          let tno = Accountno.of_string_unsafe no in
          let tname = Accountname.of_string_unsafe name in
          let tcy = string_to_currency trading_currency in
          let scy = string_to_currency settlement_currency in
          let topen = CalendarLib.Calendar.from_unixfloat (Ptime.to_float_s date_of_open) in

          let valid = match account_type with
          | "Trading" -> 
                Account.create_trading_account 
                  ~no: tno 
                  ~name: tname 
                  ~trading_currency: tcy 
                  ~account_open_date: topen

          | "Settlement" -> 
                Account.create_settlement_account 
                  ~no: tno 
                  ~name: tname 
                  ~settlement_currency: scy 
                  ~account_open_date: topen

          | "Both" -> 
                Account.create_both_account 
                  ~no: tno 
                  ~name: tname 
                  ~trading_currency: tcy 
                  ~settlement_currency: scy 
                  ~account_open_date: topen

          | _ -> failwith "invalid account type" in
          match valid with
          | Ok v -> v
          | Error e -> match e with
          | (err, _) -> failwith err
      )) 

end 