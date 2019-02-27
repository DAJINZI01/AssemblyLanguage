; int 10H 2号子程序
; INT 10H 9号子程序

ASSUME CS:CODE

CODE SEGMENT
	START:
		CALL P1
		CALL P2
		
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
		

CODE ENDS

END START