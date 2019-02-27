; 开机后，CPU自动进入到FFFF:0000单元处执行，此处有一条跳转指令。CPU执行该指令后，转去执行BIOS中的硬件系统检测和初始化程序。
; 初始化程序将建立BIOS所支持的中断向量，即将BIOS提供的中断例程的入口地址登记在中断向量表中
; 硬件系统检测和初始化完成后，调用INT 19H进行操作系统的引导。
; 如果设为从软盘启动操作系统，则 INT 19H将主要完成以下工作
; 1、控制0号软驱，读取软盘0道0面1扇区的内容到 0000:7C00
; 2、将CS:IP指向 0000:7C00
; 软盘的0道0面1扇区中装有操作系统引导程序。INT 19H 将其装到0000:7C00处后，设置CPU从0000:7C00开始执行此处的引导程序，操作系统被激活，控制计算机。

; 如果在0号软驱中没有软盘，或翻身软盘I/O错误，则INT 19H主要完成以下工作。
; 1、读取硬盘C的0道0面1扇区的内容到0000:7C00
; 2、将CS:IP指向0000:7c00

; 这次课程设计的任务是编写一个可以自行启动计算机，不需要再现有操作系统环境中运行的程序
	
; 该程序的功能如下：
	; 1、例如功能选项，让用户通过键盘进行选择，界面如下：
		; 1) reset pc			;重新启动计算机
		; 2) start system		; 引导现有的操作系统
		; 3) clock				; 进入时钟程序
		; 4) set clock			; 设置时间
	; 2、用户输入 1 后重新启动计算机，提示考虑FFFF:0000单元
	; 3、用户输入 2 后引导现有的操作系统，提示 考虑硬盘C的0到0面1扇区
	; 4、用户输入 3 后，执行动态显示当前日期、时间的程序
	; 显示格式如下：年/月/日 时:分:秒
	; 进入此项功能后，已知动态显示当前的时间，在屏幕上将出现时间按秒变化的效果，提示循环读取CMOS
	; 当按下F1键后，改变显示颜色，按下ESC键后，返回组选单。提示，利用键盘中断
	; 5、用户输入 4 后可更改当前的日期，时间，更改后返回到主选单。提示输入字符串
	
ASSUME CS:CODE, DS:DATA

DATA SEGMENT
	FUNC1_MSG DB '1) reset pc', 0; 重新启动计算机
	FUNC2_MSG DB '2) start system', 0; 引导现有的操作系统
	FUNC3_MSG DB '3) clock', 0; 进入时钟程序
	FUNC4_MSG DB '4) set clock', 0; 设置时间
	MENU	  DW FUNC1_MSG, FUNC2_MSG, FUNC3_MSG, FUNC4_MSG
DATA ENDS

STACK SEGMENT
	DB 128 DUP (?)
STACK ENDS

CODE SEGMENT

	START:
		MOV AX, DATA
		MOV DS, AX
		MOV AX, STACK
		MOV SS, AX
		MOV SP, 0080H
		
		; 打印菜单
		CALL PRINT_MENU
		; 功能函数
		CALL FUNCTION
		
	
		; main return
		MOV AX, 4C00H
		INT 21H
		

	;;;;;;;;;;;;;;;;;;; 功能 ;;;;;;;;;;;;;;;;;;;;
	FUNCTION:
		JMP FUNCTION_START
		TABLE DW FUNC1, FUNC2, FUNC3, FUNC4_MSG
		FUNCTION_START:
			MOV AH, 00H
			INT 16H
			CMP AL, '0'
			JB FUNCTION_RET
			CMP AL, '4'
			JA FUNCTION_RET
			
			MOV BL, AL
			MOV BH, 00H
			ADD BX, BX
			CALL WORD PTR TABLE[BX]
			
		FUNCTION_RET:
			RET
	;;;;;;;;;;;;;;;;;;; 重启系统 ;;;;;;;;;;;;;;;;;
	FUNC1:
		
		FUNC1_RET:
			RET
			
	;;;;;;;;;;;;;;;;;;; 引导现有的操作系统 ;;;;;;;;;;;;;;;;;
	FUNC2:
		
		FUNC2_RET:
			RET
			
	;;;;;;;;;;;;;;;;;;; 进入时钟程序 ;;;;;;;;;;;;;;;;;
	FUNC3:
		
		FUNC3_RET:
			RET
			
	
	;;;;;;;;;;;;;;;;;;; 重启系统 ;;;;;;;;;;;;;;;;;
	FUNC4:
		
		FUNC4_RET:
			RET
		
		
	;;;;;;;;;;;;;;;;;;; 设置时间 ;;;;;;;;;;;;;;;;;
	PRINT_MENU:
		
		MOV DX, 0A14H
		MOV CX, 0004H
		MOV BX, 0000H
		PRINT_MENU_S:
			PUSH CX
			INC DH
			INC CL
			MOV SI, MENU[BX]
			CALL PRINT_STR
			ADD BX, 0002H
			POP CX
			LOOP PRINT_MENU_S
		RET
	
	
	;;;;;;;;;;;;;;;;;;; 打印字符串 ;;;;;;;;;;;;;;;
	; DH DL CL
	; DS:SI
	PRINT_STR:
		PUSH AX
		PUSH ES
	
		MOV AX, 0B800H
		MOV ES, AX
		
		MOV AX, 00A0H
		MUL DH
		MOV DI, AX
		MOV AX, 0002H
		MUL DL
		ADD DI, AX
		
		PRINT_STR_S:
			MOV AL, [SI]
			CMP AL, 00H
			JE PRINT_STR_RET
			MOV ES:[DI], AL
			MOV ES:[DI+1], CL
			INC SI
			ADD DI, 0002H
			JMP PRINT_STR_S
		PRINT_STR_RET:
			POP ES
			POP AX
			RET
		
		
		

CODE ENDS
END START	