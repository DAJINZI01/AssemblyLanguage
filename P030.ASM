; 实验10 编写子程序
; 子程序描述
; 名称：DTOC
; 功能：将word型数据转变为表示十进制数的字符串，字符串以0位结尾符
; 参数：(AX)=WORD型数据
;		DS:SI 指向字符串的首地址
; 返回：无
; 应用举例：编程，将数据1266以十进制的形式在屏幕的8行3列，用绿色显示出来，在显示时我们调用本次试验中的第一个子程序show_str
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
	;DB 'Hello world'
	DB 10 DUP (0)
DATA ENDS
	
DATA2 SEGMENT
	DB 10 DUP (0)
DATA2 ENDS
	
STACK SEGMENT
	DB 16 DUP (0)
STACK ENDS




CODE SEGMENT

	START:
	;初始化DS
	MOV AX, DATA
	MOV DS, AX
	
	;初始化ES
	MOV AX, DATA2
	MOV ES, AX
	
	;初始化SS
	MOV AX, STACK
	MOV SS, AX
	MOV SP, 0010H
	
	
	; 传入参数
	MOV AX, 04D2H; 十进制数低16位 4240H
	MOV DX, 0000H; 十进制数高16位 000FH
	; 调用转换为十进制数的字符串
	CALL DTOC
	
	; 传入参数
	MOV DH, 0008H
	MOV DL, 0003H
	MOV CL, 0002H
	MOV SI, 0000H
	; 调用屏幕显示函数
	CALL SHOW_STR
	
	; 主程序返回
	MOV AX, 4C00H
	INT 21H
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 转换十进制数的字符串子程序 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	DTOC:
	MOV SI, 0000H
	
	S1:
	; 传入参数 DX:AX / CX --> DX:AX . CX
	MOV CX, 0AH; 除数
	CALL DIVDW
	
	; 将转换后的十进制数的字符压栈
	ADD CL, 30H
	MOV ES:[SI], CL
	; 记下一共有多少位
	INC SI
	; 判断商是否为0
	MOV CX, AX
	JCXZ OK1
	JMP SHORT S1
	
	OK1:
	; 将字符串逆序copy
	MOV CX, SI
	DEC SI
	MOV DI, 0000H
	S2:
	MOV AL, ES:[SI]
	MOV [DI], AL
	INC DI
	DEC SI
	LOOP S2
	; 字符串末尾添加'\0'
	MOV AL, 00H
	MOV [DI], AL
	
	RET
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 解决除法溢出子程序 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 参数 DX AX CX 
	; 返回值 DX AX CX
	;
	;
	DIVDW:
	PUSH SI
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
	POP SI
	RET
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 屏幕显示字符串的子程序 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

