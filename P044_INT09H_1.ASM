ASSUME CS:CODE, DS:DATA, SS:STACK

STACK SEGMENT
	DB 128 DUP (00H)
STACK ENDS

DATA SEGMENT
	DW 0000H, 0000H
DATA ENDS

CODE SEGMENT
	
	START:
		; initiate ss
		MOV AX, STACK
		MOV SS, AX
		MOV SP, 0080H
		; initiate ds
		MOV AX, DATA
		MOV DS, AX
		; initiate es
		MOV AX, 0000H
		MOV ES, AX
		; MOV 09H ADDRESS TO DS:[0000H], DS:[0002H]
		PUSH ES:[09H * 4]
		POP DS:[0000H]
		PUSH ES:[09H * 4 + 2]
		POP DS:[0002H]
		; SET NEW 09H ADDRESS
		CLI
		MOV WORD PTR ES:[09H * 4], OFFSET INT09H
		MOV ES:[09H * 4 + 2], CS
		STI
		; print str in screen
		CALL SHOW_STR
		; RECOVERY O9H ADDRESS
		PUSH DS:[0000H]
		POP ES:[09H * 4]
		PUSH DS:[0002H]
		POP ES:[09H * 4 + 2]
		; return
		MOV AX, 4C00H
		INT 21H
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; print str in screen ;;;;;;;;;;;;;;;;;;;;;;;;
	SHOW_STR:
		PUSH ES
		PUSH AX
		PUSH DI
		
		MOV AX, 0B800H; 显存地址
		MOV ES, AX
		MOV DI, 0A0H * 12 + 1CH
		
		MOV AL, 'a'
		MOV AH, 01H
		SHOW_STR_S:
			; 字符
			MOV ES:[DI], AL
			MOV ES:[DI+1], AH
			ADD DI, 0002H
			; 空格
			MOV BYTE PTR ES:[DI], ' '
			MOV BYTE PTR ES:[DI+1], 07H
			; 延时
			CALL DELAY
			; 计数
			ADD DI, 0002H
			INC AH
			INC AL
			CMP AL, 'z'
			JNA SHOW_STR_S
		; SHOW_STR_RETURN
		POP DI
		POP AX
		POP ES
		RET
		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; delay function ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	DELAY:
		PUSH AX
		PUSH BX
		
		MOV AX, 0000H
		MOV BX, 0010H
		DELAY_S:
			SUB AX, 0001H
			JNE DELAY_S
			SUB BX, 0001H
			JNE DELAY_S
		
		POP BX
		POP AX
		RET
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INT09H ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	INT09H:
		PUSH AX
		PUSH ES
		PUSH DI
		PUSH CX
		
		PUSHF
		; 因为，在调用 09H号 中断时，TF, IF 已经设置为 0 了。
		;PUSHF
		;POP AX
		;AND AH, 0FCH
		;PUSH AX
		;POPF
		; 处理输入键盘键 ESC
		IN AL, 60H
		CALL DWORD PTR DS:[0000H]
		CMP AL, 01H
		JNE INT09H_RETURN
		; 改变显示字符颜色
		MOV AX, 0B800H; 显存地址
		MOV ES, AX
		MOV DI, 0A0H * 12 + 1CH; 偏移地址
		MOV CX, 001AH
		INT09H_S:
			INC BYTE PTR ES:[DI + 1]
			ADD DI, 0002H
			LOOP INT09H_S
		
		INT09H_RETURN:
			POP CX
			POP DI
			POP ES
			POP AX
			IRET
	
CODE ENDS

END START