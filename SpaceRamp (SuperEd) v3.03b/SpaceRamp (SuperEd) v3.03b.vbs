Option Explicit
Randomize


'*****************************************************************************************************
'* SPACERAMP
'* Table design, drawing, coding and music by SuperEd (Ed Vink)
'* First public beta release
'* Build 1.0.0 (First RTM Release!!!)
'***************************************************************************************************** 
'
'Release 0.9.47
'Initial public beta
'
'Release 0.9.48
'Fixed right ramp not shootable (milky way primitive was collidable)
'Fixed locked ball(s), it was not saved after ball loss
'Added Multiball speech.
'Changed some contrast in playfield, hope it looks better
'Changed the lights. Hope it gives more effect
'Changed material for the ramps, hope it looks better
'Added option bEasyMultiBall. If 'true', means that multiballlock1 ready is activated at ball2 and multiballlock2 is activated at ball3
'Fixed HighScore save.
'Added a Secret Galaxy Kicker001
'Changed the speed of the Milky Way 2
'Changed the magnets to last longer
'Changed the "start gane" button. Its now locked when first ball is in play
'
'
'Release 0.9.49
'Fixed Milky Way sound stop after multiball
'Added "ball trail lights" on the ramps (as requested :-) )
'Added blue flasher for Secret Galaxy
'Fixed some timings kicker->flasher
'Added some speech
'Added GI Drain
'Changed ramp Lights
'Added Jackpot speech
'Changed BS Lights
'Changed Background lights
'Added timer SkillShot
'
'Release 0.9.50
'Fixed crash when Tilt
'Changed code to support FlexDMD
'Added the possibility to add the DMD on the Table (for FSS and single screen cabinets)
'Added the possibility to hide the big floating DMD (For FSS)
'Added the possibility to switch between UltraDMD and FlexDMD
'Fixed MultiBall mode issue when first ball is lost
'Changed some lights (minor)
'Changed DMD color to Blue (fits more with the table colors).
'Changed the ramp back to semi-transparant.
'Changed some of the GI intensity.
'Added ComboBonus every x combo's with random gift
'
'Release 1.0.0
'Added JPs Flasher DMD for systems without UltraDMD.FlexDMD (AT_Games)
'Added key "F7" to reset high scores to 0
'Changed the default HS to 0 when played very first time (AT_Games)
'Changed score calculation between balls
'Fixed tilt & ballsave combination
'
'Release 1.0.1
'Fixed player announcment
'
'Release 3.03
'Darker Playfield
'Reflection on the sides
'Added some more audio (spinner)
'Added flasher at spinners
'Transparant ramps
'
' CREDITS
' Initial table created by fuzzel, jimmyfingers, jpsalas, toxie & unclewilly (in alphabetical order)
' Flipper primitives by zany
' Ball rolling sound script by jpsalas
' Ball shadow by ninuzzu
' Ball control & ball dropping sound by rothbauerw
' DOF  by arngrim
' Positional sound helper functions by djrobx
' Plus a lot of input from the whole community
' Big thanks to JPSalas for giving me the permission to use his 'Flasher DMD' code
'*****************************************************************************************************

'*********************************************************************
'                 DOF Configs
'*********************************************************************
'-E101-Flipper Left-Solenoid
'-E102-Flipper Right-Solenoid
'-E103-Slingshot Left-Solenoid
'-E104-Slingshot right-Solenoid
'-E105-Ball Release-Solenoid-Strobe 300
'-E106-Ball Release
'-E107-Slingshot2 right-Solenoid
'-E108-Slingshot2 left-Solenoid
'-E109-Launch Button

'-E111-Bumper1-Solenoid
'-E112-Bumper2-Solenoid
'-E113-Bumper3-Solenoid
'-E114-Bumper4-Solenoid
'-E115-Bumper5-Solenoid
'
'-E121-UpperLane left->Right
'-E122-UpperLane Right->Left
'
'-E131-Kicker001_Launch
'-E132-Kicker002_Launch
'-E133-Kicker003_Launch
'-E134-Kicker004_Launch
'-E135-HitTargetsLeft
'-E136-HitTargetsCenter
'-E137-HitTargetsRight
'-E138-HitTargetsBack
'-E139-DropTargetsLeft
'-E140-HalfOnRampSplit
'
'Specials
'-E141-RightRampAward
'-E142-LeftRampAward
'-E143-CenterRampAward
'-E144-RightMultiballAward
'-E145-LeftMultiBallAward
'-E146-SHIPAward
'-E147-SecretAward
'-E148-PlanetAward
'-E149-Extra Ball
'-E150-Kicker005_Launch_KickBack
'
'-E151-Gate002,kicker006
'-E152-MultiBall Beacon
'-E153-MultiBall Start
'-E154-Gate005
'-E155-Gate006
'-E156-Gate007
'-E157-SkillShot,Secret
'-E158-BallLost
'-E159-Knocker
'-E160-Yellow_Left_Right
'-E161-Yellow_Right_Left
'-E162-Center->Out Red
'-E163-Center->Out Yellow
'-E164-Center-Out-Mid (Blue)
'-E165-Center->OUT green
'-E166-Left-White_Spinner
'-E167-Right-White_Spinner
'-E168-BlackHoleTarget

'-E901-Undercab-Blue

'*********************************************************************
'                 Sounds Configs
'*********************************************************************
'
'FX_Magnet.wav
'fx_metalrolling.wav
'fx_metalrolling0.wav
'fx_metalrolling1.wav
'fx_metalrolling2.wav
'fx_metalrolling3.wav
'FX_RotatingDisc.mp3
'FX_RotatingDisc.mp3.asd
'FX_RotatingDisc.wav
'fx_shaker.wav
'SFX_70s.wav
'SFX_Acid.wav
'SFX_AlienZap.wav
'SFX_AnotherWorld.wav
'SFX_Cloverfield.wav
'SFX_Daft.wav
'SFX_Electra1.wav
'SFX_FlyAway.wav - Lane,Kicker
'SFX_HorrorMovie.wav
'SFX_KillerDrone.wav
'SFX_MeanFall.wav
'SFX_Plasma.wav
'SFX_Predator1.wav
'SFX_Predator2.wav
'SFX_Predator3.wav
'SFX_Predator4.wav
'SFX_Predator5.wav
'SFX_Predator6.wav
'SFX_Predator7.wav
'SFX_Predator8.wav
'SFX_Ratsl.wav - Lane Bonus
'SFX_Scream.wav
'SFX_SpaceRacer.wav
'SFX_SpaceStation1.wav
'SFX_SpaceStation2.wav
'SFX_SpaceStation3.wav
'SFX_SpaceStation4.wav
'SFX_SpaceStation5.wav
'SFX_SpaceStation6.wav
'SFX_SpaceStation7.wav
'SFX_SpaceStation8.wav
'SFX_Starsl.wav
'SFX_Sword.wav - WormHole
'SFX_TheEnd.wav
'SFX_Uprise3.wav
'SFX_WaveLength.wav - BallLocked
'SFX_Whisper.wav
'SFX_Xarax.wav - Bonus Multiplier

'*********************************************************************
'                 DMD SETTINGS
'*********************************************************************
'
'BEST SETTINGS FOR DMD
'
'* ULTRADMD
'Const turnonultradmd = true , Const DmdMode = 0 
'
'* FLEXDMD (Default)
'Const turnonultradmd = true , Const DmdMode = 1 
'Const ShowVpxDMD = true ' Show the DMD in VPX (FlexDMD Only)
'Const ShowCabinetDMD = true ' SHow the DMD as floating window (Cabinet, FlexDMD only)
'
'* JPDMD 'Not an actually DMD but 2x16 Flasher digits
'Const turnonultradmd = false
'Const JPsDMD = True ' Use JP's flasher DMD. Usefull for FSS without UltraDMD or FlexDMD

Const turnonultradmd = true ' Turn On/Off UltraDMD/FlexDMD
Const DmdMode = 1 ' 0 = UltraDMD , 1 = FlexDMD
Const ShowVpxDMD = true ' Show the DMD in VPX (FlexDMD Only)
Const ShowCabinetDMD = true ' SHow the DMD as floating window (Cabinet, FlexDMD only)
Const JPsDMD = false ' Use JP's flasher DMD. Usefull for FSS without UltraDMD or FlexDMD

'*********************************************************************
'                 TABLE GAME SETTINGS
'*********************************************************************

Const nTableFxVolume = 1 'Volume of the sound FX positioned at the table
Const nTableSFXVolume = 1 ' Volume of the sound effects on the BackGlass (BS)
Const nTableMusicVolume = 0.5 'Volume of the music played
Const nTableSpeechVolume = 1 'Volume of the speech played
Const bMusicOn = True 'Do play music tracks or not
Const bDebugGeneral = true 'Used for debugging
Const cTiltSensitivity = 6
Const cNumberOfBallsInGame = 3 'Number of balls during game
Const cMaxNumberOfPlayers = 4 ' Maximal number of players

Const cAssetsFolder = "SpaceRamp" ' UtraDMD Folder
Const cDefaultDMDColor = "DeepSkyBlue" ' UltraDMD Color
Const nBallSavedTime = 15000 'BallSaved time before fast blink
Const nBallSavedQuickTime = 5000 'BallSaved time fast blink
Const nComboBonus = 5 'Award random bonus every x combo's when entering secret galaxy 
Const bEasyMultiBall = true 'It will lighten the multiball locks faster (no need to hit the targets first).

'*********************************************************************
'                 Definitions
'*********************************************************************

Dim strCurrentSong
Dim strSongToPlay
Dim bCurrentSongIsIntro
Dim bCurrentSongIsEndSong
Dim bTilted:bTilted=False
Dim nTilt,nTiltTime
Dim bTableReady:bTableReady=False
Dim nBallsOnPlayField
Dim nCurrentPlayer
Dim nCurrentBall
Dim nNumberOfPlayers
Dim bInGame 'Are We playing a game now
Dim bPlayerHasStartedGame
Dim bBlackHoleMode,bReadyForBlackHoleMode,bReadyToAwardBlackHole
Dim nMirBaseYPosition:nMirBaseYPosition = PrimitiveMIR.RotY
Dim nLastTargetHit
Dim bMultiBallMode
Dim bAutoPlunger
Dim nBalls2Eject
Dim bBallInPlungerLane
Dim bBallSaved
Dim bCurrentBallIsExtraBall
Dim bReadyForComboBonus
Dim nPreviousComboBonus
Dim nRightRampColor,nTopRampColor,nLeftRampColor
Dim nOldRightRampColor,nOldTopRampColor,nOldLeftRampColor
Dim nVocalQueue(255,2)
Dim nVocalQueueLength
Dim TotalGamesPlayed
Dim HighScore(4)
Dim HighScoreName(4)
Dim dLine(3)

Dim bRotateMir:bRotateMir=0

'*********************************************************************
'                 Scores
'*********************************************************************
const cScoreBumper=210
const cScoreTrigger=500
const cScoreRampBonus=5000
const cScoreRamp=1500
const cScoreHitTarget=1000
const cScoreWormhole=100000
const cScorePlanet=25000
const cScoreJackpot=125010
const cScoreEarth=10000
const cScoreCombo=10000
const cScoreSkillShot=50000
const cScoreMir=2000
const cScoreSpinner=390
const cBlackHoleTarget=10000
const cSecretGalaxy=15000

' Player Specific
Dim nPlayerCurrentBall(4)
Dim nScore(4)
Dim nPlayerLights(4,80) ' Store the Light States per player
Dim nPlanets(4)' Store the number off planets per player
Dim nCombos(4)' Store the number off combos per player
Dim nBonusMultiplier(4)' Store the bonus multiplier

'First, try to load the Controller.vbs (DOF), which helps controlling additional hardware like lights, gears, knockers, bells and chimes (to increase realism)
'This table uses DOF via the 'SoundFX' calls that are inserted in some of the PlaySound commands, which will then fire an additional event, instead of just playing a sample/sound effect

LoadCoreFiles
LoadControllerVBS

Sub LoadCoreFiles
	On Error Resume Next
	ExecuteGlobal GetTextFile("core.vbs")
	If Err Then MsgBox "Can't open core.vbs"
	On Error Goto 0
End Sub
Sub LoadControllerVBS
	On Error Resume Next
	ExecuteGlobal GetTextFile("Controller.vbs")
	If Err Then MsgBox "You need the Controller.vbs file in order to run this table (installed with the VPX package in the scripts folder)"
	On Error Goto 0
End Sub

'If using Visual PinMAME (VPM), place the ROM/game name in the constant below,
'both for VPM, and DOF to load the right DOF config from the Configtool, whether it's a VPM or an Original table

Const cGameName = "SpaceRamp"
Const TableName = "SpaceRamp"

Dim EnableRetractPlunger
EnableRetractPlunger = false 'Change to true to enable retracting the plunger at a linear speed; wait for 1 second at the maximum position; move back towards the resting position; nice for button/key plungers

Dim EnableBallControl
EnableBallControl = false 'Change to true to enable manual ball control (or press C in-game) via the arrow keys and B (boost movement) keys

'Const BallSize = 25  'Ball radius

Sub Table1_Init()
	Randomize
	Loadhs ' load High Scores from registry
	LoadEM
	changegi white
	Call DMD_Init
	DMD "", "GAME INIT", "Please Wait", 8000
	Call StartUpSequence
	' Game Specific
End Sub

Sub Table1_Exit()
	'ExitUltraDMD
	if turnonultradmd = false then exit sub
    If Not UltraDMD is Nothing Then
        If UltraDMD.IsRendering Then
            UltraDMD.CancelRendering
        End If
        UltraDMD.Uninit
        UltraDMD = NULL
    End If
End Sub

Sub StartUpSequence()
	' Just for the fun of it :-)
	vpmtimer.addtimer 1000, "TimerShakerShip1.enabled=1 '"
	vpmtimer.addtimer 1500, "TimerShakerShip2.enabled=1 '"
	vpmtimer.addtimer 1000, "PlaySoundAt ""fx_shaker"" , kicker004 '"
	vpmtimer.addtimer 1500, "PlaySoundAt ""fx_shaker"" , kicker002 '"
	vpmtimer.addtimer 2000, "TimerShakerShip1.enabled=0 '"
	vpmtimer.addtimer 2000, "TimerShakerShip2.enabled=0 '"
	vpmtimer.addtimer 2000, "TimerPlanetAnimation.enabled = 1 '"
	vpmtimer.addtimer 3000, "FlasherSunMIR.visible = true '"
	vpmtimer.addtimer 4000, "ChangePlanetLights True '"	
	vpmtimer.addtimer 5000, "ChangeBackLights True '"	
	vpmtimer.addtimer 5100, "GiOn '"
	vpmtimer.addtimer 7000, "LightSeqAttractLights.Play SeqBlinking , 0,5,200 '"
	vpmtimer.addtimer 7500, "ToggleGate002(True) '"
	vpmtimer.addtimer 8000, "AttractMode True '"
	vpmtimer.addtimer 8000, "bTableReady = True '"
	vpmtimer.addtimer 9000, "DOF 901, DOFON'"
End Sub

'*********************************************************************
'                 Key Functions
'*********************************************************************
Sub Table1_KeyDown(ByVal keycode)
	If bTableReady=false then exit sub
	If keycode = PlungerKey Then
        If EnableRetractPlunger Then
            Plunger.PullBackandRetract
        Else
		    Plunger.PullBack
        End If
		PlaySound "plungerpull",0,1,AudioPan(Plunger),0.25,0,0,1,AudioFade(Plunger)
	End If

	If keycode = 64 Then ShowDMDOptions cGameName 'F6 Key
	if keycode = 65 then Call ResetHS 'F7 reset High Scores
	
	if hsbModeActive = true Then ' we are entering high score
		EnterHighScoreKey(keycode)
	else
		If bTilted = false and bInGame = true then
			If keycode = LeftFlipperKey Then
				LeftFlipper.RotateToEnd
				LeftFlipper2.RotateToEnd
				PlaySoundAt SoundFXDOF("fx_flipperup", 101, DOFOn, DOFFlippers), LeftFlipper
				Call LaneShiftLeft 'Shift the Lane Lights
			End If

			If keycode = RightFlipperKey Then
				RightFlipper.RotateToEnd
				RightFlipper2.RotateToEnd
				PlaySoundAt SoundFXDOF("fx_flipperup", 102, DOFOn, DOFFlippers), RightFlipper
				Call LaneShiftRight 'Shift the Lane Lights
			End If
		end If
	end if

	' Nudge and Tile
	If keycode = LeftTiltKey Then Nudge 90, 2:PlaySound SoundFX("fx_nudge",0), 0, 1, -0.1, 0.25:CheckTilt
	If keycode = RightTiltKey Then Nudge 270, 2:PlaySound SoundFX("fx_nudge",0), 0, 1, 0.1, 0.25:CheckTilt
	If keycode = CenterTiltKey Then Nudge 0, 2:PlaySound SoundFX("fx_nudge",0), 0, 1, 1, 0.25:CheckTilt
	if keycode = MechanicalTilt then CheckMechanicalTilt

	' Start a new game
	If keycode = StartGameKey and hsbModeActive = false and bPlayerHasStartedGame = false Then
		If(nBallsOnPlayfield = 0) and bIngame = false Then
			ResetTableForNewGame()
			AddSpeechToQueue "SFX_Speech_1_player",1000 : DMD2 "", "1 PLAYER", "", 1000, UltraDmd_eNone , ""
			TotalGamesPlayed = TotalGamesPlayed + 1
			savegp
		Else
			If nNumberOfPlayers < cMaxNumberOfPlayers Then
				nNumberOfPlayers = nNumberOfPlayers + 1
				if nNumberOfPlayers = 2 then AddSpeechToQueue "SFX_Speech_2_players",1000 : DMDFLUSH : DMD2 "", "2 PLAYERS", "", 1000, UltraDmd_eNone , ""
				if nNumberOfPlayers = 3 then AddSpeechToQueue "SFX_Speech_3_players",1000 : DMDFLUSH : DMD2 "", "3 PLAYERS", "", 1000, UltraDmd_eNone , ""
				if nNumberOfPlayers = 4 then AddSpeechToQueue "SFX_Speech_4_players",1000 : DMDFLUSH : DMD2 "", "4 PLAYERS", "", 1000, UltraDmd_eNone , ""
				call dmdscore
			end if
		End If
	End If

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

	'****************
	' Testing Keys  
	'****************

	if keycode = "3" then
		TimerComboBonus.uservalue = 50
		TimerComboBonus.interval = 10
		TimerComboBonus.enabled = true
	end if
End Sub

Sub Table1_KeyUp(ByVal keycode)
	if bTableReady=false then exit Sub
	If keycode = PlungerKey Then
		Plunger.Fire
		PlaySound "plunger",0,1,AudioPan(Plunger),0.25,0,0,1,AudioFade(Plunger)
	End If

	If keycode = LeftFlipperKey Then
		LeftFlipper.RotateToStart
		LeftFlipper2.RotateToStart
		PlaySoundAt SoundFXDOF("fx_flipperdown", 101, DOFOff, DOFFlippers), LeftFlipper
	End If

	If keycode = RightFlipperKey Then
		RightFlipper.RotateToStart
		RightFlipper2.RotateToStart
		PlaySoundAt SoundFXDOF("fx_flipperdown", 102, DOFOff, DOFFlippers), RightFlipper
	End If

    'Manual Ball Control
	If EnableBallControl = 1 Then
		If keycode = 203 Then BCleft = 0	' Left Arrow
		If keycode = 200 Then BCup = 0		' Up Arrow
		If keycode = 208 Then BCdown = 0	' Down Arrow
		If keycode = 205 Then BCright = 0	' Right Arrow
	End If
End Sub

'*********************************************************************
'                 Ball Functions
'*********************************************************************

Sub PrepareBall()
	if bDebugGeneral then debug.print "Sub PrepareBall() : "
	AddSpeechToQueue "SFX_Speech_Get_Ready",1000
	vpmtimer.addtimer 1000, "PrepareBall2 '"
End Sub

Sub PrepareBall2()
	if bDebugGeneral then debug.print "Sub PrepareBall2() : "
	PlaySoundAt SoundFXDOF("ballrelease", 106, DOFPulse, DOFContactors), BallRelease
	BallRelease.CreateBall
	BallRelease.Kick 90, 7
	nBallsOnPlayField = nBallsOnPlayField + 1
End Sub

Sub Drain_Hit()
	if bDebugGeneral then debug.print "Sub Drain_Hit() : "
	PlaySound "drain",0,1,AudioPan(Drain),0.25,0,0,1,AudioFade(Drain)
	Drain.DestroyBall
	nBallsOnPlayField = nBallsOnPlayField - 1

	if bDebugGeneral then debug.print "BallsOnPlayfield : " + cstr(nBallsOnPlayField)
	if bDebugGeneral then debug.print "GetBalls : " + cstr(Ubound(GetBalls))

	If nBallsOnPLayfield = 1 and bMultiBallMode = true then Call StopMultiBall

	If (nBallsOnPlayField = 0 or Ubound(GetBalls) = -1) and bMultiBallMode = false then
		' There mare no balls on the playfield. 
		if bBlackHoleMode = true Then StopBlackHoleMode
		
		if bDebugGeneral then debug.print "LI7 state = "+cstr(li7.state)
		select case LI7.state
			case 0
				' Extra ball light = off, just end this ball
				call EndOfBallGame
			case 1
				' Extra balll light = on so Award Extra Ball if MultiBall mode = off
				If bMultiBallMode = false Then
					vpmtimer.addtimer 2500, "EndOfBallGameStep1 '"
					vpmtimer.addtimer 13000, "AwardExtraBall '"
				end if
			case 2
				' Ball saver timer = active (blink)
				AddMultiBalls 1
				bBallSaved = True
				LI7.state = 0
				LI7.timerenabled = 0
				DMD2 "", "BALL SAVED", "SHOOT AGAIN", 2000, UltraDMD_eFade , ""
				AddSpeechToQueue "SFX_Speech_Ball_Saved_Shoot_Again",1500
		end select
	end if
End Sub

Sub EndOfBallGame()
	if bDebugGeneral then debug.print "Sub EndOfBallGame() : "
	' This Sub is called when all balls are drained
	' Reset All Tilt when needed
	nBallsOnPlayField = 0
	bReadyForComboBonus = false
	Lighteffect 2 'Up2Down
	Call aLightsOff
	Call aArrowsOff
	Call aPlanetsOff
	If bTilted = true then
		bTilted = False
		nTilt = 0
		DisableTable False
		Timertilttableclear.enabled = False
		ntilttime = 0
	end If
	call dmdflush
	DMD2 "", "BALL LOST", "", 2000, UltraDMD_eFade , ""
	AddSpeechToQueue "SFX_Speech_Ball_Lost",1000
	DOF 158, DOFPULSE
	PlaySound "SFX_TheEnd" , 1 , nTableSFXVolume
	If nCurrentBall = cNumberOfBallsInGame and nCurrentPlayer = nNumberOfPlayers Then
		' Last ball, last player. Check HiScore first.
		vpmtimer.addtimer 2500, "EndOfBallGameStep1 '"
		vpmtimer.addtimer 13000, "CheckHighscore '"
	Else	
		vpmtimer.addtimer 2500, "EndOfBallGameStep1 '"
		vpmtimer.addtimer 13000, "EndOfBallGameStep2 '"
	end If
End Sub

Sub EndOfBallGameStep1()
	if bDebugGeneral then debug.print "Sub EndOfBallGameStep1() : "
	GiOff
	strSongToPlay = "Trk_SpaceRampG"
	playsong strSongToPlay,1
	' This is step 1 that is executed when all balls are drained, so here a bonus score can be shown

	DMD2 "",cstr(nPlanets(nCurrentPlayer)) + " Planets",cstr(nCombos(nCurrentPlayer)) + " Combos", 2000, UltraDMD_eScrollLeft,""
	vpmtimer.addtimer 1100 , "PlaySound ""SFX_Polarized"" , 1 , nTableSFXVolume '"
	vpmtimer.addtimer 2000 , "DMD2 """",""Total"",cstr( (nCombos(nCurrentPlayer)*cScoreCombo) + (nPlanets(nCurrentPlayer)*cScorePlanet) ), 2000, UltraDMD_eScrollLeft, """" '"
	vpmtimer.addtimer 3000 , "PlaySound ""SFX_AnotherWorld"" , 1 , nTableSFXVolume '"
	vpmtimer.addtimer 4000 , "DMD2 """",""Bonus Multiplier"",cstr(nBonusMultiplier(nCurrentPlayer))+"" X"", 2000, UltraDMD_eScrollLeft, """" '"
	vpmtimer.addtimer 6000 , "DMD2 """",""Bonus Score"",cstr( ((nCombos(nCurrentPlayer)*cScoreCombo) + (nPlanets(nCurrentPlayer)*cScorePlanet)) * nBonusMultiplier(nCurrentPlayer) ), 2000, UltraDMD_eZoom, """" '"

	AddScore (((nCombos(nCurrentPlayer)*cScoreCombo) + (nPlanets(nCurrentPlayer)*cScorePlanet)) * nBonusMultiplier(nCurrentPlayer))

	if bblackholemode = true Then
		dim b
		' If we come from black hole mode, reset to basic start
		bblackholemode = false
		nPlanets(nCurrentPlayer)=0
		nCombos(nCurrentPlayer)=0
		DMD2 "", "PLANETS RESET", "", 2000, UltraDMD_eFade , ""
		For b = 0 to 80 : nPlayerLights(nCurrentPlayer,b) = 0 : Next
	end if

	if bReadyToAwardBlackHole = true then 
		bReadyToAwardBlackHole = false
		nBonusMultiplier(nCurrentPlayer)=1
		DMD2 "", "TABLE RESET", "", 2000, UltraDMD_eFade , ""
	end if
End Sub

Sub EndOfBallGameStep2()
	if bDebugGeneral then debug.print "Sub EndOfBallGameStep2() : "
	If nCurrentBall = cNumberOfBallsInGame and nCurrentPlayer = nNumberOfPlayers Then
		vpmtimer.addtimer 2000, "GameOver '"
	else
		GiOn
		PrepareNextPlayer
	end if
	' This is step 2 that is executed when all balls are drained after step 1. Here you can start a new ball.
End Sub

Sub AwardExtraBall()
	DMD2 "","SAME PLAYER", "SHOOTS AGAIN", 2000, UltraDMD_eFade , ""
    AddSpeechToQueue "SFX_Speech_Extra_Ball_Same_Player_Shoots_Again",3000
	bAutoPlunger = False
	PrepareBall
	LI7.state = 0
	LI24.state = 0 : nPlayerLights(nCurrentPlayer,24)=0
	bCurrentBallIsExtraBall = True
	strSongToPlay = "Trk_SpaceRampF"
	playsong strSongToPlay,1
End Sub


Sub AddMultiBalls(nBallToAdd)
	nBalls2Eject = nBalls2Eject + nBallToAdd
	TimerMultiBall.enabled = true
End Sub

Sub TimerMultiBall_Timer()
	If bBallInPlungerLane = true then exit sub
	nBalls2Eject = nBalls2Eject -1
	bAutoPlunger = True
	PrepareBall
	if nBalls2Eject = 0 then TimerMultiball.enabled = false
End Sub

Sub swPlungerRest_Timer()
	swPlungerRest.TimerEnabled = 0
	plunger.autoplunger = True
	plunger.fire
	PlaySoundAt SoundFXDOF("popper_ball", 105, DOFPulse, DOFContactors), swPlungerRest
	plunger.autoplunger = false
End Sub

Sub swPlungerRest_Hit()
	bBallInPlungerLane = True
	LightEffect 11
	' There is a ball at the plunger
	If bAutoPlunger Then
		DOF 106, DOFPulse 'Right Sling		
		swPlungerRest.TimerEnabled = 1
		bAutoPlunger = False
	End If
End Sub

Sub swPlungerRest_UnHit()
	if bTilted then exit Sub
	bPlayerHasStartedGame = true
	LightEffect 12
	if bMultiBallMode = false and LI7.state = 0 and bBallSaved = false Then
		'Start BallSaved
		LI7.TimerInterval = nBallSavedTime
		LI7.BlinkInterval = 125
		LI7.state = 2
		LI7.TimerEnabled = 1
	end if
	bBallInPlungerLane = False
	swPlungerRest.TimerEnabled = 0 'stop the launch ball timer if active
End Sub

Sub LI7_Timer()
	If LI7.TimerInterval = nBallSavedTime Then	
		LI7.TimerInterval = nBallSavedQuickTime
		LI7.BlinkInterval = 75
		LI7.state = 2
		LI7.TimerEnabled = 0
		LI7.TimerEnabled = 1
	Else
		LI7.TImerEnabled = 0
		LI7.State = 0
	End If	
End Sub

'*********************************************************************
'                 Table start and End Functions
'*********************************************************************

Sub ResetTableForNewGame()
	if bDebugGeneral then debug.print "Sub ResetTableForNewGame() : "
	' This SUB is called when starting a complete new game
	call InitPlayerNewGameVariables 'Set All lights and settings to default
	call InitPlayerVariables
	nBallsOnPlayField = 0
	AttractMode false
	B2SLightOnOff 11,1
	nCurrentPlayer = 1
	nCurrentBall = 1
	nNumberOfPlayers = 1
	bBallSaved = false
	bCurrentBallIsExtraBall = false
	bReadyForComboBonus = false
	bInGame = true
	call endmusic
	strSongToPlay = "Trk_SpaceRampA"
	playsong strSongToPlay,0
	call dmdscore
	call PrepareBall
End Sub

Sub InitPlayerNewGameVariables()
	if bDebugGeneral then debug.print "Sub InitPlayerNewGameVariables() : "
	Dim a,b	
	For a = 1 to 4
		nPlayerCurrentBall(a)=0
		nScore(a)=0
		nPlanets(a)=0
		nCombos(a)=0
		nBonusMultiplier(a)=1
		For b = 0 to 80 : nPlayerLights(a,b) = 0 : Next
	next
End Sub

Sub PrepareNextPlayer()
	if bDebugGeneral then debug.print "Sub PrepareNextPlayer() : "
	if nCurrentPlayer < nNumberOfPlayers then
		nCurrentPlayer = nCurrentPlayer + 1
		if nCurrentPlayer = 2 then AddSpeechToQueue "SFX_Speech_player2",1000 : DMDFLUSH : DMD2 "", "PLAYER 2", "", 1000, UltraDmd_eNone , ""
		if nCurrentPlayer = 3 then AddSpeechToQueue "SFX_Speech_player3",1000 : DMDFLUSH : DMD2 "", "PLAYER 3", "", 1000, UltraDmd_eNone , ""
		if nCurrentPlayer = 4 then AddSpeechToQueue "SFX_Speech_player4",1000 : DMDFLUSH : DMD2 "", "PLAYER 4", "", 1000, UltraDmd_eNone , ""
	Else
		nCurrentPlayer = 1
		if nNumberOfPlayers <> 1 Then AddSpeechToQueue "SFX_Speech_player1",1000 : DMDFLUSH : DMD2 "", "PLAYER 1", "", 1000, UltraDmd_eNone , ""
		nCurrentBall = nCurrentBall + 1
	end if
	DOF 162,DofPulse
	if nCurrentBall = 1 Then
		strSongToPlay = "Trk_SpaceRampA"
		playsong strSongToPlay,0
	end If
	if nCurrentBall = 2 Then
		strSongToPlay = "Trk_SpaceRampD"
		playsong strSongToPlay,0
		if bEasyMultiBall = true and LI22.state <> 1 Then
			li22.state = 1 : nPlayerLights (nCurrentPlayer,22) = 1 : CheckTargetLights()
		end if	
	end If
	if nCurrentBall = 3 Then
		strSongToPlay = "Trk_SpaceRampE"
		playsong strSongToPlay,0
		if bEasyMultiBall = true and LI19.state <> 1 Then
			li19.state = 1 : nPlayerLights (nCurrentPlayer,19) = 1 : CheckTargetLights()
		end if	
	end If
	call PrepareSkillShot
	call dmdscore	
	call InitPlayerVariables
	call PrepareBall
End Sub

Sub InitPlayerVariables()
	if bDebugGeneral then debug.print "Sub InitPlayerVariables() : "
	Dim a,b,c,d,e
	for each a in LIAttract : a.state = 0 : next
	for each a in LiArrows : a.state = 0 : next
	for each a in LiPlanets : a.state = 0 : next
	for e = 1 to 10 : B2SLightOnOff e,0 : next
	if nPlanets(nCurrentPlayer) > 0 then 
		for e = 1 to nPlanets(nCurrentPlayer) : B2SLightOnOff e,1 : next
	end if
	dt1.isdropped = False : dt2.isdropped = False
	PlaySoundAt SoundFXDOF("fx_target", 139, DOFPulse, DOFTargets), Dt2
	' This Sub is called when its players turn. Restore Lights
	'Bonus
	LI1.state = nPlayerLights(nCurrentPlayer,1)
	LI2.state = nPlayerLights(nCurrentPlayer,2)
	LI3.state = nPlayerLights(nCurrentPlayer,3)
	'Ramp Targets
	LI4.state = nPlayerLights(nCurrentPlayer,4)
	LI5.state = nPlayerLights(nCurrentPlayer,5)
	LI6.state = nPlayerLights(nCurrentPlayer,6)
	LI8.state = nPlayerLights(nCurrentPlayer,8)
	LI9.state = nPlayerLights(nCurrentPlayer,9)
	LI10.state = nPlayerLights(nCurrentPlayer,10)
	LI20.state = nPlayerLights(nCurrentPlayer,20)
	LI23.state = nPlayerLights(nCurrentPlayer,23)
	LI18.state = nPlayerLights(nCurrentPlayer,18)
	LI21.state = nPlayerLights(nCurrentPlayer,21)
	LI22.state = nPlayerLights(nCurrentPlayer,22)
	LI11.state = nPlayerLights(nCurrentPlayer,11)
	if li11.state = 1 then dt2.isdropped = True : PlaySoundAt SoundFXDOF("fx_target", 139, DOFPulse, DOFTargets), Dt2
	if li12.state = 1 then dt1.isdropped = True : PlaySoundAt SoundFXDOF("fx_target", 139, DOFPulse, DOFTargets), Dt1
	LI12.state = nPlayerLights(nCurrentPlayer,12)
	LI19.state = nPlayerLights(nCurrentPlayer,19)
	' Lane
	LI25.state = nPlayerLights(nCurrentPlayer,25)
	LI26.state = nPlayerLights(nCurrentPlayer,26)
	LI27.state = nPlayerLights(nCurrentPlayer,27)
	LI28.state = nPlayerLights(nCurrentPlayer,28)
	' Ship
	LI14.state = nPlayerLights(nCurrentPlayer,14)
	LI15.state = nPlayerLights(nCurrentPlayer,15)
	LI16.state = nPlayerLights(nCurrentPlayer,16)
	LI17.state = nPlayerLights(nCurrentPlayer,17)
	' KickBAck
	LI13.state = nPlayerLights(nCurrentPlayer,13)
	ToggleGate006(False)

	' MultiBall Arrows
	LI50.state = nPlayerLights(nCurrentPlayer,50)
	LI51.state = nPlayerLights(nCurrentPlayer,51)
	ToggleGate005(False)
	Call CheckMultiBallReady
	Call CheckTargetLights
	' Planets
	LI31.state = nPlayerLights(nCurrentPlayer,31)
	LI32.state = nPlayerLights(nCurrentPlayer,32)
	LI33.state = nPlayerLights(nCurrentPlayer,33)
	LI34.state = nPlayerLights(nCurrentPlayer,34)
	LI35.state = nPlayerLights(nCurrentPlayer,35)
	LI36.state = nPlayerLights(nCurrentPlayer,36)
	LI37.state = nPlayerLights(nCurrentPlayer,37)
	LI38.state = nPlayerLights(nCurrentPlayer,38)
	LI39.state = nPlayerLights(nCurrentPlayer,39)
	LI40.state = nPlayerLights(nCurrentPlayer,40)

	' Extra Ball lite
	LI24.state = nPlayerLights(nCurrentPlayer,24)
	' 
	' 
	nLastTargetHit = ""
	bBallSaved = false
	bCurrentBallIsExtraBall = false
	bReadyForComboBonus = false
	call PrepareSkillShot
End Sub

Sub GameOver()
	if bDebugGeneral then debug.print "Sub GameOver() : "
	bIngame = false
	StopSong
	bCurrentSongIsEndSong = true
	PlayMusic "Trk_SpaceRampH1.mp3" , nTableMusicVolume
	DMD "","GAME OVER","",2000
	B2SLightOnOff 11,0
	AddSpeechToQueue "SFX_Speech_Game_Over",3000
	vpmtimer.addtimer 2000, "AttractMode True '"
End Sub

'*********************************************************************
'                 Light Functions
'*********************************************************************
Sub GiOn()
	dim xx :For each xx in GI:xx.State = 1: Next
End Sub

Sub GiOff()
	dim xx :For each xx in GI:xx.State = 0: Next
End Sub

Sub ChangeGi(col) 'changes the gi color
	Dim bulb
	For each bulb in GI
		SetLightColor bulb, col, -1
	Next
End Sub

Sub aLightsOff()
	dim xx :For each xx in LIAttract:xx.State = 0: Next
End Sub

Sub aLightsOn()
	dim xx :For each xx in LIAttract:xx.State = 1: Next
End Sub

Sub aArrowsOff()
	dim xx :For each xx in LiArrows:xx.State = 0: Next
End Sub
Sub aPlanetsOff()
	dim xx :For each xx in LiPlanets:xx.State = 0: Next
End Sub

Sub ChangePlanetLights(bState)
If bState = true then 
	LI101.state=1:LI102.state=1
Else
	LI101.state=1:LI102.state=0
End If
End Sub

Sub ChangeBackLights(bState)
dim xx
If bState = true then 
	For each xx in LIBackLight:xx.State = 1: Next
Else
	For each xx in LIBackLight:xx.State = 0: Next
End If
End Sub

Sub ChangeBlackHoleLights(bState)
dim xx
If bState = true then 
	For each xx in LiBlackHole:xx.State = 1: Next
Else
	For each xx in LiBlackHole:xx.State = 0: Next
End If
End Sub

Sub LightEffect(nEffectNr)
	'Method: .Play Effect, TailLength, Repeat, Pause
	Select case nEffectNr
		case 0 'Off
			LightSeqAttractLights.StopPlay
		case 1 'LeftRight
			LightSeqAttractLights.UpdateInterval = 5
			LightSeqAttractLights.Play SeqLeftOn, 50, 1
			LightSeqAttractLights.Play SeqRightOn, 50, 1
		case 2 'Up2Down
			LightSeqAttractLights.UpdateInterval = 10
			LightSeqAttractLights.Play SeqDownOn, 50, 1
		case 3 'RightLeft
			LightSeqAttractLights.UpdateInterval = 5
			LightSeqAttractLights.Play SeqRightOn, 50, 1
			LightSeqAttractLights.Play SeqLeftOn, 50, 1
		case 4 'CircleInOut
			LightSeqAttractLights.UpdateInterval = 5
			LightSeqAttractLights.Play SeqCircleOutOn, 15, 4
		case 5 'Random
			LightSeqAttractLights.UpdateInterval = 5
			LightSeqAttractLights.Play SeqRandom, 10,,250
		case 6 ' WiperUp
			LightSeqAttractLights.UpdateInterval = 2
			LightSeqAttractLights.Play SeqWiperRightOn, 90
			LightSeqAttractLights.Play SeqWiperLeftOn, 90
			LightSeqAttractLights.Play SeqWiperRightOn, 90
			LightSeqAttractLights.Play SeqWiperleftOn, 90
		case 7 'SeqFanLeftDownOn, 30
			LightSeqAttractLights.Play SeqFanLeftDownOn, 30
		case 8 'SeqFanLeftDownOn, 30
			LightSeqAttractLights.Play SeqFanRightDownOn, 30
		case 9 'All Blink
			LightSeqAttractLights.UpdateInterval = 5
			LightSeqAttractLights.Play SeqBlinking,,10,10
		case 10 'All Off left low corner
			LightSeqAttractLights.Play SeqDiagDownLeftOff,25,,1000
		case 11 'LiArrow2 walk
			LightSeqArrow2.UpdateInterval = 10
			LightSeqArrow2.Play SeqCircleInOn ,20,100,10
		case 12 'LiArrow2 Off
			LightSeqArrow2.StopPlay
		case 13 'LiArrow3 walk
			LightSeqArrow3.UpdateInterval = 10
			LightSeqArrow3.Play SeqCircleInOn ,20,100,10
		case 14 'LiArrow3 Off
			LightSeqArrow3.StopPlay
		case 15 'Down2Up
			LightSeqAttractLights.UpdateInterval = 10
			LightSeqAttractLights.Play SeqUpOn, 50, 1
	end select
End Sub

'colors
Dim red, orange, amber, yellow, darkgreen, green, blue, darkblue, purple, white, base

red = 10
orange = 9
amber = 8
yellow = 7
darkgreen = 6
green = 5
blue = 4
darkblue = 3
purple = 2
white = 1
base = 11

Sub SetLightColor(n, col, stat)
	Select Case col
		Case red
			n.color = RGB(18, 0, 0)
			n.colorfull = RGB(255, 0, 0)
		Case orange
			n.color = RGB(18, 3, 0)
			n.colorfull = RGB(255, 64, 0)
		Case amber
			n.color = RGB(193, 49, 0)
			n.colorfull = RGB(255, 153, 0)
		Case yellow
			n.color = RGB(18, 18, 0)
			n.colorfull = RGB(255, 255, 0)
		Case darkgreen
			n.color = RGB(0, 8, 0)
			n.colorfull = RGB(0, 64, 0)
		Case green
			n.color = RGB(0, 18, 0)
			n.colorfull = RGB(0, 255, 0)
		Case blue
			n.color = RGB(0, 18, 18)
			n.colorfull = RGB(0, 255, 255)
		Case darkblue
			n.color = RGB(0, 8, 8)
			n.colorfull = RGB(0, 64, 64)
		Case purple
			n.color = RGB(128, 0, 128)
			n.colorfull = RGB(255, 0, 255)
		Case white
			n.color = RGB(255, 252, 224)
			n.colorfull = RGB(193, 91, 0)
			'n.colorfull = RGB(235, 235, 235)
		Case base
			n.color = RGB(255, 197, 143)
			n.colorfull = RGB(255, 255, 236)
	End Select
	If stat <> -1 Then
		n.State = 0
		n.State = stat
	End If
End Sub

Sub RightRampColor(nColor)
	Dim a
	' Rampoff
	' RampWhite
	' Rampred
	' RampBlue
	' RampLightBlue
	' RampYellow
	' RampPurple
	' RampGreen
	nOldRightRampColor = nRightRampColor
	nRightRampColor = nColor
	If ucase(nRightRampColor) = "RAMPOFF" Then
		for each a in RampWiresRight
			a.material = ncolor
		Next
	else
		TimerRightRampColor.UserValue = 100
		TimerRightRampColor.enabled = true
		If nOldRightRampColor <> nRightRampColor then PlaySound "FX_FluorLight",1,nTableFxVolume/10
	end if
End Sub

Sub TimerRightRampColor_Timer()
	dim a,b,c
	b = TimerRightRampColor.UserValue
	if b < 10 then 
		TimerRightRampColor.enabled = False
		for each a in RampWiresRight
			a.material = nRightRampColor
		Next
	Else
		TimerRightRampColor.UserValue = TimerRightRampColor.UserValue - 1
		c = RndNum(1,b)
		if c < 10 Then
			for each a in RampWiresRight
				a.material = nRightRampColor
			Next
		Else
			for each a in RampWiresRight
				a.material = nOldRightRampColor
			Next
		end If
	end if
End Sub

Sub TopRampColor(nColor)
	Dim a
	' Rampoff
	' RampWhite
	' Rampred
	' RampBlue
	' RampLightBlue
	' RampYellow
	' RampPurple
	' RampGreen
	nOldTopRampColor = nTopRampColor
	nTopRampColor = nColor
	If ucase(nTopRampColor) = "RAMPOFF" Then
		for each a in RampWiresTop
			a.material = ncolor
		Next
	else
		TimerTopRampColor.UserValue = 100
		TimerTopRampColor.enabled = true
		If nOldTopRampColor <> nTopRampColor then PlaySound "FX_FluorLight",1,nTableFxVolume/10
	end if
End Sub

Sub TimerTopRampColor_Timer()
	dim a,b,c
	b = TimerTopRampColor.UserValue
	if b < 10 then 
		TimerTopRampColor.enabled = False
		for each a in RampWiresTop
			a.material = nTopRampColor
		Next
	Else
		TimerTopRampColor.UserValue = TimerTopRampColor.UserValue - 1
		c = RndNum(1,b)
		if c < 10 Then
			for each a in RampWiresTop
				a.material = nTopRampColor
			Next
		Else
			for each a in RampWiresTop
				a.material = nOldTopRampColor
			Next
		end If
	end if
End Sub

Sub LeftRampColor(nColor)
	Dim a
	' Rampoff
	' RampWhite
	' Rampred
	' RampBlue
	' RampLightBlue
	' RampYellow
	' RampPurple
	' RampGreen
	nOldLeftRampColor = nLeftRampColor
	nLeftRampColor = nColor
	If ucase(nLeftRampColor) = "RAMPOFF" Then
		for each a in RampWiresLeft
			a.material = ncolor
		Next
	else
		TimerLeftRampColor.UserValue = 100
		TimerLeftRampColor.enabled = true
		If nOldLeftRampColor <> nLeftRampColor then PlaySound "FX_FluorLight",1,nTableFxVolume/10
	end if
End Sub		

Sub TimerLeftRampColor_Timer()
	dim a,b,c
	b = TimerLeftRampColor.UserValue
	if b < 10 then 
		TimerLeftRampColor.enabled = False
		for each a in RampWiresLeft
			a.material = nLeftRampColor
		Next
	Else
		TimerLeftRampColor.UserValue = TimerLeftRampColor.UserValue - 1
		c = RndNum(1,b)
		if c < 10 Then
			for each a in RampWiresLeft
				a.material = nLeftRampColor
			Next
		Else
			for each a in RampWiresLeft
				a.material = nOldLeftRampColor
			Next
		end If
	end if
End Sub	

'*********************************************************************
'                 Tilt Functions
'*********************************************************************

Sub CheckTilt                                    'Called when table is nudged
	nTilt = nTilt + cTiltSensitivity                'Add to tilt count
	TimerTiltDecrease.Enabled = True
	If(nTilt> cTiltSensitivity) AND (nTilt <15) Then 'show a warning
		DMD "","WARNING","",1000
		playsound "buzz",1,nTableSFXVolume
		AddSpeechToQueue "SFX_Speech_Warning",1000
		DOF 131, DOFPulse
	End if
	If nTilt> 15 Then 'If more that 15 then TILT the table
		DMD "","TILT","",10000
		AddSpeechToQueue "SFX_Speech_Tilt",1000
		bTilted = True
		DisableTable True
		Timertilttableclear.enabled = true
		TimerTiltRecovery.Enabled = True 'start the Tilt delay to check for all the balls to be drained
		StopSong
	End If
End Sub

sub Timertilttableclear_timer
	ntilttime = ntilttime + 1
	Select Case ntilttime
		Case 10
			tableclearing
	End Select
End Sub

Sub tableclearing
End Sub


Sub TiltDecreaseTimer_Timer
	' DecreaseTilt
	If nTilt> 0 Then
		nTilt = nTilt - 0.1
	Else
		TimerTiltDecrease.Enabled = False
	End If
End Sub

Sub DisableTable(bState)
	If bState = True Then
		GiOff
		LightSeqAttractLights.play SeqAllOff
		LeftFlipper.RotateToStart
		RightFlipper.RotateToStart
		LeftSlingshot.Disabled = 1
		RightSlingshot.Disabled = 1
		FlasherSunMIR.visible = false
		ChangePlanetLights False
		ChangeBackLights False
		bBallSaved = False
		LI7.state = 0
		LI7.timerenabled = 0
	Else
		GiOn
		LightSeqAttractLights.StopPlay
		LeftSlingshot.Disabled = 0
		RightSlingshot.Disabled = 0
		vpmtimer.addtimer 1000, "FlasherSunMIR.visible = true '"
		vpmtimer.addtimer 2000, "ChangePlanetLights True '"	
		vpmtimer.addtimer 3000, "ChangeBackLights True '"
	End If
End Sub

Sub TimerTiltRecovery_Timer()
	If(nBallsOnPlayfield = 0) Then
		EndOfBallGameStep1()
		TimerTiltRecovery.Enabled = False
	End If
End Sub


'*****************************
'    Load / Save / Highscore
'*****************************

Sub Loadhs
    Dim x
    x = LoadValue(cGameName, "HighScore1")
    If(x <> "") Then HighScore(0) = CDbl(x) Else HighScore(0) = 0 End If

    x = LoadValue(cGameName, "HighScore1Name")
    If(x <> "") Then HighScoreName(0) = x Else HighScoreName(0) = "EVI" End If

    x = LoadValue(cGameName, "HighScore2")
    If(x <> "") then HighScore(1) = CDbl(x) Else HighScore(1) = 0 End If

    x = LoadValue(cGameName, "HighScore2Name")
    If(x <> "") then HighScoreName(1) = x Else HighScoreName(1) = "EVI" End If

    x = LoadValue(cGameName, "HighScore3")
    If(x <> "") then HighScore(2) = CDbl(x) Else HighScore(2) = 0 End If

    x = LoadValue(cGameName, "HighScore3Name")
    If(x <> "") then HighScoreName(2) = x Else HighScoreName(2) = "EVI" End If

    x = LoadValue(cGameName, "HighScore4")
    If(x <> "") then HighScore(3) = CDbl(x) Else HighScore(3) = 0 End If

    x = LoadValue(cGameName, "HighScore4Name")
    If(x <> "") then HighScoreName(3) = x Else HighScoreName(3) = "EVI" End If

    x = LoadValue(cGameName, "TotalGamesPlayed")
    If(x <> "") then TotalGamesPlayed = CInt(x) Else TotalGamesPlayed = 0 End If
End Sub

Sub Savehs
    SaveValue cGameName, "HighScore1", HighScore(0)
    SaveValue cGameName, "HighScore1Name", HighScoreName(0)
    SaveValue cGameName, "HighScore2", HighScore(1)
    SaveValue cGameName, "HighScore2Name", HighScoreName(1)
    SaveValue cGameName, "HighScore3", HighScore(2)
    SaveValue cGameName, "HighScore3Name", HighScoreName(2)
    SaveValue cGameName, "HighScore4", HighScore(3)
    SaveValue cGameName, "HighScore4Name", HighScoreName(3)
    SaveValue cGameName, "TotalGamesPlayed", TotalGamesPlayed
End Sub

Sub ResetHS()
    SaveValue cGameName, "HighScore1", 0
    SaveValue cGameName, "HighScore1Name", "EVI"
    SaveValue cGameName, "HighScore2", 0
    SaveValue cGameName, "HighScore2Name", "EVI"
    SaveValue cGameName, "HighScore3", 0
    SaveValue cGameName, "HighScore3Name", "EVI"
    SaveValue cGameName, "HighScore4", 0
    SaveValue cGameName, "HighScore4Name", "EVI"
	Loadhs
	DMD2 "","HIGH SCORES", "ERASED", 5000, UltraDmd_eNone , ""
End Sub

Sub Savegp
	SaveValue TableName, "TotalGamesPlayed", TotalGamesPlayed
	vpmtimer.addtimer 1000, "Loadhs'"
End Sub

' ***********************************************************
'  High Score Initals Entry Functions - based on Black's code
' ***********************************************************

Dim hsbModeActive
Dim hsEnteredName
Dim hsEnteredDigits(3)
Dim hsCurrentDigit
Dim hsValidLetters
Dim hsCurrentLetter
Dim hsLetterFlash

Sub CheckHighscore()
    Dim tmp,a
    tmp = nScore(1):a=1

    If nScore(2)> tmp Then tmp = nScore(2):a=2
    If nScore(3)> tmp Then tmp = nScore(3):a=3
    If nScore(4)> tmp Then tmp = nScore(4):a=4

	DMD2 "","PLAYER "+cstr(a), "WON THIS GAME", 5000, UltraDmd_eNone , ""

    If tmp> HighScore(1) Then 'add 1 credit for beating the highscore
        AwardSpecial
    End If

    If tmp> HighScore(3) Then
		PlaySound "SFX_Speech_Highscore",1,nTableSpeechVolume
        vpmtimer.addtimer 2000, "PlaySound ""SFX_Speech_Initials"" '"
        HighScore(3) = tmp
        'enter player's name
        vpmtimer.addtimer 4000, "HighScoreEntryInit() '"
    Else
        vpmtimer.addtimer 2000, "EndOfBallGameStep2 '"
    End If
End Sub

Sub HighScoreEntryInit()
    hsbModeActive = True
    hsLetterFlash = 0

    hsEnteredDigits(0) = "A"
    hsEnteredDigits(1) = " "
    hsEnteredDigits(2) = " "
    hsCurrentDigit = 0

    hsValidLetters = " ABCDEFGHIJKLMNOPQRSTUVWXYZ<+-0123456789" ' < is used to delete the last letter
    hsCurrentLetter = 1
    DMDFlush
    DMDId "hsc", "black-background.jpg", "ENTER YOUR NAME:", " ", 999999
    HighScoreDisplayName()
End Sub

Sub EnterHighScoreKey(keycode)
    If keycode = LeftFlipperKey Then
		DOF 160, DOFPulse 'left to right
        Playsound "SFX_Electra1"
        hsCurrentLetter = hsCurrentLetter - 1
        if(hsCurrentLetter = 0) then
            hsCurrentLetter = len(hsValidLetters)
        end if
        HighScoreDisplayName()
    End If

    If keycode = RightFlipperKey Then
		DOF 161, DOFPulse 'right to Left
        Playsound "SFX_Faulty"
        hsCurrentLetter = hsCurrentLetter + 1
        if(hsCurrentLetter> len(hsValidLetters) ) then
            hsCurrentLetter = 1
        end if
        HighScoreDisplayName()
    End If

    If keycode = StartGameKey OR keycode = PlungerKey Then
        if(mid(hsValidLetters, hsCurrentLetter, 1) <> "<") then
            playsound "SFX_Commit",1,nTableSFXVolume
            hsEnteredDigits(hsCurrentDigit) = mid(hsValidLetters, hsCurrentLetter, 1)
            hsCurrentDigit = hsCurrentDigit + 1
            if(hsCurrentDigit = 3) then
                HighScoreCommitName()
            else
                HighScoreDisplayName()
            end if
        else
            playsound "SFX_Commit"
            hsEnteredDigits(hsCurrentDigit) = " "
            if(hsCurrentDigit> 0) then
                hsCurrentDigit = hsCurrentDigit - 1
            end if
            HighScoreDisplayName()
        end if
    end if
End Sub

Sub HighScoreDisplayName()
    Dim i, TempStr

    TempStr = " >"
    if(hsCurrentDigit> 0) then TempStr = TempStr & hsEnteredDigits(0)
    if(hsCurrentDigit> 1) then TempStr = TempStr & hsEnteredDigits(1)
    if(hsCurrentDigit> 2) then TempStr = TempStr & hsEnteredDigits(2)

    if(hsCurrentDigit <> 3) then
        if(hsLetterFlash <> 0) then
            TempStr = TempStr & "_"
        else
            TempStr = TempStr & mid(hsValidLetters, hsCurrentLetter, 1)
        end if
    end if

    if(hsCurrentDigit <1) then TempStr = TempStr & hsEnteredDigits(1)
    if(hsCurrentDigit <2) then TempStr = TempStr & hsEnteredDigits(2)

    TempStr = TempStr & "< "
    DMDMod "hsc", "ENTER YOUR NAME:", Mid(TempStr, 2, 5), 999999
End Sub

Sub HighScoreCommitName()
    hsbModeActive = False
    PlaySound "SFX_Commit",1,nTableSFXVolume
    hsEnteredName = hsEnteredDigits(0) & hsEnteredDigits(1) & hsEnteredDigits(2)
    if(hsEnteredName = "   ") then
        hsEnteredName = "YOU"
    end if

    HighScoreName(3) = hsEnteredName
    SortHighscore
	savehs
    DMDFlush
    vpmtimer.addtimer 2000, "EndOfBallGameStep2 '"
End Sub

Sub SortHighscore
    Dim tmp, tmp2, i, j
    For i = 0 to 3
        For j = 0 to 2
            If HighScore(j) <HighScore(j + 1) Then
                tmp = HighScore(j + 1)
                tmp2 = HighScoreName(j + 1)
                HighScore(j + 1) = HighScore(j)
                HighScoreName(j + 1) = HighScoreName(j)
                HighScore(j) = tmp
                HighScoreName(j) = tmp2
            End If
        Next
    Next
End Sub

'*****************************************************************
' Sling Shot Animations
' Rstep and Lstep  are the variables that increment the animation
'*****************************************************************
Dim RStep, RStep2, Lstep

Sub RightSlingShot_Slingshot
    PlaySound SoundFXDOF("right_slingshot", 104, DOFPulse, DOFContactors)
	ObjSunlevel(6) = 1 : FlasherSun6_Timer
	RSling.Visible = 0
    RSling1.Visible = 1
    sling1.rotx = 20
    RStep = 0
    RightSlingShot.TimerEnabled = 1
	gi1.State = 0:Gi2.State = 0
End Sub

Sub RightSlingShot_Timer
    Select Case RStep
        Case 3:RSLing1.Visible = 0:RSLing2.Visible = 1:sling1.rotx = 10
        Case 4:RSLing2.Visible = 0:RSLing.Visible = 1:sling1.rotx = 0:RightSlingShot.TimerEnabled = 0:gi1.State = 1:Gi2.State = 1
    End Select
    RStep = RStep + 1
End Sub

Sub RightSlingShot2_Slingshot
    PlaySound SoundFXDOF("right_slingshot", 107, DOFPulse, DOFContactors)
	ObjSunlevel(8) = 1 : FlasherSun8_Timer
	R2Sling.Visible = 0
    R2Sling1.Visible = 1
    sling2.rotx = 20
    RStep2 = 0
    RightSlingShot2.TimerEnabled = 1
End Sub

Sub RightSlingShot2_Timer
    Select Case RStep2
        Case 3:R2SLing1.Visible = 0:R2SLing2.Visible = 1:sling2.rotx = 10
        Case 4:R2SLing2.Visible = 0:R2SLing.Visible = 1:sling2.rotx = 0:RightSlingShot2.TimerEnabled = 0:'gi1.State = 1:Gi2.State = 1
    End Select
    RStep2 = RStep2 + 1
End Sub

Sub LeftSlingShot_Slingshot
    PlaySound SoundFXDOF("left_slingshot", 103, DOFPulse, DOFContactors)
	ObjSunlevel(5) = 1 : FlasherSun5_Timer
    LSling.Visible = 0
    LSling1.Visible = 1
    sling2.rotx = 20
    LStep = 0
    LeftSlingShot.TimerEnabled = 1
	gi3.State = 0:Gi4.State = 0
End Sub

Sub LeftSlingShot_Timer
    Select Case LStep
        Case 3:LSLing1.Visible = 0:LSLing2.Visible = 1:sling2.rotx = 10
        Case 4:LSLing2.Visible = 0:LSLing.Visible = 1:sling2.rotx = 0:LeftSlingShot.TimerEnabled = 0:gi3.State = 1:Gi4.State = 1
    End Select
    LStep = LStep + 1
End Sub

Sub LeftSlingShot2_SlingShot
    PlaySound SoundFXDOF("left_slingshot", 108, DOFPulse, DOFContactors)
	ObjSunlevel(15) = 1 : FlasherSun15_Timer
End Sub

Sub LeftSlingShot3_SlingShot
    PlaySound SoundFXDOF("left_slingshot", 108, DOFPulse, DOFContactors)
End Sub

'*********************************************************************
'                 B2S
'*********************************************************************

Sub B2SLight(nLightNumber,nPulseTime)
	If B2SOn = true Then
		If nPulseTime = 0 then npulsetime = 1000
		select case nLightNumber
			case 1:Controller.B2SSetData 1, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 1, 0 '"
			case 2:Controller.B2SSetData 2, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 2, 0 '"
			case 3:Controller.B2SSetData 3, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 3, 0 '"
			case 4:Controller.B2SSetData 4, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 4, 0 '"
			case 5:Controller.B2SSetData 5, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 5, 0 '"
			case 6:Controller.B2SSetData 6, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 6, 0 '"
			case 7:Controller.B2SSetData 7, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 7, 0 '"
			case 8:Controller.B2SSetData 8, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 8, 0 '"
			case 9:Controller.B2SSetData 9, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 9, 0 '"
			case 10:Controller.B2SSetData 10, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 10, 0 '"
			case 11:Controller.B2SSetData 11, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 11, 0 '"
			case 21:Controller.B2SSetData 21, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 21, 0 '"
			case 22:Controller.B2SSetData 22, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 22, 0 '"
			case 23:Controller.B2SSetData 23, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 23, 0 '"
			case 24:Controller.B2SSetData 24, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 24, 0 '"
			case 25:Controller.B2SSetData 25, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 25, 0 '"
			case 26:Controller.B2SSetData 26, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 26, 0 '"
			case 27:Controller.B2SSetData 27, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 27, 0 '"
			case 31:Controller.B2SSetData 31, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 31, 0 '"
			case 32:Controller.B2SSetData 32, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 32, 0 '"
			case 33:Controller.B2SSetData 33, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 33, 0 '"
			case 34:Controller.B2SSetData 34, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 34, 0 '"
			case 35:Controller.B2SSetData 35, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 35, 0 '"
			case 36:Controller.B2SSetData 36, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 36, 0 '"
			case 37:Controller.B2SSetData 37, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 37, 0 '"
			case 38:Controller.B2SSetData 38, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 38, 0 '"
			case 39:Controller.B2SSetData 39, 1:vpmtimer.addtimer nPulseTime, "Controller.B2SSetData 39, 0 '"
		end Select
	end if
end Sub

Sub B2SLightOnOff(nLightNumber,nMode)
	If B2SOn = true Then
		Controller.B2SSetData nLightNumber, nMode
	end if
end sub

'*********************************************************************
'                 ULTRADMD
'*********************************************************************

Dim UltraDMD

const UltraDmd_eNone = 0
const UltraDMD_eScrollLeft = 1
const UltraDMD_eScrollRight = 2
const UltraDMD_eScrollUp = 3
const UltraDMD_eScrollDown = 4
const UltraDMD_eZoom = 5
const UltraDMD_eFade = 6

Const UltraDMD_VideoMode_Stretch=0, UltraDMD_VideoMode_Top = 1, UltraDMD_VideoMode_Middle = 2, UltraDMD_VideoMode_Bottom = 3
Const UltraDMD_Animation_FadeIn = 0, UltraDMD_Animation_FadeOut = 1, UltraDMD_Animation_ZoomIn = 2, UltraDMD_Animation_ZoomOut = 3
Const UltraDMD_Animation_ScrollOffLeft = 4, UltraDMD_Animation_ScrollOffRight = 5, UltraDMD_Animation_ScrollOnLeft = 6, UltraDMD_Animation_ScrollOnRight = 7,UltraDMD_Animation_ScrollOffUp = 8,UltraDMD_Animation_ScrollOffDown = 9,UltraDMD_Animation_ScrollOnUp = 10,UltraDMD_Animation_ScrollOnDown = 11,UltraDMD_Animation_None = 14


Sub DMD(background, toptext, bottomtext, duration)
	If turnonultradmd = 0 and JPsDMD = false then exit sub
	if turnonultradmd = true then
		if background = "" or len(background) < 5 then background = "black-background.jpg"
		UltraDMD.DisplayScene00 background, toptext, 15, bottomtext, 15, UltraDMD_Animation_None , duration, UltraDMD_Animation_None 
		UltraDMDTimer.Enabled = 1 'to show the score after the animation/message
	end if
	if jpsdmd = true Then
		TimerVPXText.interval = duration*2
		TimerVPXText.enabled = true
		dLine(0) = cl(toptext)
		dline(1) = cl(bottomtext)
		dmdupdate 0
		dmdupdate 1
	end if
End Sub

Sub DMD2(background, toptext, bottomtext, duration, animation, DmdSound)
	If turnonultradmd = 0 and JPsDMD = false then exit sub
	if turnonultradmd = true then
		if background ="" or len(background) <3 then background="black-background.jpg"
		if DmdSound <> "" and len(dmdsound) > 2 Then
			PlaySound DmdSound , 1, nTableSpeechVolume
		end if
		select case animation
			case UltraDmd_eNone
				UltraDMD.DisplayScene00 background, toptext, 15, bottomtext, 15, UltraDMD_Animation_None , duration, UltraDMD_Animation_None 
			case UltraDMD_eScrollLeft
				UltraDMD.DisplayScene00 background, toptext, 15, bottomtext, 15, UltraDMD_Animation_ScrollOnLeft , duration, UltraDMD_Animation_ScrollOffLeft  
			case UltraDMD_eScrollRight
				UltraDMD.DisplayScene00 background, toptext, 15, bottomtext, 15, UltraDMD_Animation_ScrollOnRight , duration, UltraDMD_Animation_ScrollOffRight 
			case UltraDMD_eScrollUp
				UltraDMD.DisplayScene00 background, toptext, 15, bottomtext, 15, UltraDMD_Animation_ScrollOnUp , duration, UltraDMD_Animation_ScrollOffUp 
			case UltraDMD_eScrollDown
				UltraDMD.DisplayScene00 background, toptext, 15, bottomtext, 15, UltraDMD_Animation_ScrollOnDown , duration, UltraDMD_Animation_ScrollOffDown   
			case UltraDMD_eZoom
				UltraDMD.DisplayScene00 background, toptext, 15, bottomtext, 15, UltraDMD_Animation_ZoomIn  , duration, UltraDMD_Animation_ZoomOut  
			case UltraDMD_eFade
				UltraDMD.DisplayScene00 background, toptext, 15, bottomtext, 15, UltraDMD_Animation_FadeIn   , duration, UltraDMD_Animation_FadeOut 
			case Else
				UltraDMD.DisplayScene00 background, toptext, 15, bottomtext, 15, UltraDMD_Animation_None , duration, UltraDMD_Animation_None 
		end select
		UltraDMDTimer.Enabled = 1 'to show the score after the animation/message'
	end if
	If jpsdmd = true then
		TimerVPXText.interval = duration*2
		TimerVPXText.enabled = true
		dLine(0) = cl(toptext)
		dline(1) = cl(bottomtext)
		dmdupdate 0
		dmdupdate 1
	end if
End Sub

Sub DMDScore
	If UltraDMDTimer.Enabled = 0 Then
	If turnonultradmd = 0 and JPsDMD = false then exit sub
		If turnonultradmd = true then
			UltraDMD.SetScoreboardBackgroundImage "scoreboard-sun-background.jpg", 15, 7
			UltraDMD.DisplayScoreboard nNumberOfPlayers, nCurrentPlayer, nScore(1), nScore(2), nScore(3), nScore(4), "Player " & nCurrentPlayer, "Ball " & nCurrentBall
		end if
	end if
	if TimerVPXText.enabled = false then
		If jpsdmd = true then
			dLine(0) = CL("player " & nCurrentPlayer & " - BALL " & nCurrentBall)
			dline(1) = cl(nScore(nCurrentPlayer))
			dmdupdate 0
			dmdupdate 1
		end if
	end if
End Sub

Sub DMDScoreNow
	If turnonultradmd = 0 and jpsdmd = false then exit sub
	DMDFlush
	DMDScore
End Sub

Sub DMDFLush
	If turnonultradmd = 0 and jpsdmd = false then exit sub
	if turnonultradmd = true then
		UltraDMDTimer.Enabled = 0
		UltraDMD.CancelRendering
	end if
	TimerVPXText.enabled = false
End Sub

Sub DMDScrollCredits(background, text, duration)
	If turnonultradmd = 0 and jpsdmd = false then exit sub
	UltraDMD.ScrollingCredits background, text, 15, 10, duration, 10
End Sub

Sub DMDId(id, background, toptext, bottomtext, duration)
	If turnonultradmd = 0 and jpsdmd = false then exit sub
	If turnonultradmd = true then
		UltraDMD.DisplayScene00ExwithID id, False, background, toptext, 15, 0, bottomtext, 15, 0, 14, duration, 14
	end if
	if jpsdmd = true Then
		dLine(0) = cl(toptext)
		dline(1) = cl(bottomtext)
		dmdupdate 0
		dmdupdate 1
	end if
End Sub

Sub DMDMod(id, toptext, bottomtext, duration)
	If turnonultradmd = 0 and jpsdmd = false then exit sub
	If turnonultradmd = true then
		UltraDMD.ModifyScene00Ex id, toptext, bottomtext, duration
	end if
	if jpsdmd = true Then
		dLine(0) = cl(toptext)
		dline(1) = cl(bottomtext)
		dmdupdate 0
		dmdupdate 1
	end if
End Sub

Sub UltraDMDTimer_Timer 'used for the attrackmode and the instant info.
	If turnonultradmd = 0 then exit sub
	If NOT UltraDMD.IsRendering Then
		DMDScoreNow
	end if
End Sub

Dim FlexDMD

Sub DMD_Init
	If turnonultradmd = 0 then exit sub

 	On Error Resume Next

	If DMDMode = 1 then ' FlexDMD

		Set FlexDMD = CreateObject("FlexDMD.FlexDMD")
		If FlexDMD is Nothing Then
			MsgBox "No FlexDMD found.  Install FLexDMD (Preferred) or switch to UltraDMD in the script (DMDMode = 0)"
			Exit Sub
		End If
		FlexDMD.GameName = cGameName
		FlexDMD.RenderMode = 2
		FlexDMD.ProjectFolder = cAssetsFolder+".UltraDMD" 
		FlexDMD.Color = RGB(137,182,226)

		Set UltraDMD = FlexDMD.NewUltraDMD()
		UltraDMD.Init

		If ShowCabinetDMD =false then
			UltraDMD.SetVisibleVirtualDMD False
		end If

		If ShowVpxDMD = True Then
			dmd1.visible = true
			TimerDMD.enabled = true
		end if

		If Not UltraDMD.GetMajorVersion = 1 Then
			MsgBox "Incompatible Version of UltraDMD found."
			Exit Sub
		End If

	Else ' UltraDMD

		ExecuteGlobal GetTextFile("UltraDMD_Options.vbs")

		InitUltraDMD cAssetsFolder,cGameName
	end if
End Sub

Dim DMDp

Sub TimerDMD_Timer()
		DMDp = FlexDMD.DmdPixels
		If Not IsEmpty(DMDp) Then
			DMDWidth = FlexDMD.Width
			DMDHeight = FlexDMD.Height
			DMDPixels = DMDp
		End If
End Sub




'*********************************************************************
'                 Positional Sound Playback Functions
'*********************************************************************

' Play a sound, depending on the X,Y position of the table element (especially cool for surround speaker setups, otherwise stereo panning only)
' parameters (defaults): loopcount (1), volume (1), randompitch (0), pitch (0), useexisting (0), restart (1))
' Note that this will not work (currently) for walls/slingshots as these do not feature a simple, single X,Y position
Sub PlayXYSound(soundname, tableobj, loopcount, volume, randompitch, pitch, useexisting, restart)
	PlaySound soundname, loopcount, volume, AudioPan(tableobj), randompitch, pitch, useexisting, restart, AudioFade(tableobj)
End Sub

' Similar subroutines that are less complicated to use (e.g. simply use standard parameters for the PlaySound call)
Sub PlaySoundAt(soundname, tableobj)
    PlaySound soundname, 1, nTableFxVolume, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub

Sub PlaySoundAtBall(soundname)
    PlaySoundAt soundname, ActiveBall
End Sub

Sub PlaySoundAtLoop(soundname, tableobj)
    PlaySound soundname, -1, nTableFxVolume, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub

Sub PlaySoundAtVol(soundname, aVol, tableobj)
    PlaySound soundname, 1, aVol, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub

Sub PlayLoopSoundAtVol(soundname, aVol, tableobj)
    PlaySound soundname, -1, aVol, AudioPan(tableobj), 0,0,0, 1, AudioFade(tableobj)
End Sub

Sub PlaySoundAtExisting(soundname, tableobj)
    PlaySound soundname, 1, nTableFxVolume, AudioPan(tableobj), 0,0,1, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtBallVol (Soundname, aVol)
	Playsound soundname, 1,aVol, AudioPan(ActiveBall), 0,0,0, 1, AudioFade(ActiveBall)
End Sub

Sub PlaySoundAtBallVolM (Soundname, aVol)
	Playsound soundname, 1,aVol, AudioPan(ActiveBall), 0,0,0, 0, AudioFade(ActiveBall)
End Sub

Dim bEndSong : bEndSong = false

Sub Table1_MusicDone()
	If bdebugGeneral Then debug.print "Sub Table1_MusicDone() : "
	If bMusicOn = true Then
		If bCurrentSongIsEndSong = false then
			PlayMusic StrCurrentSong+cstr(1)+".mp3" , nTableMusicVolume
		Else
			bCurrentSongIsEndSong = false
		end if
	end if
End Sub

Sub PlaySong(BaseName,Sequence)
	If bdebugGeneral Then debug.print "Sub PlaySong() : " & BaseName & " | " & Sequence
	if btilted then exit sub
	If bMusicOn = true Then
		If (StrCurrentSong <> BaseName) Then
			bCurrentSongIsIntro = False
			bCurrentSongIsEndSong = False
			If Sequence = 0 then bCurrentSongIsIntro = True
			Endmusic
			StrCurrentSong = BaseName
			PlayMusic StrCurrentSong+cstr(Sequence)+".mp3" , nTableMusicVolume
			If bdebugGeneral = true Then debug.print "PlaySong : " & StrCurrentSong+cstr(Sequence)+".mp3"
		end if
	End If
End Sub

Sub StopSong()
	If bdebugGeneral Then debug.print "Sub StopSong() : "
	If bMusicOn Then
		endmusic
		StrCurrentSong = "" : bCurrentSongIsIntro = false
		If bdebugGeneral Then debug.print "StopSong : " & StrCurrentSong
	end if
End Sub


'*********************************************************************
'                     Supporting Ball & Sound Functions
'*********************************************************************

Function AudioFade(tableobj) ' Fades between front and back of the table (for surround systems or 2x2 speakers, etc), depending on the Y position on the table. "table1" is the name of the table
	Dim tmp
    tmp = tableobj.y * 2 / table1.height-1
    If tmp > 0 Then
		AudioFade = Csng(tmp ^10)
    Else
        AudioFade = Csng(-((- tmp) ^10) )
    End If
End Function

Function AudioPan(tableobj) ' Calculates the pan for a tableobj based on the X position on the table. "table1" is the name of the table
    Dim tmp
    tmp = tableobj.x * 2 / table1.width-1
    If tmp > 0 Then
        AudioPan = Csng(tmp ^10)
    Else
        AudioPan = Csng(-((- tmp) ^10) )
    End If
End Function

Function Vol(ball) ' Calculates the Volume of the sound based on the ball speed
    Vol = Csng(BallVel(ball) ^2 / 2000)
End Function

Function Pitch(ball) ' Calculates the pitch of the sound based on the ball speed
    Pitch = BallVel(ball) * 20
End Function

Function BallVel(ball) 'Calculates the ball speed
    BallVel = INT(SQR((ball.VelX ^2) + (ball.VelY ^2) ) )
End Function

Sub AddSpeechToQueue(strSample, numTime)
	if bDebugGeneral then debug.print "Sub AddSpeechToQueue() : " & strSample & " " & numTime

	nVocalQueue(nVocalQueueLength,0) = strSample
	nVocalQueue(nVocalQueueLength,1) = numTime

	nVocalQueueLength = nVocalQueueLength + 1

	if TimerVocalQueue.enabled = 0 then
		TimerVocalQueue.interval = 5
		TimerVocalQueue.enabled = 1
	end if
End Sub

Sub TimerVocalQueue_Timer()
	dim a
	
	TimerVocalQueue.enabled = 0
	TimerVocalQueue.interval = nVocalQueue(0,1)

	If nVocalQueueLength > 0 then
		' There is at least 1 in the queue
		Playsound nVocalQueue(0,0) , 1 , nTableSpeechVolume
		TimerVocalQueue.enabled = 1
	end if
	
	if nVocalQueueLength > 1 then
		' There are more then 1 in the queue, so shift all 1 down
		for a = 0 to nVocalQueueLength
			nVocalQueue(a,0) = nVocalQueue(a+1,0)
			nVocalQueue(a,1) = nVocalQueue(a+1,1)
		next
	end If
	if 	nVocalQueueLength > 0 then
		nVocalQueueLength = nVocalQueueLength - 1
	end if
End Sub

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

Sub swStartBallControl_Hit()
	Set ControlActiveBall = ActiveBall
	ControlBallInPlay = true
End Sub

Sub swStopBallControl_Hit()
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


'********************************************************************
'      JP's VP10 Rolling Sounds (+rothbauerw's Dropping Sounds)
'********************************************************************

Const tnob = 5 ' total number of balls
ReDim rolling(tnob)
InitRolling

Sub InitRolling
    Dim i
    For i = 0 to tnob
        rolling(i) = False
    Next
End Sub

Sub RollingTimer_Timer()
    Dim BOT, b
    BOT = GetBalls

    ' stop the sound of deleted balls
    For b = UBound(BOT) + 1 to tnob
        rolling(b) = False
        StopSound("fx_ballrolling" & b)
    Next

    ' exit the sub if no balls on the table
    If UBound(BOT) = -1 Then Exit Sub

    For b = 0 to UBound(BOT)
        ' play the rolling sound for each ball
        If BallVel(BOT(b) ) > 1 AND BOT(b).z < 30 Then
            rolling(b) = True
            PlaySound("fx_ballrolling" & b), -1, Vol(BOT(b)), AudioPan(BOT(b)), 0, Pitch(BOT(b)), 1, 0, AudioFade(BOT(b))
        Else
            If rolling(b) = True Then
                StopSound("fx_ballrolling" & b)
                rolling(b) = False
            End If
        End If

        ' play the rolling metal sound for each ball
        If BallVel(BOT(b) ) > 1 AND (BOT(b).z > 55 or BOT(b).z < -10) Then
            rolling(b) = True
            PlaySound("fx_metalrolling" & b), -1, Vol(BOT(b)), AudioPan(BOT(b)), 0, Pitch(BOT(b)), 1, 0, AudioFade(BOT(b))
        Else
            If rolling(b) = True Then
                StopSound("fx_metalrolling" & b)
                rolling(b) = False
            End If
        End If

        ' play ball drop sounds
        If BOT(b).VelZ < -1 and BOT(b).z < 55 and BOT(b).z > 27 Then 'height adjust for ball drop sounds
            PlaySound "fx_ball_drop" & b, 0, ABS(BOT(b).velz)/17, AudioPan(BOT(b)), 0, Pitch(BOT(b)), 1, 0, AudioFade(BOT(b))
        End If
    Next
End Sub

'**********************
' Ball Collision Sound
'**********************

Sub OnBallBallCollision(ball1, ball2, velocity)
	PlaySound("fx_collide"), 0, Csng(velocity) ^2 / 2000, AudioPan(ball1), 0, Pitch(ball1), 0, 0, AudioFade(ball1)
End Sub


'*****************************************
'	ninuzzu's	FLIPPER SHADOWS
'*****************************************

sub FlipperTimer_Timer()
	FlipperLSh.RotZ = LeftFlipper.currentangle
	FlipperRSh.RotZ = RightFlipper.currentangle
End Sub

'*****************************************
'	ninuzzu's	BALL SHADOW
'*****************************************
Dim BallShadow
BallShadow = Array (BallShadow1,BallShadow2,BallShadow3,BallShadow4,BallShadow5)

Sub BallShadowUpdate_timer()
    Dim BOT, b
    BOT = GetBalls
    ' hide shadow of deleted balls
    If UBound(BOT)<(tnob-1) Then
        For b = (UBound(BOT) + 1) to (tnob-1)
            BallShadow(b).visible = 0
        Next
    End If
    ' exit the Sub if no balls on the table
    If UBound(BOT) = -1 Then Exit Sub
    ' render the shadow for each ball
    For b = 0 to UBound(BOT)
        If BOT(b).X < Table1.Width/2 Then
            BallShadow(b).X = ((BOT(b).X) - (Ballsize/6) + ((BOT(b).X - (Table1.Width/2))/7)) + 6
        Else
            BallShadow(b).X = ((BOT(b).X) + (Ballsize/6) + ((BOT(b).X - (Table1.Width/2))/7)) - 6
        End If
        ballShadow(b).Y = BOT(b).Y + 12
        If BOT(b).Z > 20 Then
            BallShadow(b).visible = 1
        Else
            BallShadow(b).visible = 0
        End If
    Next
End Sub

' #####################################
' ###### FLASHER DOME FLUPPER     #####
' #####################################

Dim TestFlashers, TableRef, FlasherLightIntensity, FlasherFlareIntensity, FlasherOffBrightness, FlasherFlareSunIntensity

								' *********************************************************************
TestFlashers = 0				' *** set this to 1 to check position of flasher object 			***
Set TableRef = Table1   		' *** change this, if your table has another name       			***
FlasherLightIntensity = 1		' *** lower this, if the VPX lights are too bright (i.e. 0.1)		***
FlasherFlareIntensity = 1		' *** lower this, if the flares are too bright (i.e. 0.1)			***
FlasherOffBrightness = 0.5		' *** brightness of the flasher dome when switched off (range 0-2)	***
FlasherFlareSunIntensity = 2	' *********************************************************************

Dim ObjLevel(20), objbase(20), objlit(20), objflasher(20), objlight(20)
Dim ObjSunLevel(35),objSun(35)

Dim tablewidth, tableheight : tablewidth = TableRef.width : tableheight = TableRef.height
'initialise the flasher color, you can only choose from "green", "red", "purple", "blue", "white" and "yellow"
InitFlasher 1, "yellow" : InitFlasher 2, "red" : InitFlasher 3, "red" : InitFlasher 4, "blue"
InitSunFlasher 1 , "yellow" : InitSunFlasher 2 , "yellow"
InitSunFlasher 3 , "yellow" : InitSunFlasher 4 , "yellow"
InitSunFlasher 5 , "white" : InitSunFlasher 6 , "white"
InitSunFlasher 7 , "white"
InitSunFlasher 8 , "white":InitSunFlasher 15 , "white"
InitSunFlasher 9 , "blue"
InitSunFlasher 10, "red"
InitSunFlasher 11 , "white" : InitSunFlasher 12 , "white"
InitSunFlasher 13 , "darkred" : InitSunFlasher 14 , "darkred"
InitSunFlasher 16 , "red"
InitSunFlasher 17 , "yellow"
InitSunFlasher 18 , "green"
InitSunFlasher 19 , "yellow"
InitSunFlasher 20 , "yellow"
InitSunFlasher 21 , "yellow"
InitSunFlasher 22 , "yellow"
InitSunFlasher 23 , "yellow"
InitSunFlasher 24 , "red"
InitSunFlasher 25 , "yellow"
InitSunFlasher 26 , "yellow"
InitSunFlasher 27 , "blue"
InitSunFlasher 28 , "blue"
' rotate the flasher with the command below (first argument = flasher nr, second argument = angle in degrees)
'RotateFlasher 4,17 : RotateFlasher 5,0 : RotateFlasher 6,90
'RotateFlasher 7,0 : RotateFlasher 8,0 
'RotateFlasher 9,-45 : RotateFlasher 10,90 : RotateFlasher 11,90

Sub InitFlasher(nr, col)
	' store all objects in an array for use in FlashFlasher subroutine
	Set objbase(nr) = Eval("Flasherbase" & nr) : Set objlit(nr) = Eval("Flasherlit" & nr)
	Set objflasher(nr) = Eval("Flasherflash" & nr) : Set objlight(nr) = Eval("Flasherlight" & nr)
	' If the flasher is parallel to the playfield, rotate the VPX flasher object for POV and place it at the correct height
	If objbase(nr).RotY = 0 Then
		objbase(nr).ObjRotZ =  atn( (tablewidth/2 - objbase(nr).x) / (objbase(nr).y - tableheight*1.1)) * 180 / 3.14159
		objflasher(nr).RotZ = objbase(nr).ObjRotZ : objflasher(nr).height = objbase(nr).z + 60
	End If
	' set all effects to invisible and move the lit primitive at the same position and rotation as the base primitive
	objlight(nr).IntensityScale = 0 : objlit(nr).visible = 0 : objlit(nr).material = "Flashermaterial" & nr
	objlit(nr).RotX = objbase(nr).RotX : objlit(nr).RotY = objbase(nr).RotY : objlit(nr).RotZ = objbase(nr).RotZ
	objlit(nr).ObjRotX = objbase(nr).ObjRotX : objlit(nr).ObjRotY = objbase(nr).ObjRotY : objlit(nr).ObjRotZ = objbase(nr).ObjRotZ
	objlit(nr).x = objbase(nr).x : objlit(nr).y = objbase(nr).y : objlit(nr).z = objbase(nr).z
	objbase(nr).BlendDisableLighting = FlasherOffBrightness
	' set the texture and color of all objects
	select case objbase(nr).image
		Case "dome2basewhite" : objbase(nr).image = "dome2base" & col : objlit(nr).image = "dome2lit" & col : 
		Case "ronddomebasewhite" : objbase(nr).image = "ronddomebase" & col : objlit(nr).image = "ronddomelit" & col
		Case "domeearbasewhite" : objbase(nr).image = "domeearbase" & col : objlit(nr).image = "domeearlit" & col
	end select
	If TestFlashers = 0 Then objflasher(nr).imageA = "domeflashwhite" : objflasher(nr).visible = 0 : End If
	select case col
		Case "blue" :   objlight(nr).color = RGB(4,120,255) : objflasher(nr).color = RGB(200,255,255) : objlight(nr).intensity = 5000
		Case "green" :  objlight(nr).color = RGB(12,255,4) : objflasher(nr).color = RGB(12,255,4)
		Case "red" :    objlight(nr).color = RGB(255,32,4) : objflasher(nr).color = RGB(255,32,4)
		Case "darkred" :    objlight(nr).color = RGB(64,0,0) : objflasher(nr).color = RGB(64,0,0)
		Case "purple" : objlight(nr).color = RGB(230,49,255) : objflasher(nr).color = RGB(255,64,255) 
		Case "yellow" : objlight(nr).color = RGB(200,173,25) : objflasher(nr).color = RGB(255,200,50)
		Case "white" :  objlight(nr).color = RGB(255,240,150) : objflasher(nr).color = RGB(100,86,59)
	end select
	objlight(nr).colorfull = objlight(nr).color
	If TableRef.ShowDT and ObjFlasher(nr).RotX = -45 Then 
		objflasher(nr).height = objflasher(nr).height - 20 * ObjFlasher(nr).y / tableheight
		ObjFlasher(nr).y = ObjFlasher(nr).y + 10
	End If
End Sub

Sub InitSunFlasher(nr,col)
	Set objSun(nr)=Eval("FlasherSun" & nr)
	select case col
		Case "blue" :    objSun(nr).color = RGB(4,32,255) :
		Case "green" :   objSun(nr).color = RGB(12,255,4)
		Case "red" :     objSun(nr).color = RGB(255,32,4)
		Case "purple" :  objSun(nr).color = RGB(255,64,255) 
		Case "yellow" :  objSun(nr).color = RGB(255,200,50)
		Case "white" :   objSun(nr).color = RGB(100,86,59)
	end select
End Sub

Sub RotateFlasher(nr, angle) : angle = ((angle + 360 - objbase(nr).ObjRotZ) mod 180)/30 : objbase(nr).showframe(angle) : objlit(nr).showframe(angle) : End Sub

Sub FlashFlasher(nr)
	On error resume next
	If not objflasher(nr).TimerEnabled Then objflasher(nr).TimerEnabled = True : objflasher(nr).visible = 1 : objlit(nr).visible = 1 : End If
	objflasher(nr).opacity = 1000 *  FlasherFlareIntensity * ObjLevel(nr)^2.5
	objlight(nr).IntensityScale = 0.5 * FlasherLightIntensity * ObjLevel(nr)^3
	objbase(nr).BlendDisableLighting =  FlasherOffBrightness + 10 * ObjLevel(nr)^3	
	objlit(nr).BlendDisableLighting = 10 * ObjLevel(nr)^2
	UpdateMaterial "Flashermaterial" & nr,0,0,0,0,0,0,ObjLevel(nr),RGB(255,255,255),0,0,False,True,0,0,0,0 
	ObjLevel(nr) = ObjLevel(nr) * 0.9 - 0.01
	If ObjLevel(nr) < 0 Then objflasher(nr).TimerEnabled = False : objflasher(nr).visible = 0 : objlit(nr).visible = 0 : End If
End Sub

Sub SunFlasher(nr)
	On error resume next
	If not objSun(nr).TimerEnabled Then objSun(nr).TimerEnabled = True : objSun(nr).visible = 1 : End If
	objSun(nr).opacity = 1000 *  FlasherFlareSunIntensity * ObjSunLevel(nr)^2.5
	ObjSunLevel(nr) = ObjSunLevel(nr) * 0.9 - 0.01
	If ObjSunLevel(nr) < 0 Then objSun(nr).TimerEnabled = False : objSun(nr).visible = 0  : End If
End Sub

Sub FlasherFlash1_Timer() : FlashFlasher(1) : End Sub 
Sub FlasherFlash2_Timer() : FlashFlasher(2) : End Sub 
Sub FlasherFlash3_Timer() : FlashFlasher(3) : End Sub 
Sub FlasherFlash4_Timer() : FlashFlasher(4) : End Sub 
Sub FlasherFlash5_Timer() : FlashFlasher(5) : End Sub 
Sub FlasherFlash6_Timer() : FlashFlasher(6) : End Sub 
Sub FlasherFlash7_Timer() : FlashFlasher(7) : End Sub
Sub FlasherFlash8_Timer() : FlashFlasher(8) : End Sub
Sub FlasherFlash9_Timer() : FlashFlasher(9) : End Sub
Sub FlasherFlash10_Timer() : FlashFlasher(10) : End Sub
Sub FlasherFlash11_Timer() : FlashFlasher(11) : End Sub

Sub FlasherSun1_Timer() : SunFlasher(1) : End Sub
Sub FlasherSun2_Timer() : SunFlasher(2) : End Sub
Sub FlasherSun3_Timer() : SunFlasher(3) : End Sub
Sub FlasherSun4_Timer() : SunFlasher(4) : End Sub
Sub FlasherSun5_Timer() : SunFlasher(5) : End Sub
Sub FlasherSun6_Timer() : SunFlasher(6) : End Sub
Sub FlasherSun7_Timer() : SunFlasher(7) : End Sub
Sub FlasherSun8_Timer() : SunFlasher(8) : End Sub
Sub FlasherSun9_Timer() : SunFlasher(9) : End Sub
Sub FlasherSun10_Timer() : SunFlasher(10) : End Sub
Sub FlasherSun11_Timer() : SunFlasher(11) : End Sub
Sub FlasherSun12_Timer() : SunFlasher(12) : End Sub
Sub FlasherSun13_Timer() : SunFlasher(13) : End Sub
Sub FlasherSun14_Timer() : SunFlasher(14) : End Sub
Sub FlasherSun15_Timer() : SunFlasher(15) : End Sub
Sub FlasherSun16_Timer() : SunFlasher(16) : End Sub
Sub FlasherSun17_Timer() : SunFlasher(17) : End Sub
Sub FlasherSun18_Timer() : SunFlasher(18) : End Sub
Sub FlasherSun19_Timer() : SunFlasher(19) : End Sub
Sub FlasherSun20_Timer() : SunFlasher(20) : End Sub
Sub FlasherSun21_Timer() : SunFlasher(21) : End Sub
Sub FlasherSun22_Timer() : SunFlasher(22) : End Sub
Sub FlasherSun23_Timer() : SunFlasher(23) : End Sub
Sub FlasherSun24_Timer() : SunFlasher(24) : End Sub
Sub FlasherSun25_Timer() : SunFlasher(25) : End Sub
Sub FlasherSun26_Timer() : SunFlasher(26) : End Sub
Sub FlasherSun27_Timer() : SunFlasher(27) : End Sub
Sub FlasherSun28_Timer() : SunFlasher(28) : End Sub
'**************************************
' Explanation of the collision routine
'**************************************

' The collision is built in VP.
' You only need to add a Sub OnBallBallCollision(ball1, ball2, velocity) and when two balls collide they 
' will call this routine. What you add in the sub is up to you. As an example is a simple Playsound with volume and paning
' depending of the speed of the collision.


Sub Pins_Hit (idx)
	PlaySound "pinhit_low", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 0, 0, AudioFade(ActiveBall)
End Sub

Sub Targets_Hit (idx)
	PlaySound "fx_target", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 0, 0, AudioFade(ActiveBall)
	AddScore cScoreHitTarget
	ActivateComboLights
End Sub

Sub Metals_Thin_Hit (idx)
	PlaySound "metalhit_thin", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
End Sub

Sub Metals_Medium_Hit (idx)
	PlaySound "metalhit_medium", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
End Sub

Sub Metals2_Hit (idx)
	PlaySound "metalhit2", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
End Sub

Sub Gates_Hit (idx)
	PlaySound "gate4", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
End Sub

Sub Kickers_Hit (idx)
	PlaySound "kicker_enter_center", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
End Sub

Sub Spinner_Spin
	PlaySound "fx_spinner", 0, .25, AudioPan(Spinner), 0.25, 0, 0, 1, AudioFade(Spinner)
End Sub

Sub Rubbers_Hit(idx)
 	dim finalspeed
  	finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
 	If finalspeed > 20 then 
		PlaySound "fx_rubber2", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
	End if
	If finalspeed >= 6 AND finalspeed <= 20 then
 		RandomSoundRubber()
 	End If
End Sub

Sub Posts_Hit(idx)
 	dim finalspeed
  	finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
 	If finalspeed > 16 then 
		PlaySound "fx_rubber2", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
	End if
	If finalspeed >= 6 AND finalspeed <= 16 then
 		RandomSoundRubber()
 	End If
End Sub

Sub RandomSoundRubber()
	Select Case Int(Rnd*3)+1
		Case 1 : PlaySound "rubber_hit_1", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
		Case 2 : PlaySound "rubber_hit_2", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
		Case 3 : PlaySound "rubber_hit_3", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
	End Select
End Sub

Sub LeftFlipper_Collide(parm)
 	RandomSoundFlipper()
End Sub

Sub RightFlipper_Collide(parm)
 	RandomSoundFlipper()
End Sub

Sub RandomSoundFlipper()
	Select Case Int(Rnd*3)+1
		Case 1 : PlaySound "flip_hit_1", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
		Case 2 : PlaySound "flip_hit_2", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
		Case 3 : PlaySound "flip_hit_3", 0, Vol(ActiveBall), AudioPan(ActiveBall), 0, Pitch(ActiveBall), 1, 0, AudioFade(ActiveBall)
	End Select
End Sub

'**********************************************************
'* FUNCTIONS **********************************************
'**********************************************************

Function RndNum(min,max)
	RndNum = Int(Rnd()*(max-min+1))+min     ' Sets a random number between min AND max
End Function

'**********************************************************
'* TABLE SPECIFIC *****************************************
'**********************************************************

changegi white

'**********************************************************
'* SCORE **************************************************
'**********************************************************

Sub AddScore(aValue)
	nScore(nCurrentPlayer)=nScore(nCurrentPlayer)+aValue
	dmdscore
	B2SLight RndNum(21,27),250
End Sub

'**********************************************************
'* BUMPERS ************************************************
'**********************************************************

Sub Bumper1_Hit()
	if btilted then exit Sub
	B2SLight rndnum(31,39),100
	PlaySoundAt SoundFXDOF("fx_bumper1", 111, DOFPulse, DOFContactors), ActiveBall ': LiBumper1.duration 1,100,0
	ObjSunlevel(7) = 1 : FlasherSun7_Timer
	PlaySound "SFX_MeanFall" , 1 , nTableSFXVolume
	AddScore cScoreBumper
End Sub
Sub Bumper2_Hit()
	if btilted then exit Sub
	B2SLight rndnum(31,39),100
	PlaySoundAt SoundFXDOF("fx_bumper2", 112, DOFPulse, DOFContactors), ActiveBall:	LiBumper2.duration 1,100,0
	PlaySound "SFX_Predator"+cstr(Int(Rnd*8)+1) , 1 , nTableSFXVolume
	AddScore cScoreBumper
End Sub
Sub Bumper3_Hit()
	if btilted then exit Sub
	B2SLight rndnum(31,39),100
	PlaySoundAt SoundFXDOF("fx_bumper3", 113, DOFPulse, DOFContactors), ActiveBall:	LiBumper3.duration 1,100,0
	PlaySound "SFX_SpaceStation"+cstr(Int(Rnd*8)+1) , 1 , nTableSFXVolume
	AddScore cScoreBumper
End Sub
Sub Bumper4_Hit()
	if btilted then exit Sub
	B2SLight rndnum(31,39),100
	PlaySoundAt SoundFXDOF("fx_bumper4", 114, DOFPulse, DOFContactors), ActiveBall:	LiBumper4.duration 1,100,0
	PlaySound "SFX_Predator"+cstr(Int(Rnd*8)+1) , 1 , nTableSFXVolume
	AddScore cScoreBumper
End Sub
Sub Bumper5_Hit()
	if btilted then exit Sub
	B2SLight rndnum(31,39),100
	PlaySoundAt SoundFXDOF("fx_bumper1", 115, DOFPulse, DOFContactors), ActiveBall:	LiBumper5.duration 1,100,0
	PlaySound "SFX_SpaceStation"+cstr(Int(Rnd*8)+1) , 1 , nTableSFXVolume
	AddScore cScoreBumper
End Sub

'**********************************************************
'* LANES    ***********************************************
'**********************************************************
Sub LaneShiftRight()
	Dim a,b,c
	a = Li28.state
	Li28.state = Li27.state : nPlayerLights (nCurrentPlayer,28) = Li28.state
	Li27.state = Li26.state : nPlayerLights (nCurrentPlayer,27) = Li27.state
	Li26.state = Li25.state : nPlayerLights (nCurrentPlayer,26) = Li26.state
	Li25.state = a : nPlayerLights (nCurrentPlayer,25) = Li25.state

	b=li17.state
	li17.state=li16.state : nPlayerLights (nCurrentPlayer,17) = Li17.state
	li16.state=li15.state : nPlayerLights (nCurrentPlayer,16) = Li16.state
	li15.state=li14.state : nPlayerLights (nCurrentPlayer,15) = Li15.state
	li14.state=b : nPlayerLights (nCurrentPlayer,14) = Li14.state

	c = li3.state
	li3.state = li2.state
	li2.state = li1.state
	li1.state = c
End Sub

Sub LaneShiftLeft()
	Dim a,b,c
	a = Li25.state
	Li25.state = Li26.state : nPlayerLights (nCurrentPlayer,25) = Li25.state
	Li26.state = Li27.state : nPlayerLights (nCurrentPlayer,26) = Li26.state
	Li27.state = Li28.state : nPlayerLights (nCurrentPlayer,27) = Li27.state
	Li28.state = a : nPlayerLights (nCurrentPlayer,28) = Li28.state

	b = Li14.state
	Li14.state = Li15.state : nPlayerLights (nCurrentPlayer,14) = Li14.state
	Li15.state = Li16.state : nPlayerLights (nCurrentPlayer,15) = Li15.state
	Li16.state = Li17.state : nPlayerLights (nCurrentPlayer,16) = Li16.state
	Li17.state = b : nPlayerLights (nCurrentPlayer,17) = Li17.state

	c = li1.state
	li1.state = li2.state
	li2.state = li3.state
	li3.state = c
End Sub

Sub LeftInlane_Hit()
	if btilted then exit sub
	PlaySound "SFX_Electra1" , 1 , nTableSFXVolume
	AddScore cScoreTrigger
	if bblackholemode = false then
		If Li26.state = 0 then LI26.state = 1 : nPlayerLights (nCurrentPlayer,26) = 1 : CheckLaneLights()
	Else
		If Li26.state <> 0 then LI26.state = 0 : nPlayerLights (nCurrentPlayer,26) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "LeftInLane"
	Call ActivateComboLights
End Sub

Sub RightInlane_Hit()
	if btilted then exit sub
	PlaySound "SFX_Electra1" , 1 , nTableSFXVolume
	AddScore cScoreTrigger
	if bblackholemode = false then
		If Li27.state = 0 then LI27.state = 1 : nPlayerLights (nCurrentPlayer,27) = 1 : CheckLaneLights()
	Else
		If Li27.state <> 0 then LI27.state = 0 : nPlayerLights (nCurrentPlayer,27) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "RightInLane"
	Call ActivateComboLights
End Sub

Sub LeftInlane2_Hit()
	if btilted then exit sub
	PlaySound "SFX_FlyAway" , 1 , nTableSFXVolume
	AddScore cScoreTrigger
	if bblackholemode = false then
		If Li25.state = 0 then LI25.state = 1 : nPlayerLights (nCurrentPlayer,25) = 1 : CheckLaneLights()
	Else
		If Li25.state <> 0 then LI25.state = 0 : nPlayerLights (nCurrentPlayer,25) = 0 : CheckBlackHoleLights()
	end if
End Sub

Sub RightInlane2_Hit()
	if btilted then exit sub
	PlaySound "SFX_FlyAway" , 1 , nTableSFXVolume
	AddScore cScoreTrigger
	if bblackholemode = false then
		If Li28.state = 0 then LI28.state = 1 : nPlayerLights (nCurrentPlayer,28) = 1 : CheckLaneLights()
	Else
		If Li28.state <> 0 then LI28.state = 0 : nPlayerLights (nCurrentPlayer,28) = 0 : CheckBlackHoleLights()
	end if
End Sub

Sub CheckLaneLights()
	if bblackholemode = true then exit sub
	If Li25.state = 1 and Li26.state = 1 and Li27.state = 1 and Li28.state = 1 Then
		Li25.state = 0 : Li26.state = 0 : Li27.state = 0 : Li28.state = 0
		nPlayerLights (nCurrentPlayer,25) = 0 : nPlayerLights (nCurrentPlayer,26) = 0 : nPlayerLights (nCurrentPlayer,27) = 0 : nPlayerLights (nCurrentPlayer,28) = 0
		Playsound "SFX_Rats" ,1 , nTableSFXVolume
		LightEffect 6 'WiperUp
		If Li14.state = 0 then 
			li14.state = 1
			nPlayerLights (nCurrentPlayer,14) = 1	 
			ElseIf Li15.state = 0 then 
				li15.state = 1
				nPlayerLights (nCurrentPlayer,15) = 1		
				ElseIf Li16.state = 0 then 
					li16.state = 1
					nPlayerLights (nCurrentPlayer,16) = 1
 					ElseIf Li17.state = 0 then 
						li17.state = 1
						nPlayerLights (nCurrentPlayer,17) = 1
		end if
	CheckTargetLights() 
	end if
End Sub
'**********************************************************
'* KICKERS ************************************************
'**********************************************************
Sub Kicker001_Hit() ' WormHole
	PlaySoundAt SoundFXDOF("popper_ball", 131, DOFPulse, DOFContactors), kicker001
	DMD2 "", "WORMHOLE", cScoreWormhole, 2000, UltraDMD_eFade , ""
	AddSpeechToQueue "SFX_Speech_Wormhole",1000
	addscore cScoreWormhole
	LightEffect 6
	LightEffect 13
	Objlevel(1) = 2 : vpmtimer.addtimer 500, "FlasherFlash1_Timer '"
	PlaySound "SFX_Sword" , 1 , nTableSFXVolume
	' Reset lights and Targets
	dt1.Isdropped = False : dt2.isdropped = False
	Li11.state = 0 : nPlayerLights (nCurrentPlayer,11) = 0
	Li12.state = 0 : nPlayerLights (nCurrentPlayer,12) = 0
	Li52.state = 0 : nPlayerLights (nCurrentPlayer,52) = 0
end sub

Sub Kicker002_Hit() ' Kicker Right
	nLastTargetHit = "Kicker002"
	call ActivateComboLights
	LightEffect 13
	TimerShakerShip2.enabled=1
	PlaySoundAt "fx_shaker" , Kicker002
	PlaySound "SFX_FlyAway" , 1 , nTableSFXVolume
	ObjSunlevel(14) = 2 : FlasherSun14_Timer
	Objlevel(3) = 2 : vpmtimer.addtimer 1700, "FlasherFlash3_Timer '"
	vpmtimer.addtimer 1500, "AddSpeechToQueue ""SFX_Speech_Get_Ready"",1000 '"
	vpmtimer.addtimer 2000, "TimerShakerShip2.enabled=0 '"
	vpmtimer.addtimer 2000, "kicker002_Launch '"
End Sub

Sub Kicker002_Launch()
	LightEffect 14
	kicker002.kickz 307,70,0,85
	PlaySoundAt SoundFXDOF("popper_ball", 132, DOFPulse, DOFContactors), kicker002
End Sub

Sub Kicker003_Hit()
	LightEffect 1
	PlaySoundAt SoundFXDOF("popper_ball", 133, DOFPulse, DOFContactors), kicker003
	' Check MultiBall Lock
	If LI50.state = 2 Then	
		LI50.state = 1 : nPlayerLights (nCurrentPlayer,50) = 1
		DMD2 "", "BALL LOCKED", "", 2000, UltraDmd_eNone , ""
		PlaySound "SFX_WaveLength",1,nTableSFXVolume
		If LI51.state = 1 Then
			AddSpeechToQueue "SFX_Speech_Ball_2_Locked",1000
		Else
			AddSpeechToQueue "SFX_Speech_Ball_1_Locked",1000
		end If
		Call CheckMultiBallReady
	end if
end sub

Sub Kicker004_Hit() ' Kicker Left
	TimerShakerShip1.enabled=1
	LightEffect 3
	PlaySoundAt "fx_shaker" , Kicker004
	PlaySound "SFX_FlyAway" , 1 , nTableSFXVolume
	ObjSunlevel(13) = 3 : FlasherSun13_Timer
	Objlevel(2) = 2 : vpmtimer.addtimer 1700, "FlasherFlash2_Timer '"
	vpmtimer.addtimer 1500, "AddSpeechToQueue ""SFX_Speech_Get_Ready"",1000 '"
	vpmtimer.addtimer 2000, "TimerShakerShip1.enabled=0 '"
	vpmtimer.addtimer 2000, "kicker004_Launch '"
	'
	' Check MultiBall Lock
	If LI51.state = 2 Then	
		'LI22.state = 0 : nPlayerLights (nCurrentPlayer,22) = 0
		LI51.state = 1 : nPlayerLights (nCurrentPlayer,51) = 1
		DMD2 "", "BALL LOCKED", "", 2000, UltraDmd_eNone , ""
		PlaySound "SFX_WaveLength",1,nTableSFXVolume
		If LI50.state = 1 Then
			AddSpeechToQueue "SFX_Speech_Ball_2_Locked",1000
		Else
			AddSpeechToQueue "SFX_Speech_Ball_1_Locked",1000
		end If
		Call CheckMultiBallReady
	end if	
End Sub

Sub Kicker004_Launch()
	kicker004.kick 131,25,0
	PlaySoundAt SoundFXDOF("popper_ball", 134, DOFPulse, DOFContactors), kicker004
End Sub

Sub Kicker005_Hit() 'KickBack
	LI13.state = 0 : nPlayerLights (nCurrentPlayer,13)=0
	LI61.state = 0 : nPlayerLights (nCurrentPlayer,61)=0
	LI62.state = 0 : nPlayerLights (nCurrentPlayer,62)=0
	ToggleGate006(False)
	LightEffect 10
	vpmtimer.addtimer 1200, "AddSpeechToQueue ""SFX_Speech_Get_Ready"",1000 '"
	vpmtimer.addtimer 1500, "kicker005_Launch '"
End Sub

Sub Kicker005_Launch() 'Kickback
	kicker005.kick 0,70,0
	PlaySoundAt SoundFXDOF("popper_ball", 150, DOFPulse, DOFContactors), kicker005
End Sub

Sub Kicker006_hit() ' Secret Galaxy / COmbo Bonus
	if btilted Then
		kicker006_Launch
		Exit Sub
	end if
	AddSpeechToQueue "SFX_Speech_You_Found_A_Secret_Galaxy",2000
	DOF 157, DOFPULSE
	lighteffect 5
	playsound "SFX_Wormhole",1,nTableSFXVolume
	if bDebugGeneral = true then debug.print int((nCombos(nCurrentPlayer) / nComboBonus)+0.5)
	if bDebugGeneral = true then debug.print nCombos(nCurrentPlayer) / nComboBonus
	If bReadyForComboBonus = true Then	
		' Award ComboBonus
		bReadyForComboBonus = false
		changegi white
		TimerComboBonus.uservalue = 50
		TimerComboBonus.interval = 10
		TimerComboBonus.enabled = true
	Else
		DMD2 "", "SECRET GALAXY", "", 2000, UltraDmd_eNone , ""
		Objlevel(4) = 0.75 
		vpmtimer.addtimer 2200, "FlasherFlash4_Timer '"
		vpmtimer.addtimer 2000, "AddSpeechToQueue ""SFX_Speech_Get_Ready"",1000 '"
		vpmtimer.addtimer 2500, "kicker006_Launch '"
		AddScore cSecretGalaxy
	end if
End Sub

Sub TimerComboBonus_Timer()
	dim a
	do 
		a = RndNum(1,5)
	Loop until a <> nPreviousComboBonus
	nPreviousComboBonus = a
	playsound "SFX_Spinner",1,nTableSFXVolume/2
	DMDFLush
	select case a
	case 1
		DMD2 "", "EXTRA BALL", "", 2000, UltraDmd_eNone , ""
		DOF 164, DOFPULSE
	case 2
		DMD2 "", "INSTANT", "MULTI BALL", 2000, UltraDmd_eNone , ""
		DOF 165, DOFPULSE
	case 3
		DMD2 "", "500000", "", 2000, UltraDmd_eNone , ""
		DOF 163, DOFPULSE
	case 4
		DMD2 "", "PLANET AWARD", "", 2000, UltraDmd_eNone , ""
		DOF 165, DOFPULSE
	case 5
		DMD2 "", "ACTIVATE", "KICKBACK", 2000, UltraDmd_eNone , ""
		DOF 165, DOFPULSE
	end select

	TimerComboBonus.UserValue = TimerComboBonus.UserValue - 1
	TimerComboBonus.interval = TimerComboBonus.interval + 5
	If TimerComboBonus.UserValue < 0 Then
		TimerComboBonus.enabled = False
		call AwardComboBonus(a)
	end If
end Sub

Sub AwardComboBonus(a)
	lighteffect 4
	Select case a
		case 1
			LightEffect 9 'All Blink
			LI7.State = 1
			LI7.timerenabled = False
			bBallSaved = true
			DMD2 "", "EXTRA BALL", "", 2000, UltraDmd_eNone , ""
			AddSpeechToQueue "SFX_Speech_Extra_Ball",1200
			PlaySOund "SFX_KiWi",1,nTableSFXVolume
			DOF 149, DOFPULSE
		case 2
			AddMultiBalls 1
			AddSpeechToQueue "SFX_Speech_Instant_Multiball",2000
			DOF 153, DOFPULSE
		case 3
			AddScore 500000
			AddSpeechToQueue "SFX_Speech_500000_Points",2000
			DOF 148, DOFPULSE
		case 4
			Call AwardPlanet(True)
		case 5
			LI13.state = 1 
			ToggleGate006(True)
			LI61.state = 2 : nPlayerLights (nCurrentPlayer,61)=2
			LI62.state = 1 : nPlayerLights (nCurrentPlayer,62)=1
			PlaySOund "SFX_Positron",1,nTableSFXVolume		
			DMD2 "", "KICKBACK", "ACTIVATED", 2000, UltraDmd_eNone , ""
			AddSpeechToQueue "SFX_Speech_Kickback_Is_Now_Activated",2000
	end Select
	playsong strSongToPlay,1
	Objlevel(4) = 0.75 
	vpmtimer.addtimer 2200, "FlasherFlash4_Timer '"
	vpmtimer.addtimer 2000, "AddSpeechToQueue ""SFX_Speech_Get_Ready"",1000 '"
	vpmtimer.addtimer 2500, "kicker006_Launch '"
End Sub

Sub Kicker006_Launch()
	kicker006.kick 45,10,0
	PlaySoundAt SoundFXDOF("popper_ball", 151, DOFPulse, DOFContactors), kicker006
End Sub

'**********************************************************
'* DROP TARGETS *******************************************
'**********************************************************
Sub Dt1_Hit() ' WormHole
	if bTilted then exit sub
	Objlevel(1) = 2 : FlasherFlash1_Timer
	PlaySoundAt SoundFXDOF("fx_target", 139, DOFPulse, DOFTargets), Dt1
	if bBlackHoleMode = false then
		If Li12.state = 0 then Li12.state = 1 : nPlayerLights (nCurrentPlayer,12) = 1 : CheckTargetLights()
	Else
		If Li12.state <> 0 then Li12.state = 0 : nPlayerLights (nCurrentPlayer,12) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "DT1"
End Sub
Sub Dt2_Hit() ' WormHole
	if bTilted then exit sub
	Objlevel(1) = 2 : FlasherFlash1_Timer
	PlaySoundAt SoundFXDOF("fx_target", 139, DOFPulse, DOFTargets), Dt2
	if bBlackHoleMode = false then
		If Li11.state = 0 then Li11.state = 1 : nPlayerLights (nCurrentPlayer,11) = 1 : CheckTargetLights()
	Else
		If Li11.state <> 0 then Li11.state = 0 : nPlayerLights (nCurrentPlayer,11) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "DT2"
End Sub

'**********************************************************
'* TARGETS ************************************************
'**********************************************************

Sub Ht4_Hit()
	if bTilted then exit sub
	ObjSunlevel(26) = 1 : FlasherSun26_Timer
	PlaySoundAt SoundFXDOF("fx_target", 138, DOFPulse, DOFTargets), HT4
	if bBlackHoleMode = false then
		If Li4.state = 0 then Li4.state = 1 : nPlayerLights (nCurrentPlayer,4) = 1 : CheckTargetLights()
	Else
		If Li4.state <> 0 then Li4.state = 0 : nPlayerLights (nCurrentPlayer,4) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT4"
End Sub
Sub Ht5_Hit()
	if bTilted then exit sub
	ObjSunlevel(25) = 1 : FlasherSun25_Timer
	PlaySoundAt SoundFXDOF("fx_target", 138, DOFPulse, DOFTargets), HT5
	if bBlackHoleMode = false then
		If Li5.state = 0 then Li5.state = 1 : nPlayerLights (nCurrentPlayer,5) = 1 : CheckTargetLights()
	Else
		If Li5.state <> 0 then Li5.state = 0 : nPlayerLights (nCurrentPlayer,5) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT5"
End Sub
Sub Ht6_Hit()
	if bTilted then exit sub
	ObjSunlevel(22) = 1 : FlasherSun22_Timer
	PlaySoundAt SoundFXDOF("fx_target", 138, DOFPulse, DOFTargets), HT6
	if bBlackHoleMode = false then
		If Li6.state = 0 then Li6.state = 1 : nPlayerLights (nCurrentPlayer,6) = 1 : CheckTargetLights()
	Else
		If Li6.state <> 0 then Li6.state = 0 : nPlayerLights (nCurrentPlayer,6) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT6"
End Sub
Sub Ht8_Hit()
	if bTilted then exit sub
	ObjSunlevel(23) = 1 : FlasherSun23_Timer
	PlaySoundAt SoundFXDOF("fx_target", 138, DOFPulse, DOFTargets), HT8
	if bBlackHoleMode = false then
		If Li8.state = 0 then Li8.state = 1 : nPlayerLights (nCurrentPlayer,8) = 1 : CheckTargetLights()
	Else	
		If Li8.state <> 0 then Li8.state = 0 : nPlayerLights (nCurrentPlayer,8) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT8"
End Sub

Sub Ht9_Hit()
	if bTilted then exit sub
	ObjSunlevel(1) = 1 : FlasherSun1_Timer
	PlaySoundAt SoundFXDOF("fx_target", 137, DOFPulse, DOFTargets), HT9
	if bBlackHoleMode = false then
		If Li9.state = 0 then Li9.state = 1 : nPlayerLights (nCurrentPlayer,9) = 1 : CheckTargetLights()
	Else
		If Li9.state <> 0 then Li9.state = 0 : nPlayerLights (nCurrentPlayer,9) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT9"
End Sub
Sub Ht10_Hit()
	if bTilted then exit sub
	ObjSunlevel(2) = 1 : FlasherSun2_Timer
	PlaySoundAt SoundFXDOF("fx_target", 137, DOFPulse, DOFTargets), HT10
	if bBlackHoleMode = false then
		If Li10.state = 0 then Li10.state = 1 : nPlayerLights (nCurrentPlayer,10) = 1 : CheckTargetLights()
	Else
		If Li10.state <> 0 then Li10.state = 0 : nPlayerLights (nCurrentPlayer,10) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT10"
End Sub

Sub Ht7_Hit()
	if bTilted then exit sub
	ObjSunlevel(21) = 1 : FlasherSun21_Timer
	PlaySoundAt SoundFXDOF("fx_target", 135, DOFPulse, DOFTargets), HT7
	if bBlackHoleMode = false then
		If Li18.state = 0 then Li18.state = 1 : nPlayerLights (nCurrentPlayer,18) = 1 : CheckTargetLights()
	Else
		If Li18.state <> 0 then Li18.state = 0 : nPlayerLights (nCurrentPlayer,18) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT7"
End Sub

Sub Ht11_Hit()
	if bTilted then exit sub
	ObjSunlevel(20) = 1 : FlasherSun20_Timer
	PlaySoundAt SoundFXDOF("fx_target", 135, DOFPulse, DOFTargets), HT11
	if bBlackHoleMode = false then
		If Li21.state = 2 then Li21.state = 1 : nPlayerLights (nCurrentPlayer,21) = 1 : CheckTargetLights()
		If Li21.state = 0 then Li21.state = 2 : nPlayerLights (nCurrentPlayer,21) = 2 
	Else
		If Li21.state <> 0 then Li21.state = 0 : nPlayerLights (nCurrentPlayer,21) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT11"
End Sub

Sub Ht12_Hit()
	if bTilted then exit sub
	ObjSunlevel(19) = 1 : FlasherSun19_Timer
	PlaySoundAt SoundFXDOF("fx_target", 135, DOFPulse, DOFTargets), HT12
	if bBlackHoleMode = false then
		If Li22.state = 2 then Li22.state = 1 : nPlayerLights (nCurrentPlayer,22) = 1 : CheckTargetLights()
		If Li22.state = 0 then Li22.state = 2 : nPlayerLights (nCurrentPlayer,22) = 2 
	Else
		If Li22.state <> 0 then Li22.state = 0 : nPlayerLights (nCurrentPlayer,22) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT12"
End Sub

Sub Ht13_Hit()
	if bTilted then exit sub
	ObjSunlevel(24) = 1 : FlasherSun24_Timer
	PlaySoundAt SoundFXDOF("fx_target", 136, DOFPulse, DOFTargets), HT13
	if bBlackHoleMode = false then
		If Li13.state = 2 then Li13.state = 1 : nPlayerLights (nCurrentPlayer,13) = 1 : CheckTargetLights()
		If Li13.state = 0 then Li13.state = 2 : nPlayerLights (nCurrentPlayer,13) = 2 
	Else
		If Li13.state <> 0 then Li13.state = 0 : nPlayerLights (nCurrentPlayer,13) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT13"
End Sub

Sub Ht14_Hit()
	if bTilted then exit sub
	ObjSunlevel(18) = 1 : FlasherSun18_Timer
	PlaySoundAt SoundFXDOF("fx_target", 135, DOFPulse, DOFTargets), HT14
	if bBlackHoleMode = false then
		If Li14.state = 0 then Li14.state = 1 : nPlayerLights (nCurrentPlayer,14) = 1 : DOF 165,DOFPULSE :CheckTargetLights()
	Else	
		If Li14.state <> 0 then Li14.state = 0 : nPlayerLights (nCurrentPlayer,14) = 0 : DOF 165,DOFPULSE : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT14"
End Sub
Sub Ht15_Hit()
	if bTilted then exit sub
	ObjSunlevel(18) = 1 : FlasherSun18_Timer
	PlaySoundAt SoundFXDOF("fx_target", 135, DOFPulse, DOFTargets), HT15
	if bBlackHoleMode = false then
		If Li15.state = 0 then Li15.state = 1 : nPlayerLights (nCurrentPlayer,15) = 1 : DOF 165,DOFPULSE :CheckTargetLights()
	Else	
		If Li15.state <> 0 then Li15.state = 0 : nPlayerLights (nCurrentPlayer,15) = 0 : DOF 165,DOFPULSE :CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT15"
End Sub
Sub Ht16_Hit()
	if bTilted then exit sub
	ObjSunlevel(18) = 1 : FlasherSun18_Timer
	PlaySoundAt SoundFXDOF("fx_target", 135, DOFPulse, DOFTargets), HT16
	if bBlackHoleMode = false then
		If Li16.state = 0 then Li16.state = 1 : nPlayerLights (nCurrentPlayer,16) = 1 : DOF 165,DOFPULSE :CheckTargetLights()
	Else	
		If Li16.state <> 0 then Li16.state = 0 : nPlayerLights (nCurrentPlayer,16) = 0 : DOF 165,DOFPULSE :CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT16"
End Sub
Sub Ht17_Hit()
	if bTilted then exit sub
	ObjSunlevel(18) = 1 : FlasherSun18_Timer
	PlaySoundAt SoundFXDOF("fx_target", 135, DOFPulse, DOFTargets), HT17
	if bBlackHoleMode = false then
		If Li17.state = 0 then Li17.state = 1 : nPlayerLights (nCurrentPlayer,17) = 1 : DOF 165,DOFPULSE :CheckTargetLights()
	Else	
		If Li17.state <> 0 then Li17.state = 0 : nPlayerLights (nCurrentPlayer,17) = 0 : DOF 165,DOFPULSE :CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT17"
End Sub

Sub Ht20_Hit()
	if bTilted then exit sub
	ObjSunlevel(3) = 1 : FlasherSun3_Timer
	PlaySoundAt SoundFXDOF("fx_target", 136, DOFPulse, DOFTargets), HT20
	if bBlackHoleMode = false then
		If Li20.state = 0 then Li20.state = 1 : nPlayerLights (nCurrentPlayer,20) = 1 : CheckTargetLights()
	Else
		If Li20.state <> 0 then Li20.state = 0 : nPlayerLights (nCurrentPlayer,20) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT20"
End Sub

Sub Ht21_Hit()
	if bTilted then exit sub
	ObjSunlevel(4) = 1 : FlasherSun4_Timer
	PlaySoundAt SoundFXDOF("fx_target", 136, DOFPulse, DOFTargets), HT21
	if bBlackHoleMode = false then
		If Li23.state = 0 then Li23.state = 1 : nPlayerLights (nCurrentPlayer,23) = 1 : CheckTargetLights()
	Else
		If Li23.state <> 0 then Li23.state = 0 : nPlayerLights (nCurrentPlayer,23) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT21"
End Sub

Sub Ht19_Hit()
	if bTilted then exit sub
	ObjSunlevel(17) = 1 : FlasherSun17_Timer
	PlaySoundAt SoundFXDOF("fx_target", 137, DOFPulse, DOFTargets), HT19
	if bBlackHoleMode = false then
		If Li19.state = 2 then Li19.state = 1 : nPlayerLights (nCurrentPlayer,19) = 1 : CheckTargetLights()
		If Li19.state = 0 then Li19.state = 2 : nPlayerLights (nCurrentPlayer,19) = 2
	Else
		If Li19.state <> 0 then Li19.state = 0 : nPlayerLights (nCurrentPlayer,19) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT19"
End Sub

Sub Ht24_Hit() 'Extra Ball
	if bTilted then exit sub
	ObjSunlevel(16) = 1 : FlasherSun16_Timer
	PlaySoundAt SoundFXDOF("fx_target", 137, DOFPulse, DOFTargets), HT24
	If bCurrentBallIsExtraBall = false and bblackholemode = false then
		If Li24.state = 2 then Li24.state = 1 : nPlayerLights (nCurrentPlayer,24) = 1 : CheckTargetLights()
		If Li24.state = 0 then Li24.state = 2 : nPlayerLights (nCurrentPlayer,24) = 2
	else
		If Li24.state <> 0 then Li24.state = 0 : nPlayerLights (nCurrentPlayer,24) = 0 : CheckBlackHoleLights()
	end if
	nLastTargetHit = "HT24"
End Sub

Sub CheckBlackHoleLights()
	dim x,y
	addscore cBlackHoleTarget
	DOF 168, DOFPULSE '2x strobe
	playsound "SFX_Plasma",1,nTableSFXVolume/2
	for each x in LiBlackHole : y = y + x.state : next
	if y = 0 then ReadyToAwardBlackHole
	DMD2 "", cstr(y)+" TARGETS LEFT", "", 1000, UltraDmd_eNone , ""
end Sub

Sub CheckTargetLights()
	if bBlackHoleMode = true or btilted = true then exit sub
	DOF 163,DOFPULSE
	' There is a target hit, so remove Combo lights first
	LI46.State=0:LI47.state=0:LI48.state=0:LI49.state=0:LI53.state=0:LI54.state=0
	' Right Ramp
	If LI9.state = 1 and Li10.state = 1 and Li55.state = 0 Then	
		LightEffect 5 'Random
		Li55.state = 2 : nPlayerLights (nCurrentPlayer,55) = 2
		Playsound "SFX_70s",1,nTableSFXVolume
		DOF 141, DOFPULSE
	end if
	' Left Ramp
	If Li18.state = 1 and Li21.state = 1 and Li57.state = 0 Then
		LightEffect 5 'Random	
		Li57.state = 2 : nPlayerLights (nCurrentPlayer,57) = 2
		Playsound "SFX_Cloverfield",1,nTableSFXVolume
		DOF 142, DOFPULSE
	end if
	' Center Ramp
	If LI20.state = 1 and Li23.state = 1 and Li56.state = 0 Then	
		LightEffect 5 'Random
		Li56.state = 2 : nPlayerLights (nCurrentPlayer,56) = 1
		Playsound "SFX_Acid",1,nTableSFXVolume
		DOF 143, DOFPULSE
	end if
	' Right MultiBall
	If LI19.state = 1 and LI50.state = 0 Then
		LightEffect 5 'Random
		LI50.state = 2 : nPlayerLights (nCurrentPlayer,50) = 2
		PlaySOund "SFX_AlienZap",1,, nTableSFXVolume
		DMD2 "", "HIT RIGHT SHIP", "TO LOCK BALL", 2000, UltraDmd_eNone , ""
		AddSpeechToQueue "SFX_Speech_Shoot_Right_SpaceShip",2000
		DOF 144, DOFPULSE
	end if
	' Left MultiBall
	If LI22.state = 1 and LI51.state = 0 Then
		LightEffect 5 'Random
		LI51.state = 2 : nPlayerLights (nCurrentPlayer,51) = 2
		PlaySOund "SFX_AlienZap",1,nTableSFXVolume
		DMD2 "", "HIT LEFT SHIP", "TO LOCK BALL", 2000, UltraDmd_eNone , ""
		AddSpeechToQueue "SFX_Speech_Shoot_Left_SpaceShip",2000
		DOF 145, DOFPULSE
	end if
	' SHIP
	If LI14.state = 1 and LI15.state = 1 and LI16.state = 1 and LI17.state = 1 and LI58.state = 0 Then
		LightEffect 5 'Random
		LI58.state = 2 : nPlayerLights (nCurrentPlayer,58) = 2
		DMD2 "", "HIT LEFT RAMP", "PLANET", 2000, UltraDmd_eNone , ""
		AddSpeechToQueue "SFX_Speech_Hit_Left_Ramp",2000
		PlaySound "SFX_Daft",1,nTableSFXVolume
		DOF 146, DOFPULSE
	end if
	' Secret
	If LI11.state = 1 and LI12.state = 1 and LI52.state = 0 Then	
		LightEffect 5 'Random
		LI52.state = 2 : nPlayerLights (nCurrentPlayer,52) = 2
		Playsound "SFX_Plasma",1,nTableSFXVolume
		DOF 147, DOFPULSE
		DMD2 "", "WORMHOLE", "IS NOW OPEN", 2000, UltraDmd_eNone , ""
		AddSpeechToQueue "SFX_Speech_Wormhole_is_now_open",2000
	end if
	' Top Ramp
	If LI6.state = 1 and LI8.state = 1 Then
		LightEffect 5 'Random
		LI60.state = 2 : nPlayerLights (nCurrentPlayer,60) = 2
		PlaySOund "SFX_SandStone",1,nTableSFXVolume
		DOF 143, DOFPULSE
	end if
	' Extra Ball
	If LI24.state = 1 and LI7.state <> 1 and bCurrentBallIsExtraBall = false Then
		'Extra Ball
		LightEffect 9 'All Blink
		LI7.State = 1
		LI7.timerenabled = False
		bBallSaved = true
		DMD2 "", "EXTRA BALL", "", 2000, UltraDmd_eNone , ""
		AddSpeechToQueue "SFX_Speech_Extra_Ball",1200
		PlaySOund "SFX_KiWi",1,nTableSFXVolume
		DOF 149, DOFPULSE
	end if
	'KickBack
	If LI13.state = 1 and gate006.open = 0 Then
		ToggleGate006(True)
		LI61.state = 2 : nPlayerLights (nCurrentPlayer,61)=2
		LI62.state = 1 : nPlayerLights (nCurrentPlayer,62)=1
		PlaySOund "SFX_Positron",1,nTableSFXVolume		
		DMD2 "", "KICKBACK", "ACTIVATED", 2000, UltraDmd_eNone , ""
		AddSpeechToQueue "SFX_Speech_Kickback_Is_Now_Activated",2000
	end if
	'Left MagnetL
	If LI5.state = 1 and LI63.state = 0 Then
		LMagnet.MagnetOn = true
		PlaySound "SFX_Ragmachine",1,nTableSFXVolume
		LI63.state = 2 :  nPlayerLights (nCurrentPlayer,63) = 2
		DMD2 "", "LEFT MAGNET", "READY", 2000, UltraDmd_eNone , ""
	end if
	'Right Magnetr
	If LI4.state = 1 and LI64.state = 0 Then
		RMagnet.MagnetOn = true
		PlaySound "SFX_Ragmachine",1,nTableSFXVolume
		LI64.state = 2 : nPlayerLights (nCurrentPlayer,64) = 2
		DMD2 "", "RIGHT MAGNET", "READY", 2000, UltraDmd_eNone , ""
	end if
End Sub

Sub Targets_Lane_Sound_Hit(idx)
	PlaySound "SFX_Predator"+cstr(Int(Rnd*8)+1), 1 , nTableSFXVolume
	AddScore cScoreHitTarget
End Sub
Sub Targets_Sound_Hit(idx)
	PlaySound "SFX_SpaceStation"+cstr(Int(Rnd*8)+1) , 1 , nTableSFXVolume
	AddScore cScoreHitTarget
End Sub

'**********************************************************
'* TRIGGERS ***********************************************
'**********************************************************
'SkillShots & multiplier
Sub Tr1_Hit()
	if btilted then exit Sub
	addscore cScoreMir
	If LI41.state <> 0 Then Call AwardSkillShot
	if LI1.state = 0 then li1.state = 1 : nPlayerLights(nCurrentPlayer,1)=1 : Call CheckAndAwardBonusMultiplier
	nLastTargetHit = "TR1"
End Sub
Sub Tr2_Hit()
	if btilted then exit Sub
	addscore cScoreMir
	If LI42.state <> 0 Then Call AwardSkillShot
	if LI2.state = 0 then li2.state = 1 : nPlayerLights(nCurrentPlayer,2)=1 : Call CheckAndAwardBonusMultiplier
	nLastTargetHit = "TR2"
End Sub
Sub Tr3_Hit()
	if btilted then exit Sub
	addscore cScoreMir
	If LI43.state <> 0 Then Call AwardSkillShot
	if LI3.state = 0 then li3.state = 1 : nPlayerLights(nCurrentPlayer,3)=1 : Call CheckAndAwardBonusMultiplier
	nLastTargetHit = "TR3"
End Sub
Sub Tr4_Hit()
	if bTilted then exit Sub
	ObjSunlevel(9) = 2 : FlasherSun9_Timer
	nLastTargetHit = "TR4"
End Sub
Sub Tr7_Hit() ' Trigger Earth
	if bTilted then exit Sub
	PlaySound "SFX_MeanFall" , 1 , nTableSFXVolume
	ObjSunlevel(10) = 3 : FlasherSun10_Timer
	If 	LI45.state = 2 then 'We are in MultiBall
		DMD2 "", "JACKPOT", cScoreJackpot, 2000, UltraDMD_eZoom , ""
		AddSpeechToQueue "SFX_Speech_Jackpot",1000
		AddScore cScoreJackpot
	Else	
		DMD2 "", cScoreEarth, "", 2000, UltraDMD_eZoom , ""
		AddScore cScoreEarth
	end if
	nLastTargetHit = "TR7"
End Sub
Sub Tr18_Hit()
	if bTilted then exit sub
	nLastTargetHit = "TR18"
	DOF 121, DOFPULSE
	playsound "SFX_Stars" , 1 , nTableSFXVolume
	Call ActivateComboLights
	Call CheckAndAwardCombo("TR18")
End Sub
Sub Tr19_Hit()
	if bTilted then exit Sub
	nLastTargetHit = "TR19"
	if ucase(nLastTargetHit) <> "TR18" Then
		DOF 122, DOFPULSE
		playsound "SFX_Stars" , 1 , nTableSFXVolume
		Call CheckAndAwardCombo("TR19")
	end if
Call ActivateComboLights
End Sub
Sub TR5_Hit() 'End SkillShot
	if bTilted then exit Sub
	If LI41.state<>0 or LI42.state<>0 or LI43.state<>0 then Call EndSkillShot
End Sub

'**********************************************************
'* TRIGGERS ON RAMPS **************************************
'**********************************************************
Sub Tr12_Hit()
	if bTilted then exit sub
	PlaySound "SFX_Scream" , 1 , nTableSFXVolume
	If LI57.state <> 0 Then
		LightEffect 7
		LI57.state = 0 : nPlayerLights (nCurrentPlayer,57)=0
		LI18.state = 0 : nPlayerLights (nCurrentPlayer,18)=0
		LI21.state = 0 : nPlayerLights (nCurrentPlayer,21)=0
		addscore cScoreRampBonus
	Else
		addscore cScoreRamp
	end if	
	If LI58.state = 2 Then	
		' Award a planet
		Call AwardPlanet(True)
	end if
	Call CheckAndAwardCombo("TR12")
	nLastTargetHit = "TR12"
End Sub
Sub Tr13_Hit()
	ObjSunlevel(11) = 1 : FlasherSun11_Timer
	PlaySound "SFX_Whisper" , 1 , nTableSFXVolume
	DOF 140,DOFPULSE
	nLastTargetHit = "TR13"
	Call ActivateComboLights
End Sub

Sub Tr14_Hit()
	if btilted then exit sub
	PlaySound "SFX_Scream" , 1 , nTableSFXVolume
	If LI60.state <> 0 Then
		LightEffect 7
		LI60.state = 0 : nPlayerLights (nCurrentPlayer,60)=0
		LI6.state = 0 : nPlayerLights (nCurrentPlayer,6)=0
		LI8.state = 0 : nPlayerLights (nCurrentPlayer,8)=0
		addscore cScoreRampBonus
		DMD2 "", "RAMP BONUS", cScoreRampBonus, 2000, UltraDMD_eZoom , ""
	Else
		addscore cScoreRamp
	end if
	Call CheckAndAwardCombo("TR14")
	nLastTargetHit = "TR14"
End Sub
Sub Tr15_Hit() 'Also Starts Multiball
	if btilted then exit sub
	ObjSunlevel(12) = 1 : FlasherSun12_Timer
	PlaySound "SFX_Whisper" , 1 , nTableSFXVolume
	DOF 140,DOFPULSE
	nLastTargetHit = "TR15"
	Call ActivateComboLights
	if Li50.state = 1 and Li51.state = 1 and bReadyForBlackHoleMode=false and bBlackHoleMode=false and bReadyToAwardBlackHole = false Then
		Call StartMultiBall
	end if
	if bReadyForBlackHoleMode=true Then
		Call StartBlackHoleMode
	end if
	if bReadyToAwardBlackHole=true Then
		Call CollectBlackHoleAward
	end if

End Sub
Sub Tr16_Hit()
	if btilted then exit sub
	PlaySound "SFX_Scream" , 1 , nTableSFXVolume
	If LI56.state <> 0 Then
		LightEffect 7
		LI56.state = 0 : nPlayerLights (nCurrentPlayer,56)=0
		LI20.state = 0 : nPlayerLights (nCurrentPlayer,20)=0
		LI23.state = 0 : nPlayerLights (nCurrentPlayer,23)=0
		addscore cScoreRampBonus
		DMD2 "", "RAMP BONUS", cScoreRampBonus, 2000, UltraDMD_eZoom , ""
	Else
		addscore cScoreRamp
	end if
	Call CheckAndAwardCombo("TR16")
	nLastTargetHit = "TR16"
End Sub
Sub Tr17_Hit()
	if btilted then exit sub
	PlaySound "SFX_Scream" , 1 , nTableSFXVolume
	If LI55.state <> 0 Then
		LightEffect 8
		LI55.state = 0 : nPlayerLights (nCurrentPlayer,55)=0
		LI9.state = 0 : nPlayerLights (nCurrentPlayer,9)=0
		LI10.state = 0 : nPlayerLights (nCurrentPlayer,10)=0
		addscore cScoreRampBonus
		DMD2 "", "RAMP BONUS", cScoreRampBonus, 2000, UltraDMD_eZoom , ""
	Else
		addscore cScoreRamp
	end if
	Call CheckAndAwardCombo("TR17")
	nLastTargetHit = "TR17"
End Sub

'**********************************************************
'* GATES **************************************************
'**********************************************************
Sub ToggleGate002(aOpen) 'GateOnRamp
	if bDebugGeneral = true then debug.print "Sub ToggleGate002 " & aOpen
	If aOpen = True then
		Gate002.open = 1
		PlaySoundAt SoundFXDOF("popper_ball", 151, DOFPulse, DOFContactors), Gate002
	else
		Gate002.open = 0
		PlaySoundAt SoundFXDOF("popper_ball", 151, DOFPulse, DOFContactors), Gate002
	end if
End Sub
Sub ToggleGate005(aOpen)
	if bDebugGeneral = true then debug.print "Sub ToggleGate005 " & aOpen
	If aOpen = True then
		Gate005.open = 1
		PlaySoundAt SoundFXDOF("popper_ball", 154, DOFPulse, DOFContactors), Gate005
	else
		Gate005.open = 0
		PlaySoundAt SoundFXDOF("popper_ball", 154, DOFPulse, DOFContactors), Gate005
	end if
End Sub
Sub ToggleGate006(aOpen) 'Kickback
	if bDebugGeneral = true then debug.print "Sub ToggleGate006 " & aOpen
	If aOpen = True then
		Gate006.open = 1
		PlaySoundAt SoundFXDOF("popper_ball", 155, DOFPulse, DOFContactors), Gate006
	else
		Gate006.open = 0
		PlaySoundAt SoundFXDOF("popper_ball", 155, DOFPulse, DOFContactors), Gate006
	end if
End Sub
Sub ToggleGate007(aOpen) 'Upper Right (skillshot Start)
	if bDebugGeneral = true then debug.print "Sub ToggleGate007 " & aOpen
	If aOpen = True then
		Gate007.open = 1
		PlaySoundAt SoundFXDOF("popper_ball", 156, DOFPulse, DOFContactors), Gate007
	else
		Gate007.open = 0
		PlaySoundAt SoundFXDOF("popper_ball", 156, DOFPulse, DOFContactors), Gate007
	end if
End Sub

'**********************************************************
'* SPINNERS ***********************************************
'**********************************************************
Sub Spinner001_spin()
	'Li71.duration 1,25,0
	ObjSunlevel(27) = 2 : FlasherSun27_Timer
	'playsound "SFX_Spinner",1,nTableSFXVolume/2
	playsound "FX_Sample04",1,nTableSFXVolume/2
	PlaySound "fx_spinner", 0, .25, AudioPan(Spinner001), 0.25, 0, 0, 1, AudioFade(Spinner001)
	DOF 166, DOFPULSE
	B2SLight rndnum(31,39),100
	AddScore cScoreSpinner
End Sub
Sub Spinner002_spin()
	ObjSunlevel(28) = 2 : FlasherSun28_Timer
	'Li72.duration 1,25,0
	'playsound "SFX_Spinner",1,nTableSFXVolume/2
	playsound "FX_Sample04",1,nTableSFXVolume/2
	PlaySound "fx_spinner", 0, .25, AudioPan(Spinner001), 0.25, 0, 0, 1, AudioFade(Spinner002)
	DOF 167, DOFPULSE
	B2SLight rndnum(31,39),100
	AddScore cScoreSpinner
End Sub
Sub Spinner003_Spin()
	'playsound "SFX_Spinner",1,nTableSFXVolume/2
	playsound "FX_Sample04",1,nTableSFXVolume/2
	PlaySound "fx_spinner", 0, .25, AudioPan(Spinner003), 0.25, 0, 0, 1, AudioFade(Spinner003)
	DOF 166, DOFPULSE
	B2SLight rndnum(31,39),100
	AddScore cScoreSpinner
	With PrimitiveEarth :.RotY = .RotY - 5 : end with	
End Sub
'**********************************************************
'* MULTIBALL **********************************************
'**********************************************************

Sub CheckMultiBallReady
	if Li50.state = 1 and Li51.state = 1 Then
		' Ready For Multiball
		ToggleGate002(False) ' Close the gate
		PlaySound "SFX_Pandora",1,nTableSFXVolume
		LI59.state = 2 : nPlayerLights (nCurrentPlayer,59)=2
		DMD2 "", "HIT RAMP FOR", "MULTIBALL", 2000, UltraDMD_eFade , ""
		AddSpeechToQueue "SFX_Speech_Hit_Center_Ramp",2000
		strSongToPlay = "Trk_SpaceRampC"
		playsong strSongToPlay,1
	end if
End Sub

Sub StartMultiBall
	' Start Multiball
	bMultiBallMode = true
	LI59.state = 0 : nPlayerLights (nCurrentPlayer,59)=0
	LI19.state = 0 : nPlayerLights (nCurrentPlayer,19)=0
	LI21.state = 0 : nPlayerLights (nCurrentPlayer,21)=0
	LI22.state = 0 : nPlayerLights (nCurrentPlayer,22)=0
	LI50.state = 0 : nPlayerLights (nCurrentPlayer,50)=0
	LI51.state = 0 : nPlayerLights (nCurrentPlayer,51)=0
	LI45.state = 2 : nPLayerLights (nCurrentPlayer,45)=2
	ChangeGI red
	RightRampColor("RampYellow")
	TopRampColor("RampYellow")
	LeftRampColor("RampYellow")
	lighteffect 4
	DOF 152, DOFON ' Beacon!
	DOF 153, DOFPULSE
	PLaySound "SFX_Stolen",1,nTableSFXVolume
	DMD2 "", "MULTIBALL !", "", 1500, UltraDMD_eZoom , ""
	DMD2 "", "MULTIBALL !", "", 1500, UltraDMD_eZoom , ""
	DMD2 "", "MULTIBALL !", "", 1500, UltraDMD_eZoom , ""
	AddSpeechToQueue "SFX_Speech_Initiating_Multiball",5000
	AddSpeechToQueue "SFX_Speech_Aim_For_The_Jackpot",2000
	strSongToPlay = "Trk_SpaceRampB"
	playsong strSongToPlay,0
	vpmtimer.addtimer 5000, "ToggleGate002(True) '"
	vpmtimer.addtimer 2500, "EnableMir(True) '"
	vpmtimer.addtimer 3500, "AddMultiBalls 2 '"
	vpmtimer.addtimer 1500, "ToggleGate005(True) '"
	vpmtimer.addtimer 500, "StartStopMilkyWay True '"
End Sub

Sub StopMultiBall
	bMultiBallMode = false
	ChangeGi white
	RightRampColor("RampRed")
	TopRampColor("RampBlue")
	LeftRampColor("RampGreen")
	DOF 152, DOFOFF 'Beacon!
	LI45.state = 0 : nPLayerLights (nCurrentPlayer,45)=0
	strSongToPlay = "Trk_SpaceRampA"
	playsong strSongToPlay,1
	EnableMir(False)
	StartStopMilkyWay False
	ToggleGate005(False)
	PlaySound "SFX_KillerDrone" , -1 , (nTableSFXVolume/16)
End Sub

'**********************************************************
'* BLACKHOLE MODE *****************************************
'**********************************************************
Sub StartBlackHoleMode()
	' First, put the table in a sort OFF mode
	bBlackHoleMode = True
	bReadyForBlackHoleMode = False
	GiOff
	aLightsOff()
	aArrowsOff()
	aPlanetsOff()
	ChangePlanetLights False
	ChangeBackLights False
	LI101.state = 0 : LI102.state = 0
	TimerPlanetAnimation.enabled = false
	RightRampColor("RampOff")
	TopRampColor("RampOff")
	LeftRampColor("RampOff")
	vpmtimer.addtimer 8000, "AddSpeechToQueue ""SFX_Speech_You_Activated_The_Black_Hole"",4000 '"
	vpmtimer.addtimer 12000, "AddSpeechToQueue ""SFX_Speech_Hit_All_Targets_1000000"",4000 '"
	DMD2 "", "...", "", 4000, UltraDMD_eFade , ""
	DMD2 "", "ENTERING", "BLACK HOLE", 1000, UltraDMD_eFade , ""
	DMD2 "", "DESTROY TARGETS", "", 1000, UltraDMD_eScrollDown , ""
	DMD2 "", "TO OBTAIN", "", 1000, UltraDMD_eScrollDown , ""
	DMD2 "", "1.000.000", "", 2000, UltraDMD_eFade , ""
	StopSong
	playsound "SFX_TheEnd",1,nTableSFXVolume
	strSongToPlay = "Trk_SpaceRampB"
	'playsong strSongToPlay,0
	'
	' Now start up table step by step
	vpmtimer.addtimer 4000, "LightEffect 4 '"
	vpmtimer.addtimer 4000, "playsong ""Trk_SpaceRampI"",0 '"
	vpmtimer.addtimer 5000, "TimerPlanetAnimation.enabled = true '"
	vpmtimer.addtimer 6000, "LI101.state = 1 '"
	vpmtimer.addtimer 6000, "LI102.state = 1 '"
	vpmtimer.addtimer 7000, "ChangeBackLights True '"
	vpmtimer.addtimer 8000, "RightRampColor(""RampPurple"") '"	
	vpmtimer.addtimer 8000, "TopRampColor(""RampPurple"") '"	
	vpmtimer.addtimer 8000, "LeftRampColor(""RampPurple"") '"	
	vpmtimer.addtimer 9000, "ChangeGi purple '"
	vpmtimer.addtimer 9000, "GiOn '"
	vpmtimer.addtimer 13000, "ToggleGate002(True) '"
	vpmtimer.addtimer 10000, "EnableMir(True) '"
	vpmtimer.addtimer 12000, "AddMultiBalls 2 '"
	vpmtimer.addtimer 11000, "ToggleGate005(True) '"
	vpmtimer.addtimer 10000, "StartStopMilkyWay True '"
	vpmtimer.addtimer 10000, "ChangeBlackHoleLights True '"
End Sub

Sub StopBlackHoleMode()
	'bBlackholemode = false
	ChangeGi white
	RightRampColor("RampRed")
	TopRampColor("RampBlue")
	LeftRampColor("RampGreen")
	DOF 152, DOFOFF 'Beacon!
	LI45.state = 0 : nPLayerLights (nCurrentPlayer,45)=0
	if nCurrentBall = 1 Then
		strSongToPlay = "Trk_SpaceRampA"
		playsong strSongToPlay,0
	end If
	if nCurrentBall = 2 Then
		strSongToPlay = "Trk_SpaceRampD"
		playsong strSongToPlay,0
	end If
	if nCurrentBall = 3 Then
		strSongToPlay = "Trk_SpaceRampE"
		playsong strSongToPlay,0
	end If
	EnableMir(False)
	StartStopMilkyWay False
	ToggleGate005(False)
	PlaySound "SFX_KillerDrone" , -1 , (nTableSFXVolume/16)
End Sub

Sub ReadyToAwardBlackHole()
	ToggleGate002(False) ' Close the gate
	PlaySound "SFX_Pandora",1,nTableSFXVolume
	LI59.state = 2 : nPlayerLights (nCurrentPlayer,59)=2
	DMD2 "", "HIT RAMP FOR", "BLACK HOLE AWARD", 2000, UltraDMD_eFade , ""
	AddSpeechToQueue "SFX_Speech_Hit_Center_Ramp_To_Collect_Black_Hole_Award",4000
	bReadyToAwardBlackHole = true
End Sub

Sub CollectBlackHoleAward()
	'bReadyToAwardBlackHole = false
	LI59.state = 0 : nPlayerLights (nCurrentPlayer,59)=2
	DMD2 "AWARD", "1000000", "", 1000, UltraDMD_eZoom , ""
	AddSpeechToQueue "SFX_Speech_Black_Hole_Finished",4000
	vpmtimer.addtimer 3000, "AwardSpecial '"
	vpmtimer.addtimer 5000, "AwardSpecial '"
	vpmtimer.addtimer 8000, "Addscore 1000000 '"
	dim b
	For b = 0 to 80 : nPlayerLights(nCurrentPlayer,b) = 0 : Next
	vpmtimer.addtimer 6000, "StopBlackHoleMode '"
	vpmtimer.addtimer 8000, "ToggleGate002(True) '"
End Sub

'**********************************************************
'* SPINDISC ***********************************************
'**********************************************************

Sub StartStopMilkyWay(bMode)
	If bMode = True Then
		spinner.MotorOn = true
		spinner2.MotorOn = true
		PlayLoopSoundAtVol "FX_RotatingDisc", nTableFxVolume, PrimitiveMilkyWay1
		PlayLoopSoundAtVol "FX_RotatingDisc2", nTableFxVolume, PrimitiveMilkyWay2
		bLi1.state = 1
		bLi7.state = 1
		TimerMilkyWay1.enabled = true
	Else
		spinner.MotorOn = False
		spinner2.MotorOn = False
		StopSound "FX_RotatingDisc"
		StopSound "FX_RotatingDisc2"
		bLi1.state = 0
		bLi7.state = 0
		TimerMilkyWay1.enabled = false
	end if
End Sub

dim spinner
Set spinner = New cvpmTurntable
With spinner
	.InitTurntable spindisc , 50
	.SpinDown = 5
	.SpinUp = 15
	.SpinCW = -1
	.MaxSpeed = 50
	.CreateEvents "spinner"
End With

dim spinner2
Set spinner2 = New cvpmTurntable
With spinner2
	.InitTurntable spindisc2 , 50
	.SpinDown = 5
	.SpinUp = 15
	.SpinCW = 0
	.MaxSpeed = 100
	.CreateEvents "spinner2"
End With

Sub TimerMilkyWay1_Timer()
	PrimitiveMilkyWay1.roty = PrimitiveMilkyWay1.roty + 3
	PrimitiveMilkyWay2.roty = PrimitiveMilkyWay2.roty - 6
End Sub

'**********************************************************
'* MAGNETS ************************************************
'**********************************************************

dim RMagnet : set RMagnet = New cvpmMagnet
with RMagnet : .InitMagnet MagnetR , 14 : end With

dim LMagnet : set LMagnet = New cvpmMagnet
with LMagnet : .InitMagnet MagnetL , 14 : end With

Sub MagnetR_Hit()
	If RMagnet.MagnetOn = true then
		LI64.state = 1 : nPlayerLights (nCurrentPlayer,64) = 1
		RMagnet.AddBall activeball
		if bDebugGeneral then debug.print "Magnet Right Hit"
		playsoundat "fx_magnet" , LI64
		vpmtimer.addtimer 10000, "KillRightMagnet '"
	End if
End Sub

Sub KillRightMagnet()
	RMagnet.MagnetOn = false
	LI64.state = 0 : nPlayerLights (nCurrentPlayer,64)=0
	LI4.state = 0 : nPlayerLights (nCurrentPlayer,4)=0
	stopsound "fx_magnet"
End Sub

Sub MagnetR_UnHit()
'	LI64.state = 0 : nPlayerLights (nCurrentPlayer,64)=0
'	LI4.state = 0 : nPlayerLights (nCurrentPlayer,4)=0
	RMagnet.RemoveBall activeball
	if bDebugGeneral then debug.print "Magnet Right UnHit"
	stopsound "fx_magnet"
End Sub

Sub MagnetL_Hit()
	If LMagnet.MagnetOn = true then
		LI63.state = 1 : nPlayerLights (nCurrentPlayer,63) = 1
		LMagnet.AddBall activeball
		if bDebugGeneral then debug.print "Magnet Left Hit"
		playsoundat "fx_magnet" , LI63
		vpmtimer.addtimer 10000, "KillLeftMagnet '"
	end if
End Sub

Sub KillLeftMagnet()
	LMagnet.MagnetOn = false
	LI63.state = 0 : nPlayerLights (nCurrentPlayer,63)=0
	LI5.state = 0 : nPlayerLights (nCurrentPlayer,5)=0
	stopsound "fx_magnet"
End Sub

Sub MagnetL_UnHit()
'	LI63.state = 0 : nPlayerLights (nCurrentPlayer,63)=0
'	LI5.state = 0 : nPlayerLights (nCurrentPlayer,5)=0
	LMagnet.RemoveBall activeball
	if bDebugGeneral then debug.print "Magnet Left UnHit"
	stopsound "fx_magnet"
End Sub

'**********************************************************
'* PLANETS & MIR ******************************************
'**********************************************************

Sub TimerPlanetAnimation_Timer()
	With PrimitiveSun : .RotX = .RotX + 0.3 : .RotY = .RotY + 0.4 : .RotZ = .RotZ + 0.5 : End With
	With PrimitiveEarth :.RotY = .RotY - 0.5 : end with
	With PrimitiveRocket1 : .RotY = .RotY + 0.1 : End With
	With PrimitiveMir
		if bRotateMir = true then
			.RotY = .RotY - 1
			If .RotY = (nMirBaseYPosition-360) then .RotY = nMirBaseYPosition
		Else
			If .RotY = (nMirBaseYPosition) then 
				' Do nothing, hang in there
			Else
				.RotY = .RotY - 1
				If .RotY = (nMirBaseYPosition-360) then 
					.RotY = nMirBaseYPosition
					if bMultiBallMode = true then AddSpeechToQueue "SFX_Speech_Aim_For_The_Jackpot",2000
					StopSound "SFX_KillerDrone"
				end if
			end if
		end if	
	End With
End Sub

Sub EnableMir(aState)
	If aState = True Then
		bRotateMir = True	
		PlaySound "SFX_KillerDrone" , 5 , (nTableSFXVolume/16)
	Else
		bRotateMir = False
	end if
End Sub


'**********************************************************
'* SPACESHIPS *********************************************
'**********************************************************

Sub TimerShakerShip1_Timer()
	PrimitiveSpaceShip1.rotx = 5 - rndnum(1,10):PrimitiveSpaceShip1.roty = 5 - rndnum(1,10):PrimitiveSpaceShip1.rotz = 5 - rndnum(1,10)
	B2SLight rndnum(31,39),100
end sub

Sub TimerShakerShip2_Timer()
	PrimitiveSpaceShip2.rotx = 5 - rndnum(1,10):PrimitiveSpaceShip2.roty = 5 - rndnum(1,10):PrimitiveSpaceShip2.rotz = 5 - rndnum(1,10)
	B2SLight rndnum(31,39),100
end sub

Sub AttractMode(aState)
	If aState = true Then
		bPlayerHasStartedGame = false
		GIOverhead.state = 0
		nAttractSteps=0:nAttractSteps2=0:nAttractSteps3=0:nAttractSteps4=0:nAttractSteps5=0:nAttractDMD=0
		DMDFlush
		TimerDMDAttract.enabled = True
		TimerAttract.enabled = True
		TimerAttractSteps.enabled = True
	Else
		GIOverhead.state = 1
		TimerAttract.enabled = false
		TimerAttractSteps.enabled = false	
		TimerDMDAttract.enabled = False
		LightSeqArrowLights.StopPlay
		LightSeqRampRunner.StopPlay
		RightRampColor("RampRed")
		TopRampColor("RampBlue")
		LeftRampColor("RampGreen")
		DMDFlush
	end if
End Sub

'**********************************************************
'* ATTRACT LIGHTS *****************************************
'**********************************************************

Dim nAttractSteps
Dim nAttractSteps2
Dim nAttractSteps3
Dim nAttractSteps4
Dim nAttractSteps5
Dim nAttractDMD

Sub TimerAttract_Timer()
	dim a,b,c,d
	for each a in LIAttract : a.state = 0 : Next
	for each a in LiPlanets : a.state = 0 : next

	d = RndNum(31,39)
	B2SLight d,100

	Select Case nAttractSteps
		case 1
			Li31.state = 1
			B2SLight 1,100
			Li14.state = 1
			Li25.state = 1
			Li1.state = 1
		case 2
			Li32.state = 1
			B2SLight 2,100
			Li15.state = 1
			Li26.state = 1
		case 3
			Li33.state = 1
			B2SLight 3,100
			Li16.state = 1
			Li27.state = 1
			Li22.state = 1
			Li2.state = 1
		case 4
			Li34.state = 1
			B2SLight 4,100
			Li17.state = 1
			Li28.state = 1
		case 5
			Li35.state = 1
			B2SLight 5,100
			Li17.state = 1
			Li3.state =1
		case 6
			Li36.state = 1
			B2SLight 6,100
			Li16.state = 1
			Li25.state = 1
			Li6.state = 1
		case 7
			Li37.state = 1
			B2SLight 7,100
			Li15.state = 1
			Li26.state = 1
			Li21.state = 1
			Li8.state =1
		case 8
			Li38.state = 1
			B2SLight 8,100
			Li14.state = 1
			Li27.state = 1
			Li9.state = 1
		case 9
			Li39.state = 1
			B2SLight 9,100
			Li28.state = 1
			Li10.state = 1
		case 10
			Li40.state = 1
			B2SLight 10,100
			b = RndNum(1,8)
			select case b
				case 1
					Objlevel(1) = 2 : FlasherFlash1_Timer
				case 2
					Objlevel(2) = 2 : FlasherFlash2_Timer
				case 3
					Objlevel(3) = 2 : FlasherFlash3_Timer
				case 4
					Objlevel(4) = 0.75 : FlasherFlash4_Timer
			end select
			B2SLight RndNum(21,27),1000
	end select

	Select Case int(nAttractSteps2+0.5)
		case 1
			Li11.state = 1
			Li18.state = 1
			Li20.state = 1
			Li4.state = 1
			LI62.state = 1
			LI64.state = 1
		case 2
			Li12.State = 1
			Li19.state = 1
			Li23.state = 1
			Li5.state = 1
			Li63.state = 1
	End Select
	
	Select Case Int(nAttractSteps3+0.5)
		case 1
			li24.state = 1
			Li7.state = 1
		case 2
			Li13.state = 1
	end select

	If nAttractSteps4 = 10 Then	
		LightSeqArrowLights.play SeqUpOn,50
		LightSeqArrowLights.play SeqDownOn,50
		LightSeqArrowLights.play SeqClockLeftOn,180,3
		LightSeqRampRunner.play SeqCircleOutOn,15,3,100
	end if

	If nAttractSteps4 = 400 then 
		PlaySound "SFX_HorrorMovie" , 1 , nTableSFXVolume
		DOF 149, DOFPULSE
	end if

	If nAttractSteps4 = 100 or nAttractSteps4 = 200 or nAttractSteps4 = 300 or nAttractSteps4 = 400 Then
		c = RndNum(1,10)
		select case c
			case 1
				RightRampColor("RampYellow")
			case 2
				RightRampColor("RampRed")
			case 3
				TopRampColor("RampWhite")
			case 4
				TopRampColor("RampBlue")
			case 5
				LeftRampColor("RampGreen")
			case 6
				LeftRampColor("RampPurple")
			case Else
				RightRampColor("RampOff")
				TopRampColor("RampOff")
				LeftRampColor("RampOff")
		end select
	end if

End Sub

Sub TimerDMDAttract_Timer()
	nAttractDMD=nAttractDMD+1

	Select Case nAttractDMD
		Case 1
			DMD2 "", "SUPERED", "", 2000, UltraDMD_eFade , ""
			DOF 162, DOFPULSE
		Case 3 
			DMD2 "", "PRESENTS", "", 2000, UltraDMD_eFade , ""
			DOF 163, DOFPULSE
		Case 5 
			DMD2 "", "SPACERAMP", "", 6000, UltraDMD_eFade , ""
			DOF 161, DOFPULSE
		Case 12 
			DMD2 "", "HIGH SCORES", "", 2000, UltraDMD_eFade , ""
		Case 14 
			DMD2 "", "1st - "+HighScoreName(0), cstr(HighScore(0)), 2000, UltraDMD_eScrollLeft , ""
			DOF 157, DOFPULSE
		Case 18 
			DMD2 "", "2nd - "+HighScoreName(1), cstr(HighScore(1)), 2000, UltraDMD_eScrollLeft , ""
		Case 22 
			DMD2 "", "3rd - "+HighScoreName(2), cstr(HighScore(2)), 2000, UltraDMD_eScrollLeft , ""
		Case 26 
			DMD2 "", "4th - "+HighScoreName(3), cstr(HighScore(3)), 2000, UltraDMD_eScrollLeft , ""
		Case 30 
			DMD2 "", "Games Played :", cstr(TotalGamesPlayed), 2000, UltraDMD_eScrollLeft , ""
		Case 34 
			dmdflush
			nAttractDMD=0
	end select
End Sub

Sub TimerAttractSteps_Timer() '50ms
	nAttractSteps = nAttractSteps + 1
	nAttractSteps2 = nAttractSteps2 + 0.5
	nAttractSteps3 = nAttractSteps3 + 0.2
	nAttractSteps4 = nAttractSteps4 + 1
	if nAttractSteps = 11 then nAttractSteps = 0
	if nAttractSteps2 >2 then nAttractSteps2 = 0
	if nAttractSteps3 >2 then nAttractSteps3 = 0
	if nAttractSteps4 >400 then nAttractSteps4 = 0
End Sub

'**********************************************************
'* PLANET AWARDS ******************************************
'**********************************************************

Sub AwardPlanet(bToggle)
	If bToggle = true then 'Sub is called from ramp pass
		addscore cscoreplanet * nPlanets(nCurrentPlayer)
		LI14.state = 0 : nPlayerLights (nCurrentPlayer,14) = 0
		LI15.state = 0 : nPlayerLights (nCurrentPlayer,15) = 0
		LI16.state = 0 : nPlayerLights (nCurrentPlayer,16) = 0
		LI17.state = 0 : nPlayerLights (nCurrentPlayer,17) = 0
		LI58.state = 0 : nPlayerLights (nCurrentPlayer,58) = 0
	end if
	If Li31.state = 0 Then
		Li31.state = 1
		nPlayerLights (nCurrentPlayer,31) = 1
		nPlanets(nCurrentPlayer) = 1
		B2SLightOnOff 1,1
		ElseIf Li32.state = 0 Then
		Li32.state = 1
		nPlayerLights (nCurrentPlayer,32) = 1
		nPlanets(nCurrentPlayer) = 2
		B2SLightOnOff 2,1
		ElseIf Li33.state = 0 Then
		Li33.state = 1
		nPlayerLights (nCurrentPlayer,33) = 1
		nPlanets(nCurrentPlayer) = 3
		B2SLightOnOff 3,1
		ElseIf Li34.state = 0 Then
		Li34.state = 1
		nPlayerLights (nCurrentPlayer,34) = 1
		nPlanets(nCurrentPlayer) = 4
		B2SLightOnOff 4,1
		ElseIf Li35.state = 0 Then
		Li35.state = 1
		nPlayerLights (nCurrentPlayer,35) = 1
		nPlanets(nCurrentPlayer) = 5
		B2SLightOnOff 5,1
		ElseIf Li36.state = 0 Then
		Li36.state = 1
		nPlayerLights (nCurrentPlayer,36) = 1
		nPlanets(nCurrentPlayer) = 6
		B2SLightOnOff 6,1
		ElseIf Li37.state = 0 Then
		Li37.state = 1
		nPlayerLights (nCurrentPlayer,37) = 1
		nPlanets(nCurrentPlayer) = 7
		B2SLightOnOff 7,1
		ElseIf Li38.state = 0 Then
		Li38.state = 1
		nPlayerLights (nCurrentPlayer,38) = 1
		nPlanets(nCurrentPlayer) = 8
		B2SLightOnOff 8,1
		ElseIf Li33.state = 0 Then
		Li39.state = 1
		nPlayerLights (nCurrentPlayer,39) = 1
		nPlanets(nCurrentPlayer) = 9
		B2SLightOnOff 9,1
		ElseIf Li40.state = 0 Then
		Li40.state = 1
		nPlayerLights (nCurrentPlayer,40) = 1
		nPlanets(nCurrentPlayer) = 10
		B2SLightOnOff 10,1
	else
		ToggleGate002(False) ' Close the gate
		PlaySound "SFX_Pandora",1,nTableSFXVolume
		LI59.state = 2 : nPlayerLights (nCurrentPlayer,59)=2
		DMD2 "", "HIT RAMP FOR", "BLACK HOLE", 2000, UltraDMD_eFade , ""
		AddSpeechToQueue "SFX_Speech_Hit_Center_Ramp_Black_Hole",4000
		bReadyForBlackHoleMode = true
	end If
	DOF 148, DOFPULSE
	PlaySound "SFX_WaveLength",1,nTableSFXVolume
	DMD2 "", cstr(nPlanets(nCurrentPlayer))+" PLANET(S)", "", 2000, UltraDmd_eNone , ""
	AddSpeechToQueue "SFX_Speech_Planet_Discovered",1500
End Sub

'**********************************************************
'* COMBO AWARDS *******************************************
'**********************************************************

Sub CheckAndAwardCombo(nRampHit)
	'Li48-Tr12
	'LI54-Tr18
	'LI47-Tr16
	'LI53-Tr14
	'LI46-Tr19
	'LI49-TR17
	Select case ucase(nRampHit)
	case "TR12"
		if LI48.state=1 then 
			call AwardCombo
		end if
	case "TR18"
		if LI54.state=1 then 
			call AwardCombo
		end if
	case "TR16"
		if LI47.state=1 then 
			call AwardCombo
		end if
	case "TR14"
		if LI53.state=1 then 
			call AwardCombo
		end if
	case "TR19"
		if LI46.state=1 then 
			call AwardCombo
		end if
	case "TR17"
		if LI49.state=1 then 
			call AwardCombo
		end if
	End Select
	LI46.State=0:LI47.state=0:LI48.state=0:LI49.state=0:LI53.state=0:LI54.state=0
End Sub

Sub AwardCombo()
	if bDebugGeneral = true then debug.print "Sub AwardCombo()"
	AddSpeechToQueue "SFX_Speech_Combo",1000
	addscore cScoreCombo
	nCombos(nCurrentPlayer)=nCombos(nCurrentPlayer)+1
	DMD2 "", "COMBO "+cstr(nCombos(nCurrentPlayer)), "", 2000, UltraDMD_eScrollLeft , ""
	PLaySOund "SFX_Faulty",1,nTableSFXVolume
	DOF 164, DOFPULSE
	If (nCombos(nCurrentPlayer) / nComboBonus) = int((nCombos(nCurrentPlayer) / nComboBonus)+0.5) and nCombos(nCurrentPlayer) > 0 Then	
		bReadyForComboBonus = True
		'ChangeGi blue
		playsong "Trk_SpaceRampI",1
		AddSpeechToQueue "SFX_Speech_Aim_For_The_Secret_Galaxy",4000
		DMD2 "", "AIM FOR THE", "SECRET GALAXY", 2000, UltraDmd_eNone , ""
		DMD2 "", "TO COLLECT YOUR", "COMBO BONUS", 2000, UltraDmd_eNone , ""
	end if	
End Sub

Sub ActivateComboLights()
	if bDebugGeneral = true then debug.print "Sub ActivateComboLights()"
	LI46.State=0:LI47.state=0:LI48.state=0:LI49.state=0:LI53.state=0:LI54.state=0
	Select case ucase(nLastTargetHit)
		case "TR13"
			LI46.state = 1 : LI47.state = 1 : LI49.state = 1
		case "LEFTINLANE"
			LI46.state = 1 : LI47.state = 1 : LI49.state = 1
		case "TR15"
			LI47.state = 1 : LI48.state = 1
		case "RIGHTINLANE"
			LI47.state = 1 : LI48.state = 1
		case "TR18"
			LI53.state = 1 
		case "TR19"
			LI53.state = 1
		case "KICKER002"
			LI53.state = 1
	End Select
End Sub

'**********************************************************
'* SKILLSHOT **********************************************
'**********************************************************

Sub PrepareSkillShot()
	if bDebugGeneral = true then debug.print "Sub PrepareSkillShot()"
	Dim a
	a = RndNum(1,3)
	LI41.state=0:LI42.state=0:LI43.state=0
	select case a
		case 1
			LI41.state=2
		case 2
			LI42.state=2
		case 3
			LI43.state=2
	end select
	ToggleGate007(False)
	TimerSkillShot.enabled = True
End Sub

Sub EndSkillShot()
	if bDebugGeneral = true then debug.print "Sub EndSkillShot()"
	LI41.state=0:LI42.state=0:LI43.state=0
	TimerSkillShot.Enabled = false
	ToggleGate007(True)
End Sub

Sub AwardSkillShot()
	if bDebugGeneral = true then debug.print "Sub AwardSkillShot()"
	playsound "SFX_Nuck",1,nTableSFXVolume
	DMDFLush
	DMD2 "", "AWARD", "SKILLSHOT", 2000, UltraDMD_eZoom , ""
	AddSpeechToQueue "SFX_Speech_SkillShot",1000
	TimerSkillShot.Enabled = false
	Call EndSkillShot
	lighteffect 15
	DOF 157, DOFPULSE
	addscore cScoreSkillShot
End Sub

Sub TimerSkillShot_Timer()
	TimerSkillShot.enabled = False
	Call EndSkillShot
End sub

'**********************************************************
'* BONUS MULTIPLIER ***************************************
'**********************************************************

Sub CheckAndAwardBonusMultiplier()
	lighteffect 15
	addscore 2*cScoreMir
	playsound "SFX_AnotherWorld",1,nTableSFXVolume
	If li1.state = 1 and li2.state = 1 and li3.state = 1 Then
		li1.state=0:li2.state=0:li3.state=0
		nPlayerLights(nCurrentPlayer,1)=0:nPlayerLights(nCurrentPlayer,2)=0:nPlayerLights(nCurrentPlayer,3)=0
		nBonusMultiplier(nCurrentPlayer)=nBonusMultiplier(nCurrentPlayer)+1
		DMD2 "", "BONUS", cstr(nBonusMultiplier(nCurrentPlayer))+" X", 4000, UltraDMD_eZoom , ""
		Select case nBonusMultiplier(nCurrentPlayer)
			case 2
				AddSpeechToQueue "SFX_Speech_2x_Multiplier",3000
			case 3
				AddSpeechToQueue "SFX_Speech_3x_Multiplier",3000
			case 4
				AddSpeechToQueue "SFX_Speech_4x_Multiplier",3000
			case 5
				AddSpeechToQueue "SFX_Speech_5x_Multiplier",3000
			case 6
				AddSpeechToQueue "SFX_Speech_6x_Multiplier",3000
			case else
				AddSpeechToQueue "SFX_Speech_Bonus_Multiplier",3000
		end select
		PLaySOund "SFX_Xarax",1,nTableSFXVolume
		lighteffect 4
		LightEffect 15
		LightEffect 5
	end if
End Sub

'**********************************************************
'* SPECIAL ************************************************
'**********************************************************
Sub AwardSpecial()
	DOF 127, DOFPulse
	PlaySound SoundFXDOF("knocker",159,DOFPulse,DOFKnocker)	
	dmd2 "", "SPECIAL","",UltraDMD_eZoom,2000,""	
	LightEffect 2
	LightEffect 3
	LightEffect 4
End Sub

'**********************************************************
'* RAMP RUNNERS *******************************************
'**********************************************************
Sub LightRampTriggerL001_Hit() : LightRampL001.Duration 1,200,0 : End Sub
Sub LightRampTriggerL002_Hit() : LightRampL002.Duration 1,200,0 : End Sub
Sub LightRampTriggerL003_Hit() : LightRampL003.Duration 1,200,0 : End Sub
Sub LightRampTriggerL004_Hit() : LightRampL004.Duration 1,200,0 : End Sub
Sub LightRampTriggerL005_Hit() : LightRampL005.Duration 1,200,0 : End Sub
Sub LightRampTriggerL006_Hit() : LightRampL006.Duration 1,200,0 : End Sub
Sub LightRampTriggerL007_Hit() : LightRampL007.Duration 1,200,0 : End Sub
Sub LightRampTriggerL008_Hit() : LightRampL008.Duration 1,200,0 : End Sub
Sub LightRampTriggerL009_Hit() : LightRampL009.Duration 1,200,0 : End Sub
Sub LightRampTriggerL010_Hit() : LightRampL010.Duration 1,200,0 : End Sub
Sub LightRampTriggerL011_Hit() : LightRampL011.Duration 1,200,0 : End Sub
Sub LightRampTriggerL012_Hit() : LightRampL012.Duration 1,200,0 : End Sub
Sub LightRampTriggerL013_Hit() : LightRampL013.Duration 1,200,0 : End Sub
Sub LightRampTriggerL014_Hit() : LightRampL014.Duration 1,200,0 : End Sub
Sub LightRampTriggerL015_Hit() : LightRampL015.Duration 1,200,0 : End Sub

Sub LightRampTriggerL016_Hit() : LightRampL016.Duration 1,200,0 : End Sub
Sub LightRampTriggerL017_Hit() : LightRampL017.Duration 1,200,0 : End Sub
Sub LightRampTriggerL018_Hit() : LightRampL018.Duration 1,200,0 : End Sub
Sub LightRampTriggerL019_Hit() : LightRampL019.Duration 1,200,0 : End Sub
Sub LightRampTriggerL020_Hit() : LightRampL020.Duration 1,200,0 : End Sub
Sub LightRampTriggerL021_Hit() : LightRampL021.Duration 1,200,0 : End Sub
Sub LightRampTriggerL022_Hit() : LightRampL022.Duration 1,200,0 : End Sub

Sub LightRampTriggerL023_Hit() : LightRampL023.Duration 1,200,0 : End Sub
Sub LightRampTriggerL024_Hit() : LightRampL024.Duration 1,200,0 : End Sub
Sub LightRampTriggerL025_Hit() : LightRampL025.Duration 1,200,0 : End Sub
Sub LightRampTriggerL026_Hit() : LightRampL026.Duration 1,200,0 : End Sub
Sub LightRampTriggerL027_Hit() : LightRampL027.Duration 1,200,0 : End Sub
Sub LightRampTriggerL028_Hit() : LightRampL028.Duration 1,200,0 : End Sub
Sub LightRampTriggerL029_Hit() : LightRampL029.Duration 1,200,0 : End Sub
Sub LightRampTriggerL030_Hit() : LightRampL030.Duration 1,200,0 : End Sub
Sub LightRampTriggerL031_Hit() : LightRampL031.Duration 1,200,0 : End Sub
Sub LightRampTriggerL032_Hit() : LightRampL032.Duration 1,200,0 : End Sub
Sub LightRampTriggerL033_Hit() : LightRampL033.Duration 1,200,0 : End Sub
Sub LightRampTriggerL034_Hit() : LightRampL034.Duration 1,200,0 : End Sub
Sub LightRampTriggerL035_Hit() : LightRampL035.Duration 1,200,0 : End Sub
Sub LightRampTriggerL036_Hit() : LightRampL036.Duration 1,200,0 : End Sub
Sub LightRampTriggerL037_Hit() : LightRampL037.Duration 1,200,0 : End Sub
Sub LightRampTriggerL038_Hit() : LightRampL038.Duration 1,200,0 : End Sub
Sub LightRampTriggerL039_Hit() : LightRampL039.Duration 1,200,0 : End Sub
Sub LightRampTriggerL040_Hit() : LightRampL040.Duration 1,200,0 : End Sub
Sub LightRampTriggerL041_Hit() : LightRampL041.Duration 1,200,0 : End Sub
Sub LightRampTriggerL042_Hit() : LightRampL042.Duration 1,200,0 : End Sub
Sub LightRampTriggerL043_Hit() : LightRampL043.Duration 1,200,0 : End Sub
Sub LightRampTriggerL044_Hit() : LightRampL044.Duration 1,200,0 : End Sub
Sub LightRampTriggerL045_Hit() : LightRampL045.Duration 1,200,0 : End Sub
Sub LightRampTriggerL046_Hit() : LightRampL046.Duration 1,200,0 : End Sub
Sub LightRampTriggerL047_Hit() : LightRampL047.Duration 1,200,0 : End Sub
Sub LightRampTriggerL048_Hit() : LightRampL048.Duration 1,200,0 : End Sub
Sub LightRampTriggerL049_Hit() : LightRampL049.Duration 1,200,0 : End Sub
Sub LightRampTriggerL050_Hit() : LightRampL050.Duration 1,200,0 : End Sub
Sub LightRampTriggerL051_Hit() : LightRampL051.Duration 1,200,0 : End Sub

Sub TimerHurryUp_Timer()
	' ComboBonusMode
	if bReadyForComboBonus = true Then
		AddSpeechToQueue "SFX_Speech_Aim_For_The_Secret_Galaxy",3000
		DMD2 "", "AIM FOR THE", "SECRET GALAXY", 2000, UltraDmd_eNone , ""
		DMD2 "", "TO COLLECT YOUR", "COMBO BONUS", 2000, UltraDmd_eNone , ""
		Objlevel(4) = 1 
		vpmtimer.addtimer 2200, "FlasherFlash4_Timer '"
		vpmtimer.addtimer 2400, "FlasherFlash4_Timer '"
		vpmtimer.addtimer 2600, "FlasherFlash4_Timer '"
		vpmtimer.addtimer 2800, "FlasherFlash4_Timer '"
	end if
End Sub

'****************************
' JP's new DMD using flashers
'****************************

Dim Digits, Chars(255)

DMDInit

Sub DMDInit
    Dim i

    Digits = Array(digit044, digit045, digit046, digit047, digit048, digit049, digit050, digit051, digit052, digit053, digit054, _
            digit055, digit056, digit057, digit058, digit059, digit060, digit061, digit062, digit063, digit064, digit065, _
            digit066, digit067, digit068, digit069, digit070, digit071, digit072, digit073, digit074, digit075, digit076, digit077, _
            digit078, digit079, digit080, digit081, digit082, digit083, digit084, digit085, digit086)


    For i = 0 to 255:Chars(i) = "dempty":Next

    Chars(32) = "dempty"
    Chars(35) = "jp1"
    Chars(36) = "jp2"
    Chars(37) = "jp3"
    Chars(38) = "title1"
    Chars(39) = "title2"
    Chars(40) = "title3"
    Chars(46) = "dot"      '.
    Chars(48) = "d0"       '0
    Chars(49) = "d1"       '1
    Chars(50) = "d2"       '2
    Chars(51) = "d3"       '3
    Chars(52) = "d4"       '4
    Chars(53) = "d5"       '5
    Chars(54) = "d6"       '6
    Chars(55) = "d7"       '7
    Chars(56) = "d8"       '8
    Chars(57) = "d9"       '9
    Chars(60) = "dless"    '<
    Chars(61) = "dequal"   '=
    Chars(62) = "dgreater" '>
    Chars(64) = "bkempty"  '@
    Chars(65) = "da"       'A
    Chars(66) = "db"       'B
    Chars(67) = "dc"       'C
    Chars(68) = "dd"       'D
    Chars(69) = "de"       'E
    Chars(70) = "df"       'F
    Chars(71) = "dg"       'G
    Chars(72) = "dh"       'H
    Chars(73) = "di"       'I
    Chars(74) = "dj"       'J
    Chars(75) = "dk"       'K
    Chars(76) = "dl"       'L
    Chars(77) = "dm"       'M
    Chars(78) = "dn"       'N
    Chars(79) = "do"       'O
    Chars(80) = "dp"       'P
    Chars(81) = "dq"       'Q
    Chars(82) = "dr"       'R
    Chars(83) = "ds"       'S
    Chars(84) = "dt"       'T
    Chars(85) = "du"       'U
    Chars(86) = "dv"       'V
    Chars(87) = "dw"       'W
    Chars(88) = "dx"       'X
    Chars(89) = "dy"       'Y
    Chars(90) = "dz"       'Z
    Chars(94) = "dup"      '^
    '    Chars(95) = '_
    Chars(96) = "d0a"  '0.
    Chars(97) = "d1a"  '1. 'a
    Chars(98) = "d2a"  '2. 'b
    Chars(99) = "d3a"  '3. 'c
    Chars(100) = "d4a" '4. 'd
    Chars(101) = "d5a" '5. 'e
    Chars(102) = "d6a" '6. 'f
    Chars(103) = "d7a" '7. 'g
    Chars(104) = "d8a" '8. 'h
    Chars(105) = "d9a" '9  'i
    Chars(111) = "do2" 'o
    Chars(112) = "dp2" 'p 'p dark
    Chars(113) = "dk2" 'q 'k dark
    Chars(114) = "de2" 'r 'e dark
    ' bumper images
    Chars(131) = "b1"
    Chars(132) = "b2"
    Chars(133) = "b3"
    Chars(134) = "b4"
    Chars(135) = "b5"
    Chars(136) = "b6"
    Chars(137) = "b7"
    Chars(138) = "b8"
    Chars(139) = "b9"
    Chars(140) = "b10"
    Chars(141) = "b11"
    Chars(142) = "b12"
    Chars(143) = "b13"
    Chars(144) = "b14"
    Chars(145) = "b15"
    Chars(146) = "b16"
    Chars(147) = "b17"
    Chars(148) = "b18"
    Chars(149) = "b19"
    Chars(150) = "b20"
    Chars(151) = "b21"
    Chars(152) = "b22"
    Chars(153) = "b23"
    Chars(154) = "b24"
    Chars(155) = "b25"
    Chars(156) = "b26"
    Chars(157) = "b27"
    Chars(158) = "b28"
    Chars(159) = "b29"
    Chars(160) = "b30"
End Sub

'**************
' Update JPs DMD
'**************

Sub DMDUpdate(id)
    Dim digit, value

    Select Case id
        Case 0 'top text line
            For digit = 0 to 19
                DMDDisplayChar mid(ucase(dLine(0)), digit + 1, 1), digit
            Next
        Case 1 'bottom text line
            For digit = 20 to 39
                DMDDisplayChar mid(ucase(dLine(1)), digit -19, 1), digit
            Next
    End Select
End Sub

Sub DMDDisplayChar(achar, adigit)
    If achar = "" Then achar = " "
    achar = ASC(achar)
    Digits(adigit).ImageA = Chars(achar)
End Sub

Function CL(NumString) 'center line
    Dim Temp, TempStr
	NumString = LEFT(NumString, 20)
    Temp = (20- Len(NumString)) \ 2
    TempStr = Space(Temp) & NumString & Space(Temp)
    CL = TempStr
End Function

Sub TimerVPXText_Timer()
	TimerVPXText.enabled = False
	DMDScore
End Sub	