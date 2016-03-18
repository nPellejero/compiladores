structure tigerregalloc :> tigerregalloc =
struct

open tigertab 
open tigerframe
open tigerassem 
open tigercolor

type allocation = (int, tigerframe.register) tigertab.Tabla


(*val listaColors = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]*)

fun alloc (assem) = 
let
(* frame es frame option
hay que llamar a color aca
iterar
y luego rewrite *)
	val miTabla = ref(tabNueva())
	val misValoresInt = listaColors @ [8,9,10,11,12,13,14, 15] (* 14 y 15 representan fp y sp (precolored) *)
(*	val misClavesReg = ["RAX", "RBX" ,"RCX", "RDX", "R8", "R9", "R10", "R11", "R12", "R13", "R14", "R15","RSI","RDI", "RBP","RSP"] *)
	val misClavesReg = ["RAX", "RBX" , "R10", "R11", "R12", "R13", "R14", "R15","RSI","RDI","RCX","RDX","R8","R9","RBP","RSP"]
(* del 0 al 7 son de uso general, del 8 al 13 son argumentos y 14 a 15 calle saves *)

	fun funAux item = miTabla := tabRInserta(item, List.nth(misClavesReg, item), !miTabla)
	val _ =  List.map funAux misValoresInt
in (assem, !miTabla	) end 

fun saytemp tabreg t = 
let
	val _ = print ("TEMP -> REG: "^t^" -> ")
	val colorConj = tabSaca(t,!color)
			handle noExiste => let val _ = print (t^" No tiene color\n")
														in (empty Int.compare) end
	val col = List.hd(listItems(colorConj))
			handle Empty => let val _ = print "(no debe pasar) saytemp: Empty\n" 
													in 0 end
	val reg = tabSaca(col,tabreg)
			handle noExiste => let val _ = print (Int.toString(col)^" No tiene registro ese color\n")
														in "ERR" end
	val _ = print (reg^"\n")
in reg end

end 
