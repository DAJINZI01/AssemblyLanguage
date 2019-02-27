; TASK1 用串传送指令，将data段中的第一个字符串复制到它后面的空间中
; TASK2 用串传送指令，将F000段中的最后16字符串复制到data段中

ASSUME CS:CODE, DS:DATA

DATA SEGMENT
	DB 'welcome to masm!'
	DB 16 DUP (0)
	DB 00H
DATA ENDS

STACK SEGMENT
	DB 16 DUP (0)
STACK ENDS

CODE SEGMENT
	START:
	
	;INITIATE DS
	MOV AX, DATA
	MOV DS, AX
	
	;CALL TASK1
	CALL TASK2
	
	
	; PRINT
	MOV SI, 0005H; 字符串首地址
	MOV DH, 0008H; 行号
	MOV DL, 0003H; 列号
	MOV CL, 02H; 颜色
	CALL SHOW_STR
	
	; MAIN RETURN
	MOV AX, 4C00H
	INT 21H
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TASK1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	TASK1:
		PUSH DS
		PUSH ES
		;INITIATE DS
		MOV AX, DATA
		MOV DS, AX
		;INITIATE ES
		;MOV AX, DATA+10H
		MOV ES, AX
		
		; MOVE
		MOV SI, 0000H
		MOV DI, 0010H
		CLD
		MOV CX, 0010H
		REP MOVSB
		
		POP ES
		PUSH DS
		RET
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TASK2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	TASK2:
		PUSH DS
		PUSH ES

		; INITIATE DS
		MOV AX, 0F000H
		MOV DS, AX
		; INITIATE ES
		MOV AX, DATA
		MOV ES, AX
		
		; SEND ARGS
		MOV DI, 000FH
		MOV SI, 0FFFFH
		MOV CX, 0010H
		STD; BACK
		REP MOVSB
		
	
		POP ES
		POP DS
		
		RET
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 屏幕显示字符串的子程序 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 参数 DH DL CL DS:SI
	; 返回值
	SHOW_STR:
		; 设置显存地址
		PUSH ES
		MOV AX, 0B800H
		MOV ES, AX
		; 通过行号和列号计算显存地址
		; 行号
		MOV AH, 00H
		MOV AL, DH
		MOV CH, 0A0H
		MUL CH
		MOV BX, AX
		; 列号
		MOV AH, 00H
		MOV AL, DL
		MOV CH, 02H
		MUL CH
		MOV DI, AX
		; 将字符串组合到显存中
		S:
		
			; 判断是否是0
			PUSH CX
			MOV CH, 00H
			MOV CL, [SI]
			JCXZ OK
			POP CX
			
			MOV AL, [SI]
			MOV ES:[BX][DI], AL
			MOV ES:[BX].01H[DI], CL
			
			INC SI
			ADD DI, 2
			JMP SHORT S
		OK:
			POP CX
			POP ES
			RET

CODE ENDS
END START