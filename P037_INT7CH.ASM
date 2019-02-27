; 编写、安装中断7CH的中断程序
; 功能：求一 word 型数据平方
; 参数：AX
; 返回值：DX AX
; 应用举例：求 2*3456^2
;
; 编写、安装中断7CH的中断程序
; 功能：讲一个全是字母，以0结尾的字符串转化为大写
; 参数：DS:SI
;
; 编写、安装中断7CH的中断程序
; 功能：显示一个用0结束的字符串
; 参数：DH DL CL DS:SI
;
;
ASSUME CS:CODE, SS:STACK

STACK SEGMENT
	DB 16 DUP (0)
STACK ENDS

CODE SEGMENT
	START:
		MOV AX, STACK
		MOV SS, AX
		MOV SP, 0010H
		
		; COPY TO 0000:0200
		MOV AX, CS
		MOV DS, AX
		MOV AX, 0000H
		MOV ES, AX
		
		MOV SI, OFFSET SHOW_STR
		MOV DI, 0200H
		CLD
		MOV CX, OFFSET SHOW_STR_END - OFFSET SHOW_STR
		REP MOVSB
		; REWRITE 0000:01F0 - 0000:01F2
		MOV AX, 0000H
		MOV DS, AX
		MOV BX, 01F0H; 7CH*4
		MOV WORD PTR [BX], 0200H
		MOV WORD PTR [BX].02H, 0000H
		; MAIN RETURN
		MOV AX, 4C00H
		INT 21H
		
		
	;;;;;;;;;;;;;;;;;;;;; word 型数据平方 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 功能：求一 word 型数据平方
	; 参数：AX
	; 返回值：DX AX
	; 应用举例：求 2*3456^2
	DOUBLE_AX:
		MUL AX;
		IRET
	DOUBLE_AX_END:
		NOP
	;;;;;;;;;;;;;;;;;;;;; 将一个全是字母，以0结尾的字符串转化为大写 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	; 编写、安装中断7CH的中断程序
	; 功能：讲一个全是字母，以0结尾的字符串转化为大写
	; 参数：DS:SI
	LITTER_TO_BIG:
		S:
			CMP BYTE PTR [SI], 00H
			JE RETURN
			AND BYTE PTR [SI], 5FH
			INC SI
			JMP S
		RETURN:
			IRET
	LITTER_TO_BIG_END:
		NOP
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 显示一个用0结束的字符串 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 功能：显示一个用0结束的字符串
	; 参数：DH DL CL DS:SI
	SHOW_STR:
		MOV AX, 0B800H
		MOV ES, AX
		MOV AX, 00A0H
		MUL DH
		MOV DI, AX
		MOV AX, 0002H
		MUL DL
		ADD DI, AX
		
		S_STR:
			CMP BYTE PTR [SI], 00H
			JE S_STR_RETURN
			MOV AL, BYTE PTR [SI]
			MOV ES:[DI], AL;
			MOV BYTE PTR ES:[DI].01H, CL
			INC SI
			ADD DI, 0002H
			JMP S_STR
		S_STR_RETURN:
			IRET
		
	SHOW_STR_END:
		NOP
	
	
CODE ENDS
END START