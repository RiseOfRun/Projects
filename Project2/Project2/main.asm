.386
.model flat, stdcall
; ��������� ������� �������� ����������� ���������� extrn,
; ����� ����� @ ����������� ����� ����� ������������ ����������,
; ����� ��������� ����������� ��������� ��������� � near
extrn GetStdHandle@4:near
extrn WriteConsoleA@20:near
extrn CharToOemA@8:near
extrn ReadConsoleA@20:near
extrn ExitProcess@4:near ; ������� ������ �� ���������
extrn lstrlenA@4:near ; ������� ����������� ����� ������
; ������� ������
.data
dout dd ? ; ���������� ������ (��������� dd ����������� ������ ������� 32 ���� (4 �����))
din dd ? ; ���������� �����
strn db "������� �����: ",13,10,0 ; ��������� ������,
; ����������� �������: 13 � ������� �������, 10 � ������� �� ����� ������, 0 � ����� ������
; (� �������������� ��������� db ������������� ������ ������)
buf db 200 dup (?); ����� ��� ��������/��������� �����
lens dd ? ; ���������� ���������� ��������
;��� �������� �����
numa dd ?
numb dd ?
; ������� ����
.code
start: ; ����� ����� ����� (����������� ����������)
; ������������ ������ strn
push offset strn ; ��������� ������� ���������� � ���� ��������
; offset � ��������, ������������ ��������
push offset strn
call CharToOemA@8 ; ����� �������

; ������� ���������� �����
push -10
call GetStdHandle@4
mov din, eax ; ����������� ��������� �� �������� eax � ������ ������ � ������ din

; ������� ���������� ������
push -11
call GetStdHandle@4
mov dout, eax

; ����� ������
push offset strn ; � ���� ���������� ��������� �� ������
call lstrlenA@4 ; ����� � eax

; ����� ������� writeconsolea ��� ������ ������ strn
push 0 ; � ���� ���������� 5-� ��������
push offset lens ; 4-� ��������
push eax ; 3-� ��������
push offset strn ; 2-� ��������
push dout ; 1-� ��������
call WriteConsoleA@20

reenterA:
; ���� ������
push 0 ; � ���� ���������� 5-� ��������
push offset lens ; 4-� ��������
push 200 ; 3-� ��������
push offset buf ; 2-� ��������
push din ; 1-� ��������
call ReadConsoleA@20

cmp lens, 5
jl reenterA

; ��������� 1 ������
push offset buf
sub lens, 2
mov ecx, lens
mov esi,offset buf ; ������ ������ �������� � ���������� buf
xor ebx,ebx ; �������� ebx
xor eax,eax ; �������� eax
convert: ; ����� ������ �����
mov edx, 10 ; �� ��� ����� ����� ��������, ������ � ����� �.�. ��� ��������� dx ����������
mov bl, [esi] ; �������� ������ �� ��������� ������ � bl
sub bl, '0' ; �������� �� ���������� ������� ��� ����
mul edx ; �������� ������ �������� ax �� 10, ��������� � � ax
add eax, ebx ; �������� � ����������� ����� ����� ��������
inc esi ; ������� �� ��������� ������
loop convert ; ����� �������� �����
mov numa, eax

; ����� ������
push offset strn ; � ���� ���������� ��������� �� ������
call lstrlenA@4
push 0 ; � ���� ���������� 5-� ��������
push offset lens ; 4-� ��������
push eax ; 3-� ��������
push offset strn ; 2-� ��������
push dout ; 1-� ��������
call WriteConsoleA@20

; ���� ������
push 0 ; � ���� ���������� 5-� ��������
push offset lens ; 4-� ��������
push 200 ; 3-� ��������
push offset buf ; 2-� ��������
push din ; 1-� ��������
call ReadConsoleA@20

; ��������� 2 ������
xor eax, eax
push offset buf
sub lens, 2
mov ecx, lens
mov esi,offset buf ; ������ ������ �������� � ���������� buf
xor ebx, ebx ; �������� ebx
xor eax, eax ; �������� eax
convertb: ; ����� ������ �����
xor edx,edx ; �������� edx
mov dl, 10 ; �� ��� ����� ����� ��������, ������ � ����� �.�. ��� ��������� dx ����������
mov bl, [esi] ; �������� ������ �� ��������� ������ � bl
sub bl, '0' ; �������� �� ���������� ������� ��� ����
mul dx ; �������� ������ �������� bx �� 10, ��������� � � ax
add eax, ebx ; �������� � ����������� ����� ����� ��������
inc esi ; ������� �� ��������� ������
loop convertb ; ����� �������� �����
mov numb, eax
; �������� �����
mov eax, numa
mov ebx, numb
add eax, ebx
mov numa, eax


;0123

;  23 - ax
;  01 - dx
;0123 - ebx

; �������������� ����������
xor ecx, ecx
xor edx, edx
mov eax, numa
mov edi, 16
.while eax>=edi ; ���� ����� > 16
div edi
add dx, '0'
.if dx>'9' ; ���� ������ > 9, �������� �� A,B,...
add dx, 7
.endif
push edx ; ������ ������ � ����, ��� ��������������
inc ecx
xor edx, edx
.endw
add ax, '0'
.if ax>'9'
add ax, 7
.endif
push eax
inc ecx
; ������ ����������� ������
mov esi, offset buf ; ������ ������ �������� � ���������� buf
convertc:
pop [esi]
inc esi
loop convertc

; ������� ���������
push offset buf ; � ���� ���������� ��������� �� ������
call lstrlenA@4
push 0 ; � ���� ���������� 5-� ��������
push offset lens ; 4-� ��������
push eax ; 3-� ��������
push offset buf ; 2-� ��������
push dout ; 1-� ��������
call WriteConsoleA@20
; ����� �� ���������
push 0 ; ��������: ��� ������
call ExitProcess@4
end start