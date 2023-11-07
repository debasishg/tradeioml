open Base
open Id

(* Implementing newtypes for accounts *)
(* Use [of_string] constructor to construct a validated account no *)

(* account number and validation *)
module Accountno = struct
  include String_id

  let validate = 
    let open Validator in
    (string_has_max_length 12 "Too long")
    |> compose
      (string_has_min_length 3 "Too short")

  let of_string x = validate x

end

(* account name and validation *)
module Accountname = struct
  include String_id

  let validate = 
    let open Validator in
    string_is_not_empty "Empty"

  let of_string x = validate x

end