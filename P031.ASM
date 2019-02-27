; 实验7 寻址方式在结构化数据访问中的应用

ASSUME CS:CODESG, SS:STACK, DS:DATA

DATA SEGMENT
	; 21年的21个字符串
	DB '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
	DB '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
	DB '1993', '1994', '1995'
	
	; 21年公司总收入的21个dword型数据
	DD 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
	DD 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
	
	; 21年公司雇员人数的21个word型数据
	DW 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
	DW 11542, 14430, 15257, 17800

	
DATA ENDS

DATA1 SEGMENT
	DB 336 DUP (0)
DATA1 ENDS

DATA2 SEGMENT
	DB 336 DUP (0)
DATA2 ENDS


TABLE SEGMENT
	DB 21 DUP ('YEAR SUMM NE ?? '), 00H
TABLE ENDS


STACK SEGMENT
	DW 8 DUP (0); 定义一个栈，大小为16字节
STACK ENDS;

	
CODESG SEGMENT
	START:
		; 初始化DS
		MOV AX, DATA
		MOV DS, AX
		
		; 初始化ES
		MOV AX, TABLE
		MOV ES, AX
		
		; 初始化SS
		MOV AX, STACK
		MOV SS, AX
		MOV SP, 0010H
		
		CALL COPY

		CALL TO_SHOW
		
		; 输出到屏幕
		PUSH DS
		;MOV AX, TABLE
		;MOV DS, AX
		MOV SI, 0000H; 字符串首地址
		MOV DH, 0008H; 行号
		MOV DL, 0003H; 列号
		MOV CL, 02H; 颜色
		CALL SHOW_STR
		POP DS
	
		; 程序返回
		MOV AX, 4C00H
		INT 21H
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 将数据中二进制数字改为十进制字符串 ;;;;;;;;;;;;;;;;;;;;;;;;;
	TO_SHOW:
		; 设置循环次数 21次, 数据存放在ES段
		PUSH DS
		; 初始化DS
		MOV AX, ES
		MOV DS, AX
		MOV CX, 0015H
		MOV BX, 0000H
		SSS:
			; 显示年份
			MOV AL, 00H
			MOV [BX].04H, AL
			MOV SI, 0000H; 字符串首地址
			MOV DH, 0008H; 行号
			MOV DL, 0003H; 列号
			MOV CL, 02H; 颜色
			CALL SHOW_STR
			
			; 显示总收入
			MOV AX, [BX].05H
			MOV DX, [BX].07H
			CALL DTOC
			PUSH DS
			MOV AX, DATA2
			MOV DS, AX
			MOV SI, 0000H; 字符串首地址
			MOV DH, 0008H; 行号
			MOV DL, 0003H; 列号
			MOV CL, 02H; 颜色
			CALL SHOW_STR
			POP DS
			
			; 显示雇员数
			MOV AX, [BX].0AH
			MOV DX, 0000H
			CALL DTOC
			PUSH DS
			MOV AX, DATA2
			MOV DS, AX
			MOV SI, 0000H; 字符串首地址
			MOV DH, 0008H; 行号
			MOV DL, 0003H; 列号
			MOV CL, 02H; 颜色
			CALL SHOW_STR
			POP DS
			
			; 显示人均收入
			MOV AX, [BX].0CH
			MOV DX, 0000H
			CALL DTOC
			PUSH DS
			MOV AX, DATA2
			MOV DS, AX
			MOV SI, 0000H; 字符串首地址
			MOV DH, 0008H; 行号
			MOV DL, 0003H; 列号
			MOV CL, 02H; 颜色
			CALL SHOW_STR
			POP DS
			
			ADD BX, 0010H
			LOOP SSS
			POP DS
	RET
		
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 格式化数据 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	COPY:
		; 循环 21 次
		MOV CX, 0015H
		MOV DX, 0000H
		MOV SI, 0000H
		MOV DI, 0000H
	
	S0:
		MOV AX, 0010H; TABLE的步长
		MUL DL
		MOV BP, AX;TABLE的偏移地址
		
		
		MOV AX, 0004H; 年份的步长
		MUL DL;
		MOV BX, AX;年份的偏移地址
		
		PUSH CX
		MOV CX, 0004H
		MOV SI, 0000H
	S1:
		; 处理年份1
		; 计算位置
		MOV AL, [BX][SI]
		MOV ES:[BP][SI], AL
		INC SI
		LOOP S1
		POP CX
		
		; 处理收入4
		MOV AX, 0004H; 收入的步长
		MUL DL;
		MOV BX, AX;
		MOV AX, 54H[BX]; 收入的偏移地址
		MOV ES:[BP].05H, AX
		MOV AX, 56H[BX]
		MOV ES:[BP].07H, AX
		
		; 处理雇员2
		MOV AX, 0002H; 雇员的步长
		MUL DL;
		MOV BX, AX
		MOV AX, 0A8H[BX];雇员的偏移地址
		MOV ES:[BP].0AH, AX
		
		
		; 处理人均收入2
		; 计算人均收入
		PUSH DX
		MOV AX, ES:[BP].05H
		MOV DX, ES:[BP].07H
		;DIV WORD PTR ES:0AH[BP]
		DIV WORD PTR 0A8H[BX]
		MOV ES:[BP].0DH, AX
		POP DX

		INC DX
		LOOP S0
		RET
		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 转换十进制数的字符串子程序 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 参数 DX AX 
	; 返回值
	DTOC:
		PUSH ES
		PUSH DS
		; 初始化ES
		MOV CX, DATA1
		MOV ES, CX
		
		; 初始化DS
		MOV CX, DATA2
		MOV DS, CX
		
		MOV SI, 0000H
	
	SS1:
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
		JMP SHORT SS1
	
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
		
		POP DS
		POP ES
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
	; 参数 DH DL CL DS:SI
	; 返回值
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

	

CODESG ENDS

END START