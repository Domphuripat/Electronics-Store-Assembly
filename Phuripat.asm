.MODEL SMALL
.STACK 100H
.386

.DATA 
    ; Color definitions
    redBlinkStart db 27, '[5;31m$', 0   ; Blink and red text
    redBlinkEnd db 27, '[0m$', 0        ; Reset color
    greenText db 27, '[32m$', 0         ; Green text
    blueText db 27, '[34m$', 0          ; Blue text
    magentaText db 27, '[35m$', 0       ; Magenta text
    cyanText db 27, '[36m$', 0          ; Cyan text
    whiteText db 27, '[37m$', 0         ; White text
    resetColor db 27, '[0m$', 0         ; Reset color
    OrangeText db 27, '[33m$', 0        ; Orange text
    brightYellowText db 27, '[1;33m$', 0; Bright Yellow text

    ; Login system
    loginHeader db 27, '[36m', 10,10, '+--------------------------------+'
                               db 10, '|     Electronics Store Login    |'
                               db 10, '+--------------------------------+', 27, '[0m$'
    askUsername db 27, '[33m', 10,10, 'Enter Your User Name: ', 27, '[32m$'
    greetingMessage db 27, '[36m', 13,10,10, 'Welcome To Electronics Store System  ', 27, '[0m$'
    buffer db 100 dup(0)

    ; ASCII Art Electronics with colors
    electronicsArt db 27, '[1;33m',10
               ; Left Side Robot
               db '    |\/\/\/|        /\ /\ /\',10
               db '    |      |       | V  \/  \---.',10
               db '    |      |        \_        /',10
               db '    | (o)(o)         (o)(o)  <__.',10
               db '    C      _)       _C         /',10
               db '     | ,___|       /____,   )  \',10
               db '     |   /          \     /----''',10
               db '    /____\           ooooo',10
               db '   /      \         /     \',10
               db 27, '[36m'
               db '', 27, '[5;31m', '      <<<<  WELCOME  >>>>', 27, '[0;36m',10
               db ' +=============================+',10
               db ' |    ', 27, '[5;32m', 'ELECTRONICS MEGA MART', 27, '[0;36m', '    |',10
               db ' +=============================+',10
               db ' |  ', 27, '[5;35m', 'Tech for Every Lifestyle!', 27, '[0;36m', '  |',10
               db ' +=============================+',10
               db 27, '[0m$'

    mainMenu db 27, '[36m', "+--------------------------------+"
                     db 10, "|    ", 27, '[33m', "Electronics Store System", 27, '[36m', "    |"
                     db 10, "+--------------------------------+"
                     db 10, "| 1. View available stock        |"
                     db 10, "| 2. Add Item                    |"
                     db 10, "| 3. Sell stock                  |"
                     db 10, "| 4. Display Stock               |"
                     db 10, "| 0. Exit                        |"
                     db 10, "+--------------------------------+"
             db 10, 27, '[33m', "Insert Your Choice: ", 27, '[32m$'
    
    invalidInput db 27, '[31m', 10, 10, "+--------------------------------+"
                                 db 10, "|            Error!              |"
                                 db 10, "| Please enter a proper number!  |"
                                 db 10, "+--------------------------------+", 27, '[0m$'

    ; Initial Stock Values
    smartphoneStock dw 25
    laptopStock dw 15
    tabletStock dw 30
    smartwatchStock dw 20
    headphonesStock dw 50
    cameraStock dw 10
    gamingConsoleStock dw 8

    ; Prices (split into high and low parts)
    smartphonePriceLow dw 1F40h    ; 8000 = 1F40h
    smartphonePriceHigh dw 0h
    laptopPriceLow dw 4E20h        ; 20000 = 4E20h
    laptopPriceHigh dw 0h
    tabletPriceLow dw 2EE0h        ; 12000 = 2EE0h
    tabletPriceHigh dw 0h
    smartwatchPriceLow dw 1388h    ; 5000 = 1388h
    smartwatchPriceHigh dw 0h
    headphonesPriceLow dw 0FA0h    ; 4000 = 0FA0h
    headphonesPriceHigh dw 0h
    cameraPriceLow dw 3A98h        ; 15000 = 3A98h
    cameraPriceHigh dw 0h
    gamingConsolePriceLow dw 2AF8h ; 11000 = 2AF8h
    gamingConsolePriceHigh dw 0h

    ; Sales and Cart
    smartphoneSold dw 0
    laptopSold dw 0
    tabletSold dw 0
    smartwatchSold dw 0
    headphonesSold dw 0
    cameraSold dw 0
    gamingConsoleSold dw 0
    totalSales dw 0   ; Total sales

    restockPrompt db 27, '[33m', 10,10, "Enter item ID to restock (1-7): ", 27, '[32m$'
    restockQtyPrompt db 27, '[33m', 10, "Enter quantity to restock (1-9): ", 27, '[32m$'
    restockSuccess db 27, '[32m', 10,10, "Item restocked successfully!", 27, '[0m$'
    
    sellPrompt db 27, '[33m', 10,10, "Enter item ID to sell (1-7): ", 27, '[32m$'
    sellQtyPrompt db 27, '[33m', 10, "Enter quantity to sell (1-9): ", 27, '[32m$'
    sellSuccess db 27, '[32m', 10,10, "Item sold successfully!", 27, '[0m$'
    notEnoughStock db 27, '[31m', 10,10, "Not enough stock!", 27, '[0m$'
    
    totalSalesHeader db 27, '[36m', 10,10,10, "Total Sales: RM", 27, '[32m$'
    
    ; Inventory
    inventoryHeader db 27, '[36m', 10,10,10, "+-----------------------------------+"
                                      db 10, "|   ", 27, '[33m', "Electronics Store System", 27, '[36m', "    |"
                                      db 10, "+-----------------------------------+"
                                      db 10, "| ID | Name              | Quantity |"
                                      db 10, "+-----------------------------------+", 27, '[0m$'
   
      smartphone          db 27, '[37m', 10, "   1 | Smartphone        |", 27, '[0m$'
      laptop              db 27, '[37m', 10, "   2 | Laptop            |", 27, '[0m$'
      tablet              db 27, '[37m', 10, "   3 | Tablet            |", 27, '[0m$'
      smartwatch          db 27, '[37m', 10, "   4 | Smartwatch        |", 27, '[0m$'
      headphones          db 27, '[37m', 10, "   5 | Headphones        |", 27, '[0m$'
      camera              db 27, '[37m', 10, "   6 | Camera            |", 27, '[0m$'
      gamingConsole       db 27, '[37m', 10, "   7 | Gaming Console    |", 27, '[0m$'

    ; Sales Report
    salesOrderHeader  db 27, '[36m', 10,10,10, "+-----------------------------------------------------+"
                                        db 10, "|                     Sales Report                    |"
                                        db 10, "+-----------------------------------------------------+"
                                        db 10, "| ID | Name         | Quantity | Price  | Total Price |"
                                        db 10, "+-----------------------------------------------------+", 27, '[0m$'
                       
    backBttn db 27, '[36m', 10, "| Press B. for Return to Main Menu |"
                         db 10, "+----------------------------------+", 27, '[0m$'
             
    bottomBorder db 27, '[36m', 10, "+----------------------------------+", 27, '[0m$'
    totalSalesFooter db 27, '[36m', 10, "Total Sales: RM ", 27, '[32m$'
    
    endline db 10,'$'
    newline db 10, '$'
    separator  db '    | $'
    separator1 db '   | $'
    separator2 db '  | $'

    lowStock db 27, '[31m', 'LOW STOCK', 27, '[0m$'

    ; Sales Report specific strings
    salesReportBackBttn     db 27, '[36m', 10, "|           Press B. for Return to Main Menu          |"
                                        db 10, "+-----------------------------------------------------+", 27, '[0m$'
    salesReportBottomBorder db 27, '[36m', 10, "+-----------------------------------------------------+", 27, '[0m$'

.CODE

Main PROC
    ; Initialize data segment
    mov ax, @data
    mov ds, ax    

    ; Display login header
    mov ah, 09h
    lea dx, loginHeader
    int 21h

    ; Ask user's username
    mov ah, 09h
    lea dx, askUsername
    int 21h

    ; Read String (Not Character)
    mov buffer[0], 21
    mov ah, 0Ah
    lea dx, buffer
    int 21h

    ; Display greeting
    mov ah, 09h
    lea dx, greetingMessage
    int 21h

    mov bx, 2
    add bl, buffer[1]
    mov buffer[bx], '$'

    mov ah, 09h
    lea dx, buffer
    add dx, 2
    int 21h        

    jmp MainInterface

MainInterface:
    ; Display ASCII Art Electronics
    mov ah, 09h
    lea dx, electronicsArt
    int 21h

    ; Display Main Menu
    mov ah, 09h
    lea dx, mainMenu
    int 21h 

    ; Character Input
    mov ah, 01h
    int 21h
    
    ; Conditions based on input
    cmp al, '1'
    je viewInventory

    cmp al, '2'
    je restockItem

    cmp al, '3'
    je sellItems

    cmp al, '4'
    je salesReport

    cmp al, '0'
    je exit

    jmp error

viewInventory:
    call ShowInventory
    jmp MainInterface

restockItem:
    ; Display inventory
    call ShowInventory

    ; Prompt for item ID to restock
    mov ah, 09h
    lea dx, restockPrompt
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    ; Prompt for quantity to restock
    mov ah, 09h
    lea dx, restockQtyPrompt
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    mov cl, al

    ; Find and restock item
    cmp bl, 1
    je restockSmartphone
    cmp bl, 2
    je restockLaptop
    cmp bl, 3
    je restockTablet
    cmp bl, 4
    je restockSmartwatch
    cmp bl, 5
    je restockHeadphones
    cmp bl, 6
    je restockCamera
    cmp bl, 7
    je restockGamingConsole
    jmp error

restockSmartphone:
    mov ax, smartphoneStock
    add ax, cx
    mov smartphoneStock, ax
    jmp restockSuccessLabel

restockLaptop:
    mov ax, laptopStock
    add ax, cx
    mov laptopStock, ax
    jmp restockSuccessLabel

restockTablet:
    mov ax, tabletStock
    add ax, cx
    mov tabletStock, ax
    jmp restockSuccessLabel

restockSmartwatch:
    mov ax, smartwatchStock
    add ax, cx
    mov smartwatchStock, ax
    jmp restockSuccessLabel

restockHeadphones:
    mov ax, headphonesStock
    add ax, cx
    mov headphonesStock, ax
    jmp restockSuccessLabel

restockCamera:
    mov ax, cameraStock
    add ax, cx
    mov cameraStock, ax
    jmp restockSuccessLabel

restockGamingConsole:
    mov ax, gamingConsoleStock
    add ax, cx
    mov gamingConsoleStock, ax
    jmp restockSuccessLabel

restockSuccessLabel:
    mov ah, 09h
    lea dx, restockSuccess
    int 21h
    mov ah, 01h
    int 21h
    jmp MainInterface

sellItems:
    ; Display inventory
    call ShowInventory
       
    ; Prompt for item ID to sell
    mov ah, 09h
    lea dx, sellPrompt
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    ; Prompt for quantity to sell
    mov ah, 09h
    lea dx, sellQtyPrompt
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    mov cl, al

    ; Find and sell item
    cmp bl, 1
    je sellSmartphone
    cmp bl, 2
    je sellLaptop
    cmp bl, 3
    je sellTablet
    cmp bl, 4
    je sellSmartwatch
    cmp bl, 5
    je sellHeadphones
    cmp bl, 6
    je sellCamera
    cmp bl, 7
    je sellGamingConsole
    jmp error

sellSmartphone:
    mov ax, smartphoneStock
    cmp ax, cx
    jb notEnoughStockLabel
    sub ax, cx
    mov smartphoneStock, ax
    mov ax, cx
    mov bx, smartphonePriceLow
    imul bx
    add totalSales, ax
    add smartphoneSold, cx
    jmp sellSuccessLabel

sellLaptop:
    mov ax, laptopStock
    cmp ax, cx
    jb notEnoughStockLabel
    sub ax, cx
    mov laptopStock, ax
    mov ax, cx
    mov bx, laptopPriceLow
    imul bx
    add totalSales, ax
    add laptopSold, cx
    jmp sellSuccessLabel

sellTablet:
    mov ax, tabletStock
    cmp ax, cx
    jb notEnoughStockLabel
    sub ax, cx
    mov tabletStock, ax
    mov ax, cx
    mov bx, tabletPriceLow
    imul bx
    add totalSales, ax
    add tabletSold, cx
    jmp sellSuccessLabel

sellSmartwatch:
    mov ax, smartwatchStock
    cmp ax, cx
    jb notEnoughStockLabel
    sub ax, cx
    mov smartwatchStock, ax
    mov ax, cx
    mov bx, smartwatchPriceLow
    imul bx
    add totalSales, ax
    add smartwatchSold, cx
    jmp sellSuccessLabel

sellHeadphones:
    mov ax, headphonesStock
    cmp ax, cx
    jb notEnoughStockLabel
    sub ax, cx
    mov headphonesStock, ax
    mov ax, cx
    mov bx, headphonesPriceLow
    imul bx
    add totalSales, ax
    add headphonesSold, cx
    jmp sellSuccessLabel

sellCamera:
    mov ax, cameraStock
    cmp ax, cx
    jb notEnoughStockLabel
    sub ax, cx
    mov cameraStock, ax
    mov ax, cx
    mov bx, cameraPriceLow
    imul bx
    add totalSales, ax
    add cameraSold, cx
    jmp sellSuccessLabel

sellGamingConsole:
    mov ax, gamingConsoleStock
    cmp ax, cx
    jb notEnoughStockLabel
    sub ax, cx
    mov gamingConsoleStock, ax
    mov ax, cx
    mov bx, gamingConsolePriceLow
    imul bx
    add totalSales, ax
    add gamingConsoleSold, cx
    jmp sellSuccessLabel

sellSuccessLabel:
    mov ah, 09h
    lea dx, sellSuccess
    int 21h
    mov ah, 01h
    int 21h
    jmp MainInterface

notEnoughStockLabel:
    mov ah, 09h
    lea dx, notEnoughStock
    int 21h
    jmp MainInterface

salesReport:
    call ShowSalesReport
    jmp MainInterface

error:
    ; Display error message
    mov ah, 09h
    lea dx, invalidInput
    int 21h

    jmp MainInterface 

exit:
    ; Terminate Program
    mov ah, 4ch
    int 21h

Main ENDP

ShowInventory PROC
    ; Display inventory
    mov ah, 09h
    lea dx, inventoryHeader
    int 21h

    ; Display smartphone stock
    mov ah, 09h
    lea dx, smartphone
    int 21h
    mov ax, smartphoneStock
    call DisplayIntegerHighlight
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Display laptop stock
    mov ah, 09h
    lea dx, laptop
    int 21h
    mov ax, laptopStock
    call DisplayIntegerHighlight
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Display tablet stock
    mov ah, 09h
    lea dx, tablet
    int 21h
    mov ax, tabletStock
    call DisplayIntegerHighlight
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Display smartwatch stock
    mov ah, 09h
    lea dx, smartwatch
    int 21h
    mov ax, smartwatchStock
    call DisplayIntegerHighlight
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Display headphones stock
    mov ah, 09h
    lea dx, headphones
    int 21h
    mov ax, headphonesStock
    call DisplayIntegerHighlight
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Display camera stock
    mov ah, 09h
    lea dx, camera
    int 21h
    mov ax, cameraStock
    call DisplayIntegerHighlight
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Display gaming console stock
    mov ah, 09h
    lea dx, gamingConsole
    int 21h
    mov ax, gamingConsoleStock
    call DisplayIntegerHighlight
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Display bottom border
    mov ah, 09h
    lea dx, bottomBorder
    int 21h
    
    ; Display return to main menu option
    mov ah, 09h
    lea dx, backBttn
    int 21h

    ; Wait for user input
    mov ah, 01h
    int 21h
    cmp al, 'B'
    je MainInterface
    cmp al, 'b'
    je MainInterface

    ret
ShowInventory ENDP

DisplayIntegerHighlight PROC
    push ax
    push bx
    push cx
    push dx

    ; Save the original quantity value
    mov bx, ax

    ; Check if original quantity is less than or equal to 3
    cmp bx, 3
    jle highlight_loop

    ; Convert integer to string for normal display
    mov ax, bx
    mov cx, 0
    mov dx, 0
    mov bx, 10

convert_loop_normal:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz convert_loop_normal

NormalDisplay:
    ; Print the number normally
    print_loop_normal:
        pop dx
        mov ah, 02h
        int 21h
        loop print_loop_normal

    jmp ContinueExecution

highlight_loop:
    ; Start red blinking text
    mov ah, 09h
    lea dx, redBlinkStart
    int 21h

    ; Convert integer to string for highlight display
    mov ax, bx
    mov cx, 0
    mov dx, 0
    mov bx, 10

convert_loop_highlight:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz convert_loop_highlight

    ; Print the digits with highlight
    highlight:
        pop dx        
        mov ah, 02h  
        int 21h     
        loop highlight

    ; End red blinking text
    mov ah, 09h
    lea dx, redBlinkEnd
    int 21h

    jmp ContinueExecution

ContinueExecution:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
DisplayIntegerHighlight ENDP

DisplayInteger PROC
    ; Convert integer to string and display
    mov cx, 0         
    mov bx, 10       

convertToString:
    mov dx, 0    
    div bx       
    push ax      
    add dl, '0'  
    pop ax       
    push dx      
    inc cx       
    cmp ax, 0    
    jnz convertToString 

    mov ah, 02h

displayString:
    pop dx    
    int 21h   
    dec cx    
    jnz displayString 

    ret
DisplayInteger ENDP

ShowSalesReport PROC
    ; Display sales report header
    mov ah, 09h
    lea dx, salesOrderHeader
    int 21h

    ; Display smartphone sales
    mov ah, 09h
    lea dx, smartphone
    int 21h
    mov ax, smartphoneSold
    call DisplayInteger
    mov ah, 09h
    lea dx, separator
    int 21h
    mov ax, smartphonePriceLow
    call DisplayInteger
    mov ah, 09h
    lea dx, separator1
    int 21h
    mov ax, smartphoneSold
    mov bx, smartphonePriceLow
    imul bx
    call DisplayInteger
    mov ah, 09h
    lea dx, endline
    int 21h

    ; Display laptop sales
    call DisplaySalesItem
    mov ah, 09h
    lea dx, laptop
    int 21h
    mov ax, laptopSold
    call DisplayInteger
    mov ah, 09h
    lea dx, separator
    int 21h
    mov ax, laptopPriceLow
    call DisplayInteger
    mov ah, 09h
    lea dx, separator2
    int 21h
    mov ax, laptopSold
    mov bx, laptopPriceLow
    imul bx
    call DisplayInteger
    mov ah, 09h
    lea dx, endline
    int 21h

    ; Display tablet sales
    call DisplaySalesItem
    mov ah, 09h
    lea dx, tablet
    int 21h
    mov ax, tabletSold
    call DisplayInteger
    mov ah, 09h
    lea dx, separator
    int 21h
    mov ax, tabletPriceLow
    call DisplayInteger
    mov ah, 09h
    lea dx, separator2
    int 21h
    mov ax, tabletSold
    mov bx, tabletPriceLow
    imul bx
    call DisplayInteger
    mov ah, 09h
    lea dx, endline
    int 21h

    ; Display smartwatch sales
    call DisplaySalesItem
    mov ah, 09h
    lea dx, smartwatch
    int 21h
    mov ax, smartwatchSold
    call DisplayInteger
    mov ah, 09h
    lea dx, separator
    int 21h
    mov ax, smartwatchPriceLow
    call DisplayInteger
    mov ah, 09h
    lea dx, separator1
    int 21h
    mov ax, smartwatchSold
    mov bx, smartwatchPriceLow
    imul bx
    call DisplayInteger
    mov ah, 09h
    lea dx, endline
    int 21h

    ; Display headphones sales
    call DisplaySalesItem
    mov ah, 09h
    lea dx, headphones
    int 21h
    mov ax, headphonesSold
    call DisplayInteger
    mov ah, 09h
    lea dx, separator
    int 21h
    mov ax, headphonesPriceLow
    call DisplayInteger
    mov ah, 09h
    lea dx, separator1
    int 21h
    mov ax, headphonesSold
    mov bx, headphonesPriceLow
    imul bx
    call DisplayInteger
    mov ah, 09h
    lea dx, endline
    int 21h

    ; Display camera sales
    call DisplaySalesItem
    mov ah, 09h
    lea dx, camera
    int 21h
    mov ax, cameraSold
    call DisplayInteger
    mov ah, 09h
    lea dx, separator
    int 21h
    mov ax, cameraPriceLow
    call DisplayInteger
    mov ah, 09h
    lea dx, separator2
    int 21h
    mov ax, cameraSold
    mov bx, cameraPriceLow
    imul bx
    call DisplayInteger
    mov ah, 09h
    lea dx, endline
    int 21h

    ; Display gaming console sales
    call DisplaySalesItem
    mov ah, 09h
    lea dx, gamingConsole
    int 21h
    mov ax, gamingConsoleSold
    call DisplayInteger
    mov ah, 09h
    lea dx, separator
    int 21h
    mov ax, gamingConsolePriceLow
    call DisplayInteger
    mov ah, 09h
    lea dx, separator2
    int 21h
    mov ax, gamingConsoleSold
    mov bx, gamingConsolePriceLow
    imul bx
    call DisplayInteger
    mov ah, 09h
    int 21h
    
    ; Display return to main menu button
    mov ah, 09h
    lea dx, salesReportBottomBorder
    int 21h
    mov ah, 09h
    lea dx, salesReportBackBttn
    int 21h

    ; Display total sales
    mov ah, 09h
    lea dx, totalSalesFooter
    int 21h
    mov ax, totalSales
    call DisplayInteger
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Wait for user input
    mov ah, 01h
    int 21h
    cmp al, 'B'
    je MainInterface
    cmp al, 'b'
    je MainInterface

    ret
ShowSalesReport ENDP

DisplaySalesItem PROC
    ret
DisplaySalesItem ENDP

END Main