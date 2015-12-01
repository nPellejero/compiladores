structure tigerregalloc :> tigerregalloc =
struct

open tigertab 
open tigerframe
open tigerassem 

type allocation = (tigerframe.register, int) tigertab.Tabla


val listaColors = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]

fun alloc (assem, frame) = 
let
	val miTabla = ref(tabNueva())
	val misValoresInt = listaColors @ [14, 15] (* 14 y 15 representan fp y sp (precolored) *)
	val misClavesReg = ["RAX", "RBX" ,"RCX", "RDX", "R8", "R9", "R10", "R11", "R12", "R13", "R14", "R15","RSI","RDI", "RBP","RSP"]

	fun funAux item = miTabla := tabRInserta(List.nth(misClavesReg, item), item, !miTabla)
	val _ =  List.map funAux misValoresInt
in (assem, !miTabla	) end 

fun saytemp instruc = 
let
	val _ = print "hacer algo\n"
in instruc end

end 
