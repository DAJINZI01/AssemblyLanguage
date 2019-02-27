; 实验10 编写子程序
; 显示字符串
; 子程序描述
; 名称：show_str
; 功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串
; 参数：(DH)=行号(取值范围0-24)，(DL)=列号(取值范围0-79)
;		(CL)=颜色，DS:SI指向字符串的首地址
; 返回：无
; 应用举例：在屏幕的8行3列，用绿色显示data段中的字符串


ASSUME CS:CODE, DS:DATA, SS:STACK
DATA SEGMENT
	DB 'welcome to masm!', 0
DATA ENDS

STACK SEGMENT
	DB 16 DUP (0)
STACK ENDS

CODE SEGMENT

	START:
	MOV DH, 0008H; 行号
	MOV DL, 0003H; 列号
	MOV CL, 52H; 颜色
	;
	MOV AX, DATA
	MOV DS, AX
	MOV AX, STACK
	MOV SS, AX
	MOV SP, 0010H
	
	
	MOV SI, 0000H; 字符串首地址
	CALL SHOW_STR
	
	; 返回
	MOV AX, 4C00H
	INT 21H
	
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