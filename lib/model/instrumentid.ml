open Base
open Id

(* ISIN code and validation *)
module ISINCode = struct
  include String_id

  let validate = 
    let open Validator in
    let open Tvalidator in
    (string_has_max_length 12 "Too long")
    |> compose
      (string_has_min_length 12 "Too short")
    |> compose
      (TradingValidator.string_is_isin "Invalid isin")

  let of_string x = validate x
end

(* instrument name and validation *)
module Instrumentname = struct
  include String_id

  let validate = 
    let open Validator in
    string_is_not_empty "Empty"

  let of_string x = validate x
end