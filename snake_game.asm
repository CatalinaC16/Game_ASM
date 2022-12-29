.386
.model flat, stdcall

includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf: proc


includelib canvas.lib
extern BeginDrawing: proc

public start

.data
window_title DB "SnakeGame",0

;dimensiuni fereastra
area_width EQU 400
area_height EQU 400
area_width0 EQU 0
area_height0 EQU 0

area dd 0
counter DD 0
ok dd 0
; declarare sir pe care l-am alocat dinamic
snake_array dd ?

format db "%s %d", 13, 10, 0
arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

;directii
LEFT EQU 0
UP EQU 1
RIGHT equ 2
DOWN equ 3


symbol_width EQU 10
symbol_height EQU 20

symbol_width3 EQU 14
symbol_height3 EQU 15

symbol2_width EQU 19
symbol2_height EQU 20

;lungimea initiala
snake_lungime dd 20

directie db 2
text db "Ai pierdut",13,10,0

;coordonate mancare buna
apX dd 120
apy dd 100

;coordonate mancare 
mX dd 160
my dd 148

;coordonate mancare care creste scor
blX dd 20
blY dd 30

include digits.inc
include letters.inc
include zid.inc
include food.inc
;variabila in care am salvat scorul
scor dd 0

.code

; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha

	mov eax, [ebp+arg1]
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	
	lea esi, letters
	jmp draw_text
	
	
	make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
	make_space:
	mov eax, 26
	
	lea esi, letters


	draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
	
	bucla_simbol_linii:
	mov edi, [ebp+arg2]
	mov eax, [ebp+arg4]
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3]
	shl eax, 2
	add edi, eax
	push ecx
	
	mov ecx, symbol_width
	bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
	simbol_pixel_alb:
	mov dword ptr [edi], 0117864h
	simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp
;procedura care creeaza mancare galbena, folosindu-se de matricea din fisierul food
make_badfood proc
	push ebp
	mov ebp, esp
	pusha

	mov eax, [ebp+arg1]
	lea esi, food

	draw_text:
	mov ebx, symbol_width3
	mul ebx
	mov ebx, symbol_height3
	mul ebx
	add esi, eax
	mov ecx, symbol_height3
	bucla_simbol_linii:
	mov edi, [ebp+arg2]
	mov eax, [ebp+arg4]
	add eax, symbol_height3
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3]
	shl eax, 2
	add edi, eax
	push ecx
	mov ecx, symbol_width3

	bucla_simbol_coloane:
	cmp byte ptr [esi], 1
	je simbol_pixel_colorat
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
	simbol_pixel_colorat:
	mov dword ptr [edi], 0AF601Ah
	simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	
	popa
	mov esp, ebp
	pop ebp
	ret
make_badfood endp
;procedura care creeaza mancare rosie, folosindu-se de matricea din fisierul food
make_food proc
	push ebp
	mov ebp, esp
	pusha

	mov eax, [ebp+arg1]
	lea esi, food

	draw_text:
	mov ebx, symbol_width3
	mul ebx
	mov ebx, symbol_height3
	mul ebx
	add esi, eax
	mov ecx, symbol_height3
	bucla_simbol_linii:
	mov edi, [ebp+arg2]
	mov eax, [ebp+arg4]
	add eax, symbol_height3
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3]
	shl eax, 2
	add edi, eax
	push ecx
	mov ecx, symbol_width3

	bucla_simbol_coloane:
	cmp byte ptr [esi], 1
	je simbol_pixel_colorat
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
	simbol_pixel_colorat:
	mov dword ptr [edi], 0FF0000h
	simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	
	popa
	mov esp, ebp
	pop ebp
	ret
make_food endp

;procedura de facut zid
make_zid proc
	push ebp
	mov ebp, esp
	pusha

	mov eax, [ebp+arg1]
	lea esi,zid

	draw_text:
	mov ebx, symbol2_width
	mul ebx
	mov ebx, symbol2_height
	mul ebx
	add esi, eax
	mov ecx, symbol2_height
	bucla_simbol_linii:
	mov edi, [ebp+arg2]
	mov eax, [ebp+arg4]
	add eax, symbol2_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3]
	shl eax, 2
	add edi, eax
	push ecx
	mov ecx, symbol2_width

	bucla_simbol_coloane:
	cmp byte ptr [esi], 1
	je simbol_pixel_colorat
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
	simbol_pixel_colorat:
	mov dword ptr [edi], 0781159h
	simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	
	popa
	mov esp, ebp
	pop ebp
	ret
make_zid endp

;face mancare care creste scorul- albastra
make_lucky proc
push ebp
mov ebp, esp
pusha

mov eax, [ebp+arg1]
lea esi, food

draw_text:
mov ebx, symbol_width
mul ebx
mov ebx, symbol_height
mul ebx
add esi, eax
mov ecx, symbol_height3
bucla_simbol_linii:
mov edi, [ebp+arg2]
mov eax, [ebp+arg4]
add eax, symbol_height3
sub eax, ecx
mov ebx, area_width
mul ebx
add eax, [ebp+arg3]
shl eax, 2
add edi, eax
push ecx
mov ecx, symbol_width3

bucla_simbol_coloane:
cmp byte ptr [esi], 1
je simbol_pixel_colorat
mov dword ptr [edi], 0
jmp simbol_pixel_next
simbol_pixel_colorat:
mov dword ptr [edi],01A74AFh
simbol_pixel_next:
inc esi
add edi, 4
loop bucla_simbol_coloane
pop ecx
loop bucla_simbol_linii

popa
mov esp, ebp
pop ebp
ret
make_lucky endp


make_text_macro macro symbol, drawArea, x, y
push y
push x
push drawArea
push symbol
call make_text
add esp, 16
endm

make_zid_macro macro symbol, drawArea, x, y
push y
push x
push drawArea
push symbol
call make_zid
add esp,16
endm

make_food_macro macro symbol, drawArea, x, y
  push y
push x
push drawArea
push symbol
call make_food
add esp,16
endm

make_badfood_macro macro symbol, drawArea, x, y
push y
push x
push drawArea
push symbol
call make_badfood
add esp,16
endm
make_luckyfood_macro macro symbol, drawArea, x, y
push y
push x
push drawArea
push symbol
call make_lucky
add esp,16
endm


snake_macro macro

local eti
pusha
make_zid_macro 0,area,60,50
make_zid_macro 0,area,40,150
make_zid_macro 0,area,20,40
make_zid_macro 0,area,30,160
make_zid_macro 0,area,140,60
make_zid_macro 0,area,130,70
make_zid_macro 0,area,140,190
make_zid_macro 0,area,130,180
make_zid_macro 0,area,200,150
make_zid_macro 0,area,120,140
make_zid_macro 0,area,240,260
make_zid_macro 0,area,250,90
make_zid_macro 0,area,230,270
make_zid_macro 0,area,330,270
make_zid_macro 0,area,240,290
make_zid_macro 0,area,230,220
make_zid_macro 0,area,260,70
make_zid_macro 0,area,30,280
make_zid_macro 0,area,50,100
make_zid_macro 0,area,330,150
make_zid_macro 0,area,320,140
make_zid_macro 0,area,40,270
make_zid_macro 0,area,170,290
make_zid_macro 0,area,180,300
make_zid_macro 0,area,20,380
make_zid_macro 0,area,300,333
make_zid_macro 0,area,333,40
make_zid_macro 0,area,120,240
make_zid_macro 0,area,130,320
make_zid_macro 0,area,230,320
make_zid_macro 0,area,333,350
make_zid_macro 0,area,300,206
make_zid_macro 0,area,380,90
make_zid_macro 0,area,180,370

mov esi,snake_array

   
mov eax,[esi+4]
mov ebx,area_width
mul ebx
add eax,[esi]
shl eax,2
add eax,area

;daca intalneste pixel de zid
cmp dword ptr [eax],0781159h
jne ext1

push dword ptr [scor]
push offset text
push offset format
call printf
add esp,12
mov dword ptr [ok],1
jmp eti


ext1:
;punem mancare la pozitiile initiale
make_food_macro 1,area,apX,apY
make_badfood_macro 1,area,mX,mY
make_luckyfood_macro 1,area,blX,blY

et:
mov esi,snake_array
   
mov eax,[esi+4]
mov ebx,area_width
mul ebx
add eax,[esi]
shl eax,2
add eax,area

;daca intalneste pixel de culoarea rosie, atunci coada si scorul cresc cu 1 
cmp dword ptr [eax],0FF0000h
jne ff

;generare random in functie de counter
mov ebx,counter
imul ebx,5
add ebx,38
cmp ebx,350
jle emp
mov ebx,counter
sub ebx,25
emp:
;noi coordonate pentru mancarea rosie
mov dword ptr [apX],ebx
mov dword ptr [apY],ebx

;punem mancare la noile coordonate
make_food_macro 1,area,apX,apY

;crestem scorul si coada cu 1 
inc dword ptr [snake_lungime]
inc dword ptr [scor]


ff:
;daca atinge mancare stricata
  
cmp dword ptr [eax],0AF601Ah
jne jj

;daca lungimea sarpelui scade sub 3, nu mai mananca mancarea galbena

cmp dword ptr [snake_lungime],3
jl jj
;generare random in functie de counter
	mov ebx,counter
	imul ebx,3
	add ebx,12
	cmp ebx,350
	jle ett
	mov ebx,counter
	add ebx,50
ett:
;noile coordonate ale mancarii stricate
mov dword ptr [mX],ebx
mov dword ptr [mY],ebx

make_badfood_macro 1,area,mX,mY

;lungimea sarpelui scade
dec dword ptr [snake_lungime]
;scorul creste
inc dword ptr [scor]
   
jj:
;comparare cu pixel de culoare albastra

cmp dword ptr [eax],01A74AFh
jne extt

;generare random
mov ebx,counter
imul ebx,3
add ebx,3
cmp ebx,350
jle etb
mov ebx,counter
add ebx,145

etb:
;noile coordonate ale mancarii albastre
mov dword ptr [blX],ebx
mov dword ptr [blY],ebx

make_luckyfood_macro 1,area,blX,blY

;scorul creste cu 5
add dword ptr [scor],5

extt:
;daca sarpele depaseste marginea din dreapta a jocului, in consola apare mesajul Ai pierdut si scorul
mov edx,area_width
cmp dword ptr [esi], edx
jle ext2

push dword ptr [scor]
push offset text
push offset format
call printf
add esp,12
mov dword ptr [ok],1
jmp eti
ext2:
;marginea din stanga
mov edx,area_width0
cmp dword ptr [esi], edx
jg ext3

push dword ptr [scor]
push offset text
push offset format
call printf
add esp,12
mov dword ptr [ok],1
jmp eti
ext3:
;marginea de sus 
mov edx,area_height0
cmp dword ptr [esi+4], edx
jg ext4

push dword ptr [scor]
push offset text
push offset format
call printf
add esp,12
mov dword ptr [ok],1
jmp eti
ext4:
;marginea de jos
mov edx,area_height
cmp dword ptr [esi+4], edx
jl ext5

push dword ptr [scor]
push offset text
push offset format
call printf
add esp,12
mov dword ptr [ok],1
jmp eti


ext5:
;cand sarpele isi musca coada
cmp dword ptr [eax],000FF00h
jne eti

push dword ptr [scor]
push offset text
push offset format
call printf
add esp,12
mov dword ptr [ok],1

eti:
popa
   
endm

; functie care modifica directie in functie de cea care e trimisa ca parametru
; coduri ascii:
; stanga - 25; sus - 26; dreapta - 27; jos - 28;
; ca sa fie usor, am pus ca stanga sa fie 0, sus 1, dreapta 2 si jos 3
; cand trimitem ca parametru cand apasam o tasta, scadem din codul primit in functia draw, 25 si avem direct directia
update_move proc
push ebp
mov ebp, esp
 

	mov eax, [ebp+arg1]
	push eax
	mov bl,al
	mov cl,directie
	sub bl,cl
	cmp bl, 2
	je km
	cmp bl,-2
	je km
	mov byte ptr [directie], al
	km:
	
	mov esp, ebp
	pop ebp
	ret 4
update_move endp

;pune pe pozitiile din vector coordonatele capului
create_snake proc
   push ebp
   mov ebp, esp
   pusha

   mov esi,snake_array
   
   mov ebx, dword ptr [esi]
   mov edx, dword ptr [esi+4]
   add esi,8
   
   mov ecx,snake_lungime
   dec ecx
   
   snakey:
   mov dword ptr [esi],ebx
   mov dword ptr [esi+4],edx
   add esi,8

   loop snakey
   
popa
mov esp, ebp
pop ebp
ret
create_snake endp

;shiftare vector pozitii
shiftare macro
mov esi,snake_array
mov ecx,snake_lungime

mov edx,ecx
dec edx

imul edx,8
add esi,edx

shift:

mov eax,[esi]
mov ebx,[esi+4]

mov [esi+12],ebx
mov [esi+8],eax

sub esi,8
loop shift

endm

parcurgere proc
push ebp
mov ebp, esp
pusha

mov esi,snake_array
;facem capul sarpelui de o alta culoare

mov eax,[esi+4]
mov ebx,area_width
mul ebx
add eax,[esi]
shl eax,2
add eax,area
mov dword ptr [eax],0ADFF2Fh
add esi,8


   mov ecx,snake_lungime
   dec ecx
   ;corpul sarpelui
   snaky:
		mov eax,[esi+4]
		mov ebx,area_width
		mul ebx
		add eax,[esi]
		shl eax,2
		add eax,area
		mov dword ptr [eax],000FF00h
		add esi,8

   loop snaky
   shiftare
popa
mov esp, ebp
pop ebp
ret
parcurgere endp

; functie care verifica directia si muta snake-ul in directia respectiva
move_snake proc

push ebp
mov ebp, esp
pusha

xor eax, eax
mov al, directie

move_down:

cmp eax, DOWN
jne move_left

mov esi,snake_array  

inc dword ptr [esi+4]
call parcurgere
jmp final

move_left:

cmp eax,LEFT
jne move_right

mov esi,snake_array
   
dec dword ptr [esi]
call  parcurgere 
jmp final

move_right:

cmp eax,RIGHT
jne move_up

mov esi,snake_array
     
inc dword ptr [esi]
call parcurgere  
jmp final

move_up:

cmp eax, UP
jne final

mov esi,snake_array
   
dec dword ptr [esi+4]
call parcurgere

  final:

popa
mov esp, ebp
pop ebp
ret
move_snake endp


; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click- se misca sarpele in directia in care vrem, 3 - s-a apasat o tasta)
; arg2 - x (in cazul apasarii unei taste, x contine codul ascii al tastei care a fost apasata)
; arg3 - y
draw proc
push ebp
mov ebp, esp
pusha
  cmp dword ptr [ok],1
  je afisare
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer
	cmp eax,3
	jz move

jmp afisare_litere

evt_click:
jmp afisare_litere

evt_timer:


inc counter

mov eax, area_width
mov ebx, area_height
mul ebx
shl eax, 2
push eax
push 0
push area
call memset
add esp, 12


afisare_litere:

mov ebx, 10
mov eax, scor
;cifra unitatilor
mov edx, 0
div ebx
add edx, '0'
make_text_macro edx, area, 350, 380
;cifra zecilor
mov edx, 0
div ebx
add edx, '0'
make_text_macro edx, area, 340, 380
;cifra sutelor
mov edx, 0
div ebx
add edx, '0'
make_text_macro edx, area, 330, 380
   
cmp dword ptr [counter],100
jne continue
mov dword ptr [counter],0

continue:
;scriem un mesaj
make_text_macro 'S', area,130, 20
make_text_macro 'N', area, 140, 20
make_text_macro 'A', area, 150, 20
make_text_macro 'K', area, 160, 20
make_text_macro 'E', area, 170, 20
make_text_macro ' ', area, 180, 20
make_text_macro 'G', area, 190, 20
make_text_macro 'A', area, 200, 20
make_text_macro 'M', area, 210, 20
make_text_macro 'E', area, 220, 20

make_text_macro 'S', area, 280, 380
make_text_macro 'C', area, 290, 380
make_text_macro 'O', area, 300, 380
make_text_macro 'R', area, 310, 380
make_text_macro ' ', area, 320, 380
;apelam functia de miscare in functie de directie si macroul snake in care testam cazurile speciale
call move_snake
snake_macro

 
jmp final_draw


move:
;modificare directie de la taste(sageti)
mov eax,[ebp+arg2]
sub eax, 25h
push eax
call update_move
jmp final_draw

afisare:

make_text_macro 'G', area, 170, 60
make_text_macro 'A', area, 180, 60
make_text_macro 'M', area, 190, 60
make_text_macro 'E', area, 200, 60
make_text_macro 'O', area, 220, 60
make_text_macro 'V', area, 230, 60
make_text_macro 'E', area, 240, 60
make_text_macro 'R', area, 250, 60

final_draw:

popa
mov esp, ebp
pop ebp
ret 
draw endp



start:

;alocam memorie pentru zona de desenat
mov eax, area_width
mov ebx, area_height
mul ebx
;fiecare elm este pe 4 octeti
shl eax, 2
push eax
call malloc
; x*width+y m[x][y] accesare element

add esp, 4
mov area, eax
;aloc memorie vector de coordonate
mov eax,1000
mov ebx,8
mul ebx
push eax
call malloc
add esp,4
mov snake_array,eax
mov esi, snake_array
mov dword ptr [esi],100
mov dword ptr [esi+4],100
;creeaza sarpele
mov dword ptr[ok],0
call create_snake
;apelam functia de desenare a ferestrei
; typedef void (*DrawFunc)(int evt, int x, int y);
; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);


push offset draw
push area
push area_height
push area_width
push offset window_title
call BeginDrawing
add esp, 20


;terminarea programului
push 0
call exit
end start
