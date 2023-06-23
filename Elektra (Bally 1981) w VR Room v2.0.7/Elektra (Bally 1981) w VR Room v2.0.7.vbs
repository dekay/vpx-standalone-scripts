' Elektra / IPD No. 778 / December, 1981 / 4 Players

'___________.____     _______________  __._____________________    _____   
'\_   _____/|    |    \_   _____/    |/ _|\__    ___/\______   \  /  _  \  
' |    __)_ |    |     |    __)_|      <    |    |    |       _/ /  /_\  \ 
' |        \|    |___  |        \    |  \   |    |    |    |   \/    |    \
'/_______  /|_______ \/_______  /____|__ \  |____|    |____|_  /\____|__  /
'        \/         \/        \/        \/                   \/         \/

' Version 1.1 by 32assassin, and original artwork by Francisco666

' Version 2.0 by UnclePaulie 2023
'	Table includes Hybrid VR/desktop/cabinet modes, new upscaled playfield, VPW physics, Fleep sounds, Lampz, 3D inserts, new GI, sling corrections, targets, saucers, playfield mesh, etc.  
' 	Updated playfield, plastics, and other images done by redbone.
'	New ramp primitives done by Tomate.
'	GI lighting and shadows done by iaakki
'	Complete implementation details found at the bottom of the script.

Option Explicit
Randomize


'*******************************************
' Desktop, Cab, and VR OPTIONS
'*******************************************

' Desktop, Cab, and VR Room are automatically selected.  However if in VR Room mode, you can change the environment with the magna save buttons.

const BallLightness = 2 '0 = dark, 1 = not as dark, 2 = bright, 3 = brightest 

Dim LUTset, DisableLUTSelector, LutToggleSound, LutToggleSoundLevel

LutToggleSound = True
LutToggleSoundLevel = .1
DisableLUTSelector = 0  	' Disables the ability to change LUT option with magna saves in game when set to 1
const SetDIPSwitches = 0	' 0 is the default dip settings for game play. (RECOMMENDED) If you want to set the dips differently, set to 1, and then hit F6 to launch.

' *** If using VR Room:

const CustomWalls = 0 'set to 0 for Modern Minimal Walls, floor, and roof, 1 for Sixtoe's original walls and floor
const WallClock = 1	  '1 Shows the clock in the VR minimal rooms only
const topper = 1		 '0 = Off 1= On - Topper visible in VR Room only
const poster = 1		 '1 Shows the flyer posters in the VR room only 
const poster2 = 1		 '1 Shows the flyer posters in the VR room only 

' ****************************************************

'----- Shadow Options -----
Const DynamicBallShadowsOn 	= 1		'0 = no dynamic ball shadow ("triangles" near slings and such), 1 = enable dynamic ball shadow
Const AmbientBallShadowOn 	= 1		'0 = Static shadow under ball ("flasher" image, like JP's)
									'1 = Moving ball shadow ("primitive" object, like ninuzzu's) - This is the only one that shows up on the pf when in ramps and fades when close to lights!
									'2 = flasher image shadow, but it moves like ninuzzu's
Const fovY					= 0		'Offset y position under ball to account for layback or inclination (more pronounced need further back)

'Ambient (Room light source)
Const AmbientBSFactor 		= 1 	'0 to 1, higher is darker
Const AmbientMovement		= 2		'1 to 4, higher means more movement as the ball moves left and right
Const offsetX				= 0		'Offset x position under ball	(These are if you want to change where the "room" light is for calculating the shadow position,)
Const offsetY				= 0		'Offset y position under ball	 (for example 5,5 if the light is in the back left corner)

'Dynamic (Table light sources)
Const DynamicBSFactor 		= 1		'0 to 1, higher is darker
Const Wideness				= 20	'Sets how wide the dynamic ball shadows can get (20 +5 thinness should be most realistic for a 50 unit ball)
Const Thinness				= 5		'Sets minimum as ball moves away from source

'----- General Sound Options -----
Const VolumeDial = 0.8				' Recommended values should be no greater than 1.
Const BallRollVolume = 0.5 			'Level of ball rolling volume. Value between 0 and 1
Const RampRollVolume = 0.5 			'Level of ramp rolling volume. Value between 0 and 1

'----- Phsyics Mods -----
Const FlipperCoilRampupMode = 0   	'0 = fast, 1 = medium, 2 = slow (tap passes should work)
Const TargetBouncerEnabled = 1 		'0 = normal standup targets, 1 = bouncy targets, 2 = orig TargetBouncer
Const TargetBouncerFactor = 0.7 	'Level of bounces. Recommmended value of 0.7 when TargetBouncerEnabled


'//////////////---- LUT (Colour Look Up Table) ----//////////////
'0 = Fleep Natural Dark 1
'1 = Fleep Natural Dark 2
'2 = Fleep Warm Dark
'3 = Fleep Warm Bright
'4 = Fleep Warm Vivid Soft
'5 = Fleep Warm Vivid Hard
'6 = Skitso Natural and Balanced
'7 = Skitso Natural High Contrast
'8 = 3rdaxis Referenced THX Standard
'9 = CalleV Punchy Brightness and Contrast
'10 = HauntFreaks Desaturated
'11 = Tomate Washed Out 
'12 = VPW Original 1 to 1
'13 = Bassgeige
'14 = Blacklight
'15 = B&W Comic Book
'16 = Skitso New Warmer LUT
'17 = Original LUT


LoadLUT

'LUTset = 16			' Override saved LUT for debug
SetLUT
ShowLUT_Init


' ****************************************************
' standard definitions
' ****************************************************

Dim VR_Room, cab_mode, DesktopMode: DesktopMode = Table1.ShowDT
If RenderingMode = 2 Then VR_Room=1 Else VR_Room=0      'VRRoom set based on RenderingMode in version 10.72
if Not DesktopMode and VR_Room=0 Then cab_mode=1 Else cab_mode=0

Const UseSolenoids 	= 2
Const UseLamps 		= 0
Const UseSync 		= 0
Const HandleMech 	= 0
Const UseGI			= 0
Const cGameName 	= "elektra"		'ROM name
Const ballsize 		= 50
Const ballmass 		= 1
Const UsingROM 		= True			'The UsingROM flag is to indicate code that requires ROM usage. 

'***********************

Const tnob = 4						'Total number of balls  (2 multiball, and one captive ball up top, one down below)
Const lob = 0						'Locked balls

Dim tablewidth: tablewidth = Table1.width
Dim tableheight: tableheight = Table1.height
Dim i, eBall1, eBall2, eBall3, eBall4, gBOT
Dim BIPL : BIPL = False				'Ball in plunger lane

On Error Resume Next
ExecuteGlobal GetTextFile("controller.vbs")
If Err Then MsgBox "You need the controller.vbs in order to run this table, available in the vp10 package"
On Error Goto 0

LoadVPM "00990400", "Bally.VBS", 1.2


'**********************************************************************************************************
'Solenoids
'**********************************************************************************************************

'Solenoid Call backs
'**********************************************************************************************************

SolCallback(6) 	= "SolKnocker"				'knocker solenoid
SolCallback(7) 	= "SolOutholeKicker"		'drain
SolCallBack(10) = "SolTopSaucer"			'Top level saucer
SolCallBack(11) = "SolRightSaucer"			'Right level saucer
SolCallback(12) = "SolDTDropUp"				'Drop Targets Raise
SolCallBack(13) = "SolLowerSaucer" 			'lower level saucer
SolCallback(17) = "SolGateDiverter"			'Rotate the plunger diverter gate
SolCallback(18) = "SolBGGI"					'Backglass GI

SolCallback(sllflipper)="SolLFlipper"
SolCallback(slrflipper)="SolRFlipper"


'*******************************************
'  Timers
'*******************************************

' The game timer interval is 10 ms
Sub GameTimer_Timer()
	Cor.Update 						'update ball tracking
	RollingUpdate					'update rolling sounds
	DoDTAnim 						'handle drop target animations
	DoSTAnim						'handle stand up target animations
	SpinnerTimer
End Sub


' The frame timer interval is -1, so executes at the display frame rate
Sub FrameTimer_Timer()
	FlipperVisualUpdate				'update flipper shadows and primitives
	If DynamicBallShadowsOn Or AmbientBallShadowOn Then DynamicBSUpdate 'update ball shadows

	If VR_Room=0 Then
		DisplayTimer
	End If

	If VR_Room=1 Then
		VRDisplayTimer
	End If
	LampTimer						'used for Lampz.  No need for separate timer.

End Sub

' This subroutine updates the flipper shadows and visual primitives
Sub FlipperVisualUpdate
	Lflipmesh1.RotZ = LeftFlipper.CurrentAngle
	Rflipmesh1.RotZ = RightFlipper.CurrentAngle
	FlipperLSh.RotZ = LeftFlipper.currentangle
	FlipperRSh.RotZ = RightFlipper.currentangle
	LflipmeshUp.RotZ = LeftFlipper1.CurrentAngle
	RflipmeshUp.RotZ = RightFlipper1.CurrentAngle
	FlipperLShUp.RotZ = LeftFlipper1.currentangle
	FlipperRShUp.RotZ = RightFlipper1.currentangle
	FlipperLShLow.RotZ = LeftFlipperLower.currentangle
	FlipperRShLow.RotZ = RightFlipperLower.currentangle
	Primitiveflipper.RotY = OutGate.Currentangle
End Sub


'**********************************************************************************************************
'Initiate Table
'**********************************************************************************************************

Dim lowflipon

Sub Table1_Init
	vpmInit Me
	On Error Resume Next
		With Controller
		.GameName = cGameName
		If Err Then MsgBox "Can't start Game" & cGameName & vbNewLine & Err.Description : Exit Sub
		.SplashInfoLine = "Elecktra (Bally 1981)"&chr(13)&"by UnclePaulie"
		.HandleMechanics=0
		.HandleKeyboard=0
		.ShowDMDOnly=1
		.ShowFrame=0
		.ShowTitle=0
        .hidden = 1
		.Games(cGameName).Settings.Value("sound") = 1 ' Set sound (0=OFF, 1=ON)	
		If Err Then MsgBox Err.Description
	End With
	On Error Goto 0

		Controller.Run
	If Err Then MsgBox Err.Description
	On Error Goto 0


	PinMAMETimer.Interval=PinMAMEInterval
	PinMAMETimer.Enabled=1

	vpmNudge.TiltSwitch = 15
	vpmNudge.Sensitivity = 1
	vpmNudge.TiltObj = Array(LeftSlingshot,RightSlingshot, LeftFlipper, LeftFlipper1, RightFlipper, RightFlipper1)

'Ball initializations need for physical trough
	Set eBall1 = BallRelease.CreateSizedballWithMass(Ballsize/2,Ballmass)
	Set eBall2 = Slot.CreateSizedballWithMass(Ballsize/2,Ballmass)
	Set eBall3 = SW06.CreateSizedballWithMass(Ballsize/2,Ballmass)
	Set eBall4 = SW08.CreateSizedballWithMass(Ballsize/2,Ballmass)

'Ball initializations
	gBOT = Array(eBall1, eBall2, eBall3, eBall4)
	Controller.Switch(1) = 1
	Controller.Switch(2) = 1
	Controller.Switch(8) = 1

'Saucer initializations
	controller.switch(3) = 0
	controller.switch(4) = 0

	SW06.Kick 270,1

'Lower flippers off
	lowflipon = 0

	if VR_Room = 1 Then
		setup_backglass()
		SetBackglass
	End If

' If user wants to set dip switches themselves it will force them to set it via F6.
If SetDIPSwitches = 0 Then
	SetDefaultDips
End If

End Sub

Sub table1_Paused:Controller.Pause = 1:End Sub
Sub table1_unPaused:Controller.Pause = 0:End Sub
Sub table1_exit
	SaveLUT
	Controller.stop
End Sub

'********************************************
' Keys and Plunger code
'********************************************
 
Sub table1_KeyDown(ByVal Keycode)

	If keycode = LeftMagnaSave Then 
		bLutActive = True
	End If

	If keycode = RightMagnaSave Then 
		If bLutActive Then 
			if DisableLUTSelector = 0 then
				If LutToggleSound Then
					Playsound "click", 0, LutToggleSoundLevel * VolumeDial, 0, 0.2, 0, 0, 0, 1
				End If
				LUTSet = LUTSet  + 1
				if LutSet > 17 then LUTSet = 0
				SetLUT
				ShowLUT
			end if
		End If
    End If

	If keycode = LeftTiltKey Then Nudge 90, 1 ': SoundNudgeLeft
	If keycode = RightTiltKey Then Nudge 270, 1 ': SoundNudgeRight
	If keycode = CenterTiltKey Then Nudge 0, 1 ': SoundNudgeCenter


	If KeyCode = PlungerKey Then
		Plunger.PullBack
		SoundPlungerPull()
		TimerVRPlunger.Enabled = True
		TimerVRPlunger1.Enabled = False
		PinCab_Shooter.Y = -390
	End If

	If keycode = LeftFlipperKey Then 
		controller.switch(5) = 1
		VRFlipperButtonLeft.X = VRFlipperButtonLeft.X + 8
		FlipperActivate LeftFlipper, LFPress
		FlipperActivate LeftFlipper1, LFPress1
	End If

	If keycode = RightFlipperKey Then
		VRFlipperButtonRight.X = VRFlipperButtonRight.X - 8
		FlipperActivate RightFlipper, RFPress
		FlipperActivate RightFlipper1, RFPress1
	End If

	If keycode = StartGameKey Then
		StartButton.y = 1939.978 - 5
		SoundStartButton
	End If

	If keycode = keyInsertCoin1 or keycode = keyInsertCoin2 or keycode = keyInsertCoin3 or keycode = keyInsertCoin4 Then 'Use this for ROM based games
		Select Case Int(rnd*3)
			Case 0: PlaySound ("Coin_In_1"), 0, CoinSoundLevel, 0, 0.25
			Case 1: PlaySound ("Coin_In_2"), 0, CoinSoundLevel, 0, 0.25
			Case 2: PlaySound ("Coin_In_3"), 0, CoinSoundLevel, 0, 0.25
		End Select
	End If

    If vpmKeyDown(keycode) Then Exit Sub

End Sub
 

Sub table1_KeyUp(ByVal Keycode)

    If keycode = LeftMagnaSave Then 
		bLutActive = False
	End If

	If keycode = PlungerKey Then 
		Plunger.Fire
		If BIPL = 1 Then
			SoundPlungerReleaseBall()			'Plunger release sound when there is a ball in shooter lane
		Else
			SoundPlungerReleaseNoBall()			'Plunger release sound when there is no ball in shooter lane
		End If
		TimerVRPlunger.Enabled = False
		TimerVRPlunger1.Enabled = True
		PinCab_Shooter.Y = -390
	End If

	If keycode = LeftFlipperKey Then 
		controller.switch(5) = 0
		VRFlipperButtonLeft.X = VRFlipperButtonLeft.X - 8
		FlipperDeActivate LeftFlipper, LFPress
		FlipperDeActivate LeftFlipper1, LFPress1
	End If

	If keycode = RightFlipperKey Then
		VRFlipperButtonRight.X = VRFlipperButtonRight.X + 8
		FlipperDeActivate RightFlipper, RFPress
		FlipperDeActivate RightFlipper1, RFPress1
	End If

	If keycode = StartGameKey Then
		StartButton.y = 1939.978
	End If

	if vpmKeyUp(keycode) Then Exit Sub

End Sub


'*******************************************
'  Flippers
'*******************************************

Const ReflipAngle = 20

Sub SolLFlipper(Enabled)
	If Enabled Then

	  if lowflipon = 0 Then		'main and upper playfield flippers 
		LF.Fire  'leftflipper.rotatetoend
		LF1.Fire

	  Else						'under playfield flippers
		LF2.Fire
	  end If

		If leftflipper.currentangle < leftflipper.endangle + ReflipAngle Then 
			RandomSoundReflipUpLeft LeftFlipper
		Else 
			SoundFlipperUpAttackLeft LeftFlipper
			RandomSoundFlipperUpLeft LeftFlipper
		End If		
	Else
		LeftFlipper.RotateToStart
		LeftFlipper1.RotateToStart
		LeftFlipperLower.RotateToStart
		If LeftFlipper.currentangle < LeftFlipper.startAngle - 5 Then
			RandomSoundFlipperDownLeft LeftFlipper
		End If
		FlipperLeftHitParm = FlipperUpSoundLevel
	End If
End Sub

Sub SolRFlipper(Enabled)
	If Enabled Then
	  if lowflipon = 0 Then
		RF.Fire 'rightflipper.rotatetoend
		RF1.Fire
	  Else
		RF2.Fire
	  end If
		If rightflipper.currentangle > rightflipper.endangle - ReflipAngle Then
			RandomSoundReflipUpRight RightFlipper
		Else 
			SoundFlipperUpAttackRight RightFlipper
			RandomSoundFlipperUpRight RightFlipper
		End If
	Else
		RightFlipper.RotateToStart
		RightFlipper1.RotateToStart
		RightFlipperLower.RotateToStart
		If RightFlipper.currentangle > RightFlipper.startAngle + 5 Then
			RandomSoundFlipperDownRight RightFlipper
		End If	
		FlipperRightHitParm = FlipperUpSoundLevel
	End If
End Sub


' Flipper collide subs
Sub LeftFlipper_Collide(parm)
	CheckLiveCatch Activeball, LeftFlipper, LFCount, parm
	LeftFlipperCollide parm
End Sub

Sub RightFlipper_Collide(parm)
	CheckLiveCatch Activeball, RightFlipper, RFCount, parm
	RightFlipperCollide parm
End Sub

Sub LeftFlipper1_Collide(parm)
	CheckLiveCatch Activeball, LeftFlipper1, LFCount1, parm
	LeftFlipperCollide parm
End Sub

Sub RightFlipper1_Collide(parm)
	CheckLiveCatch Activeball, RightFlipper1, RFCount1, parm
	RightFlipperCollide parm
End Sub

Sub LeftFlipperLower_Collide(parm)
	CheckLiveCatch Activeball, LeftFlipperLower, LFCount2, parm
	LeftFlipperCollide parm
End Sub

Sub RightFlipperLower_Collide(parm)
	CheckLiveCatch Activeball, RightFlipperLower, RFCount2, parm
	RightFlipperCollide parm
End Sub


'******************************************************
'			TROUGH BASED ON FOZZY and Rothbauerw
'******************************************************

Sub BallRelease_Hit : Controller.Switch(2) = 1 : UpdateTrough : End Sub
Sub BallRelease_UnHit : Controller.Switch(2) = 0 : UpdateTrough : End Sub
Sub Slot_Hit :	Controller.Switch(1) = 1 : UpdateTrough : End Sub
Sub Slot_UnHit : Controller.Switch(1) = 0 : UpdateTrough : End Sub


Sub UpdateTrough
	UpdateTroughTimer.Interval = 300
	UpdateTroughTimer.Enabled = 1
End Sub

Sub UpdateTroughTimer_Timer
	If BallRelease.BallCntOver = 0 Then Slot.kick 60, 8
	If Slot.BallCntOver = 0 Then Drain.kick 60, 12
	Me.Enabled = 0
End Sub


'********************************************
' Drain hole and saucer kickers
'********************************************
Dim RNDKickValue1, RNDKickAngle1, RNDKickValue2, RNDKickAngle2, RNDKickAngle3 	'Random Values for saucer kick and angles

Sub SolOutholeKicker(enabled)
	If enabled Then 
		BallRelease.kick 60, 12
		RandomSoundBallRelease BallRelease
	End If
End Sub

Sub Drain_Hit()
	UpdateTrough
	RandomSoundDrain Drain
End Sub

Sub SW03_Hit
	SoundSaucerLock
	Controller.Switch(3) = 1
End Sub

Sub SolRightSaucer (Enabled)
	RNDKickAngle1 = 210
	RNDKickValue1 = RndInt(12,16)    ' Generate random value between 12 and 16. (Variance of +/- 2 from 14)
	sw03.kick RNDKickAngle1, RNDKickValue1
	If (enabled) Then
			sw03Step = 0
			sw03.timerenabled = 1
	End If
End Sub

Dim SW03Step
Sub SW03_Timer()
	Select Case SW03Step
		Case 0:	pKickerArm.Rotx = 4
		Case 2: pKickerArm.Rotx = 8
		Case 3: pKickerArm.Rotx = 8
		Case 4:	pKickerArm.Rotx = 4
		Case 5: pKickerArm.Rotx = 0:sw03.timerenabled = 0:SW03Step = -1:
	End Select
	SW03Step = SW03Step + 1
End Sub

Sub SW03_Unhit
	SoundSaucerKick 1, sw03
	controller.switch(3) = 0
End Sub

Sub SW04_Hit
	SoundSaucerLock
	Controller.Switch(4) = 1
End Sub

Sub SolTopSaucer (Enabled)
	RNDKickAngle2 = 90
	RNDKickValue2 = RndInt(14,18)    ' Generate random value between 14 and 18. (Variance of +/- 2 from 16)
	sw04.kick RNDKickAngle2, RNDKickValue2
	If (enabled) Then
			sw04Step = 0
			sw04.timerenabled = 1
	End If
End Sub

Dim SW04Step
Sub SW04_Timer()
	Select Case SW04Step
		Case 0:	pKickerArmUp.Rotx = 4
		Case 2: pKickerArmUp.Rotx = 8
		Case 3: pKickerArmUp.Rotx = 8
		Case 4:	pKickerArmUp.Rotx = 4
		Case 5: pKickerArmUp.Rotx = 0:sw04.timerenabled = 0:SW04Step = -1:
	End Select
	SW04Step = SW04Step + 1
End Sub

Sub SW04_Unhit
	SoundSaucerKick 1, sw04
	controller.switch(4) = 0
End Sub

Sub SW08_Hit
	SoundSaucerLock
	Controller.Switch(8) = 1
	lowflipon = 0
End Sub

Sub SolLowerSaucer (Enabled)

		Select Case Int(Rnd*4)+1    ' Generate random value between 1 and 4
			Case 1:  RNDKickAngle3 = -2
			Case 2:  RNDKickAngle3 = -3
			Case 3:  RNDKickAngle3 = 2
			Case 4:  RNDKickAngle3 = 3
		End Select

	sw08.kick RNDKickAngle3, 24
End Sub

Sub SW08_Unhit
	SoundSaucerKick 1, sw08
	controller.switch(8) = 0
	lowflipon = 1
End Sub


'*******************************************
' Rollovers
'*******************************************

'Main Playfield

Sub SW12_Hit   : Controller.Switch(12) = 1 : End Sub 
Sub SW12_Unhit : Controller.Switch(12) = 0 : End Sub
Sub SW13_Hit   : Controller.Switch(13) = 1 : End Sub 
Sub SW13_Unhit : Controller.Switch(13) = 0 : End Sub
Sub SW14_Hit   : Controller.Switch(14) = 1 : End Sub 
Sub SW14_Unhit : Controller.Switch(14) = 0 : End Sub

'Upper Playfield
'Star Triggers

Sub sw24_Hit:vpmTimer.PulseSw 24:me.timerenabled = 0:AnimateStar star24, sw24, 1:End Sub
Sub sw24_UnHit:me.timerinterval = 7:me.timerenabled = 1:End Sub
Sub sw24_timer:AnimateStar star24, sw24, 0:End Sub

Sub sw27a_Hit:vpmTimer.PulseSw 27:me.timerenabled = 0:AnimateStar star27a, sw27a, 1:End Sub
Sub sw27a_UnHit:me.timerinterval = 7:me.timerenabled = 1:End Sub
Sub sw27a_timer:AnimateStar star27a, sw27a, 0:End Sub

Sub sw27b_Hit:vpmTimer.PulseSw 27:me.timerenabled = 0:AnimateStar star27b, sw27b, 1:End Sub
Sub sw27b_UnHit:me.timerinterval = 7:me.timerenabled = 1:End Sub
Sub sw27b_timer:AnimateStar star27b, sw27b, 0:End Sub

Sub sw27c_Hit:vpmTimer.PulseSw 27:me.timerenabled = 0:AnimateStar star27c, sw27c, 1:End Sub
Sub sw27c_UnHit:me.timerinterval = 7:me.timerenabled = 1:End Sub
Sub sw27c_timer:AnimateStar star27c, sw27c, 0:End Sub

Sub sw28a_Hit:vpmTimer.PulseSw 28:me.timerenabled = 0:AnimateStar star28a, sw28a, 1:End Sub
Sub sw28a_UnHit:me.timerinterval = 7:me.timerenabled = 1:End Sub
Sub sw28a_timer:AnimateStar star28a, sw28a, 0:End Sub

Sub sw28b_Hit:vpmTimer.PulseSw 28:me.timerenabled = 0:AnimateStar star28b, sw28b, 1:End Sub
Sub sw28b_UnHit:me.timerinterval = 7:me.timerenabled = 1:End Sub
Sub sw28b_timer:AnimateStar star28b, sw28b, 0:End Sub

Sub sw28c_Hit:vpmTimer.PulseSw 28:me.timerenabled = 0:AnimateStar star28c, sw28c, 1:End Sub
Sub sw28c_UnHit:me.timerinterval = 7:me.timerenabled = 1:End Sub
Sub sw28c_timer:AnimateStar star28c, sw28c, 0:End Sub

Sub sw38a_Hit:vpmTimer.PulseSw 38:me.timerenabled = 0:AnimateStar star38a, sw38a, 1:End Sub
Sub sw38a_UnHit:me.timerinterval = 7:me.timerenabled = 1:End Sub
Sub sw38a_timer:AnimateStar star38a, sw38a, 0:End Sub

Sub sw38b_Hit:vpmTimer.PulseSw 38:me.timerenabled = 0:AnimateStar star38b, sw38b, 1:End Sub
Sub sw38b_UnHit:me.timerinterval = 7:me.timerenabled = 1:End Sub
Sub sw38b_timer:AnimateStar star38b, sw38b, 0:End Sub


Sub AnimateStar(prim, sw, action) ' Action = 1 - to drop, 0 to raise
	If action = 1 Then
		prim.transz = -4
	Else
		prim.transz = prim.transz + 0.5
		if prim.transz = -2 and Rnd() < 0.05 Then
			sw.timerenabled = 0
		Elseif prim.transz >= 0 Then
			prim.transz = 0
			sw.timerenabled = 0
		End If
	End If
End Sub


'Mini Playfield
'Star Triggers

Sub sw25l_Hit:vpmTimer.PulseSw 25:me.timerenabled = 0:AnimateStar star25l, sw25l, 1:End Sub
Sub sw25l_UnHit:me.timerinterval = 7:me.timerenabled = 1:End Sub
Sub sw25l_timer:AnimateStar star25l, sw25l, 0:End Sub

Sub sw26l_Hit:vpmTimer.PulseSw 26:me.timerenabled = 0:AnimateStar star26l, sw26l, 1:End Sub
Sub sw26l_UnHit:me.timerinterval = 7:me.timerenabled = 1:End Sub
Sub sw26l_timer:AnimateStar star26l, sw26l, 0:End Sub


'*******************************************
' Spinners
'*******************************************

Sub Spinner2_Spin()
	vpmtimer.PulseSw 25
	SoundSpinner Spinner2
End Sub

Sub Spinner1_Spin()
	vpmtimer.PulseSw 25
	SoundSpinner Spinner1
End Sub


'***********Rotate Spinner

Sub SpinnerTimer
	SpinnerPrim1.Rotx = Spinner1.CurrentAngle
	SpinnerRod1.TransX = sin( (Spinner1.CurrentAngle+180) * (2*PI/360)) * 12
	SpinnerRod1.TransZ = sin( (Spinner1.CurrentAngle- 90) * (2*PI/360)) * 3.5
	SpinnerPrim2.Rotx = Spinner2.CurrentAngle
	SpinnerRod2.TransX = sin( (Spinner2.CurrentAngle+180) * (2*PI/360)) * 12
	SpinnerRod2.TransZ = sin( (Spinner2.CurrentAngle- 90) * (2*PI/360)) * 3.5
End Sub


'********************************************
'  Targets
'********************************************

'*******************************************
' Round Targets
'*******************************************

'Stand Up Targets Main Playfield
Sub sw29_Hit
	STHit 29
End Sub

Sub sw29o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw30_Hit
	STHit 30
End Sub

Sub sw30o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw31_Hit
	STHit 31
End Sub

Sub sw31o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw32_Hit
	STHit 32
End Sub

Sub sw32o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw33_Hit
	STHit 33
End Sub

Sub sw33o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw34_Hit
	STHit 34
End Sub

Sub sw34o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw35_Hit
	STHit 35
End Sub

Sub sw35o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw36_Hit
	STHit 36
End Sub

Sub sw36o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw37_Hit
	STHit 37
End Sub

Sub sw37o_Hit
	TargetBouncer Activeball, 1
End Sub



'Stand up Targets Upper Playfield

Sub sw20_Hit
	STHit 20
End Sub

Sub sw20o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw21_Hit
	STHit 21
End Sub

Sub sw21o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw22_Hit
	STHit 22
End Sub

Sub sw22o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw23_Hit
	STHit 23
End Sub

Sub sw23o_Hit
	TargetBouncer Activeball, 1
End Sub


'Stand Up Targets Under Playfield

Sub sw07_Hit
	STHit 07
End Sub

Sub sw07o_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw21L_Hit
	STHit 211
End Sub

Sub sw21Lo_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw22L_Hit
	STHit 221
End Sub

Sub sw22Lo_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw23L_Hit
	STHit 231
End Sub

Sub sw23Lo_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw29L_Hit
	STHit 291
End Sub

Sub sw29Lo_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw30L_Hit
	STHit 301
End Sub

Sub sw30Lo_Hit
	TargetBouncer Activeball, 1
End Sub

Sub sw31L_Hit
	STHit 311
End Sub

Sub sw31Lo_Hit
	TargetBouncer Activeball, 1
End Sub


'********************************************
' Drop Target Hits
'********************************************

'Drop Targets

Sub sw18_Hit
	DTHit 18
End Sub

Sub sw19_Hit
	DTHit 19
End Sub


'********************************************
' Drop Target Solenoid Controls
'********************************************

Sub SolDTDropUp (enabled)
	if enabled then
		RandomSoundDropTargetReset sw18p
		DTRaise 18
		DTRaise 19
	end if
End Sub


'********************************************
' Upper playfield sling / sensor 
'********************************************

'*******************************************
' Leaf Standups
'*******************************************
Sub RubberBandsw32a_Hit():vpmtimer.pulsesw 32:End Sub
Sub RubberBandsw32b_Hit():vpmtimer.pulsesw 32:End Sub


'*******************************************
'  Knocker
'*******************************************

Sub SolKnocker(Enabled)
	If enabled Then
		KnockerSolenoid
	End If
End Sub

'*******************************************
'  Plunger Diverter Gate
'*******************************************

Sub SolGateDiverter(enabled)
	if enabled Then
		OutGate.rotatetostart
	Else
		OutGate.rotatetoend
	End If
End Sub

'*******************************************
'  Block Reflections over middle glass / under PF; and shadows in plunger lane
'*******************************************

sub MiniPFBallReflectionMask_Hit() : activeball.ReflectionEnabled=false : table1.ballreflection = 0 : end Sub
sub MiniPFBallReflectionMask_UnHit() : activeball.ReflectionEnabled=true: table1.ballreflection = 1 : end Sub


dim notrtlane: notrtlane = 1
sub rtlanesense_Hit() : notrtlane = 0 : end Sub
sub rtlanesense_UnHit() : notrtlane = 1 : end Sub

'*******************************************
' Sling Shot Animations
' Rstep and Lstep  are the variables that increment the animation
'*******************************************
Dim RStep, Lstep

Sub RightSlingShot_Slingshot
	RS.VelocityCorrect(ActiveBall)
	vpmTimer.PulseSw 40
	RandomSoundSlingshotRight SLING1
    RSling.Visible = 0
    RSling1.Visible = 1
    sling1.rotx = 12
    RStep = 0
    RightSlingShot.TimerEnabled = 1
End Sub

Sub RightSlingShot_Timer
    Select Case RStep
        Case 3:RSLing1.Visible = 0:RSLing2.Visible = 1:sling1.rotx = 10
        Case 4:RSLing2.Visible = 0:RSLing.Visible = 1:sling1.rotx = 0:RightSlingShot.TimerEnabled = 0
    End Select
    RStep = RStep + 1
End Sub

Sub LeftSlingShot_Slingshot
	LS.VelocityCorrect(ActiveBall)
	vpmTimer.PulseSw 39
	RandomSoundSlingshotLeft SLING2
    LSling.Visible = 0
    LSling1.Visible = 1
    sling2.rotx = 12
    LStep = 0
    LeftSlingShot.TimerEnabled = 1
End Sub

Sub LeftSlingShot_Timer
    Select Case LStep
        Case 3:LSLing1.Visible = 0:LSLing2.Visible = 1:sling2.rotx = 10
        Case 4:LSLing2.Visible = 0:LSLing.Visible = 1:sling2.rotx = 0:LeftSlingShot.TimerEnabled = 0
    End Select
    LStep = LStep + 1
End Sub


'**********************************************************************************************************
'**********************************************************************************************************
'Bally Elektra
'added by Inkochnito
Sub editDips
  if SetDIPSwitches = 1 Then
	Dim vpmDips : Set vpmDips = New cvpmDips
	With vpmDips
		.AddForm 700,400,"Elektra - DIP switches"
		.AddChk 7,10,180,Array("Match feature", &H08000000)'dip 28
		.AddChk 205,10,115,Array("Credits display", &H04000000)'dip 27
		.AddFrame 2,30,190,"Maximum credits",&H03000000,Array("10 credits",0,"15 credits", &H01000000,"25 credits", &H02000000,"40 credits", &H03000000)'dip 25&26
		.AddFrame 2,106,190,"4-5-6 arrow",&H00000020,Array("not in memory",0,"in memory",&H00000020)'dip 6
		.AddFrame 2,152,190,"Left blue targets",&H00000040,Array("not in memory",0,"in memory",&H00000040)'dip 7
		.AddFrame 2,198,190,"Blue lights feature",&H00000080,Array("conservative 1-2-3-4-5",0,"liberal 1-3-5",&H00000080)'dip 8
		.AddFrame 2,248,190,"Minimum time needed",&H00002000,Array("10 Elektra-units",0,"6 Elektra-units",&H00002000)'dip 14
		.AddFrame 2,298,190,"Kicker during timeplay",&H00004000,Array("ball stays in kicker",0,"ball kicked out",&H00004000)'dip 15
		.AddFrame 2,348,190,"No more Elektra-units",32768,Array("game ends",0,"game goes on",32768)'dip 16
		.AddFrame 205,30,190,"Balls per game",&HC0000000,Array ("2 balls",&HC0000000,"3 balls",0,"4 balls",&H80000000,"5 balls",&H40000000)'dip 31&32
		.AddFrame 205,106,190,"Frequency",&H00100000,Array("50Hz",0,"60Hz",&H00100000)'dip 21
		.AddFrame 205,152,190,"Center red targets",&H00200000,Array("not in memory",0,"in memory",&H00200000)'dip 22
		.AddFrame 205,198,190,"Top special feature",&H00400000,Array("conservative",0,"liberal",&H00400000)'dip 23
		.AddFrame 205,248,190,"Special memory",&H00800000,Array("Off",0,"On",&H00800000)'dip 24
		.AddFrame 205,298,190,"Replay limit",&H10000000,Array("no limit",0,"1 replay per game",&H10000000)'dip 29
		.AddFrame 205,348,190,"Attract sound",&H20000000,Array("off",0,"on",&H20000000)'dip 30
		.AddLabel 50,400,300,20,"Set selftest position 18 and 19 to 03 for the best gameplay."
		.AddLabel 50,420,300,20,"After hitting OK, press F3 to reset game with new settings."
		.ViewDips
	End With
  End If
End Sub
Set vpmShowDips = GetRef("editDips")


Sub SetDefaultDips

	SetDip &H08000000,1		'Match feature
	SetDip &H04000000,1		'Credits display
	SetDip &H00000020,0		'4-5-6 arrow:  0 = not in memory, 1 = in memory
	SetDip &H00000040,0		'Left blue targets:  0 = not in memory, 1 = in memory 
	SetDip &H00000080,1		'Blue lights feature:  0 = conservative 1-2-3-4-5,  1 = liberal 1-3-5
	SetDip &H00002000,0		'Minimum time needed:  0 = 10 Elektra-units, 1 = 6 Elektra-units
	SetDip &H00004000,1		'Kicker during timeplay: 0 = Ball stays in kicker, 1 = Ball kicks out
	SetDip 32768,1			'No More Elektra Units: 0 = game ends, 1 = games goes on
	SetDip &HC0000000,0		'Balls per game: 0 = 2 balls, 1 = 3 balls
	SetDip &H80000000,0		'Balls per game: 1 = 4 balls - NOTE: prior dip will need to be at zero
	SetDip &H40000000,0		'Balls per game: 1 = 5 balls - NOTE: prior dip will need to be at zero
	SetDip &H00100000,1		'Frequency: 0 = 50Hz, 1= 60Hz
	SetDip &H00200000,0		'Center red targets:  0 = not in memory, 1 = in memory
	SetDip &H00400000,1		'Top special features:  0 = not in memory, 1 = in memory
	SetDip &H00800000,0		'Special Memory:  0 = Off,  1 = on
	SetDip &H10000000,0		'Replay Limit:  0 = no limit,  1 = 1 replay per game
	SetDip &H20000000,0		'Attract Sound:  0 = Off, 1 = on

End Sub

Sub SetDip(pos,value)
	dim mask : mask = 255
	if value >= 0.5 then value = 1 else value = 0
	If pos >= 0 and pos <= 255 Then
		pos = pos And &H000000FF
		mask = mask And (Not pos)
		Controller.Dip(0) = Controller.Dip(0) And mask
		Controller.Dip(0) = Controller.Dip(0) + pos*value
	Elseif pos >= 256 and pos <= 65535 Then
		pos = ((pos And &H0000FF00)\&H00000100) And 255
		mask = mask And (Not pos)
		Controller.Dip(1) = Controller.Dip(1) And mask
		Controller.Dip(1) = Controller.Dip(1) + pos*value		
	Elseif pos >= 65536 and pos <= 16777215 Then
		pos = ((pos And &H00FF0000)\&H00010000) And 255
		mask = mask And (Not pos)
		Controller.Dip(2) = Controller.Dip(2) And mask
		Controller.Dip(2) = Controller.Dip(2) + pos*value
	Elseif pos >= 16777216 Then
		pos = ((pos And &HFF000000)\&H01000000) And 255
		mask = mask And (Not pos)
		Controller.Dip(3) = Controller.Dip(3) And mask
		Controller.Dip(3) = Controller.Dip(3) + pos*value
	End If
End Sub





'***************************************************************
'****  VPW DYNAMIC BALL SHADOWS by Iakki, Apophis, and Wylte
'***************************************************************

' *** Required Functions, enable these if they are not already present elswhere in your table
Function max(a,b)
	if a > b then 
		max = a
	Else
		max = b
	end if
end Function


' *** Trim or extend these to match the number of balls/primitives/flashers on the table!  (will throw errors if there aren't enough objects)
dim objrtx1(4), objrtx2(4)
dim objBallShadow(4)
Dim OnPF(4)
Dim BallShadowA
BallShadowA = Array (BallShadowA0,BallShadowA1,BallShadowA2,BallShadowA3)
Dim DSSources(30), numberofsources

' *** The Shadow Dictionary
Dim bsDict
Set bsDict = New cvpmDictionary
Const bsNone = "None"
Const bsWire = "Wire"
Const bsRamp = "Ramp"
Const bsRampClear = "Clear"

'Initialization
DynamicBSInit

sub DynamicBSInit()
	Dim iii, source

	for iii = 0 to tnob - 1								'Prepares the shadow objects before play begins
		Set objrtx1(iii) = Eval("RtxBallShadow" & iii)
		objrtx1(iii).material = "RtxBallShadow" & iii
		objrtx1(iii).z = 1 + iii/1000 + 0.01			'Separate z for layering without clipping
		objrtx1(iii).visible = 0

		Set objrtx2(iii) = Eval("RtxBall2Shadow" & iii)
		objrtx2(iii).material = "RtxBallShadow2_" & iii
		objrtx2(iii).z = 1 + iii/1000 + 0.02
		objrtx2(iii).visible = 0

		Set objBallShadow(iii) = Eval("BallShadow" & iii)
		objBallShadow(iii).material = "BallShadow" & iii
		UpdateMaterial objBallShadow(iii).material,1,0,0,0,0,0,AmbientBSFactor,RGB(0,0,0),0,0,False,True,0,0,0,0
		objBallShadow(iii).Z = 1 + iii/1000 + 0.04
		objBallShadow(iii).visible = 0

		BallShadowA(iii).Opacity = 100*AmbientBSFactor
		BallShadowA(iii).visible = 0
	Next

	iii = 0

	For Each Source in DynamicSources
		DSSources(iii) = Array(Source.x, Source.y)
'		If Instr(Source.name , "Left") > 0 Then DSGISide(iii) = 0 Else DSGISide(iii) = 1	'Adapted for TZ with GI left / GI right
		iii = iii + 1
	Next
	numberofsources = iii
end sub

Sub BallOnPlayfieldNow(yeh, num)		'Only update certain things once, save some cycles
	If yeh Then
		OnPF(num) = True
		bsRampOff gBOT(num).ID
'		debug.print "Back on PF"
		UpdateMaterial objBallShadow(num).material,1,0,0,0,0,0,AmbientBSFactor,RGB(0,0,0),0,0,False,True,0,0,0,0
		objBallShadow(num).size_x = 5
		objBallShadow(num).size_y = 4.5
		objBallShadow(num).visible = 1
		BallShadowA(num).visible = 0
		BallShadowA(num).Opacity = 100 * AmbientBSFactor
	Else
		OnPF(num) = False
'		debug.print "Leaving PF"
	End If
End Sub

Sub DynamicBSUpdate
	Dim falloff: falloff = 150 'Max distance to light sources, can be changed dynamically if you have a reason
	Dim ShadowOpacity1, ShadowOpacity2 
	Dim s, LSd, iii
	Dim dist1, dist2, src1, src2
	Dim bsRampType

	'Hide shadow of deleted balls
	For s = UBound(gBOT) + 1 to tnob - 1
		objrtx1(s).visible = 0
		objrtx2(s).visible = 0
		objBallShadow(s).visible = 0
		BallShadowA(s).visible = 0
	Next

	If UBound(gBOT) < lob Then Exit Sub		'No balls in play, exit

'The Magic happens now
	For s = lob to UBound(gBOT)

' *** Normal "ambient light" ball shadow
	'Layered from top to bottom. If you had an upper pf at for example 80 units and ramps even above that, your Elseif segments would be z>110; z<=110 And z>100; z<=100 And z>30; z<=30 And z>20; Else (under 20)

	'Primitive shadow on playfield, flasher shadow in ramps
		If AmbientBallShadowOn = 1 Then

		'** Above the playfield
			If gBOT(s).Z > 30 And gBOT(s).Z < 85 Then							'The flasher follows the ball up ramps while the primitive is on the pf
				If OnPF(s) Then BallOnPlayfieldNow False, s		'One-time update
				bsRampType = getBsRampType(gBOT(s).id)
'				debug.print bsRampType

				If Not bsRampType = bsRamp Then		'Primitive visible on PF
					objBallShadow(s).visible = 1
					objBallShadow(s).X = gBOT(s).X + (gBOT(s).X - (tablewidth/2))/(Ballsize/AmbientMovement) + offsetX
					objBallShadow(s).Y = gBOT(s).Y + offsetY
					objBallShadow(s).size_x = 5 * ((gBOT(s).Z+BallSize)/80)		'Shadow gets larger and more diffuse as it moves up
					objBallShadow(s).size_y = 4.5 * ((gBOT(s).Z+BallSize)/80)
					UpdateMaterial objBallShadow(s).material,1,0,0,0,0,0,AmbientBSFactor*(30/(gBOT(s).Z)),RGB(0,0,0),0,0,False,True,0,0,0,0
				Else								'Opaque, no primitive below
					objBallShadow(s).visible = 0
				End If

				If bsRampType = bsRampClear Or bsRampType = bsRamp Then		'Flasher visible on opaque ramp
					BallShadowA(s).visible = 1
					BallShadowA(s).X = gBOT(s).X + offsetX
					BallShadowA(s).Y = gBOT(s).Y + offsetY + BallSize/10
					BallShadowA(s).height=gBOT(s).z - BallSize/4 + s/1000		'This is technically 1/4 of the ball "above" the ramp, but it keeps it from clipping the ramp
					If bsRampType = bsRampClear Then BallShadowA(s).Opacity = 50 * AmbientBSFactor
				Elseif bsRampType = bsWire or bsRampType = bsNone Then		'Turn it off on wires or falling out of a ramp
					BallShadowA(s).visible = 0
				End If

		'** On pf, primitive only
			Elseif (gBOT(s).Z > 0 AND gBOT(s).Z <= 30) OR gBOT(s).Z > 85 Then
				If Not OnPF(s) Then BallOnPlayfieldNow True, s
				objBallShadow(s).X = gBOT(s).X + (gBOT(s).X - (tablewidth/2))/(Ballsize/AmbientMovement) + offsetX
				objBallShadow(s).Y = gBOT(s).Y + offsetY
'				objBallShadow(s).Z = gBOT(s).Z + s/1000 + 0.04		'Uncomment (and adjust If/Elseif height logic) if you want the primitive shadow on an upper/split pf																																						 

		'** Under pf, flasher shadow only
			Else
				If OnPF(s) Then BallOnPlayfieldNow False, s
				objBallShadow(s).visible = 0
				BallShadowA(s).visible = 1
				BallShadowA(s).X = gBOT(s).X + offsetX
				BallShadowA(s).Y = gBOT(s).Y + offsetY
				BallShadowA(s).height=gBOT(s).z - BallSize/4 + s/1000
			end if


	'Flasher shadow everywhere
		Elseif AmbientBallShadowOn = 2 Then
			If gBOT(s).Z > 30 And gBOT(s).Z < 85 Then				'In a ramp
				BallShadowA(s).X = gBOT(s).X + offsetX
				BallShadowA(s).Y = gBOT(s).Y + offsetY + BallSize/10
				BallShadowA(s).height=gBOT(s).z - BallSize/4 + s/1000		'This is technically 1/4 of the ball "above" the ramp, but it keeps it from clipping the ramp
			Elseif (gBOT(s).Z > 0 AND gBOT(s).Z <= 30) OR gBOT(s).Z > 85 Then	'On pf
				BallShadowA(s).visible = 1
				BallShadowA(s).X = gBOT(s).X + (gBOT(s).X - (tablewidth/2))/(Ballsize/AmbientMovement) + offsetX
				BallShadowA(s).Y = gBOT(s).Y + offsetY
				BallShadowA(s).height= 1.04 + s/1000
			Else											'Under pf
				BallShadowA(s).X = gBOT(s).X + offsetX
				BallShadowA(s).Y = gBOT(s).Y + offsetY
				BallShadowA(s).height=gBOT(s).z - BallSize/4 + s/1000
			End If

		End If

' *** Dynamic shadows
		If DynamicBallShadowsOn Then
			If ((gBOT(s).Z > 0 AND gBOT(s).Z <= 30) Or gBOT(s).Z > 85) And gBOT(s).X < 860 AND notrtlane = 1 Then	'Parameters for where the shadows can show, here they are not visible above the table (no upper pf) or in the plunger lane
				dist1 = falloff:
				dist2 = falloff
				For iii = 0 to numberofsources - 1 ' Search the 2 nearest influencing lights
					LSd = Distance(gBOT(s).x, gBOT(s).y, DSSources(iii)(0), DSSources(iii)(1)) 'Calculating the Linear distance to the Source
					If LSd < falloff And gilvl > 0 Then
'					If LSd < dist2 And ((DSGISide(iii) = 0 And Lampz.State(100)>0) Or (DSGISide(iii) = 1 And Lampz.State(104)>0)) Then	'Adapted for TZ with GI left / GI right
						dist2 = dist1
						dist1 = LSd
						src2 = src1
						src1 = iii
					End If
				Next
				ShadowOpacity1 = 0
				If dist1 < falloff Then
					objrtx1(s).visible = 1 : objrtx1(s).X = gBOT(s).X : objrtx1(s).Y = gBOT(s).Y
					objrtx1(s).Z = gBOT(s).Z - 25 + s/1000 + 0.01 'Uncomment if you want to add shadows to an upper/lower pf
					objrtx1(s).rotz = AnglePP(DSSources(src1)(0), DSSources(src1)(1), gBOT(s).X, gBOT(s).Y) + 90
					ShadowOpacity1 = 1 - dist1 / falloff
					objrtx1(s).size_y = Wideness * ShadowOpacity1 + Thinness
					UpdateMaterial objrtx1(s).material,1,0,0,0,0,0,ShadowOpacity1*DynamicBSFactor^3,RGB(0,0,0),0,0,False,True,0,0,0,0
				Else
					objrtx1(s).visible = 0
				End If
				ShadowOpacity2 = 0
				If dist2 < falloff Then
					objrtx2(s).visible = 1 : objrtx2(s).X = gBOT(s).X : objrtx2(s).Y = gBOT(s).Y + offsetY
					'objrtx2(s).Z = gBOT(s).Z - 25 + s/1000 + 0.02 'Uncomment if you want to add shadows to an upper/lower pf
					objrtx2(s).rotz = AnglePP(DSSources(src2)(0), DSSources(src2)(1), gBOT(s).X, gBOT(s).Y) + 90
					ShadowOpacity2 = 1 - dist2 / falloff
					objrtx2(s).size_y = Wideness * ShadowOpacity2 + Thinness
					UpdateMaterial objrtx2(s).material,1,0,0,0,0,0,ShadowOpacity2*DynamicBSFactor^3,RGB(0,0,0),0,0,False,True,0,0,0,0
				Else
					objrtx2(s).visible = 0
				End If
				If AmbientBallShadowOn = 1 Then
					'Fades the ambient shadow (primitive only) when it's close to a light
					UpdateMaterial objBallShadow(s).material,1,0,0,0,0,0,AmbientBSFactor*(1 - max(ShadowOpacity1, ShadowOpacity2)),RGB(0,0,0),0,0,False,True,0,0,0,0
				Else
					BallShadowA(s).Opacity = 100 * AmbientBSFactor * (1 - max(ShadowOpacity1, ShadowOpacity2))
				End If
			Else 'Hide dynamic shadows everywhere else, just in case
				objrtx2(s).visible = 0 : objrtx1(s).visible = 0
			End If
		End If
	Next
End Sub

' *** Ramp type definitions

Sub bsRampOnWire()
	If bsDict.Exists(ActiveBall.ID) Then 
		bsDict.Item(ActiveBall.ID) = bsWire
	Else
		bsDict.Add ActiveBall.ID, bsWire
	End If
End Sub

Sub bsRampOn()
	If bsDict.Exists(ActiveBall.ID) Then 
		bsDict.Item(ActiveBall.ID) = bsRamp
	Else
		bsDict.Add ActiveBall.ID, bsRamp
	End If
End Sub

Sub bsRampOnClear()
	If bsDict.Exists(ActiveBall.ID) Then 
		bsDict.Item(ActiveBall.ID) = bsRampClear
	Else
		bsDict.Add ActiveBall.ID, bsRampClear
	End If
End Sub

Sub bsRampOff(idx)
	If bsDict.Exists(idx) Then 
		bsDict.Item(idx) = bsNone
	End If
End Sub

Function getBsRampType(id)
	Dim retValue
	If bsDict.Exists(id) Then
		retValue = bsDict.Item(id)
	Else
		retValue = bsNone
	End If
	getBsRampType = retValue
End Function

'****************************************************************
'****  END VPW DYNAMIC BALL SHADOWS by Iakki, Apophis, and Wylte
'****************************************************************

'******************************************************
' VPW TargetBouncer for targets and posts by Iaakki, Wrd1972, Apophis
'******************************************************


sub TargetBouncer(aBall,defvalue)
    dim zMultiplier, vel, vratio
    if TargetBouncerEnabled = 1 and aball.z < 30 then
        'debug.print "velx: " & aball.velx & " vely: " & aball.vely & " velz: " & aball.velz
        vel = BallSpeed(aBall)
        if aBall.velx = 0 then vratio = 1 else vratio = aBall.vely/aBall.velx
        Select Case Int(Rnd * 6) + 1
            Case 1: zMultiplier = 0.2*defvalue
			Case 2: zMultiplier = 0.25*defvalue
            Case 3: zMultiplier = 0.3*defvalue
			Case 4: zMultiplier = 0.4*defvalue
            Case 5: zMultiplier = 0.45*defvalue
            Case 6: zMultiplier = 0.5*defvalue
        End Select
        aBall.velz = abs(vel * zMultiplier * TargetBouncerFactor)
        aBall.velx = sgn(aBall.velx) * sqr(abs((vel^2 - aBall.velz^2)/(1+vratio^2)))
        aBall.vely = aBall.velx * vratio
        'debug.print "---> velx: " & aball.velx & " vely: " & aball.vely & " velz: " & aball.velz
        'debug.print "conservation check: " & BallSpeed(aBall)/vel
	end if
end sub

' Add targets or posts to the TargetBounce collection if you want to activate the targetbouncer code from them
Sub TargetBounce_Hit(idx)
	TargetBouncer activeball, 1
End Sub


'******************************************************
'****  FLIPPER CORRECTIONS by nFozzy
'******************************************************


'******************************************************
' Flippers Polarity (Select appropriate sub based on era) 
'******************************************************

dim LF : Set LF = New FlipperPolarity
dim RF : Set RF = New FlipperPolarity
dim LF1 : Set LF1 = New FlipperPolarity
dim RF1 : Set RF1 = New FlipperPolarity
dim LF2 : Set LF2 = New FlipperPolarity
dim RF2 : Set RF2 = New FlipperPolarity

InitPolarity

'
''*******************************************
'' Late 70's to early 80's
'
Sub InitPolarity()
        dim x, a : a = Array(LF, RF, LF1, RF1, LF2, RF2)
        for each x in a
                x.AddPoint "Ycoef", 0, RightFlipper.Y-65, 1        'disabled
                x.AddPoint "Ycoef", 1, RightFlipper.Y-11, 1
                x.enabled = True
                x.TimeDelay = 80
        Next

        AddPt "Polarity", 0, 0, 0
        AddPt "Polarity", 1, 0.05, -2.7        
        AddPt "Polarity", 2, 0.33, -2.7
        AddPt "Polarity", 3, 0.37, -2.7        
        AddPt "Polarity", 4, 0.41, -2.7
        AddPt "Polarity", 5, 0.45, -2.7
        AddPt "Polarity", 6, 0.576,-2.7
        AddPt "Polarity", 7, 0.66, -1.8
        AddPt "Polarity", 8, 0.743, -0.5
        AddPt "Polarity", 9, 0.81, -0.5
        AddPt "Polarity", 10, 0.88, 0

        addpt "Velocity", 0, 0,         1
        addpt "Velocity", 1, 0.16, 1.06
        addpt "Velocity", 2, 0.41,         1.05
        addpt "Velocity", 3, 0.53,         1'0.982
        addpt "Velocity", 4, 0.702, 0.968
        addpt "Velocity", 5, 0.95,  0.968
        addpt "Velocity", 6, 1.03,         0.945

        LF.Object = LeftFlipper        
        LF.EndPoint = EndPointLp
        RF.Object = RightFlipper
        RF.EndPoint = EndPointRp
        LF1.Object = LeftFlipper1        
        LF1.EndPoint = EndPointLp1
        RF1.Object = RightFlipper1
        RF1.EndPoint = EndPointRp1
        LF2.Object = LeftFlipperLower       
        LF2.EndPoint = EndPointLp2
        RF2.Object = RightFlipperLower
        RF2.EndPoint = EndPointRp2

End Sub



' Flipper trigger hit subs
Sub TriggerLF_Hit() : LF.Addball activeball : End Sub
Sub TriggerLF_UnHit() : LF.PolarityCorrect activeball : End Sub
Sub TriggerRF_Hit() : RF.Addball activeball : End Sub
Sub TriggerRF_UnHit() : RF.PolarityCorrect activeball : End Sub
Sub TriggerLF1_Hit() : LF1.Addball activeball : End Sub
Sub TriggerLF1_UnHit() : LF1.PolarityCorrect activeball : End Sub
Sub TriggerRF1_Hit() : RF1.Addball activeball : End Sub
Sub TriggerRF1_UnHit() : RF1.PolarityCorrect activeball : End Sub
Sub TriggerLF2_Hit() : LF2.Addball activeball : End Sub
Sub TriggerLF2_UnHit() : LF2.PolarityCorrect activeball : End Sub
Sub TriggerRF2_Hit() : RF2.Addball activeball : End Sub
Sub TriggerRF2_UnHit() : RF2.PolarityCorrect activeball : End Sub



'******************************************************
'  FLIPPER CORRECTION FUNCTIONS
'******************************************************

Class FlipperPolarity
	Public DebugOn, Enabled
	Private FlipAt        'Timer variable (IE 'flip at 723,530ms...)
	Public TimeDelay        'delay before trigger turns off and polarity is disabled TODO set time!
	private Flipper, FlipperStart,FlipperEnd, FlipperEndY, LR, PartialFlipCoef
	Private Balls(20), balldata(20)

	dim PolarityIn, PolarityOut
	dim VelocityIn, VelocityOut
	dim YcoefIn, YcoefOut
	Public Sub Class_Initialize 
		redim PolarityIn(0) : redim PolarityOut(0) : redim VelocityIn(0) : redim VelocityOut(0) : redim YcoefIn(0) : redim YcoefOut(0)
		Enabled = True : TimeDelay = 50 : LR = 1:  dim x : for x = 0 to uBound(balls) : balls(x) = Empty : set Balldata(x) = new SpoofBall : next 
	End Sub

	Public Property let Object(aInput) : Set Flipper = aInput : StartPoint = Flipper.x : End Property
	Public Property Let StartPoint(aInput) : if IsObject(aInput) then FlipperStart = aInput.x else FlipperStart = aInput : end if : End Property
	Public Property Get StartPoint : StartPoint = FlipperStart : End Property
	Public Property Let EndPoint(aInput) : FlipperEnd = aInput.x: FlipperEndY = aInput.y: End Property
	Public Property Get EndPoint : EndPoint = FlipperEnd : End Property        
	Public Property Get EndPointY: EndPointY = FlipperEndY : End Property

	Public Sub AddPoint(aChooseArray, aIDX, aX, aY) 'Index #, X position, (in) y Position (out) 
		Select Case aChooseArray
			case "Polarity" : ShuffleArrays PolarityIn, PolarityOut, 1 : PolarityIn(aIDX) = aX : PolarityOut(aIDX) = aY : ShuffleArrays PolarityIn, PolarityOut, 0
			Case "Velocity" : ShuffleArrays VelocityIn, VelocityOut, 1 :VelocityIn(aIDX) = aX : VelocityOut(aIDX) = aY : ShuffleArrays VelocityIn, VelocityOut, 0
			Case "Ycoef" : ShuffleArrays YcoefIn, YcoefOut, 1 :YcoefIn(aIDX) = aX : YcoefOut(aIDX) = aY : ShuffleArrays YcoefIn, YcoefOut, 0
		End Select
		if gametime > 100 then Report aChooseArray
	End Sub 

	Public Sub Report(aChooseArray)         'debug, reports all coords in tbPL.text
		if not DebugOn then exit sub
		dim a1, a2 : Select Case aChooseArray
			case "Polarity" : a1 = PolarityIn : a2 = PolarityOut
			Case "Velocity" : a1 = VelocityIn : a2 = VelocityOut
			Case "Ycoef" : a1 = YcoefIn : a2 = YcoefOut 
				case else :tbpl.text = "wrong string" : exit sub
		End Select
		dim str, x : for x = 0 to uBound(a1) : str = str & aChooseArray & " x: " & round(a1(x),4) & ", " & round(a2(x),4) & vbnewline : next
		tbpl.text = str
	End Sub

	Public Sub AddBall(aBall) : dim x : for x = 0 to uBound(balls) : if IsEmpty(balls(x)) then set balls(x) = aBall : exit sub :end if : Next  : End Sub

	Private Sub RemoveBall(aBall)
		dim x : for x = 0 to uBound(balls)
			if TypeName(balls(x) ) = "IBall" then 
				if aBall.ID = Balls(x).ID Then
					balls(x) = Empty
					Balldata(x).Reset
				End If
			End If
		Next
	End Sub

	Public Sub Fire() 
		Flipper.RotateToEnd
		processballs
	End Sub

	Public Property Get Pos 'returns % position a ball. For debug stuff.
		dim x : for x = 0 to uBound(balls)
			if not IsEmpty(balls(x) ) then
				pos = pSlope(Balls(x).x, FlipperStart, 0, FlipperEnd, 1)
			End If
		Next                
	End Property

	Public Sub ProcessBalls() 'save data of balls in flipper range
		FlipAt = GameTime
		dim x : for x = 0 to uBound(balls)
			if not IsEmpty(balls(x) ) then
				balldata(x).Data = balls(x)
			End If
		Next
		PartialFlipCoef = ((Flipper.StartAngle - Flipper.CurrentAngle) / (Flipper.StartAngle - Flipper.EndAngle))
		PartialFlipCoef = abs(PartialFlipCoef-1)
	End Sub
	Private Function FlipperOn() : if gameTime < FlipAt+TimeDelay then FlipperOn = True : End If : End Function        'Timer shutoff for polaritycorrect

	Public Sub PolarityCorrect(aBall)
		if FlipperOn() then 
			dim tmp, BallPos, x, IDX, Ycoef : Ycoef = 1

			'y safety Exit
			if aBall.VelY > -8 then 'ball going down
				RemoveBall aBall
				exit Sub
			end if

			'Find balldata. BallPos = % on Flipper
			for x = 0 to uBound(Balls)
				if aBall.id = BallData(x).id AND not isempty(BallData(x).id) then 
					idx = x
					BallPos = PSlope(BallData(x).x, FlipperStart, 0, FlipperEnd, 1)
					if ballpos > 0.65 then  Ycoef = LinearEnvelope(BallData(x).Y, YcoefIn, YcoefOut)                                'find safety coefficient 'ycoef' data
				end if
			Next

			If BallPos = 0 Then 'no ball data meaning the ball is entering and exiting pretty close to the same position, use current values.
				BallPos = PSlope(aBall.x, FlipperStart, 0, FlipperEnd, 1)
				if ballpos > 0.65 then  Ycoef = LinearEnvelope(aBall.Y, YcoefIn, YcoefOut)                                                'find safety coefficient 'ycoef' data
			End If

			'Velocity correction
			if not IsEmpty(VelocityIn(0) ) then
				Dim VelCoef
				VelCoef = LinearEnvelope(BallPos, VelocityIn, VelocityOut)

				if partialflipcoef < 1 then VelCoef = PSlope(partialflipcoef, 0, 1, 1, VelCoef)

				if Enabled then aBall.Velx = aBall.Velx*VelCoef
				if Enabled then aBall.Vely = aBall.Vely*VelCoef
			End If

			'Polarity Correction (optional now)
			if not IsEmpty(PolarityIn(0) ) then
				If StartPoint > EndPoint then LR = -1        'Reverse polarity if left flipper
				dim AddX : AddX = LinearEnvelope(BallPos, PolarityIn, PolarityOut) * LR

				if Enabled then aBall.VelX = aBall.VelX + 1 * (AddX*ycoef*PartialFlipcoef)
			End If
		End If
		RemoveBall aBall
	End Sub
End Class


'******************************************************
'  SLINGSHOT CORRECTION FUNCTIONS
'******************************************************

dim LS : Set LS = New SlingshotCorrection
dim RS : Set RS = New SlingshotCorrection

InitSlingCorrection

Sub InitSlingCorrection

	LS.Object = LeftSlingshot
	LS.EndPoint1 = EndPoint1LS
	LS.EndPoint2 = EndPoint2LS

	RS.Object = RightSlingshot
	RS.EndPoint1 = EndPoint1RS
	RS.EndPoint2 = EndPoint2RS

	'Slingshot angle corrections (pt, BallPos in %, Angle in deg)
	' These values are best guesses. Retune them if needed based on specific table research.
	AddSlingsPt 0, 0.00,	-4
	AddSlingsPt 1, 0.45,	-7
	AddSlingsPt 2, 0.48,	0
	AddSlingsPt 3, 0.52,	0
	AddSlingsPt 4, 0.55,	7
	AddSlingsPt 5, 1.00,	4

End Sub


Sub AddSlingsPt(idx, aX, aY)        'debugger wrapper for adjusting flipper script in-game
	dim a : a = Array(LS, RS)
	dim x : for each x in a
		x.addpoint idx, aX, aY
	Next
End Sub

Class SlingshotCorrection
	Public DebugOn, Enabled
	private Slingshot, SlingX1, SlingX2, SlingY1, SlingY2

	Public ModIn, ModOut
	Private Sub Class_Initialize : redim ModIn(0) : redim Modout(0): Enabled = True : End Sub 

	Public Property let Object(aInput) : Set Slingshot = aInput : End Property
	Public Property Let EndPoint1(aInput) : SlingX1 = aInput.x: SlingY1 = aInput.y: End Property
	Public Property Let EndPoint2(aInput) : SlingX2 = aInput.x: SlingY2 = aInput.y: End Property

	Public Sub AddPoint(aIdx, aX, aY) 
		ShuffleArrays ModIn, ModOut, 1 : ModIn(aIDX) = aX : ModOut(aIDX) = aY : ShuffleArrays ModIn, ModOut, 0
		If gametime > 100 then Report
	End Sub

	Public Sub Report()         'debug, reports all coords in tbPL.text
		If not debugOn then exit sub
		dim a1, a2 : a1 = ModIn : a2 = ModOut
		dim str, x : for x = 0 to uBound(a1) : str = str & x & ": " & round(a1(x),4) & ", " & round(a2(x),4) & vbnewline : next
		TBPout.text = str
	End Sub


	Public Sub VelocityCorrect(aBall)
		dim BallPos, XL, XR, YL, YR
		
		'Assign right and left end points
		If SlingX1 < SlingX2 Then 
			XL = SlingX1 : YL = SlingY1 : XR = SlingX2 : YR = SlingY2
		Else
			XL = SlingX2 : YL = SlingY2 : XR = SlingX1 : YR = SlingY1
		End If

		'Find BallPos = % on Slingshot
		If Not IsEmpty(aBall.id) Then 
			If ABS(XR-XL) > ABS(YR-YL) Then 
				BallPos = PSlope(aBall.x, XL, 0, XR, 1)
			Else
				BallPos = PSlope(aBall.y, YL, 0, YR, 1)
			End If
			If BallPos < 0 Then BallPos = 0
			If BallPos > 1 Then BallPos = 1
		End If

		'Velocity angle correction
		If not IsEmpty(ModIn(0) ) then
			Dim Angle, RotVxVy
			Angle = LinearEnvelope(BallPos, ModIn, ModOut)
			'debug.print " BallPos=" & BallPos &" Angle=" & Angle 
			'debug.print " BEFORE: aBall.Velx=" & aBall.Velx &" aBall.Vely" & aBall.Vely 
			RotVxVy = RotPoint(aBall.Velx,aBall.Vely,Angle)
			If Enabled then aBall.Velx = RotVxVy(0)
			If Enabled then aBall.Vely = RotVxVy(1)
			'debug.print " AFTER: aBall.Velx=" & aBall.Velx &" aBall.Vely" & aBall.Vely 
			'debug.print " " 
		End If
	End Sub

End Class


'******************************************************
'  FLIPPER POLARITY. RUBBER DAMPENER, AND SLINGSHOT CORRECTION SUPPORTING FUNCTIONS 
'******************************************************


Sub AddPt(aStr, idx, aX, aY)        'debugger wrapper for adjusting flipper script in-game
	dim a : a = Array(LF, RF, LF1, RF1, LF2, RF2)
	dim x : for each x in a
		x.addpoint aStr, idx, aX, aY
	Next
End Sub


' Used for flipper correction and rubber dampeners
Sub ShuffleArray(ByRef aArray, byVal offset) 'shuffle 1d array
	dim x, aCount : aCount = 0
	redim a(uBound(aArray) )
	for x = 0 to uBound(aArray)        'Shuffle objects in a temp array
		if not IsEmpty(aArray(x) ) Then
			if IsObject(aArray(x)) then 
				Set a(aCount) = aArray(x)
			Else
				a(aCount) = aArray(x)
			End If
			aCount = aCount + 1
		End If
	Next
	if offset < 0 then offset = 0
	redim aArray(aCount-1+offset)        'Resize original array
	for x = 0 to aCount-1                'set objects back into original array
		if IsObject(a(x)) then 
			Set aArray(x) = a(x)
		Else
			aArray(x) = a(x)
		End If
	Next
End Sub

' Used for flipper correction and rubber dampeners
Sub ShuffleArrays(aArray1, aArray2, offset)
	ShuffleArray aArray1, offset
	ShuffleArray aArray2, offset
End Sub

' Used for flipper correction, rubber dampeners, and drop targets
Function BallSpeed(ball) 'Calculates the ball speed
	BallSpeed = SQR(ball.VelX^2 + ball.VelY^2 + ball.VelZ^2)
End Function

' Used for flipper correction and rubber dampeners
Function PSlope(Input, X1, Y1, X2, Y2)        'Set up line via two points, no clamping. Input X, output Y
	dim x, y, b, m : x = input : m = (Y2 - Y1) / (X2 - X1) : b = Y2 - m*X2
	Y = M*x+b
	PSlope = Y
End Function

' Used for flipper correction
Class spoofball 
	Public X, Y, Z, VelX, VelY, VelZ, ID, Mass, Radius 
	Public Property Let Data(aBall)
		With aBall
			x = .x : y = .y : z = .z : velx = .velx : vely = .vely : velz = .velz
			id = .ID : mass = .mass : radius = .radius
		end with
	End Property
	Public Sub Reset()
		x = Empty : y = Empty : z = Empty  : velx = Empty : vely = Empty : velz = Empty 
		id = Empty : mass = Empty : radius = Empty
	End Sub
End Class

' Used for flipper correction and rubber dampeners
Function LinearEnvelope(xInput, xKeyFrame, yLvl)
	dim y 'Y output
	dim L 'Line
	dim ii : for ii = 1 to uBound(xKeyFrame)        'find active line
		if xInput <= xKeyFrame(ii) then L = ii : exit for : end if
	Next
	if xInput > xKeyFrame(uBound(xKeyFrame) ) then L = uBound(xKeyFrame)        'catch line overrun
	Y = pSlope(xInput, xKeyFrame(L-1), yLvl(L-1), xKeyFrame(L), yLvl(L) )

	if xInput <= xKeyFrame(lBound(xKeyFrame) ) then Y = yLvl(lBound(xKeyFrame) )         'Clamp lower
	if xInput >= xKeyFrame(uBound(xKeyFrame) ) then Y = yLvl(uBound(xKeyFrame) )        'Clamp upper

	LinearEnvelope = Y
End Function


'******************************************************
'  FLIPPER TRICKS 
'******************************************************

RightFlipper.timerinterval=1
Rightflipper.timerenabled=True

sub RightFlipper_timer()
	FlipperTricks LeftFlipper, LFPress, LFCount, LFEndAngle, LFState
	FlipperTricks RightFlipper, RFPress, RFCount, RFEndAngle, RFState
	FlipperTricks LeftFlipper1, LFPress1, LFCount1, LFEndAngle1, LFState1
	FlipperTricks RightFlipper1, RFPress1, RFCount1, RFEndAngle1, RFState1
	FlipperTricks LeftFlipper1, LFPress2, LFCount2, LFEndAngle2, LFState2
	FlipperTricks RightFlipper1, RFPress2, RFCount2, RFEndAngle2, RFState2
	FlipperNudge RightFlipper, RFEndAngle, RFEOSNudge, LeftFlipper, LFEndAngle
	FlipperNudge LeftFlipper, LFEndAngle, LFEOSNudge,  RightFlipper, RFEndAngle

end sub

Dim LFEOSNudge, RFEOSNudge

Sub FlipperNudge(Flipper1, Endangle1, EOSNudge1, Flipper2, EndAngle2)
	Dim b

	If Flipper1.currentangle = Endangle1 and EOSNudge1 <> 1 Then
		EOSNudge1 = 1
		'debug.print Flipper1.currentangle &" = "& Endangle1 &"--"& Flipper2.currentangle &" = "& EndAngle2
		If Flipper2.currentangle = EndAngle2 Then 
			For b = 0 to Ubound(gBOT)
				If FlipperTrigger(gBOT(b).x, gBOT(b).y, Flipper1) Then
					'Debug.Print "ball in flip1. exit"
					exit Sub
				end If
			Next
			For b = 0 to Ubound(gBOT)
				If FlipperTrigger(gBOT(b).x, gBOT(b).y, Flipper2) Then
					gBOT(b).velx = gBOT(b).velx / 1.3
					gBOT(b).vely = gBOT(b).vely - 0.5
				end If
			Next
		End If
	Else 
		If Abs(Flipper1.currentangle) > Abs(EndAngle1) + 30 then EOSNudge1 = 0
	End If
End Sub

'*****************
' Maths
'*****************
Dim PI: PI = 4*Atn(1)

Function dSin(degrees)
	dsin = sin(degrees * Pi/180)
End Function

Function dCos(degrees)
	dcos = cos(degrees * Pi/180)
End Function

Function Atn2(dy, dx)
	If dx > 0 Then
		Atn2 = Atn(dy / dx)
	ElseIf dx < 0 Then
		If dy = 0 Then 
			Atn2 = pi
		Else
			Atn2 = Sgn(dy) * (pi - Atn(Abs(dy / dx)))
		end if
	ElseIf dx = 0 Then
		if dy = 0 Then
			Atn2 = 0
		else
			Atn2 = Sgn(dy) * pi / 2
		end if
	End If
End Function

'*************************************************
'  Check ball distance from Flipper for Rem
'*************************************************

Function Distance(ax,ay,bx,by)
	Distance = SQR((ax - bx)^2 + (ay - by)^2)
End Function

Function DistancePL(px,py,ax,ay,bx,by) ' Distance between a point and a line where point is px,py
	DistancePL = ABS((by - ay)*px - (bx - ax) * py + bx*ay - by*ax)/Distance(ax,ay,bx,by)
End Function

Function Radians(Degrees)
	Radians = Degrees * PI /180
End Function

Function AnglePP(ax,ay,bx,by)
	AnglePP = Atn2((by - ay),(bx - ax))*180/PI
End Function

Function DistanceFromFlipper(ballx, bally, Flipper)
	DistanceFromFlipper = DistancePL(ballx, bally, Flipper.x, Flipper.y, Cos(Radians(Flipper.currentangle+90))+Flipper.x, Sin(Radians(Flipper.currentangle+90))+Flipper.y)
End Function

Function FlipperTrigger(ballx, bally, Flipper)
	Dim DiffAngle
	DiffAngle  = ABS(Flipper.currentangle - AnglePP(Flipper.x, Flipper.y, ballx, bally) - 90)
	If DiffAngle > 180 Then DiffAngle = DiffAngle - 360

	If DistanceFromFlipper(ballx,bally,Flipper) < 48 and DiffAngle <= 90 and Distance(ballx,bally,Flipper.x,Flipper.y) < Flipper.Length Then
		FlipperTrigger = True
	Else
		FlipperTrigger = False
	End If        
End Function


'*************************************************
'  End - Check ball distance from Flipper for Rem
'*************************************************

dim LFPress, RFPress, LFCount, RFCount, LFPress1, RFPress1, LFCount1, RFCount1, LFPress2, RFPress2, LFCount2, RFCount2
dim LFState, RFState, LFState1, RFState1, LFState2, RFState2
dim EOST, EOSA,Frampup, FElasticity,FReturn
dim RFEndAngle, LFEndAngle, RFEndAngle1, LFEndAngle1, RFEndAngle2, LFEndAngle2


LFState = 1
RFState = 1
LFState1 = 1
RFState1 = 1
LFState2 = 1
RFState2 = 1
EOST = leftflipper.eostorque
EOSA = leftflipper.eostorqueangle
Frampup = LeftFlipper.rampup
FElasticity = LeftFlipper.elasticity
FReturn = LeftFlipper.return

Const EOSTnew = 1 'EM's to late 80's
Const EOSAnew = 1
Const EOSRampup = 0
Dim SOSRampup
Select Case FlipperCoilRampupMode 
	Case 0:
		SOSRampup = 2.5
	Case 1:
		SOSRampup = 6
	Case 2:
		SOSRampup = 8.5
End Select

Const LiveCatch = 16
Const LiveElasticity = 0.45
Const SOSEM = 0.815
Const EOSReturn = 0.045  'late 70's to mid 80's

LFEndAngle = Leftflipper.endangle
RFEndAngle = RightFlipper.endangle
LFEndAngle1 = LeftFlipper1.endangle
RFEndAngle1 = RightFlipper1.endangle
LFEndAngle2 = LeftFlipperLower.endangle
RFEndAngle2 = RightFlipperLower.endangle

Sub FlipperActivate(Flipper, FlipperPress)
	FlipperPress = 1
	Flipper.Elasticity = FElasticity

	Flipper.eostorque = EOST         
	Flipper.eostorqueangle = EOSA         
End Sub

Sub FlipperDeactivate(Flipper, FlipperPress)
	FlipperPress = 0
	Flipper.eostorqueangle = EOSA
	Flipper.eostorque = EOST*EOSReturn/FReturn


	If Abs(Flipper.currentangle) <= Abs(Flipper.endangle) + 0.1 Then
		Dim b

		For b = 0 to UBound(gBOT)
			If Distance(gBOT(b).x, gBOT(b).y, Flipper.x, Flipper.y) < 55 Then 'check for cradle
				If gBOT(b).vely >= -0.4 Then gBOT(b).vely = -0.4
			End If
		Next
	End If
End Sub

Sub FlipperTricks (Flipper, FlipperPress, FCount, FEndAngle, FState) 
	Dim Dir
	Dir = Flipper.startangle/Abs(Flipper.startangle)        '-1 for Right Flipper

	If Abs(Flipper.currentangle) > Abs(Flipper.startangle) - 0.05 Then
		If FState <> 1 Then
			Flipper.rampup = SOSRampup 
			Flipper.endangle = FEndAngle - 3*Dir
			Flipper.Elasticity = FElasticity * SOSEM
			FCount = 0 
			FState = 1
		End If
	ElseIf Abs(Flipper.currentangle) <= Abs(Flipper.endangle) and FlipperPress = 1 then
		if FCount = 0 Then FCount = GameTime

		If FState <> 2 Then
			Flipper.eostorqueangle = EOSAnew
			Flipper.eostorque = EOSTnew
			Flipper.rampup = EOSRampup                        
			Flipper.endangle = FEndAngle
			FState = 2
		End If
	Elseif Abs(Flipper.currentangle) > Abs(Flipper.endangle) + 0.01 and FlipperPress = 1 Then 
		If FState <> 3 Then
			Flipper.eostorque = EOST        
			Flipper.eostorqueangle = EOSA
			Flipper.rampup = Frampup
			Flipper.Elasticity = FElasticity
			FState = 3
		End If

	End If
End Sub

Const LiveDistanceMin = 30  'minimum distance in vp units from flipper base live catch dampening will occur
Const LiveDistanceMax = 114  'maximum distance in vp units from flipper base live catch dampening will occur (tip protection)

Sub CheckLiveCatch(ball, Flipper, FCount, parm) 'Experimental new live catch
	Dim Dir
	Dir = Flipper.startangle/Abs(Flipper.startangle)    '-1 for Right Flipper
	Dim LiveCatchBounce                                                                                                                        'If live catch is not perfect, it won't freeze ball totally
	Dim CatchTime : CatchTime = GameTime - FCount

	if CatchTime <= LiveCatch and parm > 6 and ABS(Flipper.x - ball.x) > LiveDistanceMin and ABS(Flipper.x - ball.x) < LiveDistanceMax Then
		if CatchTime <= LiveCatch*0.5 Then                                                'Perfect catch only when catch time happens in the beginning of the window
			LiveCatchBounce = 0
		else
			LiveCatchBounce = Abs((LiveCatch/2) - CatchTime)        'Partial catch when catch happens a bit late
		end If

		If LiveCatchBounce = 0 and ball.velx * Dir > 0 Then ball.velx = 0
		ball.vely = LiveCatchBounce * (32 / LiveCatch) ' Multiplier for inaccuracy bounce
		ball.angmomx= 0
		ball.angmomy= 0
		ball.angmomz= 0
    Else
        If Abs(Flipper.currentangle) <= Abs(Flipper.endangle) + 1 Then FlippersD.Dampenf Activeball, parm
	End If
End Sub


'******************************************************
'****  END FLIPPER CORRECTIONS
'******************************************************


'******************************************************
'****  PHYSICS DAMPENERS
'******************************************************
'
' These are data mined bounce curves, 
' dialed in with the in-game elasticity as much as possible to prevent angle / spin issues.
' Requires tracking ballspeed to calculate COR



Sub dPosts_Hit(idx) 
	RubbersD.dampen Activeball
	TargetBouncer Activeball, 1
End Sub

Sub dSleeves_Hit(idx) 
	SleevesD.Dampen Activeball
	TargetBouncer Activeball, 0.7
End Sub


dim RubbersD : Set RubbersD = new Dampener        'frubber
RubbersD.name = "Rubbers"
RubbersD.debugOn = False        'shows info in textbox "TBPout"
RubbersD.Print = False        'debug, reports in debugger (in vel, out cor)
'cor bounce curve (linear)
'for best results, try to match in-game velocity as closely as possible to the desired curve
'RubbersD.addpoint 0, 0, 0.935        'point# (keep sequential), ballspeed, CoR (elasticity)
RubbersD.addpoint 0, 0, 1.1        'point# (keep sequential), ballspeed, CoR (elasticity)
RubbersD.addpoint 1, 3.77, 0.97
RubbersD.addpoint 2, 5.76, 0.967        'dont take this as gospel. if you can data mine rubber elasticitiy, please help!
RubbersD.addpoint 3, 15.84, 0.874
RubbersD.addpoint 4, 56, 0.64        'there's clamping so interpolate up to 56 at least

dim SleevesD : Set SleevesD = new Dampener        'this is just rubber but cut down to 85%...
SleevesD.name = "Sleeves"
SleevesD.debugOn = False        'shows info in textbox "TBPout"
SleevesD.Print = False        'debug, reports in debugger (in vel, out cor)
SleevesD.CopyCoef RubbersD, 0.85

'######################### Add new FlippersD Profile
'#########################    Adjust these values to increase or lessen the elasticity

dim FlippersD : Set FlippersD = new Dampener
FlippersD.name = "Flippers"
FlippersD.debugOn = False
FlippersD.Print = False	
FlippersD.addpoint 0, 0, 1.1	
FlippersD.addpoint 1, 3.77, 0.99
FlippersD.addpoint 2, 6, 0.99

Class Dampener
	Public Print, debugOn 'tbpOut.text
	public name, Threshold         'Minimum threshold. Useful for Flippers, which don't have a hit threshold.
	Public ModIn, ModOut
	Private Sub Class_Initialize : redim ModIn(0) : redim Modout(0): End Sub 

	Public Sub AddPoint(aIdx, aX, aY) 
		ShuffleArrays ModIn, ModOut, 1 : ModIn(aIDX) = aX : ModOut(aIDX) = aY : ShuffleArrays ModIn, ModOut, 0
		if gametime > 100 then Report
	End Sub

	public sub Dampen(aBall)
		if threshold then if BallSpeed(aBall) < threshold then exit sub end if end if
		dim RealCOR, DesiredCOR, str, coef
		DesiredCor = LinearEnvelope(cor.ballvel(aBall.id), ModIn, ModOut )
		RealCOR = BallSpeed(aBall) / (cor.ballvel(aBall.id)+0.0001)
		coef = desiredcor / realcor 
		if debugOn then str = name & " in vel:" & round(cor.ballvel(aBall.id),2 ) & vbnewline & "desired cor: " & round(desiredcor,4) & vbnewline & _
		"actual cor: " & round(realCOR,4) & vbnewline & "ballspeed coef: " & round(coef, 3) & vbnewline 
		if Print then debug.print Round(cor.ballvel(aBall.id),2) & ", " & round(desiredcor,3)

		aBall.velx = aBall.velx * coef : aBall.vely = aBall.vely * coef
		if debugOn then TBPout.text = str
	End Sub

	public sub Dampenf(aBall, parm) 'Rubberizer is handle here
		dim RealCOR, DesiredCOR, str, coef
		DesiredCor = LinearEnvelope(cor.ballvel(aBall.id), ModIn, ModOut )
		RealCOR = BallSpeed(aBall) / (cor.ballvel(aBall.id)+0.0001)
		coef = desiredcor / realcor 
		If abs(aball.velx) < 2 and aball.vely < 0 and aball.vely > -3.75 then 
			aBall.velx = aBall.velx * coef : aBall.vely = aBall.vely * coef
		End If
	End Sub

	Public Sub CopyCoef(aObj, aCoef) 'alternative addpoints, copy with coef
		dim x : for x = 0 to uBound(aObj.ModIn)
			addpoint x, aObj.ModIn(x), aObj.ModOut(x)*aCoef
		Next
	End Sub


	Public Sub Report()         'debug, reports all coords in tbPL.text
		if not debugOn then exit sub
		dim a1, a2 : a1 = ModIn : a2 = ModOut
		dim str, x : for x = 0 to uBound(a1) : str = str & x & ": " & round(a1(x),4) & ", " & round(a2(x),4) & vbnewline : next
		TBPout.text = str
	End Sub

End Class


'******************************************************
'  TRACK ALL BALL VELOCITIES
'  FOR RUBBER DAMPENER AND DROP TARGETS
'******************************************************

dim cor : set cor = New CoRTracker

Class CoRTracker
	public ballvel, ballvelx, ballvely

	Private Sub Class_Initialize : redim ballvel(0) : redim ballvelx(0): redim ballvely(0) : End Sub 

	Public Sub Update()	'tracks in-ball-velocity
		dim str, b, AllBalls, highestID : allBalls = getballs

		for each b in allballs
			if b.id >= HighestID then highestID = b.id
		Next

		if uBound(ballvel) < highestID then redim ballvel(highestID)	'set bounds
		if uBound(ballvelx) < highestID then redim ballvelx(highestID)	'set bounds
		if uBound(ballvely) < highestID then redim ballvely(highestID)	'set bounds

		for each b in allballs
			ballvel(b.id) = BallSpeed(b)
			ballvelx(b.id) = b.velx
			ballvely(b.id) = b.vely
		Next
	End Sub
End Class


'******************************************************
'****  END PHYSICS DAMPENERS
'******************************************************


'******************************************************
'****  DROP TARGETS by Rothbauerw
'******************************************************


'******************************************************
'  DROP TARGETS INITIALIZATION
'******************************************************

Class DropTarget
	Private m_primary, m_secondary, m_prim, m_sw, m_animate, m_isDropped
  
	Public Property Get Primary(): Set Primary = m_primary: End Property
	Public Property Let Primary(input): Set m_primary = input: End Property
  
	Public Property Get Secondary(): Set Secondary = m_secondary: End Property
	Public Property Let Secondary(input): Set m_secondary = input: End Property
  
	Public Property Get Prim(): Set Prim = m_prim: End Property
	Public Property Let Prim(input): Set m_prim = input: End Property
  
	Public Property Get Sw(): Sw = m_sw: End Property
	Public Property Let Sw(input): m_sw = input: End Property
  
	Public Property Get Animate(): Animate = m_animate: End Property
	Public Property Let Animate(input): m_animate = input: End Property
  
	Public Property Get IsDropped(): IsDropped = m_isDropped: End Property
	Public Property Let IsDropped(input): m_isDropped = input: End Property
  
	Public default Function init(primary, secondary, prim, sw, animate, isDropped)
	  Set m_primary = primary
	  Set m_secondary = secondary
	  Set m_prim = prim
	  m_sw = sw
	  m_animate = animate
	  m_isDropped = isDropped
  
	  Set Init = Me
	End Function
End Class

'Define a variable for each drop target

Dim DT18, DT19

'Set array with drop target objects
'
'DropTargetvar = Array(primary, secondary, prim, swtich, animate)
' 	primary: 			primary target wall to determine drop
'	secondary:			wall used to simulate the ball striking a bent or offset target after the initial Hit
'	prim:				primitive target used for visuals and animation
'							IMPORTANT!!! 
'							rotz must be used for orientation
'							rotx to bend the target back
'							transz to move it up and down
'							the pivot point should be in the center of the target on the x, y and at or below the playfield (0) on z
'	switch:				ROM switch number
'	animate:			Array slot for handling the animation instrucitons, set to 0
'						Values for animate: 1 - bend target (hit to primary), 2 - drop target (hit to secondary), 3 - brick target (high velocity hit to secondary), -1 - raise target 
'   isDropped:			Boolean which determines whether a drop target is dropped. Set to false if they are initially raised, true if initially dropped.


Set DT18 = (new DropTarget)(sw18, sw18a, sw18p, 18, 0, false)
Set DT19 = (new DropTarget)(sw19, sw19a, sw19p, 19, 0, false)

Dim DTArray
DTArray = Array(DT18, DT19)

'Configure the behavior of Drop Targets.
Const DTDropSpeed = 110 'in milliseconds
Const DTDropUpSpeed = 40 'in milliseconds
Const DTDropUnits = 44 'VP units primitive drops so top of at or below the playfield
Const DTDropUpUnits = 10 'VP units primitive raises above the up position on drops up
Const DTMaxBend = 8 'max degrees primitive rotates when hit
Const DTDropDelay = 20 'time in milliseconds before target drops (due to friction/impact of the ball)
Const DTRaiseDelay = 40 'time in milliseconds before target drops back to normal up position after the solenoid fires to raise the target
Const DTBrickVel = 30 'velocity at which the target will brick, set to '0' to disable brick

Const DTEnableBrick = 0 'Set to 0 to disable bricking, 1 to enable bricking
Const Sound = "" 'Drop Target Hit sound
Const DTDropSound = "DropTarget_Down" 'Drop Target Drop sound
Const DTResetSound = "DropTarget_Up" 'Drop Target reset sound

Const DTMass = 0.2 'Mass of the Drop Target (between 0 and 1), higher values provide more resistance


'******************************************************
'  DROP TARGETS FUNCTIONS
'******************************************************


Sub DTHit(switch)
	Dim i
	i = DTArrayID(switch)
	PlayTargetSound
	DTArray(i).animate =  DTCheckBrick(Activeball,DTArray(i).prim)
	If DTArray(i).animate = 1 or DTArray(i).animate = 3 or DTArray(i).animate = 4 Then
		DTBallPhysics Activeball, DTArray(i).prim.rotz, DTMass
	End If
	DoDTAnim
End Sub

Sub DTRaise(switch)
	Dim i
	i = DTArrayID(switch)

	DTArray(i).animate = -1
	DoDTAnim
End Sub

Sub DTDrop(switch)
	Dim i
	i = DTArrayID(switch)

	DTArray(i).animate = 1
	DoDTAnim
End Sub

Function DTArrayID(switch)
	Dim i
	For i = 0 to uBound(DTArray) 
		If DTArray(i).sw = switch Then DTArrayID = i:Exit Function 
	Next
End Function


sub DTBallPhysics(aBall, angle, mass)
	dim rangle,bangle,calc1, calc2, calc3
	rangle = (angle - 90) * 3.1416 / 180
	bangle = atn2(cor.ballvely(aball.id),cor.ballvelx(aball.id))

	calc1 = cor.BallVel(aball.id) * cos(bangle - rangle) * (aball.mass - mass) / (aball.mass + mass)
	calc2 = cor.BallVel(aball.id) * sin(bangle - rangle) * cos(rangle + 4*Atn(1)/2)
	calc3 = cor.BallVel(aball.id) * sin(bangle - rangle) * sin(rangle + 4*Atn(1)/2)

	aBall.velx = calc1 * cos(rangle) + calc2
	aBall.vely = calc1 * sin(rangle) + calc3
End Sub


'Check if target is hit on it's face or sides and whether a 'brick' occurred
Function DTCheckBrick(aBall, dtprim) 
	dim bangle, bangleafter, rangle, rangle2, Xintersect, Yintersect, cdist, perpvel, perpvelafter, paravel, paravelafter
	rangle = (dtprim.rotz - 90) * 3.1416 / 180
	rangle2 = dtprim.rotz * 3.1416 / 180
	bangle = atn2(cor.ballvely(aball.id),cor.ballvelx(aball.id))
	bangleafter = Atn2(aBall.vely,aball.velx)

	Xintersect = (aBall.y - dtprim.y - tan(bangle) * aball.x + tan(rangle2) * dtprim.x) / (tan(rangle2) - tan(bangle))
	Yintersect = tan(rangle2) * Xintersect + (dtprim.y - tan(rangle2) * dtprim.x)

	cdist = Distance(dtprim.x, dtprim.y, Xintersect, Yintersect)

	perpvel = cor.BallVel(aball.id) * cos(bangle-rangle)
	paravel = cor.BallVel(aball.id) * sin(bangle-rangle)

	perpvelafter = BallSpeed(aBall) * cos(bangleafter - rangle) 
	paravelafter = BallSpeed(aBall) * sin(bangleafter - rangle)

	If perpvel > 0 and  perpvelafter <= 0 Then
		If DTEnableBrick = 1 and  perpvel > DTBrickVel and DTBrickVel <> 0 and cdist < 8 Then
			DTCheckBrick = 3
		Else
			DTCheckBrick = 1
		End If
	ElseIf perpvel > 0 and ((paravel > 0 and paravelafter > 0) or (paravel < 0 and paravelafter < 0)) Then
		DTCheckBrick = 4
	Else 
		DTCheckBrick = 0
	End If
End Function


Sub DoDTAnim()
	Dim i
	For i=0 to Ubound(DTArray)
		DTArray(i).animate = DTAnimate(DTArray(i).primary,DTArray(i).secondary,DTArray(i).prim,DTArray(i).sw,DTArray(i).animate)
	Next
End Sub

Function DTAnimate(primary, secondary, prim, switch, animate)
	dim transz, switchid
	Dim animtime, rangle

	switchid = switch

	Dim ind
	ind = DTArrayID(switchid)

	rangle = prim.rotz * PI / 180

	DTAnimate = animate

	if animate = 0  Then
		primary.uservalue = 0
		DTAnimate = 0
		Exit Function
	Elseif primary.uservalue = 0 then 
		primary.uservalue = gametime
	end if

	animtime = gametime - primary.uservalue

	If (animate = 1 or animate = 4) and animtime < DTDropDelay Then
		primary.collidable = 0
	If animate = 1 then secondary.collidable = 1 else secondary.collidable= 0
		prim.rotx = DTMaxBend * cos(rangle)
		prim.roty = DTMaxBend * sin(rangle)
		DTAnimate = animate
		Exit Function
		elseif (animate = 1 or animate = 4) and animtime > DTDropDelay Then
		primary.collidable = 0
		If animate = 1 then secondary.collidable = 1 else secondary.collidable= 0
		prim.rotx = DTMaxBend * cos(rangle)
		prim.roty = DTMaxBend * sin(rangle)
		animate = 2
		SoundDropTargetDrop prim
	End If

	if animate = 2 Then
		
		transz = (animtime - DTDropDelay)/DTDropSpeed *  DTDropUnits * -1
		if prim.transz > -DTDropUnits  Then
			prim.transz = transz
		end if

		prim.rotx = DTMaxBend * cos(rangle)/2
		prim.roty = DTMaxBend * sin(rangle)/2

		if prim.transz <= -DTDropUnits Then 
			prim.transz = -DTDropUnits
			secondary.collidable = 0
			DTArray(ind).sw = true 'Mark target as dropped
			if UsingROM then 
				controller.Switch(Switchid) = 1
			else 
				' do nothing 
			end if
			primary.uservalue = 0
			DTAnimate = 0
			Exit Function
		Else
			DTAnimate = 2
			Exit Function
		end If 
	End If

	If animate = 3 and animtime < DTDropDelay Then
		primary.collidable = 0
		secondary.collidable = 1
		prim.rotx = DTMaxBend * cos(rangle)
		prim.roty = DTMaxBend * sin(rangle)
	elseif animate = 3 and animtime > DTDropDelay Then
		primary.collidable = 1
		secondary.collidable = 0
		prim.rotx = 0
		prim.roty = 0
		primary.uservalue = 0
		DTAnimate = 0
		Exit Function
	End If

	if animate = -1 Then
		transz = (1 - (animtime)/DTDropUpSpeed) *  DTDropUnits * -1

		If prim.transz = -DTDropUnits Then
			Dim b

			For b = 0 to UBound(gBOT)
				If InRotRect(gBOT(b).x,gBOT(b).y,prim.x, prim.y, prim.rotz, -25,-10,25,-10,25,25,-25,25) and gBOT(b).z < prim.z+DTDropUnits+25 Then
					gBOT(b).velz = 20
				End If
			Next
		End If

		if prim.transz < 0 Then
			prim.transz = transz
		elseif transz > 0 then
			prim.transz = transz
		end if

		if prim.transz > DTDropUpUnits then 
			DTAnimate = -2
			prim.transz = DTDropUpUnits
			prim.rotx = 0
			prim.roty = 0
			primary.uservalue = gametime
		end if
		primary.collidable = 0
		secondary.collidable = 1
		DTArray(ind).sw = false 'Mark target as not dropped
		if UsingROM then controller.Switch(Switchid) = 0

	End If

	if animate = -2 and animtime > DTRaiseDelay Then
		prim.transz = (animtime - DTRaiseDelay)/DTDropSpeed *  DTDropUnits * -1 + DTDropUpUnits 
		if prim.transz < 0 then
			prim.transz = 0
			primary.uservalue = 0
			DTAnimate = 0

			primary.collidable = 1
			secondary.collidable = 0
		end If 
	End If
End Function


'******************************************************
'  DROP TARGET
'  SUPPORTING FUNCTIONS 
'******************************************************


' Used for drop targets
'*** Determines if a Points (px,py) is inside a 4 point polygon A-D in Clockwise/CCW order
Function InRect(px,py,ax,ay,bx,by,cx,cy,dx,dy)
	Dim AB, BC, CD, DA
	AB = (bx*py) - (by*px) - (ax*py) + (ay*px) + (ax*by) - (ay*bx)
	BC = (cx*py) - (cy*px) - (bx*py) + (by*px) + (bx*cy) - (by*cx)
	CD = (dx*py) - (dy*px) - (cx*py) + (cy*px) + (cx*dy) - (cy*dx)
	DA = (ax*py) - (ay*px) - (dx*py) + (dy*px) + (dx*ay) - (dy*ax)

	If (AB <= 0 AND BC <=0 AND CD <= 0 AND DA <= 0) Or (AB >= 0 AND BC >=0 AND CD >= 0 AND DA >= 0) Then
		InRect = True
	Else
		InRect = False       
	End If
End Function

Function InRotRect(ballx,bally,px,py,angle,ax,ay,bx,by,cx,cy,dx,dy)
    Dim rax,ray,rbx,rby,rcx,rcy,rdx,rdy
    Dim rotxy
    rotxy = RotPoint(ax,ay,angle)
    rax = rotxy(0)+px : ray = rotxy(1)+py
    rotxy = RotPoint(bx,by,angle)
    rbx = rotxy(0)+px : rby = rotxy(1)+py
    rotxy = RotPoint(cx,cy,angle)
    rcx = rotxy(0)+px : rcy = rotxy(1)+py
    rotxy = RotPoint(dx,dy,angle)
    rdx = rotxy(0)+px : rdy = rotxy(1)+py

    InRotRect = InRect(ballx,bally,rax,ray,rbx,rby,rcx,rcy,rdx,rdy)
End Function

Function RotPoint(x,y,angle)
    dim rx, ry
    rx = x*dCos(angle) - y*dSin(angle)
    ry = x*dSin(angle) + y*dCos(angle)
    RotPoint = Array(rx,ry)
End Function


'******************************************************
'****  END DROP TARGETS
'******************************************************

'******************************************************
'		STAND-UP TARGET INITIALIZATION
'******************************************************

Class StandupTarget
	Private m_primary, m_prim, m_sw, m_animate
  
	Public Property Get Primary(): Set Primary = m_primary: End Property
	Public Property Let Primary(primary): Set m_primary = primary: End Property
  
	Public Property Get Prim(): Set Prim = m_prim: End Property
	Public Property Let Prim(prim): Set m_prim = prim: End Property
  
	Public Property Get Sw(): Sw = m_sw: End Property
	Public Property Let Sw(sw): m_sw = sw: End Property
  
	Public Property Get Animate(): Animate = m_animate: End Property
	Public Property Let Animate(animate): m_animate = animate: End Property
  
	Public default Function init(primary, prim, sw, animate)
	  Set m_primary = primary
	  Set m_prim = prim
	  m_sw = sw
	  m_animate = animate
  
	  Set Init = Me
	End Function
  End Class

'Define a variable for each stand-up target


Dim ST7, ST20, ST21, ST22, ST23, ST29, ST30, ST31, ST33, ST34, ST35, ST36, ST37, ST211, ST221, ST231, ST291, ST301, ST311


'Set array with stand-up target objects
'
'StandupTargetvar = Array(primary, prim, swtich)
' 	primary: 			vp target to determine target hit
'	prim:				primitive target used for visuals and animation
'							IMPORTANT!!! 
'							transy must be used to offset the target animation
'	switch:				ROM switch number
'	animate:			Arrary slot for handling the animation instrucitons, set to 0
' 
'You will also need to add a secondary hit object for each stand up (name sw11o, sw12o, and sw13o on the example Table1)
'these are inclined primitives to simulate hitting a bent target and should provide so z velocity on high speed impacts



Set ST7 = (new StandupTarget)(sw07, psw07,7, 0)
Set ST20 = (new StandupTarget)(sw20, psw20,20, 0)
Set ST21 = (new StandupTarget)(sw21, psw21,21, 0)
Set ST22 = (new StandupTarget)(sw22, psw22,22, 0)
Set ST23 = (new StandupTarget)(sw23, psw23,23, 0)
Set ST29 = (new StandupTarget)(sw29, psw29,29, 0)
Set ST30 = (new StandupTarget)(sw30, psw30,30, 0)
Set ST31 = (new StandupTarget)(sw31, psw31,31, 0)
Set ST33 = (new StandupTarget)(sw33, psw33,33, 0)
Set ST34 = (new StandupTarget)(sw34, psw34,34, 0)
Set ST35 = (new StandupTarget)(sw35, psw35,35, 0)
Set ST36 = (new StandupTarget)(sw36, psw36,36, 0)
Set ST37 = (new StandupTarget)(sw37, psw37,37, 0)
Set ST211 = (new StandupTarget)(sw21L, psw21L,21, 0)
Set ST221 = (new StandupTarget)(sw22L, psw22L,22, 0)
Set ST231 = (new StandupTarget)(sw23L, psw23L,23, 0)
Set ST291 = (new StandupTarget)(sw29L, psw29L,29, 0)
Set ST301 = (new StandupTarget)(sw30L, psw30L,30, 0)
Set ST311 = (new StandupTarget)(sw31L, psw31L,31, 0)


Dim STArray
STArray = Array(ST7, ST20, ST21, ST22, ST23, ST29, ST30, ST31, ST33, ST34, ST35, ST36, ST37, ST211, ST221, ST231, ST291, ST301, ST311)

'Configure the behavior of Stand-up Targets
Const STAnimStep =  1.5 				'vpunits per animation step (control return to Start)
Const STMaxOffset = 9 			'max vp units target moves when hit

Const STMass = 0.2				'Mass of the Stand-up Target (between 0 and 1), higher values provide more resistance

'******************************************************
'				STAND-UP TARGETS FUNCTIONS
'******************************************************

Sub STHit(switch)
	Dim i
	i = STArrayID(switch)

	PlayTargetSound
	STArray(i).animate =  STCheckHit(Activeball,STArray(i).primary)

	If STArray(i).animate <> 0 Then
		DTBallPhysics Activeball, STArray(i).primary.orientation, STMass
	End If
	DoSTAnim
End Sub

'Function STArrayID(switch)
'	Dim i
'	For i = 0 to uBound(STArray) 
'		If STArray(i).sw = switch Then STArrayID = i:Exit Function 
'	Next
'End Function

Function STArrayID(switch)
	If switch = 7 Then
		STArrayID = 0:Exit Function
	ElseIf switch = 20 Then
		STArrayID = 1:Exit Function
	ElseIf switch = 21 Then
		STArrayID = 2:Exit Function
	ElseIf switch = 22 Then
		STArrayID = 3:Exit Function
	ElseIf switch = 23 Then
		STArrayID = 4:Exit Function
	ElseIf switch = 29 Then
		STArrayID = 5:Exit Function
	ElseIf switch = 30 Then
		STArrayID = 6:Exit Function
	ElseIf switch = 31 Then
		STArrayID = 7:Exit Function
	ElseIf switch = 33 Then
		STArrayID = 8:Exit Function
	ElseIf switch = 34 Then
		STArrayID = 9:Exit Function
	ElseIf switch = 35 Then
		STArrayID = 10:Exit Function
	ElseIf switch = 36 Then
		STArrayID = 11:Exit Function
	ElseIf switch = 37 Then
		STArrayID = 12:Exit Function
	ElseIf switch = 211 Then
		STArrayID = 13:Exit Function
	ElseIf switch = 221 Then
		STArrayID = 14:Exit Function
	ElseIf switch = 231 Then
		STArrayID = 15:Exit Function
	ElseIf switch = 291 Then
		STArrayID = 16:Exit Function
	ElseIf switch = 301 Then
		STArrayID = 17:Exit Function
	ElseIf switch = 311 Then
		STArrayID = 18:Exit Function
	Else
		Exit Function
	End If
End Function


'Check if target is hit on it's face
Function STCheckHit(aBall, target) 
	dim bangle, bangleafter, rangle, rangle2, perpvel, perpvelafter, paravel, paravelafter
	rangle = (target.orientation - 90) * 3.1416 / 180	
	bangle = atn2(cor.ballvely(aball.id),cor.ballvelx(aball.id))
	bangleafter = Atn2(aBall.vely,aball.velx)

	perpvel = cor.BallVel(aball.id) * cos(bangle-rangle)
	paravel = cor.BallVel(aball.id) * sin(bangle-rangle)

	perpvelafter = BallSpeed(aBall) * cos(bangleafter - rangle) 
	paravelafter = BallSpeed(aBall) * sin(bangleafter - rangle)

	If perpvel > 0 and  perpvelafter <= 0 Then
		STCheckHit = 1
	ElseIf perpvel > 0 and ((paravel > 0 and paravelafter > 0) or (paravel < 0 and paravelafter < 0)) Then
		STCheckHit = 1
	Else 
		STCheckHit = 0
	End If
End Function

Sub DoSTAnim()
	Dim i
	For i=0 to Ubound(STArray)
		STArray(i).animate = STAnimate(STArray(i).primary,STArray(i).prim,STArray(i).sw,STArray(i).animate)
	Next
End Sub

Function STAnimate(primary, prim, switch,  animate)
	Dim animtime

	STAnimate = animate

	if animate = 0  Then
		primary.uservalue = 0
		STAnimate = 0
		Exit Function
	Elseif primary.uservalue = 0 then 
		primary.uservalue = gametime
	end if

	animtime = gametime - primary.uservalue

	If animate = 1 Then
		primary.collidable = 0
		prim.transy = -STMaxOffset
		if UsingROM then 
			vpmTimer.PulseSw switch
		else
			STAction switch
		end if
		STAnimate = 2
		Exit Function
	elseif animate = 2 Then
		prim.transy = prim.transy + STAnimStep
		If prim.transy >= 0 Then
			prim.transy = 0
			primary.collidable = 1
			STAnimate = 0
			Exit Function
		Else 
			STAnimate = 2
		End If
	End If	
End Function

Sub STAction(Switch)
	Select Case Switch
		Case 11:
			Addscore 1000
			Flash1 True								'Demo of the flasher
			vpmTimer.AddTimer 150,"Flash1 False'"	'Disable the flash after short time, just like a ROM would do
		Case 12:
			Addscore 1000
			Flash2 True								'Demo of the flasher
			vpmTimer.AddTimer 150,"Flash2 False'"	'Disable the flash after short time, just like a ROM would do
		Case 13:
			Addscore 1000
			Flash3 True								'Demo of the flasher
			vpmTimer.AddTimer 150,"Flash3 False'"	'Disable the flash after short time, just like a ROM would do
	End Select
End Sub

'******************************************************
'		END STAND-UP TARGETS
'******************************************************



'******************************************************
'****  BALL ROLLING AND DROP SOUNDS
'******************************************************
'
' Be sure to call RollingUpdate in a timer with a 10ms interval see the GameTimer_Timer() sub

ReDim rolling(tnob)
InitRolling

Dim DropCount
ReDim DropCount(tnob)

Sub InitRolling
	Dim i
	For i = 0 to tnob
		rolling(i) = False
	Next
End Sub

Sub RollingUpdate()
	Dim b

	' stop the sound of deleted balls
	For b = UBound(gBOT) + 1 to tnob - 1
		' Comment the next line if you are not implementing Dyanmic Ball Shadows
		If AmbientBallShadowOn = 0 Then BallShadowA(b).visible = 0
		rolling(b) = False
		StopSound("BallRoll_" & b)
	Next

	' exit the sub if no balls on the table
	If UBound(gBOT) = -1 Then Exit Sub

	' play the rolling sound for each ball

	For b = 0 to UBound(gBOT)
		If BallVel(gBOT(b)) > 1 AND gBOT(b).z < 30 Then
			rolling(b) = True
			PlaySound ("BallRoll_" & b), -1, VolPlayfieldRoll(gBOT(b)) * BallRollVolume * VolumeDial, AudioPan(gBOT(b)), 0, PitchPlayfieldRoll(gBOT(b)), 1, 0, AudioFade(gBOT(b))
		ElseIf BallVel(gBOT(b)) > 1 AND gBOT(b).z > 70 Then
			rolling(b) = True
			PlaySound ("BallRoll_" & b), -1, VolPlayfieldRoll(gBOT(b)) * BallRollVolume * VolumeDial, AudioPan(gBOT(b)), 0, PitchPlayfieldRoll(gBOT(b)), 1, 0, AudioFade(gBOT(b))
		Else
			If rolling(b) = True Then
				StopSound("BallRoll_" & b)
				rolling(b) = False
			End If
		End If

		' Ball Drop Sounds
		If gBOT(b).VelZ < -1 and gBOT(b).z < 55 and gBOT(b).z > 27 Then 'height adjust for ball drop sounds
			If DropCount(b) >= 5 Then
				DropCount(b) = 0
				If gBOT(b).velz > -7 Then
					RandomSoundBallBouncePlayfieldSoft gBOT(b)
				Else
					RandomSoundBallBouncePlayfieldHard gBOT(b)
				End If				
			End If
		End If
		If DropCount(b) < 5 Then
			DropCount(b) = DropCount(b) + 1
		End If

		' "Static" Ball Shadows
		' Comment the next If block, if you are not implementing the Dyanmic Ball Shadows
		If AmbientBallShadowOn = 0 Then
			If gBOT(b).Z > 30 And gBOT(b).Z < 85 Then
				BallShadowA(b).height=gBOT(b).z - BallSize/4		'This is technically 1/4 of the ball "above" the ramp, but it keeps it from clipping the ramp
			Else
				BallShadowA(b).height=0.1
			End If
			BallShadowA(b).Y = gBOT(b).Y + offsetY
			BallShadowA(b).X = gBOT(b).X + offsetX
			BallShadowA(b).visible = 1
		End If
	Next
End Sub


'******************************************************
'****  END BALL ROLLING AND DROP SOUNDS
'******************************************************


'******************************************************
'****  FLEEP MECHANICAL SOUNDS
'******************************************************


'///////////////////////////////  SOUNDS PARAMETERS  //////////////////////////////
Dim GlobalSoundLevel, CoinSoundLevel, PlungerReleaseSoundLevel, PlungerPullSoundLevel, NudgeLeftSoundLevel
Dim NudgeRightSoundLevel, NudgeCenterSoundLevel, StartButtonSoundLevel, RollingSoundFactor

CoinSoundLevel = 1														'volume level; range [0, 1]
NudgeLeftSoundLevel = 1													'volume level; range [0, 1]
NudgeRightSoundLevel = 1												'volume level; range [0, 1]
NudgeCenterSoundLevel = 1												'volume level; range [0, 1]
StartButtonSoundLevel = 0.1												'volume level; range [0, 1]
PlungerReleaseSoundLevel = 0.8 '1 wjr											'volume level; range [0, 1]
PlungerPullSoundLevel = 1												'volume level; range [0, 1]
RollingSoundFactor = 1.1/5		

'///////////////////////-----Solenoids, Kickers and Flash Relays-----///////////////////////
Dim FlipperUpAttackMinimumSoundLevel, FlipperUpAttackMaximumSoundLevel, FlipperUpAttackLeftSoundLevel, FlipperUpAttackRightSoundLevel
Dim FlipperUpSoundLevel, FlipperDownSoundLevel, FlipperLeftHitParm, FlipperRightHitParm
Dim SlingshotSoundLevel, BumperSoundFactor, KnockerSoundLevel

FlipperUpAttackMinimumSoundLevel = 0.010           						'volume level; range [0, 1]
FlipperUpAttackMaximumSoundLevel = 0.635								'volume level; range [0, 1]
FlipperUpSoundLevel = 1.0                        						'volume level; range [0, 1]
FlipperDownSoundLevel = 0.45                      						'volume level; range [0, 1]
FlipperLeftHitParm = FlipperUpSoundLevel								'sound helper; not configurable
FlipperRightHitParm = FlipperUpSoundLevel								'sound helper; not configurable
SlingshotSoundLevel = 0.95												'volume level; range [0, 1]
BumperSoundFactor = 4.25												'volume multiplier; must not be zero
KnockerSoundLevel = 1 													'volume level; range [0, 1]

'///////////////////////-----Ball Drops, Bumps and Collisions-----///////////////////////
Dim RubberStrongSoundFactor, RubberWeakSoundFactor, RubberFlipperSoundFactor,BallWithBallCollisionSoundFactor
Dim BallBouncePlayfieldSoftFactor, BallBouncePlayfieldHardFactor, PlasticRampDropToPlayfieldSoundLevel, WireRampDropToPlayfieldSoundLevel, DelayedBallDropOnPlayfieldSoundLevel
Dim WallImpactSoundFactor, MetalImpactSoundFactor, SubwaySoundLevel, SubwayEntrySoundLevel, ScoopEntrySoundLevel
Dim SaucerLockSoundLevel, SaucerKickSoundLevel

BallWithBallCollisionSoundFactor = 3.2									'volume multiplier; must not be zero
RubberStrongSoundFactor = 0.055/5											'volume multiplier; must not be zero
RubberWeakSoundFactor = 0.075/5											'volume multiplier; must not be zero
RubberFlipperSoundFactor = 0.075/5										'volume multiplier; must not be zero
BallBouncePlayfieldSoftFactor = 0.025									'volume multiplier; must not be zero
BallBouncePlayfieldHardFactor = 0.025									'volume multiplier; must not be zero
DelayedBallDropOnPlayfieldSoundLevel = 0.8									'volume level; range [0, 1]
WallImpactSoundFactor = 0.075											'volume multiplier; must not be zero
MetalImpactSoundFactor = 0.075/3
SaucerLockSoundLevel = 0.8
SaucerKickSoundLevel = 0.8

'///////////////////////-----Gates, Spinners, Rollovers and Targets-----///////////////////////

Dim GateSoundLevel, TargetSoundFactor, SpinnerSoundLevel, RolloverSoundLevel, DTSoundLevel

GateSoundLevel = 0.5/5													'volume level; range [0, 1]
TargetSoundFactor = 0.0025 * 10											'volume multiplier; must not be zero
DTSoundLevel = 0.25														'volume multiplier; must not be zero
RolloverSoundLevel = 0.25                              					'volume level; range [0, 1]
SpinnerSoundLevel = 0.5                              					'volume level; range [0, 1]

'///////////////////////-----Ball Release, Guides and Drain-----///////////////////////
Dim DrainSoundLevel, BallReleaseSoundLevel, BottomArchBallGuideSoundFactor, FlipperBallGuideSoundFactor 

DrainSoundLevel = 0.8														'volume level; range [0, 1]
BallReleaseSoundLevel = 1												'volume level; range [0, 1]
BottomArchBallGuideSoundFactor = 0.2									'volume multiplier; must not be zero
FlipperBallGuideSoundFactor = 0.015										'volume multiplier; must not be zero

'///////////////////////-----Loops and Lanes-----///////////////////////
Dim ArchSoundFactor
ArchSoundFactor = 0.025/5													'volume multiplier; must not be zero


'/////////////////////////////  SOUND PLAYBACK FUNCTIONS  ////////////////////////////
'/////////////////////////////  POSITIONAL SOUND PLAYBACK METHODS  ////////////////////////////
' Positional sound playback methods will play a sound, depending on the X,Y position of the table element or depending on ActiveBall object position
' These are similar subroutines that are less complicated to use (e.g. simply use standard parameters for the PlaySound call)
' For surround setup - positional sound playback functions will fade between front and rear surround channels and pan between left and right channels
' For stereo setup - positional sound playback functions will only pan between left and right channels
' For mono setup - positional sound playback functions will not pan between left and right channels and will not fade between front and rear channels

' PlaySound full syntax - PlaySound(string, int loopcount, float volume, float pan, float randompitch, int pitch, bool useexisting, bool restart, float front_rear_fade)
' Note - These functions will not work (currently) for walls/slingshots as these do not feature a simple, single X,Y position
Sub PlaySoundAtLevelStatic(playsoundparams, aVol, tableobj)
	PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(tableobj), 0, 0, 0, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtLevelExistingStatic(playsoundparams, aVol, tableobj)
	PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(tableobj), 0, 0, 1, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtLevelStaticLoop(playsoundparams, aVol, tableobj)
	PlaySound playsoundparams, -1, aVol * VolumeDial, AudioPan(tableobj), 0, 0, 0, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtLevelStaticRandomPitch(playsoundparams, aVol, randomPitch, tableobj)
	PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(tableobj), randomPitch, 0, 0, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtLevelActiveBall(playsoundparams, aVol)
	PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(ActiveBall), 0, 0, 0, 0, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtLevelExistingActiveBall(playsoundparams, aVol)
	PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(ActiveBall), 0, 0, 1, 0, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtLeveTimerActiveBall(playsoundparams, aVol, ballvariable)
	PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(ballvariable), 0, 0, 0, 0, AudioFade(ballvariable)
End Sub

Sub PlaySoundAtLevelTimerExistingActiveBall(playsoundparams, aVol, ballvariable)
	PlaySound playsoundparams, 0, aVol * VolumeDial, AudioPan(ballvariable), 0, 0, 1, 0, AudioFade(ballvariable)
End Sub

Sub PlaySoundAtLevelRoll(playsoundparams, aVol, pitch)
	PlaySound playsoundparams, -1, aVol * VolumeDial, AudioPan(tableobj), randomPitch, 0, 0, 0, AudioFade(tableobj)
End Sub

' Previous Positional Sound Subs

Sub PlaySoundAt(soundname, tableobj)
	PlaySound soundname, 1, 1 * VolumeDial, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub

Sub PlaySoundAtVol(soundname, tableobj, aVol)
	PlaySound soundname, 1, aVol * VolumeDial, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub

Sub PlaySoundAtBall(soundname)
	PlaySoundAt soundname, ActiveBall
End Sub

Sub PlaySoundAtBallVol (Soundname, aVol)
	Playsound soundname, 1,aVol * VolumeDial, AudioPan(ActiveBall), 0,0,0, 1, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtBallVolM (Soundname, aVol)
	Playsound soundname, 1,aVol * VolumeDial, AudioPan(ActiveBall), 0,0,0, 0, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtVolLoops(sound, tableobj, Vol, Loops)
	PlaySound sound, Loops, Vol * VolumeDial, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub


'******************************************************
'  Fleep  Supporting Ball & Sound Functions
'******************************************************

Function AudioFade(tableobj) ' Fades between front and back of the table (for surround systems or 2x2 speakers, etc), depending on the Y position on the table. "table1" is the name of the table
  Dim tmp
    tmp = tableobj.y * 2 / tableheight-1

	if tmp > 7000 Then
		tmp = 7000
	elseif tmp < -7000 Then
		tmp = -7000
	end if

    If tmp > 0 Then
		AudioFade = Csng(tmp ^10)
    Else
        AudioFade = Csng(-((- tmp) ^10) )
    End If
End Function

Function AudioPan(tableobj) ' Calculates the pan for a tableobj based on the X position on the table. "table1" is the name of the table
    Dim tmp
    tmp = tableobj.x * 2 / tablewidth-1

	if tmp > 7000 Then
		tmp = 7000
	elseif tmp < -7000 Then
		tmp = -7000
	end if

    If tmp > 0 Then
        AudioPan = Csng(tmp ^10)
    Else
        AudioPan = Csng(-((- tmp) ^10) )
    End If
End Function

Function Vol(ball) ' Calculates the volume of the sound based on the ball speed
	Vol = Csng(BallVel(ball) ^2)
End Function

Function Volz(ball) ' Calculates the volume of the sound based on the ball speed
	Volz = Csng((ball.velz) ^2)
End Function

Function Pitch(ball) ' Calculates the pitch of the sound based on the ball speed
	Pitch = BallVel(ball) * 20
End Function

Function BallVel(ball) 'Calculates the ball speed
	BallVel = INT(SQR((ball.VelX ^2) + (ball.VelY ^2) ) )
End Function

Function VolPlayfieldRoll(ball) ' Calculates the roll volume of the sound based on the ball speed
	VolPlayfieldRoll = RollingSoundFactor * 0.0005 * Csng(BallVel(ball) ^3)
End Function

Function PitchPlayfieldRoll(ball) ' Calculates the roll pitch of the sound based on the ball speed
	PitchPlayfieldRoll = BallVel(ball) ^2 * 15
End Function

Function RndInt(min, max)
	RndInt = Int(Rnd() * (max-min + 1) + min)' Sets a random number integer between min and max
End Function

Function RndNum(min, max)
	RndNum = Rnd() * (max-min) + min' Sets a random number between min and max
End Function

'/////////////////////////////  GENERAL SOUND SUBROUTINES  ////////////////////////////
Sub SoundStartButton()
	PlaySound ("Start_Button"), 0, StartButtonSoundLevel, 0, 0.25
End Sub

Sub SoundNudgeLeft()
	PlaySound ("Nudge_" & Int(Rnd*2)+1), 0, NudgeLeftSoundLevel * VolumeDial, -0.1, 0.25
End Sub

Sub SoundNudgeRight()
	PlaySound ("Nudge_" & Int(Rnd*2)+1), 0, NudgeRightSoundLevel * VolumeDial, 0.1, 0.25
End Sub

Sub SoundNudgeCenter()
	PlaySound ("Nudge_" & Int(Rnd*2)+1), 0, NudgeCenterSoundLevel * VolumeDial, 0, 0.25
End Sub


Sub SoundPlungerPull()
	PlaySoundAtLevelStatic ("Plunger_Pull_1"), PlungerPullSoundLevel, Plunger
End Sub

Sub SoundPlungerReleaseBall()
	PlaySoundAtLevelStatic ("Plunger_Release_Ball"), PlungerReleaseSoundLevel, Plunger	
End Sub

Sub SoundPlungerReleaseNoBall()
	PlaySoundAtLevelStatic ("Plunger_Release_No_Ball"), PlungerReleaseSoundLevel, Plunger
End Sub


'/////////////////////////////  KNOCKER SOLENOID  ////////////////////////////
Sub KnockerSolenoid()
	PlaySoundAtLevelStatic SoundFX("Knocker_1",DOFKnocker), KnockerSoundLevel, KnockerPosition
End Sub

'/////////////////////////////  DRAIN SOUNDS  ////////////////////////////
Sub RandomSoundDrain(drainswitch)
	PlaySoundAtLevelStatic ("Drain_" & Int(Rnd*11)+1), DrainSoundLevel, drainswitch
End Sub

'/////////////////////////////  TROUGH BALL RELEASE SOLENOID SOUNDS  ////////////////////////////

Sub RandomSoundBallRelease(drainswitch)
	PlaySoundAtLevelStatic SoundFX("BallRelease" & Int(Rnd*7)+1,DOFContactors), BallReleaseSoundLevel, drainswitch
End Sub

'/////////////////////////////  SLINGSHOT SOLENOID SOUNDS  ////////////////////////////
Sub RandomSoundSlingshotLeft(sling)
	PlaySoundAtLevelStatic SoundFX("Sling_L" & Int(Rnd*10)+1,DOFContactors), SlingshotSoundLevel, Sling
End Sub

Sub RandomSoundSlingshotRight(sling)
	PlaySoundAtLevelStatic SoundFX("Sling_R" & Int(Rnd*8)+1,DOFContactors), SlingshotSoundLevel, Sling
End Sub

'/////////////////////////////  BUMPER SOLENOID SOUNDS  ////////////////////////////
Sub RandomSoundBumperTop(Bump)
	PlaySoundAtLevelStatic SoundFX("Bumpers_Top_" & Int(Rnd*5)+1,DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
End Sub

Sub RandomSoundBumperMiddle(Bump)
	PlaySoundAtLevelStatic SoundFX("Bumpers_Middle_" & Int(Rnd*5)+1,DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
End Sub

Sub RandomSoundBumperBottom(Bump)
	PlaySoundAtLevelStatic SoundFX("Bumpers_Bottom_" & Int(Rnd*5)+1,DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
End Sub

'/////////////////////////////  SPINNER SOUNDS  ////////////////////////////
Sub SoundSpinner(spinnerswitch)
	PlaySoundAtLevelStatic ("Spinner"), SpinnerSoundLevel, spinnerswitch
End Sub


'/////////////////////////////  FLIPPER BATS SOUND SUBROUTINES  ////////////////////////////
'/////////////////////////////  FLIPPER BATS SOLENOID ATTACK SOUND  ////////////////////////////
Sub SoundFlipperUpAttackLeft(flipper)
	FlipperUpAttackLeftSoundLevel = RndNum(FlipperUpAttackMinimumSoundLevel, FlipperUpAttackMaximumSoundLevel)
	PlaySoundAtLevelStatic SoundFX("Flipper_Attack-L01",DOFFlippers), FlipperUpAttackLeftSoundLevel, flipper
End Sub

Sub SoundFlipperUpAttackRight(flipper)
	FlipperUpAttackRightSoundLevel = RndNum(FlipperUpAttackMinimumSoundLevel, FlipperUpAttackMaximumSoundLevel)
	PlaySoundAtLevelStatic SoundFX("Flipper_Attack-R01",DOFFlippers), FlipperUpAttackLeftSoundLevel, flipper
End Sub

'/////////////////////////////  FLIPPER BATS SOLENOID CORE SOUND  ////////////////////////////
Sub RandomSoundFlipperUpLeft(flipper)
	PlaySoundAtLevelStatic SoundFX("Flipper_L0" & Int(Rnd*9)+1,DOFFlippers), FlipperLeftHitParm, Flipper
End Sub

Sub RandomSoundFlipperUpRight(flipper)
	PlaySoundAtLevelStatic SoundFX("Flipper_R0" & Int(Rnd*9)+1,DOFFlippers), FlipperRightHitParm, Flipper
End Sub

Sub RandomSoundReflipUpLeft(flipper)
	PlaySoundAtLevelStatic SoundFX("Flipper_ReFlip_L0" & Int(Rnd*3)+1,DOFFlippers), (RndNum(0.8, 1))*FlipperUpSoundLevel, Flipper
End Sub

Sub RandomSoundReflipUpRight(flipper)
	PlaySoundAtLevelStatic SoundFX("Flipper_ReFlip_R0" & Int(Rnd*3)+1,DOFFlippers), (RndNum(0.8, 1))*FlipperUpSoundLevel, Flipper
End Sub

Sub RandomSoundFlipperDownLeft(flipper)
	PlaySoundAtLevelStatic SoundFX("Flipper_Left_Down_" & Int(Rnd*7)+1,DOFFlippers), FlipperDownSoundLevel, Flipper
End Sub

Sub RandomSoundFlipperDownRight(flipper)
	PlaySoundAtLevelStatic SoundFX("Flipper_Right_Down_" & Int(Rnd*8)+1,DOFFlippers), FlipperDownSoundLevel, Flipper
End Sub

'/////////////////////////////  FLIPPER BATS BALL COLLIDE SOUND  ////////////////////////////

Sub LeftFlipperCollide(parm)
	FlipperLeftHitParm = parm/10
	If FlipperLeftHitParm > 1 Then
		FlipperLeftHitParm = 1
	End If
	FlipperLeftHitParm = FlipperUpSoundLevel * FlipperLeftHitParm
	RandomSoundRubberFlipper(parm)
End Sub

Sub RightFlipperCollide(parm)
	FlipperRightHitParm = parm/10
	If FlipperRightHitParm > 1 Then
		FlipperRightHitParm = 1
	End If
	FlipperRightHitParm = FlipperUpSoundLevel * FlipperRightHitParm
	RandomSoundRubberFlipper(parm)
End Sub

Sub RandomSoundRubberFlipper(parm)
	PlaySoundAtLevelActiveBall ("Flipper_Rubber_" & Int(Rnd*7)+1), parm  * RubberFlipperSoundFactor
End Sub

'/////////////////////////////  ROLLOVER SOUNDS  ////////////////////////////
Sub RandomSoundRollover()
	PlaySoundAtLevelActiveBall ("Rollover_" & Int(Rnd*4)+1), RolloverSoundLevel
End Sub

Sub Rollovers_Hit(idx)
	RandomSoundRollover
End Sub

'/////////////////////////////  VARIOUS PLAYFIELD SOUND SUBROUTINES  ////////////////////////////
'/////////////////////////////  RUBBERS AND POSTS  ////////////////////////////
'/////////////////////////////  RUBBERS - EVENTS  ////////////////////////////
Sub Rubbers_Hit(idx)
	dim finalspeed
	finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
	If finalspeed > 5 then		
		RandomSoundRubberStrong 1
	End if
	If finalspeed <= 5 then
		RandomSoundRubberWeak()
	End If	
End Sub

'/////////////////////////////  RUBBERS AND POSTS - STRONG IMPACTS  ////////////////////////////
Sub RandomSoundRubberStrong(voladj)
	Select Case Int(Rnd*10)+1
		Case 1 : PlaySoundAtLevelActiveBall ("Rubber_Strong_1"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
		Case 2 : PlaySoundAtLevelActiveBall ("Rubber_Strong_2"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
		Case 3 : PlaySoundAtLevelActiveBall ("Rubber_Strong_3"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
		Case 4 : PlaySoundAtLevelActiveBall ("Rubber_Strong_4"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
		Case 5 : PlaySoundAtLevelActiveBall ("Rubber_Strong_5"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
		Case 6 : PlaySoundAtLevelActiveBall ("Rubber_Strong_6"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
		Case 7 : PlaySoundAtLevelActiveBall ("Rubber_Strong_7"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
		Case 8 : PlaySoundAtLevelActiveBall ("Rubber_Strong_8"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
		Case 9 : PlaySoundAtLevelActiveBall ("Rubber_Strong_9"), Vol(ActiveBall) * RubberStrongSoundFactor*voladj
		Case 10 : PlaySoundAtLevelActiveBall ("Rubber_1_Hard"), Vol(ActiveBall) * RubberStrongSoundFactor * 0.6*voladj
	End Select
End Sub

'/////////////////////////////  RUBBERS AND POSTS - WEAK IMPACTS  ////////////////////////////
Sub RandomSoundRubberWeak()
	PlaySoundAtLevelActiveBall ("Rubber_" & Int(Rnd*9)+1), Vol(ActiveBall) * RubberWeakSoundFactor
End Sub

'/////////////////////////////  WALL IMPACTS  ////////////////////////////
Sub Walls_Hit(idx)
	RandomSoundWall()      
End Sub

Sub RandomSoundWall()
	dim finalspeed
	finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
	If finalspeed > 16 then 
		Select Case Int(Rnd*5)+1
			Case 1 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_1"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 2 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_2"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 3 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_5"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 4 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_7"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 5 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_9"), Vol(ActiveBall) * WallImpactSoundFactor
		End Select
	End if
	If finalspeed >= 6 AND finalspeed <= 16 then
		Select Case Int(Rnd*4)+1
			Case 1 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_3"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 2 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_4"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 3 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_6"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 4 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_8"), Vol(ActiveBall) * WallImpactSoundFactor
		End Select
	End If
	If finalspeed < 6 Then
		Select Case Int(Rnd*3)+1
			Case 1 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_4"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 2 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_6"), Vol(ActiveBall) * WallImpactSoundFactor
			Case 3 : PlaySoundAtLevelExistingActiveBall ("Wall_Hit_8"), Vol(ActiveBall) * WallImpactSoundFactor
		End Select
	End if
End Sub

'/////////////////////////////  METAL TOUCH SOUNDS  ////////////////////////////
Sub RandomSoundMetal()
	PlaySoundAtLevelActiveBall ("Metal_Touch_" & Int(Rnd*13)+1), Vol(ActiveBall) * MetalImpactSoundFactor
End Sub

'/////////////////////////////  METAL - EVENTS  ////////////////////////////

Sub Metals_Hit (idx)
	RandomSoundMetal
End Sub

Sub ShooterDiverter_collide(idx)
	RandomSoundMetal
End Sub

'/////////////////////////////  BOTTOM ARCH BALL GUIDE  ////////////////////////////
'/////////////////////////////  BOTTOM ARCH BALL GUIDE - SOFT BOUNCES  ////////////////////////////
Sub RandomSoundBottomArchBallGuide()
	dim finalspeed
	finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
	If finalspeed > 16 then 
		PlaySoundAtLevelActiveBall ("Apron_Bounce_"& Int(Rnd*2)+1), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
	End if
	If finalspeed >= 6 AND finalspeed <= 16 then
		Select Case Int(Rnd*2)+1
			Case 1 : PlaySoundAtLevelActiveBall ("Apron_Bounce_1"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
			Case 2 : PlaySoundAtLevelActiveBall ("Apron_Bounce_Soft_1"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
		End Select
	End If
	If finalspeed < 6 Then
		Select Case Int(Rnd*2)+1
			Case 1 : PlaySoundAtLevelActiveBall ("Apron_Bounce_Soft_1"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
			Case 2 : PlaySoundAtLevelActiveBall ("Apron_Medium_3"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
		End Select
	End if
End Sub

'/////////////////////////////  BOTTOM ARCH BALL GUIDE - HARD HITS  ////////////////////////////
Sub RandomSoundBottomArchBallGuideHardHit()
	PlaySoundAtLevelActiveBall ("Apron_Hard_Hit_" & Int(Rnd*3)+1), BottomArchBallGuideSoundFactor * 0.25
End Sub

Sub Apron_Hit (idx)
	If Abs(cor.ballvelx(activeball.id) < 4) and cor.ballvely(activeball.id) > 7 then
		RandomSoundBottomArchBallGuideHardHit()
	Else
		RandomSoundBottomArchBallGuide
	End If
End Sub

'/////////////////////////////  FLIPPER BALL GUIDE  ////////////////////////////
Sub RandomSoundFlipperBallGuide()
	dim finalspeed
	finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
	If finalspeed > 16 then 
		Select Case Int(Rnd*2)+1
			Case 1 : PlaySoundAtLevelActiveBall ("Apron_Hard_1"),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
			Case 2 : PlaySoundAtLevelActiveBall ("Apron_Hard_2"),  Vol(ActiveBall) * 0.8 * FlipperBallGuideSoundFactor
		End Select
	End if
	If finalspeed >= 6 AND finalspeed <= 16 then
		PlaySoundAtLevelActiveBall ("Apron_Medium_" & Int(Rnd*3)+1),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
	End If
	If finalspeed < 6 Then
		PlaySoundAtLevelActiveBall ("Apron_Soft_" & Int(Rnd*7)+1),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
	End If
End Sub

'/////////////////////////////  TARGET HIT SOUNDS  ////////////////////////////
Sub RandomSoundTargetHitStrong()
	PlaySoundAtLevelActiveBall SoundFX("Target_Hit_" & Int(Rnd*4)+5,DOFTargets), Vol(ActiveBall) * 0.45 * TargetSoundFactor
End Sub

Sub RandomSoundTargetHitWeak()		
	PlaySoundAtLevelActiveBall SoundFX("Target_Hit_" & Int(Rnd*4)+1,DOFTargets), Vol(ActiveBall) * TargetSoundFactor
End Sub

Sub PlayTargetSound()
	dim finalspeed
	finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
	If finalspeed > 10 then
		RandomSoundTargetHitStrong()
		RandomSoundBallBouncePlayfieldSoft Activeball
	Else 
		RandomSoundTargetHitWeak()
	End If	
End Sub

Sub Targets_Hit (idx)
	PlayTargetSound	
End Sub

'/////////////////////////////  BALL BOUNCE SOUNDS  ////////////////////////////
Sub RandomSoundBallBouncePlayfieldSoft(aBall)
	Select Case Int(Rnd*9)+1
		Case 1 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_1"), volz(aBall) * BallBouncePlayfieldSoftFactor, aBall
		Case 2 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_2"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.5, aBall
		Case 3 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_3"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.8, aBall
		Case 4 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_4"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.5, aBall
		Case 5 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_5"), volz(aBall) * BallBouncePlayfieldSoftFactor, aBall
		Case 6 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_1"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.2, aBall
		Case 7 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_2"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.2, aBall
		Case 8 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_5"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.2, aBall
		Case 9 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_7"), volz(aBall) * BallBouncePlayfieldSoftFactor * 0.3, aBall
	End Select
End Sub

Sub RandomSoundBallBouncePlayfieldHard(aBall)
	PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_" & Int(Rnd*7)+1), volz(aBall) * BallBouncePlayfieldHardFactor, aBall
End Sub

'/////////////////////////////  DELAYED DROP - TO PLAYFIELD - SOUND  ////////////////////////////
Sub RandomSoundDelayedBallDropOnPlayfield(aBall)
	Select Case Int(Rnd*5)+1
		Case 1 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_1_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
		Case 2 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_2_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
		Case 3 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_3_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
		Case 4 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_4_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
		Case 5 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_5_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, aBall
	End Select
End Sub

'/////////////////////////////  BALL GATES AND BRACKET GATES SOUNDS  ////////////////////////////

Sub SoundPlayfieldGate()			
	PlaySoundAtLevelStatic ("Gate_FastTrigger_" & Int(Rnd*2)+1), GateSoundLevel, Activeball
End Sub

Sub SoundHeavyGate()
	PlaySoundAtLevelStatic ("Gate_2"), GateSoundLevel, Activeball
End Sub

Sub Gates_hit(idx)
	SoundHeavyGate
End Sub

Sub GatesWire_hit(idx)	
	SoundPlayfieldGate	
End Sub	

'/////////////////////////////  LEFT LANE ENTRANCE - SOUNDS  ////////////////////////////

Sub RandomSoundLeftArch()
	PlaySoundAtLevelActiveBall ("Arch_L" & Int(Rnd*4)+1), Vol(ActiveBall) * ArchSoundFactor
End Sub

Sub RandomSoundRightArch()
	PlaySoundAtLevelActiveBall ("Arch_R" & Int(Rnd*4)+1), Vol(ActiveBall) * ArchSoundFactor
End Sub


Sub Arch1_hit()
	If Activeball.velx > 1 Then SoundPlayfieldGate
	StopSound "Arch_L1"
	StopSound "Arch_L2"
	StopSound "Arch_L3"
	StopSound "Arch_L4"
End Sub

Sub Arch1_unhit()
	If activeball.velx < -8 Then
		RandomSoundRightArch
	End If
End Sub

Sub Arch2_hit()
	If Activeball.velx < 1 Then SoundPlayfieldGate
	StopSound "Arch_R1"
	StopSound "Arch_R2"
	StopSound "Arch_R3"
	StopSound "Arch_R4"
End Sub

Sub Arch2_unhit()
	If activeball.velx > 10 Then
		RandomSoundLeftArch
	End If
End Sub

'/////////////////////////////  SAUCERS (KICKER HOLES)  ////////////////////////////

Sub SoundSaucerLock()
	PlaySoundAtLevelStatic ("Saucer_Enter_" & Int(Rnd*2)+1), SaucerLockSoundLevel, Activeball
End Sub

Sub SoundSaucerKick(scenario, saucer)
	Select Case scenario
		Case 0: PlaySoundAtLevelStatic SoundFX("Saucer_Empty", DOFContactors), SaucerKickSoundLevel, saucer
		Case 1: PlaySoundAtLevelStatic SoundFX("Saucer_Kick", DOFContactors), SaucerKickSoundLevel, saucer
	End Select
End Sub

'/////////////////////////////  BALL COLLISION SOUND  ////////////////////////////
Sub OnBallBallCollision(ball1, ball2, velocity)
	Dim snd
	Select Case Int(Rnd*7)+1
		Case 1 : snd = "Ball_Collide_1"
		Case 2 : snd = "Ball_Collide_2"
		Case 3 : snd = "Ball_Collide_3"
		Case 4 : snd = "Ball_Collide_4"
		Case 5 : snd = "Ball_Collide_5"
		Case 6 : snd = "Ball_Collide_6"
		Case 7 : snd = "Ball_Collide_7"
	End Select

	PlaySound (snd), 0, Csng(velocity) ^2 / 200 * BallWithBallCollisionSoundFactor * VolumeDial, AudioPan(ball1), 0, Pitch(ball1), 0, 0, AudioFade(ball1)
End Sub


'///////////////////////////  DROP TARGET HIT SOUNDS  ///////////////////////////

Sub RandomSoundDropTargetReset(obj)
	PlaySoundAtLevelStatic SoundFX("Drop_Target_Reset_" & Int(Rnd*6)+1,DOFContactors), 1, obj
End Sub

Sub SoundDropTargetDrop(obj)
	PlaySoundAtLevelStatic ("Drop_Target_Down_" & Int(Rnd*6)+1), 200, obj
End Sub

'/////////////////////////////  GI AND FLASHER RELAYS  ////////////////////////////

Const RelayFlashSoundLevel = 0.315									'volume level; range [0, 1];
Const RelayGISoundLevel = 1.05									'volume level; range [0, 1];

Sub Sound_GI_Relay(toggle, obj)
	Select Case toggle
		Case 1
			PlaySoundAtLevelStatic ("Relay_GI_On"), 0.025*RelayGISoundLevel, obj
		Case 0
			PlaySoundAtLevelStatic ("Relay_GI_Off"), 0.025*RelayGISoundLevel, obj
	End Select
End Sub

Sub Sound_Flash_Relay(toggle, obj)
	Select Case toggle
		Case 1
			PlaySoundAtLevelStatic ("Relay_Flash_On"), 0.025*RelayFlashSoundLevel, obj			
		Case 0
			PlaySoundAtLevelStatic ("Relay_Flash_Off"), 0.025*RelayFlashSoundLevel, obj		
	End Select
End Sub

'/////////////////////////////////////////////////////////////////
'					End Mechanical Sounds
'/////////////////////////////////////////////////////////////////

'******************************************************
'****  FLEEP MECHANICAL SOUNDS
'******************************************************


'******************************************************
'****  LAMPZ by nFozzy
'******************************************************
' 

Sub SetLamp(aNr, aOn)
	Lampz.state(aNr) = abs(aOn)
End Sub

Dim NullFader : set NullFader = new NullFadingObject
Dim Lampz : Set Lampz = New LampFader
InitLampsNF              	' Setup lamp assignments

Sub LampTimer()
	dim x, chglamp
	if UsingROM then chglamp = Controller.ChangedLamps
	If Not IsEmpty(chglamp) Then
		For x = 0 To UBound(chglamp) 			'nmbr = chglamp(x, 0), state = chglamp(x, 1)
			Lampz.state(chglamp(x, 0)) = chglamp(x, 1)
		next
	End If
	Lampz.Update2	'update (fading logic only)

End Sub


Sub DisableLighting(pri, DLintensity, ByVal aLvl)	'cp's script  DLintensity = disabled lighting intesity
	if Lampz.UseFunction then aLvl = Lampz.FilterOut(aLvl)	'Callbacks don't get this filter automatically
	pri.blenddisablelighting = aLvl * DLintensity
End Sub

sub DisableLighting2(pri, DLintensityMax, DLintensityMin, ByVal aLvl)    'cp's script  DLintensity = disabled lighting intesity
    if Lampz.UseFunction then aLvl = Lampz.FilterOut(aLvl)    'Callbacks don't get this filter automatically
    pri.blenddisablelighting = (aLvl * (DLintensityMax-DLintensityMin)) + DLintensityMin
End Sub

Sub SetModLamp(id, val)
	Lampz.state(id) = val
End Sub

const insert_dl_on_red = 60
const insert_dl_on_green = 80
const insert_dl_on_orange = 80
const insert_dl_on_arrow = 100
const insert_dl_on_blue = 100
const insert_dl_on_yellow = 80
const smallinsert_max = .8
const smallinsert_min = .1

Sub InitLampsNF()

	'Filtering (comment out to disable)
	Lampz.Filter = "LampFilter"	'Puts all lamp intensityscale output (no callbacks) through this function before updating

	'Adjust fading speeds (max level / full MS fading time). The Modulate property must be set to 1 / max level if lamp is modulated.
	dim x : for x = 0 to 150 : Lampz.FadeSpeedUp(x) = 1/40 : Lampz.FadeSpeedDown(x) = 1/120 : Lampz.Modulate(x) = 1 : next

' GI Fading
	Lampz.FadeSpeedUp(63) = 1/40 : Lampz.FadeSpeedDown(63) = 1/120 : Lampz.Modulate(63) = 1

	'Lampz Assignments
	'  In a ROM based table, the lamp ID is used to set the state of the Lampz objects

	'MassAssign is an optional way to do assignments. It'll create arrays automatically / append objects to existing arrays

'Playfield
	Lampz.MassAssign(1)= L1
	Lampz.MassAssign(1)= l1a
	Lampz.Callback(1) = "DisableLighting2 p1, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(2)= L2
	Lampz.MassAssign(2)= l2a
	Lampz.Callback(2) = "DisableLighting2 p2, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(3)= L3
	Lampz.MassAssign(3)= l3a
	Lampz.Callback(3) = "DisableLighting2 p3, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(6)= L6
	Lampz.MassAssign(6)= l6a
	Lampz.Callback(6) = "DisableLighting2 p6, insert_dl_on_blue, 1,"
	Lampz.Callback(6) = "DisableLighting2 bulb6, 400, 5,"
	Lampz.MassAssign(7)= L7
	Lampz.MassAssign(7)= L7_pf
	Lampz.MassAssign(7)= L7_top
	Lampz.MassAssign(8)= L8
	Lampz.MassAssign(8)= l8a
	Lampz.Callback(8) = "DisableLighting p8, insert_dl_on_arrow,"
	Lampz.MassAssign(10)= L10
	Lampz.MassAssign(10)= l10a
	Lampz.Callback(10) = "DisableLighting2 p10, insert_dl_on_green, 1,"
	Lampz.Callback(10) = "DisableLighting2 bulb10, 400, 5,"
	Lampz.MassAssign(12)= L12
	Lampz.MassAssign(12)= l12a
	Lampz.Callback(12) = "DisableLighting2 p12, insert_dl_on_red, 1,"
	Lampz.Callback(12) = "DisableLighting2 bulb12, 400, 5,"
	Lampz.MassAssign(17)= L17
	Lampz.MassAssign(17)= l17a
	Lampz.Callback(17) = "DisableLighting2 p17, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(18)= L18
	Lampz.MassAssign(18)= l18a
	Lampz.Callback(18) = "DisableLighting2 p18, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(19)= L19
	Lampz.MassAssign(19)= l19a
	Lampz.Callback(19) = "DisableLighting2 p19, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(22)= L22
	Lampz.MassAssign(22)= l22a
	Lampz.Callback(22) = "DisableLighting2 p22, insert_dl_on_blue, 1,"
	Lampz.Callback(22) = "DisableLighting2 bulb22, 400, 5,"
	Lampz.MassAssign(23)= L23
	Lampz.MassAssign(23)= L23_pf
	Lampz.MassAssign(23)= L23_top
	Lampz.MassAssign(24)= L24
	Lampz.MassAssign(24)= l24a
	Lampz.Callback(24) = "DisableLighting p24, insert_dl_on_arrow,"
	Lampz.MassAssign(26)= L26
	Lampz.MassAssign(26)= l26a
	Lampz.Callback(26) = "DisableLighting2 p26, insert_dl_on_green, 1,"
	Lampz.Callback(26) = "DisableLighting2 bulb26, 400, 5,"
	Lampz.MassAssign(28)= L28
	Lampz.MassAssign(28)= l28a
	Lampz.Callback(28) = "DisableLighting2 p28, insert_dl_on_red, 1,"
	Lampz.Callback(28) = "DisableLighting2 bulb28, 400, 5,"
	Lampz.MassAssign(33)= L33
	Lampz.MassAssign(33)= l33a
	Lampz.Callback(33) = "DisableLighting2 p33, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(34)= L34
	Lampz.MassAssign(34)= l34a
	Lampz.Callback(34) = "DisableLighting2 p34, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(35)= L35
	Lampz.MassAssign(35)= l35a
	Lampz.Callback(35) = "DisableLighting2 p35, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(38)= L38
	Lampz.MassAssign(38)= l38a
	Lampz.Callback(38) = "DisableLighting2 p38, insert_dl_on_blue, 1,"
	Lampz.Callback(38) = "DisableLighting2 bulb38, 400, 5,"
	Lampz.MassAssign(39)= L39
	Lampz.MassAssign(39)= L39_pf
	Lampz.MassAssign(39)= L39_top
	Lampz.MassAssign(40)= L40
	Lampz.MassAssign(40)= l40a
	Lampz.Callback(40) = "DisableLighting p40, insert_dl_on_arrow,"
	Lampz.MassAssign(42)= L42
	Lampz.MassAssign(42)= l42a
	Lampz.Callback(42) = "DisableLighting2 p42, insert_dl_on_green, 1,"
	Lampz.Callback(42) = "DisableLighting2 bulb42, 400, 5,"
	Lampz.MassAssign(43)= L43
	Lampz.MassAssign(43)= l43a
	Lampz.Callback(43) = "DisableLighting2 p43, insert_dl_on_orange, 1,"
	Lampz.Callback(43) = "DisableLighting2 bulb43, 400, 5,"
	Lampz.MassAssign(44)= L44
	Lampz.MassAssign(44)= l44a
	Lampz.Callback(44) = "DisableLighting2 p44, insert_dl_on_blue, 1,"
	Lampz.Callback(44) = "DisableLighting2 bulb44, 400, 5,"
	Lampz.MassAssign(49)= L49
	Lampz.MassAssign(49)= l49a
	Lampz.Callback(49) = "DisableLighting2 p49, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(50)= L50
	Lampz.MassAssign(50)= l50a
	Lampz.Callback(50) = "DisableLighting2 p50, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(53)= L53a
	Lampz.MassAssign(53)= l53aa
	Lampz.Callback(53) = "DisableLighting2 p53a, insert_dl_on_red, 1,"
	Lampz.Callback(53) = "DisableLighting2 bulb53a, 400, 5,"
	Lampz.MassAssign(54)= L54
	Lampz.MassAssign(54)= l54a
	Lampz.Callback(54) = "DisableLighting2 p54, insert_dl_on_blue, 1,"
	Lampz.Callback(54) = "DisableLighting2 bulb54, 400, 5,"
	Lampz.MassAssign(55)= L55
	Lampz.MassAssign(55)= l55a
	Lampz.Callback(55) = "DisableLighting2 p55, insert_dl_on_blue, 1,"
	Lampz.Callback(55) = "DisableLighting2 bulb55, 400, 5,"
	Lampz.MassAssign(59)= L59
	Lampz.MassAssign(59)= l59a
	Lampz.Callback(59) = "DisableLighting2 p59, 0.4, 0.1, "
	Lampz.MassAssign(60)= L60
	Lampz.MassAssign(60)= l60a
	Lampz.Callback(60) = "DisableLighting p60, insert_dl_on_arrow,"

'Upper Playfield
	Lampz.MassAssign(4)= L4
	Lampz.MassAssign(4)= l4a
	Lampz.Callback(4) = "DisableLighting2 p4, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(5)= L5
	Lampz.MassAssign(5)= l5a
	Lampz.Callback(5) = "DisableLighting p5, insert_dl_on_arrow,"
	Lampz.MassAssign(9)= L9
	Lampz.Callback(9) = "DisableLighting2 pstar38a, 2, 0.2,"
	Lampz.MassAssign(14)= L14
	Lampz.Callback(14) = "DisableLighting2 pstar28a, 2, 0.2,"
	Lampz.MassAssign(15)= L15
	Lampz.Callback(15) = "DisableLighting2 pstar27b, 2, 0.2,"
	Lampz.Callback(15) = "BG15"
	Lampz.MassAssign(20)= L20
	Lampz.MassAssign(20)= l20a
	Lampz.Callback(20) = "DisableLighting2 p20, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(21)= L21
	Lampz.MassAssign(21)= l21a
	Lampz.Callback(21) = "DisableLighting p21, insert_dl_on_arrow,"
	Lampz.MassAssign(25)= L25
	Lampz.Callback(25) = "DisableLighting2 pstar38b, 2, 0.2,"
	Lampz.MassAssign(30)= L30
	Lampz.Callback(30) = "DisableLighting2 pstar28b, 2, 0.2,"
	Lampz.Callback(30) = "BG30"
	Lampz.MassAssign(31)= L31
	Lampz.Callback(31) = "DisableLighting2 pstar27c, 2, 0.2,"
	Lampz.Callback(31) = "BG31"
	Lampz.MassAssign(36)= L36
	Lampz.MassAssign(36)= l36a
	Lampz.Callback(36) = "DisableLighting2 p36, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(37)= L37
	Lampz.MassAssign(37)= l37a
	Lampz.Callback(37) = "DisableLighting p37, insert_dl_on_arrow,"
	Lampz.MassAssign(46)= L46
	Lampz.Callback(46) = "DisableLighting2 pstar28c, 2, 0.2,"
	Lampz.Callback(46) = "BG46"
	Lampz.MassAssign(52)= L52
	Lampz.MassAssign(52)= l52a
	Lampz.Callback(52) = "DisableLighting2 p52, insert_dl_on_blue, 1,"
	Lampz.Callback(52) = "DisableLighting2 bulb52, 400, 5,"
	Lampz.MassAssign(53)= l53
	Lampz.Callback(53) = "DisableLighting2 pstar24, 2, 0.2,"
	Lampz.MassAssign(56)= L56
	Lampz.MassAssign(56)= l56a
	Lampz.Callback(56) = "DisableLighting p56, insert_dl_on_arrow,"
	Lampz.MassAssign(62)= L62
	Lampz.Callback(62) = "DisableLighting2 pstar27a, 2, 0.2,"
	Lampz.Callback(62) = "BG62"

'Mini playfield
	Lampz.MassAssign(65)= L65
	Lampz.MassAssign(65)= l65a
	Lampz.Callback(65) = "DisableLighting2 p65, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(66)= L66
	Lampz.MassAssign(66)= l66a
	Lampz.Callback(66) = "DisableLighting2 p66, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(67)= L67
	Lampz.MassAssign(67)= l67a
	Lampz.Callback(67) = "DisableLighting2 p67, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(68)= L68
	Lampz.MassAssign(68)= l68a
	Lampz.Callback(68) = "DisableLighting p68, insert_dl_on_arrow,"
	Lampz.Callback(68) = "BG68"
	Lampz.MassAssign(69)= L69
	Lampz.MassAssign(69)= l69a
	Lampz.Callback(69) = "DisableLighting p69, insert_dl_on_arrow,"
	Lampz.Callback(69) = "BG69"
	Lampz.MassAssign(70)= L70
	Lampz.MassAssign(70)= l70a
	Lampz.Callback(70) = "DisableLighting p70, insert_dl_on_arrow,"
	Lampz.MassAssign(81)= L81
	Lampz.MassAssign(81)= l81a
	Lampz.Callback(81) = "DisableLighting2 p81, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(82)= L82
	Lampz.MassAssign(82)= l82a
	Lampz.Callback(82) = "DisableLighting2 p82, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(83)= L83
	Lampz.MassAssign(83)= l83a
	Lampz.Callback(83) = "DisableLighting2 p83, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(84)= L84
	Lampz.MassAssign(84)= l84a
	Lampz.Callback(84) = "DisableLighting p84, insert_dl_on_arrow,"
	Lampz.Callback(84) = "BG84"
	Lampz.MassAssign(85)= L85
	Lampz.MassAssign(85)= l85a
	Lampz.Callback(85) = "DisableLighting p85, insert_dl_on_arrow,"
	Lampz.Callback(85) = "BG85"
	Lampz.MassAssign(86)= L86
	Lampz.MassAssign(86)= l86a
	Lampz.Callback(86) = "DisableLighting p86, insert_dl_on_arrow,"
	Lampz.MassAssign(97)= L97
	Lampz.MassAssign(97)= l97a
	Lampz.Callback(97) = "DisableLighting2 p97, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(98)= L98
	Lampz.MassAssign(98)= l98a
	Lampz.Callback(98) = "DisableLighting2 p98, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(99)= L99
	Lampz.MassAssign(99)= l99a
	Lampz.Callback(99) = "DisableLighting2 p99, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(100)= L100
	Lampz.MassAssign(100)= l100a
	Lampz.Callback(100) = "DisableLighting p100, insert_dl_on_arrow,"
	Lampz.Callback(100) = "BG100"
	Lampz.MassAssign(101)= L101
	Lampz.MassAssign(101)= l101a
	Lampz.Callback(101) = "DisableLighting p101, insert_dl_on_arrow,"
	Lampz.Callback(101) = "BG101"
	Lampz.MassAssign(102)= L102
	Lampz.Callback(102) = "DisableLighting2 pstar26l, 2, 0.2,"
	Lampz.MassAssign(113)= L113
	Lampz.MassAssign(113)= l113a
	Lampz.Callback(113) = "DisableLighting2 p113, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(114)= L114
	Lampz.MassAssign(114)= l114a
	Lampz.Callback(114) = "DisableLighting2 p114, smallinsert_max, smallinsert_min,"
	Lampz.MassAssign(115)= L115
	Lampz.MassAssign(115)= l115a
	Lampz.Callback(115) = "DisableLighting2 p115, insert_dl_on_green, 1,"
	Lampz.Callback(115) = "DisableLighting2 bulb115, 400, 5,"
	Lampz.Callback(115) = "BG115"
	Lampz.MassAssign(118)= L118
	Lampz.Callback(118) = "DisableLighting2 pstar25l, 2, 0.2,"

	Lampz.Callback(63) = "GIUpdates"

	'Turn off all lamps on startup
	Lampz.Init	'This just turns state of any lamps to 1

	'Immediate update to turn on GI, turn off lamps
	Lampz.Update

End Sub


'====================
'Class jungle nf
'====================

'No-op object instead of adding more conditionals to the main loop
'It also prevents errors if empty lamp numbers are called, and it's only one object
'should be g2g?

Class NullFadingObject : Public Property Let IntensityScale(input) : : End Property : End Class

'version 0.11 - Mass Assign, Changed modulate style
'version 0.12 - Update2 (single -1 timer update) update method for core.vbs
'Version 0.12a - Filter can now be accessed via 'FilterOut'
'Version 0.12b - Changed MassAssign from a sub to an indexed property (new syntax: lampfader.MassAssign(15) = Light1 )
'Version 0.13 - No longer requires setlocale. Callback() can be assigned multiple times per index
' Note: if using multiple 'LampFader' objects, set the 'name' variable to avoid conflicts with callbacks
'Version 0.14 - Updated to support modulated signals - Niwak

Class LampFader
	Public FadeSpeedDown(150), FadeSpeedUp(150)
	Private Lock(150), Loaded(150), OnOff(150)
	Public UseFunction
	Private cFilter
	Public UseCallback(150), cCallback(150)
	Public Lvl(150), Obj(150)
	Private Mult(150)
	Public FrameTime
	Private InitFrame
	Public Name

	Sub Class_Initialize()
		InitFrame = 0
		dim x : for x = 0 to uBound(OnOff) 	'Set up fade speeds
			FadeSpeedDown(x) = 1/100	'fade speed down
			FadeSpeedUp(x) = 1/80		'Fade speed up
			UseFunction = False
			lvl(x) = 0
			OnOff(x) = 0
			Lock(x) = True : Loaded(x) = False
			Mult(x) = 1
		Next
		Name = "LampFaderNF" 'NEEDS TO BE CHANGED IF THERE'S MULTIPLE OF THESE OBJECTS, OTHERWISE CALLBACKS WILL INTERFERE WITH EACH OTHER!!
		for x = 0 to uBound(OnOff) 		'clear out empty obj
			if IsEmpty(obj(x) ) then Set Obj(x) = NullFader' : Loaded(x) = True
		Next
	End Sub

	Public Property Get Locked(idx) : Locked = Lock(idx) : End Property		''debug.print Lampz.Locked(100)	'debug
	Public Property Get state(idx) : state = OnOff(idx) : end Property
	Public Property Let Filter(String) : Set cFilter = GetRef(String) : UseFunction = True : End Property
	Public Function FilterOut(aInput) : if UseFunction Then FilterOut = cFilter(aInput) Else FilterOut = aInput End If : End Function
	'Public Property Let Callback(idx, String) : cCallback(idx) = String : UseCallBack(idx) = True : End Property
	Public Property Let Callback(idx, String)
		UseCallBack(idx) = True
		'cCallback(idx) = String 'old execute method
		'New method: build wrapper subs using ExecuteGlobal, then call them
		cCallback(idx) = cCallback(idx) & "___" & String	'multiple strings dilineated by 3x _

		dim tmp : tmp = Split(cCallback(idx), "___")

		dim str, x : for x = 0 to uBound(tmp)	'build proc contents
			'If Not tmp(x)="" then str = str & "	" & tmp(x) & " aLVL" & "	'" & x & vbnewline	'more verbose
			If Not tmp(x)="" then str = str & tmp(x) & " aLVL:"
		Next
		'msgbox "Sub " & name & idx & "(aLvl):" & str & "End Sub"
		dim out : out = "Sub " & name & idx & "(aLvl):" & str & "End Sub"
		ExecuteGlobal Out

	End Property

	Public Property Let state(ByVal idx, input) 'Major update path
		if TypeName(input) <> "Double" and typename(input) <> "Integer"  and typename(input) <> "Long" then
			If input Then
				input = 1
			Else
				input = 0
			End If
		End If
		if Input <> OnOff(idx) then  'discard redundant updates
			OnOff(idx) = input
			Lock(idx) = False
			Loaded(idx) = False
		End If
	End Property

	'Mass assign, Builds arrays where necessary
	'Sub MassAssign(aIdx, aInput)
	Public Property Let MassAssign(aIdx, aInput)
		If typename(obj(aIdx)) = "NullFadingObject" Then 'if empty, use Set
			if IsArray(aInput) then
				obj(aIdx) = aInput
			Else
				Set obj(aIdx) = aInput
			end if
		Else
			Obj(aIdx) = AppendArray(obj(aIdx), aInput)
		end if
	end Property

	Sub SetLamp(aIdx, aOn) : state(aIdx) = aOn : End Sub	'Solenoid Handler

	Public Sub TurnOnStates()	'If obj contains any light objects, set their states to 1 (Fading is our job!)
		dim debugstr
		dim idx : for idx = 0 to uBound(obj)
			if IsArray(obj(idx)) then
				'debugstr = debugstr & "array found at " & idx & "..."
				dim x, tmp : tmp = obj(idx) 'set tmp to array in order to access it
				for x = 0 to uBound(tmp)
					if typename(tmp(x)) = "Light" then DisableState tmp(x)' : debugstr = debugstr & tmp(x).name & " state'd" & vbnewline
					tmp(x).intensityscale = 0.001 ' this can prevent init stuttering
				Next
			Else
				if typename(obj(idx)) = "Light" then DisableState obj(idx)' : debugstr = debugstr & obj(idx).name & " state'd (not array)" & vbnewline
				obj(idx).intensityscale = 0.001 ' this can prevent init stuttering
			end if
		Next
		''debug.print debugstr
	End Sub
	Private Sub DisableState(ByRef aObj) : aObj.FadeSpeedUp = 1000 : aObj.State = 1 : End Sub	'turn state to 1

	Public Sub Init()	'Just runs TurnOnStates right now
		TurnOnStates
	End Sub

	Public Property Let Modulate(aIdx, aCoef) : Mult(aIdx) = aCoef : Lock(aIdx) = False : Loaded(aIdx) = False: End Property
	Public Property Get Modulate(aIdx) : Modulate = Mult(aIdx) : End Property

	Public Sub Update1()	 'Handle all boolean numeric fading. If done fading, Lock(x) = True. Update on a '1' interval Timer!
		dim x : for x = 0 to uBound(OnOff)
			if not Lock(x) then 'and not Loaded(x) then
				if OnOff(x) > 0 then 'Fade Up
					Lvl(x) = Lvl(x) + FadeSpeedUp(x)
					if Lvl(x) >= OnOff(x) then Lvl(x) = OnOff(x) : Lock(x) = True
				else 'fade down
					Lvl(x) = Lvl(x) - FadeSpeedDown(x)
					if Lvl(x) <= 0 then Lvl(x) = 0 : Lock(x) = True
				end if
			end if
		Next
	End Sub

	Public Sub Update2()	 'Both updates on -1 timer (Lowest latency, but less accurate fading at 60fps vsync)
		FrameTime = gametime - InitFrame : InitFrame = GameTime	'Calculate frametime
		dim x : for x = 0 to uBound(OnOff)
			if not Lock(x) then 'and not Loaded(x) then
				if OnOff(x) > 0 then 'Fade Up
					Lvl(x) = Lvl(x) + FadeSpeedUp(x) * FrameTime
					if Lvl(x) >= OnOff(x) then Lvl(x) = OnOff(x) : Lock(x) = True
				else 'fade down
					Lvl(x) = Lvl(x) - FadeSpeedDown(x) * FrameTime
					if Lvl(x) <= 0 then Lvl(x) = 0 : Lock(x) = True
				end if
			end if
		Next
		Update
	End Sub

	Public Sub Update()	'Handle object updates. Update on a -1 Timer! If done fading, loaded(x) = True
		dim x,xx, aLvl : for x = 0 to uBound(OnOff)
			if not Loaded(x) then
				aLvl = Lvl(x)*Mult(x)
				if IsArray(obj(x) ) Then	'if array
					If UseFunction then
						for each xx in obj(x) : xx.IntensityScale = cFilter(aLvl) : Next
					Else
						for each xx in obj(x) : xx.IntensityScale = aLvl : Next
					End If
				else						'if single lamp or flasher
					If UseFunction then
						obj(x).Intensityscale = cFilter(aLvl)
					Else
						obj(x).Intensityscale = aLvl
					End If
				end if
				'if TypeName(lvl(x)) <> "Double" and typename(lvl(x)) <> "Integer" and typename(lvl(x)) <> "Long" then msgbox "uhh " & 2 & " = " & lvl(x)
				'If UseCallBack(x) then execute cCallback(x) & " " & (Lvl(x))	'Callback
				If UseCallBack(x) then Proc name & x,aLvl	'Proc
				If Lock(x) Then
					if Lvl(x) = OnOff(x) or Lvl(x) = 0 then Loaded(x) = True	'finished fading
				end if
			end if
		Next
	End Sub
End Class


'Lamp Filter
Function LampFilter(aLvl)
	LampFilter = aLvl^1.6	'exponential curve?
End Function


'Helper functions
Sub Proc(string, Callback)	'proc using a string and one argument
	'On Error Resume Next
	dim p : Set P = GetRef(String)
	P Callback
	If err.number = 13 then  msgbox "Proc error! No such procedure: " & vbnewline & string
	if err.number = 424 then msgbox "Proc error! No such Object"
End Sub

Function AppendArray(ByVal aArray, aInput)	'append one value, object, or Array onto the end of a 1 dimensional array
	if IsArray(aInput) then 'Input is an array...
		dim tmp : tmp = aArray
		If not IsArray(aArray) Then	'if not array, create an array
			tmp = aInput
		Else						'Append existing array with aInput array
			Redim Preserve tmp(uBound(aArray) + uBound(aInput)+1)	'If existing array, increase bounds by uBound of incoming array
			dim x : for x = 0 to uBound(aInput)
				if isObject(aInput(x)) then
					Set tmp(x+uBound(aArray)+1 ) = aInput(x)
				Else
					tmp(x+uBound(aArray)+1 ) = aInput(x)
				End If
			Next
			AppendArray = tmp	 'return new array
		End If
	Else 'Input is NOT an array...
		If not IsArray(aArray) Then	'if not array, create an array
			aArray = Array(aArray, aInput)
		Else
			Redim Preserve aArray(uBound(aArray)+1)	'If array, increase bounds by 1
			if isObject(aInput) then
				Set aArray(uBound(aArray)) = aInput
			Else
				aArray(uBound(aArray)) = aInput
			End If
		End If
		AppendArray = aArray 'return new array
	End If
End Function

'******************************************************
'****  END LAMPZ
'******************************************************


'*******************************************
'  Ball brightness code
'*******************************************

if BallLightness = 0 Then
	table1.BallImage="ball-dark"
	table1.BallFrontDecal="JPBall-Scratches"
elseif BallLightness = 1 Then
	table1.BallImage="ball-HDR"
	table1.BallFrontDecal="Scratches"
elseif BallLightness = 2 Then
	table1.BallImage="ball-light-hf"
	table1.BallFrontDecal="g5kscratchedmorelight"
else
	table1.BallImage="ball-lighter-hf"
	table1.BallFrontDecal="g5kscratchedmorelight"
End if

' ****************************************************



'*******************************************
' Hybrid code for VR, Cab, and Desktop
'*******************************************

Dim VRThings

if VR_Room = 0 and cab_mode = 0 Then
	for each VRThings in VRStuff:VRThings.visible = 0:Next
	for each VRThings in VRClock:VRThings.visible = 0:Next
	for each VRThings in VRBackglass:VRThings.visible = 0:Next
	for each VRThings in DTRails:VRThings.visible = 1:Next
	OuterPrimBlack_dt.visible = 1
	OuterPrimBlack_cab_VR.visible = 0
	OuterPrimBlack_cab.visible = 0
	L_DT_Elektra.Visible = 1
	L_DT_Elektra2.Visible = 1
	L_DT_Elektra3.Visible = 1
	L_DT_Elektra_E.Visible = 1
	L_DT_Elektra_L.Visible = 1
	L_DT_Elektra_E.Visible = 1
	L_DT_Elektra_K.Visible = 1
	L_DT_Elektra_T.Visible = 1
	L_DT_Elektra_R.Visible = 1
	L_DT_Elektra_A.Visible = 1

Elseif VR_Room = 0 and cab_mode = 1 Then
	for each VRThings in VRStuff:VRThings.visible = 0:Next
	for each VRThings in VRClock:VRThings.visible = 0:Next
	for each VRThings in VRBackglass:VRThings.visible = 0:Next
	for each VRThings in DTBackglass:VRThings.visible = 0: Next
	for each VRThings in DTRails:VRThings.visible = 0:Next
	OuterPrimBlack_dt.visible = 0
	OuterPrimBlack_cab_VR.visible = 0
	OuterPrimBlack_cab.visible = 1
	L_DT_Elektra.Visible = 0
	L_DT_Elektra.State = 0
	L_DT_Elektra2.Visible = 0
	L_DT_Elektra2.State = 0
	L_DT_Elektra3.Visible = 0
	L_DT_Elektra3.State = 0
	L_DT_Elektra_E.Visible = 0
	L_DT_Elektra_L.Visible = 0
	L_DT_Elektra_E.Visible = 0
	L_DT_Elektra_K.Visible = 0
	L_DT_Elektra_T.Visible = 0
	L_DT_Elektra_R.Visible = 0
	L_DT_Elektra_A.Visible = 0
Else
	for each VRThings in VRStuff:VRThings.visible = 1:Next
	for each VRThings in VRClock:VRThings.visible = WallClock:Next
	for each VRThings in DTBackglass:VRThings.visible = 0: Next
	for each VRThings in DTRails:VRThings.visible = 0:Next
	OuterPrimBlack_dt.visible = 0
	OuterPrimBlack_cab_VR.visible = 1
	OuterPrimBlack_cab.visible = 0
	L_DT_Elektra.Visible = 0
	L_DT_Elektra.State = 0
	L_DT_Elektra2.Visible = 0
	L_DT_Elektra2.State = 0
	L_DT_Elektra3.Visible = 0
	L_DT_Elektra3.State = 0
	L_DT_Elektra_E.Visible = 0
	L_DT_Elektra_L.Visible = 0
	L_DT_Elektra_E.Visible = 0
	L_DT_Elektra_K.Visible = 0
	L_DT_Elektra_T.Visible = 0
	L_DT_Elektra_R.Visible = 0
	L_DT_Elektra_A.Visible = 0
'Custom Walls, Floor, and Roof
	if CustomWalls = 1 Then
		VR_Wall_Left.image = "VR_Wall_Left"
		VR_Wall_Right.image = "VR_Wall_Right"
		VR_Floor.image = "VR_Floor"
		VR_Roof.image = "VR_Roof"
	end if


	If topper = 1 Then
		Primary_topper.visible = 1
	Else
		Primary_topper.visible = 0
	End If

	If poster = 1 Then
		VRposter.visible = 1
	Else
		VRposter.visible = 0
	End If

	If poster2 = 1 Then
		VRposter2.visible = 1
	Else
		VRposter2.visible = 0
	End If

End If


'*******************************************
' VR Clock
'*******************************************

Dim CurrentMinute ' for VR clock

Sub ClockTimer_Timer()
	Pminutes.RotAndTra2 = (Minute(Now())+(Second(Now())/100))*6
	Phours.RotAndTra2 = Hour(Now())*30+(Minute(Now())/2)
	Pseconds.RotAndTra2 = (Second(Now()))*6
	CurrentMinute=Minute(Now())

End Sub


'*******************************************
' VR Plunger Code
'*******************************************

Sub TimerVRPlunger_Timer
  If PinCab_Shooter.Y < -300 then
       PinCab_Shooter.Y = PinCab_Shooter.Y + 5
  End If
End Sub

Sub TimerVRPlunger1_Timer
  PinCab_Shooter.Y = -390 + (5* Plunger.Position) -20
End Sub


'*******************************************
'Digital Display
'*******************************************

Dim Digits(34)
' 1st Player
Digits(0) = Array(LED10,LED11,LED12,LED13,LED14,LED15,LED16)
Digits(1) = Array(LED20,LED21,LED22,LED23,LED24,LED25,LED26)
Digits(2) = Array(LED30,LED31,LED32,LED33,LED34,LED35,LED36)
Digits(3) = Array(LED40,LED41,LED42,LED43,LED44,LED45,LED46)
Digits(4) = Array(LED50,LED51,LED52,LED53,LED54,LED55,LED56)
Digits(5) = Array(LED60,LED61,LED62,LED63,LED64,LED65,LED66)
Digits(6) = Array(LED70,LED71,LED72,LED73,LED74,LED75,LED76)

' 2nd Player
Digits(7) = Array(LED80,LED81,LED82,LED83,LED84,LED85,LED86)
Digits(8) = Array(LED90,LED91,LED92,LED93,LED94,LED95,LED96)
Digits(9) = Array(LED100,LED101,LED102,LED103,LED104,LED105,LED106)
Digits(10) = Array(LED110,LED111,LED112,LED113,LED114,LED115,LED116)
Digits(11) = Array(LED120,LED121,LED122,LED123,LED124,LED125,LED126)
Digits(12) = Array(LED130,LED131,LED132,LED133,LED134,LED135,LED136)
Digits(13) = Array(LED140,LED141,LED142,LED143,LED144,LED145,LED146)

' 3rd Player
Digits(14) = Array(LED150,LED151,LED152,LED153,LED154,LED155,LED156)
Digits(15) = Array(LED160,LED161,LED162,LED163,LED164,LED165,LED166)
Digits(16) = Array(LED170,LED171,LED172,LED173,LED174,LED175,LED176)
Digits(17) = Array(LED180,LED181,LED182,LED183,LED184,LED185,LED186)
Digits(18) = Array(LED190,LED191,LED192,LED193,LED194,LED195,LED196)
Digits(19) = Array(LED200,LED201,LED202,LED203,LED204,LED205,LED206)
Digits(20) = Array(LED210,LED211,LED212,LED213,LED214,LED215,LED216)

' 4th Player
Digits(21) = Array(LED220,LED221,LED222,LED223,LED224,LED225,LED226)
Digits(22) = Array(LED230,LED231,LED232,LED233,LED234,LED235,LED236)
Digits(23) = Array(LED240,LED241,LED242,LED243,LED244,LED245,LED246)
Digits(24) = Array(LED250,LED251,LED252,LED253,LED254,LED255,LED256)
Digits(25) = Array(LED260,LED261,LED262,LED263,LED264,LED265,LED266)
Digits(26) = Array(LED270,LED271,LED272,LED273,LED274,LED275,LED276)
Digits(27) = Array(LED280,LED281,LED282,LED283,LED284,LED285,LED286)

' Credits
Digits(28) = Array(LED4,LED2,LED6,LED7,LED5,LED1,LED3)
Digits(29) = Array(LED18,LED9,LED27,LED28,LED19,LED8,LED17)

' Balls
Digits(30) = Array(LED39,LED37,LED48,LED49,LED47,LED29,LED38)
Digits(31) = Array(LED67,LED58,LED69,LED77,LED68,LED57,LED59)

'Elektra Units
Digits(32) = Array(LED88,LED79,LED97,LED98,LED89,LED78,LED87)
Digits(33) = Array(LED109,LED107,LED118,LED119,LED117,LED99,LED108)


Sub DisplayTimer
	Dim ChgLED,ii,num,chg,stat,obj
	ChgLed = Controller.ChangedLEDs(&Hffffffff, &Hffffffff)
	If Not IsEmpty(ChgLED) Then
		For ii = 0 To UBound(chgLED)
			num = chgLED(ii, 0) : chg = chgLED(ii, 1) : stat = chgLED(ii, 2)
			if (num < 34) then
				For Each obj In Digits(num)
					If cab_mode = 1 OR VR_Room =1 Then
						obj.intensity=0
					Else
						obj.intensity=30
					End If
					If chg And 1 Then obj.State = stat And 1 
					chg = chg\2 : stat = stat\2
				Next
			end If
		next
	end if
End Sub


'*******************************************
' Setup Backglass
'*******************************************

Dim xoff,yoff,zoff,xrot,zscale, xcen,ycen, ix, xx, yy, xobj

Sub setup_backglass()

	xoff = -20
	yoff = 50 '78
	zoff = 699
	xrot = -90
	zscale = 0.0000001

	xcen = 0  '(130 /2) - (92 / 2)
	ycen = (780 /2 ) + (203 /2)

	for ix = 0 to 33
		For Each xobj In VRDigits(ix)

			xx = xobj.x  
				
			xobj.x = (xoff - xcen) + xx
			yy = xobj.y ' get the yoffset before it is changed
			xobj.y = yoff 

			If (yy < 0.) then
				yy = yy * -1
			end if

			xobj.height = (zoff - ycen) + yy - (yy * (zscale))
			xobj.rotx = xrot
		Next
	Next
end sub


Dim VRDigits(34)
' 1st Player
VRDigits(0) = Array(LED1x0,LED1x1,LED1x2,LED1x3,LED1x4,LED1x5,LED1x6)
VRDigits(1) = Array(LED2x0,LED2x1,LED2x2,LED2x3,LED2x4,LED2x5,LED2x6)
VRDigits(2) = Array(LED3x0,LED3x1,LED3x2,LED3x3,LED3x4,LED3x5,LED3x6)
VRDigits(3) = Array(LED4x0,LED4x1,LED4x2,LED4x3,LED4x4,LED4x5,LED4x6)
VRDigits(4) = Array(LED5x0,LED5x1,LED5x2,LED5x3,LED5x4,LED5x5,LED5x6)
VRDigits(5) = Array(LED6x0,LED6x1,LED6x2,LED6x3,LED6x4,LED6x5,LED6x6)
VRDigits(6) = Array(LED7x0,LED7x1,LED7x2,LED7x3,LED7x4,LED7x5,LED7x6)

' 2nd Player
VRDigits(7) = Array(LED8x0,LED8x1,LED8x2,LED8x3,LED8x4,LED8x5,LED8x6)
VRDigits(8) = Array(LED9x0,LED9x1,LED9x2,LED9x3,LED9x4,LED9x5,LED9x6)
VRDigits(9) = Array(LED10x0,LED10x1,LED10x2,LED10x3,LED10x4,LED10x5,LED10x6)
VRDigits(10) = Array(LED11x0,LED11x1,LED11x2,LED11x3,LED11x4,LED11x5,LED11x6)
VRDigits(11) = Array(LED12x0,LED12x1,LED12x2,LED12x3,LED12x4,LED12x5,LED12x6)
VRDigits(12) = Array(LED13x0,LED13x1,LED13x2,LED13x3,LED13x4,LED13x5,LED13x6)
VRDigits(13) = Array(LED14x0,LED14x1,LED14x2,LED14x3,LED14x4,LED14x5,LED14x6)

' 3rd Player
VRDigits(14) = Array(LED1x000,LED1x001,LED1x002,LED1x003,LED1x004,LED1x005,LED1x006)
VRDigits(15) = Array(LED1x100,LED1x101,LED1x102,LED1x103,LED1x104,LED1x105,LED1x106)
VRDigits(16) = Array(LED1x200,LED1x201,LED1x202,LED1x203,LED1x204,LED1x205,LED1x206)
VRDigits(17) = Array(LED1x300,LED1x301,LED1x302,LED1x303,LED1x304,LED1x305,LED1x306)
VRDigits(18) = Array(LED1x400,LED1x401,LED1x402,LED1x403,LED1x404,LED1x405,LED1x406)
VRDigits(19) = Array(LED1x500,LED1x501,LED1x502,LED1x503,LED1x504,LED1x505,LED1x506)
VRDigits(20) = Array(LED1x600,LED1x601,LED1x602,LED1x603,LED1x604,LED1x605,LED1x606)

' 4th Player
VRDigits(21) = Array(LED2x000,LED2x001,LED2x002,LED2x003,LED2x004,LED2x005,LED2x006)
VRDigits(22) = Array(LED2x100,LED2x101,LED2x102,LED2x103,LED2x104,LED2x105,LED2x106)
VRDigits(23) = Array(LED2x200,LED2x201,LED2x202,LED2x203,LED2x204,LED2x205,LED2x206)
VRDigits(24) = Array(LED2x300,LED2x301,LED2x302,LED2x303,LED2x304,LED2x305,LED2x306)
VRDigits(25) = Array(LED2x400,LED2x401,LED2x402,LED2x403,LED2x404,LED2x405,LED2x406)
VRDigits(26) = Array(LED2x500,LED2x501,LED2x502,LED2x503,LED2x504,LED2x505,LED2x506)
VRDigits(27) = Array(LED2x600,LED2x601,LED2x602,LED2x603,LED2x604,LED2x605,LED2x606)

' Credits
VRDigits(28) = Array(LEDax300,LEDax301,LEDax302,LEDax303,LEDax304,LEDax305,LEDax306)
VRDigits(29) = Array(LEDbx400,LEDbx401,LEDbx402,LEDbx403,LEDbx404,LEDbx405,LEDbx406)

' Balls
VRDigits(30) = Array(LEDcx500,LEDcx501,LEDcx502,LEDcx503,LEDcx504,LEDcx505,LEDcx506)
VRDigits(31) = Array(LEDdx600,LEDdx601,LEDdx602,LEDdx603,LEDdx604,LEDdx605,LEDdx606)

'Elektra Units
VRDigits(32) = Array(LEDex700,LEDex701,LEDex702,LEDex703,LEDex704,LEDex705,LEDex706)
VRDigits(33) = Array(LEDfx800,LEDfx801,LEDfx802,LEDfx803,LEDfx804,LEDfx805,LEDfx806)

dim DisplayColor
DisplayColor =  RGB(255,40,1)

Sub VRDisplayTimer
	Dim ii, jj, obj, b, x
	Dim ChgLED,num, chg, stat
	ChgLED=Controller.ChangedLEDs(&Hffffffff, &Hffffffff)
		If Not IsEmpty(ChgLED) Then
			For ii=0 To UBound(chgLED)
				num=chgLED(ii, 0) : chg=chgLED(ii, 1) : stat=chgLED(ii, 2)
				For Each obj In VRDigits(num)
 '                  If chg And 1 Then obj.visible=stat And 1    'if you use the object color for off; turn the display object visible to not visible on the playfield, and uncomment this line out.
					If chg And 1 Then FadeDisplay obj, stat And 1	
					chg=chg\2 : stat=stat\2
				Next
			Next
		End If
End Sub

Sub FadeDisplay(object, onoff)
	If OnOff = 1 Then
		object.color = DisplayColor
		Object.Opacity = 20
	Else
		Object.Color = RGB(1,1,1)
		Object.Opacity = 8
	End If
End Sub

Sub InitDigits()
	dim tmp, x, obj
	for x = 0 to uBound(VRDigits)
		if IsArray(VRDigits(x) ) then
			For each obj in VRDigits(x)
				obj.height = obj.height + 0
				FadeDisplay obj, 0
			next
		end If
	Next
End Sub

If VR_Room=1 Then
	InitDigits
End If

'*******************************************
' LAMP CALLBACK for the 6 backglass flasher lamps (not the solenoid conrolled ones)
'*******************************************


if VR_Room = 0 and cab_mode = 0 Then
	Set LampCallback = GetRef("UpdateDTLamps")
End If

if VR_Room = 1 Then
	Set LampCallback = GetRef("UpdateVRLamps")
End If

Sub UpdateDTLamps()

	If Controller.Lamp(11) = 0 Then: ShootAgainReel.setValue(0):	Else: ShootAgainReel.setValue(1) 'Shoot Again
	If Controller.Lamp(13) = 0 Then: BIPReel.setValue(0):			Else: BIPReel.setValue(1) 'Ball in Play
	If Controller.Lamp(61) = 0 Then: TiltReel.setValue(0):			Else: TiltReel.setValue(1) 'Tilt
	If Controller.Lamp(45) = 0 Then: GameOverReel.setValue(0):		Else: GameOverReel.setValue(1) 'Game Over
	If Controller.Lamp(27) = 0 Then: MatchReel.setValue(0):			Else: MatchReel.setValue(1) 'Match
	If Controller.Lamp(29) = 0 Then: HighScoreReel.setValue(0):		Else: HighScoreReel.setValue(1) 'High Score
End Sub

Sub UpdateVRLamps()
	If Controller.Lamp(11) = 0 Then: FlBGL1.visible=0: else: FlBGL1.visible=1 'Shoot again
	If Controller.Lamp(13) = 0 Then: FlBGL2.visible=0: else: FlBGL2.visible=1 'Ball in  play
	If Controller.Lamp(61) = 0 Then: FlBGL3.visible=0: else: FlBGL3.visible=1 'Tilt
	If Controller.Lamp(45) = 0 Then: FlBGL4.visible=0: else: FlBGL4.visible=1 'Game Over
	If Controller.Lamp(27) = 0 Then: FlBGL5.visible=0: else: FlBGL5.visible=1 'Match
	If Controller.Lamp(29) = 0 Then: FlBGL6.visible=0: else: FlBGL6.visible=1 'High Score
End Sub


'*******************************************
' GI Routines
'*******************************************

dim gilvl:gilvl = 1
dim gamestart: gamestart = 0

Sub GIUpdates(ByVal aLvl)
	dim x, girubbercolor, girubbercolorLow, giflippercolor
	gilvl = alvl

	if alvl = 1 then 
		gamestart = 1
	end If

	if Lampz.UseFunction then aLvl = LampFilter(aLvl)	'Callbacks don't get this filter automatically

	dim mm,bp, bpl

	if vr_room = 0 and cab_mode = 0 then

		L_DT_Elektra2.state = 1
		L_DT_Elektra3.state = 1
		L_DT_Elektra2.Intensityscale = aLvl

		L_DT_Elektra_E.Intensityscale  = (1-aLvl)
		L_DT_Elektra_L.Intensityscale  = (1-aLvl)
		L_DT_Elektra_E2.Intensityscale  = (1-aLvl)
		L_DT_Elektra_K.Intensityscale  = (1-aLvl)
		L_DT_Elektra_T.Intensityscale  = (1-aLvl)
		L_DT_Elektra_R.Intensityscale  = (1-aLvl)
		L_DT_Elektra_A.Intensityscale  = (1-aLvl)

	Else

		L_DT_Elektra.state  = 0
		L_DT_Elektra2.state = 0
		L_DT_Elektra3.state = 1

	end if

if gamestart = 0 then '(This is at start of game, where both upper and lower GI is off.)

	For each mm in GI2:mm.Intensityscale = 0: Next 'GI Mini PF
	For each xx in GI:xx.Intensityscale = 0 : Next 'GI Main/Upper PF
	For each bp in BlackPlastics:bp.visible = 0 : Next 'Black Plastics Under Layer
	For each bpl in BlackPlasticsUnder:bpl.visible = 0 : Next 'Black Plastics Under Layer
	L_DT_Elektra3.Intensityscale = 0
	Wall_clear_glass_top.visible = 1
	Wall_clear_glass.visible = 0

' flippers
	Lflipmesh1.blenddisablelighting = .025
	Rflipmesh1.blenddisablelighting = .025
	LflipmeshUp.blenddisablelighting = .025
	RflipmeshUp.blenddisablelighting = .025

	giflippercolor = 46
	MaterialColor "Rubber Red",RGB(giflippercolor,0,0)

' targets
	For each x in GITargets
		x.blenddisablelighting = .1
	Next

	For each x in GITargetsLow
		x.blenddisablelighting = .1
	Next

' prims (Red Pegs)
	For each x in GIPegs
		x.blenddisablelighting = .005
	Next

	For each x in GIPegsLow
		x.blenddisablelighting = .005
	Next

' prims (Cutouts)
	For each x in GICutoutPrims
		x.blenddisablelighting = .15
	Next

	For each x in GICutoutPrimsLow
		x.blenddisablelighting = .15
	Next

	For each x in GICutoutWalls
		x.blenddisablelighting = .2
	Next

' prims (Spinner, apron, brackets)

	SpinnerPrim1.blenddisablelighting = .1
	SpinnerPrim2.blenddisablelighting = .1

	AprinPrim.blenddisablelighting = .05
	PlungerCover.blenddisablelighting = .05
	pKickerArm.blenddisablelighting = .1
	pKickerArmUp.blenddisablelighting = .1

' prims (ramps)

	Metal_Ramps_Visual.blenddisablelighting = .025

' prims (White Screws Main)
	For each x in ScrewWhiteCaps
		x.blenddisablelighting = 0
	Next

	For each x in ScrewWhiteCapsLow
		x.blenddisablelighting = 0
	Next

' rubbers
	girubbercolor = 64
	MaterialColor "Rubber White",RGB(girubbercolor,girubbercolor,girubbercolor)

	girubbercolorLow = 64
	MaterialColor "Rubber White Low",RGB(girubbercolorLow,girubbercolorLow,girubbercolorLow)

'to make sure this flasher is not visible initially
	FlasherUnderGI.opacity = 0

end If


if gamestart = 1 then '(GI is now controlled via ROM once game is started up.)
	For each mm in GI2:mm.Intensityscale = (1-aLvl): Next 'GI Mini PF
	For each xx in GI:xx.Intensityscale = aLvl: Next 'GI Main/Upper PF
	L_DT_Elektra3.Intensityscale = 1

' Clear playfield glass and black plastic layer
	if aLvl = 1 Then
		Wall_clear_glass_top.visible = 1
		Wall_clear_glass.visible = 0
	For each bp in BlackPlastics:bp.visible = 1 : Next 'Black Plastics Under Layer
	For each bpl in BlackPlasticsUnder:bpl.visible = 0 : Next 'Black Plastics Under Layer
	Else
		Wall_clear_glass_top.visible = 0
		Wall_clear_glass.visible = 1
	For each bp in BlackPlastics:bp.visible = 0 : Next 'Black Plastics Under Layer
	For each bpl in BlackPlasticsUnder:bpl.visible = 1 : Next 'Black Plastics Under Layer
	End If

' flippers
	Lflipmesh1.blenddisablelighting = 0.1 * alvl + .025
	Rflipmesh1.blenddisablelighting = 0.1 * alvl + .025
	LflipmeshUp.blenddisablelighting = 0.1 * alvl + .025
	RflipmeshUp.blenddisablelighting = 0.1 * alvl + .025

	giflippercolor = 92* (1-alvl) + 46
	MaterialColor "Rubber Red",RGB(giflippercolor,0,0)

' targets
	For each x in GITargets
		x.blenddisablelighting = 0.25 * alvl + .1
	Next

	For each x in GITargetsLow
		x.blenddisablelighting = 0.25 * (1-alvl) + .1
	Next

' prims (Red Pegs)
	For each x in GIPegs
		x.blenddisablelighting = .015 * alvl + .005
	Next

	For each x in GIPegsLow
		x.blenddisablelighting = .015 * (1-alvl) + .005
	Next

' prims (Cutouts)
	For each x in GICutoutPrims
		x.blenddisablelighting = .25 * alvl + .15
	Next

	For each x in GICutoutPrimsLow
		x.blenddisablelighting = .25 * (1-alvl) + .15
	Next

	For each x in GICutoutWalls
		x.blenddisablelighting = .1 * alvl + .2
	Next

' prims (Spinner, apron, brackets)

	SpinnerPrim1.blenddisablelighting = 0.2 * alvl + .1
	SpinnerPrim2.blenddisablelighting = 0.2 * alvl + .1

	AprinPrim.blenddisablelighting = 0.15 * alvl + .05
	PlungerCover.blenddisablelighting = 0.15 * alvl + .05
	pKickerArm.blenddisablelighting = 0.2 * alvl + .1
	pKickerArmUp.blenddisablelighting = 0.2 * alvl + .1

' prims (ramps)

	Metal_Ramps_Visual.blenddisablelighting = 0.05 * alvl + .025

' prims (White Screws Main)
	For each x in ScrewWhiteCaps
		x.blenddisablelighting = .1 * alvl
	Next

	For each x in ScrewWhiteCapsLow
		x.blenddisablelighting = .1 * (1-alvl)
	Next

' rubbers
	girubbercolor = 128*alvl + 64
	MaterialColor "Rubber White",RGB(girubbercolor,girubbercolor,girubbercolor)

	girubbercolorLow = 128*(1-alvl) + 64
	MaterialColor "Rubber White Low",RGB(girubbercolorLow,girubbercolorLow,girubbercolorLow)

'GI PF bakes
	FlasherUnderGI.opacity = 340 * (1-gilvl)

End If


'GI PF bakes
	FlasherGI.opacity = 300 * gilvl
	FlasherUpperGI.opacity = 300 * gilvl
'	msgbox gilvl & " --> " & FlasherUnderGI.opacity



' relaysounds for GI
	if gilvl = 1 then
		Sound_GI_Relay 1, Relay_GI
	end If

	if gilvl = 0 then
		Sound_GI_Relay 0, Relay_GI
	end If


End Sub



'*******************************************
' Backglass GI and lamps
'*******************************************

Sub SolBGGI(Enabled)
dim XBG
	If Enabled Then
		For each XBG in VRBGSol
			XBG.visible = 1
		Next
		VR_Backglass.blenddisablelighting = 2.5
		if cab_mode=0 and vr_room =0 then
			L_DT_Elektra.state  = 1
			L_DT_Elektra.Intensityscale  = 1
		end If
	Else
		For each XBG in VRBGSol
			XBG.visible = 0
		Next
		VR_Backglass.blenddisablelighting = 1.5
		L_DT_Elektra.state  = 0
		L_DT_Elektra.Intensityscale  = 0
	End If
End Sub

Sub BG15(ByVal aLvl)
	dim bglvl
	bglvl = aLvl
	if Lampz.UseFunction then aLvl = LampFilter(aLvl)	'Callbacks don't get this filter automatically
	
	if bglvl = 0 then
		BGL15.visible = 0
	else
		BGL15.visible = 1
	end If
End Sub

Sub BG30(ByVal aLvl)
	dim bglvl
	bglvl = aLvl
	if Lampz.UseFunction then aLvl = LampFilter(aLvl)	'Callbacks don't get this filter automatically
	
	if bglvl = 0 then
		BGL30.visible = 0
		BGL30a.visible = 0
	else
		BGL30.visible = 1
		BGL30a.visible = 1
	end If
End Sub

Sub BG31(ByVal aLvl)
	dim bglvl
	bglvl = aLvl
	if Lampz.UseFunction then aLvl = LampFilter(aLvl)	'Callbacks don't get this filter automatically
	
	if bglvl = 0 then
		BGL31.visible = 0
		BGL31a.visible = 0
	else
		BGL31.visible = 1
		BGL31a.visible = 1
	end If
End Sub

Sub BG46(ByVal aLvl)
	dim bglvl
	bglvl = aLvl
	if Lampz.UseFunction then aLvl = LampFilter(aLvl)	'Callbacks don't get this filter automatically
	
	if bglvl = 0 then
		BGL46.visible = 0
	else
		BGL46.visible = 1
	end If
End Sub

Sub BG62(ByVal aLvl)
	dim bglvl
	bglvl = aLvl
	if Lampz.UseFunction then aLvl = LampFilter(aLvl)	'Callbacks don't get this filter automatically
	
	if bglvl = 0 then
		BGL62.visible = 0
	else
		BGL62.visible = 1
	end If
End Sub

Sub BG68(ByVal aLvl) 'E
	dim bglvl
	bglvl = aLvl
	if Lampz.UseFunction then aLvl = LampFilter(aLvl)	'Callbacks don't get this filter automatically
	
	if bglvl = 0 then
		BGL68.visible = 0
		L_DT_Elektra_E.state = 0
	else
		If vr_room = 1 then
			BGL68.visible = 1
		Elseif cab_mode = 0 Then
			L_DT_Elektra_E.state = 1
		Else
			BGL68.visible = 0
			L_DT_Elektra_E.state = 0
		End If
	end If
End Sub

Sub BG84(ByVal aLvl) 'L
	dim bglvl
	bglvl = aLvl
	if Lampz.UseFunction then aLvl = LampFilter(aLvl)	'Callbacks don't get this filter automatically
	
	if bglvl = 0 then
		BGL84.visible = 0
		L_DT_Elektra_L.state = 0
	else
		If vr_room = 1 then
			BGL84.visible = 1
		Elseif cab_mode = 0 Then
			L_DT_Elektra_L.state = 1
		Else
			BGL84.visible = 0
			L_DT_Elektra_L.state = 0
		End If
	End If
End Sub

Sub BG100(ByVal aLvl) 'E2
	dim bglvl
	bglvl = aLvl
	if Lampz.UseFunction then aLvl = LampFilter(aLvl)	'Callbacks don't get this filter automatically
	
	if bglvl = 0 then
		BGL100.visible = 0
		L_DT_Elektra_E2.state = 0
	else
		If vr_room = 1 then
			BGL100.visible = 1
		Elseif cab_mode = 0 Then
			L_DT_Elektra_E2.state = 1
		Else
			BGL100.visible = 0
			L_DT_Elektra_E2.state = 0
		End If
	End If
End Sub

Sub BG115(ByVal aLvl) 'K
	dim bglvl
	bglvl = aLvl
	if Lampz.UseFunction then aLvl = LampFilter(aLvl)	'Callbacks don't get this filter automatically
	
	if bglvl = 0 then
		BGL115.visible = 0
		L_DT_Elektra_K.state = 0
	else
		If vr_room = 1 then
			BGL115.visible = 1
		Elseif cab_mode = 0 Then
			L_DT_Elektra_K.state = 1
		Else
			BGL115.visible = 0
			L_DT_Elektra_K.state = 0
		End If
	End If
End Sub

Sub BG101(ByVal aLvl) 'T
	dim bglvl
	bglvl = aLvl
	if Lampz.UseFunction then aLvl = LampFilter(aLvl)	'Callbacks don't get this filter automatically
	
	if bglvl = 0 then
		BGL101.visible = 0
		L_DT_Elektra_T.state = 0
	else
		If vr_room = 1 then
			BGL101.visible = 1
		Elseif cab_mode = 0 Then
			L_DT_Elektra_T.state = 1
		Else
			BGL101.visible = 0
			L_DT_Elektra_T.state = 0
		End If
	End If
End Sub

Sub BG85(ByVal aLvl) 'R
	dim bglvl
	bglvl = aLvl
	if Lampz.UseFunction then aLvl = LampFilter(aLvl)	'Callbacks don't get this filter automatically
	
	if bglvl = 0 then
		BGL85.visible = 0
		L_DT_Elektra_R.state = 0
	else
		If vr_room = 1 then
			BGL85.visible = 1
		Elseif cab_mode = 0 Then
			L_DT_Elektra_R.state = 1
		Else
			BGL85.visible = 0
			L_DT_Elektra_R.state = 0
		End If
	End If
End Sub

Sub BG69(ByVal aLvl) 'A
	dim bglvl
	bglvl = aLvl
	if Lampz.UseFunction then aLvl = LampFilter(aLvl)	'Callbacks don't get this filter automatically
	
	if bglvl = 0 then
		BGL69.visible = 0
		L_DT_Elektra_A.state = 0
	else
		If vr_room = 1 then
			BGL69.visible = 1
		Elseif cab_mode = 0 Then
			L_DT_Elektra_A.state = 1
		Else
			BGL69.visible = 0
			L_DT_Elektra_A.state = 0
		End If
	End If
End Sub

'*******************************************
' Set Up Backglass Flashers
'   this is for lining up the backglass flashers on top of a backglass image
'*******************************************

Sub SetBackglass()
	Dim obj

	For Each obj In VRBackglassFlash
		obj.x = obj.x
		obj.height = - obj.y
		obj.y = 60 '78 'adjusts the distance from the backglass towards the user
	Next

End Sub

'*******************************************
' LUT
'*******************************************

Dim bLutActive

Sub SetLUT
	Table1.ColorGradeImage = "LUT" & LUTset
	VRFlashLUT.imageA = "FlashLUT" & LUTset
end sub 

Sub LUTBox_Timer
	LUTBox.TimerEnabled = 0 
	LUTBox.Visible = 0
	VRFlashLUT.opacity = 0
End Sub

Sub ShowLUT
	LUTBox.visible = 1
	VRFlashLUT.opacity = 100
	Select Case LUTSet
		Case 0: LUTBox.text = "Fleep Natural Dark 1"
		Case 1: LUTBox.text = "Fleep Natural Dark 2"
		Case 2: LUTBox.text = "Fleep Warm Dark"
		Case 3: LUTBox.text = "Fleep Warm Bright"
		Case 4: LUTBox.text = "Fleep Warm Vivid Soft"
		Case 5: LUTBox.text = "Fleep Warm Vivid Hard"
		Case 6: LUTBox.text = "Skitso Natural and Balanced"
		Case 7: LUTBox.text = "Skitso Natural High Contrast"
		Case 8: LUTBox.text = "3rdaxis Referenced THX Standard"
		Case 9: LUTBox.text = "CalleV Punchy Brightness and Contrast"
		Case 10: LUTBox.text = "HauntFreaks Desaturated"
  		Case 11: LUTBox.text = "Tomate washed out"
        Case 12: LUTBox.text = "VPW original 1on1"
        Case 13: LUTBox.text = "bassgeige"
        Case 14: LUTBox.text = "blacklight"
        Case 15: LUTBox.text = "B&W Comic Book"
        Case 16: LUTBox.text = "Skitso New Warmer LUT"
        Case 17: LUTBox.text = "Original LUT"
	End Select

	LUTBox.TimerEnabled = 1

End Sub

Sub SaveLUT
	Dim FileObj
	Dim ScoreFile

	Set FileObj=CreateObject("Scripting.FileSystemObject")
	If Not FileObj.FolderExists(UserDirectory) then 
		Exit Sub
	End if

	if LUTset = "" then LUTset = 16 'failsafe to original

	Set ScoreFile=FileObj.CreateTextFile(UserDirectory & "Elektra_LUT.txt",True)
	ScoreFile.WriteLine LUTset
	Set ScoreFile=Nothing
	Set FileObj=Nothing
End Sub


Sub LoadLUT
	Dim FileObj, ScoreFile, TextStr
	dim rLine

	Set FileObj=CreateObject("Scripting.FileSystemObject")
	If Not FileObj.FolderExists(UserDirectory) then 
		LUTset=16
		Exit Sub
	End if
	If Not FileObj.FileExists(UserDirectory & "Elektra_LUT.txt") then
		LUTset=16
		Exit Sub
	End if
	Set ScoreFile=FileObj.GetFile(UserDirectory & "Elektra_LUT.txt")
	Set TextStr=ScoreFile.OpenAsTextStream(1,0)
		If (TextStr.AtEndOfStream=True) then
			Exit Sub
		End if
		rLine = TextStr.ReadLine
		If rLine = "" then
			LUTset=16
			Exit Sub
		End if
		LUTset = int (rLine) 
		Set ScoreFile = Nothing
	    Set FileObj = Nothing
End Sub

Sub ShowLUT_Init
	LUTBox.visible = 0
End Sub


'******** Revisions done by UnclePaulie on Hybrid version 0.01 - 2.0 *********

' v.01	Enabled hybrid code for desktop, VR, and cabinet modes
'		Started updating code to make current.  Removed old sounds. added Fleep.
'		Added fastflips and turned off in game AO and ScrSp Reflections
'		Updated the base table physics, environment images, background colors, and basics.  
'		Loaded in various images, materials, sounds, etc.
'		Added VR primitives and associated code.
' 		Added lighter ball images provided by hauntfreaks and g5k ball scratches, changeable in script 
' 		Updated POV for cab
' 		Updated LUT's to additional images, and new subroutines, and ability to save to user text file.
'		Updated desktop backglass image to something less busy.  Also added new topper image for VR.
'		Changed the envrionment lighting.
' v.02	The playfields were all above the main table.  0, 85, 150.  Needed to move them down like real table.  Moved down to -85, 0, 65.
'		Had to adjust the rendering to not be static of the lower playfield.
' v.03	Flippers adjustments, as they placed wrong, and too long.
'		Removed flipper timer and added the rotation of the side diverter to it.
'		Updated the DT backglass lamps, images, locations.
' v.04	Redbone updated the playfield, spinner, apron, and plastics images.  Started with a completely new image and sized accordingly.
'		Started new placement of everything.  Walls, flippers, apron, plunger, outer prims
'		Put apron physics in.  Updated gate physics
'		Added new slings and sling animations and code
'		Changed the diverter logic to include entering plunger lane
' 		Added a ramp angle behind the saucer. Much more accurate ball entering.
'		Redid all rubbers
'		Added a new spinner prim with an animated spinner rod. 
' v.05	Completely changed the trough logic to handle balls on table
'		Implemented knocker solenoid 
'		Changed to new method of controlling saucers.
' 		No longer destroy balls.  
' v.06	Removed all the getballs calls and am only useing gBOT.  Will help eliminate stutter on slower CPU machines
' 		Added code for VPW physics, flippers, shadows, etc.
'		Adjusted the physics of flippers, slings, and table. 
' 		Added Apophis sling corrections to top and bottom slings, and updated the sling physics.
' 		Added nFozzy / Roth physics and flippers.  Updated the flipper physics per recommendations.
'		Added code for DT, ST, slingshot corrections, flippers, physics, dampeners, shadows
'		Added VPW Dynamic Ball Shadows to the solution done Iakki, Apophis, and Wylte.  
' v.07	Added new drop and standup targets to the solution done by Rothbauerw.  
'		Had to mod the stand up target code to work with multiple stand ups activating the same switch.
'		Added lower flipper functionalality and flipper tricks
' v.08	Added physics all element physics and sound routines.
'		Updated the top leaf standoffs and assigned the vpmpulses to the associated physics rubber hits.
'		Redid the walls to be walls and new images and material.  Removed the "ramp" walls.
'		Adjusted the top gate postions.
' v.09	Modified the existing plastic prims to aling with new table layouts.
'		Added physics walls under all plastics.
'		Added a ramp prim for the right plunger ramp on left and right.  
'		Enabled the game over, tilt, bip, etc. 
' 		Changed the lane guides and ramp sides to zCol_MetalFO.
'		Changed to new spinner and drop target images.
'		Adjusted day/night slider
' v.10	Converted to Lampz
' 		The lamps are not defined in manual.  32assassin went through the work to figure them out in a prior version.  I used his assignments.
'		Handled the brightness of the solid inserts for GI on and off
'		Reshaped the playfield glass insert 
'		Updated the upper and lower playfield rollover targets with 3D prims, tied to lampz.  Also changed the depth bias on lower prims.
'		Added new insert lights, and 3D insert primitives, as well as credit light.
'		Added insert light blooms
'   	Updated the playfield for 3D inserts, slings, triggers holes, and target holes, and added plywood hole images.
'		Added bulb primitives for all the GI.
' v.11	Completely redid the GI.  center GI light for bulb, top plastics light, and a playfield light that gets shadowed by other objects.
' v.12	Expanded the physical wall behind top left flipper.  ball snuck behind it once.
'		Added images for the text overlay on the insert prims (just basic, will need to clean up later)
'		Modified the plastic walls and images.
'		Created new walls and plastics images for upper and main playfield.  At least the first pass.
'		Changed the flat white inserts to be more solid white when off (closer to real table... can't see bulb.)
'		Corrected some colors on inserts based off of restoration video ( https://www.youtube.com/watch?v=b5MGkBQKEcY )
'		Added all metal screws and white screw caps
' v.13	There wasn't any sounds on ramps or upper level; added code to allow for upper level.
'		Moved the cab bottom down, as it could be seen in VR and camera mode
'		Increased the visible height of Ramp21... the hole in PF.
'		Matched lower playfield physics to be same as other playfields.
'		Added a "MiniPFBallReflectionMask" trigger.  To block the reflections of ball over the middle glass.
' 		Raised the apron a little taller.  Added a prim for the plunger stop.
'		Added VR cab and backbox images.  
'		Changed playfield alpha channel to 132.  Text overlay images to 50.
' v.14	Updated the VR primitives to better match the real table.
' v.15	Changed the round non-white insert prims, to smooth, and added a bulb in them.
' v.16	Added main and upper playfield mesh.  For bevels into saucers.
'		Added new saucer prims, and added code to move the kickout arm primitive.
'		Adjusted the GI playfield to go around the saucer areas.
' 		Added a wall under the flippers in case issue with playfield mesh.
'		Modified the flipper physics to align with VPW recommendations.
'		Adjusted the environmental lighting, and day/night slider.
' v.17	Adjusted the wall colors and material
'		Added additional code to turn off ballreflections over minipf.
'		Added GI routine to Lampz, and adjusted the disablelighting of posts, sleeves, targets, flippers, apron, spinners, rubbers, etc.
' v.18	Updated dynamic shadows.  Added code to ensure shadows don't ever go into plunger lane.  
'		Added code to ensure lower level GI is off at game start. 
'		Added code to turn all shadows off on lower level.
' 		Adjusted the lower level flippers as they were too bouncy.
'		Changed the upper level ball capture area.
' v.19 	Slight saucer strength and angle adjustment
'		Updated the VR Backglass lights, displays, blenddisable, etc.
'		Enhanced desktop mode backglass lights for ELEKTRA and the lady.
'		Slight adjustment to wall ends by main flippers.  
'		Slight dampening adjustment to gates.
'		Hours spent on studying videos for shots, physics, etc.
'		Adjusted plunger speed to accurately hit upper left flipper
'		Adjusted top saucer strength to come out to left side of rubber in middle
'		Added saucer angle variance, and ensured the ball hit left, middle, and right of target in the under section
'		Slight adjustment to flipper strength.
' v.20	Reduced scale of playfield and plastics images.
'		Tomate created new ramps in blender, both physical and visible.
'		Adjusted cab pov
'		Adjusted strength of flippers after Tomate's ramps to ensure the 3rd ramp can have the flipper shots hit the captured ball.
'		Increased the height of the physics walls on top ramp.  Ball could jump onto them from lower ramps.
'		Adjusted the lower playfield and plastics sizes to ensure didn't block the see through holes from main playfield.
'		Adjusted the height of gate posts and targets.
' 		Put a plastic piece (under the existing plastic) half way down on upper left and right plastics.
'		Changed the acrylic materials
'		Adjusted the VR backglass display digits.
'		Modded the plastics between ramps.  Maded them ramps.
' 		Adjusted the insert lights down.
'		Increased height of main level physics walls.
'		Lowered the physical ramp heights by 0.5.  Ball could catch when moving slow.
' v.21	Redbone updated the playfields and plastic images.  Also added a little "wear" to the stand up targets.
'		Adjusted a physics wall by upper left loop.
'		Adjusted flipper strength and ramp material to make shots.
' 		Text on insert were a bit thin, increased borders.
'		Added some disable lighting on the ramps and saucers.
'		Changed the opacity of the playfield center glass with GI on or off.  It was a bit too cloudy before.
' v.22	Added cab mode side blades
'		Corrected some GI overlap lines.
'		Reduced playfield reflectivity
'		Adjusted levels of lighting on middle 3 lights.
'		Adjusted the red peg transparency in the material.
'		Plastics were too see through, added a black layer underneath, but controlled visibility via GIUpdates in script.
'		Removed unused images and materials.
'		Updated lower saucer kick randomness logic
' v.23	Testing from VPW team.  
'		Apophis recommended setting Elasticity Falloff of zCol_Targets material to 0.  
'		Needed to correct zCol_Drop Targets... material had all zeros
'		Slings a little strong.  Changed to 4.5.
'		Screwcaps needed to change with GI.  
'		Modded the gameoff state GI to ensure everything was off at table launch.
'		Change the default ball to 2.
'		Increased the flipper strength to 1900 to help get up the ramps.
'		Added a glass top for collision up ramps to keep ball in play.
'		Updated recommended DIP settings notes
'		Apophis provided some example code to help me hard set the dip switches to default values.
'		Added a user setting to turn default DIP switches off, and allow to be changed via F6.
'		RECOMMENDED SETTINGS are implemented in the default setting:  (located in the SetDIPSwitches constant and SetDefaultDips Sub)
'				Minimum time needed: 10 elektra units
'				Kicker during timeplay:  ball kicked out
'				No more Elektra-Units:  game goes on
'				Blue Targets and upper level Targets:  Liberal Setting 1,3,5
' v.24	Changed images to webp format for further compression without losing quality.
'v2.0.0	Apophis recommended removing a few dynamic shadows from collection near flippers.  
'		Modded the cab body image to have the coin slot black.
'v2.0.1	Bord suggested to correctly size the center post between the flippers.
'		Playfield had incorrect physics material on it.  Was too fast.  Should have been zCol_Playfield
'		Had to add a frictionless wall under capture ball after playfield friction changed.
'		Changed the capture wall fronts to physics posts instead of front wall protectors.  
'		Adjusted plunger pull speed
'		Adjusted under playfield flipper strength.
'		Adjusted gate three above 3rd ramp friction.
'		Slight adjustment to location of center right post by 3 red lights.  
'		Adjusted the size and dampening of the physical spinners.
'		Moved peg and re-rotated left spinner.  Not in exact right location.  Helps getting ball up ramp.
'		Adjusted a couple main pf GI.
'		The 3 red lights a little bright when all three lit.  Reduced the intensity of the top/plastic light emmision, as well as the bottom pf light emmission.
'		Adjusted the coin door in VR, was too high
'		Changed the lower saucer kickout strength.
'		Added a physics wall under the playfield mesh near the left spinner.
'2.0.2 - iaakki - Added baked GI lighting
'v2.0.3	Added some physical walls near left ramp and spinner.  
'		Tied spinner height to surface just above playfield.
'		Removed the physics wall under left spinner.
'		Shortened the plunger groove lane to avoid a stuck ball when outgate opened.  Removed logic to control that as well.
'		Changed the hit height of saucers to 8.  Better action.  
'		Added second bake for underpfGI.
'		Upper RightFlipper1 angle changed to 205, along with the associated prim, shadow, physics.
'2.0.4 - iaakki - Added baked AO shadows and fixed flipper shadows
'2.0.5	Updated the upperplayfield_mesh.  Improved the saucer backstop physics.  
'2.0.6	Minor correction to apron card.
'		Released.
'2.0.7	The plunger ramp to 2nd level would catch the ball on a slow plunge.  Needed to raise the plastics slightly.

'	Thanks to Tomate for creating the 4 center ramps; both the physical and visible!
'	Thanks to redbone for upscaling and touching up the playfield, plastics, apron, and spinner images!
'	Thanks to iaakki for baking the GI lighting and shadows!  
'   Thanks to the VPW team for testing, especially Apophis, Pinstratsdan, Sixtoe, BountyBob, iaakki, Bord, TastyWasps, and leojreimroc



