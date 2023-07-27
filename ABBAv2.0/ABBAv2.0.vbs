' Vortex - Taito 1981
' IPD No. 4576 / 1981 / 4 Players
' VPX - version by JPSalas 2019, version 2.0.0

Option Explicit
Randomize
Dim Controller
Dim bMusicOn
On Error Resume Next
ExecuteGlobal GetTextFile("controller.vbs")
If Err Then MsgBox "You need the controller.vbs in order to run this table, available in the vp10 package"
On Error Goto 0

LoadVPM "01550000", "Taito.vbs", 3.26

Dim bsTrough, dtbank1, dtbank2, dtbank3, bsRightSaucer, x

Const cGameName = "Vortex"

Const UseSolenoids = 1
Const UseLamps = 0
Const UseGI = 0
Const UseSync = 0 'set it to 1 if the table runs too fast
Const HandleMech = 0
Const vpmhidden = 1 'hide the vpinmame window

If Table1.ShowDT = true then
    For each x in aReels
        x.Visible = 1
    Next
else
    For each x in aReels
        x.Visible = 0
    Next
end if

' Standard Sounds
Const SSolenoidOn = "fx_Solenoid"
Const SSolenoidOff = ""
Const SongVolume = 0.1 ' 1 is full volume. Value is from 0 to 1
Const SCoin = "fx_Coin"
bMusicOn = True
'************
' Table init.
'************


Sub table1_Init
	'Set Controller = CreateObject("B2S.Server")
	'NVramPatchLoad
    vpmInit me
    With Controller
        .GameName = cGameName
		.Games(cGameName).Settings.Value("sound") = 0 'enable the rom sound
        If Err Then MsgBox "Can't start Game" & cGameName & vbNewLine & Err.Description:Exit Sub
        .SplashInfoLine = "Vortex - Taito 1981" & vbNewLine & "VPX table by JPSalas v.2.0.0"
        .HandleKeyboard = 0
        .ShowTitle = 0
        .ShowDMDOnly = 1
        .ShowFrame = 0
        .HandleMechanics = 0
        .Hidden = vpmhidden
        .Games(cGameName).Settings.Value("rol") = 0 '1= rotated display, 0= normal
        '.SetDisplayPosition 0,0, GetPlayerHWnd 'restore dmd window position
        On Error Resume Next
        Controller.SolMask(0) = 0
        vpmTimer.AddTimer 2000, "Controller.SolMask(0)=&Hffffffff'" 'ignore all solenoids - then add the Timer to renable all the solenoids after 2 seconds
        Controller.Run GetPlayerHWnd
		
		On Error Goto 0
    End With

    ' Nudging
    vpmNudge.TiltSwitch = 30
    vpmNudge.Sensitivity = 3
    vpmNudge.TiltObj = Array(Bumper1, Bumper2, Bumper3, LeftSlingshot, RightSlingshot)

    ' Trough
    Set bsTrough = New cvpmBallStack
    With bsTrough
        .InitSw 0, 1, 0, 0, 0, 0, 0, 0
        .InitKick BallRelease, 90, 4 
        .Balls = 1
        .InitExitSnd SoundFX("fx_ballrel", DOFContactors), SoundFX("fx_Solenoid", DOFContactors) 
    End With

    ' Saucers
    Set bsRightSaucer = New cvpmBallStack
    bsRightSaucer.InitSaucer sw2, 2, 220, 15
    bsRightSaucer.InitExitSnd SoundFX("fx_kicker", DOFContactors), SoundFX("fx_Solenoid", DOFContactors)
    bsRightSaucer.KickForceVar = 6
	 
    ' Drop targets
    set dtbank1 = new cvpmdroptarget
    dtbank1.InitDrop Array(sw35, sw45, sw55, sw65, sw75), Array(35, 45, 55, 65, 75)
    dtbank1.initsnd SoundFX("", DOFDropTargets), SoundFX("fx_resetdrop", DOFContactors)

    set dtbank2 = new cvpmdroptarget
    dtbank2.InitDrop Array(sw41, sw51, sw61), Array(41, 51, 61)
    dtbank2.initsnd SoundFX("MoneyMoneyMoney", DOFDropTargets), SoundFX("fx_resetdrop", DOFContactors)

    set dtbank3 = new cvpmdroptarget
    dtbank3.InitDrop Array(sw11, sw21, sw31), Array(11, 21, 31)
    dtbank3.initsnd SoundFX("MoneyMoneyMoney", DOFDropTargets), SoundFX("fx_resetdrop", DOFContactors)

    ' Main Timer init
    PinMAMETimer.Interval = PinMAMEInterval
    PinMAMETimer.Enabled = 1
	  
' Turn on Gi
    GiOn
End Sub

Sub table1_Paused:Controller.Pause = 1:End Sub
Sub table1_unPaused:Controller.Pause = 0:End Sub
Sub table1_exit
    'NVramPatchExit
    Controller.stop
End Sub

'******************
' Realtime Updates
'******************

Set Motorcallback = GetRef("RealTimeUpdates")

Sub RealTimeUpdates
    GIUpdate
    RollingUpdate
    LeftFlipperTop.RotZ = LeftFlipper.CurrentAngle
    RightFlipperTop.RotZ = RightFlipper.CurrentAngle
End Sub

'**********
' Keys
'**********

Sub table1_KeyDown(ByVal Keycode)
    If keycode = LeftTiltKey Then Nudge 90, 5:PlaySound SoundFX("fx_nudge", 0), 0, 1, -0.1, 0.25
    If keycode = RightTiltKey Then Nudge 270, 5:PlaySound SoundFX("fx_nudge", 0), 0, 1, 0.1, 0.25
    If keycode = CenterTiltKey Then Nudge 0, 6:PlaySound SoundFX("fx_nudge", 0), 0, 1, 0, 0.25
    If keycode = PlungerKey Then PlaySoundat "fx_PlungerPull", Plunger:Plunger.Pullback
    If keycode = rightflipperkey then controller.switch(74) = 1
    If vpmKeyDown(keycode)Then Exit Sub

End Sub

Sub table1_KeyUp(ByVal Keycode)
    if keycode = rightflipperkey then controller.switch(74) = 0
    If vpmKeyUp(keycode)Then Exit Sub
    If keycode = PlungerKey Then PlaySoundAt "fx_plunger", Plunger:Plunger.Fire

End Sub

'*********
' Switches
'*********

' Slings
Dim LStep, RStep

Sub LeftSlingShot_Slingshot
    PlaySoundAt SoundFX("ABBASlingShot", DOFContactors), Lemk
    DOF 101, DOFPulse
    LeftSling4.Visible = 1
    Lemk.RotX = 26
    LStep = 0
    vpmTimer.PulseSw 71
    LeftSlingShot.TimerEnabled = 1
End Sub

Sub LeftSlingShot_Timer
    Select Case LStep
        Case 1:LeftSLing4.Visible = 0:LeftSLing3.Visible = 1:Lemk.RotX = 14
        Case 2:LeftSLing3.Visible = 0:LeftSLing2.Visible = 1:Lemk.RotX = 2
        Case 3:LeftSLing2.Visible = 0:Lemk.RotX = -10:LeftSlingShot.TimerEnabled = 0
    End Select
    LStep = LStep + 1
End Sub

Sub RightSlingShot_Slingshot
    PlaySoundAt SoundFX("ABBASlingShot", DOFContactors), Remk
    DOF 102, DOFPulse
    RightSling4.Visible = 1
    Remk.RotX = 26
    RStep = 0
    vpmTimer.PulseSw 64
    RightSlingShot.TimerEnabled = 1
End Sub

Sub RightSlingShot_Timer
    Select Case RStep
        Case 1:RightSLing4.Visible = 0:RightSLing3.Visible = 1:Remk.RotX = 14
        Case 2:RightSLing3.Visible = 0:RightSLing2.Visible = 1:Remk.RotX = 2
        Case 3:RightSLing2.Visible = 0:Remk.RotX = -10:RightSlingShot.TimerEnabled = 0
    End Select
    RStep = RStep + 1
End Sub

' Scoring rubbers
Sub sw44_Hit:vpmTimer.PulseSw 44:PlaySoundAtBall SoundFX("AahaABBAleft", DOFDropTargets):End Sub

Sub sw54_Hit:vpmTimer.PulseSw 54:PlaySoundAtBall SoundFX("AahaABBARight", DOFDropTargets):End Sub

' Rubber animations
Dim Rub1, Rub2

Sub RubberBand10_Hit:Rub1 = 1:RubberBand10_Timer:End Sub

Sub RubberBand10_Timer
    Select Case Rub1
        Case 1:r2.Visible = 0:r7.Visible = 1:RubberBand10.TimerEnabled = 1
        Case 2:r7.Visible = 0:r8.Visible = 1
        Case 3:r8.Visible = 0:r2.Visible = 1:RubberBand10.TimerEnabled = 0
    End Select
    Rub1 = Rub1 + 1
End Sub

Sub RubberBand15_Hit:Rub2 = 1:RubberBand15_Timer:End Sub
Sub RubberBand15_Timer
    Select Case Rub2
        Case 1:r6.Visible = 0:r9.Visible = 1:RubberBand15.TimerEnabled = 1
        Case 2:r9.Visible = 0:r10.Visible = 1
        Case 3:r10.Visible = 0:r6.Visible = 1:RubberBand15.TimerEnabled = 0
    End Select
    Rub2 = Rub2 + 1
End Sub

' Bumpers
Sub Bumper1_Hit:vpmTimer.PulseSw 3:PlaySoundAt SoundFX("ABBApopper", DOFContactors), Bumper1:End Sub
Sub Bumper2_Hit:vpmTimer.PulseSw 13:PlaySoundAt SoundFX("ABBApopper", DOFContactors), Bumper2:End Sub
Sub Bumper3_Hit:vpmTimer.PulseSw 23:PlaySoundAt SoundFX("ABBApopper", DOFContactors), Bumper3:End Sub

' Drain & Saucers
Sub Drain_Hit:PlaysoundAt "GimeAbreakManABBA", Drain:bsTrough.AddBall Me:End Sub
Sub sw2_Hit::PlaysoundAt "takeachanceon me",sw2:bsRightSaucer.AddBall 0:End Sub

' Rollovers
Sub sw4_Hit:Controller.Switch(4) = 1:PlaySoundAt "ABBArollOver", sw4:End Sub
Sub sw4_UnHit:Controller.Switch(4) = 0:End Sub

Sub sw14_Hit:Controller.Switch(14) = 1:PlaySoundAt "ABBArollOver", sw14:End Sub
Sub sw14_UnHit:Controller.Switch(14) = 0:End Sub

Sub sw24_Hit:Controller.Switch(24) = 1:PlaySoundAt "AahaABBAleft", sw24:End Sub
Sub sw24_UnHit:Controller.Switch(24) = 0:End Sub

Sub sw34_Hit:Controller.Switch(34) = 1:PlaySoundAt "AahaABBAleft", sw34:End Sub
Sub sw34_UnHit:Controller.Switch(34) = 0:End Sub

Sub sw42_Hit:Controller.Switch(42) = 1:PlaySoundAt "AahaABBAleft", sw42:End Sub
Sub sw42_UnHit:Controller.Switch(42) = 0:End Sub

Sub sw52_Hit:Controller.Switch(52) = 1:PlaySoundAt "AahaABBAright", sw52:End Sub 'fx_sensor
Sub sw52_UnHit:Controller.Switch(52) = 0:End Sub

Sub sw62_Hit:Controller.Switch(62) = 1:PlaySoundAt "AahaABBAright", sw62:End Sub
Sub sw62_UnHit:Controller.Switch(62) = 0:End Sub

' Droptargets
Sub sw35_Hit:PlaySoundAt SoundFX("ABBAdropTargetLeft1", DOFDropTargets), sw35:End Sub
Sub sw45_Hit:PlaySoundAt SoundFX("ABBAdropTargetLeft1", DOFDropTargets), sw45:End Sub
Sub sw55_Hit:PlaySoundAt SoundFX("ABBAdropTargetLeft1", DOFDropTargets), sw55:End Sub
Sub sw65_Hit:PlaySoundAt SoundFX("ABBAdropTargetLeft1", DOFDropTargets), sw65:End Sub
Sub sw75_Hit:PlaySoundAt SoundFX("ABBAdropTargetLeft1", DOFDropTargets), sw75:End Sub
Sub sw41_Hit:PlaySoundAt SoundFX("ABBAdropTargetCenter", DOFDropTargets), sw41:End Sub 
Sub sw51_Hit:PlaySoundAt SoundFX("ABBAdropTargetCenter", DOFDropTargets), sw51:End Sub
Sub sw61_Hit:PlaySoundAt SoundFX("ABBAdropTargetCenter", DOFDropTargets), sw61:End Sub
Sub sw11_Hit:PlaySoundAt SoundFX("ABBAdropTargetTop", DOFDropTargets), sw11:End Sub
Sub sw21_Hit:PlaySoundAt SoundFX("ABBAdropTargetTop", DOFDropTargets), sw21:End Sub
Sub sw31_Hit:PlaySoundAt SoundFX("ABBAdropTargetTop", DOFDropTargets), sw31:End Sub

Sub sw35_Dropped:dtbank1.Hit 1:End Sub
Sub sw45_Dropped:dtbank1.Hit 2:End Sub
Sub sw55_Dropped:dtbank1.Hit 3:End Sub
Sub sw65_Dropped:dtbank1.Hit 4:End Sub
Sub sw75_Dropped:dtbank1.Hit 5:End Sub
Sub sw41_Dropped:dtbank2.Hit 1:End Sub
Sub sw51_Dropped:dtbank2.Hit 2:End Sub
Sub sw61_Dropped:dtbank2.Hit 3:End Sub
Sub sw11_Dropped:dtbank3.Hit 1:End Sub
Sub sw21_Dropped:dtbank3.Hit 2:End Sub
Sub sw31_Dropped:dtbank3.Hit 3:End Sub

' Spinners
Sub Spinner1_Spin:vpmTimer.PulseSw 22:PlaySoundAt "fx_spinner", Spinner1:End Sub
Sub Spinner2_Spin:vpmTimer.PulseSw 12:PlaySoundAt "fx_spinner", Spinner2:End Sub
Sub Spinner3_Spin:vpmTimer.PulseSw 32:PlaySoundAt "fx_spinner", Spinner3:End Sub

'Targets
Sub sw33_Hit:vpmTimer.PulseSw 33:PlaySoundAtBall SoundFX("ABBAtarget", DOFDropTargets):End Sub
Sub sw43_Hit:vpmTimer.PulseSw 43:PlaySoundAtBall SoundFX("ABBAtarget", DOFDropTargets):End Sub
Sub sw53_Hit:vpmTimer.PulseSw 53:PlaySoundAtBall SoundFX("ABBAtarget", DOFDropTargets):End Sub
Sub sw63_Hit:vpmTimer.PulseSw 63:PlaySoundAtBall SoundFX("ABBAtarget", DOFDropTargets):End Sub
Sub sw73_Hit:vpmTimer.PulseSw 73:PlaySoundAtBall SoundFX("ABBAtarget", DOFDropTargets):End Sub
Sub sw72_Hit:vpmTimer.PulseSw 72:PlaySoundAtBall SoundFX("ABBAtarget", DOFDropTargets):End Sub

'*********
'Solenoids
'*********

SolCallback(1) = "bsTrough.SolOut"
SolCallback(2) = "bsRightSaucer.SolOut"
SolCallback(3) = "dtbank2.SolDropUp"
SolCallback(4) = "dtbank3.SolDropUp"
SolCallback(5) = "dtbank1.SolDropUp"
'SolCallback(6) = ""
SolCallback(7) = "dtbank1..SolHit 1,"
SolCallback(8) = "dtbank1..SolHit 2,"
SolCallback(9) = "dtbank1..SolHit 3,"
SolCallback(10) = "dtbank1..SolHit 4,"
SolCallback(11) = "dtbank1..SolHit 5,"

SolCallback(12) = "SolLeftGi"  'left flash effect
SolCallback(13) = "SolRightGi" 'right flash effect

SolCallback(17) = "SolGi"      '17=relay
SolCallback(18) = "vpmNudge.SolGameOn"

Sub SolGi(enabled)
    If enabled Then
        GiOff
    Else
        GiOn
    End If
End Sub

Sub SolLeftGi(enabled)
    If enabled Then
        For each x in aGiLeftLights
            x.State = 0
        Next
    Else
        For each x in aGiLeftLights
            x.State = 1
        Next
    End If
End Sub

Sub SolRightGi(enabled)
    If enabled Then
        For each x in aGiRightLights
            x.State = 0
        Next
    Else
        For each x in aGiRightLights
            x.State = 1
        Next
    End If
End Sub

'**************
' Flipper Subs
'**************

SolCallback(sLRFlipper) = "SolRFlipper"
SolCallback(sLLFlipper) = "SolLFlipper"

Sub SolLFlipper(Enabled)
    If Enabled Then
        PlaySoundAt SoundFX("fx_flipperup", DOFFlippers), LeftFlipper
        LeftFlipper.RotateToEnd
    Else
        PlaySoundAt SoundFX("fx_flipperdown", DOFFlippers), LeftFlipper
        LeftFlipper.RotateToStart
    End If
End Sub

Sub SolRFlipper(Enabled)
    If Enabled Then
        PlaySoundAt SoundFX("fx_flipperup", DOFFlippers), RightFlipper
        RightFlipper.RotateToEnd
    Else
        PlaySoundAt SoundFX("fx_flipperdown", DOFFlippers), RightFlipper
        RightFlipper.RotateToStart
    End If
End Sub

Sub LeftFlipper_Collide(parm)
PlaySound "fx_rubber_flipper", 0, parm/60, pan(ActiveBall), 0.2, 0, 0, 0, AudioFade(ActiveBall)
End Sub

Sub RightFlipper_Collide(parm)
PlaySound "fx_rubber_flipper", 0, parm/60, pan(ActiveBall), 0.2, 0, 0, 0, AudioFade(ActiveBall)
End Sub

'*****************
'   Gi Effects
'*****************

Dim OldGiState
OldGiState = -1 'start witht he Gi off

Sub GiON
    For each x in aGiLights
    x.State = 1
   	Next

End Sub

Sub GiOFF
    For each x in aGiLights
    x.State = 0
   	Next

End Sub

Sub GiEffect(enabled)
    If enabled Then
        For each x in aGiLights
            x.Duration 2, 1000, 1
        Next
    End If
End Sub

Sub GIUpdate
    Dim tmp, obj
    tmp = Getballs
    If UBound(tmp) <> OldGiState Then
        OldGiState = Ubound(tmp)
        If UBound(tmp) = -1 Then
            GiOff
        Else
            GiOn
        End If
    End If
End Sub
'********************
' Music as mp3 sounds
'********************
Dim SongNumber: SongNumber = 0

PlayRandomSong

Sub PlayRandomSong

   SongNumber  = INT(RND * 4) + 1

   PlayMusic "ABBA-song" & SongNumber & ".mp3"

End Sub

Sub table1_MusicDone

   PlayRandomSong

End Sub
'**********************************************************
'     JP's Flasher Fading for VPX and Vpinmame
'       (Based on Pacdude's Fading Light System)
' This is a fast fading for the Flashers in vpinmame tables
'  just 4 steps, like in Pacdude's original script.
' Included the new Modulated flashers & Lights for WPC
'**********************************************************

Dim LampState(200), FadingState(200), FlashLevel(200)

InitLamps() ' turn off the lights and flashers and reset them to the default parameters
'If li149.State = 0 Then PlaySound "AbbaVoulezVous", -1
' vpinmame Lamp & Flasher Timers

Sub LampTimer_Timer()
    Dim chgLamp, num, chg, ii
    chgLamp = Controller.ChangedLamps
    If Not IsEmpty(chgLamp)Then
        For ii = 0 To UBound(chgLamp)
            LampState(chgLamp(ii, 0)) = chgLamp(ii, 1)       'keep the real state in an array
            FadingState(chgLamp(ii, 0)) = chgLamp(ii, 1) + 3 'fading step
        Next
    End If
    UpdateLeds
    UpdateLamps
    'NVramPatchKeyCheck
End Sub

Sub UpdateLamps()
    Lamp 0, li0
    Lamp 1, li1
    Lamp 10, li10
    Lampm 100, li100
    Flash 100, li100a
    Lampm 101, li101
    Flash 101, li101a
    Lamp 102, li102
    Lamp 103, li103
    Lamp 109, li109
    Lamp 11, li11
    Lamp 110, LightBumper1
    Lamp 111, LightBumper2
    Lamp 112, LightBumper3
    Lamp 113, li113
    Lamp 12, li12
    Lamp 123, li123
    Lamp 133, li133
    Lamp 143, li143
    Lamp 153, li153
    Lamp 2, li2
    Lamp 20, li20
    Lamp 21, li21
    Lamp 22, li22
    Lamp 30, li30
    Lamp 31, li31
    Lamp 32, li32
    Lamp 40, li40
    Lamp 41, li41
    Lamp 42, li42
    Lamp 50, li50
    Lamp 51, li51
    Lamp 52, li52
    Lamp 60, li60
    Lampm 61, li61
    Lampm 61, li61a
    Flashm 61, li61b
    Flash 61, li61c
    Lamp 62, li62
    Lampm 70, li70
    Flash 70, li70a
    Lampm 71, li71
    Flash 71, li71a
    Lampm 72, li72
    Flash 72, li72a
    Lamp 79, li79
    Lamp 80, li80
    Lamp 81, li81
    Lampm 82, li82
    Flash 82, li82a
    Lamp 83, li83
    Lamp 89, li89
    Lamp 90, li90
    Lamp 91, li91
    Lampm 92, li92
    Flash 92, li92a
    Lamp 93, li93
    Lampm 99, li99
    Flash 99, li99a
    'backdrop lights
    Lamp 139, li139
    Lamp 140, li140
    Lamp 141, li141
    Lamp 142, li142
    Lamp 149, li149
    Lamp 150, li150
    Lamp 151, li151
    Lamp 152, li152
    
End Sub
 
' div lamp subs

' Normal Lamp & Flasher subs

Sub InitLamps()
    
	Dim x
    LampTimer.Interval = 25 ' flasher fading speed
    LampTimer.Enabled = 1
    For x = 0 to 200
        LampState(x) = 0
        FadingState(x) = 3 ' used to track the fading state
        FlashLevel(x) = 0
    Next
End Sub

Sub SetLamp(nr, value) ' 0 is off, 1 is on
    FadingState(nr) = abs(value) + 3
 
End Sub

' Lights: used for VPX standard lights, the fading is handled by VPX itself, they are here to be able to make them work together with the flashers

Sub Lamp(nr, object)
    Select Case FadingState(nr) 
        Case 4:object.state = 1:FadingState(nr) = 0
        Case 3:object.state = 0:FadingState(nr) = 0
    End Select
End Sub

Sub Lampm(nr, object) ' used for multiple lights, it doesn't change the fading state
    Select Case FadingState(nr)
        Case 4:object.state = 1
        Case 3:object.state = 0
	End Select
End Sub

' Flashers: 4 is on,3,2,1 fade steps. 0 is off

Sub Flash(nr, object)
    Select Case FadingState(nr)
        Case 4:Object.IntensityScale = 1:FadingState(nr) = 0
        Case 3:Object.IntensityScale = 0.66:FadingState(nr) = 2
        Case 2:Object.IntensityScale = 0.33:FadingState(nr) = 1
        Case 1:Object.IntensityScale = 0:FadingState(nr) = 0
    End Select
End Sub

Sub Flashm(nr, object) 'multiple flashers, it doesn't change the fading state
    Select Case FadingState(nr)
        Case 4:Object.IntensityScale = 1
        Case 3:Object.IntensityScale = 0.66
        Case 2:Object.IntensityScale = 0.33
        Case 1:Object.IntensityScale = 0
    End Select
End Sub

' Desktop Objects: Reels & texts (you may also use lights on the desktop)

' Reels

Sub Reel(nr, object)
    Select Case FadingState(nr)
        Case 4:object.SetValue 1:FadingState(nr) = 0
        Case 3:object.SetValue 2:FadingState(nr) = 2
        Case 2:object.SetValue 3:FadingState(nr) = 1
        Case 1:object.SetValue 0:FadingState(nr) = 0
    End Select
End Sub

Sub Reelm(nr, object)
    Select Case FadingState(nr)
        Case 4:object.SetValue 1
        Case 3:object.SetValue 2
        Case 2:object.SetValue 3
        Case 1:object.SetValue 0
    End Select
End Sub

'Texts

Sub Text(nr, object, message)
    Select Case FadingState(nr)
        Case 4:object.Text = message:FadingState(nr) = 0
        Case 3:object.Text = "":FadingState(nr) = 0
    End Select
End Sub

Sub Textm(nr, object, message)
    Select Case FadingState(nr)
        Case 4:object.Text = message
        Case 3:object.Text = ""
    End Select
End Sub

' Modulated Subs for the WPC tables

Sub SetModLamp(nr, level)
    FlashLevel(nr) = level / 150 'lights & flashers
End Sub

Sub LampMod(nr, object)          ' modulated lights used as flashers
    Object.IntensityScale = FlashLevel(nr)
    Object.State = 1             'in case it was off
End Sub

Sub FlashMod(nr, object)         'sets the flashlevel from the SolModCallback
    Object.IntensityScale = FlashLevel(nr)
End Sub

'Walls and mostly Primitives used as 4 step fading lights
'a,b,c,d are the images used from on to off

Sub FadeObj(nr, object, a, b, c, d)
    Select Case FadingState(nr)
        Case 4:object.image = a:FadingState(nr) = 0 'fading to off...
        Case 3:object.image = b:FadingState(nr) = 2
        Case 2:object.image = c:FadingState(nr) = 1
        Case 1:object.image = d:FadingState(nr) = 0
    End Select
End Sub

Sub FadeObjm(nr, object, a, b, c, d)
    Select Case FadingState(nr)
        Case 4:object.image = a
        Case 3:object.image = b
        Case 2:object.image = c
        Case 1:object.image = d
    End Select
End Sub

Sub NFadeObj(nr, object, a, b)
    Select Case FadingState(nr)
        Case 4:object.image = a:FadingState(nr) = 0 'off
        Case 3:object.image = b:FadingState(nr) = 0 'on
    End Select
End Sub

Sub NFadeObjm(nr, object, a, b)
    Select Case FadingState(nr)
        Case 4:object.image = a
        Case 3:object.image = b
    End Select
End Sub

'Modulated lights & Flashers

Sub SetModLamp(nr, level)
    FlashLevel(nr) = level / 150 'lights & flashers
End Sub

Sub LightMod(nr, object)         ' modulated lights used as flashers
    Object.IntensityScale = FlashLevel(nr)
    Object.State = 1
End Sub

Sub FlashMod(nr, object) 'sets the flashlevel from the SolModCallback
    Object.IntensityScale = FlashLevel(nr)
End Sub

'************************************
'          LEDs Display
'     Based on Scapino's LEDs
'************************************

Dim Digits(32)
Dim Patterns(11)
Dim Patterns2(11)

Patterns(0) = 0     'empty
Patterns(1) = 63    '0
Patterns(2) = 6     '1
Patterns(3) = 91    '2
Patterns(4) = 79    '3
Patterns(5) = 102   '4
Patterns(6) = 109   '5
Patterns(7) = 125   '6
Patterns(8) = 7     '7
Patterns(9) = 127   '8
Patterns(10) = 111  '9

Patterns2(0) = 128  'empty
Patterns2(1) = 191  '0
Patterns2(2) = 134  '1
Patterns2(3) = 219  '2
Patterns2(4) = 207  '3
Patterns2(5) = 230  '4
Patterns2(6) = 237  '5
Patterns2(7) = 253  '6
Patterns2(8) = 135  '7
Patterns2(9) = 255  '8
Patterns2(10) = 239 '9

'Assign 6-digit output to reels
Set Digits(0) = a0
Set Digits(1) = a1
Set Digits(2) = a2
Set Digits(3) = a3
Set Digits(4) = a4
Set Digits(5) = a5

Set Digits(6) = b0
Set Digits(7) = b1
Set Digits(8) = b2
Set Digits(9) = b3
Set Digits(10) = b4
Set Digits(11) = b5

Set Digits(12) = c0
Set Digits(13) = c1
Set Digits(14) = c2
Set Digits(15) = c3
Set Digits(16) = c4
Set Digits(17) = c5

Set Digits(18) = d0
Set Digits(19) = d1
Set Digits(20) = d2
Set Digits(21) = d3
Set Digits(22) = d4
Set Digits(23) = d5

Set Digits(24) = e0
Set Digits(25) = e1

Sub UpdateLeds
    On Error Resume Next
    Dim ChgLED, ii, jj, chg, stat
    ChgLED = Controller.ChangedLEDs(&HFF, &HFFFF)
    If Not IsEmpty(ChgLED)Then
        For ii = 0 To UBound(ChgLED)
            chg = chgLED(ii, 1):stat = chgLED(ii, 2)
            For jj = 0 to 10
                If stat = Patterns(jj)OR stat = Patterns2(jj)then Digits(chgLED(ii, 0)).SetValue jj
            Next
        Next
    End IF
End Sub

'******************************
' Diverse Collection Hit Sounds
'******************************

Sub aMetals_Hit(idx):PlaySoundAtBall "fx_MetalHit":End Sub
Sub aRubber_Bands_Hit(idx):PlaySoundAtBall "fx_rubber_band":End Sub
Sub aRubber_Posts_Hit(idx):PlaySoundAtBall "fx_rubber_post":End Sub
Sub aRubber_Pins_Hit(idx):PlaySoundAtBall "fx_rubber_pin":End Sub
Sub aPlastics_Hit(idx):PlaySoundAtBall "fx_PlasticHit":End Sub
Sub aGates_Hit(idx):PlaySoundAtBall "fx_Gate":End Sub
Sub aWoods_Hit(idx):PlaySoundAtBall "fx_Woodhit":End Sub

' *********************************************************************
'                      Supporting Ball & Sound Functions
' *********************************************************************

Function Vol(ball) ' Calculates the Volume of the sound based on the ball speed
    Vol = Csng(BallVel(ball) ^2 / 2000)
End Function

Function Pan(ball) ' Calculates the pan for a ball based on the X position on the table. "table1" is the name of the table
    Dim tmp
    tmp = ball.x * 2 / table1.width-1
    If tmp > 0 Then
        Pan = Csng(tmp ^10)
    Else
        Pan = Csng(-((- tmp) ^10))
    End If
End Function

Function Pitch(ball) ' Calculates the pitch of the sound based on the ball speed
    Pitch = BallVel(ball) * 20
End Function

Function BallVel(ball) 'Calculates the ball speed
    BallVel = (SQR((ball.VelX ^2) + (ball.VelY ^2)))
End Function

Function AudioFade(ball) 'only on VPX 10.4 and newer
    Dim tmp
    tmp = ball.y * 2 / Table1.height-1
    If tmp > 0 Then
        AudioFade = Csng(tmp ^10)
    Else
        AudioFade = Csng(-((- tmp) ^10))
    End If
End Function

Sub PlaySoundAt(soundname, tableobj) 'play sound at X and Y position of an object, mostly bumpers, flippers and other fast objects
    PlaySound soundname, 0, 1, Pan(tableobj), 0.06, 0, 0, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtBall(soundname) ' play a sound at the ball position, like rubbers, targets, metals, plastics
    PlaySound soundname, 0, Vol(ActiveBall), pan(ActiveBall), 0.2, 0, 0, 0, AudioFade(ActiveBall)
End Sub

'********************************************
'   JP's VP10 Rolling Sounds + Ballshadow
' uses a collection of shadows, aBallShadow
'********************************************

Const tnob = 20 ' total number of balls
Const lob = 0   'number of locked balls
ReDim rolling(tnob)
InitRolling

Sub InitRolling
    Dim i
    For i = 0 to tnob
        rolling(i) = False
    Next
End Sub

Sub RollingUpdate()
    Dim BOT, b, ballpitch, ballvol
    BOT = GetBalls

    ' stop the sound of deleted balls
    For b = UBound(BOT) + 1 to tnob
        rolling(b) = False
        StopSound("fx_ballrolling" & b)
    Next

    ' exit the sub if no balls on the table
    If UBound(BOT) = lob - 1 Then Exit Sub 'there no extra balls on this table

    ' play the rolling sound for each ball and draw the shadow
    For b = lob to UBound(BOT)

		aBallShadow(b).X = BOT(b).X
		aBallShadow(b).Y = BOT(b).Y

        If BallVel(BOT(b) )> 1 Then
            If BOT(b).z <30 Then
                ballpitch = Pitch(BOT(b) )
                ballvol = Vol(BOT(b) )
            Else
                ballpitch = Pitch(BOT(b) ) + 25000 'increase the pitch on a ramp
                ballvol = Vol(BOT(b) ) * 10
            End If
            rolling(b) = True
            PlaySound("fx_ballrolling" & b), -1, ballvol, Pan(BOT(b) ), 0, ballpitch, 1, 0, AudioFade(BOT(b) )
        Else
            If rolling(b) = True Then
                StopSound("fx_ballrolling" & b)
                rolling(b) = False
            End If
        End If
        ' rothbauerw's Dropping Sounds
        If BOT(b).VelZ < -1 and BOT(b).z < 55 and BOT(b).z > 27 Then 'height adjust for ball drop sounds
            PlaySound "fx_balldrop", 0, ABS(BOT(b).velz)/17, Pan(BOT(b)), 0, Pitch(BOT(b)), 1, 0, AudioFade(BOT(b))
        End If
    Next
End Sub

'**********************
' Ball Collision Sound
'**********************

Sub OnBallBallCollision(ball1, ball2, velocity)
    PlaySound("fx_collide"), 0, Csng(velocity) ^2 / 2000, Pan(ball1), 0, Pitch(ball1), 0, 0, AudioFade(ball1)
End Sub

' ' =============================================================================================================
' '                 NVram patch for Taito do Brasil tables by Pmax65
' '
' ' NVramPatchExit	' Must be placed before the Controler.Stop statement into the Table1_Exit Sub
' ' NVramPatchLoad	' Must be placed before the VPinMAME controller initialization
' ' NVramPatchKeyCheck' Must be placed in the lamptimer timer
' ' =============================================================================================================
 
' Const GameOverLampID = 149 ' set this constant to the ID number of the game-over lamp
' Dim NVramPatchCoinCnt

' Function GetNVramPath()
'     Dim WshShell
'     Set WshShell = CreateObject("WScript.Shell")
'     GetNVramPath = WshShell.RegRead("HKEY_CURRENT_USER\Software\Freeware\Visual PinMame\globals\nvram_directory")
' End function

' Function FileExists(FileName)
'     DIM FSO
'     FileExists = False
'     Set FSO = CreateObject("Scripting.FileSystemObject")
'     FileExists = FSO.FileExists(FileName)
'     Set FSO = Nothing
' End Function

' Sub Kill(FileName)
'     Dim ObjFile, FSO
'     On Error Resume Next
'     Set FSO = CreateObject("Scripting.FileSystemObject")
'     Set ObjFile = FSO.GetFile(FileName)
'     ObjFile.Delete
'     On Error Goto 0
'     Set FSO = Nothing
' End Sub

' Sub Copy(SourceFileName, DestFileName)
'     Dim FSO
'     On Error Resume Next
'     Set FSO = CreateObject("Scripting.FileSystemObject")
'     FSO.CopyFile SourceFileName, DestFileName, True
'     On Error Goto 0
'     Set FSO = Nothing
' End Sub

' Sub NVramPatchLoad
'     NVramPatchCoinCnt = 0
'     If FileExists(GetNVramPath + "\" + cGameName + ".nvb")Then
'         Copy GetNVramPath + "\" + cGameName + ".nvb", GetNVramPath + "\" + cGameName + ".nv"
'     Else
'         Copy GetNVramPath + "\" + cGameName + ".nv", GetNVramPath + "\" + cGameName + ".nvb"
'     End If
' End Sub

' Sub NVramPatchExit
     
'         Kill GetNVramPath + "\" + cGameName + ".nvb"
'         Do
    
' 		LampTimer_Timer          ' This loop is needed to avoid the NVram reset (losing the hi-score and credits)
'         Loop Until LampState(20) = 1 ' when the game is over but the match procedure isn't still ended

' End Sub
' ' =============================================================================================================
' ' To completely erase the NVram file keep the Start Game button pushed while inserting
' ' two coins into the first coin slit (this resets the high scores too)
' ' =============================================================================================================

' Sub NVramPatchKeyCheck
'     If Controller.Switch(swStartButton)then
'         If Controller.Switch(swCoin1)then
'             If NVramPatchCoinCnt = 2 Then
'                 Controller.Stop
'                 Kill GetNVramPath + "\" + cGameName + ".nv"
'                 Kill GetNVramPath + "\" + cGameName + ".nvb"
'                 QuitPlayer 2
'             Else
'                 NVramPatchCoinCnt = 1
'             End If
'         Else
'             If NVramPatchCoinCnt = 1 Then
'                 NVramPatchCoinCnt = 2
'             End If
'         End If
'     Else
'         NVramPatchCoinCnt = 0
    
' 	End If
' End Sub
