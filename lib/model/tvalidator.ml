open CalendarLib

module TradingValidator = struct
  include Validator
  
  type ('input, 'output) check = 'input -> 'output option
  
  let custom
    (check : ('i, 'o) check)
    (error : 'e)
    (input : 'i) =
    match check input with
    | Some output ->
        Ok output
    | None ->
        Error (error, [ error ])
  
  let string_is_isin_check value =
    let re = Str.regexp "([A-Z]{2})((?![A-Z]{10}\b)[A-Z0-9]{10})" in
    let mtch = Str.string_match re value 0 in
    if mtch then Some value else None
  
  let string_is_isin :
    (string, string, 'err) validator_builder =
      fun err -> custom string_is_isin_check err

  let date_in_future_check value =
    let now = CalendarLib.Calendar.now () in
    if value <= now then Some value else None

  let date_in_future :
    (Calendar.t, Calendar.t, 'err) validator_builder =
      fun err -> custom date_in_future_check err
end