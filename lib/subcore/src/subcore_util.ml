(* auto-generated by gt *)

let fname = ref (
   if Array.length(Sys.argv) > 1 then Sys.argv.(1) 
   else "<stdin>"
);;

let line = ref 1;;
type pd = int * string;;
let string_of_pos (p:pd) = " on line "^(string_of_int (fst p))^" in file "^(snd p);;
let cur_pd():pd = (!line,!fname);; (* "pd": pos *) 
