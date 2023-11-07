(* some sample currencies for the time being *)
type currency = USD | JPY | INR | GBP

(* account_type will be trading, settlement or both *)
type account_type = 
  | Trading of currency           (* with trading currency *)
  | Settlement of currency        (* with settlement currency *)
  | Both of currency * currency   (* with trading and settlement currency *)
