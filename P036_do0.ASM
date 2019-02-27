; 中断类型码0 中断处理程序载入

ASSUME CS:CODE, DS:DATA

DATA SEGMENT
	DB 'Welcome to masm!\n div by zero', 0
DATA ENDS

CODE SEGMENT
	START:
	; copy do0 程序 到 0000:0200 之后
	; 使用串传送指令
	MOV AX, CS
	MOV DS, AX
	MOV AX, 0000H
	MOV ES, AX
	
	MOV SI, OFFSET DO0
	MOV DI, 0200H
	CLD
	MOV CX, OFFSET DO0END - OFFSET DO0
	REP MOVSB
	; 修改中断类型码0号的中断向量表表项 为 0000:0200
	MOV AX, 0000H
	MOV DS, AX
	MOV BX, 0000H
	MOV WORD PTR [BX], 0200H
	MOV WORD PTR 2[BX], 0000H
	
	; main return
	MOV AX, 4C00H
	INT 21H
	
	; do0 程序 这个程序没有返回
	DO0:
		; 在代码段中存放数据
		JMP SHORT DO0START
		DB 'Welcome to masm! div by zero', 0
		DO0START:
			; print 'Welcome to masm!'
			MOV AX, CS
			MOV DS, AX
			MOV SI, 0202H; 字符串首地址
			MOV DH, 0008H; 行号
			MOV DL, 0003H; 列号
			MOV CL, 04H; 颜色
			CALL SHOW_STR
		
			; dO0 return
			MOV AX, 4C00H
			INT 21H
		
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
	DO0END:
		NOP

CODE ENDS

END START