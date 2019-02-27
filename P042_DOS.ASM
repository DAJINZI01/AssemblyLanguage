; int 10H 2号子程序
; INT 10H 9号子程序
; INT 21H 9号子程序
; 分别在屏幕的第2/4/6/8行显示4句英文诗


ASSUME CS:CODE, DS:DATA

DATA SEGMENT
	DB 'hello int 21h code:9 , how much time do i have left?$'
DATA ENDS

CODE SEGMENT
	START:
		;CALL P1
		;CALL P2
		;CALL P3
		CALL TASK
		; MAIN RETURN
		MOV AX, 4C00H
		INT 21H
	p1:
		; 用int 10H 2号子程序, 设置光标位置
		MOV AH, 02H
		MOV BH, 00H
		MOV DH, 05H
		MOV DL, 0CH
		INT 10H
		RET
	P2:
		; INT 10H 9号子程序，在光标位置显示字符功能
		MOV AH, 09H; 设置为光标
		MOV AL, 'H'; 字符
		MOV BL, 0CAH; 属性
		MOV BH, 00H; 页
		MOV CX, 0AH; 重复次数
		INT 10H
		RET
	P3:
		;INT 21H 9号子程序 在光标位置显示字符串的功能
		MOV AX, DATA
		MOV DS, AX
		MOV DX, 0000H
		MOV AH, 09H
		INT 21H
		RET
		
	TASK:
		JMP SHORT TASK_START
		; 分别在屏幕的第2/4/6/8行显示4句英文诗
		s1 	DB 'Good,better,best,', '$'
		s2 	DB 'Never let it reat,', '$'
		s3 	DB 'Till good is better,', '$'
		s4 	DB 'And better,best.', '$'
		s  	DW OFFSET S1, OFFSET S2, OFFSET S3, OFFSET S4
		ROW	DB 02H, 04H, 06H, 08H
		TASK_START:
			MOV AX, CS
			MOV DS, AX
			MOV BX, OFFSET S
			MOV SI, OFFSET ROW
			; LOOP COUNT
			MOV CX, 0004H
			OK:
				; set the point position
				MOV BH, 00H
				MOV DH, [SI]
				MOV DL, 00H
				MOV AH, 02H
				INT 10H
				; screen show str
				MOV DX, [BX]
				MOV AH, 09H
				INT 21H
				; 
				INC SI
				ADD BX, 0002H
				LOOP OK
		; RETURN
			
		RET
		

CODE ENDS

END START