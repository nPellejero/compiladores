signature tigerregalloc =
sig
	type allocation = (int,tigerframe.register) tigertab.Tabla
	val alloc : tigerassem.instr list * tigerframe.frame -> tigerassem.instr list * allocation 
	val saytemp :  allocation -> tigerassem.reg -> tigerassem.reg 
end

