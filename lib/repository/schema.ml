open Petrol
open Petrol.Postgres

(* define a new schema *)
let schema = StaticSchema.init ()

(* declare a table *)
let accounts, Expr.[no; name; account_type; date_of_open; date_of_close; base_currency; trading_currency; settlement_currency] =
    StaticSchema.declare_table schema ~name:"trading"
    Schema.[
        field ~constraints:[primary_key ()] "no" ~ty:Type.text;
        field ~constraints:[not_null ()] "name" ~ty:Type.text;
        field ~constraints:[not_null ()] "account_type" ~ty:Type.text;
        field ~constraints:[not_null ()] "date_of_open" ~ty:Type.date;
        field "date_of_close" ~ty:Type.date;
        field ~constraints:[not_null ()] "base_currency" ~ty:Type.text;
        field "trading_currency" ~ty:Type.text;
        field "settlement_currency" ~ty:Type.text;
    ]

let collect_all db =
    Query.select Expr.[no; name] ~from:accounts
    |> Request.make_many
    |> Petrol.collect_list db
    |> Lwt_result.map (List.map (fun (id, (text, ())) ->
        (id,text)
    ))