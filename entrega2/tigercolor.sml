open Array
open Splayset 
open tigertab
open tigerframe
open tigerliveness
open tigergraph
open tigerassem

fun miTabNueva() = let 
						val table = tabNueva()
						handle noExiste => let 
												val _ = print "miTabNueva: noExiste"
											in tabNueva() end					
						in table end 


fun tupleCompare ((a,b),(c,d)) = if (String.compare(a,c)=EQUAL andalso String.compare(b,d)=EQUAL) then EQUAL else if String.compare(a,c)=GREATER then GREATER else LESS 

fun miEnesimo(lista, index) = let
									val item = List.nth(lista, index)
									handle Subscript => let
														val item = List.hd(lista)
														val _ = print "excepcion: subscript"
														in item end   
									in item end

fun printConjMoves conjToPrint nombre = 
	let
		val _ = print("\n esto es: "^nombre^"\n { ")	
		fun printMoves m = 
			case m of MOVE{assem, dst, src} => print ("MOVE: "^dst^","^src^"\n")				
			| _ => print "estamo al horno"
		val _ = app printMoves conjToPrint
		val _ = print "}\n"
	in () end


fun printConj conjToPrint nombre = 
	let
		val _ = print("\n esto es: "^nombre^"\n {")	
		val _ = app (fn x => (print x;(print " ,"))) conjToPrint
		val _ = print "}\n"
	in () end

fun printAssem m = 
			case m of MOVE{assem, dst, src} => print ("MOVE: "^dst^","^src^"\n")				
			| (OPER{assem = a, dst = d, src = s, jump = j}) => let
																													val _ = print "OPER:\n {"
																													val _ = print "\nsrc:"
																													val _ = List.app (fn x => print (x^" ")) s	
																													val _ = print "\ndst:"
																													val _ = List.app (fn x => print (x^" ")) d	
																													val _ = print "}\n"
																												 in () end
			| (LABEL{assem = a, lab=l}) =>  print ("LABEL: "^a^":"^l^"\n") 

fun printTab tabToPrint nombre = 
	let
		val _ = print("\n esto es: "^nombre^"\n {")	
		fun printMoves m = 
			case m of MOVE{assem, dst, src} => print ("MOVE: "^dst^","^src^"\n")				
			| _ => print "estamo al horno"
	  fun printSetMoves s =	let val _ = app printMoves s in () end	
		val _ = tabAplica (printSetMoves,tabToPrint)  
		val _ = print "}\n"
	in () end

fun printTab2 tabToPrint nombre = 
	let
		val _ = print("\n esto es: "^nombre^"\n {")	
		(*val claves = tabClaves(tabToPrint) *)
		fun printColor m = print ("Color: "^Int.toString(m)) 
	  fun printSet s =	let val _ = app printColor s
													val _ = print "\n" in () end	
		fun printClave k = print("Nodo: "^k^" -> ")
		val _ = tabAAplica (printClave,printSet,tabToPrint)  
		val _ = print "}\n"
	in () end

fun printTab4 tabToPrint nombre = 
	let
		val _ = print("\n esto es: "^nombre^"\n {")	
		(*val claves = tabClaves(tabToPrint) *)
		fun printColor m = print ("vecinos: "^m) 
	  fun printSet s =	let val _ = app printColor s
													val _ = print "\n" in () end	
		fun printClave k = print("Nodo: "^k^" -> ")
		val _ = tabAAplica (printClave,printSet,tabToPrint)  
		val _ = print "}\n"
	in () end

fun printTab3 tabToPrint nombre = 
	let
		val _ = print("\n esto es: "^nombre^"\n {")	
		fun printValor v = print ("Valor: "^Int.toString(v)^"\n") 
		fun printClave k = print("Nodo: "^k^" -> ")
		val _ = tabAAplica (printClave,printValor,tabToPrint)  
		val _ = print "}\n"
	in () end


fun compAssem ((OPER{assem = a1, dst = d1,src = s1, jump = j1}), (OPER{assem = a2, dst = d2, src = s2, jump = j2})) =
					if a1 = a2 andalso d1 = d2 andalso s1 = s2 andalso j1 = j2 
							then EQUAL else GREATER 

|	 compAssem ((OPER{assem = a1, dst = d1,src = s1, jump = j1}), _) = GREATER
|	 compAssem ((LABEL{assem = a1, lab = l1}), (LABEL{assem = a2, lab = l2})) =
					if a1 = a2 andalso l1 = l2 
							then EQUAL else GREATER
|	 compAssem ((LABEL{assem = a1, lab = l1}), _) = LESS 
|	 compAssem ((MOVE{assem = a1, dst = d1, src = s1}), (MOVE{assem = a2, dst = d2, src = s2}))=
			if  a1 = a2 andalso d1 = d2 andalso s1 = s2 then EQUAL else GREATER
|	 compAssem ((MOVE{assem = a1, dst = d1, src = s1}), (LABEL{assem = _, lab = _})) = GREATER 
|	 compAssem ((MOVE{assem = a1, dst = d1, src = s1}), (OPER{assem = _, dst = _,src = _, jump = _})) = LESS 

val precolored_init = [fp, sp, rv ] @ argregs (*[fp,sp,rv,ov]*)
val listaColors =[0,1,2,3,4] (*[0, 1 , 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13] *)
val k = 4 (*14*) 
val precolored = ref(empty String.compare)
val initial = ref(empty String.compare)
val adjList = ref(miTabNueva())
val degree = ref(miTabNueva())
val adjSet = ref(empty tupleCompare)
val moveList = ref(miTabNueva())
val worklistMoves = ref(empty compAssem)
val spillWorklist = ref(empty String.compare)
val freezeWorklist = ref(empty String.compare)
val simplifyWorklist = ref(empty String.compare)
val selectStack = ref([])
val coalescedNodes = ref(empty String.compare)
val alias = ref(miTabNueva())
val activeMoves = ref(empty compAssem)
val coalescedMoves = ref(empty compAssem)
val constrainedMoves = ref(empty compAssem)
val frozenMoves = ref(empty compAssem)
val color = ref(miTabNueva())
val coloredNodes = ref(empty String.compare)
val spilledNodes = ref(empty String.compare)
val masterLives = ref([])

fun pushStack( item ) = selectStack := item::(!selectStack)
fun popStack() = let
					 					val _ = if null(!selectStack) 
														then print "Error Stack empty\n"
														else ()
										val stackAux = List.tl(!selectStack)
										val item = List.hd(!selectStack)
								in selectStack := stackAux; item  end
								handle Empty => let 
									val _ = print "popStack: Empty\n"		
									in "vacio" end

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
	val _ = masterLives := []
	val _ = degree := miTabNueva()
	val _ = adjList := miTabNueva()
	val _ = adjSet := empty tupleCompare
	val prec = addList (empty String.compare, precolored_init)
in precolored := prec 
end	

fun initialInit() =
let
	val conjTmpReg = addList((empty String.compare), (tabClaves(!adjList)))
	val init = difference(conjTmpReg,(!precolored))
  (*fun funAuxD n = degree := tabRInserta(n,0,!degree)
  val _ = app funAuxD conjTmpReg*)
  val _ = color := miTabNueva() 
	fun funPreC i = color := tabRInserta(List.nth(precolored_init,i-14),singleton Int.compare i,!color)
  val _ = app funPreC (addList(empty Int.compare, [14, 15])) 
	val _ = color := tabRInserta(rv, singleton Int.compare 0,  !color)
	val _ = color := tabRInserta(List.nth(argregs, 0), singleton Int.compare 2,  !color)
	val _ = color := tabRInserta(List.nth(argregs, 1), singleton Int.compare 3,  !color)
	val _ = color := tabRInserta(List.nth(argregs, 2), singleton Int.compare 4,  !color)
	val _ = color := tabRInserta(List.nth(argregs, 3), singleton Int.compare 5,  !color)
  fun funAux n = color := tabRInserta(n,empty Int.compare,!color)
	val init =  if isEmpty(!initial) then init else (!initial)
	val _ = app funAux init
in initial := init end
handle Subscript => print "initialInit: Subscript"

fun miMember2(conj, elem) =
		let 
			val conjBool = foldr (fn (x,accum) => tupleCompare(x, elem)=EQUAL orelse accum) false conj 
			in conjBool end

fun miMemberAssem(conj, elem) =
		let 
			val conjBool = foldr (fn (x,accum) => compAssem(x, elem)=EQUAL orelse accum) false conj 
			in conjBool end

fun miDelete(conj, elem) = 
let
	val conjRes = ref(empty compAssem)
	fun funAux x = if not(compAssem(x,elem)=EQUAL) 
									then let
										val _ = conjRes := add(!conjRes,x)
								 		in () end
								  else ()
	val _ = app funAux conj
in (!conjRes) end


fun adjacent(n) = 
	let 
		val miadjList = tabSaca(n, !adjList)
		val miselectStack = addList(empty String.compare, !selectStack)
		in difference(miadjList, union(miselectStack, !coalescedNodes))
   end
	 handle noExiste =>  empty String.compare (*no esta mal.pasa cuando n es precol.*) 

fun nodeMoves n = let
		(* 	val _ = print ("node: "^n^"\n") *)
				val miMoveList = tabSaca(n, !moveList) 
			  handle noExiste => let
														val vacio = empty compAssem 
														val _ =  print ("nodeMoves: "^n^" -> Move que no esta realacionado con otro temporario\n")
													 in vacio end	
(*				val _ = printConjMoves (!activeMoves) "activeMoves"
				val _ = printConjMoves (!worklistMoves) "worklistMoves"*)
				val conjInter = intersection(miMoveList,union(!activeMoves,!worklistMoves)) 
				in conjInter end

fun moveRelated n = not(isEmpty(nodeMoves n))

fun enableMoves(conjuntoNodes) =
	let
		fun enableAux(n) = 
			let
				fun auxDeAux(m) =
					let
						 val sing = singleton compAssem m
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
		handle noExiste => let
										val _ = print "decDegree: noExiste"
										in 0 end
		val _ = if d = k
						then
							let
								(* val _ = print ("decrementDegree "^m^"\n") *)
								val sing = singleton String.compare m
								val uni  = union(sing, adjacent(m))
								val _ = enableMoves(uni)	
								val miSpill = difference(!spillWorklist, sing)
								val _ = if (moveRelated(m))
															then 
																let										
																	(* val _ = print ("freeze "^m^"\n") *)
																	val newFreeze = add(!freezeWorklist,m)	
																in freezeWorklist := newFreeze end 
															else				
																let										
																	(* val _ = print ("simplifyworklist "^m^"\n") *)
																	val simp_new =  add(!simplifyWorklist,m)
																	(* val _ = printConj (simp_new) "simplifyWorklist"	*)
																in  simplifyWorklist := simp_new end
							in spillWorklist := miSpill end
						else ()
	in degree := tabRInserta(m, d-1, !degree) end  
		

fun simplify() = 
	let
		val _ = print "Simplify\n" 
		fun justAux(n) = 
			let
				 val _ = print ("Simplificando "^n^"\n") 
				val _ = pushStack(n)
				val _ = app decrementDegree	(adjacent(n))		
				val justAuxWorklist = delete(!simplifyWorklist, n)
			in simplifyWorklist := justAuxWorklist end  
		val item = List.hd(listItems(!simplifyWorklist))
	in justAux item end
	handle Empty => print "justAux: Empty"		

fun addWorklist u = 
	let
		val _ = print ("addWorklist "^u^"\n")
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
										val init_n = delete((!initial),x)
										(*val _ = print ("MakeWork "^x^"\n") *)
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
				(*val _ =  print ("poniendo noddes: " ^ nodeu ^", "^ nodev ^ "\n" ) 
				val _ = app (fn (x,y) => print ("("^x^","^y^")")) (!adjSet)
				val _ = print "\n" *)
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
handle Subscript => print "addEdge:Subscript"

fun combine(u, v) =
	let
		val _ = print ("Combine ("^u^","^v^")\n")
		val singU =  singleton String.compare u 
		val singV =  singleton String.compare v
		val _	=		let 
						val _ = if member(!freezeWorklist, v) 
										then
											freezeWorklist := difference(!freezeWorklist, singV)
										else
											spillWorklist := difference(!spillWorklist, singV)
						val miCoalesced = union(!coalescedNodes, singV)
						val arg1 = tabSaca(u, (!moveList))
						val arg2 = tabSaca(v, (!moveList))
						handle noExiste => let 
																val _ = print ("combine: noExiste("^u^","^v^")"^"\n")
															in empty  compAssem end
						val miNodeMoves = union(arg1, arg2)
					in coalescedNodes := miCoalesced; alias := tabRInserta(v, u, (!alias)); moveList := tabRInserta(u, miNodeMoves, (!moveList)) end
	val _ = enableMoves(singV)
	val _ = app (fn t => (addEdge(t, u); decrementDegree(t))) (adjacent v)
	val degU = tabSaca(u, (!degree)) 
	handle noExiste => let 
												val _ = print ("combine: noExiste("^u^","^v^")"^"\n")

											in 0 end
	val _ = if degU >= k andalso member(!freezeWorklist, u)
					then 
						let 
							val auxFreeze = difference(!freezeWorklist, singU)
							val auxSpill  = union(!spillWorklist, singU)
						in freezeWorklist := auxFreeze; spillWorklist := auxSpill end else ()
	in () end
	handle noExiste => print ("combine: noExiste("^u^","^v^")"^"\n")

 fun coalesce() = 
let
	val _ = print "Coalesce\n" 
	val m = List.hd(listItems(!worklistMoves))
	val _ = case m of MOVE {assem,dst,src} => let
						val x = getAlias(dst)
						val y = getAlias(src)
						val _ = print ("Coalesce:"^x^","^y^"\n")
						val (u, v) = if member(!precolored, y) then (y, x) else (x, y)
						val singM = singleton compAssem m
						val tempWork = difference(!worklistMoves, singM) 
						val _ = if (String.compare(u,v) = EQUAL) 
									 		then let
												val tempCoalesced1 = union(!coalescedMoves, singM)
												val _ = addWorklist(u) in coalescedMoves := tempCoalesced1 end
											else if member(!precolored, v) orelse miMember2(!adjSet, (u,v)) then
															let
																val tempConstrained = union(!constrainedMoves, singM)
																val _ = addWorklist(u)
																val _ = addWorklist(v) 
															in constrainedMoves := tempConstrained end
							             else let
															val adjconj = adjacent(v)
															val cond1 = foldr (fn (t,accum) => ok(t,u) andalso accum) true adjconj  
															val unionConj = union(adjacent(u), adjacent(v))
															val cond2 = conservative(unionConj)
															val _ = if member(!precolored,u) andalso cond1 orelse 
																					not(member(!precolored,u)) andalso cond2
																			then
																					let
																						val tempCoalesced2 = union(!coalescedMoves, singM)	
																						val _ = combine(u, v)
																						val _ = addWorklist(u)
																					in coalescedMoves := tempCoalesced2 end
																			else 
																let
																		val _ = print "if 2 \n"
																		in activeMoves := union(!activeMoves, singM) end
															in () end
		
						in worklistMoves := tempWork end
						| _ => print "coalesce: estamo al horno" 
in () end
	handle Empty => print "coalesce: Empty"		

fun isMoveInstruction(ins) =
case ins of MOVE {assem,dst,src} => true (*let 
				val _ = print ("build: "^dst^", "^src^"\n")
				in true end*)
(*| OPER {assem=a,dst=d,src=s,jump=j} => let (*val _ = print ("PRUEBA!"^String.substring(a,0,3)^"\n") *)
																					val b = (String.compare(String.substring(a,0,3),"MOV")=EQUAL)
																				(*	val _ = print ("PRUEBA: "^Bool.toString(b)^"\n")*)
																				 val _ = printAssem ins
																				in b end  *)
| _ => false

fun build outsarray (instr::assems) i (FGRAPH{control, def, use, ismove},nodes) = 
let
	fun getuse index = let val mynode = miEnesimo(nodes, index)
										val uses = (case tabBusca (mynode, use) of SOME x=> x | NONE => [])
									in addList (empty String.compare, uses) end
	fun getdef index = let val mynode = miEnesimo(nodes, index)
										val defs = (case tabBusca (mynode, def) of SOME x=> x | NONE => [])
									in addList (empty String.compare, defs) end

  fun arrayToList arr = Array.foldr (op ::) [] arr
  val isMOVE = tabSaca(miEnesimo(nodes, i),ismove)
(*  val _ = print ("isMOve: "^Bool.toString(isMOVE)^"\n")
	val _ = print ("ismoveInstr: "^Bool.toString(isMoveInstruction(instr))^"\n") *)
	val live = sub(outsarray, i)
	val _ = masterLives := ((!masterLives) @ listItems(live))
	val _ = (*case instr of MOVE {assem,dst,src} => *)
					if (isMoveInstruction(instr)) then
			let
		(*		val _ = print ("build: "^dst^", "^src^"\n")  *)
				val live = difference(live,getuse i)
				val mynode = miEnesimo(nodes,i)
				fun myFunAux item =
						let 
							val myMoveList = tabSaca(item, (!moveList))
							handle noExiste => empty compAssem (*let
														 		val _ =print "build: noExiste\n"
																in empty compAssem end *)
							val myConj = union(myMoveList, singleton compAssem instr)
				  	in moveList := tabRInserta(item, myConj, (!moveList)) end
				val _ = app myFunAux (union(getdef(i), getuse(i)))
				handle noExiste => print "build22: noExiste \n"
				val worklistTemp = union(!worklistMoves, singleton compAssem instr)
			  in worklistMoves := worklistTemp end
	(*	| _ => printAssem instr*) else ()
 (* let
							val mynode = List.nth (nodes,i) 
							in moveList := tabRInserta (nodename mynode, (empty compAssem), !moveList) 
						end *)
	val live = union(live, getdef i)
	val _ = app (fn x =>( app (fn y => addEdge(x,y)) (getdef i))) live  
(*	val _ = print "esto es live:\n"
	val _ = app (fn x => print (x ^ "\n")) live
	val _ = print "esto es getdefi:\n"
	val _ = app (fn x => print (x ^ "\n")) (getdef i) *)
in build outsarray assems (i+1) (FGRAPH{control=control, def=def, use=use, ismove=ismove},nodes) end
| build _ [] _ _ = () 
handle Subscript => print "build:Subscript"

fun freezeMoves(u) = 
	let
		val _ = print ("freezeMoves: "^u^"\n")
		val conjNodeMoves = nodeMoves(u)
		val _ = printConjMoves conjNodeMoves ("nodeMoves("^u^")")
		fun auxFun m = 
			case m of MOVE {assem,dst,src} =>
				let
					val _ = print ("NodeMoves(u) -> MOVE: "^dst^","^src^"\n")	
					val v =  if String.compare(getAlias(dst), getAlias(u)) = EQUAL 
										then getAlias(src) else getAlias(dst) (*src = x ; dst = y*) 
				 val _ = print ("Alias: "^v^"\n")
					val miMoveList = tabSaca(v, !moveList) 
					val singM = singleton compAssem m
					(*val ismember = miMemberAssem(!activeMoves,m)
					val _ = print ("Ismember: "^Bool.toString(ismember)^"\n")
					val _ = printConjMoves miMoveList "mimovelist"
  			  val _ = printConjMoves (!activeMoves) "active" 
					val _ = printConjMoves singM "singM"
					val temp2 = miDelete(!activeMoves, m)
  			  val _ = printConjMoves (temp2) "TEMP2" 
					val tempActiveMoves = difference(!activeMoves, singM)
  			val _ = printConjMoves (tempActiveMoves) "TEMPACTIVEMOVES" *)
					val tempActiveMoves = miDelete(!activeMoves, m)
					val tempFrozenMoves = union(!frozenMoves, singM)
					val _ = activeMoves := tempActiveMoves
					val _ = frozenMoves := tempFrozenMoves
					val degreeV = tabSacaInt(v, !degree)
					val singV = singleton String.compare v
  			  val _ = printConjMoves (nodeMoves(v)) "NODEMOVES DE V" 
					val cond1 = isEmpty(nodeMoves(v))
					val cond2 = degreeV < k
					val _ = print ("cond1: "^Bool.toString(cond1)^"\n")
					val _ = print ("cond2: "^Bool.toString(cond2)^"\n")
					val _ = if cond1 andalso cond2 
										then 
											let
											 val _ = print "alias v entro\n"
												val tempFreeze = difference(!freezeWorklist, singV) 
												val	tempSimplify = union(!simplifyWorklist, singV) 
											in freezeWorklist := tempFreeze; simplifyWorklist := tempSimplify end
										else ()
					in () end
			| _ => ()
		val _ = app auxFun conjNodeMoves
	in () end

fun freeze() =
 let
	val u = List.hd(listItems(!freezeWorklist))
	val _ = printConj (!freezeWorklist) "freezeWorklist"
	val _ = print ("freeze: "^u^"\n")
	val singU = singleton String.compare u
	val _ = freezeMoves(u)
	val tempFreeze = difference(!freezeWorklist,singU)
	val tempSimplify = union(!simplifyWorklist,singU)
 in freezeWorklist := tempFreeze; simplifyWorklist := tempSimplify end
	handle Empty => print "freeze: Empty"		


fun selectSpill(assem ) = 
let
  val _ = print "SelectSpill\n" 	
	fun funAux1 ((OPER{assem = a, dst = d, src = s, jump = j}), accum) = (s @ d @ accum)
	| funAux1 ((MOVE{assem = a, dst = d, src = s}), accum) = (s::d::accum)
	| funAux1 ((LABEL{assem = a, lab=l}), accum) = accum
	val masterList = List.foldl funAux1 [] assem
(*	val _ = List.app (fn x => print ("masterlist: "^x^"\n")) masterList 
	val _ = List.app (fn x => print ("masterlives: "^x^"\n")) (!masterLives)*) 
	val _ = printConj (!spillWorklist) "spillWorklist"
	val _ = print "SelectSpill \n" 
	val max = ref(("string",0))
 
	fun nuevaFun (item, (temp,apar)) = let
		val num = (List.length(List.filter(fn x => String.compare(x, item) = EQUAL) (!masterLives) ))	
	  val _ = print ("("^item^","^Int.toString(num)^")\n")	
		val ret = if (num > apar) then (item, num) else (temp,apar)
		in ret end
		
	val (temp,num) = foldl nuevaFun ("temp",0)  (!spillWorklist)
	val _ = print ("Este spilleamos:::"^temp^"\n")
	(*fun funAux item =
		let
			val deg = tabSacaInt(item, !degree)
			val maxTemp = if #2(!max) > deg then !max else (item, deg)
			in max := maxTemp end
		val _ = app funAux (!spillWorklist)
	val m = #1(!max)  List.hd(listItems(!spillWorklist))  buscar heuristica*)
  val singM = singleton String.compare temp 
	val tempSpill = difference(!spillWorklist, singM)
	val tempSimplify = union(!simplifyWorklist, singM)
	val _ = freezeMoves(temp)
in spillWorklist := tempSpill; simplifyWorklist := tempSimplify end
	handle Empty => print "SelectSpill: Empty"		

fun assignColors() =
	case !selectStack of (x::xs) =>
		let 
			(*val selectConj = addList(empty String.compare, !selectStack)
			val _ = printConj selectConj "selectConj" *)
			val n = popStack()
			val _ = print ("AssignColors"^n^"\n") 
			val singN = singleton String.compare n
			val okColors =ref(addList(empty Int.compare, listaColors )) 
			val miAdjList = tabSacaConj(n, !adjList)
	(*		val _ = printConj (miAdjList) "lista adj"*)
			fun funAux(w) =
				let 
					(*val _ = print("getAlias de: "^w^"\n")*)
					val miAlias = getAlias(w)
					val nodosColoreados = union(!coloredNodes, !precolored)
					val _ = if member(nodosColoreados, miAlias)
									then 
										let
											val col = tabSaca(miAlias, !color)
											val okColorsAux = difference(!okColors, col)
										in okColors := okColorsAux end   
									else () (*print ("miAlias no coloreado:"^w^"\n")*)
				in () end
			val _ = app funAux miAdjList
			handle noExiste =>  print "assignColors1: noExiste"
			val _ = if isEmpty(!okColors) 
							then
								let 
									val _ = print ("----- NO color: "^n^"\n")
								  val spillNew = union(!spilledNodes, singN)
								in spilledNodes := spillNew end 
							else 
								let
									val miColored = union(!coloredNodes, singN)
									val miItem = List.hd(listItems(!okColors))
									val singM = singleton Int.compare miItem
(*									val _ = print ("inserto en color: "^n^"\n") *) 
								in color := tabRInserta(n, singM, !color); coloredNodes := miColored end
		handle Empty => print "okColors: Empty"		
		in assignColors() end	
	| [] => let 
						fun funAux n =
							let
								val miAlias = getAlias(n)
								val miColor = tabSaca(miAlias, !color)
							in color := tabRInserta(n, miColor, !color ) end
					in app funAux (!coalescedNodes) end
					handle noExiste =>  print "assignColors2: noExiste/n"


fun rewrite (assems, frame) = 
let 
	val _ = print "Rewrite \n"
	val setNewTemps = ref (empty String.compare)
	fun funAuxPrev (item_c:tigertemp.temp, assems) =
		let
			val _ = print ("TempSpilleado: "^item_c^"\n") 
			val access2 = tigerframe.allocLocal frame true (*no estoy seguro si es true o false*)
			val access = tigerframe.exp access2 (* tigercedegen.muchStm(tigerframe.exp access) no estoy seguro como seria esto*)
(*			val puntero = externalCall("_allocRecord", [1]) llamar a alloclocal con escape = true. se necesita pasar el frame a alloc local para saber cuanto bajar el stack en prologo  tigercodegen.codegen y epilogo. ver en el libro procentryexit3 *)
   (*   val _ = case access2 of
							(InFrame k) => print (Int.toString(k))
							| (InReg r) => print r
i*)
			val puntero = access
		(*	val puntero2 = MEM(BINOP(PLUS, TEMP FP, CONST 0) *)
		  fun moveIns (dst, src) = tigercodegen.codegen (tigertree.MOVE (dst, src)) 
(*			val _ = print ("Access: "^puntero^"\n")  *)
			fun fetch temp punt = moveIns (tigertree.TEMP temp,punt) (* MOVE{assem = "MOV 's0, ('d0) \n", dst = punt,  src = temp} *)
      fun store temp punt = moveIns (punt,tigertree.TEMP temp) (* MOVE{assem = "MOV ('s0), 'd0 \n", dst = temp, src = punt} *)
			fun getsrc ins = 
				let 
 					val src = case ins of		
									  (OPER{assem = a, dst = d, src = s, jump = j}) => addList (empty String.compare,s)	
  								| (MOVE{assem = a, dst = d, src = s}) => singleton String.compare s
									| (LABEL{assem = a, lab=l}) => (empty String.compare)
								(*	| _ => let val _ = print "error rewrite\n" in (empty String.compare) end*)
				in src end
			fun getdst ins = 
				let 
 					val dst = case ins of		
									  (OPER{assem = a, dst = d, src = s, jump = j}) => addList (empty String.compare, d)	
  								| (MOVE{assem = a, dst = d, src = s}) => singleton String.compare d
									| (LABEL{assem = a, lab=l}) => (empty String.compare) 
								(*	| _ => let val _ = print "error rewrite\n" in (empty String.compare) end*)
				in dst end
			fun replace(item,newtmp,src_dst) =
				let
			(*		val _ = print ("Replace: "^src_dst^" por "^newtmp^" si es igual a "^item^"\n") *)
					val ret = if String.compare(src_dst,item)=EQUAL then newtmp else src_dst (* basicamente sacar item y poner newtmp*)
			(*	val _ = print ("reemplazamos: "^ret^"\n") *)
				in ret end
	fun funAux (item:tigertemp.temp) preAssem (instr::postAssem) =
		let
		(*	val postAssem = List.tl(postAssem) *)
			val midef = getdst instr (* getdef(i) extraer de src *)
			val miuse = getsrc instr (* getuse(i) extraer de dst *)	 
			val (preAssem,miTemp) = if (member(miuse,item) orelse member(midef,item)) then (preAssem,tigertemp.newtemp()) else (preAssem @ [instr],"TERR") 
			val (preAssem,instr) = if member(miuse,item)
							then
								let
(*									val _ = printConj (miuse) "misrc"
								  val _ = print ("New Fetch Temp: "^miTemp^"\n") *)
								  val _ = setNewTemps := add(!setNewTemps,miTemp)  
								  val fetchIns = fetch miTemp puntero
								  val newI = case	instr of		
									  (OPER{assem = a, dst = d, src = s, jump = j}) =>
											let 
												val new_s = List.map (fn src_u => let val _ = print ("src: "^src_u^" ")
																													 in replace(item,miTemp,src_u) end ) s 
											in  (OPER{assem = a, dst = d, src = new_s, jump = j}) end 
  								| (MOVE{assem = a, dst = d, src = s}) => (MOVE{assem = a, dst = d, src = miTemp}) 		
									| _ => instr
									val assemsP = List.map (format (fn x=>x)) ([instr] @ fetchIns )
									val _ = List.map print assemsP
								in if member(midef, item) then (preAssem @ fetchIns,newI)  else (preAssem @ fetchIns @ [newI],instr) end
							else (preAssem,instr)   
			val preAssem = if member(midef,item)
							then
								let
			(*						val _ = printConj (midef) "midst"
								  val _ = print ("New Store Temp: "^miTemp^"\n")*)
									val _ = setNewTemps := add(!setNewTemps,miTemp)  
									val storeIns = store miTemp puntero
								  (*Tambien necesitamos reemplazar en la instruccion el temporario por el temporario nuevo *)
								  val newI = case	instr of		
									  (OPER{assem = a, dst = d, src = s, jump = j}) =>
											let 
												val new_d = List.map (fn dst_u => replace(item,miTemp,dst_u)) d 
											in  (OPER{assem = a, dst = new_d, src = s, jump = j}) end 
  								| (MOVE{assem = a, dst = d, src = s}) => (MOVE{assem = a, dst = miTemp, src = s}) 		
									| _ => instr
									val assemsP = List.map (format (fn x=>x)) ([instr,newI] @ storeIns)
									val _ = List.map print assemsP
							 in preAssem @ [newI] @ storeIns end
							else preAssem
		in funAux item preAssem postAssem end
			| funAux item preAssem [] = preAssem   

		in funAux item_c [] assems end  (*fin let de funAuxPrev *)
  val newAssems = foldl funAuxPrev assems (!spilledNodes)
  val _ = spilledNodes := (empty String.compare)
  val _ = initial := union(union(!coloredNodes,!coalescedNodes), !setNewTemps)
	val _ = coloredNodes := (empty String.compare)
  val _ = coalescedNodes := (empty String.compare)
	in newAssems 
end



fun main fgraph nodes assems frame =
let	
	val _ = precoloredInit()
(*	val _ = List.map (fn nod => print ("Nodes: "^nodename(nod)^"\n")) nodes *)
(*
	fun getuse index use = let val mynode = miEnesimo(nodes, index)
										  val _ = print ("que onda: "^nodename(mynode)^"\n")
											val uses = (case tabBusca (mynode, use) of SOME x=> x | NONE => [])
									in addList (empty String.compare, uses) end

(*	val _ = List.map (fn (FGRAPH {control, def, use, ismove}) => app (fn x => print ("Nodes: "^x^"\n")) (getuse 0 use) ) fgraph *)
	val _ = case fgraph of
		 (FGRAPH {control, def, use, ismove}) => if isEmpty( (getuse 0 use) ) then print "mpty\n"  else app (fn x => print ("Nodes: "^x^"\n")) (getuse 0 use) 
		| _ => print "nada\n" *)
val (insarray,outsarray) = livenessAnalisis(fgraph,nodes)
	val _ = build outsarray assems 0 (fgraph,nodes)
	handle Subscript => print "main: Subscript" 
	val _ = initialInit()	
	val _ = printConj (!initial) "initial"
	val _ = makeWorklist() 
	val _ = printTab2 (!color) "color"
	val _ = printTab3 (!degree) "degree"
	val _ = printTab (!moveList) "moveList"
	val uni = union(!spillWorklist, union(!simplifyWorklist,union(!freezeWorklist,!precolored))) (*Deberia ser igual a todas las entradas en degree y en color*)
	val _ = printConj uni "UNION"
	val _ = printConj (!spillWorklist) "spillWorklist"
	val _ = printConj (!simplifyWorklist) "simplifyWorklist"
	val _ = printConj (!freezeWorklist) "freezeWorklist" 
	val _ = printTab4 (!adjList) "adjList"
	val _ = printConjMoves (!worklistMoves) "worklistMoves"  
  val _ = printConjMoves (!activeMoves) "activeMoves" 
	val _ = printConj (addList (empty String.compare,!selectStack)) "Stack" 
	fun boolcond() =  isEmpty(!simplifyWorklist) andalso isEmpty(!freezeWorklist) andalso isEmpty(!worklistMoves) andalso isEmpty(!spillWorklist)  
	fun preAssign() = if not(isEmpty(!simplifyWorklist)) then simplify() 
                      (* let
												val _ = simplify() 
												val _ = printConj (!simplifyWorklist) "simplifyWorklist"
											in () end *)
										else (if not(isEmpty(!worklistMoves)) then coalesce() 
													else (if not(isEmpty(!freezeWorklist)) then freeze()
															 else	(if not(isEmpty(!spillWorklist)) then selectSpill(assems) else () )))
	val _ = preAssign()
  val condicion = ref(boolcond())
	(* val _ = print ("CONDICION: "^Bool.toString(!condicion)^"\n") *)
	val _ = printConj (!spillWorklist) "spillWorklist"
	val _ = printConj (!simplifyWorklist) "simplifyWorklist"
	val _ = printConj (!freezeWorklist) "freezeWorklist"
	val _ = printConjMoves (!worklistMoves) "worklistMoves" 
	val _ = printConj (!spilledNodes) "spilledNodes"
	val _ = printConj (!coalescedNodes) "coalescedNodes"
	val i = ref(0) 
	fun lengthList() =
		let 
			val numSim =  Int.toString(numItems (!simplifyWorklist))
			val numwor =  Int.toString(numItems (!worklistMoves))
			val numfre =  Int.toString(numItems (!freezeWorklist))
			val numSpi =  Int.toString(numItems (!spillWorklist))
			val _ = print ("num lists: "^numSim^" "^numwor^" "^numfre^" "^numSpi^"\n")
		in () end 
	val _ = while not(!condicion) do ( preAssign();condicion:=boolcond();i:=(!i)+1;print ("i:::"^Int.toString(!i)^"\n"); lengthList())
	val _ = assignColors()
	val _ = printConj (!spilledNodes) "spilledNodes"
	val assemsF = if not(isEmpty(!spilledNodes)) 
		then
			let (*val assemsP = List.map (format (fn x=>x)) assems
					val _ = List.map print assemsP*)
					val assemsNew = rewrite(assems, frame)
					val assemsP = List.map (format (fn x=>x)) assemsNew
					val _ = List.map print assemsP
					val (fgraphNew,nodesNew) = tigermakegraph.instrs2graph assemsNew
					val assemsNew2 = (main fgraphNew nodesNew assemsNew frame) 
			in assemsNew2 end
		else assems	
(*	val _ = printConj (!simplifyWorklist) "simplifyWorklist"
	val _ = printConj (!coalescedNodes) "coalescedNodes"
	val _ = printConj (!spillWorklist) "spillWorklist"
	val _ = printConj (!freezeWorklist) "freezeWorklist"
	val _ = printConjMoves (!worklistMoves) "worklistMoves"
  val _ = printConjMoves (!activeMoves) "activeMoves"
	val _ = printConjMoves (!coalescedMoves) "coalescedMoves"
	val _ = printConjMoves (!constrainedMoves) "constrainedMoves"
	val _ = printConjMoves (!frozenMoves) "frozenMoves"
	val _ = printConj (!spilledNodes) "spilledNodes"
	val _ = printConj (!coloredNodes) "coloredNodes"*)
	val _ = printTab2 (!color) "Color"
in assemsF end


