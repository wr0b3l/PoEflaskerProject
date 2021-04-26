#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Thread, interrupt, 0 ; natychmiastowe przerwania

#SingleInstance force
#Persistent
#Include C:\Users\Wr0b3l\Desktop\autopot net\autopot mem\classMemory.ahk

if (_ClassMemory.__Class != "_ClassMemory")
    msgbox class memory not correctly installed. Or the (global class) variable "_ClassMemory" has been overwritten

Process, Exist, PathOfExile_x64.exe
pid := ErrorLevel
if !pid 
{
    msgbox pid not found 
    ExitApp
}

mem := new _ClassMemory("ahk_pid " pid, "", hProcessCopy) 

; Check if the above method was successful.
if !isObject(mem) 
{
    msgbox failed to open a handle
    if (hProcessCopy = 0)
        msgbox The program isn't running (not found) or you passed an incorrect program identifier parameter. 
    else if (hProcessCopy = "")
        msgbox OpenProcess failed. If the target process has admin rights, then the script also needs to be ran as admin. Consult A_LastError for more information.
    ExitApp
}

global Nazwa := 0
GuiOn = 0
GuiTrans = 0
jumpout = 0
Podglad = 0
TSPodglad = 0
MaskaPodglad := 0
tog = 0     
basePointer := 0x02506988 ;0251D978 ;0251E8F8 ;0251E8E8 ;0251C9E8 ;021FDBF8 ;0222FF48 ;02517088 ;0251F1C8 ;033F8E78 ;033F6DB8 ;033F3DB8 ;033F3DB8 ;033DEDB8 ;033DAD88 ;033D8D88 ;033CDD78 ;033CBD78 ;03377CD8 ;03378CD8 ;03376CD8 ;03372CD8 ;0336BCB8 ;0336DCB8 ;032BBCD8 ;032B9CB8 ;01FBD828 ;01FB7808 ;01FAC828 ;01FA6828 ;01FA5828 ;01FB1A98 ;01FB0BA8 ;01FB1BA8 ;01F700A0 ;01F6F080 ;01F68030 ;01F66FE0 ;01F64EA8 ;01F64EB8 ;01F07F78 ;01F08040 ;01FC2468 ;01FC2448 ;01FCF6A8 ;01FCC6A8 ;01FC8658 ;01FC8668 ;01FC93B8 ;01FC4378 ;01FC4368 ;01E3ACF8 ;01DDFC18 ;01DE8CA8 ;01DE6CB8 ;01DE2C18 ;01DE0C48 ;01DDAB28 ;01DDBA18 ;01DCDAF8 ;01C98578 ;01C985D8 ;01C8A2C8 ;01C50318 ;01C502C8 ;01C502B8 ;01C50158 ;01C34A68 ;019D63C8 ;019D23B8 ;01BF7D08 ;018D99C8 ;018D79C8 ;018CF9C8 ;01AF0178 ;01AE8648 ;018C19E8  ;018B39D8 ;01 7B F7 68 ;01 7C 07 78 ;017 40 788 ;017 3A 788 ;017 3C 788 ;0x01796300 ;017952E0
bp1=0x1C4
bp11=0x25C
bp2=0x1B8
bp3=0x258
bp4=0x90
bp5=0x418

global aX := A_ScreenWidth
global aY := A_ScreenHeight
global Xc := A_ScreenWidth/2
global Yc := A_ScreenHeight/2
Global MonsterType
SetTimer, Refresh, 10
HPmax :=  mem.read(basePointer + mem.BaseAddress, "UInt", bp5,bp4,bp3,bp2, bp11)
MPmax :=  mem.read(basePointer + mem.BaseAddress, "UInt", bp5,bp4,bp3,bp2, bp1) 

Gui, +AlwaysOnTop
Gui, 1:Submit, NoHide

Gui, 1:Add, GroupBox, xm ym+10 Section w250 h90, Status
gui, 1: add, Edit, xs ys+15 ReadOnly vIsOn w100 h20
gui, 1: add, Text, xs ys+45,HP:
gui, 1: add, Edit, xs+20 ys+42 ReadOnly vP1_GUI w80 h20
gui, 1: add, Text, xs ys+70,MP:
gui, 1: add, Edit, xs+20 ys+67 ReadOnly vMP_GUI w80 h20
gui, 1: add, Checkbox, xs+105 ys+70 h13 w13 vMPPot
gui, 1: add, Edit, xs+123 ys+67 ReadOnly vMPtrigg w20 h20
;gui, 1: add, Button, xs+155 ys+45 h20 w90 gTriggster, Trigster
gui, 1: add, Button, xs+155 ys+65 h20 w90 gLoad, Wczytaj
;gui, 1: add, Button, xs+155 ys+45 h20 w90 gchangeMAP, ZmienMape
gui, 1: add, Checkbox, xs+135 ys+25 h13 w13 vTRAP


gui, 1: add, GroupBox, xm ym+100 Section w140 h100, Slot 1
gui, 1: add, Text, xs+30 ys+15,Aktywna:
gui, 1: add, Checkbox, xs+90 ys+15 vPotOn1
gui, 1: add, Text, xs+30 ys+35,Poziom:
gui, 1: add, Edit, xs+80 ys+31 ReadOnly vfinal_result1 w30 h20
gui, 1: add, Slider, xs+5 ys+60 vSlider1 range0-100 tickinterval1-100 AltSubmit , 75


gui, 1: add, GroupBox, xm ym+200 Section w140 h100, Slot 2
gui, 1: add, Text, xs+30 ys+15,Aktywna:
gui, 1: add, Checkbox, xs+90 ys+15 vPotOn2
gui, 1: add, Text, xs+30 ys+35,Poziom:
gui, 1: add, Edit, xs+80 ys+31 ReadOnly vfinal_result2 w30 h20
gui, 1: add, Slider, xs+5 ys+60 vSlider2 range0-100 tickinterval1-100 AltSubmit , 25

gui, 1: add, GroupBox, xm+150 ym+100 Section w100 h100, Slot 3 4 5
gui, 1: add, Text, xs+10 ys+15,P3 Link:
gui, 1: add, Checkbox, xs+70 ys+15 vPot3,
gui, 1: add, Text, xs+10 ys+35,P4 Link:
gui, 1: add, Checkbox, xs+70 ys+35 vPot4,
gui, 1: add, Text, xs+10 ys+55,P5 Link:
gui, 1: add, Checkbox, xs+70 ys+55 vPot5,
gui, 1: add, Text, xs+10 ys+75,Link:
gui, 1: add, Edit, xs+40 ys+71 ReadOnly vPotAct w50 h20

gui, 1: add, GroupBox, xm+150 ym+200 Section w100 h100, Opcje
;gui, 1: add, Button, xs+5 ys+15 h15 w90 gSwaper, Swaper
gui, 1: add, Button, xs+5 ys+35 h15 w90 gZapisz, Zapisz
;gui, 1: add, Button, xs+5 ys+55 h15 w90 gZmienne, Podglad
gui, 1: add, Button, xs+5 ys+75 h20 w90 gWyjdz, Wyjdz

Gui, 1:Show, x700 y100, PathOfEz 
Gui, 1:Hide

Gui, 2:-SysMenu +ToolWindow -Caption +Border +AlwaysOnTop 
Gui, 2:Color, EEAA99                                 
Gui, 2: +LastFound                                     
WinSet, TransColor, EEAA99 
Gui, 2: Font, s12  
Gui, 2: Add, Text , w200 vINFO,
Gui, 2: Font, s12  cFFFFFF
Gui, 2: Add, Text , w200 vXY, x:    y:    
Gui, 2: Font, s10  cFFFFFF
Gui, 2: Add, Text , w200 vRr, Rm:    Rc:  
Gui, 2: Font, s10  cFFFFFF
Gui, 2: Add, Text , w200 vMT, I:    MT:  
                 
Gui, 2:show, w200 x1450 y10 , Indyk
WinSetTitle,Indyk,,%a_space%
Gui, 2:Hide

return

F3::
GuiOn:=!GuiOn
if GuiOn 
{
	Gui,1: Show, , PathOfEz
	Gui,3: Show, , Podglad zmiennych
	PodgladSwaper := 0
	TSPodglad := 0
}
Else
{
	Gui,1: Hide
	Gui,3: Hide
}
Return

F4::
GuiOn2:=!GuiOn2
if GuiOn2 
	Gui,2: Show, , Indyk
Else
	Gui,2: Hide
Return

^Y::
GuiTrans:=!GuiTrans
	WinGet, active_id, ID, PathOfEz
  	;WinSet, AlwaysOnTop, On, ahk_id %active_id%
if GuiTrans 
{

  	WinSet, Transparent, 127, ahk_id %active_id% 
  	WinSet, ExStyle, +0x80020,ahk_id %active_id%
  	
}
Else
{
	WinSet, Transparent, 255, ahk_id %active_id% 
	WinSet, ExStyle, -0x20, ahk_id %active_id%
}

Return


F1::
StartTimeMP := A_TickCount
StartTime1 := A_TickCount ; zacznij mierzyc ms
StartTime2 := A_TickCount ; zacznij mierzyc ms
StartTime3 := A_TickCount
StartTime4 := A_TickCount
StartTimeTrigster := A_TickCount
if(jumpout = 0)
{
   jumpout = 1
   SetTimer, colorCh, 1
   P1 := HPmax
   MainAct := "Aktywny"
   ; GuiControl,1:, IsOn, MainAct
}
else
{
   jumpout = 0
   MainAct := "Nie aktywny"
   ;  GuiControl,1:, IsOn, "Niekatywny"
   SetTimer, colorCh, off
   ; SetTimer, Refresh, off
}

Return

colorCh:
Gui, Submit, NoHide
HPcurr :=  mem.read(basePointer + mem.BaseAddress, "UInt", bp5,bp4,bp3,bp2, bp11)
MPcurr :=  mem.read(basePointer + mem.BaseAddress, "UInt", bp5,bp4,bp3,bp2, bp1)
HH1 := floor(HPmax * (slider1/100))
HH2 := floor(HPmax * (slider2/100))
MPtrigg := floor(MPmax/3 )

;if (c75 != 0x211C8B) && (pot1e == 0x3653D0) ; ponizej 75% i p1 2/3 niepusta
IfWinActive, Path of Exile
{
if(PotOn1 = 1)
{

	if((HPcurr <= HH1) && (HPcurr > 1))
	{
		if( (A_TickCount - StartTime1) > 3000)
		{
			Send 1
			StartTime1 := A_TickCount ; zacznij mierzyc ms
		}
	}
}

if(PotOn2 = 1)
{
	
	if((HPcurr <= HH2) && (HPcurr > 1))
	{
		if( (A_TickCount - StartTime2) > 2000)
		{
			Send 2
			StartTime2 := A_TickCount ; zacznij mierzyc ms
		}
	}
}

if(MPPot = 1)
{
	
	if((MPcurr <= MPtrigg) && (MPcurr >= 0))
	{
		if( (A_TickCount - StartTimeMP) > 3000)
		{
			if(PotOn2 = 1)
				Send 3
			Else
				Send 2
				
			StartTimeMP := A_TickCount ; zacznij mierzyc ms
		}
	}

}

if (Pot3 = 1)
{ 
	if ((Pot4 = 1) && (Pot5 = 0))
	{
			TKk := 0
			P_0 := 4
			P_1 := 5
	}
	if ((Pot4 = 0) && (Pot5 = 1))
	{

			TKk := 0
			P_0 := 5
			P_1 := 5
	}
	if ((Pot4 = 1) && (Pot5 = 1))
	{
			TKk := 1
			P_0 := 4
			P_1 := 5
	}
	if( GetKeyState("3", "P") || global Rush )
	{
		if( (A_TickCount - StartTime3) > 5000)
		{
				PT := UseFlask(3,TKk,P_0,P_1) 
				StartTime3 := A_TickCount
				global Rush := 0
		}
	}
} 
else if (Pot3 = 0) 
{
	if ((Pot4 = 1) && (Pot5 = 1))
	{
		TKk := 0
		P_0 := 5
		P_1 := 5
	}
	if( GetKeyState("4", "P") || global Rush)
	{
		if( (A_TickCount - StartTime4) > 5000)
		{
			PT := UseFlask(4,TKk,P_0,P_1) 
			StartTime4 := A_TickCount
			global Rush := 0
		}
	}
}


}
Return

Refresh:
GuiControl,1:, IsOn, %MainAct%
GuiControl,1:, PotAct, %PT%
GuiControl,1:, P1_GUI, %HPcurr%
GuiControl,1:, MP_GUI, %MPcurr%
if MPPot
	GuiControl,1:, MPtrigg, %MPtrigg%
GuiControl,1:, END_GUI, %Endurance%
GuiControl,1:, TKk, %TKk%
GuiControl,1:, P_0, %P_0%
GuiControl,1:, P_1, %P_1%
GuiControl,1:, Trigg, %Trigg%
GuiControl,1:, final_result1, %HH1%
GuiControl,1:, final_result2, %HH2% 

GuiControl, 2:, XY, x:%Xcurr% y:%Ycurr%

GuiControl,3:, P1_GUI, %HPcurr% 
GuiControl,3:, SwapAct, Unact
GuiControl,3:, IsOn, %MainAct%
GuiControl,3:, PotOn1, %PotOn1%
GuiControl,3:, PotOn2, %PotOn2%
GuiControl,3:, Pot3, %Pot3%
GuiControl,3:, Pot4, %Pot4%
GuiControl,3:, Pot5, %Pot5%
Gui, 5: Submit, NoHide 
GuiControl,5:, Sdist, %DistCalc%

return

UseFlask(Trigger,TK, Push_0, Push_1)
{

		send {%Trigger%}
		sleep, 100
		Send {%Push_0%}
		Sleep, 100
		if TK
		{
			Send {%Push_1%}
			sleep, 100
			PT = %Trigger%--%Push_0%--%Push_1%
		}
		Else
			PT = %Trigger%--%Push_0%

	return PT
}
return


F6::
MaskaPodglad := !MaskaPodglad
If MaskaPodglad
{
	gui, 9: Destroy
	Gui, 9: +LastFound -Caption +ToolWindow +AlwaysOnTop -SysMenu

;	powR := ((cX- Xcurr)**2) + ((cY-Ycurr)**2) 

;	cR := Sqrt(powR) ; * stosY
;	cRy := cR * stosY

;	elipA := floor(cR *2)  
;	elipB := floor(cRy *2)
    Sd := Rmain*2
    MIDX := Xc - Rmain
    MIDY := Yc - Rmain 
;	MIDX := ((cX)-cR)
;	MIDY := ((cY)-cRy)
	Gui, 9:Show, w%aX% h%aY%, Range Viever

	WinGet, active_id, ID, Range Viever
	WinSet, Region, %MIDX%-%MIDY% W%Sd% H%Sd% E, ahk_id %active_id%   
	WinSet, Transparent, 40, ahk_id %active_id% 
	WinSet, ExStyle, +0x80020,ahk_id %active_id%	
}
Else
{
 	Gui,9:Destroy
}
	
return

Zmienne:
Podglad := !Podglad
If Podglad
{
	Gui, 3: Submit, NoHide 
	gui, 3: add, GroupBox, xm ym Section w185 h300, Zmienne
	gui, 3: add, Button, xs+85 ys+275 h20 w95 gWyjdzZM, Wyjdz
	Gui, 3: show, w200 h315 x600 y348 , Podglad

	gui, 3: add, Text, xs+10 ys+20,Life:
	gui, 3: add, Edit, xs+45 ys+20 h15 w50 ReadOnly Center vP1_GUI
	gui, 3: add, Text, xs+10 ys+40,Swap:
	gui, 3: add, Edit, xs+45 ys+40 h15 w70 ReadOnly Center vSwapAct
	gui, 3: add, Text, xs+10 ys+60,HOT:
	gui, 3: add, Edit, xs+45 ys+60 h15 w70 ReadOnly Center vIsOn
	gui, 3: add, Text, xs+10 ys+80,Slot1:
	gui, 3: add, Edit, xs+45 ys+80 h15 w15 ReadOnly Center vPotOn1
	gui, 3: add, Text, xs+10 ys+100,Slot2:
	gui, 3: add, Edit, xs+45 ys+100 h15 w15 ReadOnly Center vPotOn2
	gui, 3: add, Text, xs+10 ys+120,Slot3:
	gui, 3: add, Edit, xs+45 ys+120 h15 w15 ReadOnly Center vPot3
	gui, 3: add, Text, xs+10 ys+140,Slot4:
	gui, 3: add, Edit, xs+45 ys+140 h15 w15 ReadOnly Center vPot4
	gui, 3: add, Text, xs+10 ys+160,Slot5:
	gui, 3: add, Edit, xs+45 ys+160 h15 w15 ReadOnly Center vPot5
}
Else
{
 	gui 3:Destroy
}

Return

Wyjdz:
	jumpout = 0
    MainAct := "Niekatywny"
    SetTimer, colorCh, off
    SetTimer, Refresh, off
	ExitApp,
Return

WyjdzZM:
	gui 3:Destroy
Return

Zapisz:
	IniWrite, %PotOn1%, Potter.ini, Potki, Pot1
	IniWrite, %PotOn2%, Potter.ini, Potki, Pot2
	IniWrite, %Pot3%, Potter.ini, Potki, Pot3
	IniWrite, %Pot4%, Potter.ini, Potki, Pot4
	IniWrite, %Pot5%, Potter.ini, Potki, Pot5
	IniWrite, %KeyChoice%, Potter.ini, Trigster, KeyChoice
	IniWrite, %DistCalc%, Potter.ini, Trigster, DistCalc
return

Load:
	SetTimer, Refresh, off 
	
	IniRead, PotOn1, Potter.ini, Potki, Pot1
	IniRead, PotOn2, Potter.ini, Potki, Pot2
	IniRead, Pot3, Potter.ini, Potki, Pot3
	IniRead, Pot4, Potter.ini, Potki, Pot4
	IniRead, Pot5, Potter.ini, Potki, Pot5
	IniRead, KeyChoice, Potter.ini, Trigster, KeyChoice
	IniRead, DistCalc, Potter.ini, Trigster, DistCalc

	GuiControl,1:, PotOn1, %PotOn1%
	GuiControl,1:, PotOn2, %PotOn2%
	GuiControl,1:, Pot3, %Pot3%
	GuiControl,1:, Pot4, %Pot4%
	GuiControl,1:, Pot5, %Pot5%
	GuiControl,5:ChooseString, KeyChoice, %KeyChoice% 

	GuiControl,5:, DistCalc, %DistCalc% 
	
	SetTimer, Refresh, on 
	HPmax :=  mem.read(basePointer+ mem.BaseAddress, "UInt", bp5,bp4,bp3,bp2, bp11)
	MPmax :=  mem.read(basePointer + mem.BaseAddress, "UInt", bp5,bp4,bp3,bp2, bp1) 
return

f9::
ExitApp, 
return

F5::
	Reload
Return


Shaper(RC)
{
	Gui, 9: +LastFound -Caption +ToolWindow +AlwaysOnTop -SysMenu
	gui, 9: Destroy

;	powR := ((cX- Xcurr)**2) + ((cY-Ycurr)**2) 

;	cR := Sqrt(powR) ; * stosY
;	cRy := cR * stosY

;	elipA := floor(cR *2)  
;	elipB := floor(cRy *2)
    S := RC*2
    MIDX := Xc - RC
    MIDY := Yc - RC 
;	MIDX := ((cX)-cR)
;	MIDY := ((cY)-cRy)
	Gui, 9:Show, w%aX% h%aY%, Range Viever

	WinGet, active_id, ID, Range Viever
	WinSet, Region, %MIDX%-%MIDY% W%S% H%S% E, ahk_id %active_id%   
	WinSet, Transparent, 40, ahk_id %active_id% 
	WinSet, ExStyle, +0x80020,ahk_id %active_id%
}