; 按下F1键，改变屏幕颜色
; 按下 A键， 显示满屏的 A

ASSUME CS:CODE

CODE SEGMENT

	START:
		; 将新的INT09H，安装到 0000:0204 之后
		; 用串传送指令 MOVSB
		MOV AX, CS
		MOV DS, AX
		MOV AX, 0000H
		MOV ES, AX
		MOV SI, OFFSET INT_09H
		MOV DI, 0204H
		MOV CX, OFFSET INT_09H_END - OFFSET INT_09H
		CLD
		REP MOVSB
		; 保存 INT 09H 地址
		MOV AX, ES:[09H * 4]
		MOV WORD PTR ES:[0200H], AX
		MOV AX, ES:[09H * 4 + 2]
		MOV WORD PTR ES:[0202H], AX
		; 修改 INT 09H 地址 为 新的
		CLI
		MOV WORD PTR ES:[09H * 4], 0200H
		MOV WORD PTR ES:[09H * 4 + 2], 0000H
		STI
		; return
		MOV AX, 4C00H
		INT 21H
	
	;;;;;;;;;;;;;; INT 09H ;;;;;;;;;;;;;;;;;;;
	INT_09H:
		; 保存相关寄存器
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		PUSH ES
		; 读取键盘输入
		IN AL, 60H
		; 调用原来的 INT 09H 中断程序
		PUSHF
		CALL DWORD PTR CS:[0200H]
		
		; 设置显存地址
		MOV BX, 0B800H
		MOV ES, BX; 设置显存
		; 判断是否输入了 F1(3BH)
		IF_AL_3BH:
			CMP AL, 3BH
			JNE IF_AL_1EH
			; 输入了 ESC ，改变 屏幕颜色
			MOV BX, 0000H; 偏移地址
			MOV CX, 07D0H; 2000 循环次数
			INT_09H_S1:
				INC  BYTE PTR ES:[BX+1]
				ADD BX, 0002H
				LOOP INT_09H_S1
			JMP INT_09H_RETURN
		; 判断是否输入了 A		
		IF_AL_1EH:
			CMP AL, 1EH + 80H
			JNE INT_09H_RETURN
			
			; 循环设置显示字符
			MOV BX, 0000H; 偏移地址
			MOV CX, 07D0H; 2000 循环次数
			INT_09H_S2:
				MOV BYTE PTR ES:[BX], 'A'
				ADD BX, 0002H
				LOOP INT_09H_S2
		INT_09H_RETURN:
			POP ES
			POP DX
			POP CX
			POP BX
			POP AX
			IRET

	INT_09H_END:
		NOP
CODE ENDS

END START