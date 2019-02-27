; 实验10 编写子程序
; 子程序描述
; 名称：DIVDW
; 功能：进行不会产生溢出的除法运算，被除数为DWORD型，除数为word型，结果为DWORD型
; 参数：(AX)=DWORD型数据的低16位
;		(DX)=DWORD型数据的高16位
;		(CX)=除数
; 返回：(DX)=结果的高16位
;		(AX)=结果的低16位
;		(CX)=余数
; 应用举例：计算1000000/10(F4240H/0AH)
; MOV AX, 4240H
; MOV DX, 0004H
; MOV CX, 0AH
; CALL DIVDW
; 结果：(DX)=0001H, (AX)=86A0H, (CX)=0
;
;
;
;
;
;
;
;

ASSUME CS:CODE, DS:DATA

DATA SEGMENT
	DB 16 DUP (0)
DATA ENDS

STACK SEGMENT
	DB 16 DUP (0)
STACK ENDS

CODE SEGMENT

	START:
	;初始化DS
	MOV AX, DATA
	MOV DS, AX
	
	;初始化SS
	MOV AX, DATA
	MOV SS, AX
	MOV SP, 0010H
	
	; 传参
	MOV AX, 4240H
	MOV DX, 000FH
	MOV CX, 0AH
	; 调用子程序
	CALL DIVDW
	
	; 主程序返回
	MOV AX, 21H
	INT 21H
	
	DIVDW:
	PUSH AX; 		保存被除数的低16位
	MOV AX, DX; 
	MOV DX, 0000H; 	组合新的被除数，为原来的被除数的高16位
	DIV CX; 		被除数高16位除以除数
		  ; 		商在AX中
		  ; 		余数在DX中
		  
	MOV SI, AX; 	保存高16位除以除数的商
	POP AX;			组合型的被除数，为原来被除数的低16位
	DIV CX;			商在AX中，为结果的低16位
		  ; 		余数在DX中
	MOV CX, DX;		保存余数
	MOV DX, SI;		保存结果的高16位
	RET
	
	
	

CODE ENDS

END START

