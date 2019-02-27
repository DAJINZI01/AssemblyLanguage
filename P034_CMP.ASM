; 编程：统计data段中数值为8的字节的个数，用AX保存统计结果

ASSUME CS:CODE, DS:DATA

DATA SEGMENT
	DB 8, 11, 8, 1, 8, 5, 63, 38, 0, 0
DATA ENDS

CODE SEGMENT
	
	START:
	; INITIATE DS
	MOV AX, DATA
	MOV DS, AX
	
	MOV CX, 0008H
	MOV AX, 0000H; INITIATE AX 0
	MOV BX, 0000H; ADDRESS
	S2:
		MOV DL, [BX]
		CMP DL, 08H
		JE ADDAX
		JMP INCBX
		ADDAX:
			INC AX
		INCBX:	
			INC BX
		LOOP S2
	
	; PRINT SCREEN
	ADD AX, 0030H
	MOV DS:[08H], AX;
	MOV SI, 0008H; 字符串首地址
	MOV DH, 0008H; 行号
	MOV DL, 0003H; 列号
	MOV CL, 02H; 颜色
	CALL SHOW_STR

	;MAIN RETURN
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

CODE ENDS
END START