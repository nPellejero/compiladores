
open tigertree
open tigerassem
open tigerframe
 
  val ilist = ref (nil: tigerassem.instr list)
	fun emit x = ilist := x :: !ilist
	fun result(gen) = let val t = tigertemp.newtemp() in gen t; t end
	fun result2(gen) = let val t = rv in gen t; t end


	(* munchExp::Tree.exp -> tigertemp.temp *)
fun munchExp(CONST i) = let	
		in 	
		if i > 0 
		then (*no estoy seguro de esta. 'd0 deberia tener 0*)
		result(fn r => emit(OPER{assem = "movq $"^(Int.toString i)^", 'd0 \n",
			src = [],
			dst = [r],
			jump = NONE})) 
		else	
		result(fn r => emit(OPER{assem = "movq $-"^(Int.toString (i*(~1)))^", 'd0 \n",
			src = [],
			dst = [r],
			jump = NONE})) 
		end
	|    munchExp(BINOP(MINUS,e1,e2)) =
		result(fn r => (emit(MOVE{assem =  "movq 's0, 'd0\n",
			src = munchExp(e1),
			dst = r
			});
			emit(OPER{assem = "subq 's0, 'd0\n",
				src = [munchExp(e2),r],
				dst = [r],
				jump= NONE})))
	|    munchExp(BINOP(DIV,e1,e2)) =
		result(fn r =>	
					(emit(MOVE{assem =  "movq 's0, 'd0\n",
      				src = munchExp(e1),
      				dst = rv
      		});
					emit(OPER{assem =  "movq $0, 'd0\n",
      				src = [],
      				dst = [rdx],
							jump = NONE
      		});
      emit(OPER{assem = "div 's0 \n",
        src = [munchExp(e2) ,rv],
        dst = [rv],
        jump= NONE});
      emit(MOVE{assem =  "movq 's0, 'd0\n",
        src = rv,
        dst = r
      })))
 (*(emit(MOVE{assem =  "movq 's0, 'd0\n",
			src = munchExp(e1),
			dst = r
			});
			emit(OPER{assem = "div 's0, 'd0\n",
				src = [munchExp(e2),r],
				dst = [r],
				jump= NONE})))*)
 |    munchExp(BINOP(MUL,e1,e2)) =
    result(fn r => (emit(MOVE{assem =  "movq 's0, 'd0\n",
      src = munchExp(e1),
      dst = rv
      });
      emit(OPER{assem = "mul 's0 \n",
        src = [munchExp(e2) ,rv],
        dst = [rv],
        jump= NONE});
      emit(MOVE{assem =  "movq 's0, 'd0\n",
        src = rv,
        dst = r
      })))
		|    munchExp(BINOP(PLUS,e1,e2)) =
		result(fn r => (emit(MOVE{assem =  "movq 's0, 'd0\n",
			src = munchExp(e1),
			dst = r
			});
			emit(OPER{assem = "addq 's0, 'd0\n",
				src = [munchExp(e2),r],
				dst = [r],
				jump= NONE})))
 |    munchExp(TEMP t) = t
 | munchExp (MEM(BINOP(PLUS,e1,CONST j))) = result (fn r =>
		if j > 0
		then
			 emit(OPER{assem="movq "^(Int.toString j)^"('s0), 'd0\n",
													dst = [r],
													src = [munchExp e1],
													jump = NONE})
		else		
				emit(OPER{assem="movq -"^(Int.toString (j*(~1)))^"('s0), 'd0\n",
													dst = [r],
													src = [munchExp e1],
													jump = NONE})
			)
	|	munchExp (MEM e) = result (fn r=> emit(OPER{assem="movq ('s0), 'd0\n",
													dst = [r],
													src = [munchExp e],
													jump = NONE}))

	|	munchExp (NAME l) = result (fn r=> emit(OPER{assem="movq $"^l^", 'd0\n",
														dst=[r],
														src=[],
														jump=NONE}))
	|	munchExp (CALL (NAME n,args)) =
			if String.compare(n,"_allocRecord") = EQUAL
			then
				result (fn r => (emit(OPER{assem = "movq $0, 'd0 \n", 
				  dst = [rv],
				  src = [],
					jump = NONE});
			emit(OPER{assem="call "^n^"\n",
						src=munchArgs (List.rev args),
						dst=callersaves,
						jump=NONE}) ))
		else
 		result2 ( fn r => emit(OPER{assem="call "^n^"\n",
						src=munchArgs (List.rev args),
						dst=callersaves,
						jump=NONE})) 
	|	munchExp exp = result (fn r=>emit(OPER{assem="NADA: "^(ppEXP exp)^"\n",src=[], dst=[], jump=NONE}))


(* munchStm::Tree.stm -> unit *)
and munchStm(SEQ(a, b)) = (munchStm a; munchStm b)(*primer stm*)
	(*comenzamos por el final, para ir de los arboles mas simples a los mas complejos. Feli dice: no es al reves? Ir de los mas complejos a los mas simples?*)
	|	munchStm (EXP(CALL (NAME n,args))) = (*Procedure*)
		if String.compare(n,"_allocRecord") = EQUAL
		then
			(emit(OPER{assem = "movq $0, 'd0 \n",              (*Esto es para funciones con arg variables como _allocLocal. Se pone 0 en rax para indicar que no hay args de punto flotante *)
				  dst = [rv],
				  src = [],
					jump = NONE});
			emit(OPER{assem="call "^n^"\n",
						src=munchArgs (List.rev args),
						dst=callersaves,
						jump=NONE}) )
		else
			emit(OPER{assem="call "^n^"\n",
						src=munchArgs (List.rev args),
						dst=callersaves,
						jump=NONE}) 
	|	munchStm (tigertree.MOVE(TEMP i, TEMP j)) =
			emit(MOVE{assem = "movq 's0, 'd0\n",
					dst = i,
					src = j})
	|	munchStm (tigertree.MOVE(TEMP i,CALL (NAME n,args))) = (*Function call*)
			(munchStm(EXP(CALL(NAME n,args)));
			emit(MOVE{assem = "movq 's0, 'd0 \n",
				  dst = i,
				  src = rv}))
	|	munchStm (tigertree.MOVE(MEM(TEMP i),CALL (NAME n,args))) = (*Function call*)
			(munchStm(EXP(CALL(NAME n,args)));
			emit(MOVE{assem = "movq 's0, ('d0) \n",
				  dst = i,
				  src = rv}))

	(*|   munchStm(tigertree.MOVE(MEM(BINOP(PLUS,e1,CONST j)),TEMP i)) =  emit(MOVE{assem = "movq 's0, " ^(Int.toString j) ^ "('d0)\n", 
			  dst = munchExp(e1),
			  src = i})  *)
 	|   munchStm(tigertree.MOVE(MEM(BINOP(PLUS,e1,CONST j)), e2)) = let
		val d0 = munchExp(e1)
		val s0 = munchExp(e2)
		in 	
		if j < 0 
		then	emit(OPER{assem = "movq 's0, -" ^(Int.toString (j*(~1)))^ "('d0)\n", 
				dst = [d0],
			  src = [s0, d0],
				jump = NONE })
		else	emit(OPER{assem = "movq 's0, " ^(Int.toString j)^ "('d0)\n", 
			  dst = [d0],
			  src = [s0, d0],
				jump = NONE})
		end
	|   munchStm(tigertree.MOVE(e2 , MEM(BINOP(PLUS,e1,CONST j)))) = let
		val s0 = munchExp(e1)
		val d0 = munchExp(e2)
		in
  	if j < 0 
		then	emit(OPER{assem = "movq -" ^(Int.toString (j*(~1)))^ "('s0), 'd0\n", 
				dst = [d0],
			  src = [s0],
				jump = NONE})
		else	emit(OPER{assem = "movq " ^(Int.toString j)^ "('s0), 'd0\n", 
			  dst = [d0],
			  src = [s0],
				jump = NONE })
		end
	|   munchStm(tigertree.MOVE(TEMP i, CONST j)) = 
		emit(OPER{assem = "movq $" ^ (Int.toString j) ^ ", 'd0 \n", (*Hay que cambiar los OPER por MOVE cuando sea necesario. Aca, por ejemplo, no lo es. ;P*)
			  dst = [i],
			  src = [],
			  jump = NONE})
	|   munchStm(tigertree.MOVE(TEMP i, e1)) =
		emit(MOVE{assem = "movq 's0, 'd0 \n",
			  dst = i,
			  src = munchExp(e1)}) 
	|   munchStm(tigertree.MOVE(MEM e0, e1)) =
		let val d0 = munchExp e0 in emit(OPER{assem = "movq 's0, ('d0) \n",
			  dst = [d0],
			  src = [munchExp e1,d0],
			  jump = NONE}) end
	|   munchStm(JUMP(NAME e,lls)) =	
		emit(OPER{assem = "jmp 'j0 \n",
			  dst = [],
			  src = [],
			  jump = SOME [e]})
	|   munchStm(CJUMP(EQ,e1,e2,l1,l2)) =
		emit(OPER{assem = "cmp 's0, 's1 \n"
				  ^ "je 'j0 \n",
			  dst = [],
			  src = [munchExp(e2),munchExp(e1)],
			  jump = SOME [l1,l2]})
	|   munchStm(CJUMP(NE,e1,e2,l1,l2)) =	
		emit(OPER{assem = "cmp 's0, 's1 \n"
				  ^ "jne 'j0 \n",
			  src = [munchExp(e2),munchExp(e1)],
			  dst = [],
			  jump = SOME [l1,l2]})
	|   munchStm(CJUMP(LT,e1,e2,l1,l2)) =	
		emit(OPER{assem = "cmp 's0, 's1 \n"
				  ^ "jl 'j0 \n",
			  src = [munchExp(e2),munchExp(e1)],
			  dst = [],
			  jump = SOME [l1,l2]})

	|   munchStm(CJUMP(GT,e1,e2,l1,l2)) =	
		emit(OPER{assem = "cmp 's0, 's1 \n"
				  ^ "jg 'j0 \n",
			  src = [munchExp(e2),munchExp(e1)],
			  dst = [],
			  jump = SOME [l1,l2]})

	|   munchStm(CJUMP(LE,e1,e2,l1,l2)) =	
		emit(OPER{assem = "cmp 's0, 's1 \n"
				  ^ "jle 'j0 \n",
			  src = [munchExp(e2),munchExp(e1)],
			  dst = [],
			  jump = SOME [l1,l2]})
	|   munchStm(CJUMP(GE,e1,e2,l1,l2)) =	
		emit(OPER{assem = "cmp 's0, 's1 \n"
				  ^ "jge 'j0 \n",
			  src = [munchExp(e2),munchExp(e1)],
			  dst = [],
			  jump = SOME [l1,l2]})
	|   munchStm(CJUMP(ULT,e1,e2,l1,l2)) =	
		emit(OPER{assem = "cmp 's0, 's1 \n"
				  ^ "jb 'j0 \n",
			  src = [munchExp(e2),munchExp(e1)],
			  dst = [],
			  jump = SOME [l1,l2]})
	|   munchStm(CJUMP(ULE,e1,e2,l1,l2)) =	
		emit(OPER{assem = "cmp 's0, 's1 \n"
				  ^ "jbe 'j0 \n",
			  src = [munchExp(e2),munchExp(e1)],
			  dst = [],
			  jump = SOME [l1,l2]})
	|   munchStm(CJUMP(UGT,e1,e2,l1,l2)) =	
		emit(OPER{assem = "cmp 's0, 's1 \n"
				  ^ "ja 'j0 \n",
			  src = [munchExp(e2),munchExp(e1)],
			  dst = [],
			  jump = SOME [l1,l2]})
	|   munchStm(CJUMP(UGE,e1,e2,l1,l2)) =	
		emit(OPER{assem = "cmp 's0, 's1 \n"
				  ^ "jae 'j0 \n",
			  src = [munchExp(e2),munchExp(e1)],
			  dst = [],
			  jump = SOME [l1,l2]})
	|   munchStm(tigertree.LABEL lab ) = 
		emit(LABEL{assem = lab ^ ": \n", lab=lab }) 
	|   munchStm(EXP(e)) = (munchExp e;())
	|	munchStm _ = emit (OPER{assem = "nada.\n",
				src	 = [], dst = [], jump = NONE})
	(* munchStm::Tree.stm -> unit *)
	(*comenzamos por las exp mas simples, que van "abajo" en el pattern matching*)

and munchArgs [] = []
		|munchArgs(arg::args) = let val temp = munchExp(arg)
										in (case (getArgForPos (List.length args)) of
														InReg reg => (emit(MOVE {assem = "movq 's0, 'd0\n",
																				dst = reg,
																				src = temp})														
																	;(reg :: munchArgs args))
														|InFrame _ => (emit(OPER {assem = "pushq 's0\n", (*medio hack*)
																						dst = [],
																						src = [temp],
																						jump = NONE})
																			;munchArgs args)
	     											)
									end

	

fun codegen (stm: tigertree.stm) : tigerassem.instr list =  (*Saque el argumento frame porque tenemos FP. Referirse a pagina 206 del Appel para mas detalles. Gracias, vuelva prontos.*)
 let 
	val ilist2 = ref (nil: tigerassem.instr list) (*Estas dos lineas las agrego Barufa, creo q estan bien...pero*)
	val _ = ilist := !ilist2 (*esta es la 2da, comentario de arriba*)
  val resul1 = munchStm stm
  val resul2 = rev(!ilist)
 in resul1;resul2
 end

fun codegen2 fragss =
let
(*  	val ilist2 = ref (nil: tigerassem.instr list)
	  val _ = ilist := !ilist2 *) 
  	fun aux2(PROC{body, frame}) = codegen body
		| aux2(STRING(l, "")) = [(LABEL{assem = l ^ ": \n", lab=l })]
		| aux2(STRING("", s)) = [(LABEL{assem = "\t"^s ^ "\n", lab="NINGUN LABEL" })]
		| aux2(STRING(l, s)) = [(LABEL{assem = l^":\n\t"^s^"\n", lab=l })]
		fun aux [] = []
			|aux (x::xs) = aux2 x @ aux xs

		fun aux3 [] = []
		| aux3(h::t) = (case h of
								(PROC {body,frame} :: instrs) => (SOME frame , procEntryExit2 (frame,aux h)  ) :: aux3 t
		|_ => (NONE ,aux h) :: aux3 t
		)
	in	aux3 fragss end

