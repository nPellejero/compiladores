signature tigercodegen = 
sig
	val codegen2 : tigerframe.frag list list -> (tigerframe.frame option * tigerassem.instr list) list
  val munchExp : tigertree.exp -> tigertemp.temp 
end
