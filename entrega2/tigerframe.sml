(*
	Frames para el 80386 (sin displays ni registers).

		|    argn    |	fp+4*(n+1)
		|    ...     |
		|    arg2    |	fp+16
		|    arg1    |	fp+12
		|	fp level |  fp+8
		|  retorno   |	fp+4
		|   fp ant   |	fp
		--------------	fp
		|   local1   |	fp-4
		|   local2   |	fp-8
		|    ...     |
		|   localn   |	fp-4*n
*)

structure tigerframe :> tigerframe = struct

open tigertree
type level = int

val fp = "FP"				(* frame pointer *)
val rax = "RAX"				(* para DIV y MUL *)
val rdx = "RDX"				(* para DIV y MUL *)
val sp = "SP"				(* stack pointer *)
val rv = "RV"				(* return value  *)
val ov = "OV"				(* overflow value (edx en el 386) *)
val wSz = 8					(* word size in bytes *)
val alignStack = 16 (* stack align on 64 bit -> convention *) 
val log2WSz = 3			(* base two logarithm of word size in bytes *)
val fpPrev = 0				(* offset (bytes) *)
val fpPrevLev = 8			(* offset (bytes) *)
val argsInicial = 0			(* words *)
val argsOffInicial = ~1		(* words *)
val argsGap = alignStack			(* bytes *)
val regInicial = 1			(* reg *)
val localsInicial = 0		(* words *)
val localsGap = 0 			(* bytes *)
val calldefs = [rv]
val specialregs = [rv, fp, sp]
val argregs = ["ARG1","ARG2", "ARG3", "ARG4", "ARG5", "ARG6" ] (*Feli was here*)
val callersaves = []
val calleesaves = []

type frame = {
	name: string,
	formals: bool list,
	locals: bool list,
	actualArg: int ref,
	actualLocal: int ref,
	actualReg: int ref,
	cantRewrites: int ref
(*	listArgs: access list ref *)
}
type register = string
datatype access = InFrame of int | InReg of tigertemp.label
datatype frag = PROC of {body: tigertree.stm, frame: frame}
	| STRING of tigertemp.label * string
fun newFrame{name, formals} = {
	name=name,
	formals=formals,
	locals=[],
	actualArg=ref argsInicial,
	actualLocal=ref localsInicial,
	actualReg=ref regInicial,
	cantRewrites= ref(0)
	(*listArgs=ref([])*)
}
fun setCantRewrites(f: frame, i) = let
													val _ = #cantRewrites f := i
														in true end

fun name(f: frame) = #name f
fun string(l, s) = l^tigertemp.makeString(s)^"\n"
val argregslength = List.length(argregs)
fun getArgForPos n = if (n<argregslength) then
						InReg (List.nth(argregs,n)) else
						InFrame ((n-argregslength)*wSz+argsGap)

fun formals({formals=f, ...}: frame) = 
	List.tabulate (List.length(f)+1, getArgForPos) (* +1 por el FP*)

fun formals_ORI({formals=f, ...}: frame) = 
	let	fun aux(n, []) = []
		| aux(n, h::t) = InFrame(n)::aux(n+argsGap, t)
	in aux(argsInicial, (true :: f)) end


fun maxRegFrame(f: frame) = !(#actualReg f)
fun allocArg (f: frame) b = 
	case b of
	true =>
		let	val ret = (!(#actualArg f)+argsOffInicial)*wSz
			val _ = #actualArg f := !(#actualArg f)-1
(*			val _ = #listArgs f := !(#listArgs f) ++ [InFrame ret] *)
		in	InFrame ret end
	| false => InReg(tigertemp.newtemp())
				(*	let
						val miTemp = tigertemp.newtemp()
						val _ = #listArgs f := !(#listArgs f) ++ [InReg(miTemp)]
					in 	InReg(miTemp) end *)

fun allocLocal (f: frame) b = 
	case b of
	true =>
		let	val ret = InFrame(((!(#actualLocal f))+(!(#actualArg f)))*wSz)
		in	#actualLocal f:=(!(#actualLocal f)-1); ret end
	| false => InReg(tigertemp.newtemp())

fun expRW(InFrame k) = MEM(BINOP(PLUS, TEMP(fp), CONST (~k)))
	| expRW(InReg l) = TEMP l

fun exp(InFrame k) = MEM(BINOP(PLUS, TEMP(fp), CONST k))
	| exp(InReg l) = TEMP l
fun externalCall(s, l) = CALL(NAME s, l)

fun procEntryExit1 (frame,body) = body

fun procEntryExit2 (frame,body) = body @ [tigerassem.OPER {assem = "",
															src = [rv]@calleesaves,
															dst = [],
															jump = NONE }]
(*fun makeProlog({name, formals, locals, actualArg, actualLocal, actualReg}:frame) = 
	let
		val lab = tigerassem.LABEL{assem=name, lab= tigertemp.newlabel() }
	in "PROCEDURE: "^name end

fun makeEpilog({name, formals, locals, actualArg, actualLocal, actualReg}:frame) = let
		val lab = tigerassem.LABEL{assem=name, lab= tigertemp.newlabel() }
	in "END:"^name end
*)

fun procEntryExit3 (frame: frame, body) = let
	val cantRewrites = #cantRewrites frame 
	val cantString = Int.toString(((!cantRewrites)+1)*wSz+alignStack)
	val miLab = List.hd(body)
	val lab = case miLab of
					tigerassem.LABEL{assem = a, lab = l} => l
					|  _ => "Error Label"
	val prolog =  [tigerassem.OPER {assem = "pushq %rbp\nmovq %rsp, %rbp\nsubq $"^cantString^", %rsp\njmp 'j0\n",
															src = [],
															dst = [],
															jump = SOME [lab] }](* makeProlog(frame)*)
	val body = body
	val epilog = [tigerassem.OPER {assem = "leave\nret\n",
															src = [],
															dst = [],
															jump = NONE }] (*makeEpilog(frame)*)
in prolog @ body @ epilog  end
(*
fun procEntryExit3_libro (frame, body) = let
	val prolog = makeProlog(frame)
	val body = body
	val epilog = makeEpilog(frame)
in {prolog=prolog,body=body,epilog=epilog}end
*)
end
