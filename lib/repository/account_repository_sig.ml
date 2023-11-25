open Model
open Accountid
open Account

module type Account_Repository_sig = sig

  val query_by_no: Accountno.t -> Account.t option
  val query_all : (Account.t list, [> Caqti_error.call_or_retrieve ]) Lwt_result.t

end