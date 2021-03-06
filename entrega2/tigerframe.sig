signature tigerframe =
sig

type frame
type register = string
val rv : tigertemp.temp
val r10 : tigertemp.temp
val r11 : tigertemp.temp
val r12 : tigertemp.temp
val r13 : tigertemp.temp
val rbx : tigertemp.temp
val r14 : tigertemp.temp
val r15 : tigertemp.temp
val rax : tigertemp.temp
val rdx : tigertemp.temp
val ov : tigertemp.temp
val fp : tigertemp.temp
datatype access = InFrame of int | InReg of tigertemp.label
val fpPrev : int
val fpPrevLev : int
val newFrame : {name: tigertemp.label, formals: bool list} -> frame
val name : frame -> tigertemp.label
val string : tigertemp.label * string -> string
val formals : frame -> access list
val allocArg : frame -> bool -> access
val allocLocal : frame -> bool -> access
val sp : tigertemp.temp
val maxRegFrame : frame -> int
val setCantRewrites : frame * int -> bool
val wSz : int
val log2WSz : int
val calldefs : tigertemp.temp list
val callersaves : tigertemp.temp list
val calleesaves : tigertemp.temp list
val extraRegs : tigertemp.temp list
val exp : access -> tigertree.exp
val expRW : access -> tigertree.exp
val externalCall : string * tigertree.exp list -> tigertree.exp
val externalCallArgs_variables : string * tigertree.exp list -> tigertree.exp
val procEntryExit1 : frame * tigertree.stm -> tigertree.stm
val procEntryExit2 : frame * tigerassem.instr list -> tigerassem.instr list
val procEntryExit3 : frame * tigerassem.instr list -> tigerassem.instr list
datatype frag = PROC of {body: tigertree.stm, frame: frame}
	| STRING of tigertemp.label * string
val getArgForPos : int -> access
val argregs : tigertemp.temp list

end
