open Array
open Splayset 
open tigertab
open tigerframe
open tigerliveness
open tigergraph
open tigerassem

fun tupleCompare ((a,b),(c,d)) = if String.compare(a,c)=EQUAL andalso String.compare(b,d)=EQUAL then EQUAL else GREATER

val precolored_init = [fp,sp,rv,ov]
val precolored = ref(empty String.compare)
val initial = ref(empty String.compare)
val adjList = ref(tabNueva())
val degree = ref(tabNueva())
val adjSet = ref(empty tupleCompare)
val moveList = ref(tabNueva())
val worklistMoves = ref(empty String.compare)
val k = 4
val spillWorklist = ref(empty String.compare)
val freezeWorklist = ref(empty String.compare)
val simplifyWorklist = ref(empty String.compare)
val activeMoves = ref(empty String.compare)

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

fun precoloredInit() =
let
	val prec = addList (empty String.compare, precolored_init)
in precolored := prec 
end

fun initialInit() =
let
	val conjTmpReg = addList((empty String.compare), (tabClaves(!adjList)))
	val init = difference(conjTmpReg,(!precolored))
in initial := init end

fun nodeMoves n = intersection(tabSaca(n,(!moveList)),union(!activeMoves,!worklistMoves)) (*Quizas en vez de tabSaca sea tabBusca*)
fun moveRelated n = isEmpty(nodeMoves n)

fun makeWorklist() =
let 
  fun makeAux x = let
										val init_n = delete ((!initial),x)
										val g = tabSaca(x,(!degree))
									  val _ = print ("Degree:"^Int.toString(g)^"\n") 
										val _ = if (g >= k) 
													then spillWorklist := add(!spillWorklist,x)	 
													else if (*moveRelated(x)*) true
															then  freezeWorklist := add(!freezeWorklist,x) 
															else simplifyWorklist := add(!simplifyWorklist,x)
									in initial := init_n 
									end
									handle NotFound => print "makeWorklist: no deberia pasar\n"
in app makeAux (!initial) 
end


fun addEdge (nodeu,nodev) =
	 if not(member (!adjSet,(nodeu,nodev))) andalso not(String.compare(nodeu,nodev) = EQUAL)
		then 
			let
				(*val _ =  print ("poniendo noddes: " ^ nodeu ^ nodev ^ "\n" ) 
				val _ = app (fn (x,y) => print ("("^x^","^y^")")) (!adjSet)
				val _ = print "\n" *)
				val _ = if not(member(!precolored, nodeu))
									then 
										let 
											val adjU = add(tabSacaConj(nodeu, !adjList), nodev)
										(*	val _ = print ("Nodeu:"^nodeu^"\n")
											val _ = app (fn x => print (x^"-")) adjU
											val _ = print "\n"*)
											in adjList := (tabRInserta(nodeu, adjU, !adjList)); degree := (tabRInserta(nodeu,tabSacaInt(nodeu,!degree)+1, !degree)) end 
									else print "es precolored\n"
 
				val _ = if not(member(!precolored, nodev))
									then 
										let 
											val adjU = add(tabSacaConj(nodev, !adjList), nodeu)
										(*	val _ = print ("Nodev:"^nodev^"\n")
											val _ = app (fn x => print (x^"-")) adjU
											val _ = print "\n" *)
											in adjList := (tabRInserta(nodev, adjU, !adjList)); degree := (tabRInserta(nodeu,tabSacaInt(nodev,!degree)+1, !degree)) end 
									else print "es precolored\n" 

				in adjSet := add(!adjSet, (nodeu,nodev)); adjSet := add(!adjSet, (nodeu,nodev)) end
					else () (*print (nodeu ^ " equals?? " ^ nodev ^ "\n")*) 

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
			  val	(conjNode, worklistTemp) = foldr funaccum (tabSaca(mynode, !moveList), !worklistMoves) (union(getdef(i), getuse(i)))
			  in moveList := (tabRInserta(mynode, conjNode, !moveList)); worklistMoves := worklistTemp end
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
	val _ = precoloredInit()
	val (insarray,outsarray) = livenessAnalisis(fgraph,nodes)
	val _ = build outsarray assems 0 (fgraph,nodes)
	val _ = initialInit()
(*	val _ = makeWorklist() *)
in (insarray, outsarray, adjSet) end



