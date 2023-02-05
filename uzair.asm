brick struct
x_axis dw ?
x_axisend dw ?
y_axis dw ?
y_axisend dw ?
strength dw 1

color db 2
brick ends

.model small
.stack 100h

.data
prompt db '        Enter Your Name :  ','$'
lines db  '----------------------------------------','$'
username db 100 dup('$')
maintitle db ' B R I C K  B R E A K E R - 2 0 2 2     ' , '$'
new_game db '  NEW GAME ','$'
instruct db 'INSTRUCTIONS ','$'
high_sc  db ' HIGH SCORE ' , '$'
exitt     db ' EXIT ' ,'$'
line1     db '1 - Use Arrow Keys to move the paddle. ','$'
line2    db '2 - Hit as many bricks as you can. ','$'
line3     db '3 - Each game has a time limit of 4 mins and you have a total of 3 lives. ','$'
line4     db '4 - Game consists of 3 levels. Enjoy ! ','$' 
instruct2 db '         INSTRUCTIONS MANUAL ','$'
welcome  db '          WELCOME  :  ','$'
names    db '          By : Azaan & Uzair ','$'
input    db ?
level dw 1
levelss db 1
strength dw 0
speed dw 2
temp dw 0
temp2 dw 0
temp1 dw 0
totalBricks brick <20,90,15,35,1,3>,<90,160,15,35,1,6>,<160,230,15,35,1,4>,<230,300,15,35,1,2>,<20,90,35,55,1,4>,<90,160,35,55,1,3>,<160,230,35,55,1,7>,<230,300,35,55,1,5>,<20,90,55,75,1,4>,<90,160,55,75,1,8>,<160,230,55,75,1,5>,<230,300,55,75,1,4>
totalBricks1 brick <20,90,15,35,2,3>,<90,160,15,35,2,6>,<160,230,15,35,2,4>,<230,300,15,35,2,2>,<20,90,35,55,2,4>,<90,160,35,55,2,3>,<160,230,35,55,2,7>,<230,300,35,55,2,5>,<20,90,55,75,2,4>,<90,160,55,75,2,8>,<160,230,55,75,2,5>,<230,300,55,75,2,4>
totalBricks2 brick <20,90,15,35,3,3>,<90,160,15,35,3,6>,<160,230,15,35,3,4>,<230,300,15,35,3,2>,<20,90,35,55,3,4>,<90,160,35,55,3,3>,<160,230,35,55,3,7>,<230,300,35,55,3,5>,<20,90,55,75,3,4>,<90,160,55,75,3,8>,<160,230,55,75,3,5>,<230,300,55,75,99,4>


tempp dw 0
flagup dw 1
flagdown dw -1
flagright dw -1
flagleft dw -1
string db "Lives:$" 
string1 db " Press any Key to Continue $"
string2 db " Score : $"
string3 db " Your Final score is : $"
congrats db "CONGRATS YOU WON !!!!!!!!!!!$"
paused db "game is Paused$"
levels db " level : $"
scoreTen db 0
scoreUnit db 0
time_aux db 12
flag dw 0
flagl byte 0
start word 100
endd word 170
y word 170
ball_y word 100
ball_x word 150
ball_yend word 110
ball_xend word 160
life word 3
.code


main proc
mov ax, @data
mov ds, ax
mov ax, 0  
mov bx,0
mov cx,0
mov dx,0
mov ah,00h
mov al,13h
int 10h
call mainmenu 
call options







mov ax, 0  
mov bx,0
mov cx,0
mov dx,0




display::


mov ah,2ch
int 21h
cmp dl,time_aux ; 1/100 of a second
je display


mov time_aux,dl


 mov ax, 0  
mov bx,0
mov cx,0
mov dx,0


MOV AH, 06
 MOV AL, 0
 MOV CX, 0
 MOV DH, 80
 MOV DL, 80
 MOV BH, 0h
 INT 10h

 mov ax, 0  
mov bx,0
mov cx,0
mov dx,0



call drawrectangle
call drawball

.if(level ==1 )
call drawbrick
call deleteBrick

call checklevel
.elseif(level==2)
call drawbrick1
call deleteBrick1
call checklevel1
.elseif(level==3)
call drawbrick2
call deleteBrick2
call checklevel2

.endif




mov ax, 0  
mov bx,0
mov cx,0
mov dx,0
   


call displaytexts

mov ax,ball_y
.if(ball_y <= 2)
     mov flagup,1
     neg flagdown

   .endif

.if(level<=2)
    .if(ball_x <= 2)
        mov flagright,1
        neg flagleft
    .endif
 .else
 .if(ball_x <= 3)
        mov flagright,1
        neg flagleft
    .endif
.endif
.if(ball_xend >= 318)
    neg flagright
    mov flagleft,1
.endif





 mov cx,start
 mov dx ,endd

.if ( ball_x >= cx && ball_x <= dx && ball_yend >= 170)
    
mov ax,start
mov dx,endd
add ax,dx                   ;finding the centre of slider
mov dx,0
mov cx,2
div cx

mov cx,ball_x               ;if the ball hits the right side ball goes right warna goes left
cmp cx,ax
jl lowerhalf
add ball_x,7
add ball_xend,7

.if(ball_x >= 318 )
sub ball_x,7
sub ball_xend,7

.endif
mov flagdown,1
mov flagleft,-1
mov flagup,-1
mov flagright,1;;;
jmp notouch
lowerhalf:


sub ball_x,7
sub ball_xend,7
mov flagdown,1
mov flagright,-1
mov flagup,-1
mov flagleft,1;;;;
jmp notouch
    .endif
notouch:





mov cx,speed
.if(flagdown==1)
    sub ball_y,cx
    sub ball_yend,cx
    .endif
.if(flagup==1)
    add ball_y,cx
    add ball_yend,cx
    .endif
.if(flagright==1)
   add ball_x,cx
   add ball_xend,cx
   .endif
.if(flagleft==1)
    sub ball_x,cx
    sub ball_xend,cx
    .endif

try:

mov ax, 0  
mov bx,0
mov cx,0
mov dx,0

mov cx,ball_yend
 cmp cx,180         ;;checking if the ball touches the ground
 jl nodeath
 call loselife
 jmp try
 nodeath:

;detecting input
Zf=0
mov ah,1
int 16h
jz display


mov ah, 00
int 16h
mov al,ah


cmp ah,4dh			;right cursor
jne  skipr
call right
jmp try
skipr:

cmp ah, 4Bh       ;left cursor
jne skipL
call lefta
jmp try
skipL:


cmp ah, 48h			;up cursor
jne noPause
call pause
noPause:

cmp ah, 50h			;down cursor
je Down

jmp display






 down::


 MOV AH, 06
 MOV AL, 0
 MOV CX, 0
 MOV DH, 80
 MOV DL, 80
 MOV BH, 0h
 INT 10h

 
mov ax,0
mov bx,0
mov cx,0
mov dx,0

mov ah, 02h
mov dh, 15  ;dh is y coordinate
mov dl, 5  ;dl is x coordinate
int 10h
mov dx, offset string3
mov ah, 9h
int 21h  


mov ax, 0  
mov bx,0
mov cx,0
mov dx,0
mov cl,scoreTen


add cl,48
Mov dl,cl 
Mov ah, 02h
Int 21h


mov ax, 0  
mov bx,0
mov cx,0
mov dx,0
mov cl,scoreUnit






add cl,48
Mov dl,cl 
Mov ah, 02h
Int 21h









;call Create_File 

;call Write_File

khatam::



mov ah,4ch
int 21h
main endp

pause proc
mov ax,0
mov bx,0
mov cx,0
mov dx,0



MOV AH, 06
 MOV AL, 0
 MOV CX, 0
 MOV DH, 80
 MOV DL, 80
 MOV BH, 0h
 INT 10h


 mov ax,0
mov bx,0
mov cx,0
mov dx,0


mov ah, 02h
mov dh, 3  ;dh is y coordinate
mov dl, 10  ;dl is x coordinate
int 10h
mov dx, offset paused
mov ah, 9h
int 21h 


mov ax,0
mov bx,0
mov cx,0
mov dx,0


mov ah, 02h
mov dh, 5  ;dh is y coordinate
mov dl, 4 ;dl is x coordinate
int 10h
mov dx, offset string1
mov ah, 9h
int 21h 

call drawrectangle
call drawball









mov ah,0
int 16h
ret
pause endp











;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
checklevel2 proc
mov cx,11
mov di,0

L1:

mov ax,(brick ptr totalbricks2 [di] ).strength
.if( ax != 0)
ret 
.endif
add di,TYPE brick
loop l1





MOV AH, 06
 MOV AL, 0
 MOV CX, 0
 MOV DH, 80
 MOV DL, 80
 MOV BH, 0h
 INT 10h


 mov ax,0
mov bx,0
mov cx,0
mov dx,0


mov ah, 02h
mov dh, 15  ;dh is y coordinate
mov dl, 10  ;dl is x coordinate
int 10h
mov dx, offset string1
mov ah, 9h
int 21h  


 mov ax,0
mov bx,0
mov cx,0
mov dx,0


mov ah, 02h
mov dh, 12  ;dh is y coordinate
mov dl, 10  ;dl is x coordinate
int 10h
mov dx, offset congrats
mov ah, 9h
int 21h  


mov ah,0
int 16h














jmp down

ret
checklevel2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawbrick2 proc
mov di,0
mov cx,12
mov ax,0
mov bx,0
mov dx,0
L11:
push cx
mov cx,(brick ptr totalbricks2 [di] ).x_axis;
mov temp,cx
mov bx,(brick ptr totalbricks2 [di] ).x_axisend;
mov temp2,bx
mov dx,(brick ptr totalbricks2 [di] ).y_axis;
mov ax,(brick ptr totalbricks2 [di] ).y_axisend;
mov temp1,ax
L051:
MOV AL, (brick ptr totalbricks2 [di] ).color;
MOV AH, 0CH
INT 10H
inc cx
cmp cx,temp2
jne L051
mov cx,temp
inc dx
cmp dx,temp1
jne L051


add di,TYPE brick

pop cx
loop L11


ret
drawbrick2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
deletebrick2 proc


mov si,0
mov cx,12
mov ax,0
mov bx,0
mov dx,0
L21:
push cx
mov ax,(brick ptr totalbricks2 [si] ).y_axis;
mov bx,(brick ptr totalbricks2 [si] ).y_axisend;
mov cx,(brick ptr totalbricks2 [si] ).x_axis;
mov dx,(brick ptr totalbricks2 [si] ).x_axisend


.if(ball_y <= bx  &&  ball_y >= ax && ball_x >= cx && ball_x <= dx)

call sound
neg flagdown
neg flagup

dec (brick ptr totalbricks2 [si] ).strength
dec (brick ptr totalbricks2 [si] ).color

mov cx,(brick ptr totalbricks2 [si] ).strength

cmp cx,0
jne nobreak1
mov (brick ptr totalbricks2 [si] ).y_axis,185
mov (brick ptr totalbricks2 [si] ).y_axisend,190
mov (brick ptr totalbricks2 [si] ).x_axis,0
mov (brick ptr totalbricks2 [si] ).x_axisend,90
mov (brick ptr totalbricks2 [si] ).color,0
add scoreunit,3
.if(scoreunit >= 10)
sub scoreUnit,10
add scoreTen,1
.endif
nobreak1:
.endif


add si,TYPE brick

pop cx
loop L21

mov cx,12
mov di,0
L17:
.if(cx==1)
mov (brick ptr totalbricks2 [di] ).color,9

.endif
add di,TYPE brick
loop L17

ret
deletebrick2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
checklevel1 proc
mov cx,12
mov di,0

L1:

mov ax,(brick ptr totalbricks1 [di] ).strength
.if( ax != 0)
ret 
.endif
add di,TYPE brick
loop l1


inc level
inc levelss
mov flagup , 1
mov flagdown , -1
mov flagright ,-1
mov flagleft , -1
mov start,110 
mov endd,170                ;;paddle to centtre
mov ball_y,  80
mov ball_x,  150
mov ball_yend , 90
mov ball_xend, 160

inc speed

mov ax,0
mov bx,0
mov cx,0
mov dx,0



MOV AH, 06
 MOV AL, 0
 MOV CX, 0
 MOV DH, 80
 MOV DL, 80
 MOV BH, 9h
 INT 10h


 mov ax,0
mov bx,0
mov cx,0
mov dx,0


mov ah, 02h
mov dh, 15  ;dh is y coordinate
mov dl, 10  ;dl is x coordinate
int 10h
mov dx, offset string1
mov ah, 9h
int 21h  
mov ah,0
int 16h



ret
checklevel1 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawbrick1 proc
mov di,0
mov cx,12
mov ax,0
mov bx,0
mov dx,0
L11:
push cx
mov cx,(brick ptr totalbricks1 [di] ).x_axis;
mov temp,cx
mov bx,(brick ptr totalbricks1 [di] ).x_axisend;
mov temp2,bx
mov dx,(brick ptr totalbricks1 [di] ).y_axis;
mov ax,(brick ptr totalbricks1 [di] ).y_axisend;
mov temp1,ax

L051:
MOV AL, (brick ptr totalbricks1 [di] ).color;
MOV AH, 0CH
INT 10H
inc cx
cmp cx,temp2
jne L051
mov cx,temp
inc dx
cmp dx,temp1
jne L051


add di,TYPE brick

pop cx
loop L11


ret
drawbrick1 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
deletebrick1 proc


mov si,0
mov cx,12
mov ax,0
mov bx,0
mov dx,0
L21:
push cx
mov ax,(brick ptr totalbricks1 [si] ).y_axis;
mov bx,(brick ptr totalbricks1 [si] ).y_axisend;
mov cx,(brick ptr totalbricks1 [si] ).x_axis;
mov dx,(brick ptr totalbricks1 [si] ).x_axisend


.if(ball_y <= bx  &&  ball_y >= ax && ball_x >= cx && ball_x <= dx)

call sound

neg flagdown
neg flagup
mov (brick ptr totalbricks1 [si] ).color,5

dec (brick ptr totalbricks1 [si] ).strength
mov cx,(brick ptr totalbricks1 [si] ).strength


cmp cx,0
jne nobreak1
mov (brick ptr totalbricks1 [si] ).y_axis,185
mov (brick ptr totalbricks1 [si] ).y_axisend,190
mov (brick ptr totalbricks1 [si] ).x_axis,0
mov (brick ptr totalbricks1 [si] ).x_axisend,90
mov (brick ptr totalbricks1 [si] ).color,0
add scoreunit,2
.if(scoreunit >= 10)
sub scoreUnit,10
add scoreTen,1
.endif
nobreak1:
.endif



add si,TYPE brick

pop cx
loop L21



ret
deletebrick1 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
checklevel proc
mov cx,12
mov di,0

L3:

mov ax,(brick ptr totalbricks [di] ).strength
.if( ax != 0)
ret 
.endif
add di,TYPE brick
loop l3
inc speed
inc level
inc levelss
mov flagup , 1
mov flagdown , -1
mov flagright ,-1
mov flagleft , -1

mov ball_y,  80
mov ball_x,  150
mov ball_yend , 90
mov ball_xend, 160


mov start,110
mov endd,170

mov ax,0
mov bx,0
mov cx,0
mov dx,0



MOV AH, 06
 MOV AL, 0
 MOV CX, 0
 MOV DH, 80
 MOV DL, 80
 MOV BH, 9h
 INT 10h


 mov ax,0
mov bx,0
mov cx,0
mov dx,0







mov ah, 02h
mov dh, 15  ;dh is y coordinate
mov dl, 10  ;dl is x coordinate
int 10h
mov dx, offset string1
mov ah, 9h
int 21h  



 mov ah,0
 int 16h








ret
checklevel endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawbrick proc
mov di,0
mov cx,12
mov ax,0
mov bx,0
mov dx,0
L1:
push cx
mov cx,(brick ptr totalbricks [di] ).x_axis;
mov temp,cx
mov bx,(brick ptr totalbricks [di] ).x_axisend;
mov temp2,bx
mov dx,(brick ptr totalbricks [di] ).y_axis;
mov ax,(brick ptr totalbricks [di] ).y_axisend;
mov temp1,ax
L05:
MOV AL, (brick ptr totalbricks [di] ).color;
MOV AH, 0CH
INT 10H
inc cx
cmp cx,temp2
jne L05
mov cx,temp
inc dx
cmp dx,temp1
jne L05


add di,TYPE brick

pop cx
loop L1


ret
drawbrick endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
deletebrick proc


mov si,0
mov cx,12
mov ax,0
mov bx,0
mov dx,0
L2:
push cx
mov ax,(brick ptr totalbricks [si] ).y_axis;
mov bx,(brick ptr totalbricks [si] ).y_axisend;
mov cx,(brick ptr totalbricks [si] ).x_axis;
mov dx,(brick ptr totalbricks [si] ).x_axisend




.if(ball_y <= bx  &&  ball_y >= ax && ball_x >= cx && ball_x <= dx)


neg flagdown
neg flagup
call sound
dec (brick ptr totalbricks [si] ).strength
mov cx,(brick ptr totalbricks [si] ).strength


cmp cx,0
jne nobreak
mov (brick ptr totalbricks [si] ).y_axis,185
mov (brick ptr totalbricks [si] ).y_axisend,190
mov (brick ptr totalbricks [si] ).x_axis,0
mov (brick ptr totalbricks [si] ).x_axisend,90
mov (brick ptr totalbricks [si] ).color,0
inc scoreUnit
.if(scoreunit >= 10)
sub scoreUnit,10
add scoreTen,1
.endif



nobreak:
.endif



add si,TYPE brick

pop cx
loop L2



ret
deletebrick endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

loselife proc

 
 mov ball_y ,100
 mov ball_x, 150
 mov ball_yend, 110
 mov ball_xend , 160
 dec life
 cmp life,0
 je down
 
 ret

loselife endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;











;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

drawball proc
;ball 
MOV CX, ball_x
MOV DX, ball_y
L15:
MOV AL, 1h ;Blue color
MOV AH, 0CH
INT 10H
inc cx
mov bx,cx
cmp bx,ball_xend
jne L15
;k5:
mov cx,ball_x
inc dx
cmp dx,ball_yend
jne L15
ret
drawball endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawrectangle proc

;rectangle 

MOV CX, start
MOV DX, y
L5:
MOV AL, 1h ;Blue color
MOV AH, 0CH
INT 10H
inc cx
mov bx,cx
cmp bx,endd
jne L5
;k5:
mov cx,start
inc dx
cmp dx,180
jne L5

ret

drawrectangle endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lefta proc

mov cx,start
mov dx ,y
cmp cx,0
je outt
sub start,5
sub endd,5
 outt:

 mov ax,0
 mov bx,0
 

 ret
lefta endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

right proc


.if(level ==1 )
.if(start < 250);250)
add start,5
add endd,5
.endif
.endif

.if(level >= 2 )
.if(start < 260);250)
add start,5
add endd,5
.endif
.endif

 mov ax,0
 mov bx,0

 

 ret 
right endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;












displaytexts proc 
mov ah, 02h
mov dh, 24  ;dh is y coordinate
mov dl, 0  ;dl is x coordinate
int 10h
mov dx, offset string
mov ah, 9h
int 21h  

mov ax, 0  
mov bx,0
mov cx,0
mov dx,0

Mov dl, ' ' 
Mov ah, 02h
Int 21h

mov cx,life
displayHeart:
Mov dl, 3
Mov ah, 02h
Int 21h
loop displayHeart



mov ax, 0  
mov bx,0
mov cx,0
mov dx,0



mov ah, 02h
mov dh, 24  ;dh is y coordinate
mov dl, 10  ;dl is x coordinate
int 10h
mov dx, offset string2
mov ah, 9h
int 21h  

mov ax, 0  
mov bx,0
mov cx,0
mov dx,0
mov cl,scoreTen


add cl,48
Mov dl,cl 
Mov ah, 02h
Int 21h


mov ax, 0  
mov bx,0
mov cx,0
mov dx,0
mov cl,scoreUnit


add cl,48
Mov dl,cl 
Mov ah, 02h
Int 21h




mov ah, 02h
mov dh, 24  ;dh is y coordinate
mov dl, 21 ;dl is x coordinate
int 10h
mov dx, offset levels
mov ah, 9h
int 21h  


mov ax, 0  
mov bx,0
mov cx,0
mov dx,0
mov cl,levelss

add cl,48
Mov dl,cl 
Mov ah, 02h
Int 21h

ret
displaytexts endp



mainmenu proc


lea dx,lines
mov ah,09h
int 21h

lea dx, maintitle
mov ah, 09h
int 21h

lea dx,lines
mov ah,09h
int 21h


lea dx,names
mov ah, 09h
int 21h


call newline
call newline
call newline
call newline
call newline
call newline



lea dx,prompt
mov ah,09h
int 21h

mov si, offset username

name_input: 
mov ah,1
int 21h
cmp al,13
je nooo
mov [si],al
inc si
jmp name_input 
nooo:
ret
mainmenu endp




newline proc
mov dl, 10
mov ah, 02h
int 21h
mov dl, 13
mov ah, 02h
int 21h
ret
newline endp

options proc

backup:
 MOV AH, 06h
 MOV AL, 0
 MOV CX, 0
 MOV DH, 80
 MOV DL, 80
 MOV BH, 0h
 INT 10h


 mov ax,0
 mov bx,0
 mov cx,0
 mov dx,0


mov ah, 02h
mov dh, 2  ;dh is y coordinate
mov dl, 3  ;dl is x coordinate
int 10h
mov dx, offset welcome
mov ah, 9h
int 21h  

 mov ax,0
 mov bx,0
 mov cx,0
 mov dx,0


mov ah, 02h
mov dh, 2  ;dh is y coordinate
mov dl, 25  ;dl is x coordinate
int 10h
mov dx, offset username
mov ah, 9h
int 21h  

mov ax,0
 mov bx,0
 mov cx,0
 mov dx,0


mov ah, 02h
mov dh, 8  ;dh is y coordinate
mov dl, 12  ;dl is x coordinate
int 10h
mov dx, offset new_game
mov ah, 9h
int 21h  

mov ax,0
mov bx,0
mov cx,0
mov dx,0



mov ah, 02h
mov dh, 11 ;dh is y coordinate
mov dl, 12  ;dl is x coordinate
int 10h
mov dx, offset instruct
mov ah, 9h
int 21h  

mov ax,0
mov bx,0
mov cx,0
mov dx,0


mov ah, 02h
mov dh, 14 ;dh is y coordinate
mov dl, 12  ;dl is x coordinate
int 10h
mov dx, offset high_sc
mov ah, 9h
int 21h  

mov ax,0
mov bx,0
mov cx,0
mov dx,0


mov ah, 02h
mov dh, 17 ;dh is y coordinate
mov dl, 15  ;dl is x coordinate
int 10h
mov dx, offset exitt
mov ah, 9h
int 21h  

mov ax,0
mov bx,0
mov cx,0
mov dx,0

call drawborder





mov ah,0
int 16h



.if(al == 110)
jmp playy
.elseif(al == 105)
call instruc
.elseif(al == 101)
 MOV AH, 06
 MOV AL, 0
 MOV CX, 0
 MOV DH, 80
 MOV DL, 80
 MOV BH, 0h
 INT 10h
jmp khatam


.endif



jmp backup
playy:
ret 

options endp



instruc proc

mov ax,0
mov bx,0
mov cx,0
mov dx,0

MOV AH, 06
 MOV AL, 0
 MOV CX, 0
 MOV DH, 80
 MOV DL, 80
 MOV BH, 0h
 INT 10h



mov ah, 02h
mov dh, 2  ;dh is y coordinate
mov dl, 8  ;dl is x coordinate
int 10h
mov dx, offset instruct
mov ah, 9h
int 21h  

mov ax,0
mov bx,0
mov cx,0
mov dx,0









mov ax,0
mov bx,0
mov cx,0
mov dx,0

mov ah, 02h
mov dh, 6  ;dh is y coordinate
mov dl, 0  ;dl is x coordinate
int 10h
mov dx, offset line1
mov ah, 9h
int 21h  

mov ax,0
mov bx,0
mov cx,0
mov dx,0

mov ah, 02h
mov dh, 10  ;dh is y coordinate
mov dl, 0  ;dl is x coordinate
int 10h
mov dx, offset line2
mov ah, 9h
int 21h  

mov ax,0
mov bx,0
mov cx,0
mov dx,0

mov ah, 02h
mov dh, 14  ;dh is y coordinate
mov dl, 0  ;dl is x coordinate
int 10h
mov dx, offset line3
mov ah, 9h
int 21h  

mov ax,0
mov bx,0
mov cx,0
mov dx,0

mov ah, 02h
mov dh, 18  ;dh is y coordinate
mov dl, 0  ;dl is x coordinate
int 10h
mov dx, offset line4
mov ah, 9h
int 21h  

mov ax,0
mov bx,0
mov cx,0
mov dx,0




mov ah,0
int 16h


ret
instruc endp

drawborder proc
mov ax, 0  
mov bx,0
mov cx,0
mov dx,0

MOV CX, 20
MOV DX, 40
L5:
MOV AL, 3h ;Blue color
MOV AH, 0CH
INT 10H
inc cx
mov bx,cx
cmp bx,300
jne L5
je k5
k5:




mov ax, 0  
mov bx,0
mov cx,0
mov dx,0

MOV CX, 20
MOV DX, 180
L6:
MOV AL, 3h ;Blue color
MOV AH, 0CH
INT 10H
inc cx
mov bx,cx
cmp bx,300
jne L6
je k6
k6:




mov ax, 0  
mov bx,0
mov cx,0
mov dx,0


MOV CX, 20
MOV DX, 40
L7:
MOV AL, 3h ;Blue color
MOV AH, 0CH
INT 10H
inc dx
mov bx,dx
cmp bx,180
jne L7
je k7
k7:








mov ax, 0  
mov bx,0
mov cx,0
mov dx,0


MOV CX, 300
MOV DX, 40
L8:
MOV AL, 3h ;Blue color
MOV AH, 0CH
INT 10H
inc dx
mov bx,dx
cmp bx,180
jne L8
je k8
k8:




mov ax, 0  
mov bx,0
mov cx,0
mov dx,0














ret

drawborder endp


sound proc
        push ax
        push bx
        push cx
        push dx
        mov     al, 182         ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, 400        ; Frequency number (in decimal)
                                ;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 2          ; Pause for duration of note.
pause1:
        mov     cx, 65535
pause2: 
        dec     cx
        jne     pause2
        dec     bx
        jne     pause1
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 11111100b   ; Reset bits 1 and 0.
        out     61h, al         ; Send new value.

        pop dx
        pop cx
        pop bx
        pop ax

ret
sound endp

Create_File Proc

mov ax,0
mov bx,0
mov cx,0
mov dx,0


mov ah, 3ch
mov dx, offset filename
mov cx,0
int 21h
mov handle, ax

mov ah,3eh
mov bx,handle
int 21h
ret 
Create_File endp

Write_File Proc
mov dx, offset filename
mov al,1
mov ah,3dh
int 21h

mov bx,ax
mov cx,0
mov ah,42h
mov al,02h
int 21h

mov cx, lengthof username
mov dx,offset username
mov ah,40h
int 21h

mov cx, lengthof spaces
mov dx,offset spaces
mov ah,40h
int 21h

mov cx, lengthof scoreTen
mov dx, offset scoreTen
mov ah,40h
int 21h

mov cx, lengthof scoreUnit
mov dx, offset scoreUnit
mov ah,40h
int 21h

mov cx, lengthof spaces
mov dx,offset spaces
mov ah,40h
int 21h

mov cx, lengthof level
mov dx,offset level
mov ah,40h
int 21h

mov ah,3eh
mov bx, handle
int 21h
ret
Write_File endp












exit_game::
end