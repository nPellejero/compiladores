open Array
open Splayset 
open tigertab
open tigerframe
open tigerliveness
open tigergraph
open tigerassem
(*
fun tupleCompare ((t1: string * string),(t2: string * string)) = if (String.compare (#1(t1),#1(t2))) andalso (String.compare (#2(t1),#2(t2))) then EQUAL else GREATER

fun tupleCompare ((a,b), (c,d)) = if a = c andalso b = d then EQUAL else GREATER  
*)
fun tupleCompare ((a,b),(c,d)) = if String.compare(a,c)=EQUAL andalso String.compare(b,d)=EQUAL then EQUAL else GREATER


val precolored = ref(empty String.compare)
val adjList = ref(tabNueva())
val degree = ref(tabNueva())
val adjSet = ref(empty tupleCompare)
val moveList = ref(tabNueva())
val worklistMoves = ref(empty String.compare)

fun tabSacaConj (item, table) = 
			let
				val conj =  tabSaca(item, table)
				in conj end
				handle noExiste => empty String.compare
fun tabSacaInt (item, table) = 
			let
				val num =  tabSaca(item, table)
				in num end 
				handle noExiste => 0

fun addEdge (nodeu,nodev) =
	 if not(member (!adjSet,(nodeu,nodev))) andalso not(String.compare(nodeu,nodev) = EQUAL)
		then 
			let
				(*val _ =  print ("poniendo noddes: " ^ nodeu ^ nodev ^ "\n" ) *)
				val _ = app (fn (x,y) => print ("("^x^","^y^")")) (!adjSet)
				val _ = if not(member(!precolored, nodeu))
									then 
										let 
											val adjU = add(tabSacaConj(nodeu, !adjList), nodev)
											in adjList := (tabInserta(nodeu, adjU, !adjList)); degree := (tabInserta(nodeu,tabSacaInt(nodeu,!degree)+1, !degree)) end 
									else print "es precolored\n"
 
				val _ = if not(member(!precolored, nodeu))
									then 
										let 
											val adjU = add(tabSacaConj(nodeu, !adjList), nodev)
											in adjList := (tabInserta(nodeu, adjU, !adjList)); degree := (tabInserta(nodeu,tabSacaInt(nodeu,!degree)+1, !degree)) end 
									else print "es precolored\n" 

				in adjSet := add(!adjSet, (nodeu,nodev)); adjSet := add(!adjSet, (nodeu,nodev)) end
					else print (nodeu ^ " equals?? " ^ nodev ^ "\n") 

fun build outsarray (instr::assems) i (FGRAPH{control, def, use, ismove},nodes) = 
let
	(*val _ = print i*)
	fun getuse index = let val mynode = List.nth (nodes, index)
										val uses = (case tabBusca (mynode, use) of SOME x=> x | NONE => [])
									in addList (empty String.compare, uses) end
	fun getdef index = let val mynode = List.nth (nodes, index)
										val defs = (case tabBusca (mynode, def) of SOME x=> x | NONE => [])
									in addList (empty String.compare, defs) end

  fun arrayToList arr = Array.foldr (op ::) [] arr

	val live = sub(outsarray, i)
	val _ = case instr of MOVE {assem,dst,src} =>
			let
				val live = difference(live,getuse i)
				fun funaccum (item, (conjX, conjY)) = let
															val cci =  singleton String.compare item
														in (item::conjX, union(conjY,cci)) end
	val mynode = List.nth (nodes,i)
	val conjNode = let 
									val xxs = (case tabBusca(mynode, !moveList) of SOME x => x | NONE => [] ) in xxs end
			  val	(conjNode, worklistTemp) = foldr funaccum (conjNode, !worklistMoves) (union(getdef(i), getuse(i)))
			  in moveList := (tabInserta(mynode, conjNode, !moveList)); worklistMoves := worklistTemp end
		| _ => ()
	val live = union(live, getdef i)
	val _ = app (fn x =>( app (fn y => addEdge(x,y)) (getdef i))) live
	val _ = print "esto es live:\n"
	val _ = app (fn x => print (x ^ "\n")) live
	val _ = print "esto es getdefi:\n"
	val _ = app (fn x => print (x ^ "\n")) (getdef i)
in build outsarray assems (i+1) (FGRAPH{control=control, def=def, use=use, ismove=ismove},nodes) end
| build _ [] _ _ = () 


fun main fgraph nodes assems =
let	
	val (insarray,outsarray) = livenessAnalisis(fgraph,nodes)
	val _ = build outsarray assems 0 (fgraph,nodes)
in (insarray, outsarray, adjSet) end



