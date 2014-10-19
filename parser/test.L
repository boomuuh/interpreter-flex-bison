
(let y = lambda x,y.(x(y y)) in (y 5))
---
let y = lambda x.lambda z.(let t = ReadString in let _ = (print t) in (if (3*5 >= 16 - 1) then (if 2 + 2 >= ((1 * 100)) then "nested if-then" else "nested else")  else "weird") ) in (y 5)
---
let x = lambda li.(print !li@1@Nil@2 * 4) in (x 2@2@4)
---
let m = lambda f,z,x.(if isNil x | (isNil !x & isNil #x) then print "i dont know" else print "sure") in (m list@billy@dummy)
---
fun function with x,w,z,jeremylin = isNil print lambda x.(isNil x & isNil 2 | 2 * 3 >= 6 | isNil !x@9 & isNil #x@4) in (function 1@1@1)

