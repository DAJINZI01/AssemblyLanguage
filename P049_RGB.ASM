; 编程，接收用户的键盘输入
; r 	将字符设置为 红色
; g 	将字符设置为 绿色
; b 	将字符设置为 蓝色

ASSUME CS:CODE

CODE SEGMENT

	START:
		MOV AH, 00H
		INT 16H
		IF_AL_IS_R:
			CMP AL, 'r'
			JNE IF_AL_IS_G
			MOV DL, 04H
			JMP SHOW_STR
		IF_AL_IS_G:
			CMP AL, 'g'
			JNE IF_AL_IS_B
			MOV DL, 02H
			JMP SHOW_STR
		IF_AL_IS_B:
			CMP AL, 'b'
			JNE  RETURN
			MOV DL, 01H
			JMP SHOW_STR
		SHOW_STR:
			CALL SHOW
		RETURN:
			MOV AX, 4C00H
			INT 21H
		
		SHOW:
			PUSH AX
			PUSH BX
			PUSH CX
			PUSH ES

			MOV AX, 0B800H
			MOV ES, AX
			MOV BX, 0000H
			
			MOV CX, 07D0H; 2000
			SHOW_S:
				MOV ES:[BX+1], DL
				ADD BX, 0002H
				LOOP SHOW_S
				
			POP ES
			POP CX
			POP BX
			POP AX
			RET
CODE ENDS

END START