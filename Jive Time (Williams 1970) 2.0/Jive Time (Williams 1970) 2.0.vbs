'*************************************
'Jive Time (Williams 1970) - IPD No. 1298
'  Playfield - rothbauerw, bord
'  Backglass - rothbauerw
'  VPX Table - rothbauerw
'  Primitives - bord, 32assassin, kiwi, acronovum
'  Misc - borgdog, loserman, randr, acronovum, STAT
'
'  Special thanks to all those I borrowed tidbits from
'************************************

Option Explicit
Randomize

On Error Resume Next
ExecuteGlobal GetTextFile("controller.vbs")
If Err Then MsgBox "You need the Controller.vbs file in order to run this table (installed with the VPX package in the scripts folder)"
On Error Goto 0

Const ballsize = 25
Const ballmass = 1

Const cGameName = "jivetime"

'******************************************************
' 						OPTIONS
'******************************************************

Dim   VRRoom: VRRoom = 0			'0 = Desktop/Cabinet/FSS, 1 = VR

Const BallsPerGame = 5				'3, 5, or 10 (5 - is the default)
Const WestGateOption = 0			'1 - close west gate after scoring special, 0 - keep west gate open (default)
Const ResetBonus = 0 				'1 - Reset bonus each game (for competition), 0 - bonus carries over, (default)
Const RestoreGame = 0				'1 - to remember last game on table close, 0 - to start with game over (default)

Dim ExpSlings: ExpSlings = 1		'1 - use new sling physics, 0 - use traditional sling physics

Const VolumeDial = 0.8				'Change bolume of hit events

Const ChimesOn=0					'This table uses bells, 1 turns on DOF Chimes

'******************************************************
' 						VARIABLES
'******************************************************

Dim i
Dim obj
Dim InProgress
Dim BallInPlay
Dim Score
Dim HighScore
Dim Initials
Dim Credits
Dim Match
Dim Bonus 
Dim SpecialLightState
Dim Replay1:Replay1 = 100000
Dim Replay2:Replay2 = 140000
Dim Replay3:Replay3 = 210000
Dim Replay4:Replay4 = 250000
Dim TableTilted
Dim TiltCount
Dim GameOn:GameOn = 0
Dim Reel1Value, Reel2Value, Reel3Value, Reel4Value, Reel5Value
Dim JTBall

' using table width and height in script slows down the performance
dim tablewidth: tablewidth = Table1.width
dim tableheight: tableheight = Table1.height

'******************************************************
' 						TABLE INIT
'******************************************************

Sub Table1_Init
	LoadEM

	For each obj in GI_Flashers:obj.visible = 0: Next
	For each obj in Targets:obj.BlendDisableLighting = 0: Next
	For each obj in UV1col: obj.BlendDisableLighting = 0.2: Next

	loadhs

	if HSA1="" then HSA1=23
	if HSA2="" then HSA2=10
	if HSA3="" then HSA3=18
	UpdatePostIt

	set JTBall = Drain.CreateBall
	TableTilted=false
	InProgress=false
	centerpostcollide.collidable = False
	minipostcollide.collidable = False

	If ExpSlings = 1 Then
		LeftSlingShot.collidable = 1
		RightSlingShot.collidable = 1
		LeftSlingShot2.collidable = 0
		RightSlingShot2.collidable = 0
	Else
		LeftSlingShot.collidable = 0
		RightSlingShot.collidable = 0
		LeftSlingShot2.collidable = 1
		RightSlingShot2.collidable = 1
	End If

	rightsling1.enabled = 0
	rightsling2.enabled = 0
	leftsling1.enabled = 0
	leftsling2.enabled = 0

	Setup_Mode

	If Credits > 0 Then DOF 125, 1
End Sub

Sub Table1_Exit()
	savehs
	DOF 101, 0
	DOF 102, 0
	DOF 123, 0
	DOF 125, 0
	If B2SOn Then Controller.Stop
End Sub

Dim BootCount:BootCount = 0

Sub BootTable_Timer()
	If BootCount = 0 Then
		BootCount = 1
		me.interval = 100
		PlaySoundAt "poweron", Plunger
	Else
		if Bonus = 0 Then Bonus = 1000
		EVAL("L" & Bonus).state = 1
	
		If match = 0 Then
			BackglassMatch.image = "JiveTimeMatch00"
		Else
			BackglassMatch.image = "JiveTimeMatch" & Match
		End If
		
		If RestoreGame = 0 Then BallInPlay = 0

		If BallInPlay <> 0 Then
			BackglassBall.image = "JiveTimeBall" & BallInPlay
			SpecialLight.state = SpecialLightState
			BackglassMatch.visible = False
			If B2SOn Then Controller.B2SSetMatch 0
			InProgress = True
			Drain_Hit
		Else
			BackglassMatch.visible = True
			SetB2SMatch
			If B2SOn Then Controller.B2SSetGameOver 1
		End If

		'*****GI Lights On
		playfield_off.visible=0

		For each obj in UV1col:obj.image = "uv1": obj.BlendDisableLighting = 0.2: Next
		For each obj in GI:obj.State = 1: Next
		For each obj in GI_Flashers:obj.visible = 1: Next
		For each obj in GIBulbs
			obj.image = "bulbon"
			obj.material = "bulbon"
			obj.blenddisablelighting = 100
		Next

		plastics.image="plastics"
		plastics.blenddisablelighting = 1

		For each obj in Targets:obj.BlendDisableLighting = 0.3: Next
		If Table1.ShowDT = True  and Table1.ShowFSS = False then

		End If
		BumperCap1.BlendDisableLighting = 0.1
		BumperCap1.image="bc red2"
		BB1.blenddisablelighting = 0.5
		BumperSkirt1.blenddisablelighting = 0.3

		leftbat.blenddisablelighting = 0.6
		rightbat.blenddisablelighting = 0.6

		BackglassGI.visible = True
		BackglassBall.visible = True

		GameOn = 1

		If B2SOn Then 
			Controller.B2SSetData 80,1
			Controller.B2SSetBallInPlay BallInPlay
		End If

		me.enabled = False
	End If
End Sub

Sub BootB2S_Timer()
	If B2SOn Then 
		Controller.B2SSetCredits Credits
		Controller.B2SSetScore 1,Score
		SetB2SSpinner
	End If
	me.enabled = False
End Sub

'******************************************************
' 						KEYS
'******************************************************

Const ReflipAngle = 20
Dim EnableBallControl
EnableBallControl = false 'Change to true to enable manual ball control (or press C in-game) via the arrow keys and B (boost movement) keys

Sub Table1_KeyDown(ByVal keycode)

	If keycode = PlungerKey Then
		Plunger.PullBack
		SoundPlungerPull()
	End If

	If keycode = StartGameKey Then
		VRFrontButton.transx = 5
	End If

	If keycode = LeftFlipperKey Then
		VRFlipperButtonLeft.transx = 10
		'STHitAction 6
	End If

	If keycode = RightFlipperKey Then
		VRFlipperButtonRight.transx = -10
		'STHitAction 7
	End If


	If keycode = LeftFlipperKey and InProgress=true and TableTilted=false Then
		FlipperActivate LeftFlipper, LFPress
		LeftFlipper.RotateToEnd
		DOF 101, 1

		If leftflipper.currentangle < leftflipper.endangle + ReflipAngle Then 
			RandomSoundReflipUpLeft LeftFlipper
		Else 
			SoundFlipperUpAttackLeft LeftFlipper
			RandomSoundFlipperUpLeft LeftFlipper
		End If

		PlaySoundAtVolLoops "buzzL",LeftFlipper,0.05,-1
	End If

	If keycode = RightFlipperKey and InProgress=true and TableTilted=false Then
		FlipperActivate RightFlipper, RFPress
		RightFlipper.RotateToEnd
		DOF 102, 1
		If rightflipper.currentangle > rightflipper.endangle - ReflipAngle Then
			RandomSoundReflipUpRight RightFlipper
		Else 
			SoundFlipperUpAttackRight RightFlipper
			RandomSoundFlipperUpRight RightFlipper
		End If

		PlaySoundAtVolLoops "buzz",RightFlipper,0.05,-1	
	End If

	If keycode = LeftTiltKey Then
		Nudge 90, 2
		SoundNudgeLeft()
		checktilt
	End If

	If keycode = RightTiltKey Then
		Nudge 270, 2
		SoundNudgeRight()
		checktilt
	End If

	If keycode = CenterTiltKey Then
		Nudge 0, 2
		SoundNudgeCenter()
		checktilt
	End If

	If keycode = MechanicalTilt Then
		gametilted
	End If

	If keycode = AddCreditKey And GameOn = 1 then
		Select Case Int(rnd*3)
			Case 0: PlaySoundAtLevelStatic ("Coin_In_1"), CoinSoundLevel, Drain
			Case 1: PlaySoundAtLevelStatic ("Coin_In_2"), CoinSoundLevel, Drain
			Case 2: PlaySoundAtLevelStatic ("Coin_In_3"), CoinSoundLevel, Drain
		End Select
		AddCredit(1)
	end if

	if keycode=StartGameKey and Credits>0 and InProgress=false And GameOn = 1 And Not HSEnterMode=true then
		AddCredit(-1)
		InProgress=true
		StartNewGame.enabled = True
	end if

	If HSEnterMode Then HighScoreProcessKey(keycode)

    ' Manual Ball Control
	If keycode = 46 Then	 				' C Key
		If EnableBallControl = 1 Then
			EnableBallControl = 0
		Else
			EnableBallControl = 1
		End If
	End If
	If EnableBallControl = 1 Then
		If keycode = 48 Then 				' B Key
			If BCboost = 1 Then
				BCboost = BCboostmulti
			Else
				BCboost = 1
			End If
		End If
		If keycode = 203 Then BCleft = 1	' Left Arrow
		If keycode = 200 Then BCup = 1		' Up Arrow
		If keycode = 208 Then BCdown = 1	' Down Arrow
		If keycode = 205 Then BCright = 1	' Right Arrow
	End If
End Sub

Sub Table1_KeyUp(ByVal keycode)

	If keycode = PlungerKey Then
		Plunger.Fire
		If JTBall.x > 880 and JTBall.y > 1720 Then	'If true then ball in shooter lane, else no ball is shooter lane
			SoundPlungerReleaseBall()			'Plunger release sound when there is a ball in shooter lane
		Else
			SoundPlungerReleaseNoBall()			'Plunger release sound when there is no ball in shooter lane
		End If
	End If

	If keycode = StartGameKey Then
		VRFrontButton.transx = 0
	End If

	If keycode = LeftFlipperKey Then
		VRFlipperButtonLeft.transx = 0
	End If

	If keycode = RightFlipperKey Then
		VRFlipperButtonRight.transx = 0
	End If


	If keycode = LeftFlipperKey and InProgress=true and TableTilted=false Then
		FlipperDeActivate LeftFlipper, LFPress
		LeftFlipper.RotateToStart
		DOF 101, 0
		If LeftFlipper.currentangle < LeftFlipper.startAngle - 5 Then
			RandomSoundFlipperDownLeft LeftFlipper
		End If
		FlipperLeftHitParm = FlipperUpSoundLevel

		Stopsound "buzzL"
	End If

	If keycode = RightFlipperKey and InProgress=true and TableTilted=false Then
		FlipperDeActivate RightFlipper, RFPress
		RightFlipper.RotateToStart
		DOF 102, 0
		If RightFlipper.currentangle > RightFlipper.startAngle + 5 Then
			RandomSoundFlipperDownRight RightFlipper
		End If	
		FlipperRightHitParm = FlipperUpSoundLevel

		StopSound "buzz"
	End If

    'Manual Ball Control
	If EnableBallControl = 1 Then
		If keycode = 203 Then BCleft = 0	' Left Arrow
		If keycode = 200 Then BCup = 0		' Up Arrow
		If keycode = 208 Then BCdown = 0	' Down Arrow
		If keycode = 205 Then BCright = 0	' Right Arrow
	End If
End Sub


'******************************************************
'			FLIPPER TRICKS
'******************************************************

RightFlipper.timerinterval=1
Rightflipper.timerenabled=True

sub RightFlipper_timer()
	FlipperTricks LeftFlipper, LFPress, LFCount, LFEndAngle, LFState
	FlipperTricks RightFlipper, RFPress, RFCount, RFEndAngle, RFState
end sub

dim LFPress, RFPress, LFCount, RFCount
dim LFState, RFState
dim EOST, EOSA,Frampup, FElasticity,FReturn
dim RFEndAngle, LFEndAngle

EOST = leftflipper.eostorque
EOSA = leftflipper.eostorqueangle
Frampup = LeftFlipper.rampup
FElasticity = LeftFlipper.elasticity
FReturn = LeftFlipper.return
Const EOSTnew = 1.5 
Const EOSAnew = 1
Const EOSRampup = 0
Dim SOSRampup
SOSRampup = 2.5
Const LiveCatch = 16
Const LiveElasticity = 0.45
Const SOSEM = 0.815
Const EOSReturn = 0.055

LFEndAngle = Leftflipper.endangle
RFEndAngle = RightFlipper.endangle

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
		Dim BOT, b
		BOT = GetBalls
			
		For b = 0 to UBound(BOT)
			If Distance(BOT(b).x, BOT(b).y, Flipper.x, Flipper.y) < 55 Then 'check for cradle
				If BOT(b).vely >= -0.4 Then BOT(b).vely = -0.4
			End If
		Next
	End If
End Sub

Sub FlipperTricks (Flipper, FlipperPress, FCount, FEndAngle, FState) 
	Dim Dir
	Dir = Flipper.startangle/Abs(Flipper.startangle)	'-1 for Right Flipper

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

' Used for drop targets and flipper tricks
Function Distance(ax,ay,bx,by)
	Distance = SQR((ax - bx)^2 + (ay - by)^2)
End Function

Const LiveDistanceMin = 30  'minimum distance in vp units from flipper base live catch dampening will occur
Dim LiveDistanceMax: LiveDistanceMax = leftflipper.length  'maximum distance in vp units from flipper base live catch dampening will occur (tip protection)

Sub CheckLiveCatch(ball, Flipper, FCount, parm) 'Experimental new live catch
	Dim Dir
	Dir = Flipper.startangle/Abs(Flipper.startangle)    '-1 for Right Flipper
	Dim LiveCatchBounce															'If live catch is not perfect, it won't freeze ball totally
	Dim CatchTime : CatchTime = GameTime - FCount

	if CatchTime <= LiveCatch and parm > 6 and ABS(Flipper.x - ball.x) > LiveDistanceMin and ABS(Flipper.x - ball.x) < LiveDistanceMax Then
		if CatchTime <= LiveCatch*0.5 Then						'Perfect catch only when catch time happens in the beginning of the window
			LiveCatchBounce = 0
		else
			LiveCatchBounce = Abs((LiveCatch/2) - CatchTime)	'Partial catch when catch happens a bit late
		end If

		If LiveCatchBounce = 0 and ball.velx * Dir > 0 Then ball.velx = 0
		ball.vely = LiveCatchBounce * (32 / LiveCatch) ' Multiplier for inaccuracy bounce
		ball.angmomx= 0
		ball.angmomy= 0
		ball.angmomz= 0
	Else
		'If Flipper.currentangle = Flipper.endangle Then RubbersD.Dampen Activeball
	End If
End Sub

Sub LeftFlipper_Collide(parm)
	CheckLiveCatch Activeball, LeftFlipper, LFCount, parm
	LeftFlipperCollide parm
End Sub

Sub RightFlipper_Collide(parm)
	CheckLiveCatch Activeball, RightFlipper, RFCount, parm
	RightFlipperCollide parm
End Sub

'****************************************************************************
'PHYSICS DAMPENERS
'****************************************************************************

Sub dPosts_Hit(idx) 
	'RubbersD.dampen Activeball
End Sub

Sub dSleeves_Hit(idx) 
	SleevesD.Dampen Activeball
End Sub

dim RubbersD : Set RubbersD = new Dampener	'frubber
RubbersD.name = "Rubbers"
RubbersD.debugOn = False	'shows info in textbox "TBPout"
RubbersD.Print = False	'debug, reports in debugger (in vel, out cor)
'cor bounce curve (linear)
'for best results, try to match in-game velocity as closely as possible to the desired curve
'RubbersD.addpoint 0, 0, 0.935	'point# (keep sequential), ballspeed, CoR (elasticity)
RubbersD.addpoint 0, 0, 1.11 '0.97'0.935 '0.96	'point# (keep sequential), ballspeed, CoR (elasticity)
RubbersD.addpoint 1, 3.77, 0.99 '0.97 '0.935 '0.96
RubbersD.addpoint 2, 5.76, 0.942 '0.967	'dont take this as gospel. if you can data mine rubber elasticitiy, please help!
RubbersD.addpoint 3, 15.84, 0.874
RubbersD.addpoint 4, 56, 0.64	'there's clamping so interpolate up to 56 at least

dim SleevesD : Set SleevesD = new Dampener	'this is just rubber but cut down to 85%...
SleevesD.name = "Sleeves"
SleevesD.debugOn = False	'shows info in textbox "TBPout"
SleevesD.Print = False	'debug, reports in debugger (in vel, out cor)
SleevesD.CopyCoef RubbersD, 0.75 '0.85

Class Dampener
	Public Print, debugOn 'tbpOut.text
	public name, Threshold 	'Minimum threshold. Useful for Flippers, which don't have a hit threshold.
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
		RealCOR = BallSpeed(aBall) / cor.ballvel(aBall.id)
		coef = desiredcor / realcor 
		if debugOn then str = name & " in vel:" & round(cor.ballvel(aBall.id),2 ) & vbnewline & "desired cor: " & round(desiredcor,4) & vbnewline & _
		"actual cor: " & round(realCOR,4) & vbnewline & "ballspeed coef: " & round(coef, 3) & vbnewline 
		if Print then debug.print Round(cor.ballvel(aBall.id),2) & ", " & round(desiredcor,3)
		
		aBall.velx = aBall.velx * coef : aBall.vely = aBall.vely * coef
		if debugOn then TBPout.text = str
	End Sub

	Public Sub CopyCoef(aObj, aCoef) 'alternative addpoints, copy with coef
		dim x : for x = 0 to uBound(aObj.ModIn)
			addpoint x, aObj.ModIn(x), aObj.ModOut(x)*aCoef
		Next
	End Sub

	Public Sub Report() 	'debug, reports all coords in tbPL.text
		if not debugOn then exit sub
		dim a1, a2 : a1 = ModIn : a2 = ModOut
		dim str, x : for x = 0 to uBound(a1) : str = str & x & ": " & round(a1(x),4) & ", " & round(a2(x),4) & vbnewline : next
		TBPout.text = str
	End Sub

End Class

'******************************************************
'		FLIPPER POLARITY AND RUBBER DAMPENER
'			SUPPORTING FUNCTIONS 
'******************************************************

' Used for flipper correction and rubber dampeners
Sub ShuffleArray(ByRef aArray, byVal offset) 'shuffle 1d array
	dim x, aCount : aCount = 0
	redim a(uBound(aArray) )
	for x = 0 to uBound(aArray)	'Shuffle objects in a temp array
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
	redim aArray(aCount-1+offset)	'Resize original array
	for x = 0 to aCount-1		'set objects back into original array
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

' Used for flipper correction and rubber dampeners
Function PSlope(Input, X1, Y1, X2, Y2)	'Set up line via two points, no clamping. Input X, output Y
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
	dim ii : for ii = 1 to uBound(xKeyFrame)	'find active line
		if xInput <= xKeyFrame(ii) then L = ii : exit for : end if
	Next
	if xInput > xKeyFrame(uBound(xKeyFrame) ) then L = uBound(xKeyFrame)	'catch line overrun
	Y = pSlope(xInput, xKeyFrame(L-1), yLvl(L-1), xKeyFrame(L), yLvl(L) )

	if xInput <= xKeyFrame(lBound(xKeyFrame) ) then Y = yLvl(lBound(xKeyFrame) ) 	'Clamp lower
	if xInput >= xKeyFrame(uBound(xKeyFrame) ) then Y = yLvl(uBound(xKeyFrame) )	'Clamp upper

	LinearEnvelope = Y
End Function

'******************************************************
' 						SWITCHES
'******************************************************

Sub TopButton_Hit()
	AddScore(1000)
	RandomSoundRollover	
	DOF 129, 2
End Sub

Sub DownPostButton_Hit()
	DownPosts
	AddScore(1000)
	RandomSoundRollover
	DOF 130, 2
End Sub

Sub LeftOutLane_Hit()
	AddScore(1000)
	RandomSoundRollover
	DOF 132, 2
End Sub

Sub RightOutLane_Hit()
	AddScore(1000)
	RandomSoundRollover
	DOF 133, 2
End Sub

Sub T10Points1_Hit()
	RubberLM1.Visible = 1:RubberLM.Visible = 0:T10Points1t.Enabled = 1
	AddScore(10)
End Sub

Sub T10Points2_Hit()
	RubberLU1.Visible = 1:RubberLU.Visible = 0:T10Points2t.Enabled = 1
	AddScore(10)
End Sub

Sub T10Points3_Hit()
	AddScore(10)
End Sub

Sub T10Points4_Hit()
	RubberRUM1.Visible = 1:RubberRUM.Visible = 0:T10Points4t.Enabled = 1
	AddScore(10)
End Sub

Sub T10Points5_Hit()
	RubberRU1.Visible = 1:RubberRU.Visible = 0:T10Points5t.Enabled = 1
	AddScore(10)
End Sub

Sub ShooterLane_Unhit()
	DOF 126, 2
End Sub

Sub ABTarget1_Hit():STHit 1:End Sub
Sub ABTarget2_Hit():STHit 2:End Sub
Sub ABTarget3_Hit():STHit 3:End Sub
Sub ABTarget4_Hit():STHit 4:End Sub
Sub UpMiniPost_Hit():STHit 5:End Sub
Sub UpLampPost_Hit():STHit 6:End Sub
Sub DownPostTarget_Hit():STHit 7:End Sub
Sub GreenOnTarget_Hit():STHit 8:End Sub
Sub YellowOnTarget_Hit():STHit 9:End Sub

Sub STHitAction(Switch)
	Select Case (Switch)
		Case 1: 
			AdvanceBonus
			DOF 111, 2
		Case 2:
			AdvanceBonus
			DOF 113, 2
		Case 3:
			AdvanceBonus
			DOF 115, 2
		Case 4:
			AdvanceBonus
			DOF 116, 2
		Case 5:
			MiniPostDir = 1
			SoundSaucerKick 0, minipost
			MoveMiniPost.enabled = True
			AddScore(1000)
			DOF 117, 2
		Case 6:
			CenterPostDir = 1
			SoundSaucerKick 0, centerpost
			MoveCenterPost.enabled = True
			AddScore(1000)
			DOF 114, 2
		Case 7:
			DownPosts
			AddScore(1000)
			DOF 118, 2
		Case 8:
			GreenLightsOn
			AddScore(1000)
			DOF 110, 2
		Case 9:
			YellowLightsOn
			AddScore(1000)
			DOF 112, 2
	End Select
End Sub

'******************************************************
'		STAND-UP TARGET INITIALIZATION
'******************************************************

Class StandupTarget
	Private m_primary, m_prim, m_sw, m_animate
  
	Public Property Get Primary(): Set Primary = m_primary: End Property
	Public Property Let Primary(input): Set m_primary = input: End Property
  
	Public Property Get Prim(): Set Prim = m_prim: End Property
	Public Property Let Prim(input): Set m_prim = input: End Property
  
	Public Property Get Sw(): Sw = m_sw: End Property
	Public Property Let Sw(input): m_sw = input: End Property
  
	Public Property Get Animate(): Animate = m_animate: End Property
	Public Property Let Animate(input): m_animate = input: End Property
  
	Public default Function init(primary, prim, sw, animate)
	  Set m_primary = primary
	  Set m_prim = prim
	  m_sw = sw
	  m_animate = animate
  
	  Set Init = Me
	End Function
  End Class
  

'Define a variable for each stand-up target
Dim ST1, ST2, ST3, ST4, ST5, ST6, ST7, ST8, ST9

'Set array with stand-up target objects
'
'StandupTargetvar = Array(primary, prim, swtich)
' 	primary: 			vp target to determine target hit
'	prim:				primitive target used for visuals and animation
'							IMPORTANT!!! 
'							transy must be used to offset the target animation
'	switch:				ROM switch number
'	animate:			Arrary slot for handling the animation instrucitons, set to 0

Set ST1 = (new StandupTarget)(ABTarget1,pST001,1,0)
Set ST2 = (new StandupTarget)(ABTarget2,pST002,2,0)
Set ST3 = (new StandupTarget)(ABTarget3,pST003,3,0)
Set ST4 = (new StandupTarget)(ABTarget4,pST004,4,0)
Set ST5 = (new StandupTarget)(UpMiniPost,pST005,5,0)
Set ST6 = (new StandupTarget)(UpLampPost,pST006,6,0)
Set ST7 = (new StandupTarget)(DownPostTarget,pST007,7,0)
Set ST8 = (new StandupTarget)(GreenOnTarget,pST008,8,0)
Set ST9 = (new StandupTarget)(YellowOnTarget,pST009,9,0)

'Add all the Stand-up Target Arrays to Stand-up Target Animation Array
' STAnimationArray = Array(ST1, ST2, ....)
Dim STArray
STArray = Array(ST1, ST2, ST3, ST4, ST5, ST6, ST7, ST8, ST9)

'Configure the behavior of Stand-up Targets
Const STAnimStep =  1.5 				'vpunits per animation step (control return to Start)
Const STMaxOffset = 9 			'max vp units target moves when hit
Const STHitSound = "targethit"	'Stand-up Target Hit sound

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
		STBallPhysics Activeball, STArray(i).primary.orientation, STMass
	End If
	DoSTAnim
End Sub

Function STArrayID(switch)
	Dim i
	For i = 0 to uBound(STArray) 
		If STArray(i).sw = switch Then STArrayID = i:Exit Function 
	Next
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

'Add Timer name STAnim to editor to handle target animations
STAnim.interval = 10
STAnim.enabled = True

Sub STAnim_Timer()
	DoSTAnim
End Sub

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
		STHitAction switch
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

sub STBallPhysics(aBall, angle, mass)
	dim rangle,bangle,calc1, calc2, calc3
	rangle = (angle - 90) * 3.1416 / 180
	bangle = atn2(cor.ballvely(aball.id),cor.ballvelx(aball.id))

	calc1 = cor.BallVel(aball.id) * cos(bangle - rangle) * (aball.mass - mass) / (aball.mass + mass)
	calc2 = cor.BallVel(aball.id) * sin(bangle - rangle) * cos(rangle + 4*Atn(1)/2)
	calc3 = cor.BallVel(aball.id) * sin(bangle - rangle) * sin(rangle + 4*Atn(1)/2)

	aBall.velx = calc1 * cos(rangle) + calc2
	aBall.vely = calc1 * sin(rangle) + calc3
End Sub

' Used for flipper correction, rubber dampeners, and drop targets
Function BallSpeed(ball) 'Calculates the ball speed
    BallSpeed = SQR(ball.VelX^2 + ball.VelY^2 + ball.VelZ^2)
End Function

Function Atn2(dy, dx)
	dim pi
	pi = 4*Atn(1)

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

'******************************************************
'		TRACK ALL BALL VELOCITIES
' 		FOR RUBBER DAMPENER AND DROP TARGETS
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

Sub GameTimer_Timer
	cor.update
End Sub

'******************************************************
' 						POSTS
'******************************************************

Dim MiniPostDir, CenterPostDir, MovePostSpeed
MoveMiniPost.interval = 5
MoveCenterPost.interval = 5
MovePostSpeed = 5

Sub DownPosts()
	MiniPostDir = -1
	CenterPostDir = -1
	MoveMiniPost.enabled = true
	MoveCenterPost.enabled = true
End Sub

Sub MoveMiniPost_timer()
	MiniPost.z = MiniPost.z + MiniPostDir*MovePostSpeed
	if MiniPost.z > -12.5 Then
		minipostcollide.collidable = True
	Else
		minipostcollide.collidable = False	
	End If

	If MiniPost.z < -24.9 Then
		MiniPost.z = -25
		SoundSolOff MiniPost
		me.enabled = False
		DOF 127, 2
	End If
	If MiniPost.z > -0.1 Then
		MiniPost.z = 0
		me.enabled = False
		DOF 127, 2
	End If
End Sub

Sub MoveCenterPost_timer()
	CenterPost.transz = CenterPost.transz + CenterPostDir*MovePostSpeed/5

	if CenterPost.transz > 13 Then
		centerpostcollide.collidable = True
	Else
		centerpostcollide.collidable = False	
	End If


	If CenterPost.transz < 6 Then 
		CenterPost.image = "pp_popupOFF"
		CenterPost.BlendDisableLighting = 0
		lp1.state=0
		lp2.state=0
	Elseif CenterPost.transz < 12 Then
		CenterPost.BlendDisableLighting = 0.05
		lp1.state=0
		lp2.state=0
	Elseif CenterPost.transz < 18 Then
		CenterPost.BlendDisableLighting = 0.1
		lp1.state=0
		lp2.state=0
	Else
		CenterPost.image = "pp_popupON"
		CenterPost.BlendDisableLighting = 0.15
		CPFlash1.visible = False
		CPFlash2.visible = False
		'lp1.state=0
		'lp2.state=1
	End If

	If CenterPost.transz < 0.1 Then
		CenterPost.transz = 0
		SoundSolOff CenterPost
		me.enabled = False
		lp1.state=0
		lp2.state=0
		CPFlash1.visible = False
		CPFlash2.visible = False
		DOF 128, 2
	End If
	If CenterPost.transz > 24.9 Then
		CenterPost.transz = 25
		lp1.state=1
		lp2.state=1
		CPFlash1.visible = True
		CPFlash2.visible = True
		me.enabled = False
		DOF 128, 2
	End If
	cprod.transz = centerpost.transz
End Sub

'******************************************************
' 						BUMPERS
'******************************************************

Sub Bumper1_Hit()
	RandomSoundBumperMiddle Bumper1	
	DOF 107, 2
	AddScore(100)

	BumperSkirt1.roty=skirtAY(me,Activeball)
	BumperSkirt1.rotx=skirtAX(me,Activeball)
	me.timerenabled=1
End Sub

sub bumper1_timer 		'****************part of bumper skirt animation
	BumperSkirt1.rotx=0
	BumperSkirt1.roty=0
	me.timerenabled=0
end sub

Sub Bumper2_Hit()
	RandomSoundBumperTop Bumper2
	RandomSoundBumperBottom Bumper3
	DOF 105, 2
	DOF 109, 2
	Bumper3.PlayHit
	If GIG1.state = 1 Then 
		AddScore(1000)
	Else	
		AddScore(100)
	End If	

	BumperSkirt2.roty=skirtAY(me,Activeball)
	BumperSkirt2.rotx=skirtAX(me,Activeball)
	me.timerenabled=1
End Sub

sub bumper2_timer 		'****************part of bumper skirt animation
	BumperSkirt2.rotx=0
	BumperSkirt2.roty=0
	me.timerenabled=0
end sub

Sub Bumper3_Hit()
	RandomSoundBumperTop Bumper2
	RandomSoundBumperBottom Bumper3
	DOF 105, 2
	DOF 109, 2
	Bumper2.PlayHit
	If GIG1.state = 1 Then 
		AddScore(1000)
	Else	
		AddScore(100)
	End If	

	BumperSkirt3.roty=skirtAY(me,Activeball)
	BumperSkirt3.rotx=skirtAX(me,Activeball)
	me.timerenabled=1
End Sub

sub bumper3_timer 		'****************part of bumper skirt animation
	BumperSkirt3.rotx=0
	BumperSkirt3.roty=0
	me.timerenabled=0
end sub

Sub Bumper4_Hit()
	RandomSoundBumperTop Bumper4
	RandomSoundBumperBottom Bumper5
	DOF 108, 2
	DOF 106, 2
	Bumper5.PlayHit
	If GIY1.state = 1 Then 
		AddScore(1000)
	Else	
		AddScore(100)
	End If	

	BumperSkirt4.roty=skirtAY(me,Activeball)
	BumperSkirt4.rotx=skirtAX(me,Activeball)
	me.timerenabled=1
End Sub

sub bumper4_timer 		'****************part of bumper skirt animation
	BumperSkirt4.rotx=0
	BumperSkirt4.roty=0
	me.timerenabled=0
end sub

Sub Bumper5_Hit()
	RandomSoundBumperTop Bumper4
	RandomSoundBumperBottom Bumper5
	DOF 108, 2
	DOF 106, 2
	Bumper4.PlayHit
	If GIY1.state = 1 Then 
		AddScore(1000)
	Else	
		AddScore(100)
	End If	

	BumperSkirt5.roty=skirtAY(me,Activeball)
	BumperSkirt5.rotx=skirtAX(me,Activeball)
	me.timerenabled=1
End Sub

sub bumper5_timer 		'****************part of bumper skirt animation
	BumperSkirt5.rotx=0
	BumperSkirt5.roty=0
	me.timerenabled=0
end sub

Sub GreenLightsOn()
	dim xx
	For each xx in GreenLights:xx.State = 1: Next
	BumperCap2.BlendDisableLighting = 0.1
	BumperCap2.image="bc green2"
	BB2.blenddisablelighting = 0.5
	BumperSkirt2.blenddisablelighting = 0.3

	BumperCap3.BlendDisableLighting = 0.1
	BumperCap3.image="bc green2"
	BB3.blenddisablelighting = 0.5
	BumperSkirt3.blenddisablelighting = 0.3
End Sub

Sub GreenLightsOff()
	dim xx
	For each xx in GreenLights:xx.State = 0: Next
	BumperCap2.BlendDisableLighting = 0
	BumperCap2.image="bc green"
	BB2.blenddisablelighting = 0
	BumperSkirt2.blenddisablelighting = 0

	BumperCap3.BlendDisableLighting = 0
	BumperCap3.image="bc green"
	BB3.blenddisablelighting = 0
	BumperSkirt3.blenddisablelighting = 0
End Sub

Sub YellowLightsOn()
	dim xx
	For each xx in YellowLights:xx.State = 1: Next
	BumperCap4.BlendDisableLighting = 0.1
	BumperCap4.image="bc yellow2"
	BB4.blenddisablelighting = 0.5
	BumperSkirt4.blenddisablelighting = 0.3

	BumperCap5.BlendDisableLighting = 0.1
	BumperCap5.image="bc yellow2"
	BB5.blenddisablelighting = 0.5
	BumperSkirt5.blenddisablelighting = 0.3
End Sub

Sub YellowLightsOff()
	dim xx
	For each xx in YellowLights:xx.State = 0: Next
	BumperCap4.BlendDisableLighting = 0
	BumperCap4.image="bc yellow"
	BB4.blenddisablelighting = 0
	BumperSkirt4.blenddisablelighting = 0

	BumperCap5.BlendDisableLighting = 0
	BumperCap5.image="bc yellow"
	BB5.blenddisablelighting = 0
	BumperSkirt5.blenddisablelighting = 0
End Sub

'*************** needed for bumper skirt animation
'*************** NOTE: set bumper object timer to around 150-175 in order to be able
'***************       to actually see the animaation, adjust to your liking

Const PI = 3.1415926
Const SkirtTilt=5		'angle of skirt tilting in degrees

Function SkirtAX(bumper, bumperball)

	skirtAX=cos(skirtA(bumper,bumperball))*(SkirtTilt)		'x component of angle
	if (bumper.y<bumperball.y) then	skirtAX=skirtAX*-1	'adjust for ball hit bottom half

End Function

Function SkirtAY(bumper, bumperball)
		
	skirtAY=sin(skirtA(bumper,bumperball))*(SkirtTilt)		'y component of angle
	if (bumper.x>bumperball.x) then	skirtAY=skirtAY*-1	'adjust for ball hit left half

End Function

Function SkirtA(bumper, bumperball)
	dim hitx, hity, dx, dy
	hitx=bumperball.x
	hity=bumperball.y

	dy=Abs(hity-bumper.y)					'y offset ball at hit to center of bumper
	if dy=0 then dy=0.0000001
	dx=Abs(hitx-bumper.x)					'x offset ball at hit to center of bumper
	skirtA=(atn(dx/dy)) '/(PI/180)			'angle in radians to ball from center of Bumper1
End Function

'******************************************************
' 						WEST GATE
'******************************************************

Sub WestGateButton2_Hit()
	PlaySoundAtBall"sensor"
	DOF 131, 2
	If WestGateLight.state = 1 Then
		AddBall 1
		If WestGateOption = 1 Then
			CloseWestGate
		End If
	Else
		'AddScore(1000) 'real machine does not score 1000
	End If
End Sub

Sub OpenWestGate()
	DiverterFlipper.rotatetoend
	DOF 122, 2
End Sub

Sub CloseWestGate()
	DiverterFlipper.rotatetostart
	DOF 122, 2
End Sub

'******************************************************
' 						KICKERS
'******************************************************

TopKicker.timerinterval = 500
dim SelectKicker

Sub TopKicker_Hit
	SelectKicker = "Top"
	SoundSaucerLock	
	If TableTilted = 0 Then
		If SpecialLight.state = 1 Then
			SpecialLight.state = 0
			AddBall 1
		End If
		RunSpinner
	Else
		TopKicker.timerenabled = True
	End If
End Sub

Sub TopKicker_Timer()
	TopKicker.Kick 168 + rnd(4), 13
	MiddleKicker.Kick 167 + rnd(4),13
	Kickerprim1.rotx = -37
	Kickerprim2.rotx = -37	
	MiddleKicker.timerenabled = true
	TopKicker.timerenabled = false
	If SelectKicker = "Top" Then
		SoundSaucerKick 1, TopKicker
		SoundSaucerKick 0, MiddleKicker
	Else
		SoundSaucerKick 0, TopKicker
		SoundSaucerKick 1, MiddleKicker
	End If
	'MiddleKicker.enabled = False
	'TopKicker.enabled = False
	DOF 119, 2
	DOF 120, 2
End Sub

Sub MiddleKicker_Hit
	SelectKicker = "Middle"
	SoundSaucerLock
	If TableTilted = 0 Then
		RunSpinner
	Else
		TopKicker.timerenabled = True
	End If
End Sub

Sub MiddleKicker_Timer()
	Kickerprim1.rotx = -20
	Kickerprim2.rotx = -20
	MiddleKicker.timerenabled = False
End Sub

'******************************************************
' 						SPINNER
'******************************************************

Dim SpinnerAngle, SpinnerTime, SpinnerRunTime, SpinnerStep 
SpinnerTimer.interval = 10

Sub SpinnerTimer_Timer()
	SpinnerRunTime = SpinnerRunTime + (me.interval/1000)
	if SpinnerRunTime < SpinnerTime Then
		SpinnerStep = 12		
	Else
		DOF 123, 0
		SpinnerStep = SpinnerStep-0.25
		If SpinnerStep < 0 Then
			SpinnerStep = 0
			me.enabled = False
		End If
	End If
	SpinnerAngle = SpinnerAngle + SpinnerStep
	If SpinnerAngle > 360 Then
		SpinnerAngle = SpinnerAngle - 360
	End If
	SetB2SSpinner
End Sub

Sub RunSpinner
	SpinnerTime = 1.25 + Int(Rnd*25)/100
	SpinnerRunTime = 0
	SpinnerTimer.enabled = true
	SpinnerScore.enabled = true
	PlaySoundAtVol "Spinner", Spinner, 0.5
	DOF 123, 1
End Sub 

Sub SpinnerScore_Timer
	SpinnerAward
	me.enabled = False
End Sub

Sub SpinnerAward()
	If SpinnerAngle > 339 Or SpinnerAngle <= 15 Then
		AddScore(10000)
		TopKicker.timerenabled = true
	Elseif SpinnerAngle > 15 And SpinnerAngle <= 51 Then
		OpenWestGate
		MultiScore 5, 100
		TopKicker.timerenabled = true
	Elseif SpinnerAngle > 51 And SpinnerAngle <= 87 Then
		BonusTimer.enabled = true
	Elseif SpinnerAngle > 87 And SpinnerAngle <= 123 Then
		AddScore(1000)
		TopKicker.timerenabled = true
	Elseif SpinnerAngle > 123 And SpinnerAngle <= 159 Then
		MultiScore 3, 1000
		TopKicker.timerenabled = true
	Elseif SpinnerAngle > 159 And SpinnerAngle <= 195 Then
		DoubleBonusTimer.enabled = 1
		MultiScore 2.5, 1000
	Elseif SpinnerAngle > 195 And SpinnerAngle <= 231 Then
		AddScore(1000)
		TopKicker.timerenabled = true
	Elseif SpinnerAngle > 231 And SpinnerAngle <= 267 Then
		OpenWestGate
		MultiScore 5, 100
		TopKicker.timerenabled = true
	Elseif SpinnerAngle > 267 And SpinnerAngle <= 303 Then
		BonusTimer.enabled = true
	Elseif SpinnerAngle > 303 And SpinnerAngle <= 339 Then
		MultiScore 3, 1000
		TopKicker.timerenabled = true
	End If
	
End Sub

Dim PrevPos

Sub SetB2SSpinner()
	If B2SOn Then 
		Dim spos
		spos = Int(((SpinnerAngle+4) mod 360)/4)

		If PrevPos <> 0 Then 
			If PrevPos > 50 Then
				Controller.B2SSetData PrevPos+109, 0
			Else
				Controller.B2SSetData PrevPos+200, 0
			End If

		End If

		If spos = 0 Then spos = 90 

		PrevPos = sPos

		If sPos > 50 Then
			Controller.B2SSetData sPos+109, 1
		Else
			Controller.B2SSetData sPos+200, 1
		End If
	End If
End Sub

Sub SpinnerTest_Timer()
	SpinnerAngle = SpinnerAngle + 0.1
	SetB2SSpinner
End Sub

'******************************************************
' 						BONUS
'******************************************************

Dim BonusCount, AdvBonus

Sub BonusTimer_Timer()
	BonusCount = BonusCount + 1

	Select Case (BonusCount)
		Case 1: 
			PlaySoundAtVol "MotorRunning", Spinner, 0.25
			PlayLoudClick
			CheckBonus	
		Case 2:
			PlayLoudClick
			CheckBonus	
		Case 3:
			PlayLoudClick
			CheckBonus	
		Case 4:
			PlayLoudClick
			CheckBonus	
		Case 5:
			PlayLoudClick
			CheckBonus	

		Case 7:
			PlayQuietClick
			CheckBonus	
		Case 8:
			PlayQuietClick
			CheckBonus	
		Case 9:
			PlayQuietClick
			CheckBonus	
		Case 10:
			PlayQuietClick
			CheckBonus	
		Case 11:
			PlayQuietClick
			CheckBonus	

		Case 13: 
			L1000.state = 1
			TopKicker.timerenabled = true
			me.enabled = false
			BonusCount = 0
	End Select
End Sub

Sub DoubleBonusTimer_Timer()
	If L1000.state = 1 or L2000.state = 1 or L3000.state = 1 or L4000.state = 1 or L5000.state = 1 or L6000.state = 1 or L7000.state = 1 or L8000.state = 1 or L9000.state = 1 or L10000.state = 1 Then
		MultiScore 2.5, 1000
	Else
		L1000.state = 1
		TopKicker.timerenabled = true
		me.enabled = false
	End If
End Sub

Sub CheckBonus()
	If L1000.state = 1 or L2000.state = 1 or L3000.state = 1 or L4000.state = 1 or L5000.state = 1 or L6000.state = 1 or L7000.state = 1 or L8000.state = 1 or L9000.state = 1 or L10000.state = 1 Then
		DecreaseBonus
		AddScore(1000)
	End If
End Sub

Sub AdvanceBonus()
	if isScoring() = 0 Then
		AddScore 1000
		If L1000.state = 1 Then
			L2000.state = 1
			L1000.state = 0
			Bonus = 2000
			PlayLoudClick
		ElseIf L2000.state = 1 Then
			L3000.state = 1
			L2000.state = 0
			Bonus = 3000
			PlayLoudClick
		ElseIf L3000.state = 1 Then
			L4000.state = 1
			L3000.state = 0
			Bonus = 4000
			PlayLoudClick
		ElseIf L4000.state = 1 Then
			L5000.state = 1
			L4000.state = 0
			Bonus = 5000
			PlayLoudClick
		ElseIf L5000.state = 1 Then
			L6000.state = 1
			L5000.state = 0
			Bonus = 6000
			PlayLoudClick
		ElseIf L6000.state = 1 Then
			L7000.state = 1
			L6000.state = 0
			Bonus = 7000
			PlayLoudClick
		ElseIf L7000.state = 1 Then
			L8000.state = 1
			L7000.state = 0
			Bonus = 8000
			PlayLoudClick
		ElseIf L8000.state = 1 Then
			L9000.state = 1
			L8000.state = 0
			Bonus = 9000
			PlayLoudClick
		ElseIf L9000.state = 1 Then
			L10000.state = 1
			L9000.state = 0
			Bonus = 10000
			PlayLoudClick
		End If
	End If
End Sub

Sub DecreaseBonus()
	PlayLoudClick
	If L1000.state = 1 Then
		L1000.state = 0
		Bonus = 1000
	ElseIf L2000.state = 1 Then
		L1000.state = 1
		L2000.state = 0
	ElseIf L3000.state = 1 Then
		L2000.state = 1
		L3000.state = 0
	ElseIf L4000.state = 1 Then
		L3000.state = 1
		L4000.state = 0
	ElseIf L5000.state = 1 Then
		L4000.state = 1
		L5000.state = 0
	ElseIf L6000.state = 1 Then
		L5000.state = 1
		L6000.state = 0
	ElseIf L7000.state = 1 Then
		L6000.state = 1
		L7000.state = 0
	ElseIf L8000.state = 1 Then
		L7000.state = 1
		L8000.state = 0
	ElseIf L9000.state = 1 Then
		L8000.state = 1
		L9000.state = 0
	ElseIf L10000.state = 1 Then
		L10000.state = 0
		L9000.state = 1
	End If
End Sub

'******************************************************
' 					SCORING/CREDITS
'******************************************************

Dim ReelClickVol:ReelClickVol=0.5
Dim PrevScore

Sub AddScore(x)
	If TableTilted = 0 Then
		PrevScore = Score
		if isScoring() = 0 Then 
			If SpecialLight.state = 1 Then SpecialLight.state = 0
			If x = 10 Then
				Play10Bell
				CheckForRoll(10)
				Score = Score + 10
				AdvMatch
			ElseIf x = 100 Then
				Play100Bell
				CheckForRoll(100)
				Score = Score + 100
			ElseIf x = 1000 Then
				Play100Bell
				CheckForRoll(1000)
				Score = Score + 1000
			ElseIf x = 10000 Then
				Play100Bell
				CheckForRoll(10000)
				Score = Score + 10000
			End If
		End If
		CheckFreeGame
	End If
	'If B2SOn Then Controller.B2SSetScore 1,Score
End Sub

Sub Play10Bell()
	If ChimesON = 1 Then
		PlaySound SoundFX("10_Point_Bell_Loud",DOFChimes), 1, 1, AudioPan(Spinner), 0,0,0,1,AudioFade(Spinner)
		DOF 153, 2
	Else
		PlaySoundAt "10_Point_Bell_Loud", Spinner
	End If
End Sub

Sub Play100Bell()
	If ChimesON = 1 Then
		PlaySound SoundFX("100_Point_Bell_Loud",DOFChimes), 1, 1, AudioPan(Spinner), 0,0,0,1,AudioFade(Spinner)
		DOF 154, 2
	Else
		PlaySoundAt "100_Point_Bell_Loud", Spinner
	End If
End Sub

Sub CheckForRoll(x)
	Select Case (x)
		Case 10: 
			PulseReel5.enabled = 1

			Reel5Value = (Reel5Value + 1) mod 10
			If B2SOn Then Controller.b2ssetreel 5,Reel5Value

			PlaySoundAtVol "reelclick5", emp1r5, ReelClickVol
			if emp1r5.rotx = 261 then CheckForRoll(100)
		Case 100:
			PulseReel4.enabled = 1

			Reel4Value = (Reel4Value + 1) mod 10
			If B2SOn Then Controller.b2ssetreel 4,Reel4Value

			PlaySoundAtVol "reelclick4", emp1r4, ReelClickVol
			if emp1r4.rotx = 261 then CheckForRoll(1000)
		Case 1000:
			PulseReel3.enabled = 1

			Reel3Value = (Reel3Value + 1) mod 10
			If B2SOn Then Controller.b2ssetreel 3,Reel3Value

			PlaySoundAtVol "reelclick3", emp1r3, ReelClickVol
			if emp1r3.rotx = 261 then CheckForRoll(10000)
		Case 10000:
			PulseReel2.enabled = 1

			Reel2Value = (Reel2Value + 1) mod 10
			If B2SOn Then Controller.b2ssetreel 2,Reel2Value

			PlaySoundAtVol "reelclick2", emp1r2, ReelClickVol
			if emp1r2.rotx = 261 then CheckForRoll(100000)
		Case 100000:
			PulseReel1.enabled = 1

			Reel1Value = (Reel1Value + 1) mod 10
			If B2SOn Then Controller.b2ssetreel 1,Reel1Value

			PlaySoundAtVol "reelclick1", emp1r1, ReelClickVol
	End Select
End Sub

Sub AddCredit(direction)
	If PulseCreditReel.enabled = 0 Then
		if direction > 0 and credits >= 40 Then
			'do Nothing
		Else			
			CreditDir = direction
			credits = credits + direction
			PulseCreditReel.enabled = 1
			PlaySoundAtVol "reelclick6", emcredits1, ReelClickVol
			DOF 135, 2
		End If
	End If
	If Credits > 0 Then 
		DOF 125, 1
	Else 
		DOF 125, 0
	End If
	If B2SOn Then Controller.B2SSetCredits Credits
End Sub

Sub CheckFreeGame()
	If PrevScore < Replay1 And Score >= Replay1 Then FreeGame
	If PrevScore < Replay2 And Score >= Replay2 Then FreeGame
	If PrevScore < Replay3 And Score >= Replay3 Then FreeGame
	If PrevScore < Replay4 And Score >= Replay4 Then FreeGame
End Sub

Sub FreeGame()
	AddCredit(1)
	KnockerSolenoid
End Sub

Dim mCountDown, mScore

Sub MultiScore(cycle, Score)
	mScore = Score
	mCountDown = cycle - 1
	AddScore(mscore)
	MultiScoreTimer.enabled = true
End Sub

Sub MultiScoreTimer_Timer
	mCountDown = mCountDown - 1
	If mCountDown < 0 Then
		DecreaseBonus
	Else
		AddScore(mscore)		
	End If
	If mCountDown < 0.1 Then
		me.enabled = False
	End If
End Sub

Function isScoring()
	if PulseReel2.enabled = 0 and PulseReel3.enabled = 0 and PulseReel4.enabled = 0 and PulseReel5.enabled = 0 Then 
		isScoring = 0 
	Else
		isScoring = 1
	End If
End Function

'******************************************************
' 						EMREELS
'******************************************************

Dim ReelStep:ReelStep = 6

Sub PulseReel1_Timer
	dim done:done=0
	emp1r1.rotx = emp1r1.rotx + ReelStep
	if emp1r1.rotx > 360 then emp1r1.rotx = emp1r1.rotx - 360
	
	Select Case (emp1r1.rotx)
		Case 9: done = 1
		Case 45: done = 1
		Case 81: done = 1
		Case 117: done = 1
		Case 153: done = 1
		Case 189: done = 1
		Case 225: done = 1
		Case 261: done = 1
		Case 297: done = 1
		Case 333: done = 1
	End Select

	if done = 1 then  
		me.enabled = 0
	End If
End Sub

Sub PulseReel2_Timer
	dim done:done=0
	emp1r2.rotx = emp1r2.rotx + ReelStep
	if emp1r2.rotx > 360 then emp1r2.rotx = emp1r2.rotx - 360
	
	Select Case (emp1r2.rotx)
		Case 9: done = 1
		Case 45: done = 1
		Case 81: done = 1
		Case 117: done = 1
		Case 153: done = 1
		Case 189: done = 1
		Case 225: done = 1
		Case 261: done = 1
		Case 297: done = 1
		Case 333: done = 1
	End Select

	if done = 1 then  
		me.enabled = 0
	End If
End Sub

Sub PulseReel3_Timer
	dim done:done=0
	emp1r3.rotx = emp1r3.rotx + ReelStep
	if emp1r3.rotx > 360 then emp1r3.rotx = emp1r3.rotx - 360
	
	Select Case (emp1r3.rotx)
		Case 9: done = 1
		Case 45: done = 1
		Case 81: done = 1
		Case 117: done = 1
		Case 153: done = 1
		Case 189: done = 1
		Case 225: done = 1
		Case 261: done = 1
		Case 297: done = 1
		Case 333: done = 1
	End Select

	if done = 1 then  
		me.enabled = 0
	End If
End Sub

Sub PulseReel4_Timer
	dim done:done=0
	emp1r4.rotx = emp1r4.rotx + ReelStep
	if emp1r4.rotx > 360 then emp1r4.rotx = emp1r4.rotx - 360
	
	Select Case (emp1r4.rotx)
		Case 9: done = 1
		Case 45: done = 1
		Case 81: done = 1
		Case 117: done = 1
		Case 153: done = 1
		Case 189: done = 1
		Case 225: done = 1
		Case 261: done = 1
		Case 297: done = 1
		Case 333: done = 1
	End Select

	if done = 1 then  
		me.enabled = 0
	End If
End Sub

Sub PulseReel5_Timer
	dim done:done=0
	emp1r5.rotx = emp1r5.rotx + ReelStep
	if emp1r5.rotx > 360 then emp1r5.rotx = emp1r5.rotx - 360
	
	Select Case (emp1r5.rotx)
		Case 9: done = 1
		Case 45: done = 1
		Case 81: done = 1
		Case 117: done = 1
		Case 153: done = 1
		Case 189: done = 1
		Case 225: done = 1
		Case 261: done = 1
		Case 297: done = 1
		Case 333: done = 1
	End Select

	if done = 1 then  
		me.enabled = 0
	End If
End Sub

Dim CreditDir

Sub PulseCreditReel_Timer
	dim done:done=0

	emcredits2.rotx = emcredits2.rotx - ReelStep*CreditDir
	if emcredits2.rotx > 360 then emcredits2.rotx = emcredits2.rotx - 360
	if emcredits2.rotx < 0 then emcredits2.rotx = emcredits2.rotx + 360
	
	If CreditDir = 1 and emcredits2.rotx < 333 and emcredits2.rotx >= 297 then
		emcredits1.rotx = emcredits1.rotx - ReelStep*CreditDir
	Elseif CreditDir = -1 and emcredits2.rotx <= 333 and emcredits2.rotx > 297 then
		emcredits1.rotx = emcredits1.rotx - ReelStep*CreditDir
	End If

	Select Case (emcredits2.rotx)
		Case 9: done = 1
		Case 45: done = 1
		Case 81: done = 1
		Case 117: done = 1
		Case 153: done = 1
		Case 189: done = 1
		Case 225: done = 1
		Case 261: done = 1
		Case 297: done = 1
		Case 333: done = 1
	End Select

	if done = 1 then  
		me.enabled = 0
	End If
End Sub

Sub ResetReels()
	If emp1r5.rotx <> 297 then PulseReel5.enabled = true:PlaySoundAtVol "reelclick5", emp1r5, ReelClickVol
	If emp1r4.rotx <> 297 then PulseReel4.enabled = true:PlaySoundAtVol "reelclick4", emp1r4, ReelClickVol
	If emp1r3.rotx <> 297 then PulseReel3.enabled = true:PlaySoundAtVol "reelclick3", emp1r3, ReelClickVol
	If emp1r2.rotx <> 297 then PulseReel2.enabled = true:PlaySoundAtVol "reelclick2", emp1r2, ReelClickVol
	If emp1r1.rotx <> 297 then PulseReel1.enabled = true:PlaySoundAtVol "reelclick1", emp1r1, ReelClickVol
	If B2SOn Then
		If Reel5Value <> 0 Then
			Reel5Value = (Reel5Value + 1) mod 10
			If B2SOn Then Controller.b2ssetreel 5,Reel5Value
		End If
		If Reel4Value <> 0 Then
			Reel4Value = (Reel4Value + 1) mod 10
			If B2SOn Then Controller.b2ssetreel 4,Reel4Value
		End If
		If Reel3Value <> 0 Then
			Reel3Value = (Reel3Value + 1) mod 10
			If B2SOn Then Controller.b2ssetreel 3,Reel3Value
		End If
		If Reel2Value <> 0 Then
			Reel2Value = (Reel2Value + 1) mod 10
			If B2SOn Then Controller.b2ssetreel 2,Reel2Value
		End If
		If Reel1Value <> 0 Then
			Reel1Value = (Reel1Value + 1) mod 10
			If B2SOn Then Controller.b2ssetreel 1,Reel1Value
		End If
	End If
End Sub

Sub SetReels()
	dim digangles(10)
	digangles(0) = 297
	digangles(1) = 333
	digangles(2) = 9
	digangles(3) = 45
	digangles(4) = 81
	digangles(5) = 117
	digangles(6) = 153
	digangles(7) = 189
	digangles(8) = 225
	digangles(9) = 261

	If Score > 9 Then emp1r5.rotx = digangles(Int(Mid(StrReverse(score),2,1))):Reel5Value=Mid(StrReverse(score),2,1)
	If Score > 99 Then emp1r4.rotx = digangles(Int(Mid(StrReverse(score),3,1)))::Reel4Value=Mid(StrReverse(score),3,1)
	If Score > 999 Then emp1r3.rotx = digangles(Int(Mid(StrReverse(score),4,1))):Reel3Value=Mid(StrReverse(score),4,1)
	If Score > 9999 Then emp1r2.rotx = digangles(Int(Mid(StrReverse(score),5,1))):Reel2Value=Mid(StrReverse(score),5,1)
	If Score > 99999 Then emp1r1.rotx = digangles(Int(Mid(StrReverse(score),6,1))):Reel1Value=Mid(StrReverse(score),6,1)

	digangles(0) = 297
	digangles(9) = 333
	digangles(8) = 9
	digangles(7) = 45
	digangles(6) = 81
	digangles(5) = 117
	digangles(4) = 153
	digangles(3) = 189
	digangles(2) = 225
	digangles(1) = 261

	If Credits > 9 Then emcredits1.rotx = digangles(Int(Mid(StrReverse(Credits),2,1)))
	emcredits2.rotx = digangles(Int(Mid(StrReverse(Credits),1,1)))

End Sub

'******************************************************
' 						DRAIN
'******************************************************

Sub Drain_Hit()
	RandomSoundDrain Drain	
	PlaySoundAtVol "MotorRunning", Spinner, 0.25
	DOF 121, DOFPulse
	DownPosts
	YellowLightsOff
	GreenLightsOff
	CloseWestGate
	If TableTilted = 1 Then
		BackglassTilt.visible = 0
		TableTilted = 0
		ResetTilt
	End If

	If SpecialLight.State = 0 Then
		SubtractBall
	Else
		Drain.timerenabled = 1
	End If
End Sub

Sub Drain_Timer()
	SpecialLight.state = 1
	Drain.Kick 60, 20
	DOF 136, DOFPulse
	RandomSoundBallRelease drain
	me.timerenabled = False
End Sub

Sub AddBall(knocker)
	If knocker = 1 then 
		KnockerSolenoid
	End If
	BallInPlay = BallInPlay + 1
	If BallInPlay > 10 Then BallInPlay=10
	PlayQuietClick
	BackglassBall.image = "JiveTimeBall" & BallInPlay
	If B2SOn Then Controller.B2SSetBallInPlay BallInPlay
End Sub

Sub SubtractBall()
	BallInPlay = BallInPlay - 1
	if ballinplay < 0 then BallInPlay = 0
	If BallInPlay = 0 Then 
		InProgress = False
		BackglassBall.image = "JiveTimeGameOver"
		If B2SOn Then Controller.B2SSetGameOver 1
		CheckMatch
		LeftFlipper.RotateToStart
		StopSound "buzzL"
		DOF 101, 0

		RightFlipper.RotateToStart
		StopSound "buzz"
		DOF 102, 0

		If Score >= HighScore Then
			HighScore = Score
			HighScoreEntryInit()
		End If
	Else
		BackglassBall.image = "JiveTimeBall" & BallInPlay	
		Drain.timerenabled = 1
	End If
	PlayQuietClick
	If B2SOn Then Controller.B2SSetBallInPlay BallInPlay
End Sub


'******************************************************
' 					START NEW GAME
'******************************************************

Dim NGCount

Sub StartNewGame_Timer()
	NGCount = NGCount + 1

	Select Case (NGCount)
		Case 1: 
			If ResetBonus = 1 Then
				EVAL("L" & Bonus).state = 0
				Bonus = 1000
				L1000.state =1
			End If
			BackglassMatch.visible = False
			BackglassTilt.visible = False
			If B2SOn Then 
				Controller.B2SSetTilt 0
				Controller.B2SSetMatch 0
				'Controller.B2SSetScore 1,0
				Controller.B2SSetGameOver 0
			End If
			ResetTilt
			PlaySoundAtVol "MotorRunning", Spinner, 0.25
			PlayLoudClick
			If BallInPlay < BallsPerGame Then AddBall 0
			ResetReels
		Case 2:
			PlayLoudClick
			If BallInPlay < BallsPerGame Then AddBall 0
			ResetReels
		Case 3:
			PlayLoudClick
			If BallInPlay < BallsPerGame Then AddBall 0
			ResetReels
		Case 4:
			PlayLoudClick
			If BallInPlay < BallsPerGame Then AddBall 0
			ResetReels
		Case 5:
			PlayLoudClick
			If BallInPlay < BallsPerGame Then AddBall 0
			ResetReels

		Case 7:
			PlayQuietClick
			If BallInPlay < BallsPerGame Then AddBall 0
			ResetReels
		Case 8:
			PlayQuietClick
			If BallInPlay < BallsPerGame Then AddBall 0
			ResetReels
		Case 9:
			PlayQuietClick
			If BallInPlay < BallsPerGame Then AddBall 0
			ResetReels
		Case 10:
			PlayQuietClick
			If BallInPlay < BallsPerGame Then AddBall 0
			ResetReels
		Case 11:
			PlayQuietClick
			If BallInPlay < BallsPerGame Then AddBall 0
			ResetReels

		Case 13: 
			Drain.timerenabled = true
			Score = 0
			SetReels
			If B2SOn Then
				Controller.b2ssetreel 1,0:Reel1Value = 0
				Controller.b2ssetreel 2,0:Reel2Value = 0
				Controller.b2ssetreel 3,0:Reel3Value = 0
				Controller.b2ssetreel 4,0:Reel4Value = 0
				Controller.b2ssetreel 5,0:Reel5Value = 0
			End If
			me.enabled = false
			NGCount = 0
	End Select	
End Sub

'******************************************************
' 							MATCH
'******************************************************

Sub CheckMatch()
	If Match = 0 Then
		BackglassMatch.image = "JiveTimeMatch00"
	Else
		BackglassMatch.image = "JiveTimeMatch" & Match
	End If

	BackglassMatch.visible = 1
	SetB2SMatch
	if Match=(Score mod 100) then
		FreeGame
	end if
End Sub

Sub AdvMatch()
	Select Case (Match)
		Case 30: Match = 80
		Case 80: Match = 20
		Case 20: Match = 50
		Case 50: Match = 90
		Case 90: Match = 40
		Case 40: Match = 0
		Case 0: Match = 60
		Case 60: Match = 10
		Case 10: Match = 70
		Case 70: Match = 30
	End Select
End Sub

Sub SetB2SMatch()
	If B2SOn Then 
		If Match = 0 Then
			Controller.B2SSetMatch 100
		Else
			Controller.B2SSetMatch Match
		End If
	End If
End Sub

'******************************************************
' 				SLING AND ANIMATED RUBBERS
'******************************************************
Dim RStep, Lstep

Sub RightSlingShot_Slingshot
	AddScore(10)
	RandomSoundSlingshotRight 
	DOF 104, 2
	RSling.Visible = 0
	RSling1.Visible = 1
	sling1.TransZ = -20
	RStep = 0
	RightSlingShot.TimerEnabled = 1
	If ExpSlings = 1 Then
		activeball.velx = cor.ballvelx(activeball.id)
		activeball.vely = cor.ballvely(activeball.id)
		rightsling1.enabled = 1
		rightsling2.enabled = 1
		rightsling1.rotatetoend
		rightsling2.rotatetoend
	End If
End Sub

Sub RightSlingShot2_Slingshot
	RightSlingShot_Slingshot
End Sub

Sub RightSlingShot_Timer
    Select Case RStep
        Case 3:RSLing1.Visible = 0:RSLing2.Visible = 1:sling1.TransZ = -10:	
			If ExpSlings = 1 Then
				rightsling1.rotatetostart
				rightsling2.rotatetostart
			End If
        Case 4:RSLing2.Visible = 0:RSLing.Visible = 1:sling1.TransZ = 0:RightSlingShot.TimerEnabled = 0:
			If ExpSlings = 1 Then
				rightsling1.enabled=0
				rightsling2.enabled=0
			End If
    End Select
    RStep = RStep + 1
End Sub

Sub LeftSlingShot_Slingshot
	AddScore(10) 
	RandomSoundSlingshotLeft
	DOF 103, 2
	LSling.Visible = 0
	LSling1.Visible = 1
	sling2.TransZ = -20
	LStep = 0
	LeftSlingShot.TimerEnabled = 1
	If ExpSlings = 1 Then
		activeball.velx = cor.ballvelx(activeball.id)
		activeball.vely = cor.ballvely(activeball.id)
		leftsling1.enabled = 1
		leftsling2.enabled = 1
		leftsling1.rotatetoend
		leftsling2.rotatetoend
	End If
End Sub

Sub LeftSlingShot2_Slingshot
	LeftSlingShot_Slingshot
End Sub

Sub LeftSlingShot_Timer
    Select Case LStep
        Case 3:LSLing1.Visible = 0:LSLing2.Visible = 1:sling2.TransZ = -10
			If ExpSlings = 1 Then
				leftsling1.rotatetostart
				leftsling2.rotatetostart
			End If
        Case 4:LSLing2.Visible = 0:LSLing.Visible = 1:sling2.TransZ = 0:LeftSlingShot.TimerEnabled = 0
			If ExpSlings = 1 Then
				leftsling1.enabled=0	
				leftsling2.enabled=0
			End If
    End Select
    LStep = LStep + 1
End Sub

Sub WallLL_Hit
	RubberLL1.Visible = 1:RubberLL.Visible = 0:WallLLt.Enabled = 1
End Sub	

Sub WallLLt_Timer
	RubberLL1.Visible = 0:RubberLL.Visible = 1:me.Enabled = 0
End Sub

Sub WallRL_Hit
	RubberRL1.Visible = 1:RubberRL.Visible = 0:WallRLt.Enabled = 1
End Sub	

Sub WallRLt_Timer
	RubberRL1.Visible = 0:RubberRL.Visible = 1:me.Enabled = 0
End Sub

Sub WallRLM_Hit
	RubberRLM1.Visible = 1:RubberRLM.Visible = 0:WallRLMt.Enabled = 1
End Sub	

Sub WallRLMt_Timer
	RubberRLM1.Visible = 0:RubberRLM.Visible = 1:me.Enabled = 0
End Sub


Sub T10Points1t_Timer
	RubberLM1.Visible = 0:RubberLM.Visible = 1:me.Enabled = 0
End Sub

Sub T10Points2t_Timer
	RubberLU1.Visible = 0:RubberLU.Visible = 1:me.Enabled = 0
End Sub

Sub T10Points4t_Timer
	RubberRUM1.Visible = 0:RubberRUM.Visible = 1:me.Enabled = 0
End Sub

Sub T10Points5t_Timer
	RubberRU1.Visible = 0:RubberRU.Visible = 1:me.Enabled = 0
End Sub

'******************************************************
' 					LOAD & SAVE TABLE
'******************************************************
sub savehs
    savevalue "JiveTime_VPX", "Credits", Credits
	savevalue "JiveTime_VPX", "Match", Match
	savevalue "JiveTime_VPX", "SpinnerAngle", SpinnerAngle
	savevalue "JiveTime_VPX", "Bonus", Bonus
	savevalue "JiveTime_VPX", "HighScore", Highscore
	savevalue "JiveTime_VPX", "HSA1", HSA1
	savevalue "JiveTime_VPX", "HSA2", HSA2
	savevalue "JiveTime_VPX", "HSA3", HSA3
	savevalue "JiveTime_VPX", "BallInPlay", BallInPlay
	savevalue "JiveTime_VPX", "Score", Score
	savevalue "JiveTime_VPX", "SpecialLight", SpecialLight.state
end sub

sub loadhs
	HighScore=0
	Credits=0
	Match=0
	SpinnerAngle = 0

    dim temp
	temp = LoadValue("JiveTime_VPX", "Credits")
    If (temp <> "") then Credits = CDbl(temp)
    temp = LoadValue("JiveTime_VPX", "Match")
    If (temp <> "") then Match = CDbl(temp)
    temp = LoadValue("JiveTime_VPX", "SpinnerAngle")
    If (temp <> "") then SpinnerAngle = CDbl(temp)
    temp = LoadValue("JiveTime_VPX", "Bonus")
    If (temp <> "") then Bonus = CDbl(temp)
    temp = LoadValue("JiveTime_VPX", "HighScore")
    If (temp <> "") then HighScore = CDbl(temp)
    temp = LoadValue("JiveTime_VPX", "hsa1")
    If (temp <> "") then HSA1 = CDbl(temp)
    temp = LoadValue("JiveTime_VPX", "hsa2")
    If (temp <> "") then HSA2 = CDbl(temp)
    temp = LoadValue("JiveTime_VPX", "hsa3")
    If (temp <> "") then HSA3 = CDbl(temp)
    temp = LoadValue("JiveTime_VPX", "BallInPlay")
    If (temp <> "") then BallInPlay = CDbl(temp)
    temp = LoadValue("JiveTime_VPX", "Score")
    If (temp <> "") then Score = CDbl(temp)
    temp = LoadValue("JiveTime_VPX", "SpecialLight")
    If (temp <> "") then SpecialLightState = CDbl(temp)
	SetReels 

	if HighScore=0 then HighScore=50000
end sub

'******************************************************
' 							TILT
'******************************************************

Dim TiltSens

Sub CheckTilt
	If Tilttimer.Enabled = True Then 
	 TiltSens = TiltSens + 1
	 if TiltSens = 3 Then GameTilted
	Else
	 TiltSens = 1
	 Tilttimer.Enabled = True
	End If
End Sub

Sub Tilttimer_Timer()
	If TiltSens > 0 Then TiltSens = TiltSens - 1
	If TiltSens = 0 Then Tilttimer.Enabled = False
End Sub

Sub GameTilted
	TableTilted = 1
	CloseWestGate
	SpecialLight.state=0
	GreenLightsOff
	YellowLightsOff
	DownPosts
	DOF 134, 2

	Bumper1.threshold = 100
	Bumper2.threshold = 100
	Bumper3.threshold = 100
	Bumper4.threshold = 100
	Bumper5.threshold = 100

	LeftSlingShot.SlingShotThreshold = 100
	RightSlingShot.SlingShotThreshold = 100
	LeftSlingShot2.SlingShotThreshold = 100
	RightSlingShot2.SlingShotThreshold = 100

	PlayLoudClick
	BackglassTilt.visible = true
	If B2SOn Then Controller.B2SSetTilt 1


	FlipperDeActivate LeftFlipper, LFPress
	LeftFlipper.RotateToStart
	StopSound "buzzL"
	DOF 101, 0

	FlipperDeActivate RightFlipper, RFPress
	RightFlipper.RotateToStart
	StopSound "buzz"
	DOF 102, 0
End Sub

Sub ResetTilt
	'DOF 134, 2
	Dim BumpThresh, SlingThresh
	BumpThresh = 1.6
	SlingThresh = 0.5

	TableTilted = 0

	Bumper1.threshold = BumpThresh
	Bumper2.threshold = BumpThresh
	Bumper3.threshold = BumpThresh
	Bumper4.threshold = BumpThresh
	Bumper5.threshold = BumpThresh

	LeftSlingShot.SlingShotThreshold = SlingThresh
	RightSlingShot.SlingShotThreshold = SlingThresh
	LeftSlingShot2.SlingShotThreshold = SlingThresh
	RightSlingShot2.SlingShotThreshold = SlingThresh
	If B2SOn Then Controller.B2SSetTilt 0
End Sub

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

'*****************************************
'   rothbauerw's Manual Ball Control
'*****************************************

Dim BCup, BCdown, BCleft, BCright
Dim ControlBallInPlay, ControlActiveBall
Dim BCvel, BCyveloffset, BCboostmulti, BCboost

BCboost = 1				'Do Not Change - default setting
BCvel = 4				'Controls the speed of the ball movement
BCyveloffset = -0.01 	'Offsets the force of gravity to keep the ball from drifting vertically on the table, should be negative
BCboostmulti = 3		'Boost multiplier to ball veloctiy (toggled with the B key) 

ControlBallInPlay = false

Sub StartBallControl_Hit()
	Set ControlActiveBall = ActiveBall
	ControlBallInPlay = true
End Sub

Sub StopBallControl_Hit()
	ControlBallInPlay = false
End Sub	

Sub BallControlTimer_Timer()
	If EnableBallControl and ControlBallInPlay then
		If BCright = 1 Then
			ControlActiveBall.velx =  BCvel*BCboost
		ElseIf BCleft = 1 Then
			ControlActiveBall.velx = -BCvel*BCboost
		Else
			ControlActiveBall.velx = 0
		End If

		If BCup = 1 Then
			ControlActiveBall.vely = -BCvel*BCboost
		ElseIf BCdown = 1 Then
			ControlActiveBall.vely =  BCvel*BCboost
		Else
			ControlActiveBall.vely = bcyveloffset
		End If
	End If
End Sub

'******************************************************
' 					REALTIME UPDATES
'******************************************************

Dim BallShadow, DropCount
BallShadow = Array (BallShadow1)

Const tnob = 1 ' total number of balls
ReDim rolling(tnob)

sub RealtimeUpdates_Timer()
	leftbat.objrotz = LeftFlipper.currentangle
	rightbat.objrotz = RightFlipper.currentangle
	FlipperLSh.RotZ = LeftFlipper.currentangle
	FlipperRSh.RotZ = RightFlipper.currentangle

	GateA.RotX = Gate1.CurrentAngle*0.6
	
	'West Gate
	diverter.roty = DiverterFlipper.currentangle + 90
	If DiverterFlipper.currentangle < -30 Then
		WestGateLight.state=1
	Else 
		If WestGateLight.state=1 Then
			CloseWestGate
			WestGateLight.state=0
		End If
	End If

	'Spinner
	spinner.rotz = SpinnerAngle + 90

	'*****************************************
	'	Ball Rolling Sounds
	'*****************************************

	If BallVel(JTBall ) > 1 AND JTBall.z < 30 Then
		rolling(0) = True
		PlaySound ("BallRoll_0"), -1, VolPlayfieldRoll(JTBall) * 1.1 * VolumeDial, AudioPan(JTBall), 0, PitchPlayfieldRoll(JTBall), 1, 0, AudioFade(JTBall)
	Else
		If rolling(0) = True Then
			StopSound("BallRoll_0")
			rolling(0) = False
		End If
	End If

	'*****************************************
	'	Ball Shadow
	'*****************************************
	
	BallShadow(0).X = JTBall.X - (TableWidth/2 - JTBall.X)/20
	ballShadow(0).Y = JTBall.Y + 10

	If JTBall.Z > 22 and JTBall.Z < 35 Then
		BallShadow(0).visible = 1
	Else
		BallShadow(0).visible = 0
	End If

	'*****************************************
	'	Ball Drop Sounds
	'*****************************************

	If JTBall.VelZ < -1 and JTBall.z < 55 and JTBall.z > 27 Then 'height adjust for ball drop sounds
		If DropCount >= 5 Then
			RandomSoundBallBouncePlayfieldSoft
			DropCount = 0
		End If
	End If
	If DropCount < 5 Then
		DropCount = DropCount + 1
	End If

End Sub


Sub PlayLoudClick()
	PlaySoundAtVol "Motor_Click_Loud_Long", Spinner, 0.05
End Sub

Sub PlayQuietClick()
	PlaySoundAtVol "Motor_Click_Quiet_Long2", Spinner, 0.05
End Sub


'==========================================================================================================================================
'============================================================= START OF HIGH SCORES ROUTINES =============================================================
'==========================================================================================================================================
'
'ADD LINE TO TABLE_KEYDOWN SUB WITH THE FOLLOWING:    If HSEnterMode Then HighScoreProcessKey(keycode) AFTER THE STARTGAME ENTRY
'ADD: And Not HSEnterMode=true TO IF KEYCODE=STARTGAMEKEY
'TO SHOW THE SCORE ON POST-IT ADD LINE AT RELEVENT LOCATION THAT HAS:  UpdatePostIt
'TO INITIATE ADDING INITIALS ADD LINE AT RELEVENT LOCATION THAT HAS:  HighScoreEntryInit()
'ADD THE FOLLOWING LINES TO TABLE_INIT TO SETUP POSTIT
'	if HSA1="" then HSA1=25
'	if HSA2="" then HSA2=25
'	if HSA3="" then HSA3=25
'	UpdatePostIt
'ADD HSA1, HSA2 AND HSA3 TO SAVE AND LOAD VALUES FOR TABLE
'ADD A TIMER NAMED HighScoreFlashTimer WITH INTERVAL 100 TO TABLE
'SET HSSSCOREX BELOW TO WHATEVER VARIABLE YOU USE FOR HIGH SCORE.
'ADD OBJECTS TO PLAYFIELD (EASIEST TO JUST COPY FROM THIS TABLE)
'IMPORT POST-IT IMAGES


Dim HSA1, HSA2, HSA3
Dim HSEnterMode, hsLetterFlash, hsEnteredDigits(3), hsCurrentDigit, hsCurrentLetter
Dim HSArray  
Dim HSScoreM,HSScore100k, HSScore10k, HSScoreK, HSScore100, HSScore10, HSScore1, HSScorex	'Define 6 different score values for each reel to use
HSArray = Array("Postit0","postit1","postit2","postit3","postit4","postit5","postit6","postit7","postit8","postit9","postitBL","postitCM","Tape")
Const hsFlashDelay = 4

' ***********************************************************
'  HiScore DISPLAY 
' ***********************************************************

Sub UpdatePostIt
	dim tempscore
	HSScorex = HighScore
	TempScore = HSScorex
	HSScore1 = 0
	HSScore10 = 0
	HSScore100 = 0
	HSScoreK = 0
	HSScore10k = 0
	HSScore100k = 0
	HSScoreM = 0
	if len(TempScore) > 0 Then
		HSScore1 = cint(right(Tempscore,1))
	end If
	if len(TempScore) > 1 Then
		TempScore = Left(TempScore,len(TempScore)-1)
		HSScore10 = cint(right(Tempscore,1))
	end If
	if len(TempScore) > 1 Then
		TempScore = Left(TempScore,len(TempScore)-1)
		HSScore100 = cint(right(Tempscore,1))
	end If
	if len(TempScore) > 1 Then
		TempScore = Left(TempScore,len(TempScore)-1)
		HSScoreK = cint(right(Tempscore,1))
	end If
	if len(TempScore) > 1 Then
		TempScore = Left(TempScore,len(TempScore)-1)
		HSScore10k = cint(right(Tempscore,1))
	end If
	if len(TempScore) > 1 Then
		TempScore = Left(TempScore,len(TempScore)-1)
		HSScore100k = cint(right(Tempscore,1))
	end If
	if len(TempScore) > 1 Then
		TempScore = Left(TempScore,len(TempScore)-1)
		HSScoreM = cint(right(Tempscore,1))
	end If
	Pscore6.image = HSArray(HSScoreM):If HSScorex<1000000 Then PScore6.image = HSArray(10)
	Pscore5.image = HSArray(HSScore100K):If HSScorex<100000 Then PScore5.image = HSArray(10)
	PScore4.image = HSArray(HSScore10K):If HSScorex<10000 Then PScore4.image = HSArray(10)
	PScore3.image = HSArray(HSScoreK):If HSScorex<1000 Then PScore3.image = HSArray(10)
	PScore2.image = HSArray(HSScore100):If HSScorex<100 Then PScore2.image = HSArray(10)
	PScore1.image = HSArray(HSScore10):If HSScorex<10 Then PScore1.image = HSArray(10)
	PScore0.image = HSArray(HSScore1):If HSScorex<1 Then PScore0.image = HSArray(10)
	if HSScorex<1000 then
		PComma.image = HSArray(10)
	else
		PComma.image = HSArray(11)
	end if
	if HSScorex<1000000 then
		PComma2.image = HSArray(10)
	else
		PComma2.image = HSArray(11)
	end if
'	if showhisc=1 and showhiscnames=1 then
'		for each objekt in hiscname:objekt.visible=1:next
		HSName1.image = ImgFromCode(HSA1, 1)
		HSName2.image = ImgFromCode(HSA2, 2)
		HSName3.image = ImgFromCode(HSA3, 3)
'	  else
'		for each objekt in hiscname:objekt.visible=0:next
'	end if
End Sub

Function ImgFromCode(code, digit)
	Dim Image
	if (HighScoreFlashTimer.Enabled = True and hsLetterFlash = 1 and digit = hsCurrentLetter) then
		Image = "postitBL"
	elseif (code + ASC("A") - 1) >= ASC("A") and (code + ASC("A") - 1) <= ASC("Z") then
		Image = "postit" & chr(code + ASC("A") - 1)
	elseif code = 27 Then
		Image = "PostitLT"
    elseif code = 0 Then
		image = "PostitSP"
    Else
      msgbox("Unknown display code: " & code)
	end if
	ImgFromCode = Image
End Function

Sub HighScoreEntryInit()
	HSA1=0:HSA2=0:HSA3=0
	HSEnterMode = True
	hsCurrentDigit = 0
	hsCurrentLetter = 1:HSA1=1
	HighScoreFlashTimer.Interval = 250
	HighScoreFlashTimer.Enabled = True
	hsLetterFlash = hsFlashDelay
End Sub

Sub HighScoreFlashTimer_Timer()
	hsLetterFlash = hsLetterFlash-1
	UpdatePostIt
	If hsLetterFlash=0 then 'switch back
		hsLetterFlash = hsFlashDelay
	end if
End Sub


' ***********************************************************
'  HiScore ENTER INITIALS 
' ***********************************************************

Sub HighScoreProcessKey(keycode)
    If keycode = LeftFlipperKey Then
		hsLetterFlash = hsFlashDelay
		Select Case hsCurrentLetter
			Case 1:
				HSA1=HSA1-1:If HSA1=-1 Then HSA1=26 'no backspace on 1st digit
				UpdatePostIt
			Case 2:
				HSA2=HSA2-1:If HSA2=-1 Then HSA2=27
				UpdatePostIt
			Case 3:
				HSA3=HSA3-1:If HSA3=-1 Then HSA3=27
				UpdatePostIt
		 End Select
    End If

	If keycode = RightFlipperKey Then
		hsLetterFlash = hsFlashDelay
		Select Case hsCurrentLetter
			Case 1:
				HSA1=HSA1+1:If HSA1>26 Then HSA1=0
				UpdatePostIt
			Case 2:
				HSA2=HSA2+1:If HSA2>27 Then HSA2=0
				UpdatePostIt
			Case 3:
				HSA3=HSA3+1:If HSA3>27 Then HSA3=0
				UpdatePostIt
		 End Select
	End If
	
    If keycode = StartGameKey Then
		Select Case hsCurrentLetter
			Case 1:
				hsCurrentLetter=2 'ok to advance
				HSA2=HSA1 'start at same alphabet spot
'				EMReelHSName1.SetValue HSA1:EMReelHSName2.SetValue HSA2
			Case 2:
				If HSA2=27 Then 'bksp
					HSA2=0
					hsCurrentLetter=1
				Else
					hsCurrentLetter=3 'enter it
					HSA3=HSA2 'start at same alphabet spot
				End If
			Case 3:
				If HSA3=27 Then 'bksp
					HSA3=0
					hsCurrentLetter=2
				Else
					savehs 'enter it
					HighScoreFlashTimer.Enabled = False
					HSEnterMode = False
				End If
		End Select
		UpdatePostIt
    End If
End Sub

'******************************************************
'				VR FUNCTIONS
'******************************************************

Dim BGx, BGy, BGz
BGx = -1100
BGy = 610
BGz = 900

Sub Setup_Mode()
	Dim Object

	If VRRoom = 1 then 
		for each object in VRRoomCol: object.visible = 1: next
		VR_Timer.enabled = true
		VR_ClockTimer.enabled = true
	Else
		for each Object in VRRoomCol: object.visible = 0: next
		VR_ClockTimer.enabled = False
		VR_Timer.enabled = True

		If Table1.ShowDT = True and Table1.ShowFSS = False then
			for each object in VRBackglass
				object.x = object.x + BGx
				object.y = object.y + BGy
				object.z = object.z - BGz
			next

			for each object in VRBackglassFlashers
				object.x = object.x + BGx
				object.y = object.y + BGy
				object.height = object.height - BGz
			next
		End If

	End If
End Sub

' VR Clock code below....
Sub VR_ClockTimer_Timer()
	VR_Pminutes.RotAndTra2 = (Minute(Now())+(Second(Now())/100))*6
	VR_Phours.RotAndTra2 = Hour(Now())*30+(Minute(Now())/2)
    VR_Pseconds.RotAndTra2 = (Second(Now()))*6
End Sub

' Lavalamp code below.  Thank you STEELY!
Dim Lspeed(7), Lbob(7), blobAng(7), blobRad(7), blobSiz(7), Blob, Bcnt
Dim beerspeed, DKCnt, DKCnt2
beerspeed = 0.75
DKCnt2 = 1

Bcnt = 0
For Each Blob in Lspeed
	Lbob(Bcnt) = .2
	Lspeed(Bcnt) = Int((5 * Rnd) + 2) * .07
	Bcnt = Bcnt + 1
Next


Sub VR_Timer_Timer()
	VRPlunger.Y = 2185 + (5* Plunger.Position) -25

	If VRRoom = 1 Then
		Bcnt = 0
		For Each Blob in VRLava
			If Blob.TransZ <= VR_LavaBase.Size_Z * 1.5 Then 	'Change blob direction to up
				Lspeed(Bcnt) = Int((5 * Rnd) + 2) * .05		'travel speed
				blobAng(Bcnt) = Int((359 * Rnd) + 1)			'blob location/angle from center
				blobRad(Bcnt) = Int((40 * Rnd) + 10)			'blob distance from center, radius
				blobSiz(Bcnt) = Int((150 * Rnd) + 100)		'blob size
				Blob.Size_x = blobSiz(Bcnt):Blob.Size_y = blobSiz(Bcnt):Blob.Size_z = blobSiz(Bcnt)
				Blob.X = Round(Cos(blobAng(Bcnt)*0.0174533), 3) * blobRad(Bcnt) + VR_LavaBase.X	'place blob
				Blob.Y = Round(Sin(blobAng(Bcnt)*0.0174533), 3) * blobRad(Bcnt) + VR_LavaBase.Y
			End If

			If Blob.TransZ => VR_LavaBase.Size_Z*5 Then		'Change blob direction to down
				blobAng(Bcnt) = Int((359 * Rnd) + 1)			'blob location/angle from center
				blobRad(Bcnt) = Int((40 * Rnd) + 10)			'blob distance from center,radius
				Blob.X = Round(Cos(blobAng(Bcnt)*0.0174533), 3) * blobRad(Bcnt) + VR_LavaBase.X	'place blob
				Blob.Y = Round(Sin(blobAng(Bcnt)*0.0174533), 3) * blobRad(Bcnt) + VR_LavaBase.Y
				Lspeed(Bcnt) = Int((8 * Rnd) + 5) * .05:Lspeed(Bcnt) = Lspeed(Bcnt) * -1				'travel speed
			End If

			'Make blob wobble
			If Blob.Size_x > blobSiz(Bcnt) + blobSiz(Bcnt)*.15 or Blob.Size_x < blobSiz(Bcnt) - blobSiz(Bcnt)*.15  Then Lbob(Bcnt) = Lbob(Bcnt) * -1
			Blob.Size_x = Blob.Size_x + Lbob(Bcnt)
			Blob.Size_y = Blob.Size_y + Lbob(Bcnt)
			Blob.Size_z = Blob.Size_Z - Lbob(Bcnt) * .66
			Blob.TransZ = Blob.TransZ + Lspeed(Bcnt)		'Move blob
			Bcnt = Bcnt + 1
		Next

		Randomize(21)
		VR_BeerBubble1.z = VR_BeerBubble1.z + Rnd(1)*0.5*beerspeed
		if VR_BeerBubble1.z > -771 then VR_BeerBubble1.z = -955

		VR_BeerBubble2.z = VR_BeerBubble2.z + Rnd(1)*1*beerspeed
		if VR_BeerBubble2.z > -768 then VR_BeerBubble2.z = -955

		VR_BeerBubble3.z = VR_BeerBubble3.z + Rnd(1)*1*beerspeed
		if VR_BeerBubble3.z > -768 then VR_BeerBubble3.z = -955

		VR_BeerBubble4.z = VR_BeerBubble4.z + Rnd(1)*0.75*beerspeed
		if VR_BeerBubble4.z > -774 then VR_BeerBubble4.z = -955

		VR_BeerBubble5.z = VR_BeerBubble5.z + Rnd(1)*1*beerspeed
		if VR_BeerBubble5.z > -771 then VR_BeerBubble5.z = -955

		VR_BeerBubble6.z = VR_BeerBubble6.z + Rnd(1)*1*beerspeed
		if VR_BeerBubble6.z > -774 then VR_BeerBubble6.z = -955

		VR_BeerBubble7.z = VR_BeerBubble7.z + Rnd(1)*0.8*beerspeed
		if VR_BeerBubble7.z > -768 then VR_BeerBubble7.z = -955

		VR_BeerBubble8.z = VR_BeerBubble8.z + Rnd(1)*1*beerspeed
		if VR_BeerBubble8.z > -771 then VR_BeerBubble8.z = -955


		DKCnt = DKCnt + 1
		
		If DKCnt > 13 Then
			DKCnt = 0
			VR_DKTube.Image = "VR_gil " & DKCnt2
			DKCnt2 = DKCnt2 + 1
			If DKCnt2 > 17 Then
				DKCnt2 = 1
			End If
		End If
	End If
End Sub


'////////////////////////////  MECHANICAL SOUNDS  ///////////////////////////
'//  This part in the script is an entire block that is dedicated to the physics sound system.
'//  Various scripts and sounds that may be pretty generic and could suit other WPC systems, but the most are tailored specifically for this table.

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
Dim RubberStrongSoundFactor, RubberWeakSoundFactor, RubberFlipperSoundFactor
Dim BallBouncePlayfieldSoftFactor, BallBouncePlayfieldHardFactor, PlasticRampDropToPlayfieldSoundLevel, WireRampDropToPlayfieldSoundLevel, DelayedBallDropOnPlayfieldSoundLevel
Dim WallImpactSoundFactor, MetalImpactSoundFactor, SubwaySoundLevel, SubwayEntrySoundLevel, ScoopEntrySoundLevel
Dim SaucerLockSoundLevel, SaucerKickSoundLevel

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


' *********************************************************************
'                      Supporting Ball & Sound Functions
' *********************************************************************

Function AudioFade(tableobj) ' Fades between front and back of the table (for surround systems or 2x2 speakers, etc), depending on the Y position on the table. "table1" is the name of the table
	Dim tmp
    tmp = tableobj.y * 2 / tableheight-1
    If tmp > 0 Then
		AudioFade = Csng(tmp ^10)
    Else
        AudioFade = Csng(-((- tmp) ^10) )
    End If
End Function

Function AudioPan(tableobj) ' Calculates the pan for a tableobj based on the X position on the table. "table1" is the name of the table
    Dim tmp
    tmp = tableobj.x * 2 / tablewidth-1
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
	PlaySoundAtLevelStatic ("Start_Button"), StartButtonSoundLevel, Drain
End Sub

Sub SoundNudgeLeft()
	Select Case Int(Rnd*3)+1
		Case 1 : PlaySound ("Nudge_1"), 0, NudgeLeftSoundLevel * VolumeDial, -0.1, 0.25
		Case 2 : PlaySound ("Nudge_2"), 0, NudgeLeftSoundLevel * VolumeDial, -0.1, 0.25
		Case 3 : PlaySound ("Nudge_3"), 0, NudgeLeftSoundLevel * VolumeDial, -0.1, 0.25
	End Select
End Sub

Sub SoundNudgeRight()
	Select Case Int(Rnd*3)+1
		Case 1 : PlaySound ("Nudge_1"), 0, NudgeRightSoundLevel * VolumeDial, 0.1, 0.25
		Case 2 : PlaySound ("Nudge_2"), 0, NudgeRightSoundLevel * VolumeDial, 0.1, 0.25
		Case 3 : PlaySound ("Nudge_3"), 0, NudgeRightSoundLevel * VolumeDial, 0.1, 0.25
	End Select
End Sub

Sub SoundNudgeCenter()
	Select Case Int(Rnd*3)+1
		Case 1 : PlaySoundAtLevelStatic ("Nudge_1"), NudgeCenterSoundLevel * VolumeDial, Drain
		Case 2 : PlaySoundAtLevelStatic ("Nudge_2"), NudgeCenterSoundLevel * VolumeDial, Drain
		Case 3 : PlaySoundAtLevelStatic ("Nudge_3"), NudgeCenterSoundLevel * VolumeDial, Drain
	End Select
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
	DOF 124, 2
End Sub

'/////////////////////////////  DRAIN SOUNDS  ////////////////////////////
Sub RandomSoundDrain(drainswitch)
	Select Case Int(Rnd*11)+1
		Case 1 : PlaySoundAtLevelStatic ("Drain_1"), DrainSoundLevel, drainswitch
		Case 2 : PlaySoundAtLevelStatic ("Drain_2"), DrainSoundLevel, drainswitch
		Case 3 : PlaySoundAtLevelStatic ("Drain_3"), DrainSoundLevel, drainswitch
		Case 4 : PlaySoundAtLevelStatic ("Drain_4"), DrainSoundLevel, drainswitch
		Case 5 : PlaySoundAtLevelStatic ("Drain_5"), DrainSoundLevel, drainswitch
		Case 6 : PlaySoundAtLevelStatic ("Drain_6"), DrainSoundLevel, drainswitch
		Case 7 : PlaySoundAtLevelStatic ("Drain_7"), DrainSoundLevel, drainswitch
		Case 8 : PlaySoundAtLevelStatic ("Drain_8"), DrainSoundLevel, drainswitch
		Case 9 : PlaySoundAtLevelStatic ("Drain_9"), DrainSoundLevel, drainswitch
		Case 10 : PlaySoundAtLevelStatic ("Drain_10"), DrainSoundLevel, drainswitch
		Case 11 : PlaySoundAtLevelStatic ("Drain_11"), DrainSoundLevel, drainswitch
	End Select
End Sub

'/////////////////////////////  TROUGH BALL RELEASE SOLENOID SOUNDS  ////////////////////////////
Sub RandomSoundBallRelease(drainswitch)
	Select Case Int(Rnd*7)+1
		Case 1 : PlaySoundAtLevelStatic SoundFX("BallRelease1",DOFContactors), BallReleaseSoundLevel, drainswitch
		Case 2 : PlaySoundAtLevelStatic SoundFX("BallRelease2",DOFContactors), BallReleaseSoundLevel, drainswitch
		Case 3 : PlaySoundAtLevelStatic SoundFX("BallRelease3",DOFContactors), BallReleaseSoundLevel, drainswitch
		Case 4 : PlaySoundAtLevelStatic SoundFX("BallRelease4",DOFContactors), BallReleaseSoundLevel, drainswitch
		Case 5 : PlaySoundAtLevelStatic SoundFX("BallRelease5",DOFContactors), BallReleaseSoundLevel, drainswitch
		Case 6 : PlaySoundAtLevelStatic SoundFX("BallRelease6",DOFContactors), BallReleaseSoundLevel, drainswitch
		Case 7 : PlaySoundAtLevelStatic SoundFX("BallRelease7",DOFContactors), BallReleaseSoundLevel, drainswitch
	End Select
End Sub



'/////////////////////////////  SLINGSHOT SOLENOID SOUNDS  ////////////////////////////
Sub RandomSoundSlingshotLeft()
	Select Case Int(Rnd*10)+1
		Case 1 : PlaySoundAtLevelStatic SoundFX("Sling_L1",DOFContactors), SlingshotSoundLevel, Sling2
		Case 2 : PlaySoundAtLevelStatic SoundFX("Sling_L2",DOFContactors), SlingshotSoundLevel, Sling2
		Case 3 : PlaySoundAtLevelStatic SoundFX("Sling_L3",DOFContactors), SlingshotSoundLevel, Sling2
		Case 4 : PlaySoundAtLevelStatic SoundFX("Sling_L4",DOFContactors), SlingshotSoundLevel, Sling2
		Case 5 : PlaySoundAtLevelStatic SoundFX("Sling_L5",DOFContactors), SlingshotSoundLevel, Sling2
		Case 6 : PlaySoundAtLevelStatic SoundFX("Sling_L6",DOFContactors), SlingshotSoundLevel, Sling2
		Case 7 : PlaySoundAtLevelStatic SoundFX("Sling_L7",DOFContactors), SlingshotSoundLevel, Sling2
		Case 8 : PlaySoundAtLevelStatic SoundFX("Sling_L8",DOFContactors), SlingshotSoundLevel, Sling2
		Case 9 : PlaySoundAtLevelStatic SoundFX("Sling_L9",DOFContactors), SlingshotSoundLevel, Sling2
		Case 10 : PlaySoundAtLevelStatic SoundFX("Sling_L10",DOFContactors), SlingshotSoundLevel, Sling2
	End Select
End Sub

Sub RandomSoundSlingshotRight()
	Select Case Int(Rnd*8)+1
		Case 1 : PlaySoundAtLevelStatic SoundFX("Sling_R1",DOFContactors), SlingshotSoundLevel, Sling1
		Case 2 : PlaySoundAtLevelStatic SoundFX("Sling_R2",DOFContactors), SlingshotSoundLevel, Sling1
		Case 3 : PlaySoundAtLevelStatic SoundFX("Sling_R3",DOFContactors), SlingshotSoundLevel, Sling1
		Case 4 : PlaySoundAtLevelStatic SoundFX("Sling_R4",DOFContactors), SlingshotSoundLevel, Sling1
		Case 5 : PlaySoundAtLevelStatic SoundFX("Sling_R5",DOFContactors), SlingshotSoundLevel, Sling1
		Case 6 : PlaySoundAtLevelStatic SoundFX("Sling_R6",DOFContactors), SlingshotSoundLevel, Sling1
		Case 7 : PlaySoundAtLevelStatic SoundFX("Sling_R7",DOFContactors), SlingshotSoundLevel, Sling1
		Case 8 : PlaySoundAtLevelStatic SoundFX("Sling_R8",DOFContactors), SlingshotSoundLevel, Sling1
	End Select
End Sub

'/////////////////////////////  BUMPER SOLENOID SOUNDS  ////////////////////////////
Sub RandomSoundBumperTop(Bump)
	Select Case Int(Rnd*5)+1
		Case 1 : PlaySoundAtLevelStatic SoundFX("Bumpers_Top_1",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
		Case 2 : PlaySoundAtLevelStatic SoundFX("Bumpers_Top_2",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
		Case 3 : PlaySoundAtLevelStatic SoundFX("Bumpers_Top_3",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
		Case 4 : PlaySoundAtLevelStatic SoundFX("Bumpers_Top_4",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
		Case 5 : PlaySoundAtLevelStatic SoundFX("Bumpers_Top_5",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
	End Select
End Sub

Sub RandomSoundBumperMiddle(Bump)
	Select Case Int(Rnd*5)+1
		Case 1 : PlaySoundAtLevelStatic SoundFX("Bumpers_Middle_1",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
		Case 2 : PlaySoundAtLevelStatic SoundFX("Bumpers_Middle_2",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
		Case 3 : PlaySoundAtLevelStatic SoundFX("Bumpers_Middle_3",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
		Case 4 : PlaySoundAtLevelStatic SoundFX("Bumpers_Middle_4",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
		Case 5 : PlaySoundAtLevelStatic SoundFX("Bumpers_Middle_5",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
	End Select
End Sub

Sub RandomSoundBumperBottom(Bump)
	Select Case Int(Rnd*5)+1
		Case 1 : PlaySoundAtLevelStatic SoundFX("Bumpers_Bottom_1",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
		Case 2 : PlaySoundAtLevelStatic SoundFX("Bumpers_Bottom_2",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
		Case 3 : PlaySoundAtLevelStatic SoundFX("Bumpers_Bottom_3",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
		Case 4 : PlaySoundAtLevelStatic SoundFX("Bumpers_Bottom_4",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
		Case 5 : PlaySoundAtLevelStatic SoundFX("Bumpers_Bottom_5",DOFContactors), Vol(ActiveBall) * BumperSoundFactor, Bump
	End Select
End Sub

'/////////////////////////////  FLIPPER BATS SOUND SUBROUTINES  ////////////////////////////
'/////////////////////////////  FLIPPER BATS SOLENOID ATTACK SOUND  ////////////////////////////
Sub SoundFlipperUpAttackLeft(flipper)
	FlipperUpAttackLeftSoundLevel = RndNum(FlipperUpAttackMinimumSoundLevel, FlipperUpAttackMaximumSoundLevel)
	PlaySoundAtLevelStatic ("Flipper_Attack-L01"), FlipperUpAttackLeftSoundLevel, flipper
End Sub

Sub SoundFlipperUpAttackRight(flipper)
	FlipperUpAttackRightSoundLevel = RndNum(FlipperUpAttackMinimumSoundLevel, FlipperUpAttackMaximumSoundLevel)
		PlaySoundAtLevelStatic ("Flipper_Attack-R01"), FlipperUpAttackLeftSoundLevel, flipper
End Sub

'/////////////////////////////  FLIPPER BATS SOLENOID CORE SOUND  ////////////////////////////
Sub RandomSoundFlipperUpLeft(flipper)
	Select Case Int(Rnd*11)+1
		Case 1 : PlaySoundAtLevelStatic SoundFX("Flipper_L01",DOFFlippers), FlipperLeftHitParm, Flipper
		Case 2 : PlaySoundAtLevelStatic SoundFX("Flipper_L02",DOFFlippers), FlipperLeftHitParm, Flipper
		Case 3 : PlaySoundAtLevelStatic SoundFX("Flipper_L07",DOFFlippers), FlipperLeftHitParm, Flipper
		Case 4 : PlaySoundAtLevelStatic SoundFX("Flipper_L08",DOFFlippers), FlipperLeftHitParm, Flipper
		Case 5 : PlaySoundAtLevelStatic SoundFX("Flipper_L09",DOFFlippers), FlipperLeftHitParm, Flipper
		Case 6 : PlaySoundAtLevelStatic SoundFX("Flipper_L10",DOFFlippers), FlipperLeftHitParm, Flipper
		Case 7 : PlaySoundAtLevelStatic SoundFX("Flipper_L12",DOFFlippers), FlipperLeftHitParm, Flipper
		Case 8 : PlaySoundAtLevelStatic SoundFX("Flipper_L14",DOFFlippers), FlipperLeftHitParm, Flipper
		Case 9 : PlaySoundAtLevelStatic SoundFX("Flipper_L18",DOFFlippers), FlipperLeftHitParm, Flipper
		Case 10 : PlaySoundAtLevelStatic SoundFX("Flipper_L20",DOFFlippers), FlipperLeftHitParm, Flipper
		Case 11 : PlaySoundAtLevelStatic SoundFX("Flipper_L26",DOFFlippers), FlipperLeftHitParm, Flipper
	End Select
End Sub

Sub RandomSoundFlipperUpRight(flipper)
	Select Case Int(Rnd*11)+1
		Case 1 : PlaySoundAtLevelStatic SoundFX("Flipper_R01",DOFFlippers), FlipperRightHitParm, Flipper
		Case 2 : PlaySoundAtLevelStatic SoundFX("Flipper_R02",DOFFlippers), FlipperRightHitParm, Flipper
		Case 3 : PlaySoundAtLevelStatic SoundFX("Flipper_R03",DOFFlippers), FlipperRightHitParm, Flipper
		Case 4 : PlaySoundAtLevelStatic SoundFX("Flipper_R04",DOFFlippers), FlipperRightHitParm, Flipper
		Case 5 : PlaySoundAtLevelStatic SoundFX("Flipper_R05",DOFFlippers), FlipperRightHitParm, Flipper
		Case 6 : PlaySoundAtLevelStatic SoundFX("Flipper_R06",DOFFlippers), FlipperRightHitParm, Flipper
		Case 7 : PlaySoundAtLevelStatic SoundFX("Flipper_R07",DOFFlippers), FlipperRightHitParm, Flipper
		Case 8 : PlaySoundAtLevelStatic SoundFX("Flipper_R08",DOFFlippers), FlipperRightHitParm, Flipper
		Case 9 : PlaySoundAtLevelStatic SoundFX("Flipper_R09",DOFFlippers), FlipperRightHitParm, Flipper
		Case 10 : PlaySoundAtLevelStatic SoundFX("Flipper_R10",DOFFlippers), FlipperRightHitParm, Flipper
		Case 11 : PlaySoundAtLevelStatic SoundFX("Flipper_R11",DOFFlippers), FlipperRightHitParm, Flipper
	End Select
End Sub

Sub RandomSoundReflipUpLeft(flipper)
	Select Case Int(Rnd*3)+1
		Case 1 : PlaySoundAtLevelStatic SoundFX("Flipper_ReFlip_L01",DOFFlippers), (RndNum(0.8, 1))*FlipperUpSoundLevel, Flipper
		Case 2 : PlaySoundAtLevelStatic SoundFX("Flipper_ReFlip_L02",DOFFlippers), (RndNum(0.8, 1))*FlipperUpSoundLevel, Flipper
		Case 3 : PlaySoundAtLevelStatic SoundFX("Flipper_ReFlip_L03",DOFFlippers), (RndNum(0.8, 1))*FlipperUpSoundLevel, Flipper
	End Select
End Sub

Sub RandomSoundReflipUpRight(flipper)
	Select Case Int(Rnd*3)+1
		Case 1 : PlaySoundAtLevelStatic SoundFX("Flipper_ReFlip_R01",DOFFlippers), (RndNum(0.8, 1))*FlipperUpSoundLevel, Flipper
		Case 2 : PlaySoundAtLevelStatic SoundFX("Flipper_ReFlip_R02",DOFFlippers), (RndNum(0.8, 1))*FlipperUpSoundLevel, Flipper
		Case 3 : PlaySoundAtLevelStatic SoundFX("Flipper_ReFlip_R03",DOFFlippers), (RndNum(0.8, 1))*FlipperUpSoundLevel, Flipper
	End Select
End Sub

Sub RandomSoundFlipperDownLeft(flipper)
	Select Case Int(Rnd*7)+1
		Case 1 : PlaySoundAtLevelStatic SoundFX("Flipper_Left_Down_1",DOFFlippers), FlipperDownSoundLevel, Flipper
		Case 2 : PlaySoundAtLevelStatic SoundFX("Flipper_Left_Down_2",DOFFlippers), FlipperDownSoundLevel, Flipper
		Case 3 : PlaySoundAtLevelStatic SoundFX("Flipper_Left_Down_3",DOFFlippers), FlipperDownSoundLevel, Flipper
		Case 4 : PlaySoundAtLevelStatic SoundFX("Flipper_Left_Down_4",DOFFlippers), FlipperDownSoundLevel, Flipper
		Case 5 : PlaySoundAtLevelStatic SoundFX("Flipper_Left_Down_5",DOFFlippers), FlipperDownSoundLevel, Flipper
		Case 6 : PlaySoundAtLevelStatic SoundFX("Flipper_Left_Down_6",DOFFlippers), FlipperDownSoundLevel, Flipper
		Case 7 : PlaySoundAtLevelStatic SoundFX("Flipper_Left_Down_7",DOFFlippers), FlipperDownSoundLevel, Flipper
	End Select
End Sub

Sub RandomSoundFlipperDownRight(flipper)
	Select Case Int(Rnd*8)+1
		Case 1 : PlaySoundAtLevelStatic SoundFX("Flipper_Right_Down_1",DOFFlippers), FlipperDownSoundLevel, Flipper
		Case 2 : PlaySoundAtLevelStatic SoundFX("Flipper_Right_Down_2",DOFFlippers), FlipperDownSoundLevel, Flipper
		Case 3 : PlaySoundAtLevelStatic SoundFX("Flipper_Right_Down_3",DOFFlippers), FlipperDownSoundLevel, Flipper
		Case 4 : PlaySoundAtLevelStatic SoundFX("Flipper_Right_Down_4",DOFFlippers), FlipperDownSoundLevel, Flipper
		Case 5 : PlaySoundAtLevelStatic SoundFX("Flipper_Right_Down_5",DOFFlippers), FlipperDownSoundLevel, Flipper
		Case 6 : PlaySoundAtLevelStatic SoundFX("Flipper_Right_Down_6",DOFFlippers), FlipperDownSoundLevel, Flipper
		Case 7 : PlaySoundAtLevelStatic SoundFX("Flipper_Right_Down_7",DOFFlippers), FlipperDownSoundLevel, Flipper
		Case 8 : PlaySoundAtLevelStatic SoundFX("Flipper_Right_Down_8",DOFFlippers), FlipperDownSoundLevel, Flipper
	End Select
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
	Select Case Int(Rnd*7)+1
		Case 1 : PlaySoundAtLevelActiveBall ("Flipper_Rubber_1"), parm  * RubberFlipperSoundFactor
		Case 2 : PlaySoundAtLevelActiveBall ("Flipper_Rubber_2"), parm  * RubberFlipperSoundFactor
		Case 3 : PlaySoundAtLevelActiveBall ("Flipper_Rubber_3"), parm  * RubberFlipperSoundFactor
		Case 4 : PlaySoundAtLevelActiveBall ("Flipper_Rubber_4"), parm  * RubberFlipperSoundFactor
		Case 5 : PlaySoundAtLevelActiveBall ("Flipper_Rubber_5"), parm  * RubberFlipperSoundFactor
		Case 6 : PlaySoundAtLevelActiveBall ("Flipper_Rubber_6"), parm  * RubberFlipperSoundFactor
		Case 7 : PlaySoundAtLevelActiveBall ("Flipper_Rubber_7"), parm  * RubberFlipperSoundFactor
	End Select
End Sub

'/////////////////////////////  ROLLOVER SOUNDS  ////////////////////////////
Sub RandomSoundRollover()
	Select Case Int(Rnd*4)+1
		Case 1 : PlaySoundAtLevelActiveBall ("Rollover_1"), RolloverSoundLevel
		Case 2 : PlaySoundAtLevelActiveBall ("Rollover_2"), RolloverSoundLevel
		Case 3 : PlaySoundAtLevelActiveBall ("Rollover_3"), RolloverSoundLevel
		Case 4 : PlaySoundAtLevelActiveBall ("Rollover_4"), RolloverSoundLevel
	End Select
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

Sub RubberWheel_Hit(idx)
 	'RandomSoundRubberWeakWheel
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
	Select Case Int(Rnd*9)+1
		Case 1 : PlaySoundAtLevelActiveBall ("Rubber_1"), Vol(ActiveBall) * RubberWeakSoundFactor
		Case 2 : PlaySoundAtLevelActiveBall ("Rubber_2"), Vol(ActiveBall) * RubberWeakSoundFactor
		Case 3 : PlaySoundAtLevelActiveBall ("Rubber_3"), Vol(ActiveBall) * RubberWeakSoundFactor
		Case 4 : PlaySoundAtLevelActiveBall ("Rubber_3"), Vol(ActiveBall) * RubberWeakSoundFactor
		Case 5 : PlaySoundAtLevelActiveBall ("Rubber_5"), Vol(ActiveBall) * RubberWeakSoundFactor
		Case 6 : PlaySoundAtLevelActiveBall ("Rubber_6"), Vol(ActiveBall) * RubberWeakSoundFactor
		Case 7 : PlaySoundAtLevelActiveBall ("Rubber_7"), Vol(ActiveBall) * RubberWeakSoundFactor
		Case 8 : PlaySoundAtLevelActiveBall ("Rubber_8"), Vol(ActiveBall) * RubberWeakSoundFactor
		Case 9 : PlaySoundAtLevelActiveBall ("Rubber_9"), Vol(ActiveBall) * RubberWeakSoundFactor
	End Select
End Sub

Sub RandomSoundRubberWeakWheel()
	Select Case Int(Rnd*9)+1
		Case 1 : PlaySoundAtLevelActiveBall ("Rubber_1"), Vol(ActiveBall) * RubberWeakSoundFactor/10
		Case 2 : PlaySoundAtLevelActiveBall ("Rubber_2"), Vol(ActiveBall) * RubberWeakSoundFactor/10
		Case 3 : PlaySoundAtLevelActiveBall ("Rubber_3"), Vol(ActiveBall) * RubberWeakSoundFactor/10
		Case 4 : PlaySoundAtLevelActiveBall ("Rubber_3"), Vol(ActiveBall) * RubberWeakSoundFactor/10
		Case 5 : PlaySoundAtLevelActiveBall ("Rubber_5"), Vol(ActiveBall) * RubberWeakSoundFactor/10
		Case 6 : PlaySoundAtLevelActiveBall ("Rubber_6"), Vol(ActiveBall) * RubberWeakSoundFactor/10
		Case 7 : PlaySoundAtLevelActiveBall ("Rubber_7"), Vol(ActiveBall) * RubberWeakSoundFactor/10
		Case 8 : PlaySoundAtLevelActiveBall ("Rubber_8"), Vol(ActiveBall) * RubberWeakSoundFactor/10
		Case 9 : PlaySoundAtLevelActiveBall ("Rubber_9"), Vol(ActiveBall) * RubberWeakSoundFactor/10
	End Select
End Sub

'/////////////////////////////  WALL IMPACTS  ////////////////////////////
Sub Walls_Hit(idx)
 	dim finalspeed
  	finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
 	If finalspeed > 5 then
 		RandomSoundRubberStrong 1 
	End if
	If finalspeed <= 5 then
 		RandomSoundRubberWeak()
 	End If	
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
	Select Case Int(Rnd*13)+1
		Case 1 : PlaySoundAtLevelActiveBall ("Metal_Touch_1"), Vol(ActiveBall) * MetalImpactSoundFactor
		Case 2 : PlaySoundAtLevelActiveBall ("Metal_Touch_2"), Vol(ActiveBall) * MetalImpactSoundFactor
		Case 3 : PlaySoundAtLevelActiveBall ("Metal_Touch_3"), Vol(ActiveBall) * MetalImpactSoundFactor
		Case 4 : PlaySoundAtLevelActiveBall ("Metal_Touch_4"), Vol(ActiveBall) * MetalImpactSoundFactor
		Case 5 : PlaySoundAtLevelActiveBall ("Metal_Touch_5"), Vol(ActiveBall) * MetalImpactSoundFactor
		Case 6 : PlaySoundAtLevelActiveBall ("Metal_Touch_6"), Vol(ActiveBall) * MetalImpactSoundFactor
		Case 7 : PlaySoundAtLevelActiveBall ("Metal_Touch_7"), Vol(ActiveBall) * MetalImpactSoundFactor
		Case 8 : PlaySoundAtLevelActiveBall ("Metal_Touch_8"), Vol(ActiveBall) * MetalImpactSoundFactor
		Case 9 : PlaySoundAtLevelActiveBall ("Metal_Touch_9"), Vol(ActiveBall) * MetalImpactSoundFactor
		Case 10 : PlaySoundAtLevelActiveBall ("Metal_Touch_10"), Vol(ActiveBall) * MetalImpactSoundFactor
		Case 11 : PlaySoundAtLevelActiveBall ("Metal_Touch_11"), Vol(ActiveBall) * MetalImpactSoundFactor
		Case 12 : PlaySoundAtLevelActiveBall ("Metal_Touch_12"), Vol(ActiveBall) * MetalImpactSoundFactor
		Case 13 : PlaySoundAtLevelActiveBall ("Metal_Touch_13"), Vol(ActiveBall) * MetalImpactSoundFactor
	End Select
End Sub

'/////////////////////////////  METAL - EVENTS  ////////////////////////////

Sub Metals_Hit (idx)
	RandomSoundMetal
End Sub

Sub DiverterFlipper_collide(idx)
	RandomSoundMetal
End Sub

'/////////////////////////////  BOTTOM ARCH BALL GUIDE  ////////////////////////////
'/////////////////////////////  BOTTOM ARCH BALL GUIDE - SOFT BOUNCES  ////////////////////////////
Sub RandomSoundBottomArchBallGuide()
 	dim finalspeed
  	finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
 	If finalspeed > 16 then 
 		Select Case Int(Rnd*2)+1
			Case 1 : PlaySoundAtLevelActiveBall ("Apron_Bounce_1"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
			Case 2 : PlaySoundAtLevelActiveBall ("Apron_Bounce_2"), Vol(ActiveBall) * BottomArchBallGuideSoundFactor
		End Select
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
	Select Case Int(Rnd*3)+1
		Case 1 : PlaySoundAtLevelActiveBall ("Apron_Hard_Hit_1"), BottomArchBallGuideSoundFactor * 0.25
		Case 2 : PlaySoundAtLevelActiveBall ("Apron_Hard_Hit_2"), BottomArchBallGuideSoundFactor * 0.25
		Case 3 : PlaySoundAtLevelActiveBall ("Apron_Hard_Hit_3"), BottomArchBallGuideSoundFactor * 0.25
	End Select
End Sub


Sub Apron_Hit (idx)
	'debug.print cor.ballvelx(activeball.id)
	'debug.print cor.ballvely(activeball.id)
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
 		Select Case Int(Rnd*3)+1
			Case 1 : PlaySoundAtLevelActiveBall ("Apron_Medium_1"),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
			Case 2 : PlaySoundAtLevelActiveBall ("Apron_Medium_2"),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
			Case 3 : PlaySoundAtLevelActiveBall ("Apron_Medium_3"),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
		End Select
 	End If
	If finalspeed < 6 Then
 		Select Case Int(Rnd*7)+1
			Case 1 : PlaySoundAtLevelActiveBall ("Apron_Soft_1"),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
			Case 2 : PlaySoundAtLevelActiveBall ("Apron_Soft_2"),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
			Case 3 : PlaySoundAtLevelActiveBall ("Apron_Soft_3"),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
			Case 4 : PlaySoundAtLevelActiveBall ("Apron_Soft_4"),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
			Case 5 : PlaySoundAtLevelActiveBall ("Apron_Soft_5"),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
			Case 6 : PlaySoundAtLevelActiveBall ("Apron_Soft_6"),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
			Case 7 : PlaySoundAtLevelActiveBall ("Apron_Soft_7"),  Vol(ActiveBall) * FlipperBallGuideSoundFactor
		End Select
	End if
End Sub

'/////////////////////////////  TARGET HIT SOUNDS  ////////////////////////////
Sub RandomSoundTargetHitStrong()
	Select Case Int(Rnd*4)+1
		Case 1 : PlaySoundAtLevelActiveBall SoundFX("Target_Hit_5",DOFTargets), Vol(ActiveBall) * 0.45 * TargetSoundFactor
		Case 2 : PlaySoundAtLevelActiveBall SoundFX("Target_Hit_6",DOFTargets), Vol(ActiveBall) * 0.45 * TargetSoundFactor
		Case 3 : PlaySoundAtLevelActiveBall SoundFX("Target_Hit_7",DOFTargets), Vol(ActiveBall) * 0.45 * TargetSoundFactor
		Case 4 : PlaySoundAtLevelActiveBall SoundFX("Target_Hit_8",DOFTargets), Vol(ActiveBall) * 0.45 * TargetSoundFactor		
	End Select
End Sub

Sub RandomSoundTargetHitWeak()
	Select Case Int(Rnd*4)+1		
		Case 1 : PlaySoundAtLevelActiveBall SoundFX("Target_Hit_1",DOFTargets), Vol(ActiveBall) * TargetSoundFactor
		Case 2 : PlaySoundAtLevelActiveBall SoundFX("Target_Hit_2",DOFTargets), Vol(ActiveBall) * TargetSoundFactor
		Case 3 : PlaySoundAtLevelActiveBall SoundFX("Target_Hit_3",DOFTargets), Vol(ActiveBall) * TargetSoundFactor
		Case 4 : PlaySoundAtLevelActiveBall SoundFX("Target_Hit_4",DOFTargets), Vol(ActiveBall) * TargetSoundFactor
	End Select
End Sub

Sub PlayTargetSound()
 	dim finalspeed
  	finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
 	If finalspeed > 10 then
 		RandomSoundTargetHitStrong()
		RandomSoundBallBouncePlayfieldSoft()
	Else 
 		RandomSoundTargetHitWeak()
 	End If	
End Sub

Sub Targets_Hit (idx)
	'PlayTargetSound	
End Sub

'/////////////////////////////  BALL BOUNCE SOUNDS  ////////////////////////////
Sub RandomSoundBallBouncePlayfieldSoft()
	Select Case Int(Rnd*9)+1
		Case 1 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_1"), volz(JTBall) * BallBouncePlayfieldSoftFactor, JTBall
		Case 2 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_2"), volz(JTBall) * BallBouncePlayfieldSoftFactor * 0.5, JTBall
		Case 3 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_3"), volz(JTBall) * BallBouncePlayfieldSoftFactor * 0.8, JTBall
		Case 4 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_4"), volz(JTBall) * BallBouncePlayfieldSoftFactor * 0.5, JTBall
		Case 5 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Soft_5"), volz(JTBall) * BallBouncePlayfieldSoftFactor, JTBall
		Case 6 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_1"), volz(JTBall) * BallBouncePlayfieldSoftFactor * 0.2, JTBall
		Case 7 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_2"), volz(JTBall) * BallBouncePlayfieldSoftFactor * 0.2, JTBall
		Case 8 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_5"), volz(JTBall) * BallBouncePlayfieldSoftFactor * 0.2, JTBall
		Case 9 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_7"), volz(JTBall) * BallBouncePlayfieldSoftFactor * 0.3, JTBall
	End Select
End Sub

Sub RandomSoundBallBouncePlayfieldHard()
	Select Case Int(Rnd*7)+1
		Case 1 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_1"), volz(JTBall) * BallBouncePlayfieldHardFactor, JTBall
		Case 2 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_2"), volz(JTBall) * BallBouncePlayfieldHardFactor, JTBall
		Case 3 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_3"), volz(JTBall) * BallBouncePlayfieldHardFactor, JTBall
		Case 4 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_4"), volz(JTBall) * BallBouncePlayfieldHardFactor, JTBall
		Case 5 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_5"), volz(JTBall) * BallBouncePlayfieldHardFactor, JTBall
		Case 6 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_6"), volz(JTBall) * BallBouncePlayfieldHardFactor, JTBall
		Case 7 : PlaySoundAtLevelStatic ("Ball_Bounce_Playfield_Hard_7"), volz(JTBall) * BallBouncePlayfieldHardFactor, JTBall
	End Select
End Sub

'/////////////////////////////  DELAYED DROP - TO PLAYFIELD - SOUND  ////////////////////////////
Sub RandomSoundDelayedBallDropOnPlayfield()
	Select Case Int(Rnd*5)+1
		Case 1 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_1_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, JTBall
		Case 2 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_2_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, JTBall
		Case 3 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_3_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, JTBall
		Case 4 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_4_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, JTBall
		Case 5 : PlaySoundAtLevelStatic ("Ball_Drop_Playfield_5_Delayed"), DelayedBallDropOnPlayfieldSoundLevel, JTBall
	End Select
End Sub

'/////////////////////////////  BALL GATES AND BRACKET GATES SOUNDS  ////////////////////////////

Sub SoundPlayfieldGate()
	Select Case Int(Rnd*2)+1				
		Case 1 : PlaySoundAtLevelStatic ("Gate_FastTrigger_1"), GateSoundLevel, Activeball
		Case 2 : PlaySoundAtLevelStatic ("Gate_FastTrigger_2"), GateSoundLevel, Activeball
	End Select
End Sub

Sub SoundHeavyGate()
	PlaySoundAtLevelStatic ("Gate_2"), GateSoundLevel, Activeball
End Sub

Sub Gates_hit(idx)
	SoundHeavyGate
End Sub


'/////////////////////////////  LEFT LANE ENTRANCE - SOUNDS  ////////////////////////////

Sub RandomSoundLeftArch()
	Select Case Int(Rnd*4)+1
		Case 1 : PlaySoundAtLevelActiveBall ("Arch_L1"), Vol(ActiveBall) * ArchSoundFactor
		Case 2 : PlaySoundAtLevelActiveBall ("Arch_L2"), Vol(ActiveBall) * ArchSoundFactor
		Case 3 : PlaySoundAtLevelActiveBall ("Arch_L3"), Vol(ActiveBall) * ArchSoundFactor
		Case 4 : PlaySoundAtLevelActiveBall ("Arch_L4"), Vol(ActiveBall) * ArchSoundFactor
	End Select
End Sub

Sub RandomSoundRightArch()
	Select Case Int(Rnd*4)+1
		Case 1 : PlaySoundAtLevelActiveBall ("Arch_R1"), Vol(ActiveBall) * ArchSoundFactor
		Case 2 : PlaySoundAtLevelActiveBall ("Arch_R2"), Vol(ActiveBall) * ArchSoundFactor
		Case 3 : PlaySoundAtLevelActiveBall ("Arch_R3"), Vol(ActiveBall) * ArchSoundFactor
		Case 4 : PlaySoundAtLevelActiveBall ("Arch_R4"), Vol(ActiveBall) * ArchSoundFactor
	End Select
End Sub


Sub Arch1_hit()
	If Activeball.velx > 1 Then SoundPlayfieldGate
	StopSound "Arch_L1"
	StopSound "Arch_L2"
	StopSound "Arch_L3"
	StopSound "Arch_L4"
	StopSound "Arch_R1"
	StopSound "Arch_R2"
	StopSound "Arch_R3"
	StopSound "Arch_R4"
End Sub

Sub Arch1_unhit()
	If activeball.velx < -8 Then
		RandomSoundRightArch
	End If	
End Sub

Sub Arch2_hit()
	'If Activeball.velx < 1 Then SoundPlayfieldGate
	StopSound "Arch_R1"
	StopSound "Arch_R2"
	StopSound "Arch_R3"
	StopSound "Arch_R4"
End Sub

Sub Arch2_unhit()
	If activeball.velx > 9 Then
		RandomSoundLeftArch
	End If
End Sub

Sub Arch3_hit()
	StopSound "Arch_R1"
	StopSound "Arch_R2"
	StopSound "Arch_R3"
	StopSound "Arch_R4"
End Sub

Sub Arch3_unhit()
	If activeball.vely < -10 Then
		RandomSoundRightArch
	End If	
End Sub


'/////////////////////////////  SAUCERS (KICKER HOLES)  ////////////////////////////

Sub SoundSaucerLock()
	Select Case Int(Rnd*2)+1	
		Case 1: PlaySoundAtLevelStatic ("Saucer_Enter_1"), SaucerLockSoundLevel, Activeball
		Case 2: PlaySoundAtLevelStatic ("Saucer_Enter_2"), SaucerLockSoundLevel, Activeball
	End Select
End Sub

Sub SoundSaucerKick(scenario, saucer)
	Select Case scenario
		Case 0: PlaySoundAtLevelStatic SoundFX("Saucer_Empty", DOFContactors), SaucerKickSoundLevel, saucer
		Case 1: PlaySoundAtLevelStatic SoundFX("Saucer_Kick", DOFContactors), SaucerKickSoundLevel, saucer
	End Select
End Sub

Sub SoundSolOff(obj)
	PlaySoundAtLevelStatic SoundFX("soloff", DOFContactors), SaucerKickSoundLevel, obj
End Sub