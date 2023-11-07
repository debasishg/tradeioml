type market = NewYork | Tokyo | HongKong | Singapore | Other 

let string_of_market = function
  | NewYork -> "NewYork"
  | Tokyo -> "Tokyo"
  | HongKong -> "HongKong"
  | Singapore -> "Singapore"
  | Other -> "Other"

let market_of_string = function
  | "NewYork" -> NewYork
  | "Tokyo" -> Tokyo
  | "HongKong" -> HongKong
  | "Singapore" -> Singapore
  | "Other" -> Other
  | _ -> failwith "market_of_string"