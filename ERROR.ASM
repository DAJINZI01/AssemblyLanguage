ASSUME CS:CODE, DS:DATA

DATA SEGMENT
	DB 'conversationDFJALKJDFjkldjalfJDJDFKL hello world KJFKLAJSD', 0
DATA ENDS

CODE SEGMENT

	START:
		CALL TASK5
	
		
		;PRINT DX AX
		MOV AX, 0B800H
		MOV DS, AX
		MOV BX, 0A0H*12 + 80
		MOV BYTE PTR [BX], 'H'
		MOV BYTE PTR [BX].01H, 42H
		ADD BX, 0002H
		MOV BYTE PTR [BX], 'p'
		MOV BYTE PTR [BX].01H, 31H
		
		MOV AX, 4C00H
		INT 21H
		
	TASK1:
		MOV AX, 3456
		INT 7CH
		
		CLC
		ADD AX, AX
		ADC DX, DX
		RET
		
	TASK2:
		MOV AX, DATA
		MOV DS, AX
		MOV SI, 0000H
		INT 7CH
		
		MOV SI, 0000H; 字符串首地址
		MOV DH, 0008H; 行号
		MOV DL, 0003H; 列号
		MOV CL, 04H; 颜色
		CALL SHOW_STR
		RET
		
	TASK3:
	; 用int 7CH 实现LOOP 功能
	; 参数 CX, BX
	; 应用举例 在屏幕中间显示 80 个 ！
		MOV AX, 0B800H
		MOV DS, AX
		MOV SI, 0A0H * 11
		MOV CX, 0050H
		MOV BX, OFFSET SSS - OFFSET SSS_END
		SSS:
			MOV BYTE PTR [SI], '!'
			MOV BYTE PTR [SI].01H, 04H
			ADD SI, 0002H
			INT 7CH
		SSS_END:
			NOP
		RET
		
	TASK4:
	; 用 INT 7CH完成 JMP NEAR PTR 功能
	; 参数 BX
	; 在屏幕第12行显示 data段中以0结尾的字符串
		MOV AX, DATA
		MOV DS, AX
		MOV AX, 0B800H
		MOV ES, AX
		
		MOV SI, 0000H
		MOV DI, 0A0H * 12
		S4:
			CMP BYTE PTR [SI], 00H
			JE RETURN
			MOV AL, [SI]
			MOV ES:[DI], AL
			MOV BYTE PTR ES:[DI].01H, 15H
			INC SI
			ADD DI, 0002H
			MOV BX, OFFSET S4 - OFFSET RETURN
			INT 7CH
		RETURN:
			RET
	
	TASK5:
	; 用 INT 7CH完成 显示一个用0结束的字符串 功能
	; 参数 DH DL CL DS:SI
		MOV DH, 0BH
		MOV DL, 0CH
		MOV CL, 0BAH
		MOV AX, DATA
		MOV DS, AX
		MOV SI, 0000H
		INT 7CH
	
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