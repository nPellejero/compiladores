open Array
open Splayset 
open tigertab
open tigerframe
open tigerliveness
open tigergraph
open tigerassem

fun tupleCompare ((a,b),(c,d)) = if (String.compare(a,c)=EQUAL andalso String.compare(b,d)=EQUAL) then EQUAL else GREATER

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
val selectStack = ref([])
val coalescedNodes = ref(empty String.compare)
val alias = ref(tabNueva())
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

fun miMember2(conj, elem) =
		let 
			val conjBool = foldr (fn (x,accum) => tupleCompare(x, elem)=EQUAL orelse accum) false conj 
			in conjBool end

fun adjacent(n) = 
	let 
		val miadjList = tabSaca(n, !adjList)
		val miselectStack = addList(empty String.compare, !selectStack)
		in difference(miadjList, union(miselectStack, !coalescedNodes))
   end
	 handle noExiste => let 
												val _ = print "adjacent: noExiste"
											in empty String.compare end 

fun nodeMoves n = let
				val miMoveList = tabSaca(n, !moveList) 
				val conjInter = intersection(miMoveList,union(!activeMoves,!worklistMoves)) 
				in conjInter end
				handle noExiste => let
														val vacio = empty String.compare
														val _ =  print "nodeMoves: noExiste\n"
													 in vacio end

fun moveRelated n = isEmpty(nodeMoves n)

fun enableMoves(conjuntoNodes) =
	let
		fun enableAux(n) = 
			let
				fun auxDeAux(m) =
					let
						 val sing = singleton String.compare m
						 val _ = if member(!activeMoves, m)
										 then
											 let
													val dif =  difference(!activeMoves, sing)
													val un  =   union(!worklistMoves, sing)
												in activeMoves := dif; worklistMoves := un end
										 else () 
						in ()
					end
			in app auxDeAux (nodeMoves(n)) end		
	in app enableAux conjuntoNodes end

	

fun decrementDegree(m) =
	let 
		val d = tabSaca(m, !degree)
		val _ = if d = k
						then
							let
								val sing = singleton String.compare m
								val uni  = union(sing, adjacent(m))
								(*val _ = enableMoves(uni)	*)
								val miSpill = difference(!spillWorklist, sing)
								val _ = if (moveRelated(m))
															then  freezeWorklist := add(!freezeWorklist,m) 
															else simplifyWorklist := add(!simplifyWorklist,m)
							in spillWorklist := miSpill end
						else ()
	in degree := tabRInserta(m, d-1, !degree) end  
		

fun simplify() = 
	let 
		fun justAux(n) = 
			let
				val justAuxWorklist = delete(!simplifyWorklist, n)
				val auxStack = n::(!selectStack)
				val _ = app decrementDegree	(adjacent(n))		
			in selectStack := auxStack; simplifyWorklist := justAuxWorklist end  
		val item = List.hd(listItems(!simplifyWorklist))
	in justAux item end
	handle Empty => print "justAux: Empty"		

fun addWorklist u = 
	let
		val cond1 = not(member(!precolored, u))
		val cond2 = not(moveRelated(u)) 
		val cond3 = tabSaca(u, !degree) < k
		val _ = if (cond1 andalso cond2 andalso cond3)
							then
								let
									val sing = singleton String.compare u
								in 	freezeWorklist := difference(!freezeWorklist, sing);
										simplifyWorklist := union(!simplifyWorklist, sing)
								end 
							else ()
		handle noExiste => print "addWorklist: noExiste"
	in () end

fun ok(t, r) = 
	let 
		val degreeLess = tabSaca(t, !degree) < k
		val ispre = member(!precolored, t)
		val isInAdjset = miMember2(!adjSet,(t, r)) 
	in degreeLess orelse ispre orelse isInAdjset end 
	handle noExiste => let
												val _ = print "ok: noExiste"
											in true end 

fun conservative(nodes) = 
	let
		fun funAux (x, y) = if y >= k then 1 else 0 
		val mapped = map funAux (tabAList(!degree))
		val reduced = List.foldr (fn (a,b) => a+b) 0 mapped
	in reduced < k end 

fun getAlias(n) =
	if member(!coalescedNodes, n)
			then
				let
					val miAlias = tabSaca(n, !alias)
				in getAlias(miAlias) end
				handle noExiste => let 
														val _ = print "getAlias: noExiste"
														in n end 
			else n						

fun makeWorklist() =
let 
  fun makeAux x = let
										val init_n = delete ((!initial),x)
										val g = tabSaca(x,(!degree))
										handle noExiste => let
														 val _ =  print ("makeAux: no existe el nodo:"^x ^" \n") in 0 end
										val _ = if (g >= k) 
													then spillWorklist := add(!spillWorklist,x)	 
													else if (moveRelated(x))
															then  freezeWorklist := add(!freezeWorklist,x) 
															else simplifyWorklist := add(!simplifyWorklist,x)
									in initial := init_n 
									end
									handle NotFound => print "makeWorklist: no deberia pasar\n"
in app makeAux (!initial) 
end


fun addEdge (nodeu,nodev) =
	 if (not(miMember2 (!adjSet,(nodeu,nodev))) orelse not(miMember2 (!adjSet,(nodev,nodeu)))) andalso not(String.compare(nodeu,nodev) = EQUAL)
		then 
			let
				(*val _ =  print ("poniendo noddes: " ^ nodeu ^ nodev ^ "\n" ) 
				val _ = app (fn (x,y) => print ("("^x^","^y^")")) (!adjSet)
				val _ = print "\n"*) 
				val _ = if not(member(!precolored, nodeu))
									then 
										let 
											val adjU = add(tabSacaConj(nodeu, !adjList), nodev)
											(*val _ = print ("Nodeu:"^nodeu^"\n")
											val _ = app (fn x => print (x^"-")) adjU
											val _ = print "\n" *)
											in adjList := (tabRInserta(nodeu, adjU, !adjList)); degree := (tabRInserta(nodeu,tabSacaInt(nodeu,!degree)+1, !degree)) end 
									else degree := (tabRInserta(nodeu, 1000, !degree))
 
				val _ = if not(member(!precolored, nodev))
									then 
										let 
											val adjU = add(tabSacaConj(nodev, !adjList), nodeu)
											(*val _ = print ("Nodev:"^nodev^"\n")
											val _ = app (fn x => print (x^"-")) adjU
											val _ = print "\n" *)
											in adjList := (tabRInserta(nodev, adjU, !adjList)); degree := (tabRInserta(nodev,tabSacaInt(nodev,!degree)+1, !degree)) end 
									else degree := (tabRInserta(nodev, 1000, !degree))

				in adjSet := add(!adjSet, (nodeu,nodev)); adjSet := add(!adjSet, (nodev,nodeu)) end
					else () (*print (nodeu ^ " equals?? " ^ nodev ^ "\n")*) 

fun build outsarray (instr::assems) i (FGRAPH{control, def, use, ismove},nodes) = 
let
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
			  val	(conjNode, worklistTemp) = foldr funaccum (tabSacaConj(nodename mynode, !moveList), !worklistMoves) (union(getdef(i), getuse(i)))
			  in moveList := (tabRInserta(nodename mynode, conjNode, !moveList)); worklistMoves := worklistTemp end
		| _ => let
							val mynode = List.nth (nodes,i) 
							in moveList := tabRInserta (nodename mynode, (empty String.compare), !moveList) 
						end
	val live = union(live, getdef i)
	val _ = app (fn x =>( app (fn y => addEdge(x,y)) (getdef i))) live
(*	val _ = print "esto es live:\n"
	val _ = app (fn x => print (x ^ "\n")) live
	val _ = print "esto es getdefi:\n"
	val _ = app (fn x => print (x ^ "\n")) (getdef i)*)
in build outsarray assems (i+1) (FGRAPH{control=control, def=def, use=use, ismove=ismove},nodes) end
| build _ [] _ _ = () 

fun printConj conjToPrint nombre = 
	let
		val _ = print("\n esto es: "^nombre^"\n {")	
		val _ = app (fn x => print (x^" ,")) conjToPrint
		val _ = print "}\n"
	in () end


fun main fgraph nodes assems =
let	
	val _ = precoloredInit()
	val (insarray,outsarray) = livenessAnalisis(fgraph,nodes)
	val _ = build outsarray assems 0 (fgraph,nodes)
	val _ = initialInit()	
	val _ = makeWorklist() 
	val _ = printConj (!spillWorklist) "spillWorklist"
	val _ = printConj (!simplifyWorklist) "simplifyWorklist"
	val _ = printConj (!freezeWorklist) "freezeWorklist" 
	val _ = printConj (!worklistMoves) "worklistMoves" 
	val _ = if not(isEmpty(!simplifyWorklist)) then simplify() else () 
in (insarray, outsarray, adjSet) end


