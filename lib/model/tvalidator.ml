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

  let date_precedes_check (date1: Calendar.t) (date2: Calendar.t option) = 
    match date2 with
    | None -> Some(date1)
    | Some date2 ->
    if date1 <= date2 then Some(date1) else None

  let date_precedes :
    Calendar.t option-> (Calendar.t, Calendar.t, 'err) validator_builder =
      fun d1 err d2 -> 
        custom (date_precedes_check d2) err d1

  let date_order_check (dates: (Calendar.t * Calendar.t option)) =
    match dates with
    | (d1, None) -> Some (d1, None)
    | (d1, Some d2) ->
      if d1 <= d2 then Some (d1, Some(d2)) else None

  let date_order :
    (Calendar.t * Calendar.t option, Calendar.t * Calendar.t option, 'err) validator_builder =
      fun err dates -> 
        custom date_order_check err dates

  let float_min_check (min : float) (value : float) =
    if value < min then
      None
    else
      Some value
      
  let float_min min = custom (float_min_check min)
end