#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#InstallMouseHook
SetBatchLines -1
ListLines Off
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetWinDelay, -1

windowtitle:="Hold"
pokerstarsWH:=(491/366)
pokerstarsHW:=(366/491)
minamaxWH:=(548/469)
minamaxHW:=(469/548)

marginx:= 30
maxx:=0
maxy:=0
maxwidth:=0
maxheight:=0

moved:=0

x1:=0
x2:=0
x3:=0

y1:=0
y2:=0

widthsix:=0
height:=0
oldActiveWindows:=0
activeWindows:=0

getQuadrant(ByRef order, ByRef i)
{
    global maxheight
    global maxwidth
    global maxx
    global maxy
    global x1
    global x2
    global x3
    global y1
    global y2

    test:=order%A_Index%
    if(test)
    {
        WinGetPos, x, y, mw, mh, ahk_id %test%
        x+=(mw/2)
        y+=(mh/2)
        ;1
        qx1:=Abs(x-x1)
        qy1:=Abs(y-y1)
        q1:=(qx1*qx1)+(qy1*qy1)
        ;2
        qx2:=Abs(x-x2)
        qy2:=Abs(y-y1)
        q2:=(qx2*qx2)+(qy2*qy2)
        ;3
        qx3:=Abs(x-x3)
        qy3:=Abs(y-y1)
        q3:=(qx3*qx3)+(qy3*qy3)
        ;4
        qx4:=Abs(x-x1)
        qy4:=Abs(y-y2)
        q4:=(qx4*qx4)+(qy4*qy4)
        ;5
        qx5:=Abs(x-x2)
        qy5:=Abs(y-y2)
        q5:=(qx5*qx5)+(qy5*qy5)
        ;6
        qx6:=Abs(x-x3)
        qy6:=Abs(y-y2)
        q6:=(qx6*qx6)+(qy6*qy6)

        prox:=Min(q1,q2,q3,q4,q5,q6)

        if(q1 = prox)
        {
            return 5
        }
        else if (q2 = prox)
        {
            return 1
        }
        else if (q3 = prox)
        {
            return 3
        }
        else if (q4 = prox)
        {
            return 6
        }
        else if (q5 = prox)
        {
            return 2
        }
        else if (q6 = prox)
        {
            return 4
        }
        return 0
    }
}


Move(ByRef order, ByRef i)
{
    global height
    global pokerstarsWH
    global pokerstarsHW
    global minamaxWH
    global minamaxHW
    global widthsix
    global marginx
    global maxwidth
    global maxheight
    global maxx
    global maxy


    ;;MsgBox "old " . %oldActiveWindows%
    ;;MsgBox "active" . %activeWindows%

    ; if ((activeWindows > 4) and (oldActiveWindows < 5))
    ; {
    ;     oldActiveWindows:=activeWindows
    ;     Loop 6
    ;     {
    ;         ;;MsgBox "Altered"
    ;         Move(order,A_Index)
    ;     }
    ;     return
    ; }
    ; if (activeWindows < 5 and oldActiveWindows > 4)
    ; {
    ;     oldActiveWindows:=activeWindows
    ;     Loop 6
    ;     {
    ;         Move(order,A_Index)
    ;     }
    ;     return
    ; }
    test:=order%i%
    WinGet, process, ProcessName, ahk_id %test%
    if(process = "Winamax Poker.exe")
    {
        HW:= minamaxHW
        WH:= minamaxWH
    }
    else
    {
        HW:= pokerstarsHW
        WH:= pokerstarsWH
    }

    sizeheight:=height
    sizewidth:=height*WH
    ; if (activeWindows > 4)
    ; {
        if (sizewidth > (widthsix - marginx))
        {
            sizewidth:=(widthsix - marginx)
            sizeheight:=(sizewidth*HW)
        }
    ; }
    ; else
    ; {
    ;     if (sizewidth > width)
    ;     {
    ;         sizewidth:=width
    ;     }
    ; }
    
    

    move:=order%i%
    movex:=(maxwidth - sizewidth + maxx)
    ;MsgBox %height%
    ;MsgBox %sizeheight%
    moveyup:=((height/2) - (sizeheight/2) + maxy)
    moveydown:=(maxy + height + (height/2) - (sizeheight/2))
    movexmiddle:=(maxx + maxwidth -widthsix -widthsix + marginx)

    WinActivate, ahk_id %move%
    if (i = 5)
    {
        WinMove, ahk_id %move%,,%marginx%,%moveyup%,%sizewidth%,%sizeheight%
        ; 1
    }
    else if (i = 3)
    {
        WinMove, ahk_id %move%,,%movex%,%moveyup%,%sizewidth%,%sizeheight%
        ; 3
    }
    else if (i = 6)
    {
        WinMove, ahk_id %move%,,%marginx%,%moveydown%,%sizewidth%,%sizeheight%
        ; 4
    }
    else if (i = 4)
    {
        WinMove, ahk_id %move%,,%movex%,%moveydown%,%sizewidth%,%sizeheight%
        ; 6
    }
    else if (i = 1)
    {
        WinMove, ahk_id %move%,,%movexmiddle%,%moveyup%,%sizewidth%,%sizeheight%
        ; 2
    }
    else if (i = 2)
    {
        WinMove, ahk_id %move%,,%movexmiddle%,%moveydown%,%sizewidth%,%sizeheight%
        ; 5
    }
    oldActiveWindows:=activeWindows
    return
}

#Persistent
list := []
oldList := []
addList := []
order := []
Loop 6
{
    order++
    order%order%:=0
}
first:=1
second:=1
SetTitleMatchMode, 2
SetTitleMatchMode, Fast
SetTimer, main, 100
HookProcAdr := RegisterCallback("HookProc", "F" )
API_SetWinEventHook(0xA,0xB,0,HookProcAdr,0,0,0)

return

main:
    oldActiveWindows:=activeWindows
    ;get current list
    WinGet, list, List, %windowtitle%
    if(second and list)
    {
        Loop % list
        {
            ; MsgBox "Getting info"
            test:=list%A_Index%
            ; MsgBox % list%A_Index%
            WinActivate, ahk_id %test%
            WinGet, state, MinMax, ahk_id %test%
            if(state != 1)
            {
                WinMaximize, ahk_id %test%
            }
            WinGetPos, maxx, maxy, maxwidth, maxheight, ahk_id %test%
            Sleep, 500
            WinRestore, ahk_id %test%
            ; MsgBox %maxx%
            ; MsgBox %maxy%
            ; MsgBox %maxwidth%
            ; MsgBox %maxheight%
            widthsix:=maxwidth/3
            height:=maxheight/2
            second:=0

            x1:=maxx+(widthsix/2)
            x2:=x1+widthsix
            x3:=x2+widthsix

            y1:=maxy+(maxheight/4)
            y2:=y1+(maxheight/2)

            break
        }
    }
    i:=0
    check:=1

    ;remove minimized or stoped from order
    activeWindows:=0
    Loop % order
    {
        ;MsgBox % "order " . order%A_Index%
        if (order%A_Index% != 0)
        {
            test:=% order%A_Index%
            WinGet,state,MinMax,ahk_id %test%
            ;MsgBox % "index " . A_Index . " state " . state
            if(state = "" or state = -1)
            {
                ;MsgBox "Removed"
                ;MsgBox % "order " . order%A_Index%
                if (state = -1)
                {
                    queue++
                    queue%queue%:=% order%A_Index%
                }
                order%A_Index% = 0
                ;MsgBox % "order after " . order%A_Index%
            }
            else
            {
                activeWindows++
            }
        }
    }

    ;remove order from list
    i:=0
    Loop % order
    {
        i++
        j:=0
        k:=1
        Loop % list
        {
            k++
            ;MsgBox % "remove order " . list%A_Index%
            if(list%A_Index% = order%i% or j = 1)
            {
                ;MsgBox % "Is going to be removed " . list%A_Index%
                j:=1
                ;MsgBox %A_Index%
                ;MsgBox %k%
                list%A_Index%:=% list%k%
                ;MsgBox % "Local " . list%A_Index%
                ;MsgBox % "Next " . list%k%
            }
        }
        if(j = 1)
        {
            ;MsgBox %list%
            list--
            ;MsgBox %list%
        }
        
    }

    ;MsgBox % "List size : " . list


    ;add queue to order if possible
    check:=activeWindows
    ;MsgBox % "queue size " . queue
    i:=0
    Loop % queue
    {
        i++
        if (activeWindows < 6)
        {
            Loop % order
            {
                ;MsgBox % order%A_Index%
                if(order%A_Index% = 0)
                {
                    order%A_Index% = % queue%i%
                    activeWindows++
                    Move(order,A_Index)
                    break
                }
            }
        }
        ;MsgBox % "queue :" . queue%A_Index%
        j:=0
        k:=1
        ;remove queue from list
        Loop % list
        {
            k++
            if(list%A_Index% = queue%i% or j = 1)
            {
                j:=1
                ;MsgBox % "List now " . list%A_Index%
                ;MsgBox % "List after " . list%next%
                list%A_Index% := % list%k%
                ;MsgBox % "List now after" . list%A_Index%
            }
        }
        if(j = 1)
        {
            ;;MsgBox %list%
            list--
            ;;MsgBox %list%
        }
    }
    removed:=(activeWindows-check)
    queue-=removed

    ;MsgBox % "List size " . list
    ;MsgBox % "Queue size " . queue
    ;MsgBox % "Removed itens queue " . removed

    
    if (removed != 0)
    {
        i:=1
        Loop % queue
        {
            i++
            ;MsgBox % "remove queue " . queue%A_Index%
            queue%A_Index%:=% queue%i%
            ;MsgBox % "next " . queue%A_Index%
        }
    }

    i:=0
    if (activeWindows < 6)
    {
        Loop % list
        {
            i++
            ;MsgBox % "here " . list%A_Index%
            Loop % order
            {
                if(order%A_Index% = 0)
                {
                    ;;MsgBox % "Added to order " . list%i%
                    activeWindows++
                    order%A_Index%:= % list%i%
                    ;MsgBox % order%A_Index%
                    list%i%:= 0
                    Move(order,A_Index)
                    break
                }
            }
        }
    }
    

    Loop % list
    {
        if(list%A_Index% != 0)
        {
            queue++
            queue%queue%:=% list%A_Index%
        }
    }

    if(moved)
    {
        Loop % order {
            a := order%A_Index%
            if (a = moved)
            {
                q := getQuadrant(order,A_Index)
                if(A_Index != q)
                {
                    buf := order%A_Index%
                    order%A_Index% := order%q%
                    order%q% := buf
                    if (order%A_Index% != 0)
                    {
                        Move(order,A_Index)
                    }
                    Move(order,q)
                }
            }

        }
        moved := 0
    }
return


HookProc(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime ){
    global moved
	if event = 11
		moved = %hwnd%
}

API_SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags) {
	DllCall("CoInitialize", "uint", 0)
	return DllCall("SetWinEventHook", "uint", eventMin, "uint", eventMax, "uint", hmodWinEventProc, "uint", lpfnWinEventProc, "uint", idProcess, "uint", idThread, "uint", dwFlags)
}