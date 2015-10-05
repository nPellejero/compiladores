signature tigerregalloc =
sig
	type allocation = (tigerframe.register, int) tigertab.Tabla
	val alloc : tigerassem.instr list * tigerframe.frame -> tigerassem.instr list * allocation 
end

