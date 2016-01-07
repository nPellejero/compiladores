open Splayset

fun tupleCompare ((a,b),(c,d)) = if (String.compare(a,c)=EQUAL andalso String.compare(b,d)=EQUAL) then EQUAL else if String.compare(a,c)=GREATER then GREATER else LESS

fun tupleCompare1 ((a,b),(c,d)) = if (String.compare(a,c)=EQUAL andalso String.compare(b,d)=EQUAL) then EQUAL else GREATER

val conj1 = empty tupleCompare1
val conj2 = empty tupleCompare1

val list1 = [("1","2"),("3","2")]
val list2 = [("1","2"),("2","3"),("1","1")]

val conjList1 = addList(conj1, list1)
val conjList2 = addList(conj2, list2)

val _ = print (Bool.toString(member( conjList1,("1","2")))^"\n")
val _ = print (Bool.toString(member( conjList2,("1","4")))^"\n")


