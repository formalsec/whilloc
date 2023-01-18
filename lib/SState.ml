type t = Program.stmt * (Program.stmt list) * SStore.t * SCallstack.t * PathCondition.t

(*
type t = {
  stmt  : Program.stmt;
  cont  : Program.stmt list;
  store : SStore.t;
  cs    : SCallstack.t;
  pc    : PathCondition.t;
}
{stmt=next_statement; cont=cont'; store=store; cs=cs; pc=pc}
*)

let string_of_sstate (state : t) : string =
  let stmt,cont,store,_,pc = state in
  Printf.sprintf "#Statement:\n   %s\n#Continuation:\n   %s\n#Store:\n   %s\n#Callstack:\n   %s\n#PathCondition:\n   %s\n"
                (Program.string_of_stmt stmt) (String.concat "\n" (List.map Program.string_of_stmt cont)) (SStore.string_of_store store) ("callstackTODO") 
                (PathCondition.string_of_pathcondition pc)