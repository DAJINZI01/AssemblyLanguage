; 二维数组， 编程，将datasg段每个单词的前4个字母改为大写字母

ASSUME CS:CODESG, DS:DATASG, SS:STACKSG

DATASG SEGMENT
	DB '1. display      '
	DB '2. brows        '
	DB '3. replace      '
	DB '4. modify       '
DATASG ENDS

STACKSG SEGMENT
	DW 0000H, 0000H, 0000H, 0000H, 0000H, 0000H, 0000H, 0000H; 定义一个栈，容量为16B
STACKSG ENDS



CODESG SEGMENT
	START:
	; 初始化DS
	MOV AX, DATASG
	MOV DS, AX
	
	; 初始化SS
	MOV AX, STACKSG
	MOV SS, AX
	MOV SP, 0010H
	
	; 外循环
	MOV CX, 0004H
	MOV BX, 0000H
	S1:
	
	PUSH CX
	; 内循环
	MOV SI, 0000H
	MOV CX, 0004H
	S2:
	MOV AL, [BX + 3 + SI]
	AND AL, 5FH
	MOV [BX +3 + SI], AL
	INC SI
	LOOP S2
	
	ADD BX, 0010H
	POP CX
	
	LOOP S1
	
	; 程序返回
	MOV AX, 4C00H
	INT 21H

CODESG ENDS

END START


















