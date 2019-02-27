; 试验5(5) 编写code段中的代码，将a段和b段的数据依次相加，将结果存到c段中。

ASSUME CS:CODE

A SEGMENT
	DB 1, 2, 3, 4, 5, 6, 7, 8
A ENDS

B SEGMENT
	DB 1, 2, 3, 4, 5, 6, 7, 8
B ENDS

C SEGMENT
	DB 0, 0, 0, 0, 0, 0, 0, 0
C ENDS

CODE SEGMENT

	START:
	; 初始化A为DS
	MOV AX, A
	MOV DS, AX
	
	; 初始化ES
	MOV AX, C
	MOV ES, AX

	; BX做偏移地址
	MOV BX, 0000H
	
	; A 循环复制到 C
	MOV CX, 0008H
	S1:
	MOV AL, [BX]
	MOV ES:[BX], AL
	INC BX
	LOOP S1
	
	; 初始化B为DS
	MOV AX,	B
	MOV DS, AX
	
	; BX做偏移地址
	MOV BX, 0000H
	
	; B 循环和 C 加
	MOV CX, 0008H
	S2:
	MOV AL, [BX]
	ADD ES:[BX], AL
	INC BX
	LOOP S2
	
	; 程序返回
	MOV AX, 4C00H
	INT 21H
	
CODE ENDS

END START
