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

(*let m = isNil print lambda x.(isNil x & isNil 2 | 2 * 3 >= 6 | isNil !x@9 & isNil #x@4) in (m 1@1@1)*)

(*isNil x | isNil 2*2 / 1 & 2 * 3 >= 6 & isNil 1@2 *)

(*fun x with z,x,v = print "function" in (x 29)*)

let true = lambda x.(lambda y.x) in
let false = lambda x.(lambda y.y) in
fun read_list with n =
	if (false n 0) then Nil else
	let val = readInt in
	let rest = (read_list (n-1)) in
	val@rest
in
let _ = print "Enter number of integers in list" in
let num = readInt in
let _ = print "Please enter the list values:" in
let l = (read_list num) in
let _ = print "List entered" in
let _ = print l in
let _ = print "Adding 2 to each element: " in

fun add with l, n =
	if isNil #l then ((!l)+n)@Nil else
	let hd = !l in
	let tl = #l in
	(hd+n)@(add tl n)
in

(add l 2)







