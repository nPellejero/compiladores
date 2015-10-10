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


val precolored = empty String.compare
val adjList = tabNueva()
val degree = tabNueva()
val adjSet = empty tupleCompare
val moveList = tabNueva()
val worklistMoves = empty String.compare
fun tabSacaConj (item, table) = 
			let
				val conj =  tabSaca(item, table)
				handle noExiste => empty String.compare
				in conj end
fun tabSacaInt (item, table) = 
			let
				val num =  tabSaca(item, table)
				handle noExiste => 0
				in num end
fun addEdge (nodeu,nodev) =
	 if not(member (adjSet,(nodeu,nodev))) andalso not(String.compare(nodeu,nodev) = EQUAL)
		then 
			let
				val adjSet = add(adjSet, (nodeu,nodev))
				val adjSet = add(adjSet, (nodev,nodeu))
				val _ = if not(member(precolored, nodeu))
									then 
										let 
											val adjU = add(tabSacaConj(nodeu, adjList), nodev)
											val _ = tabInserta(nodeu, adjU, adjList)
											val _ = tabInserta(nodeu,tabSacaInt(nodeu,degree)+1, degree) 
											in () end 
									else print "es precolored\n" 

				val _ = if not(member(precolored, nodev))
									then 
										let 
											val adjV = add(tabSacaConj(nodev, adjList), nodeu)
											val _ = tabInserta(nodev, adjV, adjList)
											val _ = tabInserta(nodev,tabSacaInt(nodev,degree)+1, degree) 
											in () end
										else print "es precolored\n" 

				in () end
					else (*print (nodeu ^ "equals??" ^ nodev ^ "\n") *) ()

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
														in (union(conjX,cci), union(conjY,cci)) end
	val mynode = List.nth (nodes,i)
	val conjNode = let 
									val xxs = (case tabBusca(mynode, moveList) of SOME x => x | NONE => [] ) in addList(empty String.compare, xxs) end
			  val	(conjNode, worklistMoves) = foldr funaccum (conjNode, worklistMoves) (union(getdef(i), getuse(i)))
			  in () end
		| _ => ()
	val live = union(live, getdef(i))
	val _ = app (fn x => revapp (fn y => addEdge(x,y)) (getdef i)) live
in build outsarray assems (i+1) (FGRAPH{control=control, def=def, use=use, ismove=ismove},nodes) end
| build _ [] _ _ = () 


fun main fgraph nodes assems =
let	
	val (insarray,outsarray) = livenessAnalisis(fgraph,nodes)
	val _ = build outsarray assems 0 (fgraph,nodes)
in (insarray, outsarray, adjSet) end



