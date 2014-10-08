(*33 1 "duck" identifier*)

(*let y = lambda x,y.(x(y y)) in (y 5)*)

(*print ("STRING")*)
(*((2) + 3) * 4
 2 + 3 * 4 
*)

(*(2 * 3) + 4 * ((3) + (5 - 97)) *)

(*((3 + 5 - 1) / 2 = 2 - 1 * 200) = 23 *)

(*(print (if (3*5 >= 16 - 1) then (if 2 + 2 >= ((1 * 100)) then "nested if-then" else "nested else")  else "weird"))*)

(*let x = print "hello" in x*)

(*let x = (if 2 * 4 <> 8 then print "this shouldn't run" else print "Winner winner" + "chicken" + "dinner") in x*)

(*let y = lambda x.lambda z.(let t = ReadString in let _ = (print t) in 0) in (y 5)*)

(*isNil x *)
(*let x = lambda l.(if isNil !l then print !l else print #l) in (x 1@2@3) *)

(*let x = lambda li.(print !li@1@Nil@2 * 4) in (x 2@2@4)*)

(*let m = lambda f,z,x.(if isNil x | (isNil !x & isNil #x) then print "i dont know" else print "sure") in (m list@billy@dummy)*)

(*isNil x & isNil 2 | 2 * 3 >= 6 | isNil 1@2 *)

isNil x | isNil 2*2 / 1 & 2 * 3 >= 6 & isNil 1@2 