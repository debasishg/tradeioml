module type ID = sig
  type t

  val to_string : t -> string
  val of_string : string -> t
  val ( = ) : t -> t -> bool

end

module String_id : ID = struct
  type t = string

  let to_string x = x
  let of_string x = x
  let ( = ) = String.equal

end