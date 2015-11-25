structure tigerregalloc :> tigerregalloc =
struct

open tigertab 
open tigerframe
open tigerassem 

type allocation = (tigerframe.register, int) tigertab.Tabla
fun alloc (assem, frame) = 
let
	val miTabla = ref(tabNueva())
	val misValoresInt = tigercolor.listaColors @ [14, 15] (* 14 y 15 representan fp y sp (precolored) *)
	val misClavesReg = ["RAX", "RBX" ,"RCX", "RDX", "R8", "R9", "R10", "R11", "R12", "R13", "R14", "R15","RSI","RDI", "RBP","RSP"]

	fun funAux item = miTabla := tabRInserta(List.nth(misClavesReg, item), item, !miTabla)
	val _ =  List.map funAux misValoresInt
in (assem, !miTabla	) end 
end
