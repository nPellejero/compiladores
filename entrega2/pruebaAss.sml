open Splayset
open tigerassem

fun compAssem ((OPER{assem = a1, dst = d1,src = s1, jump = j1}), (OPER{assem = a2, dst = d2, src = s2, jump = j2})) =
          if a1 = a2 andalso d1 = d2 andalso s1 = s2 andalso j1 = j2
              then EQUAL else GREATER
|  compAssem ((OPER{assem = a1, dst = d1,src = s1, jump = j1}), _) = GREATER
|  compAssem ((LABEL{assem = a1, lab = l1}), (LABEL{assem = a2, lab = l2})) =
          if a1 = a2 andalso l1 = l2
              then EQUAL else GREATER
|  compAssem ((LABEL{assem = a1, lab = l1}), _) = LESS
|  compAssem ((MOVE{assem = a1, dst = d1, src = s1}), (MOVE{assem = a2, dst = d2, src = s2}))=
      if  a1 = a2 andalso d1 = d2 andalso s1 = s2 then EQUAL else GREATER
|  compAssem ((MOVE{assem = a1, dst = d1, src = s1}), (LABEL{assem = _, lab = _})) = GREATER
|  compAssem ((MOVE{assem = a1, dst = d1, src = s1}), (OPER{assem = _, dst = _,src = _, jump = _})) = LESS

fun compAssem1 ((OPER{assem = a1, dst = d1,src = s1, jump = j1}), (OPER{assem = a2, dst = d2, src = s2, jump = j2})) =
          if a1 = a2 andalso d1 = d2 andalso s1 = s2 andalso j1 = j2
              then EQUAL else GREATER
|  compAssem1 ((OPER{assem = a1, dst = d1,src = s1, jump = j1}), _) = GREATER
|  compAssem1 ((LABEL{assem = a1, lab = l1}), (LABEL{assem = a2, lab = l2})) =
          if a1 = a2 andalso l1 = l2
              then EQUAL else GREATER
|  compAssem1 ((LABEL{assem = a1, lab = l1}), _) = GREATER 
|  compAssem1 ((MOVE{assem = a1, dst = d1, src = s1}), (MOVE{assem = a2, dst = d2, src = s2}))=
      if  a1 = a2 andalso d1 = d2 andalso s1 = s2 then EQUAL else GREATER
|  compAssem1 ((MOVE{assem = a1, dst = d1, src = s1}),_) = GREATER


val conj1 = empty compAssem1
val conj2 = empty compAssem1

val lab1 = LABEL{assem="lalala", lab="milab1"}
val lab2 = LABEL{assem="lalala", lab="milab2"}
val mov1 = MOVE{assem="lalala", dst="T1", src="T2"} 
val mov2 = MOVE{assem="lalala", dst="T1", src="T3"} 

val list1 = [lab1, lab2, mov1]
val list2 = [mov2, lab1]

val conjList1 = addList(conj1, list1)
val conjList2 = addList(conj2, list2)

val _ = print (Bool.toString(member( conjList1,lab1))^"\n")
val _ = print (Bool.toString(member( conjList2,lab2))^"\n")


