type t = Program.stmt * (Program.stmt list) * SStore.t * SCallstack.t * PathCondition.t

(*
type t = {
  stmt  : Program.stmt;
  cont  : Program.stmt list;
  store : SStore.t;
  cs    : SCallstack.t;
  pc    : PathCondition.t
}   
*)