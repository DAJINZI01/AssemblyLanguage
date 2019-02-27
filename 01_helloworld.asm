ASSUME CS:CODE, DS:DATA, SS:STACK
; .............................................................
; 堆栈段
; .............................................................
stack segment stack
	db	100 dup (?)
stack ends
; .............................................................
; 数据段
; .............................................................
data segment
	szHello db 'Hello world', 0dh, 0ah, "$"
data ends
; .............................................................
; 代码段
; .............................................................
code segment
	start:
		mov ax, data
		mov ds, ax
		
		mov ah, 9
		mov dx, offset szHello
		int 21h
		
		mov ax, 4c00h
		int 21h
code ends
end start


	