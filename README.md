# Abstraction and Parametricity implementing domain models in OCaml

One of my favorite comments on abstraction and parametricity ..

> Parametricity can be thought of as the dual to abstraction. Where abstraction hides details about an implementation from the outside world, parametricity hides details about the outside world from an implementation.

When using OCaml as the implementation language, you abstract using **ADTs (Abstract Data Types)** and make your abstraction parametric using **functors**. And bind all of the algebras together using **Modules**. 

## Abstraction

In a domain model for trading systems, I have an ADT for the Trade model, specified by 

* A module that has a type, called its signature. With `Trade_sig` as the signature of the trade module, only the names mentioned in the signature are exported outside the module.

```ocaml
module type Trade_sig = sig
  (* names to be exported *)
end
```

* An implementation of the module type that remains completely hidden from the world outside the module. 

```ocaml
module Trade : Trade_sig = struct
  (* implementations *)
end
```

The above modules form the **abstraction** part in the quote above.

## Parametricity

One part in the trade model deals with the handling of tax and fees which varies with the market/country where the trade is made, while our trade model above needs to be generic across all markets. So the trade model has to *abstract over* the structure that implements the signature of the `TaxFee` module. Yes, we need to think in terms of modules for the tax/fee structure since they are the primary units of modularity that OCaml offers as first class values.

This is **parametricity** and in OCaml you do this with functors. Functors are nothing but functions from modules to modules. In our case we will have a functor that maps the TaxFee module to the Trade module.

First we define a module signature for `TaxFee`.

```ocaml
module type TaxFee = sig
  type t

  (* tax/fee rates for every tax/fee applicable for the market *)
  val tax_fee_rates : (t * float) list

  (* list of tax/fees applicable for the market *)
  val tax_fees : market -> t list
end
```

And then use this to define the functor for `Trade` 

```ocaml
module Trade(TaxFeeForMarket: TaxFee) : Trade_sig = struct
  (* implementations *)
end
```

This defines a functor that takes a `TaxFee` module and returns a `Trade` module. Note that it takes the signature of the `TaxFee` module which only publishes the basic interface and no implementation.

The complete implementation is [here](https://github.com/debasishg/tradeioml).