open Array
open Splayset 
open tigertab
open tigerframe
open tigerliveness

(*
val precolored = empty tigerframe.register
*)

fun main fgraph nodes =
let	
	val adjSet = tabNueva()
	val (insarray,outsarray) = livenessAnalisis(fgraph,nodes)
in (insarray, outsarray, adjSet) end





