; 安装一个新的 INT 7CH中断例程，实现通过逻辑扇区对硬盘读写
; 参数说明
; 用AH寄存器传递功能号：0 表示读， 1 表示写
; 用DX寄存器传递要读写的扇区的逻辑扇区号
; 用ES:BX指向存储数据或写入数据的内存区




ASSUME CS:CODE


CODE SEGMENT

	START:
		; 安装INT 7CH中断例程 0000:0200
		MOV AX, CS
		MOV DS, AX
		MOV AX, 0000H
		MOV ES, AX
		MOV SI, OFFSET INT7CH
		MOV DI, 0200H
		CLD
		MOV CX, OFFSET INT7CH_END - OFFSET INT7CH
		REP MOVSB
		
		CALL TEST_INT_7CH
	
		
		
		; return
		MOV AX, 4C00H
		INT 21H
		
	TEST_INT_7CH:
		PUSH ES
		PUSH BX
		
		MOV BX, 0B800H
		MOV ES, BX
		MOV BX, 0000H; 显存地址
		MOV AH, 00H; 读
		MOV DX, 0000H; 逻辑扇区
		INT 7CH
		
		POP BX
		POP ES
		RET
		
	INT7CH:
		JMP INT7CH_START
		TABLE DW OFFSET READ, OFFSET WRITE
		INT7CH_START:
			MOV BL, AH
			MOV BH, 00H
			ADD BX, BX
			CALL WORD PTR TABLE[BX]
			
		READ:
			; INT 13H 功能号
			MOV AH, 02H; 读
			JMP INNER_FUNC
		WRITE:
			MOV AH, 03H; 写
		INNER_FUNC:
			; 扇区数
			MOV AX, DX
			MOV DX, 0000H
			MOV BX, 05A0H; 1440
			DIV BX; AX BX
			
			MOV BX, AX
			MOV AX, DX
			MOV DH, BL; 磁头号(面)
			MOV BL, 12H; 18
			DIV BL;
			MOV CH, AL; 磁道号 
			MOV AL, AH;
			MOV AH, 00H;
			DIV BL;
			MOV CL, AL;
			INC CL; 扇区号
			
			; MOV AL, 08H; 扇区数
			; MOV CH, 00H; 磁道号
			; MOV CL, 01H; 扇区号
			; MOV DH, 00H; 磁头号(面)
			; MOV DL, 00H; 驱动
			; 返回值
			; 成功 AH = 0, AL = 写入的扇区数
			; 失败 AH = 出错代码
			
			
			INT 13H
			
	INT7CH_END:
		NOP

CODE ENDS

END START