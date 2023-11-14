open Market

module type TaxFee = sig
  type t

  (* tax/fee rates for every tax/fee applicable for the market *)
  val tax_fee_rates : (t * float) list

  (* list of tax/fees applicable for the market *)
  val tax_fees : market -> t list
end