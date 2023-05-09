%macro scall 4
        mov rax,%1
        mov rdi,%2
        mov rsi,%3
        mov rdx,%4
        syscall
%endmacro
%macro exit 0
        mov rax,60
        mov rdi,0
        syscall
%endmacro
section .data
	msg db "Processor is in Protected mode",0xA,0xD
	msglen equ $-msg
	msg1 db "Processor is in Real mode",0xA,0xD
	msglen1 equ $-msg1
	gdtmsg db "GDT contains are:",0xA,0xD
	gdtmsglen equ $-gdtmsg
	ldtmsg db "LDT contains are:",0xA,0xD
	ldtmsglen equ $-ldtmsg
	idtmsg db "IDT contains are:",0xA,0xD
	idtmsglen equ $-idtmsg
	trmsg db "Task register contains are:",0xA,0xD
	trmsglen equ $-trmsg
	col db ":"
	collen equ $-col
	new db "",0xA,0xD
	newlen equ $-new
section .bss 
	answer resb 16
	gdt resd 1
	ldt resw 1
	idt resw 1
	tr resw 1
section .text

global _start
_start:
	smsw rax
	mov rbx,rax
	BT rax,0
	jc l1
	
	l1:
	scall 1,1,msg,msglen
	jmp l3
	l2:
	scall 1,1,msg1,msglen1
	exit
	l3:
	scall 1,1,gdtmsg,gdtmsglen
	sgdt [gdt]
	mov ax,[gdt+4]
	Call display
	mov ax,[gdt+2]
	Call display
	scall 1,1,col,collen
	mov ax,[gdt]
	call display
	
	mov rax,0
	scall 1,1,new,newlen
	scall 1,1,idtmsg,idtmsglen
	sidt [idt]
	mov ax,[idt+4]
	Call display
	mov ax,[idt+2]
	Call display
	scall 1,1,col,collen
	mov ax,[idt]
	call display
	
	mov rax,0
	scall 1,1,new,newlen
	scall 1,1,ldtmsg,ldtmsglen
	sldt [ldt]
	mov ax,[ldt]
	call display
	
	mov rax,0
	scall 1,1,new,newlen
	scall 1,1,trmsg,trmsglen
	str [tr]
	mov ax,[tr]
	call display
		
	
	exit




display:
        mov rsi,answer+15
        mov rcx,4

cnt:    mov rdx,0
        mov rbx,16
        div rbx
        cmp dl,09h
        jbe add30
        add dl,07h
add30:  add dl,30h
        mov [rsi],dl
        dec rsi
        dec rcx
        jnz cnt
        scall 1,1,answer,16
ret

