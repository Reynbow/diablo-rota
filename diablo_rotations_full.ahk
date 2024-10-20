#SingleInstance, Force
SendMode, Input
FileCreateDir, %A_AppDataCommon%\DiabloRotations
IniFile := A_AppDataCommon "\DiabloRotations\GuiPosition.ini"

; Load previous position
If FileExist(IniFile)
{
    IniRead, PosX, %IniFile%, Position, X, Center
    IniRead, PosY, %IniFile%, Position, Y, Center
}
else
{
    PosX := "Center"
    PosY := "Center"
}

Gui, -Border -Caption +AlwaysOnTop +ToolWindow
Gui, Color, 1E1E1E, 1E1E1E
Gui, Font, s14 cFFFFFF, Segoe UI

; Draggable Title Bar
Gui, Add, Text, x10 y10 w190 h32 cFFFFFF Background3A3A3A gDragWindow +Border,
Gui, Add, Text, x18 y14 w200 cFFFFFF, ROTATIONS
Gui, Add, Button, x200 y10 w32 h32 gCloseButton +BackgroundDefault, X

; Input Fields
Gui, Add, Text, x10 y70 w220 cFFFFFF, Enter names below:
Gui, Add, Edit, vInput1 x10 y100 w220 cFFFFFF Background2E2E2E
Gui, Add, Edit, vInput2 x10 y140 w220 cFFFFFF Background2E2E2E
Gui, Add, Edit, vInput3 x10 y180 w220 cFFFFFF Background2E2E2E
Gui, Add, Edit, vInput4 x10 y220 w220 cFFFFFF Background2E2E2E
Gui, Add, Button, gSaveVars x10 y270 w220 h40, Update Names

; Tick Boxes
Gui, Add, Text, x20 y330 w200 Center cFFFFFF, Vendor Frequency
Gui, Add, Radio, vFourRotations x60 y360 w80 cFFFFFF Group, 4x
Gui, Add, Radio, vFiveRotations x140 y360 w80 cFFFFFF, 5x

Gui, Add, Button, gResetVars x10 y410 w220 h40, Reset
Gui, Show, x%PosX% y%PosY% h460 w240, Input Box

Saved := 0
Iteration1 := 1
Iteration2 := 1
VendorFlag := 0
VendorCounter := 0

SaveVars:
    Gui, Submit, NoHide
    Saved := 1
    Iteration1 := 1
    Iteration2 := 1
    VendorFlag := 0
    VendorCounter := 0
    Return

DragWindow:
    PostMessage, 0xA1, 2,,, A
Return

GuiMove:
    Gui, +LastFound
    WinGetPos, PosX, PosY,,, A
    IniWrite, %PosX%, %IniFile%, Position, X
    IniWrite, %PosY%, %IniFile%, Position, Y
Return

F1::
    if (!Saved) {
        MsgBox, Please enter values in all the input boxes and click 'Update Names' before pressing F1.
        Return
    }

    Gui, Submit, NoHide

    if (VendorFlag) {
        Send, {Enter}==== VENDOR ===={Enter}
        VendorFlag := 0
        Return
    }

    varName := "Input" . Iteration2
    varValue := %varName%
    Send, {Enter}==== %Iteration1% - %Iteration2% %varValue% ===={Enter}

    Iteration2++
    VendorCounter++

    if (Iteration2 > 4) {
        Iteration2 := 1
        Iteration1++
    }

    if ((FourRotations && VendorCounter == 4) || (FiveRotations && VendorCounter == 5)) {
        VendorFlag := 1
        VendorCounter := 0
    }
Return

ResetVars:
    Iteration1 := 1
    Iteration2 := 1
    VendorFlag := 0
    VendorCounter := 0
    Return

CloseButton:
GuiClose:
    Gui, +LastFound
    WinGetPos, PosX, PosY,,, A
    IniWrite, %PosX%, %IniFile%, Position, X
    IniWrite, %PosY%, %IniFile%, Position, Y
    ExitApp
