type path_condition = Expression.expr list

type t = SStore.t * (Program.stmt list) * Callstack.t * path_condition
