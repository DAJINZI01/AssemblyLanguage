; 实验5(6) 编写code段中的代码，用push指令将a段中的前8个字型数据，逆序存储到b段中。

ASSUME CS:CODE

A SEGMENT
	DW 1, 2, 3, 4, 5, 6, 7, 8, 9, 0AH, 0BH, 0CH, 0DH, 0EH, 0FH, 0FFH
A ENDS

B SEGMENT
	DW 0, 0, 0, 0, 0, 0, 0, 0
B ENDS

CODE SEGMENT
	
	START:
	; 初始化DS
	MOV AX, A
	MOV DS, AX
	
	; 初始化SS
	MOV AX, B
	MOV SS, AX
	MOV SP, 0010H
	
	; 循环压栈
	MOV BX, 0000H
	MOV CX, 0008H
	S:
	PUSH [BX]
	ADD BX, 2
	LOOP S
	
	; 程序返回
	MOV AX, 4C00H
	INT 21H
	
CODE ENDS

END START