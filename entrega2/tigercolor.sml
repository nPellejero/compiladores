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
fun tupleCompare ((a,b),(c,d)) = if (String.compare(a,c)=EQUAL andalso String.compare(b,d)=EQUAL) then EQUAL else GREATER

fun compAssem ((OPER{assem = a1, dst = d1,src = s1, jump = j1}), (OPER{assem = a2, dst = d2, src = s2, jump = j2})) =
					if a1 = a2 andalso d1 = d2 andalso s1 = s2 andalso j1 = j2 
							then EQUAL else GREATER 

|	 compAssem ((OPER{assem = a1, dst = d1,src = s1, jump = j1}), _) = GREATER
|	 compAssem ((LABEL{assem = a1, lab = l1}), (LABEL{assem = a2, lab = l2})) =
					if a1 = a2 andalso l1 = l2 
							then EQUAL else GREATER
|	 compAssem ((LABEL{assem = a1, lab = l1}), _) =  GREATER
|	 compAssem ((MOVE{assem = a1, dst = d1, src = s1}), (MOVE{assem = a2, dst = d2, src = s2}))= 
					if  a1 = a2 andalso d1 = d2 andalso s1 = s2 then EQUAL else GREATER
|	 compAssem ((MOVE{assem = a1, dst = d1, src = s1}), _) = GREATER 

val precolored_init = [fp,sp,rv,ov]
val listaColors = [0, 1, 2, 3]
val k = 4
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
	val prec = addList (empty String.compare, precolored_init)
in precolored := prec 
end

fun initialInit() =
let
	val conjTmpReg = addList((empty String.compare), (tabClaves(!adjList)))
	val init = difference(conjTmpReg,(!precolored))
  (*fun funAuxD n = degree := tabRInserta(n,0,!degree)
  val _ = app funAuxD conjTmpReg*)
	fun funPreC i = color := tabRInserta(List.nth(precolored_init,i),singleton Int.compare i,!color)
  val _ = app funPreC (addList(empty Int.compare, listaColors)) 
  fun funAux n = color := tabRInserta(n,empty Int.compare,!color)
	val _ = app funAux init
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
	 handle noExiste =>  empty String.compare (*no esta mal.pasa cuando n es precol.*) 

fun nodeMoves n = let
		(*	val _ = print ("node: "^n^"\n") *)
				val miMoveList = tabSaca(n, !moveList) 
			  handle noExiste => let
														val vacio = empty compAssem 
														val _ =  print ("nodeMoves: "^n^" -> noExiste\n")
													 in vacio end	
				val conjInter = intersection(miMoveList,union(!activeMoves,!worklistMoves)) 
				in conjInter end

fun moveRelated n = isEmpty(nodeMoves n)

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
								val sing = singleton String.compare m
								val uni  = union(sing, adjacent(m))
								val _ = enableMoves(uni)	
								val miSpill = difference(!spillWorklist, sing)
								val _ = if (moveRelated(m))
															then  freezeWorklist := add(!freezeWorklist,m) 
															else simplifyWorklist := add(!simplifyWorklist,m)
							in spillWorklist := miSpill end
						else ()
	in degree := tabRInserta(m, d-1, !degree) end  
		

fun simplify() = 
	let
		val _ = print "Simplify\n" 
		fun justAux(n) = 
			let
				val justAuxWorklist = delete(!simplifyWorklist, n)
				val _ = pushStack(n)
				val _ = app decrementDegree	(adjacent(n))		
			in simplifyWorklist := justAuxWorklist end  
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
										val init_n = delete((!initial),x)
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

fun combine(u, v) =
	let
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
																val _ = print "combine: noExiste"
															in empty  compAssem end
						val miNodeMoves = union(arg1, arg2)
					in alias := tabRInserta(v, u, (!alias)); moveList := tabRInserta(u, miNodeMoves, (!moveList)) end
	val _ = enableMoves(singV)
	val _ = app (fn t => (addEdge(t, u); decrementDegree(t))) (adjacent v)
	val degU = tabSaca(u, (!degree)) 
	handle noExiste => let 
												val _ = print "combine: noExiste"
											in 0 end
	val _ = if degU >= k andalso member(!freezeWorklist, u)
					then 
						let 
							val auxFreeze = difference(!freezeWorklist, singU)
							val auxSpill  = union(!spillWorklist, singU)
						in freezeWorklist := auxFreeze; spillWorklist := auxSpill end else ()
	in () end

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
																			else activeMoves := union(!activeMoves, singM)
															in () end
		
						in worklistMoves := tempWork end
						| _ => print "coalesce: estamo al horno" 
in () end
	handle Empty => print "coalesce: Empty"		


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
				val mynode = List.nth (nodes,i)
				fun myFunAux item =
						let 
							val myMoveList = tabSaca(item, (!moveList))
							handle noExiste => empty compAssem (*let
														 		val _ =print "build: noExiste\n"
																in empty compAssem end*)
							val _ = print ("Build moveList:"^dst^","^src^"\n")
							val myConj = union(myMoveList, singleton compAssem instr)
				  	in moveList := tabRInserta(item, myConj, (!moveList)) end
				val _ = app myFunAux (union(getdef(i), getuse(i)))
				handle noExiste => () (* print "build22: noExiste \n" *)
				val worklistTemp = union(!worklistMoves, singleton compAssem instr)
			  in worklistMoves := worklistTemp end
		| _ => () (* let
							val mynode = List.nth (nodes,i) 
							in moveList := tabRInserta (nodename mynode, (empty compAssem), !moveList) 
						end *)
	val live = union(live, getdef i)
	val _ = app (fn x =>( app (fn y => addEdge(x,y)) (getdef i))) live  
(*	val _ = print "esto es live:\n"
	val _ = app (fn x => print (x ^ "\n")) live
	val _ = print "esto es getdefi:\n"
	val _ = app (fn x => print (x ^ "\n")) (getdef i)*)
in build outsarray assems (i+1) (FGRAPH{control=control, def=def, use=use, ismove=ismove},nodes) end
| build _ [] _ _ = () 

fun printConjMoves conjToPrint nombre = 
	let
		val _ = print("\n esto es: "^nombre^"\n { ")	
		fun printMoves m = 
			case m of MOVE{assem, dst, src} => print ("MOVE: "^dst^","^src^"\n")				
			| _ => print "estamo al horno"
		val _ = app printMoves conjToPrint
		val _ = print "}\n"
	in () end

fun freezeMoves(u) = 
	let
		val _ = print ("freezeMoves: "^u^"\n")
		val conjNodeMoves = nodeMoves(u)
		val _ = printConjMoves conjNodeMoves ("nodeMoves("^u^")")
		fun auxFun m = 
			case m of MOVE{assem , dst, src} =>
				let
					val _ = print ("NodeMoves(u) -> MOVE: "^dst^","^src^"\n")	
					val v =  if String.compare(getAlias(src), getAlias(dst)) = EQUAL 
										then getAlias(src) else getAlias(dst) (*src = x ; dst = y*) 
					val singM = singleton compAssem m
					val tempActiveMoves = difference(!activeMoves, singM)
					val tempFrozenMoves = union(!frozenMoves, singM)
					val degreeV = tabSacaInt(v, !degree)
					val singV = singleton String.compare v
					val _ = if isEmpty(nodeMoves(v)) andalso degreeV < k 
										then 
											let
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
	val _ = print ("freeze: "^u^"\n")
	val singU = singleton String.compare u
	val tempFreeze = difference(!freezeWorklist,singU)
	val tempSimplify = union(!simplifyWorklist,singU)
	val _ = freezeMoves(u)
 in freezeWorklist := tempFreeze; simplifyWorklist := tempSimplify end
	handle Empty => print "freeze: Empty"		

fun printConj conjToPrint nombre = 
	let
		val _ = print("\n esto es: "^nombre^"\n {")	
		val _ = app (fn x => (print x;(print " ,"))) conjToPrint
		val _ = print "}\n"
	in () end

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


fun selectSpill(assem ) = 
let
	
	fun funAux1 ((OPER{assem = a, dst = d, src = s, jump = j}), accum) = (s @ d @ accum)
	| funAux1 ((MOVE{assem = a, dst = d, src = s}), accum) = (s::d::accum)
	| funAux1 ((LABEL{assem = a, lab=l}), accum) = accum
	val masterList = List.foldl funAux1 [] assem
	val _ = printConj (!spillWorklist) "spillWorklist"
	val _ = print "SelectSpill \n" 
	val max = ref(("string",0))
 
	fun nuevaFun (item, (temp,apar)) = let
		val num = (List.length(List.filter(fn x => String.compare(x, item) = EQUAL) masterList ))	
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
			val _ = print "AssignColors \n" 
			val n = popStack()
			val singN = singleton String.compare n
			val okColors =ref(addList(empty Int.compare, listaColors )) 
			val miAdjList = tabSacaConj(n, !adjList)
			fun funAux(w) =
				let 
					val miAlias = getAlias(w)
					val nodosColoreados = union(!coloredNodes, !precolored)
					val _ = if member(nodosColoreados, miAlias)
									then 
										let
											val col = tabSaca(miAlias, !color)
											val okColorsAux = difference(!okColors, col)
										in okColors := okColorsAux end   
									else ()
				in () end
			val _ = app funAux miAdjList
			handle noExiste =>  print "assignColors1: noExiste"
			val _ = if isEmpty(!okColors) 
							then
								spilledNodes := union(!spilledNodes, singN)
							else 
								let
									val miColored = union(!coloredNodes, singN)
									val miItem = List.hd(listItems(!okColors))
									val singM = singleton Int.compare miItem
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
(*
fun rewrite (assems, frame) = 
	let 

	fun funAuxPrev item =
		let 
			val access = Frame.allocLocal frame true (*no estoy seguro si es true o false*)
(*			val puntero = externalCall("_allocRecord", [1]) llamar a alloclocal con escape = true. se necesita pasar el frame a alloc local para saber cuanto bajar el stack en prologo y epilogo. ver en el libro procentryexit3 *)
		  fun moveInsn (dst, src) = ()
      fun store temp punt = moveInsn (punt, temp)
      fun fetch temp punt = moveInsn (temp,punt)
	

	fun funAux item assemL puntero i =
		let
			val midef = (* getdef(i) extraer de src *)
			val miuse = (* getuse(i) extraer de dst *)	 
			val assemTemp = if member(item, midef)
							then
								let
									val miTemp = Frame.newtemp()
								  val storeIns = store miTemp puntero
								  (*Tambien necesitamos reemplazar en la instruccion el temporario por el temporario nuevo *)
									val (preAssem,I,postAssem) = (List.take(assemL, i),List.nth(assemL,i),List.drop(assem, i+1)) 
								  val newI = case	I of		
									  (OPER{assem = a, dst = d, src = s, jump = j}) =>
											app (fn dst_u => replace(item,miTemp,dst_u)) dst (* dst es conjunto de conjuntos o algo asi*)		
  								| (MOVE{assem = a, dst = d, src = s}) => 
											replace(item,miTemp,dst)
							 in preAssem @ [storeIns] @ I @ postAssem end
							else assemL 
			val assemTemp = if member(item, miuse)
							then
								let
									val miTemp = newtemp()
								  val fetchIns = fetch miTemp puntero
								  val (preAssem,postAssem) = (List.take(assemL, i-1), List.drop(assem, i-1))
								in preAssem @ [fetchIns] @ postAssem end
							else assemL
  		in funAux item assemTemp puntero (i+1)  end
			
		in funAux item assem puntero 0 end
	
	in app funAuxPrev (!spillNodes) end
*)
fun main fgraph nodes assems =
let	
	val _ = precoloredInit()
	val (insarray,outsarray) = livenessAnalisis(fgraph,nodes)
	val _ = build outsarray assems 0 (fgraph,nodes)
	val _ = initialInit()	
	val _ = makeWorklist() 
	val _ = printTab2 (!color) "color"
	val _ = printTab3 (!degree) "degree"
	val _ = printConj (!spillWorklist) "spillWorklist"
	val _ = printConj (!simplifyWorklist) "simplifyWorklist"
	val _ = printTab (!moveList) "moveList"
	val _ = printConj (!freezeWorklist) "freezeWorklist" 
	(*val _ = printTab4 (!adjList) "adjList"*)
	val _ = printConjMoves (!worklistMoves) "worklistMoves"  
  val _ = printConjMoves (!activeMoves) "activeMoves"
	fun boolcond() =  isEmpty(!simplifyWorklist) andalso isEmpty(!freezeWorklist) andalso isEmpty(!worklistMoves) andalso isEmpty(!spillWorklist)  
	fun preAssign() = if not(isEmpty(!simplifyWorklist)) then simplify() else 
						 if not(isEmpty(!worklistMoves)) then coalesce() else  
						 if not(isEmpty(!freezeWorklist)) then freeze() else 
						if not(isEmpty(!spillWorklist)) then selectSpill(assems) else ()
	val _ = preAssign()
  val condicion = ref(boolcond())
	val _ = print ("CONDICION: "^Bool.toString(!condicion)^"\n") 
	val _ = printConj (!spillWorklist) "spillWorklist"
	val _ = printConj (!simplifyWorklist) "simplifyWorklist"
	val _ = printConj (!freezeWorklist) "freezeWorklist"
	val _ = printConjMoves (!worklistMoves) "worklistMoves" 
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
	val _ = printConj (!simplifyWorklist) "simplifyWorklist"
	val _ = printConj (!spillWorklist) "spillWorklist"
	val _ = printConj (!freezeWorklist) "freezeWorklist"
	val _ = printConjMoves (!worklistMoves) "worklistMoves"
  val _ = printConjMoves (!activeMoves) "activeMoves"
	val _ = printConjMoves (!coalescedMoves) "coalescedMoves"
	val _ = printConjMoves (!constrainedMoves) "constrainedMoves"
	val _ = printConjMoves (!frozenMoves) "frozenMoves"
	val _ = printConj (!spilledNodes) "spilledNodes"
	val _ = printConj (!coloredNodes) "coloredNodes"
	val _ = printTab2 (!color) "color"
in (insarray, outsarray, adjSet) end

