; 程序运行时，定义的数据存放在CS:0000 - CS:000F中，共8个字单元。依次将这8个字单元中的数据入栈，然后在依次出栈到这8个字单元中，从而实现数据的逆序存放。
ASSUME CS:CODE

CODE SEGMENT
	DW 0123H, 0456H, 0789H, 0ABCH, 0DEFH, 0FEDH, 0CBAH, 0987H; 8个字型数据
	DW 0, 0, 0, 0, 0, 0, 0, 0; 栈空间
	
	START:;程序入口
	; 初始化栈
	MOV AX, CS
	MOV SS, AX
	MOV SP, 0020H
	
	; 间接寻址
	MOV BX, 0000H
	
	; 循环压栈
	MOV CX, 0008H
	S1:
	PUSH CS:[BX]
	ADD BX, 0002H
	LOOP S1
	
	; 间接寻址
	MOV BX, 0000H
	
	; 循环出栈
	MOV CX, 0008H
	S2:
	POP CS:[BX]
	ADD BX, 00002H
	LOOP S2
	
	; 程序返回
	MOV AX, 4C00H
	INT 21H


CODE ENDS

END START