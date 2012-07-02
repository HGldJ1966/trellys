(* auto-generated by gt *)

open Subcore_syntax;;

let cur_line = ref 1;;
let del = ref 0;;
let rec print_new_line (os:string->unit) (do_print:bool) (p:int) : unit =
   if(p > !cur_line && do_print) then ( 
      os "\n"; 
      incr cur_line;
      print_new_line os do_print p;
   );;


let rec dummy () = ()
and gviz_terminal (os:string->unit) (to_pretty_print:bool) (cons:string) = function
   (d,str1) -> 
      print_new_line os to_pretty_print (fst d); let str1 = let st = ref "" in 
      String.iter(fun s -> if(s = '"') then( st := ((!st)^"\\"^(Char.escaped s)))
      else (st := ((!st)^(Char.escaped s)))) str1; !st in os str1

and gviz_binding (os:string->unit) (to_pretty_print:bool) (cons:string) = function 
   |Binding (d , str1 , pd2 , oterm3 , pd4 , oterm5) -> let del' = !del in incr del; let _ = del' in os "Binding"; os (string_of_int del');  os ";\n"; os "Binding"; os (string_of_int del'); os "[label=\""; os "Binding"; os "\"];\n"; os "Binding"; os (string_of_int del');  os " -- "; os "Binding"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Binding"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  gviz_terminal os to_pretty_print (cons) str1; os "\"];\n"; os "Binding"; os (string_of_int del'); os "[label=\""; os "Binding"; os "\"];\n"; os "Binding"; os (string_of_int del');  os " -- "; os "Binding"; os (string_of_int del');  os (string_of_int del'); os "_med1;\n";os "Binding"; os (string_of_int del');  os (string_of_int del'); os "_med1[label=\"";  os ":"; os "\"];\n"; os "Binding"; os (string_of_int del'); os "[label=\""; os "Binding"; os "\"];\n"; os "Binding"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm3; os "Binding"; os (string_of_int del'); os "[label=\""; os "Binding"; os "\"];\n"; os "Binding"; os (string_of_int del');  os " -- "; os "Binding"; os (string_of_int del');  os (string_of_int del'); os "_med2;\n";os "Binding"; os (string_of_int del');  os (string_of_int del'); os "_med2[label=\"";  os "="; os "\"];\n"; os "Binding"; os (string_of_int del'); os "[label=\""; os "Binding"; os "\"];\n"; os "Binding"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm5;  () 

and gviz_cmd (os:string->unit) (to_pretty_print:bool) (cons:string) = function 
   |Def (d , pd1 , str2 , pd3 , oterm4 , pd5 , oterm6) -> let del' = !del in incr del; let _ = del' in os "Def"; os (string_of_int del');  os ";\n"; os "Def"; os (string_of_int del'); os "[label=\""; os "Def"; os "\"];\n"; os "Def"; os (string_of_int del');  os " -- "; os "Def"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Def"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "Define"; os "\"];\n"; os "Def"; os (string_of_int del'); os "[label=\""; os "Def"; os "\"];\n"; os "Def"; os (string_of_int del');  os " -- "; os "Def"; os (string_of_int del');  os (string_of_int del'); os "_med1;\n";os "Def"; os (string_of_int del');  os (string_of_int del'); os "_med1[label=\"";  gviz_terminal os to_pretty_print (cons) str2; os "\"];\n"; os "Def"; os (string_of_int del'); os "[label=\""; os "Def"; os "\"];\n"; os "Def"; os (string_of_int del');  os " -- "; os "Def"; os (string_of_int del');  os (string_of_int del'); os "_med2;\n";os "Def"; os (string_of_int del');  os (string_of_int del'); os "_med2[label=\"";  os ":"; os "\"];\n"; os "Def"; os (string_of_int del'); os "[label=\""; os "Def"; os "\"];\n"; os "Def"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm4; os "Def"; os (string_of_int del'); os "[label=\""; os "Def"; os "\"];\n"; os "Def"; os (string_of_int del');  os " -- "; os "Def"; os (string_of_int del');  os (string_of_int del'); os "_med3;\n";os "Def"; os (string_of_int del');  os (string_of_int del'); os "_med3[label=\"";  os "="; os "\"];\n"; os "Def"; os (string_of_int del'); os "[label=\""; os "Def"; os "\"];\n"; os "Def"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm6;  () 
   |SetFlag (d , pd1 , str2) -> let del' = !del in incr del; let _ = del' in os "SetFlag"; os (string_of_int del');  os ";\n"; os "SetFlag"; os (string_of_int del'); os "[label=\""; os "SetFlag"; os "\"];\n"; os "SetFlag"; os (string_of_int del');  os " -- "; os "SetFlag"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "SetFlag"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "Set"; os "\"];\n"; os "SetFlag"; os (string_of_int del'); os "[label=\""; os "SetFlag"; os "\"];\n"; os "SetFlag"; os (string_of_int del');  os " -- "; os "SetFlag"; os (string_of_int del');  os (string_of_int del'); os "_med1;\n";os "SetFlag"; os (string_of_int del');  os (string_of_int del'); os "_med1[label=\"";  gviz_terminal os to_pretty_print (cons) str2; os "\"];\n";  () 
   |UnsetFlag (d , pd1 , str2) -> let del' = !del in incr del; let _ = del' in os "UnsetFlag"; os (string_of_int del');  os ";\n"; os "UnsetFlag"; os (string_of_int del'); os "[label=\""; os "UnsetFlag"; os "\"];\n"; os "UnsetFlag"; os (string_of_int del');  os " -- "; os "UnsetFlag"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "UnsetFlag"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "Unset"; os "\"];\n"; os "UnsetFlag"; os (string_of_int del'); os "[label=\""; os "UnsetFlag"; os "\"];\n"; os "UnsetFlag"; os (string_of_int del');  os " -- "; os "UnsetFlag"; os (string_of_int del');  os (string_of_int del'); os "_med1;\n";os "UnsetFlag"; os (string_of_int del');  os (string_of_int del'); os "_med1[label=\"";  gviz_terminal os to_pretty_print (cons) str2; os "\"];\n";  () 
   |EvalCmd (d , pd1 , oterm2) -> let del' = !del in incr del; let _ = del' in os "EvalCmd"; os (string_of_int del');  os ";\n"; os "EvalCmd"; os (string_of_int del'); os "[label=\""; os "EvalCmd"; os "\"];\n"; os "EvalCmd"; os (string_of_int del');  os " -- "; os "EvalCmd"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "EvalCmd"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "Eval"; os "\"];\n"; os "EvalCmd"; os (string_of_int del'); os "[label=\""; os "EvalCmd"; os "\"];\n"; os "EvalCmd"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm2;  () 
   |FixCmd (d , pd1 , binding2 , fixcmd_cmd_comma03) -> let del' = !del in incr del; let _ = del' in os "FixCmd"; os (string_of_int del');  os ";\n"; os "FixCmd"; os (string_of_int del'); os "[label=\""; os "FixCmd"; os "\"];\n"; os "FixCmd"; os (string_of_int del');  os " -- "; os "FixCmd"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "FixCmd"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "Fix"; os "\"];\n"; os "FixCmd"; os (string_of_int del'); os "[label=\""; os "FixCmd"; os "\"];\n"; os "FixCmd"; os (string_of_int del');  os " -- ";gviz_binding os to_pretty_print (cons) binding2; os "FixCmd"; os (string_of_int del'); os "[label=\""; os "FixCmd"; os "\"];\n"; os "FixCmd"; os (string_of_int del');  os " -- ";gviz_fixcmd_cmd_comma0 os to_pretty_print ("FixCmd"^(string_of_int del')) fixcmd_cmd_comma03;  () 

and gviz_oterm (os:string->unit) (to_pretty_print:bool) (cons:string) = function 
   |Lam (d , pd1 , str2 , pd3 , oterm4 , pd5 , oterm6) -> let del' = !del in incr del; let _ = del' in os "Lam"; os (string_of_int del');  os ";\n"; os "Lam"; os (string_of_int del'); os "[label=\""; os "Lam"; os "\"];\n"; os "Lam"; os (string_of_int del');  os " -- "; os "Lam"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Lam"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "\\"; os "\"];\n"; os "Lam"; os (string_of_int del'); os "[label=\""; os "Lam"; os "\"];\n"; os "Lam"; os (string_of_int del');  os " -- "; os "Lam"; os (string_of_int del');  os (string_of_int del'); os "_med1;\n";os "Lam"; os (string_of_int del');  os (string_of_int del'); os "_med1[label=\"";  gviz_terminal os to_pretty_print (cons) str2; os "\"];\n"; os "Lam"; os (string_of_int del'); os "[label=\""; os "Lam"; os "\"];\n"; os "Lam"; os (string_of_int del');  os " -- "; os "Lam"; os (string_of_int del');  os (string_of_int del'); os "_med2;\n";os "Lam"; os (string_of_int del');  os (string_of_int del'); os "_med2[label=\"";  os ":"; os "\"];\n"; os "Lam"; os (string_of_int del'); os "[label=\""; os "Lam"; os "\"];\n"; os "Lam"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm4; os "Lam"; os (string_of_int del'); os "[label=\""; os "Lam"; os "\"];\n"; os "Lam"; os (string_of_int del');  os " -- "; os "Lam"; os (string_of_int del');  os (string_of_int del'); os "_med3;\n";os "Lam"; os (string_of_int del');  os (string_of_int del'); os "_med3[label=\"";  os "."; os "\"];\n"; os "Lam"; os (string_of_int del'); os "[label=\""; os "Lam"; os "\"];\n"; os "Lam"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm6;  () 
   |Self (d , pd1 , str2 , pd3 , oterm4) -> let del' = !del in incr del; let _ = del' in os "Self"; os (string_of_int del');  os ";\n"; os "Self"; os (string_of_int del'); os "[label=\""; os "Self"; os "\"];\n"; os "Self"; os (string_of_int del');  os " -- "; os "Self"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Self"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "self"; os "\"];\n"; os "Self"; os (string_of_int del'); os "[label=\""; os "Self"; os "\"];\n"; os "Self"; os (string_of_int del');  os " -- "; os "Self"; os (string_of_int del');  os (string_of_int del'); os "_med1;\n";os "Self"; os (string_of_int del');  os (string_of_int del'); os "_med1[label=\"";  gviz_terminal os to_pretty_print (cons) str2; os "\"];\n"; os "Self"; os (string_of_int del'); os "[label=\""; os "Self"; os "\"];\n"; os "Self"; os (string_of_int del');  os " -- "; os "Self"; os (string_of_int del');  os (string_of_int del'); os "_med2;\n";os "Self"; os (string_of_int del');  os (string_of_int del'); os "_med2[label=\"";  os "."; os "\"];\n"; os "Self"; os (string_of_int del'); os "[label=\""; os "Self"; os "\"];\n"; os "Self"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm4;  () 
   |Fix (d , pd1 , binding2 , fix_oterm_comma13 , pd4 , oterm5) -> let del' = !del in incr del; let _ = del' in os "Fix"; os (string_of_int del');  os ";\n"; os "Fix"; os (string_of_int del'); os "[label=\""; os "Fix"; os "\"];\n"; os "Fix"; os (string_of_int del');  os " -- "; os "Fix"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Fix"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "fix"; os "\"];\n"; os "Fix"; os (string_of_int del'); os "[label=\""; os "Fix"; os "\"];\n"; os "Fix"; os (string_of_int del');  os " -- ";gviz_binding os to_pretty_print (cons) binding2; os "Fix"; os (string_of_int del'); os "[label=\""; os "Fix"; os "\"];\n"; os "Fix"; os (string_of_int del');  os " -- ";gviz_fix_oterm_comma1 os to_pretty_print ("Fix"^(string_of_int del')) fix_oterm_comma13; os "Fix"; os (string_of_int del'); os "[label=\""; os "Fix"; os "\"];\n"; os "Fix"; os (string_of_int del');  os " -- "; os "Fix"; os (string_of_int del');  os (string_of_int del'); os "_med1;\n";os "Fix"; os (string_of_int del');  os (string_of_int del'); os "_med1[label=\"";  os "in"; os "\"];\n"; os "Fix"; os (string_of_int del'); os "[label=\""; os "Fix"; os "\"];\n"; os "Fix"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm5;  () 
   |Arrow (d , term1 , pd2 , oterm3) -> let del' = !del in incr del; let _ = del' in os "Arrow"; os (string_of_int del');  os ";\n"; os "Arrow"; os (string_of_int del'); os "[label=\""; os "Arrow"; os "\"];\n"; os "Arrow"; os (string_of_int del');  os " -- ";gviz_term os to_pretty_print (cons) term1; os "Arrow"; os (string_of_int del'); os "[label=\""; os "Arrow"; os "\"];\n"; os "Arrow"; os (string_of_int del');  os " -- "; os "Arrow"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Arrow"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "->"; os "\"];\n"; os "Arrow"; os (string_of_int del'); os "[label=\""; os "Arrow"; os "\"];\n"; os "Arrow"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm3;  () 
   |Pi (d , pd1 , str2 , pd3 , term4 , pd5 , oterm6) -> let del' = !del in incr del; let _ = del' in os "Pi"; os (string_of_int del');  os ";\n"; os "Pi"; os (string_of_int del'); os "[label=\""; os "Pi"; os "\"];\n"; os "Pi"; os (string_of_int del');  os " -- "; os "Pi"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Pi"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "!"; os "\"];\n"; os "Pi"; os (string_of_int del'); os "[label=\""; os "Pi"; os "\"];\n"; os "Pi"; os (string_of_int del');  os " -- "; os "Pi"; os (string_of_int del');  os (string_of_int del'); os "_med1;\n";os "Pi"; os (string_of_int del');  os (string_of_int del'); os "_med1[label=\"";  gviz_terminal os to_pretty_print (cons) str2; os "\"];\n"; os "Pi"; os (string_of_int del'); os "[label=\""; os "Pi"; os "\"];\n"; os "Pi"; os (string_of_int del');  os " -- "; os "Pi"; os (string_of_int del');  os (string_of_int del'); os "_med2;\n";os "Pi"; os (string_of_int del');  os (string_of_int del'); os "_med2[label=\"";  os ":"; os "\"];\n"; os "Pi"; os (string_of_int del'); os "[label=\""; os "Pi"; os "\"];\n"; os "Pi"; os (string_of_int del');  os " -- ";gviz_term os to_pretty_print (cons) term4; os "Pi"; os (string_of_int del'); os "[label=\""; os "Pi"; os "\"];\n"; os "Pi"; os (string_of_int del');  os " -- "; os "Pi"; os (string_of_int del');  os (string_of_int del'); os "_med3;\n";os "Pi"; os (string_of_int del');  os (string_of_int del'); os "_med3[label=\"";  os "."; os "\"];\n"; os "Pi"; os (string_of_int del'); os "[label=\""; os "Pi"; os "\"];\n"; os "Pi"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm6;  () 
   |Check (d , term1 , pd2 , oterm3) -> let del' = !del in incr del; let _ = del' in os "Check"; os (string_of_int del');  os ";\n"; os "Check"; os (string_of_int del'); os "[label=\""; os "Check"; os "\"];\n"; os "Check"; os (string_of_int del');  os " -- ";gviz_term os to_pretty_print (cons) term1; os "Check"; os (string_of_int del'); os "[label=\""; os "Check"; os "\"];\n"; os "Check"; os (string_of_int del');  os " -- "; os "Check"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Check"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os ":"; os "\"];\n"; os "Check"; os (string_of_int del'); os "[label=\""; os "Check"; os "\"];\n"; os "Check"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm3;  () 
   |Term (d , term1) -> let del' = !del in incr del; let _ = del' in os "Term"; os (string_of_int del');  os ";\n"; os "Term"; os (string_of_int del'); os "[label=\""; os "Term"; os "\"];\n"; os "Term"; os (string_of_int del');  os " -- ";gviz_term os to_pretty_print (cons) term1;  () 

and gviz_prog (os:string->unit) (to_pretty_print:bool) (cons:string) = function 
   |Prog (d , prog_prog_cmd21) -> let del' = !del in incr del; let _ = del' in os "Prog"; os (string_of_int del');  os ";\n"; os "Prog"; os (string_of_int del'); os "[label=\""; os "Prog"; os "\"];\n"; os "Prog"; os (string_of_int del');  os " -- ";gviz_prog_prog_cmd2 os to_pretty_print ("Prog"^(string_of_int del')) prog_prog_cmd21;  () 

and gviz_term (os:string->unit) (to_pretty_print:bool) (cons:string) = function 
   |App (d , pd1 , term2 , app_term_term33 , pd4) -> let del' = !del in incr del; let _ = del' in os "App"; os (string_of_int del');  os ";\n"; os "App"; os (string_of_int del'); os "[label=\""; os "App"; os "\"];\n"; os "App"; os (string_of_int del');  os " -- "; os "App"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "App"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "("; os "\"];\n"; os "App"; os (string_of_int del'); os "[label=\""; os "App"; os "\"];\n"; os "App"; os (string_of_int del');  os " -- ";gviz_term os to_pretty_print (cons) term2; os "App"; os (string_of_int del'); os "[label=\""; os "App"; os "\"];\n"; os "App"; os (string_of_int del');  os " -- ";gviz_app_term_term3 os to_pretty_print ("App"^(string_of_int del')) app_term_term33; os "App"; os (string_of_int del'); os "[label=\""; os "App"; os "\"];\n"; os "App"; os (string_of_int del');  os " -- "; os "App"; os (string_of_int del');  os (string_of_int del'); os "_med1;\n";os "App"; os (string_of_int del');  os (string_of_int del'); os "_med1[label=\"";  os ")"; os "\"];\n";  () 
   |Star (d , pd1) -> let del' = !del in incr del; let _ = del' in os "Star"; os (string_of_int del');  os ";\n"; os "Star"; os (string_of_int del'); os "[label=\""; os "Star"; os "\"];\n"; os "Star"; os (string_of_int del');  os " -- "; os "Star"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Star"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "*"; os "\"];\n";  () 
   |Var (d , str1) -> let del' = !del in incr del; let _ = del' in os "Var"; os (string_of_int del');  os ";\n"; os "Var"; os (string_of_int del'); os "[label=\""; os "Var"; os "\"];\n"; os "Var"; os (string_of_int del');  os " -- "; os "Var"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Var"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  gviz_terminal os to_pretty_print (cons) str1; os "\"];\n";  () 
   |Conv (d , pd1 , oterm2 , pd3 , oterm4 , pd5 , term6 , pd7 , term8) -> let del' = !del in incr del; let _ = del' in os "Conv"; os (string_of_int del');  os ";\n"; os "Conv"; os (string_of_int del'); os "[label=\""; os "Conv"; os "\"];\n"; os "Conv"; os (string_of_int del');  os " -- "; os "Conv"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Conv"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "conv"; os "\"];\n"; os "Conv"; os (string_of_int del'); os "[label=\""; os "Conv"; os "\"];\n"; os "Conv"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm2; os "Conv"; os (string_of_int del'); os "[label=\""; os "Conv"; os "\"];\n"; os "Conv"; os (string_of_int del');  os " -- "; os "Conv"; os (string_of_int del');  os (string_of_int del'); os "_med1;\n";os "Conv"; os (string_of_int del');  os (string_of_int del'); os "_med1[label=\"";  os "to"; os "\"];\n"; os "Conv"; os (string_of_int del'); os "[label=\""; os "Conv"; os "\"];\n"; os "Conv"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm4; os "Conv"; os (string_of_int del'); os "[label=\""; os "Conv"; os "\"];\n"; os "Conv"; os (string_of_int del');  os " -- "; os "Conv"; os (string_of_int del');  os (string_of_int del'); os "_med2;\n";os "Conv"; os (string_of_int del');  os (string_of_int del'); os "_med2[label=\"";  os "by"; os "\"];\n"; os "Conv"; os (string_of_int del'); os "[label=\""; os "Conv"; os "\"];\n"; os "Conv"; os (string_of_int del');  os " -- ";gviz_term os to_pretty_print (cons) term6; os "Conv"; os (string_of_int del'); os "[label=\""; os "Conv"; os "\"];\n"; os "Conv"; os (string_of_int del');  os " -- "; os "Conv"; os (string_of_int del');  os (string_of_int del'); os "_med3;\n";os "Conv"; os (string_of_int del');  os (string_of_int del'); os "_med3[label=\"";  os ","; os "\"];\n"; os "Conv"; os (string_of_int del'); os "[label=\""; os "Conv"; os "\"];\n"; os "Conv"; os (string_of_int del');  os " -- ";gviz_term os to_pretty_print (cons) term8;  () 
   |Trans (d , pd1 , oterm2 , trans_term_semi43 , pd4) -> let del' = !del in incr del; let _ = del' in os "Trans"; os (string_of_int del');  os ";\n"; os "Trans"; os (string_of_int del'); os "[label=\""; os "Trans"; os "\"];\n"; os "Trans"; os (string_of_int del');  os " -- "; os "Trans"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Trans"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "["; os "\"];\n"; os "Trans"; os (string_of_int del'); os "[label=\""; os "Trans"; os "\"];\n"; os "Trans"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm2; os "Trans"; os (string_of_int del'); os "[label=\""; os "Trans"; os "\"];\n"; os "Trans"; os (string_of_int del');  os " -- ";gviz_trans_term_semi4 os to_pretty_print ("Trans"^(string_of_int del')) trans_term_semi43; os "Trans"; os (string_of_int del'); os "[label=\""; os "Trans"; os "\"];\n"; os "Trans"; os (string_of_int del');  os " -- "; os "Trans"; os (string_of_int del');  os (string_of_int del'); os "_med1;\n";os "Trans"; os (string_of_int del');  os (string_of_int del'); os "_med1[label=\"";  os "]"; os "\"];\n";  () 
   |Parens (d , pd1 , oterm2 , pd3) -> let del' = !del in incr del; let _ = del' in os "Parens"; os (string_of_int del');  os ";\n"; os "Parens"; os (string_of_int del'); os "[label=\""; os "Parens"; os "\"];\n"; os "Parens"; os (string_of_int del');  os " -- "; os "Parens"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Parens"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "("; os "\"];\n"; os "Parens"; os (string_of_int del'); os "[label=\""; os "Parens"; os "\"];\n"; os "Parens"; os (string_of_int del');  os " -- ";gviz_oterm os to_pretty_print (cons) oterm2; os "Parens"; os (string_of_int del'); os "[label=\""; os "Parens"; os "\"];\n"; os "Parens"; os (string_of_int del');  os " -- "; os "Parens"; os (string_of_int del');  os (string_of_int del'); os "_med1;\n";os "Parens"; os (string_of_int del');  os (string_of_int del'); os "_med1[label=\"";  os ")"; os "\"];\n";  () 
   |Substself (d , pd1) -> let del' = !del in incr del; let _ = del' in os "Substself"; os (string_of_int del');  os ";\n"; os "Substself"; os (string_of_int del'); os "[label=\""; os "Substself"; os "\"];\n"; os "Substself"; os (string_of_int del');  os " -- "; os "Substself"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Substself"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "substself"; os "\"];\n";  () 
   |Unfold (d , pd1) -> let del' = !del in incr del; let _ = del' in os "Unfold"; os (string_of_int del');  os ";\n"; os "Unfold"; os (string_of_int del'); os "[label=\""; os "Unfold"; os "\"];\n"; os "Unfold"; os (string_of_int del');  os " -- "; os "Unfold"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Unfold"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "unfold"; os "\"];\n";  () 
   |Eval (d , pd1) -> let del' = !del in incr del; let _ = del' in os "Eval"; os (string_of_int del');  os ";\n"; os "Eval"; os (string_of_int del'); os "[label=\""; os "Eval"; os "\"];\n"; os "Eval"; os (string_of_int del');  os " -- "; os "Eval"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Eval"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "eval"; os "\"];\n";  () 
   |Refl (d , pd1) -> let del' = !del in incr del; let _ = del' in os "Refl"; os (string_of_int del');  os ";\n"; os "Refl"; os (string_of_int del'); os "[label=\""; os "Refl"; os "\"];\n"; os "Refl"; os (string_of_int del');  os " -- "; os "Refl"; os (string_of_int del');  os (string_of_int del'); os "_med0;\n";os "Refl"; os (string_of_int del');  os (string_of_int del'); os "_med0[label=\"";  os "refl"; os "\"];\n";  () 

and gviz_trans_term_semi4 (os:string->unit) (to_pretty_print:bool) (cons:string) = function 
   | (d,[]) -> let del' = !del in incr del; let _ = del' in os cons;  os (string_of_int del'); os "_med0;\n"; os cons;  os (string_of_int del'); os "_med0[label=\"[]\"];\n";  () 
   | (d , (pd1 , oterm2)::trans_term_semi43) -> let del' = !del in incr del; let _ = del' in  os ";\n"; os cons; os "[label=\""; os cons; os "\"];\n"; os cons;  os " -- "; os cons;  os (string_of_int del'); os "_med0;\n";os cons;  os (string_of_int del'); os "_med0[label=\"";  os ";"; os "\"];\n"; os cons; os "[label=\""; os cons; os "\"];\n"; os cons;  os " -- ";gviz_oterm os to_pretty_print (cons) oterm2; os cons; os "[label=\""; os cons; os "\"];\n"; os cons;  os " -- ";gviz_trans_term_semi4 os to_pretty_print (cons)  (d,trans_term_semi43) ;  () 

and gviz_app_term_term3 (os:string->unit) (to_pretty_print:bool) (cons:string) = function 
   | (d,[]) -> let del' = !del in incr del; let _ = del' in os cons;  os (string_of_int del'); os "_med0;\n"; os cons;  os (string_of_int del'); os "_med0[label=\"[]\"];\n";  () 
   | (d , (term1)::app_term_term32) -> let del' = !del in incr del; let _ = del' in gviz_term os to_pretty_print (cons) term1; os cons; os "[label=\""; os cons; os "\"];\n"; os cons;  os " -- ";gviz_app_term_term3 os to_pretty_print (cons)  (d,app_term_term32) ;  () 

and gviz_prog_prog_cmd2 (os:string->unit) (to_pretty_print:bool) (cons:string) = function 
   | (d,[]) -> let del' = !del in incr del; let _ = del' in os cons;  os (string_of_int del'); os "_med0;\n"; os cons;  os (string_of_int del'); os "_med0[label=\"[]\"];\n";  () 
   | (d , (cmd1)::prog_prog_cmd22) -> let del' = !del in incr del; let _ = del' in gviz_cmd os to_pretty_print (cons) cmd1; os cons; os "[label=\""; os cons; os "\"];\n"; os cons;  os " -- ";gviz_prog_prog_cmd2 os to_pretty_print (cons)  (d,prog_prog_cmd22) ;  () 

and gviz_fix_oterm_comma1 (os:string->unit) (to_pretty_print:bool) (cons:string) = function 
   | (d,[]) -> let del' = !del in incr del; let _ = del' in os cons;  os (string_of_int del'); os "_med0;\n"; os cons;  os (string_of_int del'); os "_med0[label=\"[]\"];\n";  () 
   | (d , (pd1 , binding2)::fix_oterm_comma13) -> let del' = !del in incr del; let _ = del' in  os ";\n"; os cons; os "[label=\""; os cons; os "\"];\n"; os cons;  os " -- "; os cons;  os (string_of_int del'); os "_med0;\n";os cons;  os (string_of_int del'); os "_med0[label=\"";  os ","; os "\"];\n"; os cons; os "[label=\""; os cons; os "\"];\n"; os cons;  os " -- ";gviz_binding os to_pretty_print (cons) binding2; os cons; os "[label=\""; os cons; os "\"];\n"; os cons;  os " -- ";gviz_fix_oterm_comma1 os to_pretty_print (cons)  (d,fix_oterm_comma13) ;  () 

and gviz_fixcmd_cmd_comma0 (os:string->unit) (to_pretty_print:bool) (cons:string) = function 
   | (d,[]) -> let del' = !del in incr del; let _ = del' in os cons;  os (string_of_int del'); os "_med0;\n"; os cons;  os (string_of_int del'); os "_med0[label=\"[]\"];\n";  () 
   | (d , (pd1 , binding2)::fixcmd_cmd_comma03) -> let del' = !del in incr del; let _ = del' in  os ";\n"; os cons; os "[label=\""; os cons; os "\"];\n"; os cons;  os " -- "; os cons;  os (string_of_int del'); os "_med0;\n";os cons;  os (string_of_int del'); os "_med0[label=\"";  os ","; os "\"];\n"; os cons; os "[label=\""; os cons; os "\"];\n"; os cons;  os " -- ";gviz_binding os to_pretty_print (cons) binding2; os cons; os "[label=\""; os cons; os "\"];\n"; os cons;  os " -- ";gviz_fixcmd_cmd_comma0 os to_pretty_print (cons)  (d,fixcmd_cmd_comma03) ;  () ;;

let gviz (os:string->unit) (to_pretty_print:bool) (cons:string) e = os "graph hopeful { \nnode [shape=\"plaintext\"];\n"; gviz_prog os to_pretty_print cons e; os "}";;