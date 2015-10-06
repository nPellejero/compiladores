open Array
open Splayset 
open tigertab
open tigerframe
open tigerliveness
open tigergraph


(*
fun tupleCompare ((t1: string * string),(t2: string * string)) = if (String.compare (#1(t1),#1(t2))) andalso (String.compare (#2(t1),#2(t2))) then EQUAL else GREATER

fun tupleCompare ((a,b), (c,d)) = if a = c andalso b = d then EQUAL else GREATER  
*)
fun tupleCompare ((a,b),(c,d)) = if String.compare(a,c)=EQUAL andalso String.compare(b,d)=EQUAL then EQUAL else GREATER


val precolored = empty String.compare
(*val adjSet = empty tupleCompare *)
val adjList = tabNueva()
val degree = tabNueva()
val adjSet = empty tupleCompare

fun main fgraph nodes =
let	
(*	val adjSet = empty tupleCompare *)
	val (insarray,outsarray) = livenessAnalisis(fgraph,nodes)
in (insarray, outsarray, adjSet) end

fun addEdge (nodeu,nodev) adjSet =
	 if member (adjSet,(nodeu,nodev)) andalso String.compare(nodeu,nodev) = EQUAL
		then 
			let
				val adjSet = add(adjSet, (nodeu,nodev))
				val adjSet = add(adjSet, (nodev,nodeu))
				val _ = if not(member(precolored, nodeu))
									then 
										let 
											val adjU = add(tabSaca(nodeu, adjList), nodev)
											val _ = tabInserta(nodeu, adjU, adjList)
											val _ = tabInserta(nodeu,tabSaca(nodeu,degree)+1, degree) 
											in () end 
									else ()
				val _ = if not(member(precolored, nodev))
									then 
										let 
											val adjV = add(tabSaca(nodev, adjList), nodeu)
											val _ = tabInserta(nodev, adjV, adjList)
											val _ = tabInserta(nodev,tabSaca(nodev,degree)+1, degree) 
											in () end
										else ()

				in adjSet end
					else adjSet

