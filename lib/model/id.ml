open Validator

module type ID = sig
  type t

  val to_string : t -> string
  val of_string : string -> (t, string) validator_result
  val ( = ) : t -> t -> bool

end

module String_id : ID = struct
  type t = string

  let to_string x = x

  let of_string x = Ok x

  let ( = ) = String.equal

end