; 二维数组， 编程，将datasg段每个单词改为大写字母

ASSUME CS:CODESG, DS:DATASG, SS:STACKSG

DATASG SEGMENT
	DB 'ibm             '
	DB 'dec             '
	DB 'dos             '
	DB 'vax             '
	DW 0000H; 定义一个字型数据，用来暂存CX中的值
DATASG ENDS

STACKSG SEGMENT
	DW 0, 0, 0, 0, 0, 0, 0, 0; 定义一个栈，容量为16B
STACKSG ENDS



CODESG SEGMENT
	START:
	; 初始化DATA
	MOV AX, DATASG
	MOV DS, AX
	
	; 初始化栈
	MOV AX, STACKSG
	MOV SS, AX
	MOV SP, 0010H
	
	; 外循环
	MOV CX, 0004H
	MOV BX, 0000H
	S1:
	;MOV DS:[0040H], CX; MOV DX, CX
	PUSH CX
	; 内循环
	MOV SI, 0000H
	MOV CX, 3H
	S2:
	MOV AL, [BX + SI]
	AND AL, 5FH
	MOV [BX + SI], AL
	INC SI
	LOOP S2
	
	ADD BX, 0010H
	;MOV CX, DS:[0040H];MOV CX, DX
	POP CX
	LOOP S1
	
	; 程序返回
	MOV AX, 4C00H
	INT 21H

CODESG ENDS

END START


















