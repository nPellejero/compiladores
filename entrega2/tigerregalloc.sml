structure tigerregalloc :> tigerregalloc =
struct

open tigertab 
open tigerframe
open tigerassem 

type allocation = (tigerframe.register, int) tigertab.Tabla
fun alloc (arg1, arg2) = (arg1, tabNueva()) 
end
