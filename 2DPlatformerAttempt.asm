INCLUDE Irvine32.inc ;library

.data

ground BYTE "------------------------------------------------------------------------------------------------------------------------",0
strScore BYTE "Your score is: ",0
score BYTE 0

EndRound BYTE "YOU'VE GOT 10 CIONS!, YOU WON!!",0
xPosition byte 20
yPosition byte 20

inputChar byte ?

xCPosition byte ?
yCPosition byte ?

.code
main PROC far

; draw ground
          mov dl,0
          mov dh,29
          call gotoxy
          mov edx, offset ground
          call Writestring

          call dropPlayer
          call createRandomCoin
          call DropCoin

          call Randomize

   gameLoop:
; getting points
		mov bl,xPosition
		cmp bl,xCPosition
		jne notCollecting
		mov bl,yPosition
		cmp bl,yCPosition
		jne notCollecting

;player is intersecting coin:
		inc score
		call CreateRandomCoin
		call DropCoin
	
		notCollecting:
        	mov eax,white (black * 16)
                call SetTextColor 


;draw score
              mov dl, 0
              mov dh, 0
              call gotoxy
              mov edx, offset strScore
              call Writestring

	      mov al, score
	      cmp al, 10
	      jge exiteround
	      add al,"0"
	      call Writechar

;gravity logic
   gravity:
             cmp yPosition , 28
             jge onGround

   ;make player fall
             call updatePlayer
	     inc yPosition
	     call dropPlayer
	     mov eax, 100
	     call delay
	     jmp gravity

    onGround:
;get user key input
             call ReadChar
             mov  inputChar, al

;exit game if user typed X
         cmp inputChar,"x"
	 je exitGame

	 cmp inputChar,"w"
	 je moveUp

	 cmp inputChar,"s"
	 je moveDown

	 cmp inputChar,"a"
	 je moveLeft

	 cmp inputChar,"d"
	 je moveRight

	 moveUp:  
;allow player to jump
               mov ecx, 1
	       jumpLoop:
	       call updatePlayer
	       dec yPosition
	       call dropPlayer
	       mov eax, 10
	       call delay 
	       
	  loop jumpLoop
	  jmp gameLoop

	 moveDown:
	 call updatePlayer
	 inc yPosition
	 call dropPlayer
	  jmp gameLoop


	 moveLeft:
	 call updatePlayer
	 dec xPosition
	 call dropPlayer
	  jmp gameLoop

	 moveRight:
	 call updatePlayer
	 inc xPosition
	 call dropPlayer
	  jmp gameLoop

   jmp gameLoop
   
   exiteround:
           mov dl, 35
           mov dh, 14
           call gotoxy
           mov edx, offset EndRound
	   call Writestring

        exitGame:
	exit
main ENDP

dropPlayer proc near
;draw Player at (xPosition, yPosition)
              mov dl, xPosition
	      mov dh, yPosition
	      call gotoxy
              mov al, 'X'
	      call WriteChar
	      ret
dropPlayer endp

updatePlayer proc near
              mov dl, xPosition
	      mov dh, yPosition
	      call gotoxy
              mov al, ' '
	      call WriteChar
	      ret
updatePlayer endp

DropCoin PROC near
	       mov eax, red (red * 16)
	       call SetTextColor
	       mov dl, xCPosition
	       mov dh, yCPosition
	       call Gotoxy
	       mov al, "X"
	       call WriteChar
	       ret
DropCoin ENDP


createRandomCoin proc near
               mov eax, 50
	       call RandomRange
	       mov xCPosition,al
	       mov yCPosition,27
	       ret
createRandomCoin endp

;recomended if there is no round
;aboveDigitPrinting proc 
;	mov dl , al
;       add dl , D      where D is the difference value between the scorer and its crosponding char in ASCII
;	call WriteString
;aboveDigitPrinting endp 

END main
