'                                                                   =*########*:                                                                                 
'                                                             +######################:                                                                           
'                                                         .##############################                                                                        
'                                                       ####################################                                                                     
'                                                     ###############            #############                                                                   
'                                                   ################*            -##############                                                                 
'                                                 =##################             ###############                                                                
'                                                ####################             *###############+                                                              
'                                               ###################-#*             #################                                                             
'                                              ###################. ##             *################+                                                            
'                                             +###################  .#-             #################                                                            
'                                             ###################.   ##             ##################                                                           
'### #####.##  *#####-=#####*  *##### ####   +###################   ###.             #################    ##=.#### :##  ##### *###      =###+     *####    *####-
'##  ##### -#   ####*  #####    #####   ##   ###################.   ####             ##################   ##  ####. *#  -####   +#-     +####      #####   ##### 
'=.  #####  #   ####*  #####    #####  =     ###################   #####             :#################   #.  ####.  #  -####    .     :.####*      ####+ .##### 
'    #####      ####* :#####    ##### ##     ##################   :######             #################       ####.     :#### .#-      # *####      *##### ##### 
'    #####      ####*  #####    ##### -#     ##################   #######             +################       ####.     :####  #-     *.  ####+    * ##### ####* 
'    #####      #####  #####    #####    :   #################   :#######-             ################       ####      -####         # #######    #  ###  ####* 
'    #####      #####  #####    #####   ##   ################*   ##                    +##############.       ####      -####   .#*  #     ####:   #  *#.  ####* 
'   ######*    *#####+*######  #####* ####    ###############   :#*                     ##############      .######-    ##### ####*:###.  ######: ###= #  ######*
'                                             ###############   ###########             *############.                                                           
'                                              #############   .###########              ############                                                            
'                                               ###########     ###########-             ###########                                                             
'                                                #######          =#######                 ########                                                              
'                                                 #####=           ######:                  #####-                                                               
'                                                  :############################################                                                                 
'                                                    =########################################                                                                   
'                                                      -####################################                                                                     
'                                                         *##############################=                                                                       
'                                                            :########################                                                                           
'                                                                 .*############+  


' ****************************************************************
'                       VISUAL PINBALL X 1.72
'                 Jicho Original Pinball Table
'                         Version 2.0.4
' ****************************************************************



Option Explicit
Randomize

Const BallSize = 50  ' 50 is the normal size used in the core.vbs, VP kicker routines uses this value divided by 2
Const BallMass = 1   ' normal ball mass
Const SongVolume = 0.3 ' 1 is full volume. Value is from 0 to 1

'FlexDMD in high or normal quality
'change it to True if you have an LCD screen, 256x64
'or keep it False if you have a real DMD at 128x32 in size
Const FlexDMDHighQuality = False

' Define Table Constants
Const cGameName = "TheATeam"
Const TableName = "TheATeam"
Const myVersion = "2.0.0"
Const MaxPlayers = 4     ' from 1 to 4
Const BallSaverTime = 20 ' in seconds NORMALMENTE 20
Const MaxMultiplier = 5  ' limit to 5x in this game, both bonus multiplier and playfield multiplier
Const BallsPerGame = 3   ' usually 3 or 5
Const MaxMultiballs = 5  ' max number of balls during multiballs

Dim EnableBallControl
EnableBallControl = false 'Change to true to enable manual ball control (or press C in-game) via the arrow keys and B (boost movement) keys

' Load the core.vbs for supporting Subs and functions
LoadCoreFiles

Sub LoadCoreFiles
    On Error Resume Next
    ExecuteGlobal GetTextFile("core.vbs")
    If Err Then MsgBox "Can't open core.vbs"
    ExecuteGlobal GetTextFile("controller.vbs")
    If Err Then MsgBox "Can't open controller.vbs"
    On Error Goto 0
End Sub

' Define Global Variables
Dim PlayersPlayingGame
Dim CurrentPlayer
Dim Credits
Dim BonusPoints(4)
Dim BonusHeldPoints(4)
Dim BonusMultiplier(4)
Dim PlayfieldMultiplier(4)
Dim bBonusHeld
Dim BallsRemaining(4)
Dim ExtraBallsAwards(4)
Dim Score(4)
Dim HighScore(4)
Dim HighScoreName(4)
Dim Jackpot(4)
Dim SuperJackpot
Dim Tilt
Dim TiltSensitivity
Dim Tilted
Dim TotalGamesPlayed
Dim mBalls2Eject
Dim SkillshotValue(4)
Dim bAutoPlunger
Dim bInstantInfo
Dim bAttractMode


' Define Game Control Variables
Dim LastSwitchHit
Dim BallsOnPlayfield
Dim BallsInLock(4)
Dim BallsInHole
	

' Define Game Flags
Dim bFreePlay
Dim bGameInPlay
Dim bOnTheFirstBall
Dim bBallInPlungerLane
Dim bBallSaverActive
Dim bBallSaverReady
Dim bMultiBallMode
Dim bMusicOn
Dim bSkillshotReady
Dim bExtraBallWonThisBall
Dim bJustStarted
Dim bJackpot

Dim Repeat_DMD_From_Start
	Repeat_DMD_From_Start = True
Dim Dmd_Rest_Active 
	Dmd_Rest_Active = True

' core.vbs variables
Dim plungerIM 'used mostly as an autofire plunger during multiballs
Dim cbRight   'captive ball
Dim bsJackal
Dim bsJeep
Dim bsBarrel
Dim bsCharacterKicker
Dim bsExtraBallKicker
Dim ExtraballDMD
Dim GifDMDBumper_active
Dim x

'**********************************
'Nuevas Variables
'**********************************

Dim BallSaverTimer (15) 'Saver Timer in Submisions

BallSaverTimer (1) = 10  ' 15 seconds in Truck Convoy Mision 
BallSaverTimer (2) = 10  ' 15 seconds in Punch Out Mision 
BallSaverTimer (3) = 10  ' 15 seconds in Truck Convoy Mision
BallSaverTimer (4) = 10  ' 15 seconds in Truck Convoy Mision
BallSaverTimer (5) = 10  ' 15 seconds in Truck Convoy Mision
BallSaverTimer (6) = 10  ' 15 seconds in Truck Convoy Mision
BallSaverTimer (7) = 10  ' 15 seconds in Truck Convoy Mision
BallSaverTimer (8) = 10  ' 15 seconds in Truck Convoy Mision
BallSaverTimer (9) = 10  ' 15 seconds in Truck Convoy Mision
BallSaverTimer (10) = 10  ' 15 seconds in Truck Convoy Mision
BallSaverTimer (11) = 10
BallSaverTimer (12) = 10
BallSaverTimer (13) = 10
BallSaverTimer (14) = 10
BallSaverTimer (15) = 10

Dim Puntuacion
Dim GifAnimated
Dim Parameter
Dim Box
Dim SkillshotDone(4)
Dim SkillshotDontrepeat(4)
Dim Killshot
Dim End_mu_active (4)

Dim FraseDMD
Dim FraseExplanation
Dim FraseExplanationLine2
Dim Frase

Killshot=0 
Dim fso
Dim curDir
Dim FlexPath

Dim Activacion_Misiones(4)'ANTES MORPHEO
Dim Mision (4,5)

Dim NombreMision(4)
NombreMision(1)="MURDOCK"
NombreMision(2)="BARRACUS"
NombreMision(3)="FACEMAN"
NombreMision(4)="HANNIBAL"

Dim Nombre_Sorteo (10)
Nombre_Sorteo (1) = "EXTRABALL LITE"
Nombre_Sorteo (2) = "BIG POINTS"
Nombre_Sorteo (3) = "BONUS HELD"
Nombre_Sorteo (4) = "BONUS MULTIPLIER"
Nombre_Sorteo (5) = "COMPLETE BATTLE"
Nombre_Sorteo (6) = "COMPLETE MISION"
Nombre_Sorteo (7) = "SUPERBUMPERS"
Nombre_Sorteo (8) = "BALL SAVE"
Nombre_Sorteo (9) = "MULTIBALL"
Nombre_Sorteo (10) = "TRIBALL READY"

Dim Mensaje_Mision(4)

Dim Pos_Temp (4)

Pos_Temp (1)= 0
Pos_temp (2)= 28
Pos_temp (3)= 0
Pos_temp (4)= 28

Dim Pos_mision_Cuadrante (4,3) 'Position in DMD

Pos_mision_Cuadrante(0,0) = 0
Pos_mision_Cuadrante(0,1) = 0
Pos_mision_Cuadrante(1,0) = 64
Pos_mision_Cuadrante(1,1) = 0
Pos_mision_Cuadrante(2,0) = 0
Pos_mision_Cuadrante(2,1) = 16
Pos_mision_Cuadrante(3,0) = 64
Pos_mision_Cuadrante(3,1) = 16

Dim Status_DMD_Mision (4)

Dim TriBallReady

Dim Sub_Mensaje_Mision(4)

Sub_Mensaje_Mision(1)=	"SPINNERS "
Sub_Mensaje_Mision(2)=	"BUMPERS"
Sub_Mensaje_Mision(3)=	"RAMPS"
Sub_Mensaje_Mision(4)=	"LEFT TARGETS"

Dim OrdenNombreMision (4,5)
Dim Norepetirmision (4,5)
Dim NewMision
Dim MisionActiva (4) 'Para cada jugador en que numero de mision se encuentra, primera segunda tercera o cuarta

Dim SpinCountMision (4)
Dim SuperBumperHits (4)
Dim RampHits3(4)
Dim TargetHits8 (4)
Dim MrLee_Value (4)

Dim Activacion_Weel_of_Fortune(4)
Dim Draw(4,11)
Dim OrdenNombreDraw (4,11)
Dim Not_Repeat_Draw_number(4,11)
Dim Weel_of_Fortune_Activa (4) 'Para cada jugador en que numero de sorteo se encuentra.

Dim Fuente(4)

Dim TargetHit (4)

TargetHit (1) =0
TargetHit (2) =0
TargetHit (3) =0
TargetHit (4) =0

Dim SuperTargets

Dim MisionStatusLigth (4,4) 'ESTADO DE LAS MISIONES PARA ACTUALIZAR LAS LUCES


Dim ContadorMisionDone(4) 'CONTADOR DE MISIONES POR JUGADOR
 

Dim LaneIntroDMD (4)
Dim Pausa_DMD
Dim Lane_RunAway_Status (3)

Lane_RunAway_Status(1)= 0 '0 Es carril Vacio, 1 Ocupado
Lane_RunAway_Status(2)= 0
Lane_RunAway_Status(3)= 0

Dim Lane_Saved(4)

Dim SpellTeam (4,4)

Dim GifVanRelancuchActive


'Mostrar el gif de Puntuacion o el de los Bumpers
Dim BumperActivo 
BumperActivo=0 
  
Dim SpinnerActivo
Spinneractivo =0       
Dim ScoreBumpers(4)
Dim ScoreDMDActive
Dim Door_Bloqued
Dim Door_is_open(4)

Dim RedayTriballDMD (4)

'Activar o desactivr la puntuación en el DMD
ScoreDMDActive=0
' Valor inicial Mision Trinity Scape en Spinners
Dim TrinityScape_value
TrinityScape_Value=25000000

Dim Segundos_value
Segundos_Value = 30

Dim LuzBackglass
Dim FaseParpadeo
Dim LuzCharacterBackglass
Dim FaseCharacterParpadeo

Set fso = CreateObject("Scripting.FileSystemObject")
		curDir = fso.GetAbsolutePathName(".")
		FlexPath = curDir & "\TheATeam\"
			

'*****************************************************************************************************
' UltraDMD constants
Const UltraDMD_VideoMode_Stretch=0, UltraDMD_VideoMode_Top = 1, UltraDMD_VideoMode_Middle = 2, UltraDMD_VideoMode_Bottom = 3
Const UltraDMD_Animation_FadeIn = 0, UltraDMD_Animation_FadeOut = 1, UltraDMD_Animation_ZoomIn = 2, UltraDMD_Animation_ZoomOut = 3
Const UltraDMD_Animation_ScrollOffLeft = 4, UltraDMD_Animation_ScrollOffRight = 5, UltraDMD_Animation_ScrollOnLeft = 6, UltraDMD_Animation_ScrollOnRight = 7,_
UltraDMD_Animation_ScrollOffUp = 8,UltraDMD_Animation_ScrollOffDown = 9,UltraDMD_Animation_ScrollOnUp = 10,UltraDMD_Animation_ScrollOnDown = 11,UltraDMD_Animation_None = 14

'*****************************************************************************************************
' FlexDMD constants
Const 	FlexDMD_RenderMode_DMD_GRAY = 0, _
		FlexDMD_RenderMode_DMD_GRAY_4 = 1, _
		FlexDMD_RenderMode_DMD_RGB = 2, _
		FlexDMD_RenderMode_SEG_2x16Alpha = 3, _
		FlexDMD_RenderMode_SEG_2x20Alpha = 4, _
		FlexDMD_RenderMode_SEG_2x7Alpha_2x7Num = 5, _
		FlexDMD_RenderMode_SEG_2x7Alpha_2x7Num_4x1Num = 6, _
		FlexDMD_RenderMode_SEG_2x7Num_2x7Num_4x1Num = 7, _
		FlexDMD_RenderMode_SEG_2x7Num_2x7Num_10x1Num = 8, _
		FlexDMD_RenderMode_SEG_2x7Num_2x7Num_4x1Num_gen7 = 9, _
		FlexDMD_RenderMode_SEG_2x7Num10_2x7Num10_4x1Num = 10, _
		FlexDMD_RenderMode_SEG_2x6Num_2x6Num_4x1Num = 11, _
		FlexDMD_RenderMode_SEG_2x6Num10_2x6Num10_4x1Num = 12, _
		FlexDMD_RenderMode_SEG_4x7Num10 = 13, _
		FlexDMD_RenderMode_SEG_6x4Num_4x1Num = 14, _
		FlexDMD_RenderMode_SEG_2x7Num_4x1Num_1x16Alpha = 15, _
		FlexDMD_RenderMode_SEG_1x16Alpha_1x16Num_1x7Num = 16

Const 	FlexDMD_Align_TopLeft = 0, _
		FlexDMD_Align_Top = 1, _
		FlexDMD_Align_TopRight = 2, _
		FlexDMD_Align_Left = 3, _
		FlexDMD_Align_Center = 4, _
		FlexDMD_Align_Right = 5, _
		FlexDMD_Align_BottomLeft = 6, _
		FlexDMD_Align_Bottom = 7, _
		FlexDMD_Align_BottomRight = 8


Dim AlphaChars(255)
AlphaChars(48) = &h443F ' 0
AlphaChars(49) = &h0406 ' 1
AlphaChars(50) = &h085B ' 2
AlphaChars(51) = &h080F ' 3
AlphaChars(52) = &h0866 ' 4
AlphaChars(53) = &h086D ' 5
AlphaChars(54) = &h087D ' 6
AlphaChars(55) = &h2401 ' 7
AlphaChars(56) = &h087F ' 8
AlphaChars(57) = &h086F ' 9
AlphaChars(65) = &h0877 ' A
AlphaChars(66) = &h2A0F ' B
AlphaChars(67) = &h0039 ' C
AlphaChars(68) = &h220F ' D
AlphaChars(69) = &h0879 ' E
AlphaChars(70) = &h0871 ' F
AlphaChars(71) = &h083D ' G
AlphaChars(72) = &h0876 ' H
AlphaChars(73) = &h2209 ' I
AlphaChars(74) = &h001E ' J
AlphaChars(75) = &h1470 ' K
AlphaChars(76) = &h0038 ' L
AlphaChars(77) = &h0536 ' M
AlphaChars(78) = &h1136 ' N
AlphaChars(79) = &h003F ' O
AlphaChars(80) = &h0873 ' P
AlphaChars(81) = &h103F ' Q
AlphaChars(82) = &h1873 ' R
AlphaChars(83) = &h090D ' S
AlphaChars(84) = &h2201 ' T
AlphaChars(85) = &h003E ' U
AlphaChars(86) = &h4430 ' V
AlphaChars(87) = &h5036 ' W
AlphaChars(88) = &h5500 ' X
AlphaChars(89) = &h2500 ' Y
AlphaChars(90) = &h4409 ' Z


'*****************************************************************************************************
'
' FlexDMD's script
'
Const 	Mode_Welcome = 0, _
		Mode_Stern = 1, _
		Mode_Williams = 2, _
		Mode_Colors = 3, _
		Mode_VideoMode = 4, _
		Mode_AlphaNum = 5

Dim FlexDMD, AlphaNumDMD
Dim DmdMode : DmdMode = Mode_Welcome
Dim Scores(4) : Scores(1) = 0 : Scores(2) = 0 : Scores(3) = 0 : Scores(4) = 0
Dim Player : Player = 1
Dim FontScoreInactive, FontScoreActive
Dim VideoModeActive  'IF TRUE, LOCK THE FLIPPERS. IF fALSE UNLOCK THE FLIPPERS
Dim Frame : Frame = 0


Dim Battle_is_Active

'MISSION 2: Punch Out Variables

Dim Punch_Out_Value 

'MISSION 3: Lotrey Variables
Dim Lotery_Score
Dim Lotery_Frames (4)
Dim Rail_Lotery_Pos (4)
Dim Vel_Rail (4)
Dim Stop_Rail (4)
Dim Rail_Stopped
Dim Lotery_Value (4)
Dim Rail_Relativo (4)

'MISSION 4: Run Away Variables
Dim Car_Izq_Frames(21)
Dim Car_Cen_Frames(21)
Dim Car_Der_Frames(21)
Dim Car_Frames_Ready: Car_Frames_ready = True
Dim Player_Car_Frames(3)
Dim Player_Car_Position 
	Player_Car_position = 2
Dim RunAway_Value

'MISSION 5: Look And Shoot Variables

Dim CursorX
Dim	LeftFlipperPressed
Dim	RightFlipperPressed
Dim Mirilla_FindAndShoot_DMD (4)
Dim Enemy_FindAndShoot_posX (4,2)
	Enemy_FindAndShoot_posX(1,1) = 0
	Enemy_FindAndShoot_posX(1,2) = 0
	Enemy_FindAndShoot_posX(2,1) = 0
	Enemy_FindAndShoot_posX(2,2) = 0
	Enemy_FindAndShoot_posX(3,1) = 0
	Enemy_FindAndShoot_posX(3,2) = 0
	Enemy_FindAndShoot_posX(4,1) = 0
	Enemy_FindAndShoot_posX(4,2) = 0
Dim Enemy1_Frames(5)
Dim Enemy2_Frames(5)
Dim Enemy3_Frames(5)
Dim Enemy4_Frames(5)


Dim Frame_Enemy(4) : Frame_Enemy (1) = 0 : Frame_Enemy (2) = 0 : Frame_Enemy (3) =0 : Frame_Enemy (4)=0

Dim Mirilla_posX
	Mirilla_posX = 64
Dim Mirilla_Active
	Mirilla_Active= 0

Dim Enemy_FindAndShoot_Active (4)
	Enemy_FindAndShoot_Active(1) = False
	Enemy_FindAndShoot_Active(2) = False
	Enemy_FindAndShoot_Active(3) = False
	Enemy_FindAndShoot_Active(4) = False

Dim FindAndShoot_Scores(4)
Dim FindAndShoot_Timer

FindAndShoot_Timer = 30
Dim FindAndShoot_Value

Dim TargetS1_Status (4)
Dim TargetS2_Status (4)
Dim TargetS3_Status (4)
Dim TargetS4_Status (4)
' *********************************************************************
'                Text types
' *********************************************************************

Dim Font_Small
Dim	Font_Medium_special

	Font_Small = "FlexDMD.Resources.teeny_tiny_pixls-5.fnt"
	Font_Medium_special= "FlexDMD.Resources.bm_army-12.fnt"


' *********************************************************************
'                Visual Pinball Defined Script Events
' *********************************************************************

Sub Table1_Init()
    LoadEM
    Dim i
    Randomize
	
	'Reset HighScores
		'Reseths()

    'Impulse Plunger as autoplunger
    Const IMPowerSetting = 50 ' Plunger Power
    Const IMTime = 1.1        ' Time in seconds for Full Plunge
    Set plungerIM = New cvpmImpulseP
    With plungerIM
        .InitImpulseP swplunger, IMPowerSetting, IMTime
        .Random 1.5
        .InitExitSnd SoundFXDOF("fx_kicker", 141, DOFPulse, DOFContactors), SoundFXDOF("fx_solenoid", 141, DOFPulse, DOFContactors)
        .CreateEvents "plungerIM"
    End With

    Set cbRight = New cvpmCaptiveBall
    With cbRight
        .InitCaptive CapTrigger1, CapWall1, Array(CapKicker1, CapKicker1a), 0
        .NailedBalls = 1
        .ForceTrans = .9
        .MinForce = 3.5
        '.CreateEvents "cbRight"
        .Start
    End With
    CapKicker1.CreateSizedBallWithMass BallSize / 2, BallMass

	'CharacterKicker hole
	Set bsCharacterKicker = New cvpmTrough
    With bsCharacterKicker
        .size = 5
		'JackalHole direction
        .Initexit CharacterKicker, 188, 35
        '.InitExitVariance 2, 2
        .MaxBallsPerKick = 1
    End With

	'ExtraBall hole
	Set bsExtraBallKicker = New cvpmTrough
    With bsExtraBallKicker
        .size = 5
        .Initexit ExtraBallKicker, 50, 35
        .MaxBallsPerKick = 1
    End With

    ' Jackal hole
    Set bsJackal = New cvpmTrough
    With bsJackal
        .size = 5
		'JackalHole direction
        .Initexit JackalHole, 188, 35
        '.InitExitVariance 2, 2
        .MaxBallsPerKick = 1
    End With

	Set bsJeep = New cvpmTrough
    With bsJeep
        .size = 5
		'JeepHole direction
        .Initexit JeepHole, 220, 25
        '.InitExitVariance 2, 2
        .MaxBallsPerKick = 1
    End With

	Set bsBarrel = New cvpmTrough
    With bsBarrel
        .size = 5
		'JeepHole direction
        .Initexit BarrelHole, 220, 25
        '.InitExitVariance 2, 2
        .MaxBallsPerKick = 1
    End With

    ' Misc. VP table objects Initialisation, droptargets, animations...
    VPObjects_Init

    ' load saved values, highscore, names, jackpot
    Loadhs


    ' freeplay or coins
    bFreePlay = False 'we want coins

    if bFreePlay Then DOF 125, DOFOn

    ' Init main variables and any other flags
    bAttractMode = False
    bOnTheFirstBall = False
    bBallInPlungerLane = False
    bBallSaverActive = False
    bBallSaverReady = False
    bMultiBallMode = False
    bGameInPlay = False
    bAutoPlunger = False
    bMusicOn = True
    BallsOnPlayfield = 0
    BallsInLock(1) = 0
    BallsInLock(2) = 0
    BallsInLock(3) = 0
    BallsInLock(4) = 0
    BallsInHole = 0
    LastSwitchHit = ""
    Tilt = 0
    TiltSensitivity = 6
    Tilted = False
    bBonusHeld = False
    bJustStarted = True
    bJackpot = False
    bInstantInfo = False
    ' set any lights for the attract mode
    GiOff
    StartAttractMode

    ' Start the RealTime timer
    RealTime.Enabled = 1

    ' Load table color
    LoadLut
	'CAMBIO EL ARCO
	Primitive011.ObjRoty= 315
	Primitive011.ObjRotx= 90
Set FlexDMD = CreateObject("FlexDMD.FlexDMD")
    If FlexDMD is Nothing Then
        MsgBox "No FlexDMD found. This table will NOT run without it."
        Exit Sub
    End If
	SetLocale(1033)
	With FlexDMD
		.GameName = cGameName
		.TableFile = Table1.Filename & ".vpx"
		.Color = RGB(255, 0, 0)
		.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
		.Width = 128
		.Height = 32
		.Clear = True
		.Run = True
	End With
	Set AlphaNumDMD = CreateObject("FlexDMD.FlexDMD")
	With AlphaNumDMD
		.GameName = cGameName+"-AlphaNum"
		.RenderMode = FlexDMD_RenderMode_SEG_2x16Alpha
	End With
	
	'START SCENE TABLE
		'FindAndShootDMD()
	InicioDMDScenes()
	
End Sub

Sub DotMatrix_Timer
	Dim DMDp
	If FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_RGB Then
		DMDp = FlexDMD.DmdColoredPixels
		If Not IsEmpty(DMDp) Then
			DMDWidth = FlexDMD.Width
			DMDHeight = FlexDMD.Height
			DMDColoredPixels = DMDp
		End If
	Else
		DMDp = FlexDMD.DmdPixels
		If Not IsEmpty(DMDp) Then
			DMDWidth = FlexDMD.Width
			DMDHeight = FlexDMD.Height
			DMDPixels = DMDp
		End If
	End If
End Sub

'------------------------------------------------------------------------------------------
'******************************************************************************************
'									 DMD
'******************************************************************************************
'------------------------------------------------------------------------------------------

'****************************
'	Test DMD file exists
'****************************
Function FileExists(FilePath)
  Set fso = CreateObject("Scripting.FileSystemObject")
  If fso.FileExists(FilePath) Then
    FileExists=CBool(1)
  Else
    FileExists=CBool(0)
  End If
End Function


'****************************
'		DMD INICIO
'****************************

Sub InicioDMDScenes ()

			DotMatrix.color = RGB(255, 0, 0)

			Dim af, list
			Dim scene1
			Set scene1 = FlexDMD.NewGroup("Scene 1")

		'Scene 1 First Presentation
			scene1.AddActor FlexDMD.NewLabel("SystemVersion", FlexDMD.NewFont(Font_Small, vbWhite, vbBlack, 1), "-Jicho Present-")
			scene1.GetLabel("SystemVersion").SetBounds 0, 0, 128, 10
			scene1.AddActor FlexDMD.NewLabel("TableName", FlexDMD.NewFont(Font_Medium_special, vbWhite, vbBlack, 1), TableName)
			scene1.GetLabel("TableName").SetBounds 0, 8, 128, 16
			scene1.AddActor FlexDMD.NewLabel("TableVersion", FlexDMD.NewFont(Font_Small, vbWhite, vbBlack, 1), myVersion)
			scene1.GetLabel("TableVersion").SetBounds 0, 16, 128, 20
		
		'Scene 2 Second Presentation
			Dim scene2
			Set scene2 = FlexDMD.NewGroup("Scene 2")
			scene2.AddActor FlexDMD.NewLabel("Frase2", FlexDMD.NewFont(Font_Small, vbWhite, vbBlack, 1), "An Original VPX Table" ) 
			scene2.GetLabel("Frase2").SetBounds 0, 0, 130, 34
		
		'Scene 3 Presentatión GIF INTRO
			Dim scene3
			Set scene3 = FlexDMD.NewGroup("Scene 3")

			Dim File_Name_Check
				File_Name_Check = "Intro_A_Team.gif"

		'
			scene3.AddActor FlexDMD.NewVideo("Intro", FlexPath & File_Name_Check )
			scene3.GetVideo("Intro").SetBounds 0, 0, 128, 32
			scene3.GetVideo("Intro").Visible = True
		

		
		'Escena 4 Presentatión NO CREDITS "INSERT COIN"
			
			If Credits =0 Then
				Dim scene4
				Set scene4 = FlexDMD.NewGroup("Scene 4")
				scene4.AddActor FlexDMD.NewVideo("Insert_Coin", FlexPath &"Insert_Coin.gif")
				scene4.GetVideo("Insert_Coin").SetBounds 0, 0, 128, 32
				scene4.GetVideo("Insert_Coin").Visible = True
			End If
		
		'Escena 4 Presentación CON CREDITOS "MARCO PULSA START"
			If Credits >0 Then
				Set scene4 = FlexDMD.NewGroup("Scene 3")
				'scene2.AddActor FlexDMD.NewImage("Back", "FlexDMD.Resources.dmds.black.png")
				scene4.AddActor FlexDMD.NewLabel("Credits", FlexDMD.NewFont("FlexDMD.Resources.bm_army-12.fnt", vbWhite, vbBlack, 1), "Credits " & Credits)
				scene4.GetLabel("Credits").SetBounds 0, 0, 130, 34
				scene4.AddActor FlexDMD.NewFrame("Marco")
				scene4.GetFrame("Marco").Thickness = 1
				scene4.GetFrame("Marco").SetBounds 0, 0, 128, 32
			End If
		
		'Escena 4 Presentación CON CREDITOS "PULSA START"
			If Credits >0 Then
				Dim scenePush_Start
				Set scenePush_Start = FlexDMD.NewGroup("scenePush_Start")
				
				scenePush_Start.AddActor FlexDMD.NewVideo("Push_Start",  FlexPath & "Push_Start.gif")
				scenePush_Start.GetVideo("Push_Start").SetBounds 0, 0, 128, 32
				scenePush_Start.GetVideo("Push_Start").Visible = True	
			End If
		
		'SECUENCIA FINAL Escena Presentación 
			Dim sequence
			Set sequence = FlexDMD.NewGroup("Sequence")
			sequence.SetSize 128, 32
			Set af = sequence.ActionFactory
			Set list = af.Sequence()
		
		'Presenta la version
			If Repeat_DMD_From_Start= True Then 

				list.Add af.AddChild(scene1)
				list.Add af.Wait(3)
				list.Add af.RemoveChild(scene1)
				list.Add af.AddChild(scene2)
				list.Add af.Wait(3)
				list.Add af.RemoveChild(scene2)

				If FileExists( FlexPath & File_Name_Check ) Then
						list.Add af.AddChild(scene3)
						list.Add af.Wait(3.285)
						list.Add af.RemoveChild(scene3)  
				End If

				Repeat_DMD_From_Start = False' 	Dont repeat the opening scene after adding credit

			End If
		'continue the presentation from Start or Insert Coin, depending on the number of credits
			list.Add af.AddChild(scene4)
			list.Add af.Wait(3.1)
			list.Add af.RemoveChild(scene4)

			If Credits >0 Then
				list.Add af.AddChild(scenePush_Start)
				list.Add af.Wait(3.2)
				list.Add af.RemoveChild(scenePush_Start)

			End If

			sequence.AddAction af.Repeat(list, -1)

			FlexDMD.LockRenderThread
			FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
			FlexDMD.Stage.RemoveAll
			FlexDMD.Stage.AddActor sequence
			FlexDMD.UnlockRenderThread		

		End Sub
		
' Final Presentation Scene

'****************************
'	Puntuacion en el DMD 
'****************************

Sub ScoreDMD() 
	DotMatrix.color = RGB(255, 0, 0)
	Dim i,j
	
	Set FontScoreActive = FlexDMD.NewFont("FlexDMD.Resources.udmd-f7by13.fnt", vbWhite, vbWhite, 0)
	Set FontScoreInactive = FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbWhite, 0)
	

	Dim scene : Set scene = FlexDMD.NewGroup("Score")

	scene.AddActor FlexDMD.NewFrame("Frame1")
	scene.GetFrame("Frame1").Thickness = 1
	scene.GetFrame("Frame1").SetBounds 0, 24, 128, 1
	
	
	For j = 1 to PlayersPlayingGame
		If CurrentPlayer = j Then
				Fuente(j) = FontScoreActive
		Else
				Fuente(j) = FontScoreInactive
		End If
	
			Next

For i = 1 to PlayersPlayingGame
				scene.AddActor FlexDMD.NewLabel("Content_" & i, Fuente(i), FormatNumber(Score(i), 0, -1, 0, -1))
				'scene.AddActor FlexDMD.NewGroup("Content_" & i)
				'scene.Text = FormatNumber(Scores(i), 0, -1, 0, -1)
				Next
		If PlayersPlayingGame >0  Then
			scene.GetLabel("Content_1").SetAlignedPosition 0, 0, FlexDMD_Align_TopLeft
		End If
'scene.AddActor FlexDMD.NewLabel("Content_" & i, Fuente(1), Score(1))
			'FlexDMD.Stage.GetLabel("Score_3").SetAlignedPosition 0, 24, FlexDMD_Align_BottomLeft
			'FlexDMD.Stage.GetLabel("Score_4").SetAlignedPosition 128, 24, FlexDMD_Align_BottomRight
			'FlexDMD.Stage.GetLabel("Ball").SetAlignedPosition 2, 33, FlexDMD_Align_BottomLeft
			'FlexDMD.Stage.GetLabel("Credit").SetAlignedPosition 126, 33, FlexDMD_Align_BottomRight

	If PlayersPlayingGame >1 Then
			
						scene.GetLabel("Content_2").SetAlignedPosition 129, 0, FlexDMD_Align_TopRight

						If CurrentPlayer=2 Then 
							scene.GetLabel("Content_2").SetAlignedPosition 129, 0, FlexDMD_Align_TopRight
						End If

	End If

	If PlayersPlayingGame >2 Then

						scene.GetLabel("Content_3").SetAlignedPosition 0, 24, FlexDMD_Align_BottomLeft

						If CurrentPlayer=2 Then 
							scene.GetLabel("Content_3").SetAlignedPosition 0, 24, FlexDMD_Align_BottomLeft
						End If

	End If

	If PlayersPlayingGame >3 Then

						scene.GetLabel("Content_4").SetAlignedPosition 129, 24, FlexDMD_Align_BottomRight

						If CurrentPlayer=2 Then 
							scene.GetLabel("Content_4").SetAlignedPosition 129, 24, FlexDMD_Align_BottomRight
						End If

	End If

	'scene.AddActor FlexDMD.NewGroup("Content_1")
	'scene.GetGroup("Content_1").SetAlignedPosition 0, 0, FlexDMD_Align_TopLeft
	'scene.GetGroup("Content_1").AddActor FlexDMD.NewLabel("Content_1", fuente1, Score(1))

	
'FLAGS
	'scene.AddActor FlexDMD.NewGroup("Content_flag")
	'scene.GetGroup("Content_flag").SetBounds 1, 18, 128, 32
	'scene.GetGroup("Content_flag").AddActor FlexDMD.NewLabel("BALL", FontScoreInactive, "FLAGS:"& Battle_is_Active &" "& Battle(CurrentPlayer, 0)&" "&  Mision(CurrentPlayer, 0)&" "&  ContadorMisionDone(CurrentPlayer) &"-"& BattlesWon(CurrentPlayer))	
	
'NORMAL
	scene.AddActor FlexDMD.NewGroup("Content")
	scene.GetGroup("Content").SetBounds 55, 26, 128, 32
	scene.GetGroup("Content").AddActor FlexDMD.NewLabel("BALL", FontScoreInactive,"BALL "& Balls)
	

	scene.AddActor FlexDMD.NewGroup("Content2")
	scene.GetGroup("Content2").SetBounds 1, 26, 128, 32
	scene.GetGroup("Content2").AddActor FlexDMD.NewLabel("PLAYER", FontScoreInactive,"PLAYER " & CurrentPlayer )
	
	scene.AddActor FlexDMD.NewGroup("Content3")
	scene.GetGroup("Content3").SetBounds 92, 26, 128, 32
	scene.GetGroup("Content3").AddActor FlexDMD.NewLabel("CREDITS", FontScoreInactive,"CREDITS "& Credits  )

	AlphaNumDMD.Run = False
	FlexDMD.LockRenderThread
	FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
	FlexDMD.Stage.RemoveAll
	FlexDMD.Stage.AddActor scene
	FlexDMD.Show = True
	FlexDMD.UnlockRenderThread
End Sub
'****************************
'	End Score DMD 
'****************************

Sub End_Score_DMD ()
	DotMatrix.color = RGB(225, 0, 0)

			Dim FontScoreShadow, FontScoreBlack 
	 
			Set FontScoreActive = FlexDMD.NewFont("FlexDMD.Resources.udmd-f7by13.fnt", vbWhite, vbWhite, 0) 
			Set FontScoreShadow = FlexDMD.NewFont("FlexDMD.Resources.udmd-f7by13.fnt", RGB(50,50,50), RGB(50,50,50), 0)
			Set FontScoreBlack = FlexDMD.NewFont("FlexDMD.Resources.udmd-f7by13.fnt", vbBlack, vbBlack, 0)

			Dim Scene_bonus : Set Scene_bonus = FlexDMD.NewGroup("Bonus")
			Dim Scene_score : Set Scene_score = FlexDMD.NewGroup("Score")

			Dim File_Name_Check
				File_Name_Check = FlexPath & "endofball.gif"

					Dim Background_End_Scene
						'Añande el Gif
						Set Background_End_Scene = FlexDMD.NewGroup("Scene")
					
						
						If FileExists( File_Name_Check ) Then
							Background_End_Scene.AddActor FlexDMD.NewVideo("Gif", FlexPath &"endofball.gif")
							Background_End_Scene.GetVideo("Gif").SetBounds 0, 0, 128, 32
						Background_End_Scene.GetVideo("Gif").Visible = True
						End If 
						
			Scene_score.AddActor FlexDMD.NewGroup("Content")
			'Scene_score.GetGroup("Content").'SetAlignedPosition 0, 15, FlexDMD_Align_Top
			Scene_score.GetGroup("Content").AddActor FlexDMD.NewLabel("BALL1", FontScoreShadow, FormatNumber(Score(CurrentPlayer), 0, -1, 0, -1))   
			Scene_score.GetLabel("BALL1").SetBounds 1, -4, 130, 34 

			Scene_score.GetGroup("Content").AddActor FlexDMD.NewLabel("BALL2", FontScoreBlack , FormatNumber(Score(CurrentPlayer), 0, -1, 0, -1))
			Scene_score.GetLabel("BALL2").SetBounds 0, -5, 130, 34 
			
		
			Scene_score.GetGroup("Content").AddActor FlexDMD.NewLabel("BALL", FontScoreActive, FormatNumber(Score(CurrentPlayer), 0, -1, 0, -1))
			Scene_score.GetLabel("BALL").SetBounds 0, -5, 130, 34 


			Scene_bonus.AddActor FlexDMD.NewGroup("Content_bonus")
			'Scene_score.GetGroup("Content").'SetAlignedPosition 0, 15, FlexDMD_Align_Top
			Scene_bonus.GetGroup("Content_bonus").AddActor FlexDMD.NewLabel("BONUS1", FontScoreShadow, FormatNumber(BonusPoints(CurrentPlayer), 0, -1, 0, -1))   
			Scene_bonus.GetLabel("BONUS1").SetBounds 1, -4, 130, 34 

			Scene_bonus.GetGroup("Content_bonus").AddActor FlexDMD.NewLabel("BONUS2", FontScoreBlack , FormatNumber(BonusPoints(CurrentPlayer), 0, -1, 0, -1))
			Scene_bonus.GetLabel("BONUS2").SetBounds 0, -5, 130, 34 
			
		
			Scene_bonus.GetGroup("Content_bonus").AddActor FlexDMD.NewLabel("BONUS3", FontScoreActive, FormatNumber(BonusPoints(CurrentPlayer), 0, -1, 0, -1))
			Scene_bonus.GetLabel("BONUS3").SetBounds 0, -5, 130, 34
			
							'Añade el Marco
						
				
						'DMDScene.AddActor FlexDMD.NewLabel("PuntuacionBumper", FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", RGB(255, 255, 255), vbBlack, 0), ScoreBumpers(CurrentPlayer))
						'DMDScene.GetLabel("PuntuacionBumper").SetAlignedPosition 120, 2, FlexDMD_Align_TopRight

						'DMDScene.AddActor FlexDMD.NewFrame("Marco")
						'DMDScene.GetFrame("Marco").Thickness = 1
						'DMDScene.GetFrame("Marco").SetBounds 0, 0, 128, 32
						
					   ' Presenta el DMD
						
				 ' Presenta el DMD
			Dim sequence, af, list

           Set sequence = FlexDMD.NewGroup("Sequence")
				sequence.SetSize 128, 32
				Set af = sequence.ActionFactory
				Set list = af.Sequence()
					
					
					list.Add af.AddChild(Background_End_Scene)								
					list.Add af.Wait(1.5)		
					list.Add af.AddChild(Scene_bonus)	
					list.Add af.Wait(1)
					list.Add af.RemoveChild(Scene_bonus)
					list.Add af.Wait(1.8)
					list.Add af.AddChild(Scene_score)
					list.Add af.Wait(7)

				'Final Secuencia
					sequence.AddAction af.Repeat(list, -1)
			

			AlphaNumDMD.Run = False
			FlexDMD.LockRenderThread
			FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
			FlexDMD.Stage.RemoveAll
			FlexDMD.Stage.AddActor sequence
			FlexDMD.Show = True
			FlexDMD.UnlockRenderThread	
   
End Sub


'****************************
'	GIF en el DMD 
'****************************


Sub GifDMD(GifAnimated)
	DotMatrix.color = RGB(255, 0, 0)

		Dim DMDScene
			'Añande el Gif
            Set DMDScene = FlexDMD.NewGroup("Scene")
            'DMDScene.AddActor FlexDMD.NewImage("Back", "VPX.bkempty")
           ' DMDScene.GetImage("Back").SetSize FlexDMD.Width, FlexDMD.Height
			If FileExists( FlexPath & GifAnimated &".gif" ) Then
			DMDScene.AddActor FlexDMD.NewVideo("Gif", FlexPath & GifAnimated &".gif")
			
			'Añade el Marco
			DMDScene.GetVideo("Gif").SetBounds 0, 0, 128, 32
			DMDScene.GetVideo("Gif").Visible = True
			DMDScene.AddActor FlexDMD.NewFrame("Marco")
			DMDScene.GetFrame("Marco").Thickness = 1
			DMDScene.GetFrame("Marco").SetBounds 0, 0, 128, 32
           ' Presenta el DMD
            FlexDMD.LockRenderThread
			FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
			FlexDMD.Stage.RemoveAll
            FlexDMD.Stage.AddActor DMDScene
            FlexDMD.UnlockRenderThread	
		End If	
        
End Sub
	' Final Escena con GIF

'****************************
' TEST GifDMD_int         
'****************************

Sub GifDMD_int()
	DotMatrix.color = RGB(255, 0, 0)
	Dim  scene,  i

		Set scene = FlexDMD.NewGroup("Scene_FindAndShoot")

		For i = 1 to 5
		Dim y : y = Int((i - 1) / 5)
		Dim x : x = (i - 1) - y * 5

		'Cargo y oculto frames del Coche Izquierdo
		Set Enemy1_Frames(i) = FlexDMD.NewImage("Enemy1_Img_" & i, "VPX.MR_LEE_Back&region=" & (x * 128) & "," & (y * 32) & ",128,32")
		Enemy1_Frames(i).Visible = True
		scene.AddActor Enemy1_Frames(i)
		Next

	'Añade la frase
			Dim FraseInfo, sequence, af, list
			
			'Dim Explanation
			'	Set Explanation = FlexDMD.NewGroup("FraseExplanation")
			'		Explanation.AddActor FlexDMD.NewLabel("Explanation", SmallFont, FraseExplanation )
			'		Explanation.GetLabel("Explanation").SetBounds 0, 0, 130, 34
			'Dim ExplanationLine2
			'	Set ExplanationLine2 = FlexDMD.NewGroup("FraseExplanation")
			'		ExplanationLine2.AddActor FlexDMD.NewLabel("Explanation", SmallFont, FraseExplanationLine2 )
			'		ExplanationLine2.GetLabel("Explanation").SetBounds 0, 10, 130, 34

           ' Presenta el DMD
           Set sequence = FlexDMD.NewGroup("Sequence")
				sequence.SetSize 128, 32
				Set af = sequence.ActionFactory
				Set list = af.Sequence()
					
				For i=1 to 5	
					list.Add af.AddChild(Enemy1_Frames(i))
					list.Add af.Wait(0.5)		
					list.Add af.RemoveChild(Enemy1_Frames(i))	
					

				'Final Secuencia
					sequence.AddAction af.Repeat(list, -1)
				Next

			AlphaNumDMD.Run = False
			FlexDMD.LockRenderThread
			FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
			FlexDMD.Stage.RemoveAll
			FlexDMD.Stage.AddActor sequence
			FlexDMD.Show = True
			FlexDMD.UnlockRenderThread	

End Sub
'****************************
'	GIF en el DMD CON FRASE
'****************************


Sub GifDMDFrase(GifAnimated, Frase, FraseExplanation,FraseExplanationLine2)
	DotMatrix.color = RGB(255, 0, 0)

		Dim DMDScene
		
		Dim MediumFont : Set MediumFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f6by12.fnt", vbWhite, vbBlack, 1)
		Dim SmallFont: Set SmallFont = FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbBlack, vbWhite, 1)
			'Añande el Gif
            Set DMDScene = FlexDMD.NewGroup("Scene")
            'DMDScene.AddActor FlexDMD.NewImage("Back", "VPX.bkempty")
           ' DMDScene.GetImage("Back").SetSize FlexDMD.Width, FlexDMD.Height
			DMDScene.AddActor FlexDMD.NewVideo("Gif", FlexPath & GifAnimated &".gif")
			'Añade el Marco
			DMDScene.GetVideo("Gif").SetBounds 0, 0, 128, 32
			DMDScene.GetVideo("Gif").Visible = True
			DMDScene.AddActor FlexDMD.NewFrame("Marco")
			DMDScene.GetFrame("Marco").Thickness = 1
			DMDScene.GetFrame("Marco").SetBounds 0, 0, 128, 32

			'Añade la frase
			Dim FraseInfo, sequence, af, list
			Set FraseInfo = FlexDMD.NewGroup("FraseInfo")
	
				FraseInfo.AddActor FlexDMD.NewLabel("InfoText", MediumFont, Frase )
				FraseInfo.GetLabel("InfoText").SetBounds 0, 0, 130, 34

			Dim Explanation
				Set Explanation = FlexDMD.NewGroup("FraseExplanation")
					Explanation.AddActor FlexDMD.NewLabel("Explanation", SmallFont, FraseExplanation )
					Explanation.GetLabel("Explanation").SetBounds 0, 0, 130, 34
			Dim ExplanationLine2
				Set ExplanationLine2 = FlexDMD.NewGroup("FraseExplanation")
					ExplanationLine2.AddActor FlexDMD.NewLabel("Explanation", SmallFont, FraseExplanationLine2 )
					ExplanationLine2.GetLabel("Explanation").SetBounds 0, 10, 130, 34


           ' Presenta el DMD
           Set sequence = FlexDMD.NewGroup("Sequence")
				sequence.SetSize 128, 32
				Set af = sequence.ActionFactory
				Set list = af.Sequence()
					
					
					list.Add af.AddChild(DMDScene)
					list.Add af.Wait(1.5)		
					list.Add af.AddChild(FraseInfo)	
					list.Add af.Wait(2.5)
					list.Add af.RemoveChild(FraseInfo)	
					list.Add af.AddChild(Explanation)
					list.Add af.AddChild(ExplanationLine2)
					list.Add af.Wait(3)

				'Final Secuencia
					sequence.AddAction af.Repeat(list, -1)
			

			AlphaNumDMD.Run = False
			FlexDMD.LockRenderThread
			FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
			FlexDMD.Stage.RemoveAll
			FlexDMD.Stage.AddActor sequence
			FlexDMD.Show = True
			FlexDMD.UnlockRenderThread	
        
End Sub
	' Final Escena con GIF y Frase


'****************************
'	FraseMediumDMD
'****************************
Sub FraseMediumDMD ( FraseDMD )
		DotMatrix.color = RGB(255, 0, 0)


Dim MediumFont : Set MediumFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f6by12.fnt", vbWhite, vbWhite, 0)
Dim FraseInfo : Set FraseInfo = FlexDMD.NewGroup("Frase")

'------------------------------FRAME INFO COMÚN---------------------------------------------
			Set FraseInfo = FlexDMD.NewGroup("FraseInfo")
				FraseInfo.AddActor FlexDMD.NewFrame("MarcoInfo")
				FraseInfo.GetFrame("MarcoInfo").Thickness = 1
				FraseInfo.GetFrame("MarcoInfo").SetBounds 0, 0, 128, 32

				FraseInfo.AddActor FlexDMD.NewFrame("MarcoInfo2")
				FraseInfo.GetFrame("MarcoInfo2").Thickness = 1
				FraseInfo.GetFrame("MarcoInfo2").SetBounds 2, 2, 124, 28

				FraseInfo.AddActor FlexDMD.NewLabel("InfoText", MediumFont, FraseDMD )
				FraseInfo.GetLabel("InfoText").SetBounds 0, 0, 130, 34

			AlphaNumDMD.Run = False
				FlexDMD.LockRenderThread
				FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
				FlexDMD.Stage.RemoveAll
				FlexDMD.Stage.AddActor FraseInfo
				FlexDMD.Show = True
				FlexDMD.UnlockRenderThread
End Sub

'****************************
'	FraseSmallDMD
'****************************

Sub FraseSmallDMD ( FraseDMD )
	DotMatrix.color =RGB(255, 0, 0)
Dim SmallFont: Set SmallFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f5by7.fnt", vbWhite, vbWhite, 0) 
Dim FraseInfo : Set FraseInfo = FlexDMD.NewGroup("Frase")

'------------------------------FRAME INFO COMÚN---------------------------------------------
			Set FraseInfo = FlexDMD.NewGroup("FraseInfo")
				FraseInfo.AddActor FlexDMD.NewFrame("MarcoInfo")
				FraseInfo.GetFrame("MarcoInfo").Thickness = 1
				FraseInfo.GetFrame("MarcoInfo").SetBounds 0, 0, 128, 32

				FraseInfo.AddActor FlexDMD.NewFrame("MarcoInfo2")
				FraseInfo.GetFrame("MarcoInfo2").Thickness = 1
				FraseInfo.GetFrame("MarcoInfo2").SetBounds 2, 2, 124, 28

				FraseInfo.AddActor FlexDMD.NewLabel("InfoText", SmallFont, FraseDMD )
				FraseInfo.GetLabel("InfoText").SetBounds 0, 0, 130, 34

			AlphaNumDMD.Run = False
				FlexDMD.LockRenderThread
				FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
				FlexDMD.Stage.RemoveAll
				FlexDMD.Stage.AddActor FraseInfo
				FlexDMD.Show = True
				FlexDMD.UnlockRenderThread
End Sub
'****************************
'	DoubleFraseDMD
'****************************

Sub DoubleFraseDMD ( FraseDMD, FraseExplanation)
	DotMatrix.color = RGB(255, 0, 0)
Dim SmallFont: Set SmallFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f5by7.fnt", vbWhite, vbWhite, 0) 
Dim MediumFont : Set MediumFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f6by12.fnt",RGB(125,0,0), vbWhite, 1)
Dim FraseInfo : Set FraseInfo = FlexDMD.NewGroup("Frase")

'------------------------------FRAME INFO COMÚN---------------------------------------------
			Set FraseInfo = FlexDMD.NewGroup("FraseInfo")
				FraseInfo.AddActor FlexDMD.NewFrame("MarcoInfo")
				FraseInfo.GetFrame("MarcoInfo").Thickness = 1
				FraseInfo.GetFrame("MarcoInfo").SetBounds 0, 0, 128, 32

				FraseInfo.AddActor FlexDMD.NewFrame("MarcoInfo2")
				FraseInfo.GetFrame("MarcoInfo2").Thickness = 1
				FraseInfo.GetFrame("MarcoInfo2").SetBounds 2, 2, 124, 28

				FraseInfo.AddActor FlexDMD.NewLabel("InfoText", SmallFont, FraseExplanation )
				FraseInfo.GetLabel("InfoText").SetBounds 0, 8, 130, 34

				FraseInfo.AddActor FlexDMD.NewLabel("InfoText2", MediumFont, FraseDMD )
				FraseInfo.GetLabel("InfoText2").SetBounds 0, -4, 130, 34

			AlphaNumDMD.Run = False
				FlexDMD.LockRenderThread
				FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
				FlexDMD.Stage.RemoveAll
				FlexDMD.Stage.AddActor FraseInfo
				FlexDMD.Show = True
				FlexDMD.UnlockRenderThread
End Sub

'****************************
'	GIF en el DMD en BUMPERS
'****************************

Sub GifDMDBumper()
	DotMatrix.color = RGB(225, 0, 0)
	If GifDMDBumper_active = false Then 

			Dim File_Name_Check
				File_Name_Check = FlexPath & "pelea.gif"

					Dim DMDScene
						'Añande el Gif
						Set DMDScene = FlexDMD.NewGroup("Scene")
					If BumperActivo = 1 then 
						
						If FileExists( File_Name_Check ) Then
							DMDScene.AddActor FlexDMD.NewVideo("Gif", FlexPath &"pelea.gif")
							DMDScene.GetVideo("Gif").SetBounds 0, 0, 128, 32
						DMDScene.GetVideo("Gif").Visible = True
						End If 
						
					End If
							'Añade el Marco
						
				
						DMDScene.AddActor FlexDMD.NewLabel("PuntuacionBumper", FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", RGB(255, 255, 255), vbBlack, 0), ScoreBumpers(CurrentPlayer))
						DMDScene.GetLabel("PuntuacionBumper").SetAlignedPosition 120, 2, FlexDMD_Align_TopRight

						DMDScene.AddActor FlexDMD.NewFrame("Marco")
						DMDScene.GetFrame("Marco").Thickness = 1
						DMDScene.GetFrame("Marco").SetBounds 0, 0, 128, 32
						
					   ' Presenta el DMD
						FlexDMD.LockRenderThread
						
						FlexDMD.Stage.AddActor DMDScene
						FlexDMD.UnlockRenderThread		
						FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
						vpmtimer.addtimer 1000, "BUMPERGIF '"
						ScoreDMDActive =0
						TiempoActivarDMDScore (1100)
						vpmtimer.addtimer 250, "ChangeGifDMDBumper_status '"
				
   End If
End Sub

Sub ChangeGifDMDBumper_status
		GifDMDBumper_active = false
End Sub


'****************************
'	SIMPLE GIf CON FRASE EN DMD 
'****************************
Sub SimpleGifDMDFrase(GifAnimated, Frase)
	DotMatrix.color = RGB(255, 0, 0)

		Dim DMDScene
		
		Dim MediumFont : Set MediumFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f6by12.fnt", vbWhite, vbBlack, 0)
			'Añande el Gif
            Set DMDScene = FlexDMD.NewGroup("Scene")
            'DMDScene.AddActor FlexDMD.NewImage("Back", "VPX.bkempty")
           ' DMDScene.GetImage("Back").SetSize FlexDMD.Width, FlexDMD.Height
			DMDScene.AddActor FlexDMD.NewVideo("Gif", FlexPath & GifAnimated &".gif")
			'Añade el Marco
			DMDScene.GetVideo("Gif").SetBounds 0, 0, 128, 32
			DMDScene.GetVideo("Gif").Visible = True
			DMDScene.AddActor FlexDMD.NewFrame("Marco")
			DMDScene.GetFrame("Marco").Thickness = 1
			DMDScene.GetFrame("Marco").SetBounds 0, 0, 128, 32

			'Añade la frase
			Dim FraseInfo, sequence, af, list
			Set FraseInfo = FlexDMD.NewGroup("FraseInfo")
	
				FraseInfo.AddActor FlexDMD.NewLabel("InfoText", MediumFont, Frase )
				FraseInfo.GetLabel("InfoText").SetBounds 0, 0, 130, 34


           ' Presenta el DMD
           Set sequence = FlexDMD.NewGroup("Sequence")
				sequence.SetSize 128, 32
				Set af = sequence.ActionFactory
				Set list = af.Sequence()
					
					
					list.Add af.AddChild(DMDScene)
					list.Add af.Wait(0.1)		
					list.Add af.AddChild(FraseInfo)	
					list.Add af.Wait(2.5)
					list.Add af.RemoveChild(FraseInfo)	
					

				'Final Secuencia
					sequence.AddAction af.Repeat(list, -1)
			

			AlphaNumDMD.Run = False
			FlexDMD.LockRenderThread
			FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
			FlexDMD.Stage.RemoveAll
			FlexDMD.Stage.AddActor sequence
			FlexDMD.Show = True
			FlexDMD.UnlockRenderThread	
        
End Sub
'****************************
'	Weel of Fortune DMD
'****************************

Sub Weel_Of_fortune_DMD ( )
	DotMatrix.color =RGB(255, 0, 0)
Dim SmallFont: Set SmallFont = FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbWhite, 0) 
Dim Scene , FraseInfo , FrameInfo
 

 Set scene = FlexDMD.NewGroup("Score")	

			
			If FileExists( FlexPath & "Faceman_Background.gif" ) Then
			Scene.AddActor FlexDMD.NewVideo("Gif", FlexPath & "Faceman_Background.gif")
			End If

			scene.AddActor FlexDMD.NewGroup("Marco")
			scene.GetGroup("Marco").Clip = True
			scene.GetGroup("Marco").SetBounds 0, 0, 128, 32

			scene.AddActor FlexDMD.NewGroup("Content_1")
			scene.GetGroup("Content_1").Clip = True
			scene.GetGroup("Content_1").SetBounds 0, 0, 128, 32
			
			'scene.AddActor FlexDMD.NewGroup("Content_2")
			'scene.GetGroup("Content_2").Clip = True
			'scene.GetGroup("Content_2").SetBounds 0, 0, 128, 32
			
'------------------------------FRAME INFO COMÚN---------------------------------------------
			Set FrameInfo = FlexDMD.NewGroup("Marco")
				FrameInfo.AddActor FlexDMD.NewFrame("MarcoInfo")
				FrameInfo.GetFrame("MarcoInfo").Thickness = 1
				FrameInfo.GetFrame("MarcoInfo").SetBounds 0, 0, 128, 32
				FrameInfo.AddActor FlexDMD.NewFrame("MarcoInfo2")
				FrameInfo.GetFrame("MarcoInfo2").Thickness = 2
				FrameInfo.GetFrame("MarcoInfo2").SetBounds 40, 12, 80, 13

			Set FraseInfo = FlexDMD.NewGroup("Frase")

			Dim i 

				for i = 1 to 20

					If i < 11  Then 
					FraseInfo.AddActor FlexDMD.NewLabel("InfoText" & i, SmallFont, Nombre_Sorteo (Draw(CurrentPlayer, i)))
					FraseInfo.GetLabel("InfoText" & i).SetBounds 15, ((8*i)-18), 128, 32

					Else 
					
					FraseInfo.AddActor FlexDMD.NewLabel("InfoText" & i, SmallFont, Nombre_Sorteo (Draw(CurrentPlayer, i -10)))
					FraseInfo.GetLabel("InfoText" & i).SetBounds 15, ((8*(i))-18), 128, 32

					End If
					'FraseInfo.GetLabel("InfoText" & i).SetAlignedPosition 50, 1, FlexDMD_Align_Top
				Next

				'GANADOR SORTEO NUEMRO 9

				'FraseInfo.AddActor FlexDMD.NewLabel("InfoText", SmallFont, Draw(CurrentPlayer, 0)&","& Draw(CurrentPlayer, 1)&","& Draw(CurrentPlayer, 2)&","& Draw(CurrentPlayer, 3)&","& Draw(CurrentPlayer, 4)&","& Draw(CurrentPlayer, 5)&","& Draw(CurrentPlayer, 6)&","& Draw(CurrentPlayer, 7)&","& Draw(CurrentPlayer, 8)&","& Draw(CurrentPlayer, 9)&","&Draw(CurrentPlayer, 10))
				'FraseInfo.GetLabel("InfoText").SetBounds 0, 0, 130, 34
			Dim af, Sequence, list
			Set af = FraseInfo.ActionFactory
					Set list = af.Sequence()
						list.Add af.MoveTo(0, -130, 1.0)

						FraseInfo.AddAction af.Repeat(list, -1)

			scene.GetGroup("Marco").AddActor FrameInfo
			scene.GetGroup("Content_1").AddActor FraseInfo

			AlphaNumDMD.Run = False
				FlexDMD.LockRenderThread
				FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
				FlexDMD.Stage.RemoveAll
				FlexDMD.Stage.AddActor scene
				FlexDMD.Show = True
				FlexDMD.UnlockRenderThread
End Sub
		
'****************************
'	GIF MR LEE DMD
'****************************


Sub MrLeeDMD()
	DotMatrix.color = RGB(255, 0, 0)

		Dim DMDScene
		Dim GifMrLee
 
			GifMrLee ="MR_Lee_Background"

		'GifDMDFrase "MR_LEE_Background", "   MR LEE", MrLee_Value(CurrentPlayer)&" HITS" ,  "FOR CONTACT MR LEE"


		Dim MediumFont : Set MediumFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f6by12.fnt", vbWhite, vbBlack, 1)
		Dim SmallFont: Set SmallFont = FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbBlack, vbWhite, 1)
			'Añande el Gif
            Set DMDScene = FlexDMD.NewGroup("Scene")
            'DMDScene.AddActor FlexDMD.NewImage("Back", "VPX.bkempty")
           ' DMDScene.GetImage("Back").SetSize FlexDMD.Width, FlexDMD.Height
			DMDScene.AddActor FlexDMD.NewVideo("Gif", FlexPath & "MR_Lee_Background.gif")
			'Añade el Marco
			DMDScene.GetVideo("Gif").SetBounds 0, 0, 128, 32
			DMDScene.GetVideo("Gif").Visible = True
			DMDScene.AddActor FlexDMD.NewFrame("Marco")
			DMDScene.GetFrame("Marco").Thickness = 1
			DMDScene.GetFrame("Marco").SetBounds 0, 0, 128, 32

			'Añade la frase
			Dim FraseInfo, sequence, af, list
			Set FraseInfo = FlexDMD.NewGroup("FraseInfo")
	
				FraseInfo.AddActor FlexDMD.NewLabel("InfoText", MediumFont, MrLee_Value(CurrentPlayer)&" HITS TO" )
				FraseInfo.GetLabel("InfoText").SetBounds 15, -5, 130, 34

			Dim Explanation
				Set Explanation = FlexDMD.NewGroup("FraseExplanation")
					Explanation.AddActor FlexDMD.NewLabel("Explanation", SmallFont, " CONTACT MR LEE" )
					Explanation.GetLabel("Explanation").SetBounds 12, 10, 130, 34

           ' Presenta el DMD
           Set sequence = FlexDMD.NewGroup("Sequence")
				sequence.SetSize 128, 32
				Set af = sequence.ActionFactory
				Set list = af.Sequence()
					
					
					list.Add af.AddChild(DMDScene)
					list.Add af.Wait(0.8)		
					list.Add af.AddChild(FraseInfo)							
					list.Add af.AddChild(Explanation)
					list.Add af.Wait(5)

				'Final Secuencia
					sequence.AddAction af.Repeat(list, -1)

			AlphaNumDMD.Run = False
			FlexDMD.LockRenderThread
			FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
			FlexDMD.Stage.RemoveAll
			FlexDMD.Stage.AddActor sequence
			FlexDMD.Show = True
			FlexDMD.UnlockRenderThread	
        
End Sub
	' Final Escena Mr Lee

'****************************
'	Mision en el DMD 
'****************************
Sub MisionDMD

	DotMatrix.color = RGB(255, 0, 0)
		Dim i

		Dim sequence, af, list
		Dim DMDbacground
		Dim DMDNiebla
		Dim DMDScene
		Dim sceneAciva
		Dim sceneactiva
		Dim scene
		Dim SceneCruz

Dim Pos_media (4,3)

Pos_media(0,0) = 34
Pos_media(0,1) = -7

Pos_media(1,0) = 98
Pos_media(1,1) = -7

Pos_media(2,0) = 34
Pos_media(2,1) = 9

Pos_media(3,0) = 98
Pos_media(3,1) = 9


		Set FontScoreActive = FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", RGB(255, 255, 255), vbBlack, 1)
		Set FontScoreInactive = FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", RGB(128, 128, 128), vbWhite, 0)
			
	If Mision(CurrentPlayer,1)>0 Then 'Cuando haya cargado las misiones del jugador

'-----------------------------------------------------MISION ACTIVA-------------------------------------------------

			'CUADROS TRASEROS

			'*------------------*
			'   LOGO BACKGROUND
			'*------------------*

			
					'Añande el Gif
					Set DMDbacground = FlexDMD.NewGroup("Scene")
					DMDbacground.AddActor FlexDMD.NewImage("LogoATeam", FlexPath & "LogoATeam.png")
					DMDbacground.GetImage("LogoATeam").SetBounds 0, 0, 128, 32
					DMDbacground.GetImage("LogoATeam").Visible = True

			'*------------------*
			'  EFECTO TELE
			'*------------------*
					If ContadorMisionDone(CurrentPlayer) < 4 Then 
						'Añande el Gif
						Set DMDNiebla = FlexDMD.NewGroup("Niebla")
						DMDNiebla.AddActor FlexDMD.NewVideo("Niebla", FlexPath & "niebla.gif")
						DMDNiebla.GetGroup("Niebla").SetBounds Pos_mision_Cuadrante(ContadorMisionDone(CurrentPlayer),0), Pos_mision_Cuadrante(ContadorMisionDone(CurrentPlayer),1), 64, 16
					End if 
			'*--------------------------*
			'   BACKGROUND MISION ACTIVA
			'*--------------------------*

			
					'Añande el Gif
					Set DMDScene = FlexDMD.NewGroup("Scene")
					DMDScene.AddActor FlexDMD.NewVideo("Gif", FlexPath & "BackgroundMision.gif")
					DMDScene.GetVideo("Gif").SetBounds Pos_mision_Cuadrante(ContadorMisionDone(CurrentPlayer),0), Pos_mision_Cuadrante(ContadorMisionDone(CurrentPlayer),1), 64, 16
					DMDScene.GetVideo("Gif").Visible = True
					
			'*--------------------------*
			'   TEXTO MISION ACTIVA
			'*--------------------------*

			Set sceneActiva = FlexDMD.NewGroup("Activa")
			sceneActiva.AddActor FlexDMD.NewLabel("Content1", FontScoreActive, OrdenNombreMision(CurrentPlayer,ContadorMisionDone(CurrentPlayer)+1))
			sceneActiva.GetLabel("Content1").SetBounds 0, 0, 64, 32			
			sceneActiva.GetLabel("Content1").SetAlignedPosition Pos_media(ContadorMisionDone(CurrentPlayer),0),Pos_media(ContadorMisionDone(CurrentPlayer),1), FlexDMD_Align_Top
			
			'*--------------------------*
			'   MISIONES RESTANTES
			'*--------------------------*
			
			Set scene = FlexDMD.NewGroup("Inactiva")


			'MISION 2 NOMBRE Y FONDO
				If ContadorMisionDone(CurrentPlayer)=0 Then 

				Scene.AddActor FlexDMD.NewVideo("Gif2", FlexPath & "BackgroundNoMision2.gif")
				Scene.GetVideo("Gif2").SetBounds 64, 0, 64, 17
				Scene.GetVideo("Gif2").Visible = True

				Scene.AddActor FlexDMD.NewGroup("Inactiva2")
				Scene.AddActor FlexDMD.NewLabel("Content2", FontScoreActive, OrdenNombreMision(CurrentPlayer,2))
				Scene.GetLabel("Content2").SetBounds 0, 0, 64, 32			
				Scene.GetLabel("Content2").SetAlignedPosition Pos_media(1,0),Pos_media(1,1), FlexDMD_Align_Top
			
				
				End If


			'MISION 3 NOMBRE Y FONDO
				If ContadorMisionDone(CurrentPlayer)<2 Then 

				Scene.AddActor FlexDMD.NewVideo("Gif3", FlexPath & "BackgroundNoMision3.gif")
				Scene.GetVideo("Gif3").SetBounds 0, 16, 65, 16
				Scene.GetVideo("Gif3").Visible = True

				Scene.AddActor FlexDMD.NewGroup("Inactiva3")
				Scene.AddActor FlexDMD.NewLabel("Content3", FontScoreActive, OrdenNombreMision(CurrentPlayer,3))
				Scene.GetLabel("Content3").SetBounds 0, 0, 64, 32			
				Scene.GetLabel("Content3").SetAlignedPosition Pos_media(2,0),Pos_media(2,1), FlexDMD_Align_Top
				End If

				'MISION 4 NOMBRE Y FONDO
				
				

			If ContadorMisionDone(CurrentPlayer)<3 Then 

				Scene.AddActor FlexDMD.NewVideo("Gif4", FlexPath & "BackgroundNoMision4.gif")
				Scene.GetVideo("Gif4").SetBounds 64, 16, 64, 16
				Scene.GetVideo("Gif4").Visible = True

				Scene.AddActor FlexDMD.NewGroup("Inactiva4")
				Scene.AddActor FlexDMD.NewLabel("Content4", FontScoreActive, OrdenNombreMision(CurrentPlayer,4))
				Scene.GetLabel("Content4").SetBounds 0, 0, 64, 32			
				Scene.GetLabel("Content4").SetAlignedPosition Pos_media(3,0),Pos_media(3,1), FlexDMD_Align_Top
				End If

			'DIVIDE EN CUADRANTES

			
			Set SceneCruz = FlexDMD.NewGroup("sceneCruz")
			If ContadorMisionDone(CurrentPlayer) < 3 Then
					SceneCruz.AddActor FlexDMD.NewImage("Cruz", FlexPath & "Cruz"& ContadorMisionDone(CurrentPlayer) &".png")
					SceneCruz.GetImage("Cruz").SetBounds 0, 0, 128, 32
			End If

            'INICIO SECUENCIA

				
				Set sequence = FlexDMD.NewGroup("Sequence")
				sequence.SetSize 128, 32
				Set af = sequence.ActionFactory
				Set list = af.Sequence()
					
					
					list.Add af.AddChild(DMDbacground)

					list.Add af.Wait(0.5)		
					list.Add af.AddChild(scene)	
					list.Add af.AddChild(DMDScene)
					list.Add af.AddChild(SceneCruz)

				list.Add af.AddChild(DMDNiebla)	
					list.Add af.Wait(0.5)
					list.Add af.RemoveChild(DMDNiebla)			
					list.Add af.AddChild(sceneActiva)
					list.Add af.Wait(0.5)
					list.Add af.RemoveChild(sceneActiva)
					list.Add af.RemoveChild(DMDScene)
					list.Add af.Wait(0.17)	
					list.Add af.AddChild(DMDScene)
					list.Add af.AddChild(sceneActiva)
					list.Add af.Wait(0.5)
					list.Add af.RemoveChild(sceneActiva)
					list.Add af.RemoveChild(DMDScene)			
					list.Add af.Wait(0.17)
					list.Add af.AddChild(DMDScene)	
					list.Add af.AddChild(sceneActiva)
					list.Add af.Wait(0.5)
					list.Add af.RemoveChild(sceneActiva)
					list.Add af.RemoveChild(DMDScene)		
					list.Add af.Wait(0.17)	
					list.Add af.AddChild(DMDScene)
					list.Add af.AddChild(sceneActiva)

				'Final Secuencia
					sequence.AddAction af.Repeat(list, -1)
			

			AlphaNumDMD.Run = False
			FlexDMD.LockRenderThread
			FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
			FlexDMD.Stage.RemoveAll
			FlexDMD.Stage.AddActor sequence
			FlexDMD.Show = True
			FlexDMD.UnlockRenderThread

	End If
	
		vpmtimer.addtimer 2800, "MISION_active_DMD() '"

End Sub
'-----------------------------------------------
'-----------------------------------------------
'-----------------------------------------------


'****************************
'	MISIONACTIVE en el DMD 
'****************************
Sub MISION_active_DMD()
	
          
		Dim i, mensaje, Background_Mision
	Dim MediumFont : Set MediumFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f6by12.fnt", vbWhite, vbWhite, 0)
	Set FontScoreActive = FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbWhite, 0)

	MisionStatusLigth(CurrentPlayer,Mision(CurrentPlayer,0))=2
 
	Dim scene : Set scene = FlexDMD.NewGroup("Score")
	
	If  (Mision(CurrentPlayer, 0)) > 0 Then
		scene.AddActor FlexDMD.NewFrame("Marco")
		scene.GetFrame("Marco").Thickness = 1
		scene.GetFrame("Marco").SetBounds 0, 0, 128, 32
		
		scene.AddActor FlexDMD.NewFrame("Marco2")
		scene.GetFrame("Marco2").Thickness = 1
		scene.GetFrame("Marco2").SetBounds 2, 2, 124, 28

		Dim y : y = Int((Mision(CurrentPlayer,0) - 1) / 2)
		Dim x : x = (Mision(CurrentPlayer,0) - 1) - y * 2

		'Background Mission charge AQUI

		If Pausa_DMD = False Then 
			Set Background_Mision = FlexDMD.NewImage("Background", "VPX.Character&region=" & (x * 128) & "," & (y * 32) & ",128,32")
			Background_Mision.Visible = True
			scene.AddActor Background_Mision

			Pausa_DMD = True
			Pausa200.enabled = True
		End If	

	End If

		'If ContadorMisionDone(CurrentPlayer) ><0 Then
			scene.AddActor FlexDMD.NewLabel("InfoMision_Part1", MediumFont, OrdenNombreMision(Currentplayer,MisionActiva(CurrentPlayer)))
			scene.GetLabel("InfoMision_Part1").SetBounds Pos_temp (Mision(CurrentPlayer, 0)), -5, 100, 34 
			scene.AddActor FlexDMD.NewLabel("InfoMision_Part2", FontScoreActive,"SHOOT THE "& Sub_Mensaje_Mision(Mision(CurrentPlayer, 0)) )
			scene.GetLabel("InfoMision_Part2").SetBounds Pos_temp (Mision(CurrentPlayer, 0)), 7, 100, 34 	
		'End If

	AlphaNumDMD.Run = False
	FlexDMD.LockRenderThread
	FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
	FlexDMD.Stage.RemoveAll
	FlexDMD.Stage.AddActor scene
	FlexDMD.Show = True
	FlexDMD.UnlockRenderThread


Light1.State = MisionStatusLigth(CurrentPlayer,1)
Light2.State = MisionStatusLigth(CurrentPlayer,2)
Light3.State = MisionStatusLigth(CurrentPlayer,3)
Light4.State = MisionStatusLigth(CurrentPlayer,4)

End Sub


'****************************
'	REST OF MISION ACTIVE en el DMD AQUI
Sub Rest_MISION_active_DMD()
	
          
		Mensaje_Mision(1)=(150 - SpinCountMision(CurrentPlayer))
		Mensaje_Mision(2)=(20 - SuperBumperHits(CurrentPlayer))
		Mensaje_Mision(3)=(8 - RampHits3(CurrentPlayer))
		Mensaje_Mision(4)=(8 - TargetHits8(CurrentPlayer))	

	Dim MediumFont : Set MediumFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f6by12.fnt", vbWhite, vbWhite, 0)
	Dim SmallFont: Set SmallFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f5by7.fnt", vbWhite, vbWhite, 0) 
	Dim Background_Mision

	Dim scene : Set scene = FlexDMD.NewGroup("Score")
	MisionStatusLigth(CurrentPlayer,Mision(CurrentPlayer,0))=2
	'Añande el Gif
 If  (Mision(CurrentPlayer, 0)) > 0 Then 
    
	scene.AddActor FlexDMD.NewFrame("Marco")
				scene.GetFrame("Marco").Thickness = 1
				scene.GetFrame("Marco").SetBounds 0, 0, 128, 32
	scene.AddActor FlexDMD.NewFrame("Marco2")
				scene.GetFrame("Marco2").Thickness = 1
				scene.GetFrame("Marco2").SetBounds 2, 2, 124, 28

	If Mision(CurrentPlayer, 0)= 3 Then
		Dmd_Rest_Active = True
	End if

	If Dmd_Rest_Active = True Then 
			'Background Mission charge
		Dim y : y = Int((Mision(CurrentPlayer,0) - 1) / 2)
		Dim x : x = (Mision(CurrentPlayer,0) - 1) - y * 2

		Set Background_Mision = FlexDMD.NewImage("Background", "VPX.Character&region=" & (x * 128) & "," & (y * 32) & ",128,32")
		
			Background_Mision.Visible = True
			scene.AddActor Background_Mision
		
	End If
			scene.AddActor FlexDMD.NewLabel("InfoMision_Part1", MediumFont, Mensaje_Mision(Mision(CurrentPlayer, 0))&" "&Sub_Mensaje_Mision(Mision(CurrentPlayer, 0)))
				scene.GetLabel("InfoMision_Part1").SetBounds Pos_temp (Mision(CurrentPlayer, 0)), -5, 100, 34 
			scene.AddActor FlexDMD.NewLabel("InfoMision_Part2", SmallFont,"TO COMPLETE" )
				scene.GetLabel("InfoMision_Part2").SetBounds Pos_temp (Mision(CurrentPlayer, 0)), 7, 100, 34 	
End if	

	AlphaNumDMD.Run = False
	FlexDMD.LockRenderThread
	FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
	FlexDMD.Stage.RemoveAll
	FlexDMD.Stage.AddActor scene
	FlexDMD.Show = True
	FlexDMD.UnlockRenderThread
	
	
    Light1.State = MisionStatusLigth(CurrentPlayer,1)
	Light2.State = MisionStatusLigth(CurrentPlayer,2)
    Light3.State = MisionStatusLigth(CurrentPlayer,3)	
	Light4.State = MisionStatusLigth(CurrentPlayer,4)

	

End Sub

'****************************
'	DMD in HANNIBAL TARGET MISION 
'****************************
Sub Hannibal_Targets_MisionDMD(Target)

	DotMatrix.color = RGB(255, 0, 0)
			ScoreDMDActive =0
			TiempoActivarDMDScore(2000)

	Dim Letter1,Letter2, Letter3, Letter4
	Letter1= "T"
	Letter2= "E"
	Letter3= "A"
	Letter4= "M"

	Dim af, list
				Dim  scene1, scene2, scene3, scene4, FrameDMD
				
				Dim FontBigBig2 : Set FontBigBig2 = FlexDMD.NewFont("FlexDMD.Resources.udmd-f12by24.fnt", vbWhite,RGB(125, 125, 125), 1)
				Dim FontBigBig: Set FontBigBig = FlexDMD.NewFont("FlexDMD.Resources.udmd-f12by24.fnt", vbBlack, vbWhite, 1)
				 	
			
			Dim scene : Set scene = FlexDMD.NewGroup("Score")	

			scene.AddActor FlexDMD.NewGroup("Marco")
			scene.GetGroup("Marco").Clip = True
			scene.GetGroup("Marco").SetBounds 0, 0, 128, 32

			scene.AddActor FlexDMD.NewGroup("Content_1")
			scene.GetGroup("Content_1").Clip = True
			scene.GetGroup("Content_1").SetBounds 0, 0, 128, 32
			
			scene.AddActor FlexDMD.NewGroup("Content_2")
			scene.GetGroup("Content_2").Clip = True
			scene.GetGroup("Content_2").SetBounds 0, 0, 128, 32
			
			scene.AddActor FlexDMD.NewGroup("Content_3")
			scene.GetGroup("Content_3").Clip = True
			scene.GetGroup("Content_3").SetBounds 0, 0, 128, 32

			scene.AddActor FlexDMD.NewGroup("Content_4")
			scene.GetGroup("Content_4").Clip = True
			scene.GetGroup("Content_4").SetBounds 0, 0, 128, 32

'------------------------------FRAME & BACKGROUND---------------------------------------------

			Set FrameDMD = FlexDMD.NewGroup("Frame")

				FrameDMD.AddActor FlexDMD.NewFrame("Marco")
				FrameDMD.GetFrame("Marco").Thickness = 1
				FrameDMD.GetFrame("Marco").SetBounds 0, 0, 128, 32

'--------------------------------- THE A TEAM SPELL---------------------------------------

			Set scene1 = FlexDMD.NewGroup("Letter_T")

				If Target >< 1 Then 
					scene1.AddActor FlexDMD.NewLabel("Letter_1A",FontBigBig ,Letter1)
					scene1.GetLabel("Letter_1A").SetAlignedPosition 15,(4 + (TargetS1_Status (CurrentPlayer))*25) , FlexDMD_Align_TopLeft	
					scene1.AddActor FlexDMD.NewLabel("Letter_1B",FontBigBig2 ,Letter1)
					scene1.GetLabel("Letter_1B").SetAlignedPosition 15,(4 + (TargetS1_Status (CurrentPlayer))*25) , FlexDMD_Align_TopLeft
					scene1.AddActor FlexDMD.NewFrame("Marco1")
					scene1.GetFrame("Marco1").Thickness = 1
					scene1.GetFrame("Marco1").SetBounds 8, (2 + (TargetS1_Status (CurrentPlayer))*25), 26, 28	
				Else
					scene1.AddActor FlexDMD.NewLabel("Letter_1A",FontBigBig ,Letter1)
					scene1.GetLabel("Letter_1A").SetAlignedPosition 15, 4 , FlexDMD_Align_TopLeft	
					scene1.AddActor FlexDMD.NewLabel("Letter_1B",FontBigBig2 ,Letter1)
					scene1.GetLabel("Letter_1B").SetAlignedPosition 15, 4 , FlexDMD_Align_TopLeft
					scene1.AddActor FlexDMD.NewFrame("Marco1")
					scene1.GetFrame("Marco1").Thickness = 1
					scene1.GetFrame("Marco1").SetBounds 8, 2 , 26, 28
					
					Set af = scene1.ActionFactory
					Set list = af.Sequence()
						list.Add af.MoveTo(0, 25, 1.0)
						scene1.AddAction af.Repeat(list, -1)
				End if

			Set scene2 = FlexDMD.NewGroup("Letter_E")

				If Target >< 2 Then
					scene2.AddActor FlexDMD.NewLabel("Letter_2A",FontBigBig ,Letter2)
					scene2.GetLabel("Letter_2A").SetAlignedPosition 44,(4 + (TargetS2_Status (CurrentPlayer))*25), FlexDMD_Align_TopLeft	
					scene2.AddActor FlexDMD.NewLabel("Letter_2B",FontBigBig2 ,Letter2)
					scene2.GetLabel("Letter_2B").SetAlignedPosition 44,(4 + (TargetS2_Status (CurrentPlayer))*25), FlexDMD_Align_TopLeft
					scene2.AddActor FlexDMD.NewFrame("Marco2")
					scene2.GetFrame("Marco2").Thickness = 1
					scene2.GetFrame("Marco2").SetBounds 37, (2 + (TargetS2_Status (CurrentPlayer))*25), 26, 28
				Else 
					scene2.AddActor FlexDMD.NewLabel("Letter_2A",FontBigBig ,Letter2)
					scene2.GetLabel("Letter_2A").SetAlignedPosition 44, 4, FlexDMD_Align_TopLeft	
					scene2.AddActor FlexDMD.NewLabel("Letter_2B",FontBigBig2 ,Letter2)
					scene2.GetLabel("Letter_2B").SetAlignedPosition 44, 4, FlexDMD_Align_TopLeft
					scene2.AddActor FlexDMD.NewFrame("Marco2")
					scene2.GetFrame("Marco2").Thickness = 1
					scene2.GetFrame("Marco2").SetBounds 37, 2, 26, 28
		
					Set af = scene2.ActionFactory
					Set list = af.Sequence()
						list.Add af.MoveTo(0, 25, 1.0)
						scene2.AddAction af.Repeat(list, -1)
				End if

			Set scene3 = FlexDMD.NewGroup("Letter_A")
	
				If Target >< 3 Then
					scene3.AddActor FlexDMD.NewLabel("Letter_3A",FontBigBig ,Letter3)
					scene3.GetLabel("Letter_3A").SetAlignedPosition 73,(4 + (TargetS3_Status (CurrentPlayer))*25), FlexDMD_Align_TopLeft	
					scene3.AddActor FlexDMD.NewLabel("Letter_3B",FontBigBig2 ,Letter3)
					scene3.GetLabel("Letter_3B").SetAlignedPosition 73,(4 + (TargetS3_Status (CurrentPlayer))*25), FlexDMD_Align_TopLeft
					scene3.AddActor FlexDMD.NewFrame("Marco3")
					scene3.GetFrame("Marco3").Thickness = 1
					scene3.GetFrame("Marco3").SetBounds 66,(2 + (TargetS3_Status (CurrentPlayer))*25), 26, 28
				Else
					scene3.AddActor FlexDMD.NewLabel("Letter_3A",FontBigBig ,Letter3)
					scene3.GetLabel("Letter_3A").SetAlignedPosition 73, 4, FlexDMD_Align_TopLeft	
					scene3.AddActor FlexDMD.NewLabel("Letter_3B",FontBigBig2 ,Letter3)
					scene3.GetLabel("Letter_3B").SetAlignedPosition 73, 4, FlexDMD_Align_TopLeft
					scene3.AddActor FlexDMD.NewFrame("Marco3")
					scene3.GetFrame("Marco3").Thickness = 1
					scene3.GetFrame("Marco3").SetBounds 66, 2, 26, 28
					
					Set af = scene3.ActionFactory
					Set list = af.Sequence()
						list.Add af.MoveTo(0, 25, 1.0)
						scene3.AddAction af.Repeat(list, -1)
				End if
	
			Set scene4 = FlexDMD.NewGroup("Letter_M")
			
				If Target >< 4 Then
					scene4.AddActor FlexDMD.NewLabel("Letter_4A",FontBigBig ,Letter4)
					scene4.GetLabel("Letter_4A").SetAlignedPosition 102, (4 + (TargetS4_Status (CurrentPlayer))*25), FlexDMD_Align_TopLeft	
					scene4.AddActor FlexDMD.NewLabel("Letter_4B",FontBigBig2 ,Letter4)
					scene4.GetLabel("Letter_4B").SetAlignedPosition 102, (4 + (TargetS4_Status (CurrentPlayer))*25), FlexDMD_Align_TopLeft
					scene4.AddActor FlexDMD.NewFrame("Marco4")
					scene4.GetFrame("Marco4").Thickness = 1
					scene4.GetFrame("Marco4").SetBounds 95,(2 + (TargetS4_Status (CurrentPlayer))*25), 26, 28
				Else		
					scene4.AddActor FlexDMD.NewLabel("Letter_4A",FontBigBig ,Letter4)
					scene4.GetLabel("Letter_4A").SetAlignedPosition 102, 4, FlexDMD_Align_TopLeft	
					scene4.AddActor FlexDMD.NewLabel("Letter_4B",FontBigBig2 ,Letter4)
					scene4.GetLabel("Letter_4B").SetAlignedPosition 102, 4, FlexDMD_Align_TopLeft
					scene4.AddActor FlexDMD.NewFrame("Marco4")
					scene4.GetFrame("Marco4").Thickness = 1
					scene4.GetFrame("Marco4").SetBounds 95, 2, 26, 28
					
					Set af = scene4.ActionFactory
					Set list = af.Sequence()
						list.Add af.MoveTo(0, 25, 1.0)
						scene4.AddAction af.Repeat(list, -1)
				End if

			scene.GetGroup("Marco").AddActor FrameDMD
			scene.GetGroup("Content_1").AddActor scene1
			scene.GetGroup("Content_2").AddActor scene2
			scene.GetGroup("Content_3").AddActor scene3
			scene.GetGroup("Content_4").AddActor scene4

	AlphaNumDMD.Run = False
	FlexDMD.LockRenderThread
	FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
	FlexDMD.Stage.RemoveAll
	FlexDMD.Stage.AddActor scene
	FlexDMD.Show = True
	FlexDMD.UnlockRenderThread

End Sub

'****************************
'		DMD InstantInfo
'****************************

Sub InstantInfo

    DotMatrix.color = RGB(255, 0, 0)

			Dim af, list, Background_Mision
			Dim SceneTextHighScores, scene, scene1, scene2, scene3, scene4, FrameInfo, InstantInfoDMD, SpinnerValueDMD, BumperValueDMD
			Dim BonusValueDMD, PlayfieldValueDMD
			Dim MediumFont : Set MediumFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f6by12.fnt", vbWhite, vbWhite, 0)
			Dim FontScoreActive: Set FontScoreActive = FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbWhite, 0)
			Dim FontBigBig: Set FontBigBig = FlexDMD.NewFont("FlexDMD.Resources.udmd-f12by24.fnt", vbWhite, vbBlack, 1)
			Dim SmallFont: Set SmallFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f5by7.fnt", vbWhite, vbWhite, 0) 	
    
   
    'DMD CL("LOCKED BALLS"), CL(BallsInLock(CurrentPlayer)), "", eNone, eNone, eNone, 800, False, ""
    'DMD CL("LANE BONUS"), CL(LaneBonus), "", eNone, eNone, eNone, 800, False, ""
    'DMD CL("TARGET BONUS"), CL(TargetBonus), "", eNone, eNone, eNone, 800, False, ""
    'DMD CL("RAMP BONUS"), CL(RampBonus), "", eNone, eNone, eNone, 800, False, ""
    'DMD CL("MONSTERS KILLED"), CL(MonstersKilled(CurrentPlayer)), "", eNone, eNone, eNone, 800, False, ""
    'DMD CL("HIGHEST SCORE"), CL(HighScoreName(0) & " " & HighScore(0)), "", eNone, eNone, eNone, 800, False, ""

'------------------------------FRAME INFO COMÚN---------------------------------------------
			Set FrameInfo = FlexDMD.NewGroup("FrameInfo")
				FrameInfo.AddActor FlexDMD.NewFrame("MarcoInfo")
				FrameInfo.GetFrame("MarcoInfo").Thickness = 1
				FrameInfo.GetFrame("MarcoInfo").SetBounds 0, 0, 128, 32

				FrameInfo.AddActor FlexDMD.NewFrame("MarcoInfo2")
				FrameInfo.GetFrame("MarcoInfo2").Thickness = 1
				FrameInfo.GetFrame("MarcoInfo2").SetBounds 2, 2, 124, 28

'------------------------------INSTANT INFO TEXT---------------------------------------------
			Set InstantInfoDMD = FlexDMD.NewGroup("InstantInfoText")
				
				InstantInfoDMD.AddActor FlexDMD.NewLabel("InfoText", MediumFont, "Instant Info" )
				InstantInfoDMD.GetLabel("InfoText").SetBounds 0, 0, 130, 34
'------------------------------MISION ACTIVE---------------------------------------------
		

			Dim MisionActiveDMD : Set MisionActiveDMD = FlexDMD.NewGroup("Character")

		Mensaje_Mision(1)=(150 - SpinCountMision(CurrentPlayer))
		Mensaje_Mision(2)=(20 - SuperBumperHits(CurrentPlayer))
		Mensaje_Mision(3)=(8 - RampHits3(CurrentPlayer))
		Mensaje_Mision(4)=(8 - TargetHits8(CurrentPlayer))	
				
			If Mision(CurrentPlayer,0) = 0 Then 'Indica no hay misión
					
				MisionActiveDMD.AddActor FlexDMD.NewLabel("InfoText", MediumFont, "No Mision Select" )
				MisionActiveDMD.GetLabel("InfoText").SetBounds 0, -5, 130, 34
				MisionActiveDMD.AddActor FlexDMD.NewLabel("InfoText2", SmallFont, "SHOOT THE VAN" )
				MisionActiveDMD.GetLabel("InfoText2").SetBounds 0, 7, 130, 34
				
			End If

			If Mision(CurrentPlayer,0) > 0 Then 'Añande el Gif
				Dim y : y = Int((Mision(CurrentPlayer,0) - 1) / 2)
				Dim x : x = (Mision(CurrentPlayer,0) - 1) - y * 2
				Set Background_Mision = FlexDMD.NewImage("Background", "VPX.Character&region=" & (x * 128) & "," & (y * 32) & ",128,32")
					Background_Mision.Visible = True
					MisionActiveDMD.AddActor Background_Mision
			MisionActiveDMD.AddActor FlexDMD.NewLabel("InfoMision_Part1", MediumFont, Mensaje_Mision(Mision(CurrentPlayer, 0))&" "&Sub_Mensaje_Mision(Mision(CurrentPlayer, 0)))
				MisionActiveDMD.GetLabel("InfoMision_Part1").SetBounds Pos_temp (Mision(CurrentPlayer, 0)), -5, 100, 34 
			MisionActiveDMD.AddActor FlexDMD.NewLabel("InfoMision_Part2", SmallFont,"TO COMPLETE" )
				MisionActiveDMD.GetLabel("InfoMision_Part2").SetBounds Pos_temp (Mision(CurrentPlayer, 0)), 7, 100, 34 	

			End if

'------------------------------SPINNER VALUE---------------------------------------------
			Set SpinnerValueDMD = FlexDMD.NewGroup("ValueSpinnerText")
				
				SpinnerValueDMD.AddActor FlexDMD.NewLabel("SpinnerText", SmallFont, "Spinner Value "& spinnervalue(CurrentPlayer))
				SpinnerValueDMD.GetLabel("SpinnerText").SetBounds 0, 0, 130, 34

'------------------------------BUMPER VALUE---------------------------------------------
			Set BumperValueDMD = FlexDMD.NewGroup("ValueBumperText")
				
				BumperValueDMD.AddActor FlexDMD.NewLabel("BumperText", SmallFont, "Bumper Value "& bumpervalue(CurrentPlayer))
				BumperValueDMD.GetLabel("BumperText").SetBounds 0, 0, 130, 34

'------------------------------BONUS X---------------------------------------------
			Set BonusValueDMD = FlexDMD.NewGroup("ValueBonusText")
				
				BonusValueDMD.AddActor FlexDMD.NewLabel("BonusText", SmallFont, "Bonus X "& bumpervalue(CurrentPlayer))
				BonusValueDMD.GetLabel("BonusText").SetBounds 0, 0, 130, 34

'------------------------------PLAYFIELD X---------------------------------------------
			Set PlayfieldValueDMD = FlexDMD.NewGroup("ValuePlayfieldText")
				
				PlayfieldValueDMD.AddActor FlexDMD.NewLabel("PlayfieldText", SmallFont, "Playfield X "& BonusMultiplier(CurrentPlayer))
				PlayfieldValueDMD.GetLabel("PlayfieldText").SetBounds 0, 0, 130, 34

'------------------------------HIGHSCORES---------------------------------------------
		'Marco común HIGHSCORES
			Set scene = FlexDMD.NewGroup("ScoreMarco")
			scene.AddActor FlexDMD.NewFrame("Marco")
						scene.GetFrame("Marco").Thickness = 1
						scene.GetFrame("Marco").SetBounds 2, 2, 46, 28
			scene.AddActor FlexDMD.NewFrame("Marco2")
						scene.GetFrame("Marco2").Thickness = 1
						scene.GetFrame("Marco2").SetBounds 50, 12, 76, 18
			scene.AddActor FlexDMD.NewFrame("Marco3")
						scene.GetFrame("Marco3").Thickness = 1
						scene.GetFrame("Marco3").SetBounds 117, 2, 9, 9

		'Text TOP HIGHSCORES
			Set SceneTextHighScores = FlexDMD.NewGroup("TextHighScores")
			SceneTextHighScores.AddActor FlexDMD.NewLabel("HighScore_tittle",FontScoreActive ,"TOP HIGHSCORES")
			SceneTextHighScores.GetLabel("HighScore_tittle").SetAlignedPosition 84, 4, FlexDMD_Align_Top
			
		'HighScore 1 Presentación
			Set scene1 = FlexDMD.NewGroup("Score1")
			scene1.AddActor FlexDMD.NewLabel("position1",FontScoreActive ,1)
			scene1.GetLabel("position1").SetAlignedPosition 120, 4, FlexDMD_Align_TopLeft	

			scene1.AddActor FlexDMD.NewLabel("HighScore1_Name",FontBigBig ,HighScoreName(0))
			scene1.GetLabel("HighScore1_Name").SetAlignedPosition 4, 4, FlexDMD_Align_TopLeft			

			scene1.AddActor FlexDMD.NewLabel("HighScore1", MediumFont ,HighScore(0))
			scene1.GetLabel("HighScore1").SetAlignedPosition 88, 15, FlexDMD_Align_Top	
			
		'HighScore 2 Presentación
			Set scene2 = FlexDMD.NewGroup("Score2")
			scene2.AddActor FlexDMD.NewLabel("position2",FontScoreActive ,2)
			scene2.GetLabel("position2").SetAlignedPosition 120, 4, FlexDMD_Align_TopLeft	

			scene2.AddActor FlexDMD.NewLabel("HighScore2_Name",FontBigBig ,HighScoreName(1))
			scene2.GetLabel("HighScore2_Name").SetAlignedPosition 4, 4, FlexDMD_Align_TopLeft			

			scene2.AddActor FlexDMD.NewLabel("HighScore2", MediumFont ,HighScore(1))
			scene2.GetLabel("HighScore2").SetAlignedPosition 88, 15, FlexDMD_Align_Top	
			
		'HighScore 3 Presentación 
			Set scene3 = FlexDMD.NewGroup("Score3")
			scene3.AddActor FlexDMD.NewLabel("position3",FontScoreActive ,3)
			scene3.GetLabel("position3").SetAlignedPosition 120, 4, FlexDMD_Align_TopLeft	

			scene3.AddActor FlexDMD.NewLabel("HighScore3_Name",FontBigBig ,HighScoreName(2))
			scene3.GetLabel("HighScore3_Name").SetAlignedPosition 4, 4, FlexDMD_Align_TopLeft			

			scene3.AddActor FlexDMD.NewLabel("HighScore3", MediumFont ,HighScore(2))
			scene3.GetLabel("HighScore3").SetAlignedPosition 88, 15, FlexDMD_Align_Top
			
		'HighScore 4 Presentación 
			Set scene4 = FlexDMD.NewGroup("Score4")
			scene4.AddActor FlexDMD.NewLabel("position4",FontScoreActive ,4)
			scene4.GetLabel("position4").SetAlignedPosition 120, 4, FlexDMD_Align_TopLeft	

			scene4.AddActor FlexDMD.NewLabel("HighScore4_Name",FontBigBig ,HighScoreName(3))
			scene4.GetLabel("HighScore4_Name").SetAlignedPosition 4, 4, FlexDMD_Align_TopLeft			

			scene4.AddActor FlexDMD.NewLabel("HighScore4", MediumFont ,HighScore(3))
			scene4.GetLabel("HighScore4").SetAlignedPosition 88, 15, FlexDMD_Align_Top
		
			
		'SECUENCIA FINAL Instant Info
			Dim sequence
			Set sequence = FlexDMD.NewGroup("Sequence")
			sequence.SetSize 128, 32
			Set af = sequence.ActionFactory
			Set list = af.Sequence()
		'Presenta la version
				'FrameInfo
				list.Add af.AddChild(FrameInfo)	
				'InstantInfo
				list.Add af.AddChild(InstantInfoDMD)
				list.Add af.Wait(1)
				list.Add af.RemoveChild(InstantInfoDMD)
				'MisionActive
				list.Add af.AddChild(MisionActiveDMD)
				list.Add af.Wait(3)
				list.Add af.RemoveChild(MisionActiveDMD)
				'SpinnerValue
				list.Add af.AddChild(SpinnerValueDMD)
				list.Add af.Wait(2)
				list.Add af.RemoveChild(SpinnerValueDMD)
				'BumperValue
				list.Add af.AddChild(BumperValueDMD)
				list.Add af.Wait(2)
				list.Add af.RemoveChild(BumperValueDMD)
				'BonusValue
				list.Add af.AddChild(BonusValueDMD)
				list.Add af.Wait(2)
				list.Add af.RemoveChild(BonusValueDMD)
				'PlayfieldValue
				list.Add af.AddChild(PlayfieldValueDMD)
				list.Add af.Wait(2)
				list.Add af.RemoveChild(PlayfieldValueDMD)
				'
				list.Add af.AddChild(scene)
				list.Add af.AddChild(SceneTextHighScores)
				list.Add af.AddChild(scene1)
				list.Add af.Wait(3)
				list.Add af.RemoveChild(scene1)
				list.Add af.AddChild(scene2)
				list.Add af.Wait(3)
				list.Add af.RemoveChild(scene2)
				list.Add af.AddChild(scene3)
				list.Add af.Wait(3)
				list.Add af.RemoveChild(scene3)
				list.Add af.AddChild(scene4)
				list.Add af.Wait(3)
				list.Add af.RemoveChild(scene4)
				list.Add af.RemoveChild(SceneTextHighScores)
				list.Add af.RemoveChild(scene)

			sequence.AddAction af.Repeat(list, -1)

			FlexDMD.LockRenderThread
			FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
			FlexDMD.Stage.RemoveAll
			FlexDMD.Stage.AddActor sequence
			FlexDMD.UnlockRenderThread		
End Sub

'****************************
'		DMD HighScore
'****************************

Sub DMDHighScore ()
		DotMatrix.color = RGB(255, 0, 0)

			Dim af, list
			Dim SceneTextHighScores, scene, scene1, scene2, scene3, scene4, FrameInfo, InstantInfoDMD, SpinnerValueDMD, BumperValueDMD
			Dim BonusValueDMD, PlayfieldValueDMD
			Dim FontBig : Set FontBig = FlexDMD.NewFont("FlexDMD.Resources.udmd-f7by13.fnt", vbWhite, vbBlack, 1)
			Dim MediumFont : Set MediumFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f6by12.fnt", vbWhite, vbWhite, 0)
			Dim FontScoreActive: Set FontScoreActive = FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbWhite, 0)
			Dim FontBigBig: Set FontBigBig = FlexDMD.NewFont("FlexDMD.Resources.udmd-f12by24.fnt", vbWhite, vbBlack, 1)
			Dim SmallFont: Set SmallFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f5by7.fnt", vbWhite, vbWhite, 0) 	
    
'------------------------------FRAME INFO COMÚN---------------------------------------------
			Set FrameInfo = FlexDMD.NewGroup("FrameInfo")
				FrameInfo.AddActor FlexDMD.NewFrame("MarcoInfo")
				FrameInfo.GetFrame("MarcoInfo").Thickness = 1
				FrameInfo.GetFrame("MarcoInfo").SetBounds 0, 0, 128, 32

				FrameInfo.AddActor FlexDMD.NewFrame("MarcoInfo2")
				FrameInfo.GetFrame("MarcoInfo2").Thickness = 1
				FrameInfo.GetFrame("MarcoInfo2").SetBounds 2, 2, 124, 28

'------------------------------INSTANT INFO TEXT---------------------------------------------
			Set InstantInfoDMD = FlexDMD.NewGroup("InstantInfoText")
				
				InstantInfoDMD.AddActor FlexDMD.NewLabel("InfoText", MediumFont, "HIGHSCORES" )
				InstantInfoDMD.GetLabel("InfoText").SetBounds 0, 0, 130, 34

'------------------------------HIGHSCORES---------------------------------------------
		'Marco común HIGHSCORES
			Set scene = FlexDMD.NewGroup("ScoreMarco")
			scene.AddActor FlexDMD.NewFrame("Marco")
						scene.GetFrame("Marco").Thickness = 1
						scene.GetFrame("Marco").SetBounds 2, 2, 46, 28
			scene.AddActor FlexDMD.NewFrame("Marco2")
						scene.GetFrame("Marco2").Thickness = 1
						scene.GetFrame("Marco2").SetBounds 50, 12, 76, 18
			scene.AddActor FlexDMD.NewFrame("Marco3")
						scene.GetFrame("Marco3").Thickness = 1
						scene.GetFrame("Marco3").SetBounds 117, 2, 9, 9

		'Text TOP HIGHSCORES
			Set SceneTextHighScores = FlexDMD.NewGroup("TextHighScores")
			SceneTextHighScores.AddActor FlexDMD.NewLabel("HighScore_tittle",FontScoreActive ,"TOP HIGHSCORES")
			SceneTextHighScores.GetLabel("HighScore_tittle").SetAlignedPosition 84, 4, FlexDMD_Align_Top
			
		'HighScore 1 Presentación
			Set scene1 = FlexDMD.NewGroup("Score1")
			scene1.AddActor FlexDMD.NewLabel("position1",FontScoreActive ,1)
			scene1.GetLabel("position1").SetAlignedPosition 120, 4, FlexDMD_Align_TopLeft	

			scene1.AddActor FlexDMD.NewLabel("HighScore1_Name",FontBigBig ,HighScoreName(0))
			scene1.GetLabel("HighScore1_Name").SetAlignedPosition 4, 4, FlexDMD_Align_TopLeft			

			scene1.AddActor FlexDMD.NewLabel("HighScore1", MediumFont ,HighScore(0))
			scene1.GetLabel("HighScore1").SetAlignedPosition 88, 15, FlexDMD_Align_Top	
			
		'HighScore 2 Presentación
			Set scene2 = FlexDMD.NewGroup("Score2")
			scene2.AddActor FlexDMD.NewLabel("position2",FontScoreActive ,2)
			scene2.GetLabel("position2").SetAlignedPosition 120, 4, FlexDMD_Align_TopLeft	

			scene2.AddActor FlexDMD.NewLabel("HighScore2_Name",FontBigBig ,HighScoreName(1))
			scene2.GetLabel("HighScore2_Name").SetAlignedPosition 4, 4, FlexDMD_Align_TopLeft			

			scene2.AddActor FlexDMD.NewLabel("HighScore2", MediumFont ,HighScore(1))
			scene2.GetLabel("HighScore2").SetAlignedPosition 88, 15, FlexDMD_Align_Top	
			
		'HighScore 3 Presentación 
			Set scene3 = FlexDMD.NewGroup("Score3")
			scene3.AddActor FlexDMD.NewLabel("position3",FontScoreActive ,3)
			scene3.GetLabel("position3").SetAlignedPosition 120, 4, FlexDMD_Align_TopLeft	

			scene3.AddActor FlexDMD.NewLabel("HighScore3_Name",FontBigBig ,HighScoreName(2))
			scene3.GetLabel("HighScore3_Name").SetAlignedPosition 4, 4, FlexDMD_Align_TopLeft			

			scene3.AddActor FlexDMD.NewLabel("HighScore3", MediumFont ,HighScore(2))
			scene3.GetLabel("HighScore3").SetAlignedPosition 88, 15, FlexDMD_Align_Top
			
		'HighScore 4 Presentación 
			Set scene4 = FlexDMD.NewGroup("Score4")
			scene4.AddActor FlexDMD.NewLabel("position4",FontScoreActive ,4)
			scene4.GetLabel("position4").SetAlignedPosition 120, 4, FlexDMD_Align_TopLeft	

			scene4.AddActor FlexDMD.NewLabel("HighScore4_Name",FontBigBig ,HighScoreName(3))
			scene4.GetLabel("HighScore4_Name").SetAlignedPosition 4, 4, FlexDMD_Align_TopLeft			

			scene4.AddActor FlexDMD.NewLabel("HighScore4", MediumFont ,HighScore(3))
			scene4.GetLabel("HighScore4").SetAlignedPosition 88, 15, FlexDMD_Align_Top
		
			
		'SECUENCIA FINAL Instant Info
			Dim sequence
			Set sequence = FlexDMD.NewGroup("Sequence")
			sequence.SetSize 128, 32
			Set af = sequence.ActionFactory
			Set list = af.Sequence()
		'Presenta la version
				'FrameInfo
				list.Add af.AddChild(FrameInfo)	
				'InstantInfo
				list.Add af.AddChild(InstantInfoDMD)
				list.Add af.Wait(1)
				list.Add af.RemoveChild(InstantInfoDMD)
				'
				list.Add af.AddChild(scene)
				list.Add af.AddChild(SceneTextHighScores)
				list.Add af.AddChild(scene1)
				list.Add af.Wait(3)
				list.Add af.RemoveChild(scene1)
				list.Add af.AddChild(scene2)
				list.Add af.Wait(3)
				list.Add af.RemoveChild(scene2)
				list.Add af.AddChild(scene3)
				list.Add af.Wait(3)
				list.Add af.RemoveChild(scene3)
				list.Add af.AddChild(scene4)
				list.Add af.Wait(3)
				list.Add af.RemoveChild(scene4)
				list.Add af.RemoveChild(scene)
				list.Add af.RemoveChild(SceneTextHighScores)

			sequence.AddAction af.Repeat(list, -1)

			FlexDMD.LockRenderThread
			FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
			FlexDMD.Stage.RemoveAll
			FlexDMD.Stage.AddActor sequence
			FlexDMD.UnlockRenderThread		
			

		End Sub
		' Final Escena Presentación


'****************************
'		DMD HighScoreNAME
'****************************

Sub HighScoreDisplayName()
    Dim i
    Dim TempTopStr
    Dim TempBotStr



    TempTopStr = "YOUR NAME:"
    dLine(0) = ExpandLine(TempTopStr)
    'DMDUpdate 0

    TempBotStr = ""
    if(hsCurrentDigit > 0)then TempBotStr = TempBotStr & hsEnteredDigits(0)
    if(hsCurrentDigit > 1)then TempBotStr = TempBotStr & hsEnteredDigits(1)
    if(hsCurrentDigit > 2)then TempBotStr = TempBotStr & hsEnteredDigits(2)

    if(hsCurrentDigit <> 3)then
        if(hsLetterFlash <> 0)then
            TempBotStr = TempBotStr & " "
        else
            TempBotStr = TempBotStr & mid(hsValidLetters, hsCurrentLetter, 1)
        end if
    end if

    if(hsCurrentDigit < 1)then TempBotStr = TempBotStr & hsEnteredDigits(1)
    if(hsCurrentDigit < 2)then TempBotStr = TempBotStr & hsEnteredDigits(2)

    TempBotStr = TempBotStr & ""
    dLine(1) = ExpandLine(TempBotStr)
   
	'TEXT IN DMD



			DotMatrix.color = RGB(255, 0, 0)

			Dim af, list
			Dim scene, scene1, scene2, scene3, scene4 
			Dim FontBig : Set FontBig = FlexDMD.NewFont("FlexDMD.Resources.udmd-f7by13.fnt", vbWhite, vbBlack, 1)
			Dim MediumFont : Set MediumFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f6by12.fnt", vbWhite, vbWhite, 0)
			Dim FontScoreActive: Set FontScoreActive = FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbWhite, 0)
			Dim FontBigBig: Set FontBigBig = FlexDMD.NewFont("FlexDMD.Resources.udmd-f12by24.fnt", vbWhite, vbBlack, 1)

		'Marco común
			Set scene = FlexDMD.NewGroup("ScoreMarco")
			scene.AddActor FlexDMD.NewFrame("Marco")
						scene.GetFrame("Marco").Thickness = 1
						scene.GetFrame("Marco").SetBounds 2, 2, 46, 28
			scene.AddActor FlexDMD.NewFrame("MarcoInfo2")
						scene.GetFrame("MarcoInfo2").Thickness = 1
						scene.GetFrame("MarcoInfo2").SetBounds 2, 2, 124, 28
			scene.AddActor FlexDMD.NewFrame("Marco2")
						scene.GetFrame("Marco2").Thickness = 1
						scene.GetFrame("Marco2").SetBounds 50, 12, 76, 18


			scene.AddActor FlexDMD.NewLabel("HighScore_tittle",FontScoreActive ,"ENTER YOUR INITIAL")
			scene.GetLabel("HighScore_tittle").SetAlignedPosition 90, 4, FlexDMD_Align_Top
			
		'HighScore initial
			scene.AddActor FlexDMD.NewLabel("HighScoreInitial",FontBigBig ,TempBotStr)
			scene.GetLabel("HighScoreInitial").SetAlignedPosition 4, 4, FlexDMD_Align_TopLeft					

			scene.AddActor FlexDMD.NewLabel("NewScore", MediumFont ,Score(CurrentPlayer))
			scene.GetLabel("NewScore").SetAlignedPosition 88, 15, FlexDMD_Align_Top	
			
			FlexDMD.LockRenderThread
			FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_GRAY_4
			FlexDMD.Stage.RemoveAll
			FlexDMD.Stage.AddActor scene
			FlexDMD.UnlockRenderThread	


End Sub

'****************************
'BATTLE1	Find The BOX en el DMD 
'****************************

Sub FindTheBoxDMD(Box)
	DotMatrix.color = RGB(255, 0, 0)
		
		Dim DMDScene, PositionBox (4), i

	'Divide the DMD into 4 parts
		PositionBox (1) = 0 
		PositionBox (2) = 32
		PositionBox (3) = 64
		PositionBox (4) = 96

			'Add the background
            Set DMDScene = FlexDMD.NewGroup("Scene")

			DMDScene.AddActor FlexDMD.NewVideo("Gif0",FlexPath &  "BACKGROUND_BOX.gif")
			DMDScene.GetVideo("Gif0").SetBounds 0, 0, 128, 32
			DMDScene.GetVideo("Gif0").Visible = True

			For i = 1 to 4

				If FindtheBox(i) >< 2 Then
				DMDScene.AddActor FlexDMD.NewVideo("Gif_" & i,FlexPath &  "WOOD_BOX.gif")
				DMDScene.GetVideo("Gif_" & i).SetBounds PositionBox(i), 0, 32, 32
				DMDScene.GetVideo("Gif_" & i).Visible = True
				End If

			Next

		If Box >< 0 Then

			DMDScene.AddActor FlexDMD.NewVideo("Gif5",FlexPath &  "WOOD_BOX_"& FindtheBox(Box) &".gif")
			DMDScene.GetVideo("Gif5").SetBounds PositionBox (Box), 0, 32, 32
			DMDScene.GetVideo("Gif5").Visible = True

		End If

			'Añade el Marco
			DMDScene.AddActor FlexDMD.NewFrame("Marco")
			DMDScene.GetFrame("Marco").Thickness = 1
			DMDScene.GetFrame("Marco").SetBounds 0, 0, 128, 32
           ' Presenta el DMD
            FlexDMD.LockRenderThread
			FlexDMD.Stage.RemoveAll
            FlexDMD.Stage.AddActor DMDScene
            FlexDMD.UnlockRenderThread		
        
End Sub

'****************************
'BATTLE2	PUNCH OUT DMD            
'****************************

Sub PunchOutDMD()
	DotMatrix.color = RGB(255, 0, 0)

ScoreDMDActive =0
TiempoActivarDMDScore (1000)

		Dim FontBig : Set FontBig = FlexDMD.NewFont("FlexDMD.Resources.udmd-f6by12.fnt", vbWhite, vbBlack, 0)
		Dim PunchDMDScene
			'Añande el Gif
            Set PunchDMDScene = FlexDMD.NewGroup("Scene")
			
			'Añade el Imagen de fondo
		
	If Pausa_DMD = False Then 
				PunchDMDScene.AddActor FlexDMD.NewImage("Punch_fondo", FlexPath &"Background_punch_out.png")
			PunchDMDScene.GetImage("Punch_fondo").SetBounds 0, 0, 128, 32
		Pausa_DMD = True
		Pausa200.enabled = True
	End If	
				
			'Añade el Marco	

			PunchDMDScene.AddActor FlexDMD.NewLabel("Punch_Out_Tittle", FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt",  vbBlack, vbWhite , 1),"PUNCH OUT")
			PunchDMDScene.GetLabel("Punch_Out_Tittle").SetAlignedPosition 90, 6, FlexDMD_Align_TopRight

			PunchDMDScene.AddActor FlexDMD.NewLabel("HighScore",FontBig ,FormatNumber(Punch_Out_Value, 0, -1, 0, -1))
			PunchDMDScene.GetLabel("HighScore").SetAlignedPosition 90, 14, FlexDMD_Align_TopRight
			
			PunchDMDScene.AddActor FlexDMD.NewLabel("Left_Punch", FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite , vbBlack, 0),"SECONDS")
			PunchDMDScene.GetLabel("Left_Punch").SetAlignedPosition 127, 32, FlexDMD_Align_BottomRight

				If Segundos_value < 10 Then
					PunchDMDScene.AddActor FlexDMD.NewLabel("Seconds_Left_Punch", FlexDMD.NewFont("FlexDMD.Resources.udmd-f12by24.fnt", RGB(255,255, 0) , RGB(255, 0, 0), 1),"0"& Segundos_value)
				Else
					PunchDMDScene.AddActor FlexDMD.NewLabel("Seconds_Left_Punch", FlexDMD.NewFont("FlexDMD.Resources.udmd-f12by24.fnt", RGB(255,255, 0) , RGB(255, 0, 0), 1),Segundos_value)
				End If
				PunchDMDScene.GetLabel("Seconds_Left_Punch").SetAlignedPosition 129, 0, FlexDMD_Align_TopRight
			' Presenta el DMD

			CuentaAtras
	

 FlexDMD.LockRenderThread
            FlexDMD.Stage.AddActor PunchDMDScene
            FlexDMD.UnlockRenderThread		

'DURACION DE LA ESCENA
'ScoreDMDActive =0
'TiempoActivarDMDScore (25000)
   
End Sub

'****************************
'BATTLE3	LOTERY DMD            
'****************************

Sub Previus_Lotery_DMD
	DoubleFraseDMD "USE FLIPPERS", "STOP THE SLOTS"
End Sub


Sub LoteryDMD()
	DotMatrix.color = RGB(255, 0, 0)
	Dim  scene, Background_Lotery, PrimerPlano_Lotery, BezelLotery, i

		Set scene = FlexDMD.NewGroup("Scene_Lotery_Mode")
		Set Background_Lotery = FlexDMD.NewGroup("BackgroundLotery")
		Set PrimerPlano_Lotery = FlexDMD.NewGroup("PrimerPlanoLotery")

		
	
	Background_Lotery.AddActor FlexDMD.NewImage("Background_Lotery_1","VPX.Background_Lotery")
		scene.AddActor Background_Lotery

		For i = 1 to 4
		Dim y : y = Int((i - 1) / 4)
		Dim x : x = (i - 1) - y * 4

	'Cargo frames Lotery
		Set Lotery_Frames(i) = FlexDMD.NewImage("Lotery_Img_" & i, "VPX.loteria&region=" & (x * 32) & "," & (y * 160) & ",32,160")
		Lotery_Frames(i).SetBounds  ((i-1) *32), 0 , 32, 160


		'Lotery_Frames(i).Visible = True
		scene.AddActor Lotery_Frames(i)
		Next


		
		
		'scene.AddActor PrimerPlano_Lotery

	Set BezelLotery = FlexDMD.NewImage("Bezel","VPX.bezel_loteria")
					scene.AddActor BezelLotery

		'Rail 1 FLAG
	'scene.AddActor FlexDMD.NewLabel("Score1", FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbBlack, 1), "0")
	'scene.GetLabel("Score1").SetAlignedPosition 16, 32, FlexDMD_Align_BottomRight	
		'Rail 2 FLAG
	'scene.AddActor FlexDMD.NewLabel("Score2", FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbBlack, 1), "0")
	'scene.GetLabel("Score2").SetAlignedPosition 48, 32, FlexDMD_Align_BottomRight
		'Rail 3 FLAG
	'scene.AddActor FlexDMD.NewLabel("Score3", FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbBlack, 1), "0")
	'scene.GetLabel("Score3").SetAlignedPosition 80, 32, FlexDMD_Align_BottomRight
		'Rail 4 FLAG
	'scene.AddActor FlexDMD.NewLabel("Score4", FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbBlack, 1), "0")
	'scene.GetLabel("Score4").SetAlignedPosition 112, 32, FlexDMD_Align_BottomRight

		'LOTERY FLAG
	'scene.AddActor FlexDMD.NewLabel("ENEMY1_POSITION", FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbBlack, 1), "0")
	'scene.GetLabel("ENEMY1_POSITION").SetAlignedPosition 20, 32, FlexDMD_Align_BottomRight

	AlphaNumDMD.Run = False
	FlexDMD.LockRenderThread
	FlexDMD.Stage.RemoveAll
	FlexDMD.Stage.AddActor scene
	
	FlexDMD.UnlockRenderThread
End Sub

'****************************
'BATTLE4	RUNAWAY DMD            
'****************************

Sub RunAwayDMD()
	DotMatrix.color = RGB(255, 0, 0)
	Dim i, af, lp, main, scene, sceneIzq, sceneDer, sceneCen, scenePlayer, sceneRoad1,sceneRoad2 

		Set scene = FlexDMD.NewGroup("Background_road")
		Set sceneIzq = FlexDMD.NewGroup("Car_Izq")
		Set sceneDer = FlexDMD.NewGroup("Car_Der")		
		Set sceneCen = FlexDMD.NewGroup("Car_Cen")
		Set scenePlayer = FlexDMD.NewGroup("Car_Ply")

	Set sceneRoad1 = FlexDMD.NewGroup("sceneRoad1")
	sceneRoad1.AddActor FlexDMD.NewImage("Road1", FlexPath &"Background_road1.png")

	Set sceneRoad2 = FlexDMD.NewGroup("sceneRoad2")
	sceneRoad2.AddActor FlexDMD.NewImage("Foreground2", FlexPath &"Background_road2.png")

		Dim sequence, list
			Set sequence = FlexDMD.NewGroup("Sequence")
			sequence.SetSize 128, 32
			Set af = sequence.ActionFactory
			Set list = af.Sequence()
				list.Add af.AddChild(sceneRoad1)
				list.Add af.Wait(0.1)
				list.Add af.AddChild(sceneRoad2)
				list.Add af.Wait(0.1)
				list.Add af.RemoveChild(sceneRoad2)
				sequence.AddAction af.Repeat(list, -1)
		scene.AddActor Sequence

	'Cargo sin usar for las posiciones de player car para que salga rapido la posicion central
			Set Player_Car_Frames(1) = FlexDMD.NewImage("Player_Car_" & 1,"VPX.PlayerCar&region=0,0,128,32")
			Player_Car_Frames(1).Visible = False
			scenePlayer.AddActor Player_Car_Frames(1)
				
			Set Player_Car_Frames(2) = FlexDMD.NewImage("Player_Car_" & 2,"VPX.PlayerCar&region=128,0,128,32")
			Player_Car_Frames(2).Visible = True
			scenePlayer.AddActor Player_Car_Frames(2)

			Set Player_Car_Frames(3) = FlexDMD.NewImage("Player_Car_" & 3,"VPX.PlayerCar&region=256,0,128,32")
			Player_Car_Frames(3).Visible = False
			scenePlayer.AddActor Player_Car_Frames(3)
		
	'For i = 1 to 3
	'		y = Int((i - 1) / 3)
	'		x = (i - 1) - y * 3

	'		Set Player_Car_Frames(i) = FlexDMD.NewImage("Player_Car_" & i,FlexPath &"PlayerCar.png&region=" & (x * 128) & "," & (y * 32) & ",128,32")
	'		Player_Car_Frames(i).Visible = False
	'		scenePlayer.AddActor Player_Car_Frames(i)
	'Next


		'scene.GetGroup("Sequence").AddAction sequence
	'Set af = scene.GetImage("Foreground1").ActionFactory
	'Set af = scene.GetImage("Foreground2").ActionFactory
	'Set lp = af.Sequence()
	'lp.Add af.MoveTo(0, 0, 0)
	'lp.Add af.MoveTo(-384, 0, 15)
	'Set main = af.Sequence()
	'main.Add af.Wait(2)
	'main.Add af.Repeat(lp, -1)
	'scene.GetImage("Foreground1").AddAction main
	'Set af = scene.GetImage("Foreground2").ActionFactory
	'Set lp = af.Sequence()
	'lp.Add af.MoveTo(384, 0, 0)
	'lp.Add af.MoveTo(0, 0, 15)
	'Set main = af.Sequence()
	'main.Add af.Wait(2)
	'main.Add af.Repeat(lp, -1)
	'scene.GetImage("Foreground2").AddAction main
	
	For i = 1 to 21
		Dim y : y = Int((i - 1) / 7)
		Dim x : x = (i - 1) - y * 7

		'Cargo y oculto frames del Coche Izquierdo
		Set Car_Izq_Frames(i) = FlexDMD.NewImage("Car_Izq_" & i, "VPX.enemigoIzq&region=" & (x * 61) & "," & (y * 32) & ",61,32")
		Car_Izq_Frames(i).Visible = False
		sceneIzq.AddActor Car_Izq_Frames(i)

		'Cargo y oculto frames del Coche Central
		Set Car_Cen_Frames(i) = FlexDMD.NewImage("Car_Cen_" & i, "VPX.enemigoCen&region=" & (x * 61) & "," & (y * 32) & ",61,32")
		Car_Cen_Frames(i).Visible = False
		sceneCen.AddActor Car_Cen_Frames(i)

		'Cargo y oculto frames del Coche Derecho
		Set Car_Der_Frames(i) = FlexDMD.NewImage("Car_Der_" & i, "VPX.enemigoDer&region=" & (x * 61) & "," & (y * 32) & ",61,32")
		Car_Der_Frames(i).Visible = False
		sceneDer.AddActor Car_Der_Frames(i)
	Next
	
		'Añado al escenario frames del Coche Izquierdo en Posicion Izquierda
		scene.AddActor sceneIzq
		'Añado al escenario frames del Coche Central en Posicion Central
		sceneCen.GetGroup("Car_Cen").SetBounds 34, 0, 128, 32
		scene.AddActor sceneCen
		'Añado al escenario frames del Coche Derecho en Posicion Derecha
		sceneDer.GetGroup("Car_Der").SetBounds 67, 0, 128, 32
		scene.AddActor sceneDer
		'Añado al escenario en Posicion Central

		'Añado al escenario el coche del jugador
		scene.AddActor scenePlayer
	
	scene.AddActor FlexDMD.NewLabel("Title", FlexDMD.NewFont("FlexDMD.Resources.bm_army-12.fnt", RGB(200, 230, 255), vbBlack, 1), "Video Mode")
	scene.GetLabel("Title").SetBounds 0, 0, 128, 24
	Set af = scene.GetLabel("Title").ActionFactory
	Set main = af.Sequence()
	main.Add af.Wait(2)
	main.Add af.Show(False)
	scene.GetLabel("Title").AddAction main

	scene.AddActor FlexDMD.NewLabel("Infos", FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbWhite, 0), "Use Flipper Buttons to slide!")
	scene.GetLabel("Infos").SetAlignedPosition 64, 32, FlexDMD_Align_Bottom
	Set af = scene.GetLabel("Infos").ActionFactory
	Set main = af.Sequence()
	For i = 1 To 4
		main.Add af.Wait(0.25)
		main.Add af.Show(True)
		main.Add af.Wait(0.25)
		main.Add af.Show(False)
	Next
	scene.GetLabel("Infos").AddAction main

	scene.AddActor FlexDMD.NewLabel("Score", FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbWhite, 0), "0")
	scene.GetLabel("Score").SetAlignedPosition 126, 32, FlexDMD_Align_BottomRight
	Set af = scene.GetLabel("Score").ActionFactory
	Set main = af.Sequence()
	main.Add af.Show(False)
	main.Add af.Wait(2)
	main.Add af.Show(True)
	scene.GetLabel("Score").AddAction main

	AlphaNumDMD.Run = False
	FlexDMD.LockRenderThread
	FlexDMD.Stage.RemoveAll
	FlexDMD.Stage.AddActor scene
	FlexDMD.UnlockRenderThread


	Scores(Player) = 0
End Sub

'****************************
'BATTLE 5	LOOKANDFIRE DMD            
'****************************

Sub FindAndShootDMD()
	DotMatrix.color = RGB(255, 0, 0)
	Dim  scene, Background_FindAndShoot, PrimerPlano__FindAndShoot, i

		Set scene = FlexDMD.NewGroup("Scene_FindAndShoot")
		Set Background_FindAndShoot = FlexDMD.NewGroup("BackgroundFindAndShoot")
		Set PrimerPlano__FindAndShoot = FlexDMD.NewGroup("PrimerPlanoFindAndShoot")

		
	
	Background_FindAndShoot.AddActor FlexDMD.NewImage("Background_FindAndShoot_1","VPX.Background_FindAndShoot")
		Background_FindAndShoot.GetImage("Background_FindAndShoot_1").SetBounds CursorX, 0, 600, 32
		scene.AddActor Background_FindAndShoot

		For i = 1 to 5
		Dim y : y = Int((i - 1) / 5)
		Dim x : x = (i - 1) - y * 5

		'Cargo y oculto frames del Coche Izquierdo
		Set Enemy1_Frames(i) = FlexDMD.NewImage("Enemy1_Img_" & i, "VPX.enemy_1&region=" & (x * 32) & "," & (y * 32) & ",32,32")
		Enemy1_Frames(i).Visible = False
		scene.AddActor Enemy1_Frames(i)


		Set Enemy2_Frames(i) = FlexDMD.NewImage("Enemy2_Img_" & i, "VPX.enemy_2&region=" & (x * 32) & "," & (y * 32) & ",32,32")
		Enemy2_Frames(i).Visible = False
		scene.AddActor Enemy2_Frames(i)
		

		Set Enemy3_Frames(i) = FlexDMD.NewImage("Enemy3_Img_" & i, "VPX.enemy_3&region=" & (x * 32) & "," & (y * 32) & ",32,32")
		Enemy3_Frames(i).Visible = False
		scene.AddActor Enemy3_Frames(i)
		

		Set Enemy4_Frames(i) = FlexDMD.NewImage("Enemy4_Img_" & i, "VPX.enemy_4&region=" & (x * 32) & "," & (y * 32) & ",32,32")
		Enemy4_Frames(i).Visible = False
		scene.AddActor Enemy4_Frames(i)
		Next


		PrimerPlano__FindAndShoot.AddActor FlexDMD.NewImage("PrimerPlanoFindAndShoot_1","VPX.PrimerPlano_FindAndShoot")
		PrimerPlano__FindAndShoot.GetImage("PrimerPlanoFindAndShoot_1").SetBounds CursorX, 0, 600, 32
		scene.AddActor PrimerPlano__FindAndShoot



		'MIRILLA
		For i = 1 to 4
			Set Mirilla_FindAndShoot_DMD(i) = FlexDMD.NewImage("Mirilla" & i,"VPX.mirilla_&region=0,"& (i-1) * 32 &",128,32")
					Mirilla_FindAndShoot_DMD(i).Visible = False
					
					scene.AddActor Mirilla_FindAndShoot_DMD(i)
		Next
					Mirilla_FindAndShoot_DMD(1).Visible = True


		'MOVIMIENTO FLAG
	scene.AddActor FlexDMD.NewLabel("Score", FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbBlack, 1), "0")
	scene.GetLabel("Score").SetAlignedPosition 126, 32, FlexDMD_Align_BottomRight
	
		'ENEMY1 FLAG
	scene.AddActor FlexDMD.NewLabel("ENEMY1_POSITION", FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbBlack, 1), "0")
	scene.GetLabel("ENEMY1_POSITION").SetAlignedPosition 20, 32, FlexDMD_Align_BottomRight

	AlphaNumDMD.Run = False
	FlexDMD.LockRenderThread
	'FlexDMD.RenderMode = FlexDMD_RenderMode_DMD_RGB
	FlexDMD.Stage.RemoveAll
	FlexDMD.Stage.AddActor scene
	'FlexDMD.Show = True
	FlexDMD.UnlockRenderThread

End Sub
'****************************
'	Loop Trasero en el DMD 
'****************************
Sub LoopCountDMD

	DotMatrix.color = RGB(255, 0, 0)
			ScoreDMDActive =0

				If loopCount (CurrentPlayer) = 10 Then
					TiempoActivarDMDScore(4000)
				Else
					TiempoActivarDMDScore(2000)
				End If

	 Dim Logo ' T H E A T E A M  8 caracteres
	 Logo= "THE A TEAM"
	Dim Logo1,Logo2, Logo3
			'Avanzo espacios
			If mid(Logo, LoopCount (CurrentPlayer), 1 ) = " " Then
				LoopCount (CurrentPlayer) = LoopCount (CurrentPlayer) + 1
			End If

	If LoopCount (CurrentPlayer) >< 1 Then 
	Logo2= mid(logo,1,(LoopCount(CurrentPlayer)-1))  
	End If

	If LoopCount (CurrentPlayer) = 1 Then 
	Logo2= ""  
	End If
	 
	Logo3= Mid(logo,1,LoopCount (CurrentPlayer))

	Dim af, list
				Dim scene1, scene2, scene3, scene4, FrameDMD
				
				Dim FontBig : Set FontBig = FlexDMD.NewFont("FlexDMD.Resources.udmd-f7by13.fnt",vbBlack, RGB(125, 125, 125), 1)
				Dim FontBig2 : Set FontBig2 = FlexDMD.NewFont("FlexDMD.Resources.udmd-f7by13.fnt", vbWhite,RGB(125, 125, 125), 1)
				Dim MediumFont : Set MediumFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f6by12.fnt", vbWhite, vbWhite, 0)
				Dim FontScoreActive: Set FontScoreActive = FlexDMD.NewFont("FlexDMD.Resources.teeny_tiny_pixls-5.fnt", vbWhite, vbWhite, 0)
				Dim FontBigBig: Set FontBigBig = FlexDMD.NewFont("FlexDMD.Resources.udmd-f12by24.fnt", vbWhite, vbBlack, 1)
				Dim SmallFont: Set SmallFont = FlexDMD.NewFont("FlexDMD.Resources.udmd-f5by7.fnt", vbWhite, vbWhite, 0) 	
		
	'------------------------------FRAME ---------------------------------------------
				Set FrameDMD = FlexDMD.NewGroup("Frame")
					FrameDMD.AddActor FlexDMD.NewFrame("Marco")
					FrameDMD.GetFrame("Marco").Thickness = 1
					FrameDMD.GetFrame("Marco").SetBounds 0, 0, 128, 32


					FrameDmD.AddActor FlexDMD.NewFrame("Marco2")
					FrameDMD.GetFrame("Marco2").Thickness = 1
					FrameDMD.GetFrame("Marco2").SetBounds 2, 2, 124, 28
	'--------------------------------- THE A TEAM SPELL---------------------------------------
				Set scene1 = FlexDMD.NewGroup("Letters")
				scene1.AddActor FlexDMD.NewLabel("Letters1",FontBig ,Logo)
				scene1.GetLabel("Letters1").SetAlignedPosition 15, 10, FlexDMD_Align_TopLeft	

				Set scene2 = FlexDMD.NewGroup("Letters_2")
				scene2.AddActor FlexDMD.NewLabel("Letters2",FontBig2 ,Logo2)
				scene2.GetLabel("Letters2").SetAlignedPosition 15, 10, FlexDMD_Align_TopLeft	


				Set scene3 = FlexDMD.NewGroup("Actual_Letter")
				scene3.AddActor FlexDMD.NewLabel("Actual",FontBig2 ,Logo3)
				scene3.GetLabel("Actual").SetAlignedPosition 15, 10, FlexDMD_Align_TopLeft	


			Set scene4 = FlexDMD.NewGroup("Complete_Letter")
				scene4.AddActor FlexDMD.NewLabel("Complete",FontBig2 ,Logo)
				scene4.GetLabel("Complete").SetAlignedPosition 15, 10, FlexDMD_Align_TopLeft	

	'SECUENCIA FINAL Instant Info
				Dim sequence
				Set sequence = FlexDMD.NewGroup("Sequence")
				sequence.SetSize 128, 32
				Set af = sequence.ActionFactory
				Set list = af.Sequence()
			'Presenta la version
					list.Add af.AddChild(FrameDMD)	
					list.Add af.AddChild(scene1)

				If loopcount (CurrentPlayer) < 10 Then 
					list.Add af.AddChild(scene2)
					list.Add af.AddChild(scene3)
					list.Add af.Wait(0.4)
					list.Add af.RemoveChild(scene3)
					list.Add af.Wait(0.4)
					list.Add af.AddChild(scene3)
					list.Add af.Wait(0.4)
					list.Add af.RemoveChild(scene3)
					list.Add af.Wait(0.4)
					list.Add af.AddChild(scene3)
					list.Add af.Wait(0.5)
					list.Add af.RemoveChild(scene3)
					list.Add af.Wait(0.5)
					list.Add af.AddChild(scene3)
					list.Add af.Wait(0.4)
					list.Add af.RemoveChild(scene3)
					list.Add af.Wait(0.4)
				End If
				If loopcount (CurrentPlayer)=10 Then 
					list.Add af.AddChild(scene4)
					list.Add af.Wait(0.4)
					list.Add af.RemoveChild(scene4)
					list.Add af.Wait(0.4)
					list.Add af.AddChild(scene4)
					list.Add af.Wait(0.4)
					list.Add af.RemoveChild(scene4)
					list.Add af.Wait(0.4)
					list.Add af.AddChild(scene4)
					list.Add af.Wait(0.5)
					list.Add af.RemoveChild(scene4)
					list.Add af.Wait(0.5)
					list.Add af.AddChild(scene4)
					list.Add af.Wait(0.4)
					list.Add af.RemoveChild(scene4)
					list.Add af.Wait(0.4)
				End If			
				sequence.AddAction af.Repeat(list, -1)

				FlexDMD.LockRenderThread
				FlexDMD.Stage.RemoveAll
				FlexDMD.Stage.AddActor sequence
				FlexDMD.UnlockRenderThread


			If loopCount (CurrentPlayer) = 10 Then
				PlaySound "Full_spelling_TheATeam"
				vpmtimer.addtimer 2000, "GifDMD ""10Millions"" '"
				loopCount (CurrentPlayer) =0	
				Addscore 10000000
				vpmtimer.addtimer 3000, "TurnOffLogoLights '"		
			End If
	
End Sub

'****************************
'	Pausa en el DMD - Evita errores de carga de archivos
'****************************
Sub Pausa200_Timer
	Pausa_DMD =False
	Pausa200.enabled = False

End Sub
'------------------------------------------------------------------------------------------
'******************************************************************************************
'									 DMD FLUSH
'******************************************************************************************
'------------------------------------------------------------------------------------------


Sub DMDFlush()
    Dim i
    DMDTimer.Enabled = False
    DMDEffectTimer.Enabled = False
    dqHead = 0
    dqTail = 0
    For i = 0 to 2
        deCount(i) = 0
        deCountEnd(i) = 0
        deBlinkCycle(i) = 0
    Next
End Sub

'******************
' Magna
'******************

Dim mMagnaSave
Set mMagnaSave = New cvpmMagnet : With mMagnaSave
	.InitMagnet Magna, 8
	.GrabCenter = 0
End With

Sub Magna_Hit():mMagnaSave.AddBall ActiveBall: End Sub
Sub Magna_UnHit(): mMagnaSave.RemoveBall ActiveBall: End Sub

Dim mMagnaSave001
Set mMagnaSave001 = New cvpmMagnet : With mMagnaSave001
	.InitMagnet Magna001, 8
	.GrabCenter = 0
End With

Sub Magna001_Hit():mMagnaSave001.AddBall ActiveBall: End Sub
Sub Magna001_UnHit(): mMagnaSave001.RemoveBall ActiveBall: End Sub

Dim mMagnaSave002
Set mMagnaSave002 = New cvpmMagnet : With mMagnaSave002
	.InitMagnet Magna002, 8
	.GrabCenter = 0
End With

Sub Magna002_Hit():mMagnaSave002.AddBall ActiveBall: End Sub
Sub Magna002_UnHit(): mMagnaSave002.RemoveBall ActiveBall: End Sub

Dim mMagnaSave003
Set mMagnaSave003 = New cvpmMagnet : With mMagnaSave003
	.InitMagnet Magna003, 8
	.GrabCenter = 0
End With

Sub Magna003_Hit():mMagnaSave003.AddBall ActiveBall: End Sub
Sub Magna003_UnHit(): mMagnaSave003.RemoveBall ActiveBall: End Sub

Dim mMagnaSave004
Set mMagnaSave004 = New cvpmMagnet : With mMagnaSave004
	.InitMagnet Magna004, 8
	.GrabCenter = 0
End With

Sub Magna004_Hit():mMagnaSave004.AddBall ActiveBall: End Sub
Sub Magna004_UnHit(): mMagnaSave004.RemoveBall ActiveBall: End Sub


'******************
' Captive Ball Subs
'******************
Sub CapTrigger1_Hit:cbRight.TrigHit ActiveBall:End Sub
Sub CapTrigger1_UnHit:cbRight.TrigHit 0:End Sub
Sub CapWall1_Hit:cbRight.BallHit ActiveBall:PlaySoundAtBall "fx_collide":End Sub
Sub CapKicker1a_Hit:cbRight.BallReturn Me:End Sub

'******
' Keys
'******

Sub Table1_KeyDown(ByVal Keycode)
    If keycode = LeftMagnaSave Then bLutActive = True
		If keycode = RightMagnaSave Then
			If bLutActive Then NextLUT:End If
		End If

		 
		If Keycode = AddCreditKey And VideoModeActive = False Then
			Credits = Credits + 1
			playsound "fx_coin"
			'NEW CREDIT IN DMD

			
				InicioDMDScenes
			

			
			if bFreePlay = False Then DOF 125, DOFOn
			If(Tilted = False)Then
				DMDFlush
				
				If NOT bGameInPlay Then ShowTableInfo
			
		End If		
    End If

    If keycode = PlungerKey Then
		
		Plunger001.Pullback
        Plunger.Pullback
        PlaySoundAt "fx_plungerpull", plunger
        PlaySoundAt "fx_reload", plunger
    End If


    If hsbModeActive Then
        EnterHighScoreKey(keycode)
        Exit Sub
    End If

    ' Table specific

    ' Normal flipper action

    If bGameInPlay AND NOT Tilted Then

        If keycode = LeftTiltKey Then Nudge 90, 8:PlaySound "fx_nudge", 0, 1, -0.1, 0.25:CheckTilt
        If keycode = RightTiltKey Then Nudge 270, 8:PlaySound "fx_nudge", 0, 1, 0.1, 0.25:CheckTilt
        If keycode = CenterTiltKey Then Nudge 0, 9:PlaySound "fx_nudge", 0, 1, 1, 0.25:CheckTilt


        If keycode = LeftFlipperKey Then 
			

			If VideoModeActive= False Then 'UNLOCK THE FLIPPERS
			InstantInfoTimer.Enabled = True
			SolLFlipper 1
			End If

			Select Case Battle(CurrentPlayer, 0)
				Case 3
					If Rail_Stopped < 4 Then 
					Rail_Stopped = Rail_Stopped +1
						Stop_Rail (Rail_Stopped) = True
					End if
				Case 4
					If Player_Car_Position > 1 Then 
						Player_Car_Position = Player_Car_Position -1
					End If
				Case 5
					LeftFlipperPressed = True 
					
			End Select
		End If

		If keycode = RightFlipperKey Then 
			

			If VideoModeActive= False Then 
			InstantInfoTimer.Enabled = True
			SolRFlipper 1
			End If
			
			Select Case Battle(CurrentPlayer, 0)
				Case 3
					If Rail_Stopped < 4 Then 
					Rail_Stopped = Rail_Stopped +1
						Stop_Rail (Rail_Stopped) = True
					End if
				Case 4
					If Player_Car_Position <3 Then 
					Player_Car_Position = Player_Car_Position +1
					End If
				Case 5
					RightFlipperPressed = true

			End Select
		End If

        If keycode = StartGameKey Then

		

            If((PlayersPlayingGame < MaxPlayers)AND(bOnTheFirstBall = True) AND VideoModeActive = False)Then

                If(bFreePlay = True)Then
                    PlayersPlayingGame = PlayersPlayingGame + 1
                    TotalGamesPlayed = TotalGamesPlayed + 1
                   ' DMD "_", CL(PlayersPlayingGame & " PLAYERS"), "", eNone, eBlink, eNone, 500, True, "so_fanfare1"
                Else
                    If(Credits > 0)then
                        PlayersPlayingGame = PlayersPlayingGame + 1
                        TotalGamesPlayed = TotalGamesPlayed + 1
                        Credits = Credits - 1
						playsound "fx_bonus"

						

						FraseMediumDMD ( PlayersPlayingGame & " PLAYERS" ) ' ! Second in the DMD

						vpmtimer.addtimer 1000, "ScoreDMD '" 

					
                        
                        If Credits < 1 And bFreePlay = False Then DOF 125, DOFOff
                        Else
                            ' Not Enough Credits to start a game.

						FraseSmallDMD ("Not Enough Credits")

						vpmtimer.addtimer 1000, "InicioDMDScenes '"

                            'DMD CL("CREDITS " & Credits), CL("INSERT COIN"), "", eNone, eBlink, eNone, 500, True, "so_nocredits"
                    End If
                End If
            End If
        End If
        Else ' If (GameInPlay)

            If keycode = StartGameKey AND VideoModeActive = False Then
                If(bFreePlay = True)Then
                    If(BallsOnPlayfield = 0)Then
                        ResetForNewGame()
                    End If
                Else
                    If(Credits > 0) AND VideoModeActive = False Then
                        If(BallsOnPlayfield = 0)Then
                            Credits = Credits - 1
                            If Credits < 1 And bFreePlay = False Then DOF 125, DOFOff
							playsound "fx_bonus"
		

                            ResetForNewGame()
                        End If
                    Else
						FraseSmallDMD ("Not Enough Credits")

						vpmtimer.addtimer 1000, "InicioDMDScenes '"
                        ' Not Enough Credits to start a game.
                        'DMD CL("CREDITS " & Credits), CL("INSERT COIN"), "", eNone, eBlink, eNone, 500, True, "so_nocredits"
                        ShowTableInfo
                    End If
                End If
            End If
    End If ' If (GameInPlay)

'test keys

'****** MANUEL BALL CONTROL  *********
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
'****** BACK BATTLE SUBMISION ********* 

If keycode = 30 Then	 				' A Key
	Select Case Battle(CurrentPlayer, 0)

		Case 0 'Select Next Battle
				Dim tmp
				If NewBattle > 1 Then 'NUMERO MINIMO DE BATALLAS
					If BattlesWon(CurrentPlayer) = 10 Then
						NewBattle = 11
						Battle(CurrentPlayer, NewBattle) = 2:UpdateBattleLights:StartBattle '11 battle is the wizard
					Else
						 Tmp = NewBattle 

						do while Battle(CurrentPlayer, NewBattle) <> 0
							NewBattle = NewBattle - 1
						loop
					
						If NewBattle < 1 Then 
							NewBattle = 10
							do while Battle(CurrentPlayer, NewBattle) <> 0
								NewBattle = NewBattle - 1
							loop
						End if

						Battle(CurrentPlayer, Tmp) = 0
						Battle(CurrentPlayer, NewBattle) = 2
						UpdateBattleLights
					End iF
				Else 
						Battle(CurrentPlayer, NewBattle) = 0 
						NewBattle = 10

						do while Battle(CurrentPlayer, NewBattle) <> 0
							NewBattle = NewBattle - 1
						loop
						Battle(CurrentPlayer, NewBattle) = 2
						UpdateBattleLights
				End If	
	End Select
End If

'****** ADVANCE BATTLE SUBMISION  ***********

If keycode = 31 Then	 				' S Key 
		
	Select Case Battle(CurrentPlayer, 0)
			
			Case 0 'Select Next Battle
						
					If NewBattle < 10 Then 'NUMERO MÁXIMODE BATALLAS
							If BattlesWon(CurrentPlayer) = 10Then
								NewBattle = 11
								Battle(CurrentPlayer, NewBattle) = 2:UpdateBattleLights:StartBattle '11 battle is the wizard
							Else

							 Tmp = NewBattle 

							do while Battle(CurrentPlayer, NewBattle) <> 0
								NewBattle = NewBattle + 1
							loop
							
						If NewBattle > 10 Then 
							
							NewBattle = 1
							do while Battle(CurrentPlayer, NewBattle) <> 0
								NewBattle = NewBattle + 1
							loop

						End if
							Battle(CurrentPlayer, Tmp) = 0
							Battle(CurrentPlayer, NewBattle) = 2
							UpdateBattleLights
						End if

						Else 
							Battle(CurrentPlayer, NewBattle) = 0
							NewBattle = 1
							Tmp = NewBattle 

							do while Battle(CurrentPlayer, NewBattle) <> 0
								NewBattle = NewBattle + 1
							loop

							Battle(CurrentPlayer, NewBattle) = 2
							UpdateBattleLights
					
				End If
		End Select

End If
'-----------------------KEY CODE TEST LETRA F AQUI-------------------------------
			If keycode = 33 Then
				Select Case Mision(CurrentPlayer, 0)
					Case 1
						Addscore 40000
						SpinCountMision(CurrentPlayer) = SpinCountMision(CurrentPlayer) + 150
						CheckMisionDone
						
						
						'Dmd scrore Wait
						If Status_DMD_Mision (1) = True Then
							ScoreDMDActive =0
							TiempoActivarDMDScore(4000)
								If Rest_Mision_Timer. Enabled = False Then 
									Rest_Mision_Timer. Enabled = True
									Dmd_Rest_Active = True
								End If
						End If
					Case 2
							SuperBumperHits(CurrentPlayer) = SuperBumperHits(CurrentPlayer) + 25
							Addscore 500000
							CheckMisionDone
					Case 3
							RampHits3(CurrentPlayer) = RampHits3(CurrentPlayer) + 6
							Addscore 250000
							CheckMisionDone
					Case 4
				
							TargetHannibal = TargetHannibal + 4 
							Addscore 2500000
							CheckMisionDone
				End Select
			End if


			If keycode = 34 Then
					
			
			vpmtimer.addtimer 1500, "Playsound ""fx_fanfare1"" '"  
			vpmtimer.addtimer 5000, "Addscore ""0"" '"
			
			Select Case NewBattle
				Case 1
					FraseMediumDMD "SUPPLY FOUND"
					Playsound "HANNIBAL_PLAINS"	
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 2	
					FraseMediumDMD "COMPLETE BATTLE"
					Playsound "HANNIBAL_KEEP_CALM_MA"	
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 3
					GifDMD "Slots"
					Playsound "Murdock_winner"	
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 4
					GifDMD "Runaway_intro"
					PlaySound "SALIDACOCHE"
					PlaySound "fx_alarm"
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 5
					GifDMD "Find_and_shoot_intro"
					Playsound "HANNIBAL_PLAINS"	
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 6
					GifDMD "EXTRABALL"
					ExtraballDMD =True
					playsound "vo_extraball"
					DOF 121, DOFPulse
					ExtraBallsAwards(CurrentPlayer) = ExtraBallsAwards(CurrentPlayer) + 1
					bExtraBallWonThisBall = True
				Case 7
					FraseMediumDMD "COLLECT AWARD"
					Playsound "HANNIBAL_KEEP_CALM_MA"	
					AddScore 5000000
					vpmtimer.addtimer 1500, "GifDMD ""5Millions""'"
				Case 8
					GifDMD "HOSPITAL-CARTEL"	
					PlaySound "Murdock_Scape"
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 9
					FraseMediumDMD "COMPLETE BATTLE"
					Playsound "HANNIBAL_KEEP_CALM_MA"	
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 10
					FraseMediumDMD "LITE MULTIBALL"
					PlaySound "Rafaga"
					'EnableBallSaver(10)
					'AddMultiball 1

				End Select 

				Battle(CurrentPlayer, 0) = 0
				Battle(CurrentPlayer, NewBattle) = 1

				UpdateBattleLights
				FlashEffect 2
				LightEffect 2
				GiEffect 2
				Battle_is_Active = False
   
				DOF 139, DOFPulse
				StopBattle2
				NewBattle = 0
				SelectBattle 'automatically select a new battle 
				ResetNewBallLights
				'ChangeSong
			End If

End Sub



'---------------------------------------------------------
'Lift the key
'---------------------------------------------------------

Sub Table1_KeyUp(ByVal keycode)

    If keycode = LeftMagnaSave Then bLutActive = False: LutBox.text = ""

		
	If keycode = PlungerKey Then
        Plunger.Fire
        PlaySoundAt "fx_plunger", plunger
        
		If bBallInPlungerLane Then PlaySoundAt "fx_fire", plunger

			If BallsOnPlayfield >0 Then
				PlaySound "Rafaga"
			End If

		End If

    If hsbModeActive Then
        Exit Sub
    End If

    ' Table specific

    If bGameInPLay AND NOT Tilted Then

'Manual Ball Control
	If EnableBallControl = 1 Then
		If keycode = 203 Then BCleft = 0	' Left Arrow
		If keycode = 200 Then BCup = 0		' Up Arrow
		If keycode = 208 Then BCdown = 0	' Down Arrow
		If keycode = 205 Then BCright = 0	' Right Arrow
	End If



        If keycode = LeftFlipperKey Then
            SolLFlipper 0
            InstantInfoTimer.Enabled = False


            If bInstantInfo Then 
                bInstantInfo = False
            End If

			Select Case Battle(CurrentPlayer, 0)
				Case 5
					LeftFlipperPressed = False
			End Select
        End If

        If keycode = RightFlipperKey Then
            SolRFlipper 0
            InstantInfoTimer.Enabled = False

            If bInstantInfo Then
                bInstantInfo = False
            End If

			Select Case Battle(CurrentPlayer, 0)
				Case 5
				RightFlipperPressed = False
			End Select
        End If
    End If
	

End Sub

Sub InstantInfoTimer_Timer
    InstantInfoTimer.Enabled = False
    If NOT hsbModeActive AND bSkillShotReady = False Then
        bInstantInfo = True
        DMDFlush
        InstantInfo
    End If
End Sub



'*************
' Pause Table
'*************

Sub table1_Paused
End Sub

Sub table1_unPaused
End Sub

Sub Table1_Exit
    Savehs
    If Not FlexDMD is Nothing Then
		FlexDMD.Show = False
		FlexDMD.Run = False
		FlexDMD = NULL
    End If
    If B2SOn = true Then Controller.Stop
End Sub



'********************
'     Flippers
'********************

Sub SolLFlipper(Enabled)
    If Enabled Then
        PlaySoundAt SoundFXDOF("fx_flipperup", 101, DOFOn, DOFFlippers), LeftFlipper
        LeftFlipper.RotateToEnd
        LeftFlipperOn = 1
    Else
        PlaySoundAt SoundFXDOF("fx_flipperdown", 101, DOFOff, DOFFlippers), LeftFlipper
        LeftFlipper.RotateToStart
        LeftFlipperOn = 0
    End If
End Sub

Sub SolRFlipper(Enabled)
    If Enabled Then
        PlaySoundAt SoundFXDOF("fx_flipperup", 102, DOFOn, DOFFlippers), RightFlipper
        RightFlipper.RotateToEnd
        RightFlipperOn = 1
    Else
        PlaySoundAt SoundFXDOF("fx_flipperdown", 102, DOFOff, DOFFlippers), RightFlipper
        RightFlipper.RotateToStart
        RightFlipperOn = 0
    End If
End Sub

' flippers hit Sound

Sub LeftFlipper_Collide(parm)
    PlaySound "fx_rubber_flipper", 0, parm / 60, pan(ActiveBall), 0.1, 0, 0, 0, AudioFade(ActiveBall)
End Sub

Sub RightFlipper_Collide(parm)
    PlaySound "fx_rubber_flipper", 0, parm / 60, pan(ActiveBall), 0.1, 0, 0, 0, AudioFade(ActiveBall)
End Sub

'*********************************************************
' Real Time Flipper adjustments - by JLouLouLou & JPSalas
'        (to enable flipper tricks) 
'*********************************************************

Dim FlipperPower
Dim FlipperElasticity
Dim SOSTorque, SOSAngle
Dim FullStrokeEOS_Torque, LiveStrokeEOS_Torque
Dim LeftFlipperOn
Dim RightFlipperOn

Dim LLiveCatchTimer
Dim RLiveCatchTimer
Dim LiveCatchSensivity

FlipperPower = 5000
FlipperElasticity = 0.8
FullStrokeEOS_Torque = 0.3 	' EOS Torque when flipper hold up ( EOS Coil is fully charged. Ampere increase due to flipper can't move or when it pushed back when "On". EOS Coil have more power )
LiveStrokeEOS_Torque = 0.2	' EOS Torque when flipper rotate to end ( When flipper move, EOS coil have less Ampere due to flipper can freely move. EOS Coil have less power )

LeftFlipper.EOSTorqueAngle = 10
RightFlipper.EOSTorqueAngle = 10

SOSTorque = 0.1
SOSAngle = 6

LiveCatchSensivity = 10

LLiveCatchTimer = 0
RLiveCatchTimer = 0

LeftFlipper.TimerInterval = 1
LeftFlipper.TimerEnabled = 1

Sub LeftFlipper_Timer 'flipper's tricks timer
'Start Of Stroke Flipper Stroke Routine : Start of Stroke for Tap pass and Tap shoot
    If LeftFlipper.CurrentAngle >= LeftFlipper.StartAngle - SOSAngle Then LeftFlipper.Strength = FlipperPower * SOSTorque else LeftFlipper.Strength = FlipperPower : End If
 
'End Of Stroke Routine : Livecatch and Emply/Full-Charged EOS
	If LeftFlipperOn = 1 Then
		If LeftFlipper.CurrentAngle = LeftFlipper.EndAngle then
			LeftFlipper.EOSTorque = FullStrokeEOS_Torque
			LLiveCatchTimer = LLiveCatchTimer + 1
			If LLiveCatchTimer < LiveCatchSensivity Then
				LeftFlipper.Elasticity = 0
			Else
				LeftFlipper.Elasticity = FlipperElasticity
				LLiveCatchTimer = LiveCatchSensivity
			End If
		End If
	Else
		LeftFlipper.Elasticity = FlipperElasticity
		LeftFlipper.EOSTorque = LiveStrokeEOS_Torque
		LLiveCatchTimer = 0
	End If
	

'Start Of Stroke Flipper Stroke Routine : Start of Stroke for Tap pass and Tap shoot
    If RightFlipper.CurrentAngle <= RightFlipper.StartAngle + SOSAngle Then RightFlipper.Strength = FlipperPower * SOSTorque else RightFlipper.Strength = FlipperPower : End If
 
'End Of Stroke Routine : Livecatch and Emply/Full-Charged EOS
 	If RightFlipperOn = 1 Then
		If RightFlipper.CurrentAngle = RightFlipper.EndAngle Then
			RightFlipper.EOSTorque = FullStrokeEOS_Torque
			RLiveCatchTimer = RLiveCatchTimer + 1
			If RLiveCatchTimer < LiveCatchSensivity Then
				RightFlipper.Elasticity = 0
			Else
				RightFlipper.Elasticity = FlipperElasticity
				RLiveCatchTimer = LiveCatchSensivity
			End If
		End If
	Else
		RightFlipper.Elasticity = FlipperElasticity
		RightFlipper.EOSTorque = LiveStrokeEOS_Torque
		RLiveCatchTimer = 0
	End If
End Sub


'*********
' TILT
'*********

'NOTE: The TiltDecreaseTimer Subtracts .01 from the "Tilt" variable every round

Sub CheckTilt                                    'Called when table is nudged
    Tilt = Tilt + TiltSensitivity                'Add to tilt count
    TiltDecreaseTimer.Enabled = True
    If(Tilt > TiltSensitivity)AND(Tilt < 15)Then 'show a warning
        
	FraseMediumDMD "CAREFUL"
'DMD "_", CL("CAREFUL"), "_", eNone, eBlinkFast, eNone, 500, True, ""
    End if
    If Tilt > 15 Then 'If more that 15 then TILT the table
        Tilted = True
        'display Tilt
        DMDFlush
		FraseMediumDMD "TILT"
        'DMD "", CL("TILT"), "", eNone, eNone, eNone, 200, False, ""
        DisableTable True
        TiltRecoveryTimer.Enabled = True 'start the Tilt delay to check for all the balls to be drained
    End If
End Sub

Sub TiltDecreaseTimer_Timer
    ' DecreaseTilt
    If Tilt > 0 Then
        Tilt = Tilt - 0.1
    Else
        TiltDecreaseTimer.Enabled = False
    End If
End Sub

Sub DisableTable(Enabled)
    If Enabled Then
        'turn off GI and turn off all the lights
        GiOff
LightSeqBumpers.StopPlay
        LightSeqTilt.Play SeqAllOff
        'Disable slings, bumpers etc
        LeftFlipper.RotateToStart
        RightFlipper.RotateToStart
        'Bumper1.Force = 0
		

        LeftSlingshot.Disabled = 1
        RightSlingshot.Disabled = 1
    Else
        'turn back on GI and the lights
        GiOn
        LightSeqTilt.StopPlay
        'Bumper1.Force = 6
        LeftSlingshot.Disabled = 0
        RightSlingshot.Disabled = 0
        'clean up the buffer display
        DMDFlush
    End If
End Sub

Sub TiltRecoveryTimer_Timer()
    ' if all the balls have been drained then..
    If(BallsOnPlayfield = 0)Then
        ' do the normal end of ball thing (this doesn't give a bonus if the table is tilted)
        EndOfBall()
        TiltRecoveryTimer.Enabled = False
    End If
' else retry (checks again in another second or so)
End Sub

'********************
' Music as wav sounds
'********************

Dim Song
Song = ""

Sub PlaySong(name)
    If bMusicOn Then
        If Song <> name Then
            StopSound Song
            Song = name
            PlaySound Song, -1, SongVolume
        End If
    End If
End Sub

Sub PlayBattleSong
    Dim tmp
    tmp = INT(RND * 6)
    Select Case tmp
        Case 0:PlaySong "mu_battle1"
        Case 1:PlaySong "mu_battle2"
        Case 2:PlaySong "mu_battle3"
        Case 3:PlaySong "mu_battle4"
        Case 4:PlaySong "mu_battle5"
        Case 5:PlaySong "mu_battle6"
    End Select
End Sub


Sub PlayMultiballSong
       PlaySong "mc_Hannibal" 
End Sub

Sub ChangeSong
	'If bBallSaverActive = False Then 
		If(BallsOnPlayfield = 0)  Then
			PlaySong "mc_Hannibal"

					If 	 PlayersPlayingGame =1  Then
						playsound "fx_bonus"
						PlaySong "mu_end"
						
						Exit Sub
					End If
			Exit Sub
		End If

		
			

		If bMultiBallMode Then
			PlayMultiballSong
		Else
			Select Case Mision(CurrentPlayer, 0)
					Case 0
							PlaySong "mu_main"
							End_mu_active (CurrentPlayer) = False

					Case 1
						PlaySong "mc_Murdock"
					Case 2
						PlaySong "mc_Barracus"
					Case 3
						PlaySong "mc_Face"
					Case 4
						PlaySong "mc_Hannibal2"
					Case 13
							PlayMultiballSong
			End Select
		End If

   ' End If
End Sub

Sub ChangeSong_Character_mision
	'If bBallSaverActive = False Then
		If(BallsOnPlayfield = 0)  Then
			PlaySong "mu_end"
			Exit Sub
		End If

			If bMultiBallMode Then
				PlayMultiballSong
			Else
				Select Case Battle(CurrentPlayer, 0)
			   Case 0
				
						PlaySong "mu_main"
						End_mu_active (CurrentPlayer) = False
					
				Case 1 PlaySong "JEEP_A team_1"

				Case 2 vpmtimer.addtimer 2500, "PlaySong ""PUNCH_ OUT_theme"" '"	
				
				Case 3 vpmtimer.addtimer 2500, "PlaySong ""Lotery_theme"" '" 

				Case 4
					PlaySong "Battle_RunAway"
				Case 5 
					PlaySong "FIND_AND_SHOOT_theme"
				Case 6 
					PlaySong "EXTRABALL_theme"
				Case 8
					PlaySong "MURDOCK_SCAPE_THEME" 
				Case 9
					PlaySong "BA_Targets_Theme" 	
				Case  7, 10, 11, 12
					PlayBattleSong
			   Case 13
					PlayMultiballSong
			End Select
				
			End If
	'End If
End Sub

'********************
' Play random quotes
'********************

Sub PlayQuote
    Dim tmp
    tmp = INT(RND * 130) + 1
    PlaySound "quote_" &tmp
End Sub

'**********************
'     GI effects
' independent routine
' it turns on the gi
' when there is a ball
' in play
'**********************

Dim OldGiState
OldGiState = -1   'start witht the Gi off

Sub ChangeGi(col) 'changes the gi color
    Dim bulb
    For each bulb in aGILights
        SetLightColor bulb, col, -1
    Next
End Sub

Sub GIUpdateTimer_Timer
    Dim tmp, obj
    tmp = Getballs
    If UBound(tmp) <> OldGiState Then
        OldGiState = Ubound(tmp)
        If UBound(tmp) = 1 Then 'we have 2 captive balls on the table (-1 means no balls, 0 is the first ball, 1 is the second..)
            GiOff               ' turn off the gi if no active balls on the table, we could also have used the variable ballsonplayfield.
        Else
            Gion
        End If
    End If
End Sub

Sub GiOn
    DOF 118, DOFOn
    Dim bulb
    For each bulb in aGiLights
        bulb.State = 1
    Next
'APAGA LAS LUCES DE LOS BUMPERS DE INICIO
If Puntuacion >0 Then
    For each bulb in aBumperLights
        bulb.Visible = 1
    Next
End If

End Sub

Sub GiOff
    DOF 118, DOFOff
    Dim bulb
    For each bulb in aGiLights
        bulb.State = 0
    Next
    For each bulb in aBumperLights
        bulb.Visible = 0
    Next
	
End Sub

' GI, light & flashers sequence effects

Sub GiEffect(n)
    Dim ii
    Select Case n
        Case 0 'all off
            LightSeqGi.Play SeqAlloff
        Case 1 'all blink
            LightSeqGi.UpdateInterval = 10
            LightSeqGi.Play SeqBlinking, , 15, 10
        Case 2 'random
            LightSeqGi.UpdateInterval = 10
            LightSeqGi.Play SeqRandom, 50, , 1000
        Case 3 'all blink fast
            LightSeqGi.UpdateInterval = 10
            LightSeqGi.Play SeqBlinking, , 10, 10
		Case 4 'all blink fast
            LightSeqGi.UpdateInterval = 50
            LightSeqGi.Play SeqRandom, 50, , 100
			'vpmtimer.addtimer 1500, "GiEffectOff '"
    End Select

End Sub



Sub LightEffect(n)
    Select Case n
        Case 0 ' all off
            LightSeqInserts.Play SeqAlloff
        Case 1 'all blink
            LightSeqInserts.UpdateInterval = 10
            LightSeqInserts.Play SeqBlinking, , 15, 10
        Case 2 'random
            LightSeqInserts.UpdateInterval = 10
            LightSeqInserts.Play SeqRandom, 50, , 1000
        Case 3 'all blink fast
            LightSeqInserts.UpdateInterval = 10
            LightSeqInserts.Play SeqBlinking, , 10, 10
		Case 4 'all blink fast
            LightSeqInserts.UpdateInterval = 50
            LightSeqInserts.Play SeqRandom, 50, , 100
			'vpmtimer.addtimer 1500, "LightEffectOff '"
    End Select
End Sub

Sub FlashEffect(n)
    Dim ii
    Select case n
        Case 0 ' all off
            LightSeqFlasher.Play SeqAlloff
        Case 1 'all blink
            LightSeqFlasher.UpdateInterval = 10
            LightSeqFlasher.Play SeqBlinking, , 10, 10
        Case 2 'random
            LightSeqFlasher.UpdateInterval = 10
            LightSeqFlasher.Play SeqRandom, 50, , 1000
        Case 3 'all blink fast
            LightSeqFlasher.UpdateInterval = 10
            LightSeqFlasher.Play SeqBlinking, , 5, 10
		 Case 4 'all blink fast
			LightSeqFlasher.UpdateInterval = 50
            LightSeqFlasher.Play SeqRandom, 50, , 100
			'vpmtimer.addtimer 1500, "FlashEffectOff '"
    End Select
End Sub

Sub LightEffectOff
			LightSeqInserts.StopPlay	
End Sub

Sub FlashEffectOff
			LightSeqFlasher.StopPlay					
End Sub

Sub GiEffectOff		
			LightSeqGi.StopPlay			
End Sub

'************************************
' Diverse Collection Hit Sounds v3.0
'************************************

Sub aMetals_Hit(idx):PlaySoundAtBall "fx_MetalHit":End Sub
Sub aMetalWires_Hit(idx):PlaySoundAtBall "fx_MetalWire":End Sub
Sub aRubber_Bands_Hit(idx):PlaySoundAtBall "fx_rubber_band":End Sub
Sub aRubber_LongBands_Hit(idx):PlaySoundAtBall "fx_rubber_longband":End Sub
Sub aRubber_Posts_Hit(idx):PlaySoundAtBall "fx_rubber_post":End Sub
Sub aRubber_Pins_Hit(idx):PlaySoundAtBall "fx_rubber_pin":End Sub
Sub aRubber_Pegs_Hit(idx):PlaySoundAtBall "fx_rubber_peg":End Sub
Sub aPlastics_Hit(idx):PlaySoundAtBall "fx_PlasticHit":End Sub
Sub aGates_Hit(idx):PlaySoundAtBall "fx_Gate":End Sub
Sub aWoods_Hit(idx):PlaySoundAtBall "fx_Woodhit":End Sub

'***************************************************************
'             Supporting Ball & Sound Functions v4.0
'  includes random pitch in PlaySoundAt and PlaySoundAtBall
'***************************************************************

Dim TableWidth, TableHeight

TableWidth = Table1.width
TableHeight = Table1.height

Function Vol(ball) ' Calculates the Volume of the sound based on the ball speed
    Vol = Csng(BallVel(ball) ^2 / 2000)
End Function

Function Pan(ball) ' Calculates the pan for a ball based on the X position on the table. "table1" is the name of the table
    Dim tmp
    tmp = ball.x * 2 / TableWidth-1
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
    tmp = ball.y * 2 / TableHeight-1
    If tmp > 0 Then
        AudioFade = Csng(tmp ^10)
    Else
        AudioFade = Csng(-((- tmp) ^10))
    End If
End Function

Sub PlaySoundAt(soundname, tableobj) 'play sound at X and Y position of an object, mostly bumpers, flippers and other fast objects
    PlaySound soundname, 0, 1, Pan(tableobj), 0.2, 0, 0, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtBall(soundname) ' play a sound at the ball position, like rubbers, targets, metals, plastics
    PlaySound soundname, 0, Vol(ActiveBall), pan(ActiveBall), 0.2, Pitch(ActiveBall) * 10, 0, 0, AudioFade(ActiveBall)
End Sub

Function RndNbr(n) 'returns a random number between 1 and n
    Randomize timer
    RndNbr = Int((n * Rnd) + 1)
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

'***********************************************
'   JP's VP10 Rolling Sounds + Ballshadow v4.0
'   uses a collection of shadows, aBallShadow
'***********************************************

Const tnob = 19   'total number of balls
Const lob = 2     'number of locked balls
Const maxvel = 40 'max ball velocity
ReDim rolling(tnob)
InitRolling

Sub InitRolling
    Dim i
    For i = 0 to tnob
        rolling(i) = False
    Next
End Sub

Sub RollingUpdate()
    Dim BOT, b, ballpitch, ballvol, speedfactorx, speedfactory
    BOT = GetBalls

    ' stop the sound of deleted balls
    For b = UBound(BOT) + 1 to tnob
        rolling(b) = False
        StopSound("fx_ballrolling" & b)
        aBallShadow(b).Y = 3000
    Next

    ' exit the sub if no balls on the table
    If UBound(BOT) = lob - 1 Then Exit Sub 'there no extra balls on this table

    ' play the rolling sound for each ball and draw the shadow
    For b = lob to UBound(BOT)
        aBallShadow(b).X = BOT(b).X
        aBallShadow(b).Y = BOT(b).Y
        aBallShadow(b).Height = BOT(b).Z -Ballsize/2

        If BallVel(BOT(b))> 1 Then
            If BOT(b).z <30 Then
                ballpitch = Pitch(BOT(b))
                ballvol = Vol(BOT(b))
            Else
                ballpitch = Pitch(BOT(b)) + 50000 'increase the pitch on a ramp
                ballvol = Vol(BOT(b)) * 10
            End If
            rolling(b) = True
            PlaySound("fx_ballrolling" & b), -1, ballvol, Pan(BOT(b)), 0, ballpitch, 1, 0, AudioFade(BOT(b))
        Else
            If rolling(b) = True Then
                StopSound("fx_ballrolling" & b)
                rolling(b) = False
            End If
        End If

        ' rothbauerw's Dropping Sounds
        If BOT(b).VelZ <-1 and BOT(b).z <55 and BOT(b).z> 27 Then 'height adjust for ball drop sounds
            PlaySound "fx_balldrop", 0, ABS(BOT(b).velz) / 17, Pan(BOT(b)), 0, Pitch(BOT(b)), 1, 0, AudioFade(BOT(b))
        End If

        ' jps ball speed control
        If BOT(b).VelX AND BOT(b).VelY <> 0 Then
            speedfactorx = ABS(maxvel / BOT(b).VelX)
            speedfactory = ABS(maxvel / BOT(b).VelY)
            If speedfactorx <1 Then
                BOT(b).VelX = BOT(b).VelX * speedfactorx
                BOT(b).VelY = BOT(b).VelY * speedfactorx
            End If
            If speedfactory <1 Then
                BOT(b).VelX = BOT(b).VelX * speedfactory
                BOT(b).VelY = BOT(b).VelY * speedfactory
            End If
        End If
    Next
End Sub

'*****************************
' Ball 2 Ball Collision Sound
'*****************************

Sub OnBallBallCollision(ball1, ball2, velocity)
    PlaySound("fx_collide"), 0, Csng(velocity) ^2 / 2000, Pan(ball1), 0, Pitch(ball1), 0, 0, AudioFade(ball1)
End Sub


' *********************************************************************
'                        User Defined Script Events
' *********************************************************************

' Initialise the Table for a new Game
'
Sub ResetForNewGame()
    Dim i

    bGameInPLay = True

    'resets the score display, and turn off attract mode
    StopAttractMode
    GiOn

    TotalGamesPlayed = TotalGamesPlayed + 1
    CurrentPlayer = 1
    PlayersPlayingGame = 1
    bOnTheFirstBall = True
    For i = 1 To MaxPlayers
        Score(i) = 0
        BonusPoints(i) = 0
        BonusHeldPoints(i) = 0
        BonusMultiplier(i) = 1
        PlayfieldMultiplier(i) = 1
        BallsRemaining(i) = BallsPerGame
        ExtraBallsAwards(i) = 0
		'TargetHit(i)=0
    Next

    ' initialise any other flags
    Tilt = 0

    ' initialise Game variables
    Game_Init()

    ' you may wish to start some music, play a sound, do whatever at this point

    vpmtimer.addtimer 1500, "FirstBall '" 
End Sub

' This is used to delay the start of a game to allow any attract sequence to
' complete.  When it expires it creates a ball for the player to start playing with

Sub FirstBall


	Dim Delay
    Delay = 1000
    ' reset the table for a new ball
    ResetForNewPlayerBall()


	
	

	
	TimerHistory.Enabled =True

    ' create a new ball in the shooters lane
    vpmtimer.addtimer delay, "CreateNewBall '" 
End Sub



Sub TimerHistory_Timer()
TimerHistory.Enabled=False
GifDMD("ateam_intro_hd")
End Sub


' (Re-)Initialise the Table for a new ball (either a new ball after the player has
' lost one or we have moved onto the next player (if multiple are playing))

Sub ResetForNewPlayerBall()
    ' make sure the correct display is upto date
    AddScore 0

    ' set the current players bonus multiplier back down to 1X
    SetBonusMultiplier 1

    ' reduce the playfield multiplier
    SetPlayfieldMultiplier 1

    ' reset any drop targets, lights, game Mode etc..

    BonusPoints(CurrentPlayer) = 0
    bBonusHeld = False
    bExtraBallWonThisBall = False

    'Reset any table specific
    ResetNewBallVariables
    ResetNewBallLights()

    'This is a new ball, so activate the ballsaver
    bBallSaverReady = True

    'and the skillshot
    bSkillShotReady = True
	TurnOnLogoLights
'Change the music ?
End Sub

' Create a new ball on the Playfield

Sub CreateNewBall()
    ' create a ball in the plunger lane kicker.
    BallRelease.CreateSizedBallWithMass BallSize / 2, BallMass

    ' There is a (or another) ball on the playfield
    BallsOnPlayfield = BallsOnPlayfield + 1

    ' kick it out..
    PlaySoundAt SoundFXDOF("fx_Ballrel", 123, DOFPulse, DOFContactors), BallRelease
    BallRelease.Kick 90, 4


vpmtimer.addtimer 5400, "Check_Ready_TriballTimer_Timer '"


If bSkillShotReady = True Then

	
     If bOnTheFirstBall=True  Then 
		GifDMD("HELICOPTERO1")	
	'	StopSound "mu_end" 
		If LaneIntroDMD(CurrentPlayer) = 0 Then

			PlaySong "Intro_spech"
				
		End if

			'Wait Intro_Spech Sound
		vpmtimer.addtimer 20750, "PlaySoundMu_end '"

	End If
End If

' if there is 2 or more balls then set the multibal flag (remember to check for locked balls and other balls used for animations)
' set the bAutoPlunger flag to kick the ball in play automatically
    If BallsOnPlayfield > 1 Then
        DOF 143, DOFPulse
        bMultiBallMode = True
        bAutoPlunger = True
        ChangeGi 5
    End If
End Sub

Sub PlaySoundMu_end
	If End_mu_active (CurrentPlayer) = True  Then 
		PlaySong "mu_end"
	End If
End Sub 

' Add extra balls to the table with autoplunger
' Use it as AddMultiball 4 to add 4 extra balls to the table

Sub AddMultiball(nballs)
    mBalls2Eject = mBalls2Eject + nballs
    CreateMultiballTimer.Enabled = True
    'and eject the first ball
    CreateMultiballTimer_Timer
End Sub

' Eject the ball after the delay, AddMultiballDelay
Sub CreateMultiballTimer_Timer()
    ' wait if there is a ball in the plunger lane
    If bBallInPlungerLane Then
        Exit Sub
    Else
        If BallsOnPlayfield < MaxMultiballs Then
            CreateNewBall()
            mBalls2Eject = mBalls2Eject -1
            If mBalls2Eject = 0 Then 'if there are no more balls to eject then stop the timer
                CreateMultiballTimer.Enabled = False
            End If
        Else 'the max number of multiballs is reached, so stop the timer
            mBalls2Eject = 0
            CreateMultiballTimer.Enabled = False
        End If
    End If
End Sub

' The Player has lost his ball (there are no more balls on the playfield).
' Handle any bonus points awarded

Sub EndOfBall()
	Dim i
	For i = 0 to 4 
		Status_DMD_Mision (i) = True
	Next
    Dim AwardPoints, TotalBonus, ii
    AwardPoints = 0
    TotalBonus = 0
    ' the first ball has been lost. From this point on no new players can join in
    bOnTheFirstBall = False
	
	Battle_is_Active = False
	GifVanRelancuchActive = True
	Segundos_value = 0
	
    ' only process any of this if the table is not tilted.  (the tilt recovery
    ' mechanism will handle any extra balls or end of game)

    If NOT Tilted Then

'add in any bonus points (multipled by the bonus multiplier)
AwardPoints = BonusPoints(CurrentPlayer) * BonusMultiplier(CurrentPlayer)
AddScore AwardPoints
'debug.print "Bonus Points = " & AwardPoints

		ScoreDMDActive =0
		TiempoActivarDMDScore(3500)

	
	
	'FraseSmallDMD ("BONUS: " & BonusPoints(CurrentPlayer) & " X" & BonusMultiplier(CurrentPlayer) &" EDIT")

	'GifDMD "endofball"

	End_Score_DMD

'DMD "", CL("BONUS: " & BonusPoints(CurrentPlayer) & " X" & BonusMultiplier(CurrentPlayer) ), "", eNone, eBlink, eNone, 1000, True, ""

'Count the bonus. This table uses several bonus
'Lane Bonus
        AwardPoints = LaneBonus * 1000
        TotalBonus = AwardPoints
        'DMD CL(FormatScore(AwardPoints)), CL("LANE BONUS " & LaneBonus), "", eBlink, eNone, eNone, 800, False, ""

        'Number of Target hits
        AwardPoints = TargetBonus * 2000
        TotalBonus = TotalBonus + AwardPoints
        'DMD CL(FormatScore(AwardPoints)), CL("TARGET BONUS " & TargetBonus), "", eBlink, eNone, eNone, 800, False, ""

        'Number of Ramps completed
        AwardPoints = RampBonus * 10000
        TotalBonus = TotalBonus + AwardPoints
        'DMD CL(FormatScore(AwardPoints)), CL("RAMP BONUS " & RampBonus), "", eBlink, eNone, eNone, 800, False, ""

        'Number of Monsters Killed
        AwardPoints = MonstersKilled(CurrentPlayer) * 25000
        TotalBonus = TotalBonus + AwardPoints
        'DMD CL(FormatScore(AwardPoints)), CL("MONSTERS KILLED " & MonstersKilled(CurrentPlayer)), "", eBlink, eNone, eNone, 800, False, ""

        ' calculate the totalbonus
        TotalBonus = TotalBonus * BonusMultiplier(CurrentPlayer) + BonusHeldPoints(CurrentPlayer)

        ' handle the bonus held
        ' reset the bonus held value since it has been already added to the bonus
        BonusHeldPoints(CurrentPlayer) = 0

        ' the player has won the bonus held award so do something with it :)
        If bBonusHeld Then
            If Balls = BallsPerGame Then ' this is the last ball, so if bonus held has been awarded then double the bonus
                TotalBonus = TotalBonus * 2
            End If
        Else ' this is not the last ball so save the bonus for the next ball
            BonusHeldPoints(CurrentPlayer) = TotalBonus
        End If
        bBonusHeld = False

        ' Add the bonus to the score
        'DMD CL(FormatScore(TotalBonus)), CL("TOTAL BONUS " & " X" & BonusMultiplier(CurrentPlayer)), "", eBlinkFast, eNone, eNone, 1500, True, ""

        AddScore TotalBonus

        ' add a bit of a delay to allow for the bonus points to be shown & added up
        vpmtimer.addtimer 9000, "EndOfBall2 '"
    Else 'if tilted then only add a short delay
        vpmtimer.addtimer 100, "EndOfBall2 '"
    End If
	'New MisionStatusLigth
		MisionLight.State = 0
		'Stop bumpers
				LightSeqBumpers.StopPlay
		'Stop Mision Light
				Light1.State = 0
				Light35.State = 0
				Light33.State = 0
				Light2.State = 0

				Light3.State = 0
				Light34.State = 0
				Light36.State = 0
				Light39.State = 0
				Light48.State = 0

				Light4.State = 0
		'Stop Left save Ball Light
				Light002.State = 0
				Light003.State = 0
		'Stop Mision Arrow Light
				Light47.State = 0
        'Stop Luces Jackpot
				Light51.State = 0
				Light41.State = 0
		'Stop luces Logo
			Logo_Light001.State = 0
			Logo_Light002.State = 0
			Logo_Light003.State = 0
			Logo_Light005.State = 0
			Logo_Light007.State = 0
			Logo_Light008.State = 0
			Logo_Light009.State = 0
			Logo_Light010.State = 0	
		'Stop luces Targetas avion
			light19.state = 0
			light20.state = 0

	
				
End Sub

' The Timer which delays the machine to allow any bonus points to be added up
' has expired.  Check to see if there are any extra balls for this player.
' if not, then check to see if this was the last ball (of the CurrentPlayer)
'
Sub EndOfBall2()
    ' if were tilted, reset the internal tilted flag (this will also
    ' set TiltWarnings back to zero) which is useful if we are changing player LOL
    Tilted = False
    Tilt = 0
    DisableTable False 'enable again bumpers and slingshots

    ' has the player won an extra-ball ? (might be multiple outstanding)
    If(ExtraBallsAwards(CurrentPlayer) <> 0)Then
        'debug.print "Extra Ball"

        ' yep got to give it to them
        ExtraBallsAwards(CurrentPlayer) = ExtraBallsAwards(CurrentPlayer)- 1

        ' if no more EB's then turn off any shoot again light
        If(ExtraBallsAwards(CurrentPlayer) = 0)Then
            LightShootAgain.State = 0
        End If

        ' You may wish to do a bit of a song AND dance at this point
		
        ' In this table an extra ball will have the skillshot and ball saver, so we reset the playfield for the new ball
        ResetForNewPlayerBall() 

        ' Create a new ball in the shooters lane
        CreateNewBall()


    Else ' no extra balls

        BallsRemaining(CurrentPlayer) = BallsRemaining(CurrentPlayer)- 1

        ' was that the last ball ?
        If(BallsRemaining(CurrentPlayer) <= 0)Then
            'debug.print "No More Balls, High Score Entry"

            ' Submit the CurrentPlayers score to the High Score system
            CheckHighScore()
        ' you may wish to play some music at this point

        Else

            ' not the last ball (for that player)
            ' if multiple players are playing then move onto the next one

            EndOfBallComplete() 
		
        End If
    End If



End Sub

' This function is called when the end of bonus display
' (or high score entry finished) AND it either end the game or
' move onto the next player (or the next ball of the same player)
'
Sub EndOfBallComplete()

	LuzBackglassOFF
	BlinkCharacterB2STimer. Enabled = False 'aqui
	LuzCharacterBackglass = 0 
	FaseCharacterParpadeo = 0


    Dim NextPlayer

    'debug.print "EndOfBall - Complete"

    ' are there multiple players playing this game ?
    If(PlayersPlayingGame > 1)Then
        ' then move to the next player
        NextPlayer = CurrentPlayer + 1
        ' are we going from the last player back to the first
        ' (ie say from player 4 back to player 1)
        If(NextPlayer > PlayersPlayingGame)Then
            NextPlayer = 1
        End If
    Else
        NextPlayer = CurrentPlayer
    End If

    'debug.print "Next Player = " & NextPlayer

    ' is it the end of the game ? (all balls been lost for all players)
    If((BallsRemaining(CurrentPlayer) <= 0)AND(BallsRemaining(NextPlayer) <= 0))Then
        ' you may wish to do some sort of Point Match free game award here
        ' generally only done when not in free play mode

        ' set the machine into game over mode
        EndOfGame()

    ' you may wish to put a Game Over message on the desktop/backglass

    Else
        ' set the next player
        CurrentPlayer = NextPlayer

        ' make sure the correct display is up to date
        AddScore 0

        ' reset the playfield for the new player (or new ball)
        ResetForNewPlayerBall()

        ' AND create a new ball
        CreateNewBall()

        ' play a sound if more than 1 player
        If PlayersPlayingGame > 1 Then
            PlaySound "vo_player" &CurrentPlayer           
        End If
    End If
End Sub

' This function is called at the End of the Game, it should reset all
' Drop targets, AND eject any 'held' balls, start any attract sequences etc..

Sub EndOfGame()
    'debug.print "End Of Game"
    bGameInPLay = False
    ' just ended your game then play the end of game tune
    If NOT bJustStarted Then
        ChangeSong
    End If

    bJustStarted = False
    ' ensure that the flippers are down
    SolLFlipper 0
    SolRFlipper 0
	
    ' terminate all Mode - eject locked balls

    ' most of the Mode/timers terminate at the end of the ball
		Subir_Puerta
		
    ' set any lights for the attract mode
    GiOff
    StartAttractMode
	InicioDMDScenes()
' you may wish to light any Game Over Light you may have
End Sub

Function Balls
    Dim tmp
    tmp = BallsPerGame - BallsRemaining(CurrentPlayer) + 1
    If tmp > BallsPerGame Then
        Balls = BallsPerGame
    Else
        Balls = tmp
    End If
End Function

' *********************************************************************
'                      Drain / Plunger Functions
' *********************************************************************

' lost a ball ;-( check to see how many balls are on the playfield.
' if only one then decrement the remaining count AND test for End of game
' if more than 1 ball (multi-ball) then kill of the ball but don't create
' a new one
'
Sub Drain_Hit()

    ' Destroy the ball
    Drain.DestroyBall
    ' Exit Sub ' only for debugging - this way you can add balls from the debug window

    BallsOnPlayfield = BallsOnPlayfield - 1

    ' pretend to knock the ball into the ball storage mech
    PlaySoundAt "fx_drain", Drain
    'if Tilted the end Ball Mode
    If Tilted Then
        StopEndOfBallMode
    End If

    ' if there is a game in progress AND it is not Tilted
    If(bGameInPLay = True)AND(Tilted = False)Then

        ' is the ball saver active,
        If(bBallSaverActive = True)Then
			CloseDoor001
            ' yep, create a new ball in the shooters lane
            ' we use the Addmultiball in case the multiballs are being ejected
            AddMultiball 1
            ' we kick the ball with the autoplunger
            bAutoPlunger = True
            ' you may wish to put something on a display or play a sound at this point
            'DMD "_", CL("BALL SAVED"), "_", eNone, eBlinkfast, eNone, 800, True, ""
			
			Playsound "ShootAgain"
        Else
            ' cancel any multiball if on last ball (ie. lost all other balls)
            If(BallsOnPlayfield = 1)Then
                ' AND in a multi-ball??
                If(bMultiBallMode = True)then
                    ' not in multiball mode any more
                    bMultiBallMode = False
                    ' you may wish to change any music over at this point and
                    ' turn off any multiball specific lights
                    ResetJackpotLights

			Subir_Puerta
			TargetHit (CurrentPlayer) =0
			Panel_Bomba.Image = "Contador_10"
			
	  
			
		
                    Select Case Battle(CurrentPlayer, 0)
                        Case 13:WinBattle
                    End Select
                    ChangeGi white
                    ChangeSong
                End If
            End If

            ' was that the last ball on the playfield
            If(BallsOnPlayfield = 0)Then
                ' End Mode and timers
                ChangeSong
                ChangeGi white
                ' Show the end of ball animation
                ' and continue with the end of ball
                ' DMD something?
                StopEndOfBallMode
                vpmtimer.addtimer 200, "EndOfBall '" 'the delay is depending of the animation of the end of ball, since there is no animation then move to the end of ball
            End If
        End If
    End If
		If ExtraballDMD =True AND bBallSaverActive = false Then
		ScoreDMDActive =0
		TiempoActivarDMDScore(3500)
		DoubleFraseDMD "Don`t Move", "SHOOT AGAIN"
			
		End if

		LastSwitchHit = "Drain"
End Sub

' The Ball has rolled out of the Plunger Lane and it is pressing down the trigger in the shooters lane
' Check to see if a ball saver mechanism is needed and if so fire it up.

Sub swPlungerRest_Hit()

		'DEFINE IF IT IS THE FIRST BALL AND THE BALL HAS NOT BEEN PLAYED 
		If LaneIntroDMD(CurrentPlayer) = 0 and Score(CurrentPlayer) = 0 Then
		'SELVA IF POINTS = 0
				vpmtimer.addtimer 5000, "SelvaDMDReady '"
				
				'vpmtimer.addtimer 5000, "GifDMD ""selva"" '"
		LaneIntroDMD (CurrentPlayer) = LaneIntroDMD (CurrentPlayer) +1

		End If

    'debug.print "ball in plunger lane"
    ' some sound according to the ball position
    PlaySoundAt "fx_sensor", swPlungerRest
    bBallInPlungerLane = True
    ' turn on Launch light is there is one
    'LaunchLight.State = 2

    'be sure to update the Scoreboard after the animations, if any

    ' kick the ball in play if the bAutoPlunger flag is on
    If bAutoPlunger Then
        'debug.print "autofire the ball"
        PlungerIM.AutoFire
        DOF 121, DOFPulse
        PlaySoundAt "fx_fire", swPlungerRest
        bAutoPlunger = False
    End If
    ' if there is a need for a ball saver, then start off a timer
    ' only start if it is ready, and it is currently not running, else it will reset the time period
    If(bBallSaverReady = True)AND(BallSaverTime <> 0)And(bBallSaverActive = False)Then
        EnableBallSaver BallSaverTime
    Else
        ' show the message to shoot the ball in case the player has fallen sleep
        swPlungerRest.TimerEnabled = 1
    End If
    'Start the Selection of the skillshot if ready
    
    ' remember last trigger hit by the ball.
    LastSwitchHit = "swPlungerRest"
End Sub


'The ball is not in play

sub SelvaDMDReady
		 If Score(CurrentPlayer) = 0 Then 
				GifDMD "selva"
		 End If
End Sub

' The ball is released from the plunger turn off some flags and check for skillshot

Sub swPlungerRest_UnHit()
    bBallInPlungerLane = False
    swPlungerRest.TimerEnabled = 0 'stop the launch ball timer if active
    If bSkillShotReady Then
        ResetSkillShotTimer.Enabled = 1
    End If
    If bMultiballMode Then
        If BallsOnPlayfield = 2 Then
            ChangeSong
        End If
    Else
		 'ANTES INICIO AUDIO Y DMD
		'ChangeSong
    End If
' turn off LaunchLight
' LaunchLight.State = 0
End Sub

Sub Trigger001_UnHit() 



		If bSkillShotReady Then
			UpdateSkillshot()
			ScoreDMDActive =0
			TiempoActivarDMDScore(10000)
			GifDMD "Skillshot"
			


		Else
		'---------------------------------------------------------
		' Activate start score after 2 seconds
		'---------------------------------------------------------
		TiempoActivarDMDScore(2000)
		'---------------------------------------------------------
		' Activate opening song
		'---------------------------------------------------------
		End If
		
	If Battle(CurrentPlayer, 0) = 0 Then
		StopSound "Intro_spech" 
		ChangeSong
	End If

End Sub



' swPlungerRest timer to show the "launch ball" if the player has not shot the ball during 6 seconds

Sub swPlungerRest_Timer
    swPlungerRest.TimerEnabled = 0
End Sub

Sub EnableBallSaver(seconds)
    'debug.print "Ballsaver started"
    ' set our game flag
    bBallSaverActive = True
    bBallSaverReady = False
    ' start the timer
    BallSaverTimerExpired.Interval = 1000 * seconds
    BallSaverTimerExpired.Enabled = True
    BallSaverSpeedUpTimer.Interval = 1000 * seconds -(1000 * seconds) / 3
    BallSaverSpeedUpTimer.Enabled = True
    ' if you have a ball saver light you might want to turn it on at this point (or make it flash)
    LightShootAgain.BlinkInterval = 160
    LightShootAgain.State = 2
End Sub

' The ball saver timer has expired.  Turn it off AND reset the game flag
'
Sub BallSaverTimerExpired_Timer()
    'debug.print "Ballsaver ended"
    BallSaverTimerExpired.Enabled = False
    ' clear the flag
    bBallSaverActive = False
    ' if you have a ball saver light then turn it off at this point
    LightShootAgain.State = 0
End Sub

Sub BallSaverSpeedUpTimer_Timer()
    'debug.print "Ballsaver Speed Up Light"
    BallSaverSpeedUpTimer.Enabled = False
    ' Speed up the blinking
    LightShootAgain.BlinkInterval = 80
    LightShootAgain.State = 2
End Sub

' *********************************************************************
'                      Supporting Score Functions
' *********************************************************************

' *********************************************************************
'                			 PUNTUACION    
' *********************************************************************




Sub TiempoActivarDMDScore(Valor)
		
	vpmtimer.addtimer Valor, "ActivarDMDScore '"

End Sub


Sub ActivarDMDScore()
        AddScore 0
		ScoreDMDActive =1
End Sub

' Add points to the score AND update the score board
' In this table we use SecondRound variable to double the score points in the second round after killing Malthael
Sub AddScore(points)
    If(Tilted = False)Then
        ' add the points to the current players score variable
       
				'MODO PUNTUACION EN FLEX DMD
				'LLAMADA A SCOREDMDACTIVE PARA SABER SI SE ESTABA REPRODUCIENDO UN GIF
					If ScoreDMDActive =1 Then
						ScoreDMD()
					End If


		Score(CurrentPlayer) = Score(CurrentPlayer) + points * PlayfieldMultiplier(CurrentPlayer)

		AddBonus(points/100)
		
    End if
' you may wish to check to see if the player has gotten a replay
End Sub

' Add bonus to the bonuspoints AND update the score board
Sub AddBonus(points) 'not used in this table, since there are many different bonus items.
    If(Tilted = False)Then
        ' add the bonus to the current players bonus variable
        BonusPoints(CurrentPlayer) = BonusPoints(CurrentPlayer) + points
    End if
End Sub

' Add some points to the current Jackpot.
'
Sub AddJackpot(points)
    ' Jackpots only generally increment in multiball mode AND not tilted
    ' but this doesn't have to be the case
    If(Tilted = False)Then

        ' If(bMultiBallMode = True) Then
        Jackpot(CurrentPlayer) = Jackpot(CurrentPlayer) + points


       ' DMD "_", CL("INCREASED JACKPOT"), "_", eNone, eNone, eNone, 800, True, ""
    ' you may wish to limit the jackpot to a upper limit, ie..
    '	If (Jackpot >= 6000) Then
    '		Jackpot = 6000
    ' 	End if
    'End if
    End if
End Sub

Sub AddSuperJackpot(points) 'not used in this table
    If(Tilted = False)Then
    End if
End Sub

Sub AddBonusMultiplier(n)
    Dim NewBonusLevel
    ' if not at the maximum bonus level
    if(BonusMultiplier(CurrentPlayer) + n <= MaxMultiplier)then
        ' then add and set the lights
        NewBonusLevel = BonusMultiplier(CurrentPlayer) + n
        SetBonusMultiplier(NewBonusLevel)
        'DMD "_", CL("BONUS X " &NewBonusLevel), "_", eNone, eNone, eNone, 2000, True, "fx_bonus"
    Else
        AddScore 50000
        'DMD "_", CL("50000"), "_", eNone, eNone, eNone, 800, True, ""
    End if
End Sub

' Set the Bonus Multiplier to the specified level AND set any lights accordingly

Sub SetBonusMultiplier(Level)
    ' Set the multiplier to the specified level
    BonusMultiplier(CurrentPlayer) = Level
    UPdateBonusXLights(Level)
End Sub

Sub UpdateBonusXLights(Level)
    ' Update the lights
    Select Case Level
        Case 1:light56.State = 0:light57.State = 0:light58.State = 0:light59.State = 0
        Case 2:light56.State = 1:light57.State = 0:light58.State = 0:light59.State = 0
        Case 3:light56.State = 0:light57.State = 1:light58.State = 0:light59.State = 0
        Case 4:light56.State = 0:light57.State = 0:light58.State = 1:light59.State = 0
        Case 5:light56.State = 0:light57.State = 0:light58.State = 0:light59.State = 1
    End Select
End Sub

Sub AddPlayfieldMultiplier(n)
    Dim NewPFLevel
    ' if not at the maximum level x
    if(PlayfieldMultiplier(CurrentPlayer) + n <= MaxMultiplier)then
        ' then add and set the lights
        NewPFLevel = PlayfieldMultiplier(CurrentPlayer) + n
        SetPlayfieldMultiplier(NewPFLevel)
		FraseMediumDMD  ("PLAYFIELD X " &NewPFLevel)
       ' DMD "_", CL("PLAYFIELD X " &NewPFLevel), "_", eNone, eNone, eNone, 2000, True, "fx_bonus"
    Else 'if the 5x is already lit
        AddScore 50000


       ' DMD "_", CL("50000"), "_", eNone, eNone, eNone, 2000, True, ""
    End if
'Start the timer to reduce the playfield x every 30 seconds
' pfxtimer.Enabled = 0
' pfxtimer.Enabled = 1
End Sub

' Set the Playfield Multiplier to the specified level AND set any lights accordingly

Sub SetPlayfieldMultiplier(Level)
    ' Set the multiplier to the specified level
    PlayfieldMultiplier(CurrentPlayer) = Level
    UpdatePFXLights(Level)
End Sub

Sub UpdatePFXLights(Level)
' in this table the multiplier is always shown in the score display sub

' Update the lights
'Select Case Level
'    Case 1:light3.State = 0:light2.State = 0:light1.State = 0:light4.State = 0
'    Case 2:light3.State = 1:light2.State = 0:light1.State = 0:light4.State = 0
'    Case 3:light3.State = 0:light2.State = 1:light1.State = 0:light4.State = 0
'    Case 4:light3.State = 0:light2.State = 0:light1.State = 1:light4.State = 0
'    Case 5:light3.State = 0:light2.State = 0:light1.State = 0:light4.State = 1
'End Select
' show the multiplier in the DMD
End Sub

Sub AwardExtraBall()
    If NOT bExtraBallWonThisBall Then
		ScoreDMDActive =0
		TiempoActivarDMDScore(4000)
		GifDMD "EXTRABALL"
		ExtraballDMD =True
        playsound "vo_extraball"
        DOF 121, DOFPulse
        ExtraBallsAwards(CurrentPlayer) = ExtraBallsAwards(CurrentPlayer) + 1
        bExtraBallWonThisBall = True
		
			

		'LUZ BOLA EXTRA ABAJO
		ExtraBall_Light.State = 1
       ' LightShootAgain.State = 1 'light the shoot again lamp
        GiEffect 2
        LightEffect 2
    END If
End Sub

Sub AwardSpecial()
    'DMD "_", CL(("EXTRA GAME WON")), "_", eNone, eBlink, eNone, 1000, True, SoundFXDOF("fx_Knocker", 122, DOFPulse, DOFKnocker)
    DOF 121, DOFPulse
    Credits = Credits + 1
    If bFreePlay = False Then DOF 125, DOFOn
    LightEffect 2
    FlashEffect 2
End Sub

Sub AwardJackpot() 'award a normal jackpot, double or triple jackpot
    Dim tmp
		ScoreDMDActive =0
		GifDMD("jackpot")
		TiempoActivarDMDScore(4000)
		Addscore 10000000
    DOF 126, DOFPulse
    tmp = INT(RND * 2)
    Select Case tmp
        Case 0:PlaySound "vo_Jackpot"
        Case 1:PlaySound "vo_Jackpot2"
        Case 2:PlaySound "vo_Jackpot3"
    End Select
    AddScore Jackpot(CurrentPlayer)
    LightEffect 2
    FlashEffect 2
    'sjekk for superjackpot
    'EnableSuperJackpot
End Sub

Sub AwardSuperJackpot() 'this is actually 4 times a jackpot
    SuperJackpot = Jackpot(CurrentPlayer) * 4
    'DMD CL(FormatScore(SuperJackpot)), CL("SUPER JACKPOT"), "d_border", eBlinkFast, eBlinkFast, eNone, 1000, True, "vo_superjackpot"
    DOF 126, DOFPulse
    AddScore SuperJackpot
    LightEffect 2
    FlashEffect 2
    'enabled jackpots again
    StartJackpots
End Sub

'*****************************
'    Load / Save / Highscore
'*****************************

Sub Loadhs
    Dim x
    x = LoadValue(TableName, "HighScore1")
    If(x <> "")Then HighScore(0) = CDbl(x)Else HighScore(0) = 100000 End If
    x = LoadValue(TableName, "HighScore1Name")
    If(x <> "")Then HighScoreName(0) = x Else HighScoreName(0) = "AAA" End If
    x = LoadValue(TableName, "HighScore2")
    If(x <> "")then HighScore(1) = CDbl(x)Else HighScore(1) = 100000 End If
    x = LoadValue(TableName, "HighScore2Name")
    If(x <> "")then HighScoreName(1) = x Else HighScoreName(1) = "BBB" End If
    x = LoadValue(TableName, "HighScore3")
    If(x <> "")then HighScore(2) = CDbl(x)Else HighScore(2) = 100000 End If
    x = LoadValue(TableName, "HighScore3Name")
    If(x <> "")then HighScoreName(2) = x Else HighScoreName(2) = "CCC" End If
    x = LoadValue(TableName, "HighScore4")
    If(x <> "")then HighScore(3) = CDbl(x)Else HighScore(3) = 100000 End If
    x = LoadValue(TableName, "HighScore4Name")
    If(x <> "")then HighScoreName(3) = x Else HighScoreName(3) = "DDD" End If
    x = LoadValue(TableName, "Credits")
    If(x <> "")then Credits = CInt(x)Else Credits = 0:If bFreePlay = False Then DOF 125, DOFOff:End If
    x = LoadValue(TableName, "TotalGamesPlayed")
    If(x <> "")then TotalGamesPlayed = CInt(x)Else TotalGamesPlayed = 0 End If
End Sub

Sub Savehs
    SaveValue TableName, "HighScore1", HighScore(0)
    SaveValue TableName, "HighScore1Name", HighScoreName(0)
    SaveValue TableName, "HighScore2", HighScore(1)
    SaveValue TableName, "HighScore2Name", HighScoreName(1)
    SaveValue TableName, "HighScore3", HighScore(2)
    SaveValue TableName, "HighScore3Name", HighScoreName(2)
    SaveValue TableName, "HighScore4", HighScore(3)
    SaveValue TableName, "HighScore4Name", HighScoreName(3)
    SaveValue TableName, "Credits", Credits
    SaveValue TableName, "TotalGamesPlayed", TotalGamesPlayed
End Sub

Sub Reseths
    HighScoreName(0) = "AAA"
    HighScoreName(1) = "BBB"
    HighScoreName(2) = "CCC"
    HighScoreName(3) = "DDD"
    HighScore(0) = 100000
    HighScore(1) = 100000
    HighScore(2) = 100000
    HighScore(3) = 100000
    Savehs
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
    Dim tmp
    tmp = Score(CurrentPlayer)

    If tmp > HighScore(0)Then 'add 1 credit for beating the highscore
        Credits = Credits + 1
        DOF 125, DOFOn
    End If

    If tmp > HighScore(3)Then
        PlaySound SoundFXDOF("fx_Knocker", 122, DOFPulse, DOFKnocker)
        DOF 121, DOFPulse
        HighScore(3) = tmp
        'enter player's name
        HighScoreEntryInit()
    Else
        EndOfBallComplete()
    End If
End Sub

Sub HighScoreEntryInit()
    hsbModeActive = True
    'PlaySound "vo_greatscore" &RndNbr(6)
    hsLetterFlash = 0


    hsEnteredDigits(0) = "A"
    hsEnteredDigits(1) = "A"
    hsEnteredDigits(2) = "A"
    hsCurrentDigit = 0

    hsValidLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789<" ' < is back arrow
    hsCurrentLetter = 1
    DMDFlush()
    HighScoreDisplayNameNow()
    HighScoreFlashTimer.Interval = 250
    HighScoreFlashTimer.Enabled = True

End Sub

Sub EnterHighScoreKey(keycode)
    If keycode = LeftFlipperKey Then
        playsound "fx_Previous"
        hsCurrentLetter = hsCurrentLetter - 1
        if(hsCurrentLetter = 0)then
            hsCurrentLetter = len(hsValidLetters)
        end if
        HighScoreDisplayNameNow()
    End If

    If keycode = RightFlipperKey Then
        playsound "fx_Next"
        hsCurrentLetter = hsCurrentLetter + 1
        if(hsCurrentLetter > len(hsValidLetters))then
            hsCurrentLetter = 1
        end if
        HighScoreDisplayNameNow()
    End If

    If keycode = PlungerKey OR keycode = StartGameKey Then
        if(mid(hsValidLetters, hsCurrentLetter, 1) <> "<")then
            playsound "fx_Enter"
            hsEnteredDigits(hsCurrentDigit) = mid(hsValidLetters, hsCurrentLetter, 1)
            hsCurrentDigit = hsCurrentDigit + 1
            if(hsCurrentDigit = 3)then
                HighScoreCommitName()
            else
                HighScoreDisplayNameNow()
            end if
        else
            playsound "fx_Esc"
            hsEnteredDigits(hsCurrentDigit) = " "
            if(hsCurrentDigit > 0)then
                hsCurrentDigit = hsCurrentDigit - 1
            end if
            HighScoreDisplayNameNow()
        end if
    end if
End Sub

Sub HighScoreDisplayNameNow()
    HighScoreFlashTimer.Enabled = False
    hsLetterFlash = 0
    HighScoreDisplayName()
    HighScoreFlashTimer.Enabled = True
End Sub



Sub HighScoreFlashTimer_Timer()
    HighScoreFlashTimer.Enabled = False
    hsLetterFlash = hsLetterFlash + 1
    if(hsLetterFlash = 2)then hsLetterFlash = 0
    HighScoreDisplayName()
    HighScoreFlashTimer.Enabled = True
End Sub

Sub HighScoreCommitName()
    HighScoreFlashTimer.Enabled = False
    hsbModeActive = False

    hsEnteredName = hsEnteredDigits(0) & hsEnteredDigits(1) & hsEnteredDigits(2)
    if(hsEnteredName = "AAA")then
        hsEnteredName = "YOU"
    end if

    HighScoreName(3) = hsEnteredName
    SortHighscore
    EndOfBallComplete()
End Sub

Sub SortHighscore
    Dim tmp, tmp2, i, j
    For i = 0 to 3
        For j = 0 to 2
            If HighScore(j) < HighScore(j + 1)Then
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

' *************************************************************************
'   JP's Reduced Display Driver Functions (based on script by Black)
' only 5 effects: none, scroll left, scroll right, blink and blinkfast
' 3 Lines, treats all 3 lines as text.
' 1st and 2nd lines are 20 characters long
' 3rd line is just 1 character
' Example format:
' DMD "text1","text2","backpicture", eNone, eNone, eNone, 250, True, "sound"
' Short names:
' dq = display queue
' de = display effect
' *************************************************************************

Const eNone = 0        ' Instantly displayed
Const eScrollLeft = 1  ' scroll on from the right
Const eScrollRight = 2 ' scroll on from the left
Const eBlink = 3       ' Blink (blinks for 'TimeOn')
Const eBlinkFast = 4   ' Blink (blinks for 'TimeOn') at user specified intervals (fast speed)

Const dqSize = 64

Dim dqHead
Dim dqTail
Dim deSpeed
Dim deBlinkSlowRate
Dim deBlinkFastRate

Dim dCharsPerLine(2)
Dim dLine(2)
Dim deCount(2)
Dim deCountEnd(2)
Dim deBlinkCycle(2)

Dim dqText(2, 64)
Dim dqEffect(2, 64)
Dim dqTimeOn(64)
Dim dqbFlush(64)
Dim dqSound(64)



Function ExpandLine(TempStr) 'id is the number of the dmd line
    If TempStr = "" Then
        TempStr = Space(20)
    Else
        if Len(TempStr) > Space(20)Then
            TempStr = Left(TempStr, Space(20))
        Else
            if(Len(TempStr) < 20)Then
                TempStr = TempStr & Space(20 - Len(TempStr))
            End If
        End If
    End If
    ExpandLine = TempStr
End Function

Function FormatScore(ByVal Num) 'it returns a string with commas (as in Black's original font)
    dim i
    dim NumString
    NumString = CStr(abs(Num))
    For i = Len(NumString)-3 to 1 step -3
        if IsNumeric(mid(NumString, i, 1))then
            NumString = left(NumString, i-1) & chr(asc(mid(NumString, i, 1)) + 128) & right(NumString, Len(NumString)- i)
        end if
    Next
    FormatScore = NumString
End function

Function FL(NumString1, NumString2) 'Fill line
    Dim Temp, TempStr
    If Len(NumString1) + Len(NumString2) < 20 Then
        Temp = 20 - Len(NumString1)- Len(NumString2)
        TempStr = NumString1 & Space(Temp) & NumString2
        FL = TempStr
    End If
End Function

Function CL(NumString) 'center line
    Dim Temp, TempStr
    If Len(NumString) > 20 Then NumString = Left(NumString, 20)
    Temp = (20 - Len(NumString)) \ 2
    TempStr = Space(Temp) & NumString & Space(Temp)
    CL = TempStr
End Function

Function RL(NumString) 'right line
    Dim Temp, TempStr
    If Len(NumString) > 20 Then NumString = Left(NumString, 20)
    Temp = 20 - Len(NumString)
    TempStr = Space(Temp) & NumString
    RL = TempStr
End Function

'**************
' Update DMD
'**************

Sub DMDUpdate(id)
    Dim digit, value
    If UseFlexDMD Then FlexDMD.LockRenderThread
    Select Case id
        Case 0 'top text line
            For digit = 0 to 19
                DMDDisplayChar mid(dLine(0), digit + 1, 1), digit
            Next
        Case 1 'bottom text line
            For digit = 20 to 39
                DMDDisplayChar mid(dLine(1), digit -19, 1), digit
            Next
        Case 2 ' back image - back animations
            If dLine(2) = "" OR dLine(2) = " " Then dLine(2) = "bkempty"
            Digits(40).ImageA = dLine(2)
            If UseFlexDMD Then DMDScene.GetImage("Back").Bitmap = FlexDMD.NewImage("", "VPX." & dLine(2) & "&dmd=2").Bitmap
    End Select
    If UseFlexDMD Then FlexDMD.UnlockRenderThread
End Sub

Sub DMDDisplayChar(achar, adigit)
    If achar = "" Then achar = " "
    achar = ASC(achar)
    Digits(adigit).ImageA = Chars(achar)
    If UseFlexDMD Then DMDScene.GetImage("Dig" & adigit).Bitmap = FlexDMD.NewImage("", "VPX." & Chars(achar) & "&dmd=2&add").Bitmap
End Sub

'****************************
' JP's new DMD using flashers
'****************************

Dim Digits, DigitsBack, Chars(255), Images(255)

'DMDInit

Sub DMDInit
    Dim i
    Digits = Array(digit001, digit002, digit003, digit004, digit005, digit006, digit007, digit008, digit009, digit010, _
        digit011, digit012, digit013, digit014, digit015, digit016, digit017, digit018, digit019, digit020,            _
        digit021, digit022, digit023, digit024, digit025, digit026, digit027, digit028, digit029, digit030,            _
        digit031, digit032, digit033, digit034, digit035, digit036, digit037, digit038, digit039, digit040,            _
        digit041)
    For i = 0 to 255:Chars(i) = "d_empty":Next

    Chars(32) = "d_empty"
    Chars(33) = ""        '!
    Chars(34) = ""        '"
    Chars(35) = ""        '#
    Chars(36) = ""        '$
    Chars(37) = ""        '%
    Chars(38) = ""        '&
    Chars(39) = ""        ''
    Chars(40) = ""        '(
    Chars(41) = ""        ')
    Chars(42) = ""        '*
    Chars(43) = ""        '+
    Chars(44) = ""        '
    Chars(45) = "d_minus" '-
    Chars(46) = "d_dot"   '.
    Chars(47) = ""        '/
    Chars(48) = "d_0"     '0
    Chars(49) = "d_1"     '1
    Chars(50) = "d_2"     '2
    Chars(51) = "d_3"     '3
    Chars(52) = "d_4"     '4
    Chars(53) = "d_5"     '5
    Chars(54) = "d_6"     '6
    Chars(55) = "d_7"     '7
    Chars(56) = "d_8"     '8
    Chars(57) = "d_9"     '9
    Chars(60) = "d_less"  '<
    Chars(61) = ""        '=
    Chars(62) = "d_more"  '>
    Chars(64) = ""        '@
    Chars(65) = "d_a"     'A
    Chars(66) = "d_b"     'B
    Chars(67) = "d_c"     'C
    Chars(68) = "d_d"     'D
    Chars(69) = "d_e"     'E
    Chars(70) = "d_f"     'F
    Chars(71) = "d_g"     'G
    Chars(72) = "d_h"     'H
    Chars(73) = "d_i"     'I
    Chars(74) = "d_j"     'J
    Chars(75) = "d_k"     'K
    Chars(76) = "d_l"     'L
    Chars(77) = "d_m"     'M
    Chars(78) = "d_n"     'N
    Chars(79) = "d_o"     'O
    Chars(80) = "d_p"     'P
    Chars(81) = "d_q"     'Q
    Chars(82) = "d_r"     'R
    Chars(83) = "d_s"     'S
    Chars(84) = "d_t"     'T
    Chars(85) = "d_u"     'U
    Chars(86) = "d_v"     'V
    Chars(87) = "d_w"     'W
    Chars(88) = "d_x"     'X
    Chars(89) = "d_y"     'Y
    Chars(90) = "d_z"     'Z
    Chars(94) = "d_up"    '^
    '    Chars(95) = '_
    Chars(96) = ""
    Chars(97) = ""  'a
    Chars(98) = ""  'b
    Chars(99) = ""  'c
    Chars(100) = "" 'd
    Chars(101) = "" 'e
    Chars(102) = "" 'f
    Chars(103) = "" 'g
    Chars(104) = "" 'h
    Chars(105) = "" 'i
    Chars(106) = "" 'j
    Chars(107) = "" 'k
    Chars(108) = "" 'l
    Chars(109) = "" 'm
    Chars(110) = "" 'n
    Chars(111) = "" 'o
    Chars(112) = "" 'p
    Chars(113) = "" 'q
    Chars(114) = "" 'r
    Chars(115) = "" 's
    Chars(116) = "" 't
    Chars(117) = "" 'u
    Chars(118) = "" 'v
    Chars(119) = "" 'w
    Chars(120) = "" 'x
    Chars(121) = "" 'y
    Chars(122) = "" 'z
    Chars(123) = "" '{
    Chars(124) = "" '|
    Chars(125) = "" '}
    Chars(126) = "" '~
    'used in the FormatScore function
    Chars(176) = "d_0a" '0.
    Chars(177) = "d_1a" '1.
    Chars(178) = "d_2a" '2.
    Chars(179) = "d_3a" '3.
    Chars(180) = "d_4a" '4.
    Chars(181) = "d_5a" '5.
    Chars(182) = "d_6a" '6.
    Chars(183) = "d_7a" '7.
    Chars(184) = "d_8a" '8.
    Chars(185) = "d_9a" '9.
End Sub


'****************************************
' Real Time updatess using the GameTimer
'****************************************
'used for all the real time updates

Sub Realtime_Timer
    RollingUpdate
    ' add any other real time update subs, like gates or diverters
    doorp.Roty = - DoorF.CurrentAngle + 90
	doorp001.Roty = - DoorF001.CurrentAngle + 90
    LeftFlipperTop.RotZ = LeftFlipper.CurrentAngle
    RightFlipperTop.RotZ = RightFlipper.CurrentAngle

	
	
End Sub

'********************************************************************************************
' Only for VPX 10.2 and higher.
' FlashForMs will blink light or a flasher for TotalPeriod(ms) at rate of BlinkPeriod(ms)
' When TotalPeriod done, light or flasher will be set to FinalState value where
' Final State values are:   0=Off, 1=On, 2=Return to previous State
'********************************************************************************************

Sub FlashForMs(MyLight, TotalPeriod, BlinkPeriod, FinalState) 'thanks gtxjoe for the first version

    If TypeName(MyLight) = "Light" Then

        If FinalState = 2 Then
            FinalState = MyLight.State 'Keep the current light state
        End If
        MyLight.BlinkInterval = BlinkPeriod
        MyLight.Duration 2, TotalPeriod, FinalState
    ElseIf TypeName(MyLight) = "Flasher" Then

        Dim steps

        ' Store all blink information
        steps = Int(TotalPeriod / BlinkPeriod + .5) 'Number of ON/OFF steps to perform
        If FinalState = 2 Then                      'Keep the current flasher state
            FinalState = ABS(MyLight.Visible)
        End If
        MyLight.UserValue = steps * 10 + FinalState 'Store # of blinks, and final state

        ' Start blink timer and create timer subroutine
        MyLight.TimerInterval = BlinkPeriod
        MyLight.TimerEnabled = 0
        MyLight.TimerEnabled = 1
        ExecuteGlobal "Sub " & MyLight.Name & "_Timer:" & "Dim tmp, steps, fstate:tmp=me.UserValue:fstate = tmp MOD 10:steps= tmp\10 -1:Me.Visible = steps MOD 2:me.UserValue = steps *10 + fstate:If Steps = 0 then Me.Visible = fstate:Me.TimerEnabled=0:End if:End Sub"
    End If
End Sub

'******************************************
' Change light color - simulate color leds
' changes the light color and state
' 12 colors: red, orange, amber, yellow...
'******************************************

'colors
Const red = 1
Const orange = 2
Const amber = 3
Const yellow = 4
Const darkgreen = 5
Const green = 6
Const blue = 7
Const darkblue = 8
Const purple = 9
Const white = 10
Const teal = 11
Const ledwhite = 12

Sub SetLightColor(n, col, stat) 'stat 0 = off, 1 = on, 2 = blink, -1= no change
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
            n.color = RGB(0, 16, 0)
            n.colorfull = RGB(0, 128, 0)
        Case blue
            n.color = RGB(0, 18, 18)
            n.colorfull = RGB(0, 255, 255)
        Case darkblue
            n.color = RGB(0, 8, 8)
            n.colorfull = RGB(0, 64, 64)
        Case purple
            n.color = RGB(64, 0, 96)
            n.colorfull = RGB(128, 0, 192)
        Case white 'bulb
            n.color = RGB(193, 91, 0)
            n.colorfull = RGB(255, 197, 143)
        Case teal
            n.color = RGB(1, 64, 62)
            n.colorfull = RGB(2, 128, 126)
        Case ledwhite
            n.color = RGB(255, 197, 143)
            n.colorfull = RGB(255, 252, 224)
    End Select
    If stat <> -1 Then
        n.State = 0
        n.State = stat
    End If
End Sub

Sub SetFlashColor(n, col, stat) 'stat 0 = off, 1 = on, -1= no change - no blink for the flashers, use FlashForMs
    Select Case col
        Case red
            n.color = RGB(255, 0, 0)
        Case orange
            n.color = RGB(255, 64, 0)
        Case amber
            n.color = RGB(255, 153, 0)
        Case yellow
            n.color = RGB(255, 255, 0)
        Case darkgreen
            n.color = RGB(0, 64, 0)
        Case green
            n.color = RGB(0, 128, 0)
        Case blue
            n.color = RGB(0, 255, 255)
        Case darkblue
            n.color = RGB(0, 64, 64)
        Case purple
            n.color = RGB(128, 0, 192)
        Case white 'bulb
            n.color = RGB(255, 197, 143)
        Case teal
            n.color = RGB(2, 128, 126)
         Case ledwhite
            n.color = RGB(255, 252, 224)
    End Select
    If stat <> -1 Then
        n.Visible = stat
    End If
End Sub

'*************************
' Rainbow Changing Lights
'*************************

Dim RGBStep, RGBFactor, rRed, rGreen, rBlue, RainbowLights

Sub StartRainbow(n)
    set RainbowLights = n
    RGBStep = 0
    RGBFactor = 5
    rRed = 255
    rGreen = 0
    rBlue = 0
    RainbowTimer.Enabled = 1
End Sub

Sub StopRainbow()
    Dim obj
    RainbowTimer.Enabled = 0
    RainbowTimer.Enabled = 0
End Sub

Sub RainbowTimer_Timer 'rainbow led light color changing
    Dim obj
    Select Case RGBStep
        Case 0 'Green
            rGreen = rGreen + RGBFactor
            If rGreen > 255 then
                rGreen = 255
                RGBStep = 1
            End If
        Case 1 'Red
            rRed = rRed - RGBFactor
            If rRed < 0 then
                rRed = 0
                RGBStep = 2
            End If
        Case 2 'Blue
            rBlue = rBlue + RGBFactor
            If rBlue > 255 then
                rBlue = 255
                RGBStep = 3
            End If
        Case 3 'Green
            rGreen = rGreen - RGBFactor
            If rGreen < 0 then
                rGreen = 0
                RGBStep = 4
            End If
        Case 4 'Red
            rRed = rRed + RGBFactor
            If rRed > 255 then
                rRed = 255
                RGBStep = 5
            End If
        Case 5 'Blue
            rBlue = rBlue - RGBFactor
            If rBlue < 0 then
                rBlue = 0
                RGBStep = 0
            End If
    End Select
    For each obj in RainbowLights
        obj.color = RGB(rRed \ 10, rGreen \ 10, rBlue \ 10)
        obj.colorfull = RGB(rRed, rGreen, rBlue)
    Next
End Sub

' ********************************
'   Table info & Attract Mode
' ********************************

Sub ShowTableInfo
    Dim ii
    'info goes in a loop only stopped by the credits and the startkey
    If Score(1)Then
        'DMD CL("LAST SCORE"), CL("PLAYER 1 " &FormatScore(Score(1))), "", eNone, eNone, eNone, 3000, False, ""
    End If
    If Score(2)Then
        'DMD CL("LAST SCORE"), CL("PLAYER 2 " &FormatScore(Score(2))), "", eNone, eNone, eNone, 3000, False, ""
    End If
    If Score(3)Then
        'DMD CL("LAST SCORE"), CL("PLAYER 3 " &FormatScore(Score(3))), "", eNone, eNone, eNone, 3000, False, ""
    End If
    If Score(4)Then
        'DMD CL("LAST SCORE"), CL("PLAYER 4 " &FormatScore(Score(4))), "", eNone, eNone, eNone, 3000, False, ""
    End If
    'DMD "", CL("GAME OVER"), "", eNone, eBlink, eNone, 2000, False, ""
    If bFreePlay Then
        'DMD "", CL("FREE PLAY"), "", eNone, eBlink, eNone, 2000, False, ""
    Else
        If Credits > 0 Then
           ' DMD CL("CREDITS " & Credits), CL("PRESS START"), "", eNone, eBlink, eNone, 2000, False, ""
        Else
            'DMD CL("CREDITS " & Credits), CL("INSERT COIN"), "", eNone, eBlink, eNone, 2000, False, ""
        End If
    End If

    'DMD "        JPSALAS", "        PRESENTS", "d_jppresents", eNone, eNone, eNone, 3000, False, ""
   ' DMD "", "", "SeriousSam2", eNone, eNone, eNone, 4000, False, ""
   ' DMD "", CL("ROM VERSION " &myversion), "", eNone, eNone, eNone, 2000, False, ""
    'DMD CL("HIGHSCORES"), Space(dCharsPerLine(1)), "", eScrollLeft, eScrollLeft, eNone, 20, False, ""
    'DMD CL("HIGHSCORES"), "", "", eBlinkFast, eNone, eNone, 1000, False, ""
    'DMD CL("HIGHSCORES"), "1> " &HighScoreName(0) & " " &FormatScore(HighScore(0)), "", eNone, eScrollLeft, eNone, 2000, False, ""
   ' DMD "_", "2> " &HighScoreName(1) & " " &FormatScore(HighScore(1)), "", eNone, eScrollLeft, eNone, 2000, False, ""
    'DMD "_", "3> " &HighScoreName(2) & " " &FormatScore(HighScore(2)), "", eNone, eScrollLeft, eNone, 2000, False, ""
   ' DMD "_", "4> " &HighScoreName(3) & " " &FormatScore(HighScore(3)), "", eNone, eScrollLeft, eNone, 2000, False, ""
    'DMD Space(dCharsPerLine(0)), Space(dCharsPerLine(1)), "", eScrollLeft, eScrollLeft, eNone, 500, False, ""
End Sub

Sub StartAttractMode
    ChangeSong
    StartLightSeq
    
    ShowTableInfo
End Sub

Sub StopAttractMode
    'DMDScoreNow
    LightSeqAttract.StopPlay
    LightSeqFlasher.StopPlay
End Sub

Sub StartLightSeq() 'esta desactivado despues de cambiar el dmd hisgscore
    'lights sequences
    LightSeqFlasher.UpdateInterval = 150
    LightSeqFlasher.Play SeqRandom, 10, , 50000
    LightSeqAttract.UpdateInterval = 25
    LightSeqAttract.Play SeqBlinking, , 5, 150
    LightSeqAttract.Play SeqRandom, 40, , 4000
    LightSeqAttract.Play SeqAllOff
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 50, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqCircleOutOn, 15, 2
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 10
    LightSeqAttract.Play SeqCircleOutOn, 15, 3
    LightSeqAttract.UpdateInterval = 5
    LightSeqAttract.Play SeqRightOn, 50, 1
    LightSeqAttract.UpdateInterval = 5
    LightSeqAttract.Play SeqLeftOn, 50, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 50, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 50, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 40, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 40, 1
    LightSeqAttract.UpdateInterval = 10
    LightSeqAttract.Play SeqRightOn, 30, 1
    LightSeqAttract.UpdateInterval = 10
    LightSeqAttract.Play SeqLeftOn, 30, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 15, 1
    LightSeqAttract.UpdateInterval = 10
    LightSeqAttract.Play SeqCircleOutOn, 15, 3
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 5
    LightSeqAttract.Play SeqStripe1VertOn, 50, 2
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqCircleOutOn, 15, 2
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqStripe1VertOn, 50, 3
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqCircleOutOn, 15, 2
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqStripe2VertOn, 50, 3
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 25, 1
	LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 25, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqStripe1VertOn, 25, 3
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqStripe2VertOn, 25, 3
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqUpOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqDownOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqRightOn, 15, 1
    LightSeqAttract.UpdateInterval = 8
    LightSeqAttract.Play SeqLeftOn, 15, 1
End Sub

Sub LightSeqAttract_PlayDone()
    StartLightSeq()
End Sub

Sub LightSeqTilt_PlayDone()
    LightSeqTilt.Play SeqAllOff
End Sub

Sub LightSeqSkillshot_PlayDone()
    LightSeqSkillshot.Play SeqAllOff
End Sub

'***************************
'   LUT - Darkness control 
'***************************

Dim bLutActive, LUTImage

Sub LoadLUT
    bLutActive = False
    x = LoadValue(cGameName, "LUTImage")
    If(x <> "")Then LUTImage = x Else LUTImage = 6
    UpdateLUT
End Sub

Sub SaveLUT
    SaveValue cGameName, "LUTImage", LUTImage
End Sub

Sub NextLUT:LUTImage = (LUTImage + 1)MOD 15:UpdateLUT:SaveLUT:Lutbox.text = "level of darkness " & LUTImage:End Sub

Sub UpdateLUT
    Select Case LutImage
        Case 0:table1.ColorGradeImage = "LUT0":GiIntensity = 1:ChangeGIIntensity 1
        Case 1:table1.ColorGradeImage = "LUT1":GiIntensity = 1.05:ChangeGIIntensity 1
        Case 2:table1.ColorGradeImage = "LUT2":GiIntensity = 1.1:ChangeGIIntensity 1
        Case 3:table1.ColorGradeImage = "LUT3":GiIntensity = 1.15:ChangeGIIntensity 1
        Case 4:table1.ColorGradeImage = "LUT4":GiIntensity = 1.2:ChangeGIIntensity 1
        Case 5:table1.ColorGradeImage = "LUT5":GiIntensity = 1.25:ChangeGIIntensity 1
        Case 6:table1.ColorGradeImage = "LUT6":GiIntensity = 1.3:ChangeGIIntensity 1
        Case 7:table1.ColorGradeImage = "LUT7":GiIntensity = 1.35:ChangeGIIntensity 1
        Case 8:table1.ColorGradeImage = "LUT8":GiIntensity = 1.4:ChangeGIIntensity 1
        Case 9:table1.ColorGradeImage = "LUT9":GiIntensity = 1.45:ChangeGIIntensity 1
        Case 10:table1.ColorGradeImage = "LUT10":GiIntensity = 1.5:ChangeGIIntensity 1
        Case 11:table1.ColorGradeImage = "LUT11":GiIntensity = 1.55:ChangeGIIntensity 1
        Case 12:table1.ColorGradeImage = "LUT12":GiIntensity = 1.6:ChangeGIIntensity 1
        Case 13:table1.ColorGradeImage = "LUT13":GiIntensity = 1.65:ChangeGIIntensity 1
        Case 14:table1.ColorGradeImage = "LUT14":GiIntensity = 1.7:ChangeGIIntensity 1
    End Select
End Sub

Dim GiIntensity
GiIntensity = 1               'used for the LUT changing to increase the GI lights when the table is darker

Sub ChangeGIIntensity(factor) 'changes the intensity scale
    Dim bulb
    For each bulb in aGILights
        bulb.IntensityScale = GiIntensity * factor
    Next
End Sub

'***********************************************************************
' *********************************************************************
'                     Table Specific Script Starts Here
' *********************************************************************
'***********************************************************************

' droptargets, animations, etc
Sub VPObjects_Init
End Sub

' tables variables and Mode init
Dim LaneBonus
Dim TargetBonus
Dim TargetHannibal
Dim RampBonus
Dim BumperValue(4)
Dim BumperHits
Dim SpinnerValue(4)
Dim MonstersKilled(4)

Dim SpinCount

Dim RampHits12
Dim OrbitHits
Dim TargetHits9

Dim CaptiveBallHits
Dim LightHits9
Dim LightHits11
Dim loopCount (4)
Dim BattlesWon(4)
Dim Battle(4, 15) '12 battles, 1 final battle
Dim NewBattle

Dim FindtheBox (4) 'Battle1 Variables

Dim PowerupHits



Sub Game_Init() 'called at the start of a new game

	

    Dim i, j
    bExtraBallWonThisBall = False
    'Play some Music
    ChangeSong
    'Init Variables
    LaneBonus = 0 'it gets deleted when a new ball is launched
    TargetBonus = 0
	TargetHannibal = 0
    RampBonus = 0
    BumperHits = 0
    For i = 1 to 4
        SkillshotValue(i) = 0
        Jackpot(i) = 100000
        MonstersKilled(i) = 0
        BallsInLock(i) = 0
        SpinnerValue(i) = 1000
        BumperValue(i) = 500 'start at 210 and every 30 hits its value is increased by 500 points
		SuperBumperHits(i) =0
		TargetHits8(i) = 0
		SpinCountMision (i) =0
		RampHits3 (i) = 0
		TargetHit (i) =0
		'MisionStatus for new game=0
		 MisionStatusLigth(i,i)=0
		ContadorMisionDone(i)=0
		Mision(i, 0)=0
		Mision(i, 1)=0
		Mision(i, 2)=0
		Mision(i, 3)=0
		Mision(i, 4)=0
		Draw(i, 0)=0
		Draw(i, 1)=0
		Draw(i, 2)=0
		Draw(i, 3)=0
		Draw(i, 4)=0
		Draw(i, 5)=0
		Draw(i, 6)=0
		Draw(i, 7)=0
		Draw(i, 8)=0
		Draw(i, 9)=0
		Draw(i, 10)=0
		MisionStatusLigth(CurrentPlayer,i)=0
		ScoreBumpers (i) = 50
		RedayTriballDMD (i) = False
		End_mu_active (i)= True
		Activacion_Misiones (i) = 1
		Activacion_Weel_of_Fortune(i) = 1
		Status_DMD_Mision (i) = True
		FindtheBox (i) = 0
		loopCount(i)=0
		Lane_Saved(i) =0
		FindAndShoot_Scores(i) = 0
		MrLee_Value (i) = 10
		Norepetirmision (i,1)=0
		Norepetirmision (i,2)=0
		Norepetirmision (i,3)=0
		Norepetirmision (i,4)=0
		Not_Repeat_Draw_number (i,0)=0
		Not_Repeat_Draw_number (i,1)=0
		Not_Repeat_Draw_number (i,2)=0
		Not_Repeat_Draw_number (i,3)=0
		Not_Repeat_Draw_number (i,4)=0
		Not_Repeat_Draw_number (i,5)=0
		Not_Repeat_Draw_number (i,6)=0
		Not_Repeat_Draw_number (i,7)=0
		Not_Repeat_Draw_number (i,8)=0
		Not_Repeat_Draw_number (i,9)=0
		Not_Repeat_Draw_number (i,10)=0
		Rail_Lotery_Pos (i) = 0
		Vel_Rail (i) = 8
		Stop_Rail (i)= False
		Lotery_Value (i) = 0
		Rail_Relativo (i) = 0
		LaneIntroDMD(i) = 0
		SpellTeam (i,1) = 0
		SpellTeam (i,2) = 0
		SpellTeam (i,3) = 0
		SpellTeam (i,4) = 0
		TargetS1_Status (i)= 0
		TargetS2_Status (i)= 0
		TargetS3_Status (i)= 0
		TargetS4_Status (i)= 0
		Door_is_open(i)= False
		SuperTargets = False
		Door_Bloqued = False
		ExtraballDMD= False
		GifDMDBumper_active = false
		Repeat_DMD_From_Start = True

		
    Next

	Battle_is_Active= False
	Dmd_Rest_Active = True
	VideoModeActive= False 'UNLOCK THE FLIPPERS VIDEOMODE
	Panel_Bomba.Image = "contador_0"
    ResetBattles
	ResetMisions
	ResetDraw
	SpinCount = 0
    Pausa_DMD = False
    RampHits12 = 0
    OrbitHits = 0
    TargetHits9 = 0
    CaptiveBallHits = 0
    PowerupHits = 0
    LightHits9 = 0
    LightHits11 = 0
	Punch_Out_Value =0
	RunAway_Value = 0
	CursorX = 0
	FindAndShoot_Value = 0
	Rail_Stopped = 0
	UpAllTargetHannibal

	LeftFlipperPressed = False
	RightFlipperPressed = False
    'Init Delays/Timers
    'MainMode Init()
    'Init lights
	TriBallReady = False
	DMDTimer.interval = 80
    TurnOffPlayfieldLights()
    CloseDoor
	OpenDoor001
	GifVanRelancuchActive = True
	LuzBackglass = 0
	FaseParpadeo = 0
	LuzCharacterBackglass = 0
	FaseCharacterParpadeo = 0

End Sub

Sub StopEndOfBallMode() 'this sub is called after the last ball is drained
    'ResetSkillShotTimer_Timer
    StopBattle
End Sub

Sub ResetNewBallVariables() 'reset variables for a new ball or player
    Dim tmp
'Activo el Saver plunger Izq
	Light002.State=1
	Light003.State=0

	For tmp = 1 to 4
		FindtheBox (tmp) = 0
	Next
	OpenDoor001
	CloseDoor002
	
	TargetS1.IsDropped = TargetS1_Status (CurrentPlayer)
	TargetS2.IsDropped = TargetS2_Status (CurrentPlayer)
	TargetS3.IsDropped = TargetS3_Status (CurrentPlayer)
	TargetS4.IsDropped = TargetS4_Status (CurrentPlayer)

	LightTS1.State = TargetS1_Status (CurrentPlayer)
	LightTS2.State = TargetS2_Status (CurrentPlayer)
	LightTS3.State = TargetS3_Status (CurrentPlayer)
	LightTS4.State = TargetS4_Status (CurrentPlayer)

	
 	If TargetHit (CurrentPlayer) < 10 Then
		Panel_Bomba.Image = "Contador_"&(10-TargetHit (CurrentPlayer))	
		Subir_Puerta
     ' If bOnTheFirstBall = False Then
	'	Subir_Puerta
		'End If
		
	End if
	If TargetHit (CurrentPlayer) > 9 Then
		Panel_Bomba.Image = "Contador_0"
		Bajar_Puerta
	End if

	If TargetHit (CurrentPlayer) < 0 Then 
	Panel_Bomba.Image = "contador_0"
	End If


    LaneBonus = 0
    TargetBonus = 0
	TargetHannibal= 0
    RampBonus = 0
    BumperHits = 0
    ' select a battle
    SelectBattle
	bJackpot = False
	Segundos_Value=30
	

	Mision(CurrentPlayer, 0) = Mision(CurrentPlayer, 0)

	If ScoreBumpers(CurrentPlayer) = 0 Then 
		ScoreBumpers(CurrentPlayer) =50
	End If
	
	SuperTargets = False
	
End Sub

Sub ResetNewBallLights() 
	LightSeqBumpers.StopPlay
		Light1.State = MisionStatusLigth(CurrentPlayer,1)
		Light2.State = MisionStatusLigth(CurrentPlayer,2)
		Light3.State = MisionStatusLigth(CurrentPlayer,3)
		Light4.State = MisionStatusLigth(CurrentPlayer,4)
	Dim i,j 
		For i = 1 to 4
			j= 210 + i
			DOF j,MisionStatusLigth(CurrentPlayer, i)
		Next	
	If Mision(CurrentPlayer, 0) = 0 Then
	MisionLight.State = 2
		
	End If

			If Mision(CurrentPlayer, 0) >< 0 Then
				BlinkCharacterB2STimer. Enabled = true 'aqui
				LuzCharacterBackglass = 210 + Mision(CurrentPlayer, 0)
				FaseCharacterParpadeo = 1
			End If

	Select Case Mision(CurrentPlayer, 0)
			Case 0
				'Light58.State = 2
			Case 1
				Light35.State = 2
				Light33.State = 2
			Case 2				
				LightSeqBumpers.Play SeqRandom, 10, , 1000
				Light55.State = 2			
			Case 3	
				Light36.State = 2
				Light34.State = 2
			Case 4

				If TargetS1_Status (CurrentPlayer) = 1 Then
					LightTS1.State = 1
				Else 
					LightTS1.State = 2
				End if
				
				If TargetS2_Status (CurrentPlayer) = 1 Then
					LightTS2.State = 1
				Else 
					LightTS2.State = 2
				End if

				If TargetS3_Status (CurrentPlayer) = 1 Then
					LightTS3.State = 1
				Else 
					LightTS3.State = 2
				End if

				If TargetS4_Status (CurrentPlayer) = 1 Then
					LightTS4.State = 1
				Else 
					LightTS4.State = 2
				End if		
			Case 10
				Light42.State = 2
				
	End Select
				'SUPERTARGETS
	
				Light29.State = 0
				Light31.State = 0
'turn on or off the needed lights before a new ball is released
' UpdatePFXLights(PlayfieldMultiplier(CurrentPlayer)) 'ensure the multiplier is displayed right
End Sub

Sub TurnOffPlayfieldLights()
    Dim a
    For each a in aLights
        a.State = 0
    Next

End Sub

Sub TurnOnLogoLights()
	Dim i
	Dim LOGOLights (11)
		
	For i =	0 to loopCount(CurrentPlayer)

	LOGOLights (i) = 1

    Next
  
	Logo_Light001.State =  LOGOLights (1)'T
	Logo_Light002.State =  LOGOLights (2)'H
	Logo_Light003.State =  LOGOLights (3)'E
	Logo_Light005.State =  LOGOLights (4)'A
	Logo_Light007.State =  LOGOLights (6)'T
	Logo_Light008.State =  LOGOLights (8)'E
	Logo_Light009.State =  LOGOLights (9)'A
	Logo_Light010.State =  LOGOLights (10)'M
	

End Sub

Sub TurnOffLogoLights()
  
	Logo_Light001.State =  0'T
	Logo_Light002.State =  0'H
	Logo_Light003.State =  0'E
	Logo_Light005.State =  0'A
	Logo_Light007.State =  0'T
	Logo_Light008.State =  0'E
	Logo_Light009.State =  0'A
	Logo_Light010.State =  0'M

End Sub



Sub UpdateSkillShot() 'Setup and updates the skillshot lights
    LightSeqSkillshot.Play SeqAllOff
    'Light48.State = 2
    Light18.State = 2
    Gate2.Open = 1
    Gate3.Open = 1
		'Unactivate target skillshot
		TJS001.isDropped = False
		TJS002.isDropped = False
		TJS003.isDropped = False
		TJS004.isDropped = False

		If Door_is_open(CurrentPlayer) = True Then  

		Posicion_ligth_turn_on
		
		If Mision(CurrentPlayer,0) = 0 Then 

				Rafaga_ligth_turn_on
				
		End If
	End If

End Sub

Sub ResetSkillShotTimer_Timer 'timer to reset the skillshot lights & variables
    ResetSkillShotTimer.Enabled = 0
    bSkillShotReady = False
    LightSeqSkillshot.StopPlay
    If Light18.State = 2 Then Light18.State = 0
    Light48.State = 0
   
		'Activate target skillshot
		TJS001.isDropped = True
		TJS002.isDropped = True
		TJS003.isDropped = True
		TJS004.isDropped = True
    'DMDScoreNow
	ScoreDMDActive =0
	TiempoActivarDMDScore(6000)

	DoubleFraseDMD SkillShotValue(CurrentPlayer)&" MILLIONS", "TOTAL SKILLSHOT"
	
	'Reseteo el valor del SkillshotDone 
	SkillShotValue(CurrentPlayer) = 0

	If Mision(CurrentPlayer,0) = 2 Then
		Gate2.Open = 0
		Gate3.Open = 0
	End If
End Sub

' *********************************************************************
'                        Table Object Hit Events
'
' Any target hit Sub will follow this:
' - play a sound
' - do some physical movement
' - add a score, bonus
' - check some variables/Mode this trigger is a member of
' - set the "LastSwitchHit" variable in case it is needed later
' *********************************************************************


'*********************************************************
' Slingshots has been hit
' In this table the slingshots change the outlanes lights

Dim LStep, RStep

Sub LeftSlingShot_Slingshot
    If Tilted Then Exit Sub
    PlaySoundAt SoundFXDOF("fx_slingshot", 103, DOFPulse, DOFcontactors), Lemk
    DOF 105, DOFPulse
    LeftSling4.Visible = 1
    Lemk.RotX = 26
    LStep = 0
    LeftSlingShot.TimerEnabled = True
    ' add some points
    AddScore 210
    ' add some effect to the table?
    ' remember last trigger hit by the ball
    LastSwitchHit = "LeftSlingShot"
    ChangeOutlanes
   
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
    If Tilted Then Exit Sub
    PlaySoundAt SoundFXDOF("fx_slingshot", 104, DOFPulse, DOFcontactors), Remk
    DOF 106, DOFPulse
    RightSling4.Visible = 1
    Remk.RotX = 26
    RStep = 0
    RightSlingShot.TimerEnabled = True
    ' add some points
    AddScore 210
    ' add some effect to the table?
    ' remember last trigger hit by the ball
    LastSwitchHit = "RightSlingShot"
    ChangeOutlanes
    
End Sub

Sub RightSlingShot_Timer
    Select Case RStep
        Case 1:RightSLing4.Visible = 0:RightSLing3.Visible = 1:Remk.RotX = 14
        Case 2:RightSLing3.Visible = 0:RightSLing2.Visible = 1:Remk.RotX = 2
        Case 3:RightSLing2.Visible = 0:Remk.RotX = -10:RightSlingShot.TimerEnabled = 0
    End Select
    RStep = RStep + 1
End Sub

Sub ChangeOutlanes
    Dim tmp
    tmp = light13.State
    light13.State = light16.State
    light16.State = tmp
End Sub

'*********
' Bumpers
'*********
' after each 30 hits the bumpers increase their score value by 500 points up to 3210
' and they increase the playfield multiplier.

'ACTIVA EL GIF DEL BUMPER SI NO ESTÁ YA REPRODUCIENDOO
Sub BUMPERGIF()
	 BumperActivo =0 
	Addscore 0 'ScoreBumpers
End Sub



Sub EnableBlinkBumper(bumpernumber)
    ' start the timers
    TimerBumperBlink.Enabled = True
   ' Blink bumper light
   bumpernumber.Visible = 1

    
End Sub

Sub TimerBumperBlink_Timer()
    TimerBumperBlink.Enabled = False
    ' turn off the light
    bumper1light.Visible = 0
	bumper2light.Visible = 0
	bumper3light.Visible = 0
End Sub

Sub Bumper1_Hit
    If NOT Tilted Then
        PlaySoundAt SoundFXDOF("fx_bumper", 109, DOFPulse, DOFContactors), Bumper1
        DOF 138, DOFPulse
		Bumper1Light.visible=1
		EnableBlinkBumper(Bumper1Light)	

		HitBumpers

        ' remember last trigger hit by the ball
        LastSwitchHit = "Bumper1"
    End If
End Sub

Sub Bumper2_Hit
    If NOT Tilted Then
        PlaySoundAt SoundFXDOF("fx_bumper", 110, DOFPulse, DOFContactors), Bumper2
        DOF 140, DOFPulse
		Bumper2Light.Visible = 1
		EnableBlinkBumper(Bumper2Light)	
		
		HitBumpers

        ' remember last trigger hit by the ball
        LastSwitchHit = "Bumper2"
    End If
	
End Sub

Sub Bumper3_Hit
    If NOT Tilted Then
        PlaySoundAt SoundFXDOF("fx_bumper", 107, DOFPulse, DOFContactors), Bumper3
        DOF 137, DOFPulse
		Bumper3Light.Visible = 1
		EnableBlinkBumper(Bumper3Light)	
		
		HitBumpers

        ' remember last trigger hit by the ball
        LastSwitchHit = "Bumper3"
    End If
   
End Sub

Sub HitBumpers

			If ScoreBumpers(CurrentPlayer) > 0 Then 

				'ADD SOME POINTS 
					AddScore BumperValue(CurrentPlayer)	
					ScoreBumpers(CurrentPlayer) = ScoreBumpers(CurrentPlayer) - 1 
					
					If ScoreBumpers(CurrentPlayer) = 0 Then

						SuperTargets = True
							Light29.State = 2
							Light31.State = 2
						
						ScoreDMDActive =0
						TiempoActivarDMDScore(2000)
						FraseMediumDMD "SUPERTARGETS"


					End if
					 
			
				'ACTIVATE GIF OF THE BUMPERS
					If BumperActivo=0 and Mision(CurrentPlayer, 0) >< 2 then 
						BumperActivo=1
						vpmtimer.addtimer 100, "GifDMDBumper '" 
					End If
			End If	

			If Mision(CurrentPlayer, 0) = 2 Then
				SuperBumperHits(CurrentPlayer) = SuperBumperHits(CurrentPlayer) + 1
				Addscore 500000
				CheckMisionDone
				'DMD SCORE WAIT
						If Status_DMD_Mision (2) = True Then
							ScoreDMDActive =0
							TiempoActivarDMDScore(2000)
							If Rest_Mision_Timer. Enabled = False Then 
								Rest_Mision_Timer. Enabled = True
								Dmd_Rest_Active = True
							End If
						End If
			End If
		' CHECK THE BUMPERHITS
			 CheckBumpers
End Sub



Sub CheckBumpers()
    ' increase the bumper hit count and increase the bumper value after each 30 hits
    BumperHits = BumperHits + 1
    If BumperHits MOD 30 = 0 Then
        If BumperValue(CurrentPlayer) < 15000 Then
            BumperValue(CurrentPlayer) = BumperValue(CurrentPlayer) + 5000
        End If
        ' lit the playfield multiplier light
        light54.State = 1
    End If
End Sub

'*************************
' Top & Inlanes: Bonus X
'*************************
' lit the 2 top lane lights and the 2 inlane lights to increase the bonus multiplier

Sub sw1_Hit
    DOF 128, DOFPulse
    PlaySoundAtBall "fx_sensor"
    If Tilted Then Exit Sub
    LaneBonus = LaneBonus + 1
    Light17.State = 1
    FlashForMs f8, 1000, 50, 0
    
     CheckBonusX
    
End Sub

Sub sw6_Hit
    DOF 129, DOFPulse
    PlaySoundAtBall "fx_sensor"
    If Tilted Then Exit Sub
    LaneBonus = LaneBonus + 1
    Light18.State = 1
    FlashForMs f8, 1000, 50, 0
   
        CheckBonusX
    
End Sub

Sub sw4_Hit
    DOF 133, DOFPulse
    PlaySoundAtBall "fx_sensor"
    If Tilted Then Exit Sub
    LaneBonus = LaneBonus + 1
    Light14.State = 1
    FlashForMs f6, 1000, 50, 0
    AddScore 5000
    CheckBonusX
' Do some sound or light effect
End Sub

Sub sw3_Hit
    DOF 134, DOFPulse
    PlaySoundAtBall "fx_sensor"
    If Tilted Then Exit Sub
    LaneBonus = LaneBonus + 1
    Light15.State = 1
    FlashForMs f7, 1000, 50, 0
    AddScore 5000
    CheckBonusX
' Do some sound or light effect
End Sub

Sub CheckBonusX
    If Light17.State + Light18.State + Light14.State + Light15.State = 4 Then
        AddBonusMultiplier 1
        GiEffect 1
        FlashForMs Light17, 1000, 50, 0
        FlashForMs Light18, 1000, 50, 0
        FlashForMs Light14, 1000, 50, 0
        FlashForMs Light15, 1000, 50, 0
    End IF
End Sub

'************************************
' Flipper OutLanes: Virtual kickback
'************************************
' if the light is lit then activate the ballsave

Sub sw2_Hit
    DOF 132, DOFPulse
    PlaySoundAtBall "fx_sensor"
    If Tilted Then Exit Sub
    LaneBonus = LaneBonus + 1
    'AddScore 50000
    ' Do some sound or light effect
    ' do some check
    If light13.State = 1 Then
        EnableBallSaver 5
    End If
		vpmtimer.addtimer 200, "PlungerLeftSave '"
		
		'Plunger001.Fire
        PlaySoundAt "fx_plunger", plunger
End Sub


'--------------------------------------------------
'				AUTOSAVE PLUNGER LEFT
'----------------------------------------------
Sub PlungerLeftSave()

	'I AVOID THE DOUBLE GIF
	 If GifVanRelancuchActive = True Then 
		GifDMD("Van-RELAUNCH")
		GifVanRelancuchActive = False	
		PlaySound "VanBrackAndCrash"
		vpmtimer.addtimer 620, "AddScore ""50000"" '"
		vpmtimer.addtimer 500, "GifVanRelancuchChange '"
	 End If

If Light002.State=1 then
	Plunger001.Fire
	Plunger001.Pullback
	PlaySoundAt "fx_fire", plunger
	
		ScoreDMDActive =0
			vpmtimer.addtimer 600, "GifDMD ""relaunch"" '"
		TiempoActivarDMDScore(2600)
			 
	' Abre los Gates si la mision no es de Bumpers
		Gate3.Open = 0
	
	End If

	Light002.State=0

	Light003.State=2

End Sub

Sub GifVanRelancuchChange
	GifVanRelancuchActive = True
End Sub




Sub sw5_Hit
    DOF 135, DOFPulse
    PlaySoundAtBall "fx_sensor"
    If Tilted Then Exit Sub
    LaneBonus = LaneBonus + 1
    AddScore 50000
    ' Do some sound or light effect
    ' do some check
    If Light16.State = 1 Then
        EnableBallSaver 5
    End If
End Sub

'************
'  Spinners
'************

Sub spinner1_Spin
    If Tilted Then Exit Sub
    Addscore spinnervalue(CurrentPlayer)
    PlaySoundAt "fx_spinner", spinner1
    DOF 136, DOFPulse
    
	Select Case Mision(CurrentPlayer, 0)
        Case 1
            Addscore 40000
            SpinCountMision(CurrentPlayer) = SpinCountMision(CurrentPlayer) + 1
            CheckMisionDone

			'Dmd scrore Wait
			If Status_DMD_Mision (1) = True Then
				ScoreDMDActive =0
				TiempoActivarDMDScore(4000)
					If Rest_Mision_Timer. Enabled = False Then 
						Rest_Mision_Timer. Enabled = True
						Dmd_Rest_Active = True
					End If
				
			End If

    End Select

		'ObjRotx= 90 en el fijo
		'ObjRoty= 225 en el fijo
		

	Primitive011.ObjRoty= 315
	Primitive011.ObjRotx= 90
	Primitive011.ObjRotz= Primitive011.ObjRotz+ 40

	Primitive004.RotZ= Primitive004.RotZ+1130
	
	
End Sub

Sub spinner2_Spin
    If Tilted Then Exit Sub
    PlaySoundAt "fx_spinner", spinner2
    DOF 124, DOFPulse
    Addscore spinnervalue(CurrentPlayer)
    
	Select Case Mision(CurrentPlayer, 0)
        Case 1
            Addscore 40000
            SpinCountMision(CurrentPlayer) = SpinCountMision(CurrentPlayer) + 1
            CheckMisionDone
			
			'Dmd scrore Wait
			If Status_DMD_Mision (1) = True Then
				ScoreDMDActive =0
				TiempoActivarDMDScore(4000)
					If Rest_Mision_Timer. Enabled = False Then 
						Rest_Mision_Timer. Enabled = True
						Dmd_Rest_Active = True
					End If
			End If
    End Select
		'ObjRotx= 90 en el fijo
		'ObjRoty= 225 en el fijo
		

	Primitive011.ObjRoty= 315
	Primitive011.ObjRotx= 90
	Primitive011.ObjRotz= Primitive011.ObjRotz+ 40


End Sub

'*********************************
'     Targets Hannibal Mision
'*********************************

'--------------------TargetS1-------------
Sub TargetS1_Hit
    PlaySoundAt SoundFXDOF("fx_target", 116, DOFPulse, DOFTargets), TargetS1
		If Tilted Then Exit Sub
			AddScore 5000
   
		' Do some sound or light effect
	
			LightTS1.State = 1
			TargetS1_Status (CurrentPlayer) = 1
	

		If LightTS1.State = 1 AND LightTS2.State = 1 AND  LightTS3.State = 1 AND  LightTS4.State = 1 Then 
			vpmtimer.addtimer 200, "UpAllTargetHannibal '"

			If Mision(CurrentPlayer, 0) = 4 Then	
				DropAllTargetHannibal	
			End If
		End If

	If Mision(CurrentPlayer, 0) = 4 Then
			vpmtimer.addtimer 200, "DropTargetHannibal ""1"" '"
     End If
	
End Sub
'--------------------TargetS2-------------
Sub TargetS2_Hit
    PlaySoundAt SoundFXDOF("fx_target", 116, DOFPulse, DOFTargets), TargetS2
    If Tilted Then Exit Sub
		AddScore 5000
   
		' Do some sound or light effect
		
			LightTS2.State = 1
			TargetS2_Status (CurrentPlayer) = 1

		If LightTS1.State = 1 AND LightTS2.State = 1 AND  LightTS3.State = 1 AND  LightTS4.State = 1 Then 
			vpmtimer.addtimer 200, "UpAllTargetHannibal '"

			If Mision(CurrentPlayer, 0) = 4 Then
					DropAllTargetHannibal
			End If

		End If

	If Mision(CurrentPlayer, 0) = 4 Then
			vpmtimer.addtimer 200, "DropTargetHannibal ""2"" '"
     End If
	
End Sub
'--------------------TargetS3-------------
Sub TargetS3_Hit
    PlaySoundAt SoundFXDOF("fx_target", 116, DOFPulse, DOFTargets), TargetS3
    If Tilted Then Exit Sub
		AddScore 5000
   
		' Do some sound or light effect
	
			LightTS3.State = 1
			TargetS3_Status (CurrentPlayer) = 1
	
		If LightTS1.State = 1 AND LightTS2.State = 1 AND  LightTS3.State = 1 AND  LightTS4.State = 1 Then 
			vpmtimer.addtimer 200, "UpAllTargetHannibal '"	

			If Mision(CurrentPlayer, 0) = 4 Then
					DropAllTargetHannibal
			End If
		
		End If

	If Mision(CurrentPlayer, 0) = 4 Then

			vpmtimer.addtimer 200, "DropTargetHannibal ""3"" '"
     End If
	
End Sub
'--------------------TargetS4-------------
Sub TargetS4_Hit
    PlaySoundAt SoundFXDOF("fx_target", 116, DOFPulse, DOFTargets), TargetS4
    If Tilted Then Exit Sub
		AddScore 5000
   
		' Do some sound or light effect
	
			LightTS4.State = 1
			TargetS4_Status (CurrentPlayer) = 1
	
		If LightTS1.State = 1 AND LightTS2.State = 1 AND  LightTS3.State = 1 AND  LightTS4.State = 1 Then 
			vpmtimer.addtimer 200, "UpAllTargetHannibal '"
			
			If Mision(CurrentPlayer, 0) = 4 Then
					DropAllTargetHannibal
			End If
		End If

	If Mision(CurrentPlayer, 0) = 4 Then
			vpmtimer.addtimer 200, "DropTargetHannibal ""4"" '"
     End If
	
End Sub

Sub DropTargetHannibal(Target)
		TargetHannibal = TargetHannibal + 1 
			Addscore 2500000

				CheckMisionDone

			SpellTeam (CurrentPlayer,Target) = 1
			'Dmd scrore Wait
					If Status_DMD_Mision (4) = True Then
						ScoreDMDActive =0
						TiempoActivarDMDScore(2000)
		'Dmd Targets to Hannibal
					End If
		Hannibal_Targets_MisionDMD(Target)
End Sub

Sub DropAllTargetHannibal

				MisionDone
				Addscore 25000000
				SpellTeam (CurrentPlayer,1) = 0
				SpellTeam (CurrentPlayer,2) = 0
				SpellTeam (CurrentPlayer,3) = 0
				SpellTeam (CurrentPlayer,4) = 0
				
				TargetS1_Status (CurrentPlayer) = 0
				TargetS2_Status (CurrentPlayer) = 0
				TargetS3_Status (CurrentPlayer) = 0
				TargetS4_Status (CurrentPlayer) = 0

End Sub

Sub UpAllTargetHannibal
		TargetS1.IsDropped = False
		TargetS2.IsDropped = False
		TargetS3.IsDropped = False
		TargetS4.IsDropped = False	
		
		LightTS1.State = 0
		LightTS2.State = 0
		LightTS3.State = 0
		LightTS4.State = 0

End Sub


'*********************************
'      The Lock Targets
'*********************************


Sub Puerta_Caja_Hit

 CheckDropTarget1()
PlaySound("fx_Explosion02")
	'fx_Explosion02 
		If TriBallReady= False Then 
			TargetHit(CurrentPlayer) = TargetHit(CurrentPlayer) + 1
			ScoreDMDActive =0
			TiempoActivarDMDScore(3000)
			GifDMD "shoot_wood_"& TargetHit(CurrentPlayer)
			AddScore 10000
			Panel_Bomba.Image = "Contador_"&(10-TargetHit (CurrentPlayer))

		End If
		
		If TriBallReady= True Then

			Light41.BlinkInterval = 160
			Light41.State = 2

			Light51.BlinkInterval = 160
			Light51.State = 2

			light49.State = 0

		End If

		If TargetHit (CurrentPlayer) > 10 Then 
				Panel_Bomba.Image = "contador_0"
		End If

End Sub


Sub CheckDropTarget1()
      CheckDropTargetTimer.enabled = true
End Sub
 
' The CheckDropTargetTime is set to 500 ms in my case, so after that period of time (which allows the target to fully drop and meet the isDropped = 1 state), the code to see if all 4 are dropped runs.
 
Sub CheckDropTargetTimer_Timer
		 If TargetHit (CurrentPlayer) < 10 Then
			Puerta_Caja.TransY =  0
			Puerta_Caja.Collidable = True
		End if
		   If TargetHit (CurrentPlayer) >9 Then
				Bajar_Puerta
				RedayTriballDMD(CurrentPlayer)= True

vpmtimer.addtimer 2000, "Check_Ready_TriballTimer_Timer '"

			'Check_Ready_TriballTimer_Timer
		End if
		   CheckDropTargetTimer.enabled = false
End Sub

Sub Bajar_Puerta
    Bajar_Puerta_Timer.enabled = true
End Sub

Sub Bajar_Puerta_Timer_Timer
		Puerta_Caja.TransY = Puerta_Caja.TransY -2

	If Puerta_Caja.TransY  = - 90 Then 
			Puerta_Caja.Collidable = False
			Bajar_Puerta_Timer.enabled = False	
	End If
End Sub

Sub Subir_Puerta

    Subir_Puerta_Timer.enabled = true
	Puerta_Caja.Collidable = True
End Sub

Sub Subir_Puerta_Timer_Timer

		If Puerta_Caja.TransY  < 0 Then

			Puerta_Caja.TransY = Puerta_Caja.TransY +2
		End If
		If Puerta_Caja.TransY  = 0 Then 
			
			Subir_Puerta_Timer.enabled = False	
		End If
End Sub


Sub CheckReady_Triball()

		ScoreDMDActive =0
		GifDMD("Triball_Ready")
		TiempoActivarDMDScore(3000)
		Check_Ready_TriballTimer.enabled = true
End Sub

Sub Check_Ready_TriballTimer_Timer
		
			If RedayTriballDMD(CurrentPlayer)= True AND BallsOnPlayfield >0 Then
			CheckReady_Triball()
			End If

End Sub





Sub Target13_Hit
    PlaySoundAt SoundFXDOF("fx_target", 116, DOFPulse, DOFTargets), Target13
    If Tilted Then Exit Sub
    AddScore 5000
		TargetBonus = TargetBonus + 1
		' Do some sound or light effect
		
		FlashForMs f4, 1000, 50, 0
		' do some check
		Light19.State = 1
	Check2BankTargets	
   
     
	If SuperTargets = True Then 
		Addscore 500000

	End If

				'If Mision(CurrentPlayer, 0) = 4 Then
				'        TargetHits8(CurrentPlayer)= TargetHits8(CurrentPlayer)+1
				'        Addscore 250000
				'        CheckMisionDone

						'Dmd scrore Wait

				'			If Status_DMD_Mision (4) = True Then
				'					ScoreDMDActive =0
				'					TiempoActivarDMDScore(2000)
				'					Rest_MISION_active_DMD
				'			End If

				' End If
	
    LastSwitchHit = "Target13"

End Sub

Sub Target1_Hit

    PlaySoundAt SoundFXDOF("fx_target", 116, DOFPulse, DOFTargets), Target1
    If Tilted Then Exit Sub
    AddScore 5000
    TargetBonus = TargetBonus + 1
		
		FlashForMs f5, 1000, 50, 0
			' do some check
	Light20.State = 1
    ' do some check	
    Check2BankTargets

	If SuperTargets = True Then 
		Addscore 500000

	End If

				'If Mision(CurrentPlayer, 0) = 4 Then
				'        TargetHits8(CurrentPlayer)= TargetHits8(CurrentPlayer)+1
				'        Addscore 250000
				'        CheckMisionDone

						'Dmd scrore Wait

				'			If Status_DMD_Mision (4) = True Then
				'					ScoreDMDActive =0
				'					TiempoActivarDMDScore(2000)
				'					Rest_MISION_active_DMD
				'			End If

				' End If

	
    LastSwitchHit = "Target1"
End Sub

Sub Check2BankTargets
    If light19.state + light20.state = 2 Then
        light19.state = 0
        light20.state = 0
        LightEffect 1
        FlashEffect 1
        Addscore 20000
        
		If light53.State = 0 Then 'lit the increase jackpot light if the lock light is lit
            light53.State = 1
        PlaySound "vo_IncreaseJakpot"
        Else
            Addscore 30000
        End If
    End If
End Sub




'**************************
' The Lock: Main Multiball
'**************************
' the lock is a virtual lock, where the locked balls are simply counted




'-------------------------ORIGINAL------------------------------

Sub Door_Hit
		PlaySoundAt "fx_woodhit", doorf
		OpenDoor
End Sub

'-------------------------------------------------------
	'ENCENCIDO LUCES VAN
'-------------------------------------------------------

Sub Rafaga_ligth_turn_on()

	Faros_Frontales_Sub.Visible = True
	Faros_Frontales_Sub_Duplicado.Visible = True
	Aura_Faro_izq.State = 1
	Aura_Faro_der.State = 1
	Faros_Frontales.Visible = True
	Faro_Posicion.Visible= False

	PlaySound "Turn_On_van"
End Sub

Sub Rafaga_ligth_turn_Off()

	Faros_Frontales_Sub.Visible = False
	Faros_Frontales_Sub_Duplicado.Visible = False
	Aura_Faro_izq.State = 0
	Aura_Faro_der.State = 0
	Faros_Frontales.Visible = False

	'PlaySound "Turn_On_van"
End Sub

Sub Posicion_ligth_turn_on()

	Faro_Posicion.Visible= True

End Sub

Sub Posicion_ligth_turn_off()

	Faro_Posicion.Visible= False

End Sub
'-------------------------------------------------------

Sub Door001_Hit
    PlaySoundAt "fx_woodhit", doorf001
    OpenDoor001
End Sub

Sub lock_Hit

	'desactiva el control de bola Activa
			EnableBallControl = false
    Dim delay
    delay = 500
    PlaySoundAt "fx_hole_enter", lock
    bsJackal.AddBall Me
    'CloseDoor
		ScoreDMDActive =0
		GifDMD("Triball")
		TiempoActivarDMDScore(4000)
	
		RedayTriballDMD(CurrentPlayer)= False
    If bJackpot = True Then
        
        EnableSuperJackpot
    End If

	If bJackpot = False Then
	
            vpmtimer.addtimer 2000, "StartMainMultiball '"
    End If 

    vpmtimer.addtimer 2000, "Caja_Original_Position '"
    vpmtimer.addtimer delay, "JackalExit '"
	light50.State = 0
End Sub

Sub Caja_Original_Position
			Subir_Puerta
			TargetHit (CurrentPlayer) =0
			TriBallReady= True

End Sub

Sub StartMainMultiball
    AddMultiball 2
    
    ChangeGi 6
    'reset BallsInLock variable
    BallsInLock(CurrentPlayer) = 0
	
	Light49.BlinkInterval = 160
    Light49.State = 2

End Sub

Sub OpenDoor
	If Door_Bloqued = false and bSkillShotReady = False Then 
		doorf.RotateToEnd
		door.IsDropped = 1
		Rafaga_ligth_turn_on
		Door_is_open(CurrentPlayer)=True
	End If
End Sub

Sub CloseDoor
    doorf.RotateToStart
    door.IsDropped = 0
End Sub

Sub OpenDoor001
    doorf001.RotateToEnd
    door001.IsDropped = 1
	Panelled1.Image = "led1"
End Sub

Sub CloseDoor001
    doorf001.RotateToStart
    door001.IsDropped = 0
	Panelled1.Image = "led0"
End Sub

Sub OpenDoor002
    doorf002.RotateToEnd
End Sub

Sub CloseDoor002
    doorf002.RotateToStart
End Sub

'**********
' Jackpots
'**********
' Jackpots are enabled during the Main multiball and the wizard battles

Sub StartJackpots
    bJackpot = true
	AwardJackpot	

	Bajar_Puerta
    'turn on the jackpot lights
	Light49.State=2
	Light49.BlinkInterval = 160
    
End Sub

Sub ResetJackpotLights 'when multiball is finished, resets jackpot and superjackpot lights
    bJackpot = False
	Light36.State = 0
	Light34.State = 0
	Light50.State = 0
    light41.State = 0
    Light49.State = 0
    light51.State = 0
End Sub

Sub EnableSuperJackpot
    If bJackpot = True Then
		ScoreDMDActive =0
		GifDMD("double_jackpot")
		TiempoActivarDMDScore(2000)
		Addscore 20000000
		PlaySound "vo_superjackpot"
    End If
End Sub

'***********************************
' Skillshot Targets
'***********************************

Sub TJS001_Hit
    
	'AVOID MULTIPLE IMPACT
	If LastSwitchHit >< "TJS001" Then
		PlaySoundAtBall SoundFXDOF("fx_target", 120, DOFPulse, DOFTargets)
		AddScore 1000000
		GifDMD("1Million")
		TiempoActivarDMDScore(1500)
		SkillShotValue(CurrentPlayer)= SkillShotValue(CurrentPlayer) + 1
		LastSwitchHit = "TJS001"
	End If

End Sub

Sub TJS002_Hit
	
	'AVOID MULTIPLE IMPACT
	If LastSwitchHit >< "TJS002" Then
		PlaySoundAtBall SoundFXDOF("fx_target", 120, DOFPulse, DOFTargets)
		AddScore 1000000
		GifDMD("1Million")
		TiempoActivarDMDScore(1500)
		SkillShotValue(CurrentPlayer)= SkillShotValue(CurrentPlayer) + 1
		LastSwitchHit = "TJS002"
	End If

End Sub

Sub TJS003_Hit

	'AVOID MULTIPLE IMPACT
	If LastSwitchHit >< "TJS003" Then
		PlaySoundAtBall SoundFXDOF("fx_target", 120, DOFPulse, DOFTargets)
		AddScore 1000000
		GifDMD("1Million")
		TiempoActivarDMDScore(1500)
		SkillShotValue(CurrentPlayer)= SkillShotValue(CurrentPlayer) + 1
		LastSwitchHit = "TJS003"
	End If

End Sub

Sub TJS004_Hit
	
	'AVOID MULTIPLE IMPACT
	If LastSwitchHit >< "TJS004" Then
		PlaySoundAtBall SoundFXDOF("fx_target", 120, DOFPulse, DOFTargets)
		AddScore 1000000
		GifDMD("1Million")
		TiempoActivarDMDScore(1500)
		SkillShotValue(CurrentPlayer)= SkillShotValue(CurrentPlayer) + 1
		LastSwitchHit = "TJS004"
	End if

End Sub


'***********************************
' Blue Targets:  The Mummy Targets
'***********************************

Sub Target2_Hit
    PlaySoundAtBall SoundFXDOF("fx_target", 120, DOFPulse, DOFTargets)
    If Tilted Then Exit Sub
    AddScore 5000
    TargetBonus = TargetBonus + 1
	
    LastSwitchHit = "Target2"
    ' Do some sound or light effect
    Light23.State = 1
    ' do some check
    Select Case Battle(CurrentPlayer, 0)
		Case 2: Punch_Out_Value = Punch_Out_Value + 500000 : PunchOutDMD
				Playsound "BA_Punch"

				'LIGHT EFFECT
					FlashEffect 2
					LightEffect 2
					GiEffect 2
		Case 9	BA_Light002.State = 1
				Check9BankTargets
    End Select
    Check6BankTargets
End Sub

Sub Target4_Hit
    PlaySoundAtBall SoundFXDOF("fx_target", 120, DOFPulse, DOFTargets)
    If Tilted Then Exit Sub
    AddScore 5000
    TargetBonus = TargetBonus + 1
	
    LastSwitchHit = "Target4"
    ' Do some sound or light effect
    Light24.State = 1
    ' do some check
    Select Case Battle(CurrentPlayer, 0)
		Case 2: Punch_Out_Value = Punch_Out_Value + 500000 : PunchOutDMD
				Playsound "BA_Punch"

				'LIGHT EFFECT
					FlashEffect 2
					LightEffect 2
					GiEffect 2
		
		Case 9	BA_Light001.State = 1
				Check9BankTargets
				
				
    End Select
    Check6BankTargets
End Sub

Sub Target5_Hit
    PlaySoundAtBall SoundFXDOF("fx_target", 113, DOFPulse, DOFTargets)
    If Tilted Then Exit Sub
    AddScore 5000
    TargetBonus = TargetBonus + 1
    LastSwitchHit = "Target5"
	
    ' Do some sound or light effect
    Light25.State = 1
    ' do some check
    Select Case Battle(CurrentPlayer, 0)
		Case 2: Punch_Out_Value = Punch_Out_Value + 500000 : PunchOutDMD
				Playsound "BA_Punch"

				'LIGHT EFFECT
					FlashEffect 2
					LightEffect 2
					GiEffect 2
		Case 9	BA_Light004.State = 1
				Check9BankTargets
    End Select
    Check6BankTargets
End Sub

Sub Target7_Hit
    PlaySoundAtBall SoundFXDOF("fx_target", 113, DOFPulse, DOFTargets)
    If Tilted Then Exit Sub
    AddScore 5000
    TargetBonus = TargetBonus + 1
	
    LastSwitchHit = "Target7"
    ' Do some sound or light effect
    Light26.State = 1
    ' do some check
    Select Case Battle(CurrentPlayer, 0)
		Case 2: Punch_Out_Value = Punch_Out_Value + 500000 : PunchOutDMD
				Playsound "BA_Punch"

				'LIGHT EFFECT
					FlashEffect 2
					LightEffect 2
					GiEffect 2
		Case 9	BA_Light003.State = 1
				Check9BankTargets
    End Select
    Check6BankTargets
End Sub

Sub Target10_Hit
    PlaySoundAtBall SoundFXDOF("fx_target", 114, DOFPulse, DOFTargets)
    If Tilted Then Exit Sub
    AddScore 5000
    TargetBonus = TargetBonus + 1
	
    LastSwitchHit = "Target10"
    ' Do some sound or light effect
    Light27.State = 1
    ' do some check
    Select Case Battle(CurrentPlayer, 0)
		Case 2: Punch_Out_Value = Punch_Out_Value + 500000 : PunchOutDMD
				Playsound "BA_Punch"

				'LIGHT EFFECT
					FlashEffect 2
					LightEffect 2
					GiEffect 2
	Case 9	BA_Light006.State = 1
				Check9BankTargets
    End Select
    Check6BankTargets
End Sub

Sub Target8_Hit
    PlaySoundAtBall SoundFXDOF("fx_target", 114, DOFPulse, DOFTargets)
    If Tilted Then Exit Sub
    AddScore 5000
    TargetBonus = TargetBonus + 1
	
    LastSwitchHit = "Target8"
    ' Do some sound or light effect
    Light28.State = 1
    ' do some check
    Select Case Battle(CurrentPlayer, 0)
		Case 2: Punch_Out_Value = Punch_Out_Value + 500000 : PunchOutDMD
				Playsound "BA_Punch"

				'LIGHT EFFECT
					FlashEffect 2
					LightEffect 2
					GiEffect 2
		Case 9	BA_Light005.State = 1
				Check9BankTargets
    End Select
    Check6BankTargets
End Sub

Sub Check6BankTargets
    Dim tmp
    FlashForMs f1, 1000, 50, 0
	FlashForMs f2, 1000, 50, 0
    FlashForMs f3, 1000, 50, 0
    FlashForMs f4, 1000, 50, 0
    FlashForMs f4, 1000, 50, 0
    
    
    ' if all 6 targets are hit then 
    If light23.state + light24.state + light25.state + light26.state + light27.state + light28.state = 6 Then

        ' OPTION UP BONUS IN DMD 
        LightEffect 1
        FlashEffect 1
        ' Lit the Mystery light if it is off
        If Light63.State = 1 Then
			Light63.State = 0
		'UP BONUS

        Else
            Light63.State = 1
            
        End If
		AddScore 1000000
        ' reset the lights
        light23.state = 0
        light24.state = 0
        light25.state = 0
        light26.state = 0
        light27.state = 0
        light28.state = 0
    End If
End Sub

Sub Check9BankTargets
    Dim tmp
    FlashForMs f1, 1000, 50, 0
	FlashForMs f2, 1000, 50, 0
    FlashForMs f3, 1000, 50, 0
    FlashForMs f4, 1000, 50, 0
    FlashForMs f4, 1000, 50, 0
    ' if all 6 targets are hit then kill a monster & activate the mystery light
    If BA_Light001.state + BA_Light002.state + BA_Light003.state + BA_Light004.state + BA_Light005.state + BA_Light006.state = 6 Then
        ' kill a monster
		WinBattle
        'MonstersKilled(CurrentPlayer) = MonstersKilled(CurrentPlayer) + 1
        'DMD " YOU KILLED", "  A MONSTER", "monster_" &tmp, eNone, eNone, eNone, 2500, True, ""
        LightEffect 1
        FlashEffect 1
        
        ' reset the lights
        BA_Light001.state = 0
        BA_Light002.state = 0
        BA_Light003.state = 0
        BA_Light004.state = 0
        BA_Light005.state = 0
        BA_Light006.state = 0
		
		Check6BankTargets
	
    End If
End Sub

' Playfiel Multiplier timer: reduces the multiplier after 30 seconds

Sub pfxtimer_Timer
    If PlayfieldMultiplier(CurrentPlayer) > 1 Then
        PlayfieldMultiplier(CurrentPlayer) = PlayfieldMultiplier(CurrentPlayer)-1
        SetPlayfieldMultiplier PlayfieldMultiplier(CurrentPlayer)
    Else
        pfxtimer.Enabled = 0
    End If
End Sub

'*****************
'  Captive Target
'*****************

Sub Target9_Hit
    PlaySoundAtBall SoundFXDOF("fx_target", 113, DOFPulse, DOFTargets)
    If Tilted Then Exit Sub
    
    AddScore 5000 'all targets score 5000
    ' Do some sound or light effect
    ' do some check
    If(bJackpot = True)AND(light52.State = 2)Then
        AwardSuperJackpot
        light52.State = 0
        light48.State = 0
        StartJackpots
    End If
    'Select Case Battle(CurrentPlayer, 0)
    '    Case 0:SelectBattle 'no battle is active then change to another battle
    'End Select

    ' increase the playfield multiplier for 30 seconds
    If light54.State = 1 Then
        AddPlayfieldMultiplier 1
        light54.State = 0
    End If

    ' increase Jackpot
    If light53.State = 1 Then
        AddJackpot 50000
        light53.State = 0
    End If
End Sub


'****************************
'CharacterKicker /MURDOCK / HANNIBAL/ FACEMAN/ BARRACUS
'****************************
Sub CharacterKicker_Hit

If Pausa_DMD = False Then 'AVOID COLLAPSES DUE TO CALL TO IMAGE

			'STOP DMD Score
				ScoreDMDActive =0
				TiempoActivarDMDScore (1000)
					
			'desactiva el control de bola Activa
				EnableBallControl = false
				'ASIGNA LAS MISIONES
			Dim numerodemision

				'SI Activacion_Misiones es 1 esta lista para activar, si es 0 esta activa, si es 2 hay mas de una mision
				If Activacion_Misiones(CurrentPlayer)=1 Then
					
				'MISIONPREDEFINITA TEST BORRAR 
				'Mision(CurrentPlayer,1)= 4

				'MISIONES ALEATORIAS
					For numerodemision =0 to 4

						do while Norepetirmision(CurrentPlayer,Mision(CurrentPlayer,numerodemision)) <> 0 
			
								Mision(CurrentPlayer,numerodemision)=INT(RND * 4 + 1)	
						loop

						Norepetirmision(CurrentPlayer,Mision(CurrentPlayer,numerodemision)) =1 		
					Next	
				End If
								'PASAR A A SIGUIENTE MISION, TRAS MISIONDONE EL VALOR ES 2
				If Activacion_Misiones(CurrentPlayer)>0 Then

					'Si pasas el primer paersonaje pasar el segundo. SI ES EL PRIMERO PASA DE 0 A 1
					MisionActiva (CurrentPlayer)=MisionActiva (CurrentPlayer) +1
				
					'Almaceno en el indice 0 qué personaje es el que esta activo
					Mision(CurrentPlayer, 0) = Mision(CurrentPlayer,MisionActiva(CurrentPlayer))	
					SelectMision


					'LECTURA DEL NOMBRE D ELA MISION ANTES DE SALIR EN EL DMD

						Dim n

						For n=1 to 4

						If Mision(CurrentPlayer,n) =1 Then
						OrdenNombreMision(CurrentPlayer,n) = NombreMision(1)
						End If
						If Mision(CurrentPlayer,n) =2 Then
						OrdenNombreMision(CurrentPlayer,n) = NombreMision(2)
						End If
						If Mision(CurrentPlayer,n) =3 Then
						OrdenNombreMision(CurrentPlayer,n) = NombreMision(3)
						End If
						If Mision(CurrentPlayer,n) =4 Then
						OrdenNombreMision(CurrentPlayer,n) = NombreMision(4)
						End If
						Next
					'CUADRANTE MISIONES EN EL DMD
					ScoreDMDActive =0
					TiempoActivarDMDScore(5000)
					MisionDMD

			Else ' Activacion_Misiones(CurrentPlayer)=0 
				MrLee_Value(CurrentPlayer) = MrLee_Value(CurrentPlayer) - 1

				if MrLee_Value(CurrentPlayer) = 0 Then
					PlaySound "MRLEE_0"
					MrLee_Value(CurrentPlayer) = 10
					ScoreDMDActive =0
					GifDMD("25millions")
					TiempoActivarDMDScore(3000)
					Addscore 25000000
					PlaySound "vo_superjackpot"
					
				else
				
				MrLeeDMD
				
					PlaySound "MRLEE_"& MrLee_Value(CurrentPlayer)

				End If

			End If

				
			
			'BALL OUT
			

			Pausa_DMD = True
			Pausa200.enabled = True
	End If

	Dim Delay
			Delay = 4000
			PlaySoundAt "fx_hole_enter", CharacterKicker
			bsCharacterKicker.AddBall Me
		
			vpmtimer.addtimer Delay, "CharacterKickerExit '"
End Sub



Sub CharacterKickerExit()
    If bsCharacterKicker.Balls > 0 Then
		
		playSound "SALIDACOCHE"
		Faro_Posicion.Visible= False

        FlashForMs f1, 1000, 50, 0
		FlashForMs Aura_Faro_der, 1000, 50, 0
		FlashForMs Aura_Faro_izq, 1000, 50, 0
		FlashForMs Faros_Frontales, 1000, 50, 0 
		FlashForMs Faros_Frontales_Sub, 1000, 50, 0
		FlashForMs Faros_Frontales_Sub_Duplicado, 1000, 50, 0
		

		vpmtimer.addtimer 1000, "Posicion_ligth_turn_on '"
		

        PlaySoundAt SoundFXDOF("fx_kicker", 119, DOFPulse, DOFContactors), CharacterKicker
        DOF 121, DOFPulse
        PlaySoundAt "fx_cannon", CharacterKicker
        'add a small delay before actually kicking lothe ball
        vpmtimer.addtimer 500, "bsCharacterKicker.ExitSol_On '"
    End If

    'kick out all the balls
    If bsCharacterKicker.Balls > 0 Then
        vpmtimer.Addtimer 500, "CharacterKickerExit '"
    End If

	If Activacion_Misiones(CurrentPlayer)><0 Then
		vpmtimer.Addtimer 600, "CloseDoor '"
		Door_is_open(CurrentPlayer)=False
	End If
	'MisionLight OFF
	MisionLight.State = 0
End Sub

'****************************
'  Jackal Hole Hit & Awards
'****************************

Sub JackalHole_Hit
    Dim Delay
    Delay = 2000
    PlaySoundAt "fx_hole_enter", JackalHole
    bsJackal.AddBall Me

    vpmtimer.addtimer Delay, "JackalExit '"
End Sub

Sub JackalExit()
    If bsJackal.Balls > 0 Then
        FlashForMs f10, 1000, 50, 0
        PlaySoundAt SoundFXDOF("fx_kicker", 119, DOFPulse, DOFContactors), JackalHole
        DOF 121, DOFPulse
        PlaySoundAt "fx_cannon", JackalHole
        'add a small delay before actually kicking the ball
        vpmtimer.addtimer 500, "bsJackal.ExitSol_On '"
    End If
    'kick out all the balls
    If bsJackal.Balls > 0 Then
        vpmtimer.Addtimer 500, "JackalExit '"
    End If
End Sub

'****************************
'  Jeep Hole Hit & Awards
'****************************

Sub JeepHole_Hit

	'desactiva el control de bola Activa
			EnableBallControl = false
	Dim Delay
		Delay = 2000
		PlaySoundAt "fx_hole_enter", JeepHole
		bsJeep.AddBall Me

		If(Battle(CurrentPlayer, NewBattle) = 2)AND(Battle(CurrentPlayer, 0) = 0) AND (bSkillShotReady = False) AND (bMultiballMode = FALSE) Then 'the battle is ready, so start it
			'Battle_is_Active = True
			StartBattle
			'vpmtimer.addtimer 1000, "StartBattle '" ( no se porque el tiempo de espera)
		End If
		'Ball out if mision is active
		If VideoModeActive = false AND Battle_is_Active= True Then 'Y LA BATALLA ESTA ACTIVA 
			vpmtimer.addtimer 1000, "PlaySound ""fx_Alarm"" '"
			vpmtimer.addtimer Delay, "JeepHoleExit '"

		End If

		If bSkillShotReady = True Then 
			vpmtimer.addtimer 1000, "PlaySound ""fx_Alarm"" '"
			vpmtimer.addtimer Delay, "JeepHoleExit '"
		End If

End Sub

Sub JeepHoleExit()
    If bsJeep.Balls > 0 Then
        FlashForMs f2, 1000, 50, 0
        PlaySoundAt SoundFXDOF("fx_kicker", 119, DOFPulse, DOFContactors), JeepHole
        DOF 121, DOFPulse
        PlaySoundAt "fx_cannon", JeepHole
        'add a small delay before actually kicking the ball
        vpmtimer.addtimer 500, "bsJeep.ExitSol_On '"
    End If
    'kick out all the balls
    If bsJeep.Balls > 0 Then
        vpmtimer.Addtimer 500, "JeepHoleExit '"
    End If

	Select Case NewBattle
			'If not a videomode misión, keep the battle active

			Case 3 'LOTERY
					Battle_is_Active = False
			Case 4 'VIDEO MODE RUN AWAY
					Battle_is_Active = False          
			Case 5 'FIND AND SHOOT
					Battle_is_Active = False
			Case 2
			
	 End Select


End Sub

'****************************
'  Barrel Hole Hit & Awards 
'****************************

Sub BarrelHole_Hit
	
		Dim Delay
				Delay = 5000

			 'STOP DMD Score
						ScoreDMDActive =0
						TiempoActivarDMDScore(6500)

		If Pausa_DMD = False AND (bMultiballMode = FALSE) AND Light42.State >< 2 Then 'AVOID COLLAPSES DUE TO CALL TO IMAGE				
										
				'desactiva el control de bola Activa
					EnableBallControl = false
					'ASIGNA LOS NUMEROS DEL SORTEO
				Dim Number_Draw

					'SI Activacion_Misiones es 1 esta lista para activar, si es 0 esta activa, si es 2 hay mas de una mision
					If Activacion_Weel_of_Fortune (CurrentPlayer)=1 Then
						
					'SORTEOPREDEFINITA TEST BORRAR 
					'Draw(CurrentPlayer,1)= 4

					'MISIONES ALEATORIAS
						For Number_Draw =0 to 10

							do while Not_Repeat_Draw_number(CurrentPlayer,Draw(CurrentPlayer,Number_Draw)) <> 0 
				
									Draw(CurrentPlayer,Number_Draw)=INT(RND * 10 + 1)	
							loop

							Not_Repeat_Draw_number(CurrentPlayer,Draw(CurrentPlayer,Number_Draw)) =1 		
						Next	
					End If
									'PASAR A A SIGUIENTE MISION, TRAS MISIONDONE EL VALOR ES 2
					If Activacion_Weel_of_Fortune(CurrentPlayer)>0 Then

						'Si pasas el primer paersonaje pasar el segundo. SI ES EL PRIMERO PASA DE 0 A 1
						Weel_of_Fortune_Activa (CurrentPlayer)= Weel_of_Fortune_Activa (CurrentPlayer) +1
					
						'Almaceno en el indice 0 qué personaje es el que esta activo
						Draw(CurrentPlayer, 0) = Draw(CurrentPlayer, Weel_of_Fortune_Activa(CurrentPlayer))	

						'LECTURA DEL NOMBRE D ELA MISION ANTES DE SALIR EN EL DMD

						
							Dim n

							For n=1 to 10
								If draw(CurrentPlayer,n) =1 Then
								OrdenNombreDraw(CurrentPlayer,n) = Nombre_Sorteo (1)
								End If
								If draw(CurrentPlayer,n) =2 Then
								OrdenNombreDraw(CurrentPlayer,n) = Nombre_Sorteo (2)
								End If
								If draw(CurrentPlayer,n) =3 Then
								OrdenNombreDraw(CurrentPlayer,n) = Nombre_Sorteo (3)
								End If
								If draw(CurrentPlayer,n) =4 Then
								OrdenNombreDraw(CurrentPlayer,n) = Nombre_Sorteo (4)
								End If
								If draw(CurrentPlayer,n) =5 Then
								OrdenNombreDraw(CurrentPlayer,n) = Nombre_Sorteo (5)
								End If
								If draw(CurrentPlayer,n) =6 Then
								OrdenNombreDraw(CurrentPlayer,n) = Nombre_Sorteo (6)
								End If
								If draw(CurrentPlayer,n) =7 Then
								OrdenNombreDraw(CurrentPlayer,n) = Nombre_Sorteo (7)
								End If
								If draw(CurrentPlayer,n) =8 Then
								OrdenNombreDraw(CurrentPlayer,n) = Nombre_Sorteo (8)
								End If
								If draw(CurrentPlayer,n) =9 Then
								OrdenNombreDraw(CurrentPlayer,n) = Nombre_Sorteo (9)
								End If
								If draw(CurrentPlayer,n) =10 Then
								OrdenNombreDraw(CurrentPlayer,n) = Nombre_Sorteo (10)
								End If	
							Next
					End If

			
				PlaySoundAt "fx_hole_enter", BarrelHole
				bsBarrel.AddBall Me

				
					
					SimpleGifDMDFrase "Sol_Naciente", "WELL OF FORTUNE"
					
					
					vpmtimer.addtimer 1500, "Weel_Of_fortune_DMD '"
					vpmtimer.addtimer 4000, "GiveRandomAward '"
					vpmtimer.addtimer 10000, "ResetDraw '"

	End If

	If Light42.State=2 Then
		EnableBallControl = false
		EnableBallSaver(10)
		AddMultiball 1
		Delay = 2000
		bsBarrel.AddBall Me
	End If
		

			vpmtimer.addtimer Delay, "BarrelHoleExit '"
		
End Sub

Sub BarrelHoleExit()
    If bsBarrel.Balls > 0 Then
        FlashForMs f4, 1000, 50, 0
        PlaySoundAt SoundFXDOF("fx_kicker", 119, DOFPulse, DOFContactors), BarrelHole
        DOF 121, DOFPulse
        PlaySoundAt "fx_cannon", BarrelHole
        'add a small delay before actually kicking the ball
        vpmtimer.addtimer 500, "bsBarrel.ExitSol_On '"
    End If
    'kick out all the balls
    If bsBarrel.Balls > 0 Then
        vpmtimer.Addtimer 500, "BarrelHoleExit '"
    End If

End Sub


Sub GiveRandomAward() 'from the Jackal Sphynx
    Dim tmp, tmp2 'AQUI

   ' Nombre_Sorteo
'Nombre_Sorteo (1) = "EXTRABALL LITE"
'Nombre_Sorteo (2) = "BIG POINTS"
'Nombre_Sorteo (3) = " AddPlayfieldMultiplier 1"
'Nombre_Sorteo (4) = "BONUS MULTIPLIER"
'Nombre_Sorteo (5) = "COMPLETE BATTLE"
'Nombre_Sorteo (6) = "COMPLETE MISION"
'Nombre_Sorteo (7) = "SUPERBUMPERS"
'Nombre_Sorteo (8) = "BALL SAVE"
'Nombre_Sorteo (9) = "MULTIBALL"
'Nombre_Sorteo (10) = "TRIBALL READY"

			ScoreDMDActive =0
			TiempoActivarDMDScore(6500)

    tmp = Draw(CurrentPlayer, 9)
	'tmp = 6
    Select Case tmp
        Case 1 'EXTRABALL LITE
			
            'FraseMediumDMD "EXTRABALL LITE"
			Playsound "fx_fanfare1"
            ExtraBall_Light.State = 2
			Gate2.Open = 0
			OpenDoor002
			CloseDoor
			GifDMD "Extraball_Is_Lit"

        Case 2 'BIG POINTS
			Playsound "fx_fanfare1"
			FraseMediumDMD "BIG POINTS"
			vpmtimer.addtimer 1500, "GifDMD ""2Millions"" '"
            AddScore 2000000

        Case 3 'BONUS HELD
			Playsound "fx_fanfare1"
			FraseMediumDMD " Playfield + 1"
             AddPlayfieldMultiplier 1

        Case 4 'INCREASE BONUS MULTIPLIER
			Playsound "fx_fanfare1"
			FraseMediumDMD "BONUS X "& BonusMultiplier(CurrentPlayer)
			AddBonusMultiplier 1

        Case 5 'COMPLETE BATTLE
          
			
			vpmtimer.addtimer 1500, "Playsound ""fx_fanfare1"" '"  
			vpmtimer.addtimer 5000, "Addscore ""0"" '"
			
			Select Case NewBattle
				Case 1
					FraseMediumDMD "SUPPLY FOUND"
					Playsound "HANNIBAL_PLAINS"	
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 2	
					FraseMediumDMD "COMPLETE BATTLE"
					Playsound "HANNIBAL_KEEP_CALM_MA"	
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 3
					GifDMD "Slots"
					Playsound "Murdock_winner"	
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 4
					GifDMD "Runaway_intro"
					PlaySound "SALIDACOCHE"
					PlaySound "fx_alarm"
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 5
					GifDMD "Find_and_shoot_intro"
					Playsound "HANNIBAL_PLAINS"	
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 6
					GifDMD "EXTRABALL"
					ExtraballDMD =True
					playsound "vo_extraball"
					DOF 121, DOFPulse
					ExtraBallsAwards(CurrentPlayer) = ExtraBallsAwards(CurrentPlayer) + 1
					bExtraBallWonThisBall = True
				Case 7
					FraseMediumDMD "COLLECT AWARD"
					Playsound "HANNIBAL_KEEP_CALM_MA"	
					AddScore 5000000
					vpmtimer.addtimer 1500, "GifDMD ""5Millions""'"
				Case 8
					GifDMD "HOSPITAL-CARTEL"	
					PlaySound "Murdock_Scape"
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 9
					FraseMediumDMD "COMPLETE BATTLE"
					Playsound "HANNIBAL_KEEP_CALM_MA"	
					AddScore 10000000
					vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				Case 10
					FraseMediumDMD "LITE MULTIBALL"
					PlaySound "Rafaga"
					EnableBallControl = false
					EnableBallSaver(10)
					AddMultiball 1

				End Select 

				Battle(CurrentPlayer, 0) = 0
				Battle(CurrentPlayer, NewBattle) = 1
				UpdateBattleLights
				FlashEffect 2
				LightEffect 2
				GiEffect 2
				Battle_is_Active = False
   
				DOF 139, DOFPulse
				StopBattle2
				NewBattle = 0
				SelectBattle 'automatically select a new battle 
				ResetNewBallLights
				'ChangeSong
            
        Case 6 'MISIONDONE
            If Mision(CurrentPlayer, 0) > 0 AND Mision(CurrentPlayer, 0) < 5 Then
				
				ScoreDMDActive =0
				TiempoActivarDMDScore(6500)

				FraseMediumDMD "COMPLETE MISION"
				AddScore 10000000
				vpmtimer.addtimer 1500, "GifDMD ""10Millions"" '"
				vpmtimer.addtimer 1500, "Playsound ""fx_fanfare1"" '"  
				vpmtimer.addtimer 5000, "Addscore ""0"" '"
				MisionStatusLigth(CurrentPlayer,NewMision)=1
                MisionDone
				ChangeSong
            Else
               Playsound "fx_fanfare1"
				FraseMediumDMD "BIG POINTS"
				vpmtimer.addtimer 1500, "GifDMD ""2Millions"" '"
				AddScore 2000000
            End If
				FlashEffect 2
				LightEffect 2
				GiEffect 2
           
        Case 7 'SUPERBUMPERS
			Playsound "fx_fanfare1"
			vpmtimer.addtimer 4500, "FraseMediumDMD ""SUPERBUMPERS"" '"
          
             'AddPlayfieldMultiplier 1
        Case 8 'Increase Bumper value
            BumperValue(CurrentPlayer) = BumperValue(CurrentPlayer) + 500
            'DMD CL("BUMPER VALUE"), CL(BumperValue(CurrentPlayer)), "", eBlink, eBlink, eNone, 1500, True, "fx_fanfare1"
        Case 9 'extra multiball
            'DMD CL("EXTRA"), CL("MULTIBALL"), "", eBlink, eBlink, eNone, 1500, True, "fx_fanfare1"
            AddMultiball 1
        Case 10 ' Ball Save
            'DMD CL("BALL SAVE"), CL("ACTIVATED"), "", eBlink, eBlink, eNone, 1500, True, "fx_fanfare1"
            EnableBallSaver 20
        Case ELSE 'Add a Random score from 10.000 to 100,000 points
            tmp2 = INT((RND) * 9) * 10000 + 10000
            'DMD CL("EXTRA POINTS"), CL(tmp2), "", eBlink, eBlink, eNone, 1500, True, "fx_fanfare1"
            AddScore tmp2
    End Select
End Sub
'*******************
'   The Orbit lanes
'*******************

Sub sw8_Hit
    DOF 130, DOFPulse
    PlaySoundAtBall "fx_sensor"
    If Tilted Then Exit Sub
    LaneBonus = LaneBonus + 1
		'Back loop Status
		If LastSwitchHit = "sw7" Then
                LastSwitchHit = ""
                loopCount (CurrentPlayer) = loopCount (CurrentPlayer) + 1
				TurnOnLogoLights
               ' Addscore 140000
			If bSkillShotReady = False Then 
					LoopCountDMD
			End If
         Else 
				LastSwitchHit = "sw8"
		End If
	'Reactivate Save
		If Light003.State=2 Then
			Light003.State=0
			Light002.State=1

				If Mision(CurrentPlayer,0) >< 2 Then
					Gate2.Open = 1
					Gate3.Open = 1
				End If
		End If
	'*****¿JACKPOT?*******
    'If(bJackpot = True)AND(light41.State = 2)Then
     '   light41.State = 0
      '  AwardJackpot
   ' End If
    Select Case Battle(CurrentPlayer, 0)
				
		Case 1 'FindTheBox
			If Light39.State = 2 Then
				CheckWinBattle(1)		
				Light39.State = 0
				FindtheBox(1) = 2 
			End If
        Case 4
        Case 5
        Case 6          
		Case 8 'Murdock Scape
		If LScape001.State = 2 Then
                AddScore 500000
                FlashEffect 3
                LightHits9 = LightHits9 + 1
				'SONIDO
					PlaySound "SCAPE_1"
                CheckWinBattle(9)
               GifDMD "Murdock_corriendo"
				ScoreDMDActive =0
				TiempoActivarDMDScore(2500)
            End If
     
        Case 10

    End Select
    
End Sub


    

Sub sw7_Hit
    DOF 131, DOFPulse
    PlaySoundAtBall "fx_sensor"
    If Tilted Then Exit Sub
    LaneBonus = LaneBonus + 1


			If LastSwitchHit = "sw8" Then
                LastSwitchHit = ""
                loopCount (CurrentPlayer) = loopCount (CurrentPlayer) + 1
               ' Addscore 140000
				TurnOnLogoLights
				If bSkillShotReady = False Then
					LoopCountDMD
				End If
            Else 
				LastSwitchHit = "sw7"
			End If

    If(bJackpot = True)AND(light51.State = 2)Then
        light51.State = 0
        AwardJackpot
    End If
    Select Case Battle(CurrentPlayer, 0)

		Case 1 'FindTheBox
			If Light48.State = 2 Then		'
				CheckWinBattle(4)				 
				Light48.State = 0
				FindtheBox(4) = 2 
			End If
        Case 4
        Case 5      
        Case 6    
        Case 8 'Murdock Scape
       If PanelLedTimer. Enabled = True Then
				
				Panelled1.Image = "led1"
                AddScore 500000
                FlashEffect 3
                LightHits9 = LightHits9 + 1
				'SONIDO
					PlaySound "SCAPE_1"
                CheckWinBattle(9)
               GifDMD "Murdock_corriendo"
				ScoreDMDActive =0
				TiempoActivarDMDScore(2500)
            End If
       
    End Select
    LastSwitchHit = "sw7"
End Sub

Sub Trigger_Barrel_Hit
	Playsound "Cross_Barrel_Sound"
End Sub


Sub TriggerMagna_Hit
    
		 Select Case Battle(CurrentPlayer, 0)
			Case 9' MAGNA
				PlaySoundAtBall "fx_sensor"
				MagnaOff
		End Select
    LastSwitchHit = "Magna"
End Sub

Sub TriggerMagna001_Hit
    
		 Select Case Battle(CurrentPlayer, 0)
			Case 9' MAGNA
				PlaySoundAtBall "fx_sensor"
				Magna1Off
		End Select
    LastSwitchHit = "Magna1"
End Sub

Sub TriggerMagna002_Hit
    
		 Select Case Battle(CurrentPlayer, 0)
			Case 9' MAGNA
				PlaySoundAtBall "fx_sensor"
				Magna2Off
		End Select
    LastSwitchHit = "Magna2"
End Sub

Sub TriggerMagna003_Hit
    
		 Select Case Battle(CurrentPlayer, 0)
			Case 9' MAGNA
				PlaySoundAtBall "fx_sensor"
				Magna3Off
		End Select
    LastSwitchHit = "Magna3"
End Sub

Sub TriggerMagna004_Hit
    
		 Select Case Battle(CurrentPlayer, 0)
			Case 9' MAGNA
				PlaySoundAtBall "fx_sensor"
				Magna4Off
		End Select
    LastSwitchHit = "Magna4"
End Sub

Sub ExtraballKicker_Hit
	PlaySoundAtBall "fx_sensor"
		
		 Select Case Battle(CurrentPlayer, 0)
			Case 6'EXTRABALL
				AwardExtraBall
				ScoreDMDActive =0
				TiempoActivarDMDScore(5000)
				GifDMD "EXTRABALL"
				Winbattle	
		End Select
		
		
		PlaySoundAt "fx_hole_enter", ExtraballKicker
		bsExtraBallKicker.AddBall Me
		Gate2.Open = 1

		vpmtimer.addtimer 2000, "ExtraballKickerExit '"
		vpmtimer.addtimer 4000, "CloseDoor002 '"
		
   
End Sub

Sub ExtraballKickerExit
	If bsExtraBallKicker.Balls > 0 Then
        FlashForMs f1, 1000, 50, 0
        PlaySoundAt SoundFXDOF("fx_kicker", 119, DOFPulse, DOFContactors), ExtraBallKicker
        DOF 121, DOFPulse
        PlaySoundAt "fx_cannon", ExtraBallKicker
        'add a small delay before actually kicking lothe ball
        vpmtimer.addtimer 500, "bsExtraBallKicker.ExitSol_On '"
    End If
    'kick out all the balls
    If bsCharacterKicker.Balls > 0 Then
        vpmtimer.Addtimer 500, "ExtraBallKickerExit '"
    End If
	If Activacion_Misiones(CurrentPlayer)><0 Then
		vpmtimer.Addtimer 600, "CloseDoor '"
		Door_is_open(CurrentPlayer)=False
    End If
	
End Sub


Sub MagnaOff
	mMagnaSave.MagnetOn = 0
	vpmtimer.addtimer 500, "MagnaOn '"			
End Sub

Sub MagnaOn
	mMagnaSave.MagnetOn = 1	
End Sub

Sub Magna1Off
	mMagnaSave001.MagnetOn = 0
	vpmtimer.addtimer 500, "Magna1On '"			
End Sub

Sub Magna1On
	mMagnaSave001.MagnetOn = 1	
End Sub

Sub Magna2Off
	mMagnaSave002.MagnetOn = 0
	vpmtimer.addtimer 500, "Magna2On '"			
End Sub

Sub Magna2On
	mMagnaSave002.MagnetOn = 1	
End Sub

Sub Magna3Off
	mMagnaSave003.MagnetOn = 0
	vpmtimer.addtimer 500, "Magna3On '"			
End Sub

Sub Magna3On
	mMagnaSave003.MagnetOn = 1	
End Sub

Sub Magna4Off
	mMagnaSave004.MagnetOn = 0
	vpmtimer.addtimer 500, "Magna4On '"			
End Sub

Sub Magna4On
	mMagnaSave004.MagnetOn = 1	
End Sub


'****************
'     Ramps
'****************

Sub LeftRampDone_Hit
    Dim tmp, i
    If Tilted Then Exit Sub
    'increase the ramp bonus
    RampBonus = RampBonus + 1
    
	If(TriBallReady= True)AND(Light41.State = 2)Then
        Light41.State = 0
		Light51.State = 0
		StartJackpots 
    End If

    'PowerUp - left ramp only counts the variable
   ' PowerupHits = PowerupHits + 1
   ' CheckPowerup


    'Battles
    Select Case Battle(CurrentPlayer, 0)
		

		Case 0 'Select Next Battle
					
					If NewBattle < 10 Then 'NUMERO MÁXIMODE BATALLAS
						If BattlesWon(CurrentPlayer) = 10 Then
							NewBattle = 11
							Battle(CurrentPlayer, NewBattle) = 2:UpdateBattleLights:StartBattle '11 battle is the wizard
						Else

						 Tmp = NewBattle 

						do while Battle(CurrentPlayer, NewBattle) <> 0
							NewBattle = NewBattle + 1
						loop
						
					If NewBattle > 10 Then 
						
						NewBattle = 1
						do while Battle(CurrentPlayer, NewBattle) <> 0
							NewBattle = NewBattle + 1
						loop

					End if


						Battle(CurrentPlayer, Tmp) = 0
						Battle(CurrentPlayer, NewBattle) = 2
						UpdateBattleLights

						End if

					Else 
						Battle(CurrentPlayer, NewBattle) = 0

						NewBattle = 1

						Tmp = NewBattle 

						do while Battle(CurrentPlayer, NewBattle) <> 0
							NewBattle = NewBattle + 1
						loop

						Battle(CurrentPlayer, NewBattle) = 2
						UpdateBattleLights
					
				End If

        Case 1 'FindTheBox
			If Light36.State = 2 Then
				CheckWinBattle (2)		 
				Light36.State = 0
				FindtheBox(2) = 2 
			End If
        Case 8 'Murdock Scape
            If LScape002.State = 2 Then
                AddScore 500000
                FlashEffect 3
                LightHits9 = LightHits9 + 1
				'SONIDO
					PlaySound "SCAPE_1"
                CheckWinBattle(8)
                GifDMD "Murdock_corriendo"
				ScoreDMDActive =0
				TiempoActivarDMDScore(2500)
            End If
       
    End Select

'MISIONES PERSONAJE
		Select Case Mision(CurrentPlayer, 0)
				
				Case 3:RampHits3(CurrentPlayer) = RampHits3(CurrentPlayer) + 1
				
				Light36.State=2
				
				Addscore 250000
				CheckMisionDone

				'Dmd scrore Wait
				If (bJackpot = false)  Then

					If (Light41.State > 2) or (Light41.State < 2) Then
						ScoreDMDActive =0
						TiempoActivarDMDScore(2000)
						Rest_MISION_active_DMD
					End If

				End If
		Case else
					' play ss quote
					'PlayQuote
		End Select

    'check for combos
    if LastSwitchHit = "RightRampDone" OR LastSwitchHit = "LeftRampDone" Then
		ScoreDMDActive =0
		TiempoActivarDMDScore(2000)
		'Addscore jackpot(CurrentPlayer)
		Addscore 200000
        FraseMediumDMD "COMBO"
    End If
    LastSwitchHit = "LeftRampDone"
End Sub

Sub RightRampDone_Hit
    Dim tmp
    If Tilted Then Exit Sub
    'increase the ramp bonus
    RampBonus = RampBonus + 1
    If(TriBallReady= True)AND(Light51.State = 2)Then
        Light41.State = 0
		Light51.State = 0
        StartJackpots
        


    End If
    'Powerup - rightt ramp counts the variable and give the jackpot if light31 is lit
    'If light50.State = 2 Then
       ' DMD CL("POWERUP AWARD"), CL(jackpot(CurrentPlayer)), "_", eNone, eBlinkFast, eNone, 1000, True, "vo_Jackpot"
       ' AddScore Jackpot(CurrentPlayer)
       ' LightEffect 2
       ' FlashEffect 2
   ' Else
    '    PowerupHits = PowerupHits + 1
    '    CheckPowerup
   ' End If

    'Battles
    Select Case Battle(CurrentPlayer, 0)

		

		Case 0 'Select Next Battle
					
				If NewBattle > 1 Then 'NUMERO MINIMO DE BATALLAS
					If BattlesWon(CurrentPlayer) = 10 Then
						NewBattle = 11
						Battle(CurrentPlayer, NewBattle) = 2:UpdateBattleLights:StartBattle '11 battle is the wizard
					Else
						 Tmp = NewBattle 

						do while Battle(CurrentPlayer, NewBattle) <> 0
							NewBattle = NewBattle - 1
						loop
					
						If NewBattle < 1 Then 
						
						NewBattle = 10
						do while Battle(CurrentPlayer, NewBattle) <> 0
							NewBattle = NewBattle - 1
						loop

						End if

						Battle(CurrentPlayer, Tmp) = 0
						Battle(CurrentPlayer, NewBattle) = 2
						UpdateBattleLights

						

					End iF

				Else 
						Battle(CurrentPlayer, NewBattle) = 0 
						NewBattle = 10

						do while Battle(CurrentPlayer, NewBattle) <> 0
							NewBattle = NewBattle - 1
						loop


						Battle(CurrentPlayer, NewBattle) = 2
						UpdateBattleLights
				End If
		Case 1 'FindTheBox
			If Light34.State = 2 Then
				CheckWinBattle (3) 
				Light34.State = 0
				FindtheBox(3) = 2 
			End If
        Case 8 'Murdock Scape
            If LScape003.State = 2 Then
                AddScore 500000
                FlashEffect 3
                LightHits9 = LightHits9 + 1
				'SONIDO
					PlaySound "SCAPE_1"
                CheckWinBattle(9)
               GifDMD "Murdock_corriendo"
				ScoreDMDActive =0
				TiempoActivarDMDScore(2500)
            End If
    End Select

'MISIONES PERSONAJE

			Select Case Mision(CurrentPlayer, 0)
				Case 3:RampHits3(CurrentPlayer)= RampHits3(CurrentPlayer) + 1
				
				Light34.State=2
				
				Addscore 250000
				CheckMisionDone
				'Dmd scrore Wait
		If (bJackpot = false)  Then
						If (Light51.State > 2) or (Light51.State < 2) Then
						ScoreDMDActive =0
						TiempoActivarDMDScore(2000)
						Rest_MISION_active_DMD
					End If
		End if
				Case else
					' play ss quote
					'PlayQuote
			End Select

    'check for combos
    if LastSwitchHit = "RightRampDone" OR LastSwitchHit = "LeftRampDone" Then
       
		ScoreDMDActive =0
		TiempoActivarDMDScore(2000)
		'Addscore jackpot(CurrentPlayer)
		Addscore 200000
        FraseMediumDMD "COMBO"

    End If
    LastSwitchHit = "RightRampDone"
End Sub





'******************
' Left Red Target : Lite MultiBall 
'******************

Sub Target12_Hit
    PlaySoundAtBall "fx_target"
    If Tilted Then Exit Sub

    Select Case Battle(CurrentPlayer, 0)
        Case 10
            
			If Light42.State =2 Then 
				Light42.State =0 
				PlaySound "vo_multiball"
				AddMultiball 1
				Winbattle	
				OpenDoor
			End If
        
           
    End Select
    LastSwitchHit = "Target12"
End Sub
'-----------------------------------------------
'***********************************************
'       Characters PERSONAJES
'***********************************************
'-----------------------------------------------

'************************
' SELECCION DE MISION PERSONAJE
'************************


Sub SelectMision 'select a new battle if none is active
    Dim i
    

        If ContadorMisionDone(CurrentPlayer) = 4 Then 
			'*****************MISION FINAL************************
			AddScore "25000000"
			ScoreDMDActive =0
			TiempoActivarDMDScore(4000)
			' Borramos los contadores de misiones del jugador
			GifDMD "25millions"
				ContadorMisionDone(CurrentPlayer)= 0
				Activacion_Misiones(CurrentPlayer)=1
				Light1.State = 0
				Light2.State = 0
				Light3.State = 0
				Light4.State = 0
			MisionActiva (CurrentPlayer)= 0
				For i = 0 to 4
					Mision(CurrentPlayer, i)=0
					Norepetirmision(CurrentPlayer,i) = 0 
					OrdenNombreMision(CurrentPlayer,i)=0
					MisionStatusLigth(CurrentPlayer,i)= 0
				Next
			SpinCountMision(CurrentPlayer) = 150
			SuperBumperHits(CurrentPlayer) =20
			RampHits3(CurrentPlayer) = 8
			TargetS1_Status (CurrentPlayer )= 0
			TargetS2_Status (CurrentPlayer )= 0
			TargetS3_Status (CurrentPlayer )= 0
			TargetS4_Status (CurrentPlayer )= 0	
			LightTS1.State = TargetS1_Status (CurrentPlayer)
			LightTS2.State = TargetS2_Status (CurrentPlayer)
			LightTS3.State = TargetS3_Status (CurrentPlayer)
		LightTS4.State = TargetS4_Status (CurrentPlayer)


            'NewMision = 5:Mision(CurrentPlayer, NewMision) = 2:UpdateBattleLights:StartBattle '5 battle is the wizard
        Else
            NewMision = Mision(CurrentPlayer,0)' La mision que toque correlativamente almacenada en indice 0
            
			'Activacion_Misiones =0 Las misiones no se pueden activar
			Activacion_Misiones(CurrentPlayer)=0

			
           ' Mision(CurrentPlayer, NewMision) = 4
            'Light47.State = 2
			StartMision


			'FALTAN LAS LUCES Y EL CHECK
            'UpdateBattleLights

        End If
    
    
End Sub

'************************
' START MISION PERSONAJE
'************************

Sub StartMision
 Mision(CurrentPlayer, 0) = NewMision
    'Light47.State = 0
    'CAMBIO DE SONIDO
	BlinkCharacterB2STimer. Enabled = True ' ACTIVATE THE CLOCK 
				FaseCharacterParpadeo = 1 ' ACTIVATE BLINK
				LuzCharacterBackglass =210 'DEFINE THE ID PART 1

				LuzCharacterBackglass = LuzCharacterBackglass + NewMision 'DEFINE COMPLETE TEHE ID
	ChangeSong
    PlaySound "fx_alarm"
    EnableBallSaver 15 'start a 15 seconds ball save
Select Case NewMision
        Case 1      'MURDOCK

			Playsound "Character1_Sound_init"
            Light33.State = 2
            Light35.State = 2
            SpinCountMision(CurrentPlayer) = 0
        Case 2 'BARRACUS
           ' DMD CL("ISIS"), CL("HIT THE POP BUMPERS"), "", eNone, eNone, eNone, 1500, True, ""
            Light55.State = 2
            LightSeqBumpers.Play SeqRandom, 10, , 1000

			Gate2.Open = 0
			Gate3.Open = 0
            SuperBumperHits(CurrentPlayer) = 0
        Case 3 'Faceman = Ramps
           ' DMD ("SHOOT THE RAMPS")
            Light36.State = 2
            Light34.State = 2
            RampHits3(CurrentPlayer) = 0
        
        Case 4 'Hannibal = Left Targets
			UpAllTargetHannibal
            LightTS1.State = 2
			LightTS2.State = 2	
			LightTS3.State = 2
			LightTS4.State = 2	
            TargetHits8(CurrentPlayer) = 0
        
        Case 5 
            AddMultiball 4
            StartJackpots
            ChangeGi 5
    End Select
End Sub

'************************
' CHECK MISION DONE
'************************

Sub CheckMisionDone
    dim tmp
    tmp = INT(RND * 7) + 1
    PlaySound "fx_thunder" & tmp
    DOF 126, DOFPulse
    LightSeqInserts.StopPlay 'stop the light effects before starting again so they don't play too long.
    LightEffect 3
    FlashEffect 3
    Select Case NewMision
        Case 1
            If SpinCountMision(CurrentPlayer) > 149 Then 
				MisionDone
				SpinCountMision(CurrentPlayer)=0
				MisionStatusLigth(CurrentPlayer,1)=1 
			End if
        Case 2
            If SuperBumperHits(CurrentPlayer) > 19 Then 
			MisionStatusLigth(CurrentPlayer,2)=1
			Gate2.Open = 1
			Gate3.Open = 1
			MisionDone
			LightSeqBumpers.StopPlay
			End if
        Case 3
            If RampHits3(CurrentPlayer)> 7 Then 
			RampHits3(CurrentPlayer)=0
			MisionStatusLigth(CurrentPlayer,3)=1
			MisionDone
			Light34.State=0
			Light36.State=0
			End if
        Case 4
            MisionStatusLigth(CurrentPlayer,4)=1
        Case 5
            If LightHits9 = 8 Then MisionDone:End if
   
    End Select
End Sub

'************************
' MISION DONE
'************************

Sub MisionDone
    Dim tmp
    ContadorMisionDone(CurrentPlayer) = ContadorMisionDone(CurrentPlayer) + 1
    Mision(CurrentPlayer, 0) = 0
	Activacion_Misiones(CurrentPlayer)=2
	ScoreDMDActive =0
	TiempoActivarDMDScore(6500)
	AddScore 10000000
	
	GifDMD	"10Millions"
	If ContadorMisionDone(CurrentPlayer) >< 4 Then 
		vpmtimer.addtimer 2500, "FraseMediumDMD ""SHOOT THE VAN"" '"
		vpmtimer.addtimer 4500, "FraseMediumDMD ""TO NEXT MISION"" '"
    End if
	'UpdateBattleLights
    'FlashEffect 2
    'LightEffect 2
    'GiEffect 
    tmp = INT(RND * 4)
    Select Case tmp
        Case 0:vpmtimer.addtimer 1500, "PlaySound ""vo_excelent"" '"
        Case 1:vpmtimer.addtimer 1500, "PlaySound ""vo_impressive"" '"
        Case 2:vpmtimer.addtimer 1500, "PlaySound ""vo_welldone"" '"
        Case 3:vpmtimer.addtimer 1500, "PlaySound ""vo_YouWon"" '"
    End Select
    StopMision2
    
    
    'add a multiball after each 2 Mision Done
    Select Case  ContadorMisionDone(CurrentPlayer)
        'Case 2, 4, 6, 8:AddMultiball 2
    End Select
    ChangeSong

	'ABRE LA PUERTA
	Light47.State = 2
	
	CloseDoor
	Door_is_open(CurrentPlayer)=False
	'MisionLight ON
	MisionLight.State = 2
vpmtimer.addtimer 1500, "CheckMisionStatusLigth '"
		
End Sub

Sub CheckMisionStatusLigth
		Light1.State = MisionStatusLigth(CurrentPlayer,1)
		Light2.State = MisionStatusLigth(CurrentPlayer,2)
		Light3.State = MisionStatusLigth(CurrentPlayer,3)
		Light4.State = MisionStatusLigth(CurrentPlayer,4)
End Sub

'************************
' STOP MISION 2
'************************

Sub StopMision2
    'Turn off the bomb lights
	LightTS1.State = 0
	LightTS2.State = 0	
	LightTS3.State = 0
	LightTS4.State = 0	
    Light29.State = 0
    Light31.State = 0
    Light33.State = 0
    Light34.State = 0
    Light35.State = 0
    Light36.State = 0
    


	ResetNewBallLights
    ' stop some timers or reset battle variables
    Select Case NewMision
        Case 1:SpinCountMision(CurrentPlayer)= 0
        Case 2:Light55.State = 0:LightSeqBumpers.StopPlay:SuperBumperHits(CurrentPlayer) = 0
			'Parar la secuencia de los bumpers

        Case 3: RampHits3(CurrentPlayer) = 0
        Case 4
 		

        Case 13:ResetBattles:SelectBattle
    End Select
End Sub


'-----------------------------------------------
'***********************************************
'       Battles BATALLAS
'***********************************************
'-----------------------------------------------

'************************
' SELECCION BATTLE AQUI
'************************

Sub SelectBattle 'select a new random battle if none is active
    Dim i
    If Battle(CurrentPlayer, 0) = 0 Then
        ' reset the battles that are not finished
        For i = 1 to 10
            If Battle(CurrentPlayer, i) = 2 Then Battle(CurrentPlayer, i) = 0
        Next
        If BattlesWon(CurrentPlayer) = 10 tHEN

								EnableBallSaver 5
								TargetHit (CurrentPlayer) = 10 
								CheckDropTargetTimer_Timer
								EnableBallControl = false
								BattlesWon(CurrentPlayer) = 0
								Dim j

								For j=0 to 10
									Battle(CurrentPlayer, j) = 0
								Next
								NewBattle = 0
								playsound "fx_Explosion01"
						
           ' NewBattle = 11
			'Battle(CurrentPlayer, NewBattle) = 2:UpdateBattleLights:StartBattle '11 battle is the wizard
        Else
			
            NewBattle = INT(RND * 10 + 1)
            do while Battle(CurrentPlayer, NewBattle) <> 0
                NewBattle = INT(RND * 9 + 1)
            loop

			'SELECCIONAR BATALLA CONCRETA
				'NewBattle = 10

            Battle(CurrentPlayer, NewBattle) = 2
            Light47.State = 2
            UpdateBattleLights
        End iF
    'debug.print "newbatle " & newbattle
    End If
End Sub

'************************
' LUCES BATTLE PLAYFIELD
'************************

' Update the lights according to the battle's state
Sub UpdateBattleLights
    Light5.State = Battle(CurrentPlayer, 1)
	Light6.State = Battle(CurrentPlayer, 2)
    Light7.State = Battle(CurrentPlayer, 3)
    Light8.State = Battle(CurrentPlayer, 4)
    Light9.State = Battle(CurrentPlayer, 5)
	Light10.State = Battle(CurrentPlayer, 6)
    Light11.State = Battle(CurrentPlayer, 7)
    Light60.State = Battle(CurrentPlayer, 8)
	Light12.State = Battle(CurrentPlayer, 9)
	Light61.State = Battle(CurrentPlayer, 10)

	Dim i,j 
		For i = 1 to 10
			j= 200 + i
			DOF j,Battle(CurrentPlayer, i)
		Next


   
End Sub

' Starting a battle means to setup some lights and variables, maybe timers
' Battle lights will always blink during an active battle

'************************
' START BATTLE
'************************
Sub StartBattle 'AQUI
	Dim tmp

    Battle(CurrentPlayer, 0) = NewBattle
	Light47.State = 0
    ChangeSong_Character_mision
    
	EnableBallSaver BallSaverTimer (NewBattle)

				BlinkB2STimer. Enabled = True
				FaseParpadeo = 1
				LuzBackglass =200

				LuzBackglass = LuzBackglass + NewBattle

	
    Select Case NewBattle

         Case 1 'BATTLE NAME: FIND THE BOX

				BlinkB2STimer. Enabled = True
				FaseParpadeo = 1
				LuzBackglass =201
				'DOF 201, 1
			'BATTLE VARIABLES
			 
			tmp = INT(RND * 4 + 1)
			
			'BATTLE ACTIONS ON THE TABLE
				'CLOSE THE GATES------>DONT OPEN 2 BOX IN ONE SHOOT
				Gate2.Open = 0
				Gate3.Open = 0

			FindtheBox (tmp)= 1
			'----------------------------FLAG "WHERE IS THE BOX"-----------------------------------
			FraseMediumDMD ( FindtheBox (1)&""&FindtheBox (2)&""&FindtheBox (3)&""&FindtheBox (4) ) 

			'DELAY DMDScore
					ScoreDMDActive =0
					TiempoActivarDMDScore(6500)
			
			'ADJUST THE BALL EXIT TIME
			Activate_Batte
			vpmtimer.addtimer 7000, "JeepHoleExit '"

			'ADJUST SOUND
				'-------------SOUND ADVICE ALARM------------------
				vpmtimer.addtimer 5000, "PlaySound ""fx_alarm"" '" 

			'ADJUST AND ORDER DMD SCENE
			GifDMDFrase "armytruck", "TRUCKS CONVOY" , "SEARCH IN THE TRUCKS" , "FIND THE BOX"
			vpmtimer.addtimer 5500, "FindTheBoxDMD ""(0)"" '" 

			'ADJUST LIGHTS
				Light39.State = 2
				Light36.State = 2
				Light34.State = 2
				Light48.State = 2
				Light5.State = 2

		Case 2 'BATTLE NAME: PUNCH OUT
			
			'BATTLE VARIABLES
			
			Punch_Out_Value = 500000
			
			'BATTLE ACTIONS ON THE TABLE	
				Door_Bloqued = true
				CloseDoor
				Door_is_open(CurrentPlayer)=False

			'DELAY DMDScore
				ScoreDMDActive =0
				TiempoActivarDMDScore(8000)
			

			'ADJUST THE BALL EXIT TIME
			vpmtimer.addtimer 7000, "Activate_Batte '" 
			vpmtimer.addtimer 7000, "JeepHoleExit '"

			'ADJUST AND ORDER DMD SCENE
			'DoubleFraseDMD "SHOOT TARGETS", "TO INCREASE PUNCH"
			SimpleGifDMDFrase "PUNCH_OUT", "PUNCH OUT"
			vpmtimer.addtimer 3000, "FraseMediumDMD ""SHOOT TARGETS"" '"	
			vpmtimer.addtimer 7000, "PunchOutDMD '"
			
			
			'ADJUST SOUND
				'-------------SOUND ADVICE ALARM------------------
				PlaySound "HANNIBAL_PUNCH_BA"
				vpmtimer.addtimer 5000, "PlaySound ""fx_alarm"" '" 
			
			'ADJUST LIGHTS
				BA_Light001.State = 2
				BA_Light002.State = 2
				BA_Light003.State = 2
				BA_Light004.State = 2
				BA_Light005.State = 2
				BA_Light006.State = 2
			
				Light6.State = 2

        Case 3 'BATTLE NAME: LOTERY

				'BATTLE VARIABLES
					Dim i 

						For i =1 to 4
								Vel_Rail (i) = 8
								Rail_Lotery_Pos (i) = 0
								Rail_Stopped = False
								Lotery_Value (i) = 0
						Next
				'BATTLE ACTIONS ON THE TABLE	
					VideoModeActive = True 'LOCK THE FLIPPERS
				
				'DELAY DMDScore
					ScoreDMDActive =0
					TiempoActivarDMDScore(4510)
					
				'ADJUST THE BALL EXIT TIME = 0, WHITHOUT DELAY
					Activate_Batte 

				'ADJUST AND ORDER DMD SCENE
					GifDMD "Slots"   
					vpmtimer.addtimer 1500, "Previus_Lotery_DMD '"
					vpmtimer.addtimer 5000, "BattledelayVideoMode '"
					vpmtimer.addtimer 4500, "LoteryDMD '"

				'ADJUST SOUND
					PlaySound "fx_alarm"
					vpmtimer.addtimer 1500, "PlaySound ""roulette2"" '" 

				'ADJUST LIGHTS
					Light7.State = 2
				
        Case 4 'BATTLE NAME: VIDEO MODE RUNAWAY

				'BATTLE ACTIONS ON THE TABLE	
					VideoModeActive = True 'LOCK THE FLIPPERS

				'ADJUST THE BALL EXIT TIME = 0, WHITHOUT DELAY
					Activate_Batte 

				'DELAY DMDScore
					ScoreDMDActive =0
					TiempoActivarDMDScore(5500)

				'ADJUST AND ORDER DMD SCENE
					GifDMD "Runaway_intro"		
					vpmtimer.addtimer 2700, "FraseMediumDMD ""RUN AWAY"" '"
					vpmtimer.addtimer 8000, "BattledelayVideoMode '"
					vpmtimer.addtimer 5500, "RunAwayDMD '"

				'ADJUST SOUND
					PlaySound "SALIDACOCHE"
					PlaySound "fx_alarm"

				'ADJUST LIGHTS
					Light8.State = 2
				
        Case 5 'BATTLE NAME: FIND AND SHOOT

				'BATTLE VARIABLES
					Enemy_FindAndShoot_posX(1,2) = 0
					Enemy_FindAndShoot_posX(2,1) = 0
					Enemy_FindAndShoot_posX(2,2) = 0
					Enemy_FindAndShoot_posX(3,1) = 0
					Enemy_FindAndShoot_posX(3,2) = 0
					Enemy_FindAndShoot_posX(4,1) = 0
					Enemy_FindAndShoot_posX(4,2) = 0
		
				'BATTLE ACTIONS ON THE TABLE
					VideoModeActive = True 'LOCK THE FLIPPERS

				'ADJUST THE BALL EXIT TIME = 0, WHITHOUT DELAY
					Activate_Batte 


				'DELAY DMDScore
					ScoreDMDActive =0
					TiempoActivarDMDScore(5600)

				'ADJUST AND ORDER DMD SCENE
				
				DoubleFraseDMD "30 seconds", "SHOOT ALL ENEMIES"
				vpmtimer.addtimer 1800, "GifDMD ""Find_and_shoot_intro"" '"			
				vpmtimer.addtimer 5900, "BattledelayVideoMode '"
				vpmtimer.addtimer 5600, "FindAndShootDMD '"

				'ADJUST SOUND
					Playsound "HANNIBAL_ 30_SECONDS"

				'ADJUST LIGHTS
					Light9.State = 2
				
        Case 6 'BATTLE NAME: GET THE EXTRABALL

				'BATTLE VARIABLES
					Door_is_open(CurrentPlayer)=False

				'BATTLE ACTIONS ON THE TABLE
					VideoModeActive = False
					Gate2.Open = 0
					OpenDoor002
					CloseDoor

				
				'ADJUST THE BALL EXIT TIME
					vpmtimer.addtimer 6200, "Activate_Batte '" 
					vpmtimer.addtimer 6200, "JeepHoleExit '"
			
				'DELAY DMDScore
					ScoreDMDActive =0
					TiempoActivarDMDScore(6500)
					vpmtimer.addtimer 6200, "AddScore ""0"" '"

				'ADJUST AND ORDER DMD SCENE
					GifDMD "fence"
					vpmtimer.addtimer 2500, "GifDMD ""Extraball_Is_Lit"" '"
			
				'ADJUST SOUND
					PlaySound "Rafaga"
					PlaySound "fx_alarm"

				'ADJUST LIGHTS
					Light10.State = 2
					ExtraBall_Light.State = 2

        Case 7 'BATTLE NAME: GET 5 MILLIONS

				'BATTLE VARIABLES
					AddScore 5000000

				'BATTLE ACTIONS ON THE TABLE
					WinBattle
				
				'ADJUST THE BALL EXIT TIME
					vpmtimer.addtimer 1000, "Activate_Batte '" 
					vpmtimer.addtimer 4000, "JeepHoleExit '"
				
				'ADJUST AND ORDER DMD SCENE
					FraseMediumDMD "COLLECT AWARD"
					vpmtimer.addtimer 2500, "GifDMD ""5millions"" '"
					vpmtimer.addtimer 4800, "AddScore ""0"" '"

				'ADJUST SOUND
					PlaySound "MRLEE_0"
					vpmtimer.addtimer 3000, "PlaySound ""fx_alarm"" '"
				
				'ADJUST LIGHTS
					Light11.State = 1
		   
        Case 8 'BATTLE NAME: MURDOCK SCAPE => Follow the Lights 

				'BATTLE VARIABLES
					LightHits9 = 0

				'BATTLE ACTIONS ON THE TABLE
					DMDTimer.Enabled = True
					FollowTheLights.Enabled = 1
					Gate2.Open = 0
					Gate3.Open = 0
					
				'DELAY DMDScore
					ScoreDMDActive =0
					TiempoActivarDMDScore(5000)

				'ADJUST THE BALL EXIT TIME
					vpmtimer.addtimer 4500, "Activate_Batte '" 
					vpmtimer.addtimer 4500, "JeepHoleExit '"
			
				'ADJUST AND ORDER DMD SCENE
					DoubleFraseDMD  "FIND THE WAY","FOLLOW THE LIGHT"
					vpmtimer.addtimer 2300, "GifDMD ""HOSPITAL-CARTEL"" '"	

				'ADJUST SOUND
					PlaySound "Murdock_Scape"

				'ADJUST LIGHTS
					Light60.State = 2


		Case 9 'BA_Targets
			PlaySound "fx_alarm"
			
			PlaySound "Rafaga"
		
			BA_Light001.State = 2
			BA_Light002.State = 2
			BA_Light003.State = 2
			BA_Light004.State = 2
			BA_Light005.State = 2
			BA_Light006.State = 2

			MAGNA_Light001.State = 2
			MAGNA_Light002.State = 2
			MAGNA_Light003.State = 2
			MAGNA_Light004.State = 2
			MAGNA_Light005.State = 2
			

			'ADJUST THE BALL EXIT TIME
			vpmtimer.addtimer 4000, "Activate_Batte '" 
			vpmtimer.addtimer 4000, "JeepHoleExit '"
			FraseMediumDMD "BA TARGETS"
			
			mMagnaSave.MagnetOn = 1
			mMagnaSave001.MagnetOn = 1
			mMagnaSave002.MagnetOn = 1
			mMagnaSave003.MagnetOn = 1
			mMagnaSave004.MagnetOn = 1
			
        Case 10 'LITE MULTIBALL"
			PlaySound "fx_alarm"
			
			PlaySound "Rafaga"
			'ADJUST THE BALL EXIT TIME
			vpmtimer.addtimer 7000, "Activate_Batte '" 
			vpmtimer.addtimer 4000, "JeepHoleExit '"
			FraseMediumDMD "LITE MULTIBALL"
			PlaySound "Rafaga"

			Light42. State = 2

			
			'mMagnaSave.MagnetOn = 1'IMAN'

        Case 11'Mordekai the Summoner - the final battle
            'DMD CL("MORDEKAI BATTLE"), CL("SHOOT THE JACKPOTS"), "", eNone, eNone, eNone, 1500, True, ""
           ' AddMultiball 4
           ' StartJackpots
           ' ChangeGi 5
    End Select
End Sub

Sub Activate_Batte
		Battle_is_Active = True
End Sub


Sub BattledelayVideoMode
			DMDTimer.Enabled = True
End Sub



'************************
' CHECK WIN BATTLE
'************************

' check if the battle is completed
Sub CheckWinBattle(Parameter) 
    dim tmp
    tmp = INT(RND * 7) + 1
    PlaySound "fx_thunder" & tmp
    DOF 126, DOFPulse
    LightSeqInserts.StopPlay 'stop the light effects before starting again so they don't play too long.
    LightEffect 3
    FlashEffect 3
    Select Case NewBattle
        Case 1 'FindtheBox
				'Delay DMDScore
					ScoreDMDActive =0
					TiempoActivarDMDScore(2000)

				If (FindtheBox (Parameter) = 1) Then
							
						'Dont Open the Gates in Hannibal Mision
						If Mision (CurrentPlayer, 0 ) >< 2 Then
							Gate2.Open = 1
							Gate3.Open = 1
						End If
					WinBattle
					Light5.State = 1
				End If

				If (FindtheBox (Parameter) = 0) Then 
				vpmtimer.addtimer 1500, "FraseMediumDMD ""TRY AGAIN"" '"
				Playsound "MURDOCK_WHAT_ARE_YOU_DOING_DUDE"
				End If
				FindTheBoxDMD(Parameter)        
        Case 4
            If OrbitHits = 6 Then WinBattle:End if
        Case 8
            If LightHits9 = 3 Then
				ScoreDMDActive =0
				TiempoActivarDMDScore (4000)
				WinBattle 
				Addscore 10000000
				vpmtimer.addtimer 5000, "Addscore ""0"" '"
				End if

   
    End Select
End Sub

Sub StopBattle 'called at the end of a ball
    Dim i
    Battle(CurrentPlayer, 0) = 0
    For i = 0 to 15
        If Battle(CurrentPlayer, i) = 2 Then Battle(CurrentPlayer, i) = 0
    Next
    UpdateBattleLights
    StopBattle2
    NewBattle = 0

End Sub
'************************
' WIN BATTLE CASE
'************************


'called after completing a battle

Sub WinBattle 
    Dim tmp
   
	
	ScoreDMDActive =0
	TiempoActivarDMDScore (4000)

	Select Case Battle(CurrentPlayer, 0)
    '    Case 0:vpmtimer.addtimer 1500, "PlaySound ""vo_excelent"" '"
		Case 1

				vpmtimer.addtimer 1500, "FraseMediumDMD ""SUPPLY FOUND"" '" 
				Playsound "HANNIBAL_PLAINS"
				vpmtimer.addtimer 3000, "GifDMD ""10Millions"" '"
				
				Addscore 10000000
				vpmtimer.addtimer 5000, "Addscore ""0"" '"
				
					

    '    Case 2:vpmtimer.addtimer 1500, "PlaySound ""vo_welldone"" '"
		Case 3:vpmtimer.addtimer 1500, "PlaySound ""Murdock_winner"" '"

		


	End Select

    Battle(CurrentPlayer, 0) = 0
    Battle(CurrentPlayer, NewBattle) = 1
    UpdateBattleLights
    FlashEffect 2
    LightEffect 2
    GiEffect 2
	Battle_is_Active = False
    
    DOF 139, DOFPulse
   

    StopBattle2

	ResetNewBallLights
	NewBattle = 0
    SelectBattle 
    ChangeSong

End Sub

Sub StopBattle2 
    'Turn off the bomb lights
	LightTS1.State = 0
	LightTS2.State = 0	
	LightTS3.State = 0
	LightTS4.State = 0	
    Light29.State = 0
    Light31.State = 0
    Light33.State = 0    
    Light35.State = 0   
	Light48.State = 0
	Light39.State = 0
	Light42.State = 0
	Light10.State = 0
	Light60.State = 0


	Light5.State = 0
	Light6.State = 0
    Light7.State = 0
    Light8.State = 0
    Light9.State = 0
	Light10.State = 0
    Light11.State = 0
    Light60.State = 0
	Light12.State = 0
	Light61.State = 0


	Light19.State = 0
	Light20.State = 0

	ExtraBall_Light.State = 0
	LScape001.State = 0
	FlashRotativo001.Visible= False
	LScape002.State = 0
	LScape002bis.State = 0
	LScape003.State = 0
	LScape0031.State = 0
	LScape0032.State = 0
	LScape0033.State = 0
	
	PanelLedTimer. Enabled = False
	Panelled1.Image = "led0"


	BA_Light001.State = 0	
	BA_Light002.State = 0
	BA_Light003.State = 0
	BA_Light004.State = 0
	BA_Light005.State = 0
	BA_Light006.State = 0
	
	MAGNA_Light001.State = 0
	MAGNA_Light002.State = 0
	MAGNA_Light003.State = 0
	MAGNA_Light004.State = 0
	MAGNA_Light005.State = 0

			Gate2.Open = 1
			Gate3.Open = 1

	Faro_Posicion.Visible= False
	CloseDoor
	Rafaga_ligth_turn_Off
	TargetS1_Status (CurrentPlayer )= 0
	TargetS2_Status (CurrentPlayer )= 0
	TargetS3_Status (CurrentPlayer )= 0
	TargetS4_Status (CurrentPlayer )= 0
		
	LightTS1.State = 0
	LightTS2.State = 0
	LightTS3.State = 0
	LightTS4.State = 0

	Door_Bloqued = false

	'AQUI DESACTIVO TODO 

		
		LightHits9 = 0

		'Stop Light Ramps except Faceman Mision
		If Mision(CurrentPlayer,0) >< 3 Then
			Light36.State = 0
			Light34.State = 0
		End If		
			
		BattlesWon(CurrentPlayer) = BattlesWon(CurrentPlayer) + 1
			 'stop some timers or reset battle variables
		Select Case NewBattle
			Case 1 

				
				Battle(CurrentPlayer, 0) = 0
					If Battle_is_Active = True Then
					Battle(CurrentPlayer, 1) = 1
					End If
				UpdateBattleLights
			  
			Case 2
				
				
				Battle(CurrentPlayer, 0) = 0
					If Battle_is_Active = True Then
					Battle(CurrentPlayer, 2) = 1
					End If
				UpdateBattleLights

				AddScore Punch_Out_Value
				Cronometro_segundos.enabled = false
				Punch_Out_Value = 0

			  Case 6
				
				
				Battle(CurrentPlayer, 0) = 0
				
				
				If Battle_is_Active = True Then
						Battle(CurrentPlayer, 6) = 1
				End If
				UpdateBattleLights
				
			Case 7
				If Battle_is_Active = True Then
						Battle(CurrentPlayer, 7) = 1
				End If
				UpdateBattleLights

			Case 8:	
					If Battle_is_Active = True Then
					FollowTheLights.Enabled = 0
					Battle(CurrentPlayer, 8) = 1
					
					End If
					
					Battle(CurrentPlayer, 0) = 0

					UpdateBattleLights
			Case 9
				mMagnaSave.MagnetOn = 0
				mMagnaSave001.MagnetOn = 0
				mMagnaSave002.MagnetOn = 0
				mMagnaSave003.MagnetOn = 0
				mMagnaSave004.MagnetOn = 0
				
				If Battle_is_Active = True Then
						Battle(CurrentPlayer, 9) = 1
				End If
				UpdateBattleLights
			Case 10
				
				
				Battle(CurrentPlayer, 0) = 0
				mMagnaSave.MagnetOn = 0
				
				If Battle_is_Active = True Then
						Battle(CurrentPlayer, 10) = 1
				End If

				UpdateBattleLights

			End Select
		
		Battle_is_Active= False
		BlinkB2STimer. Enabled = False
		DOF LuzBackglass,0
		LuzBackglass = 0
		FaseParpadeo = 0
		UpdateBattleLights
End Sub



Sub ResetBattles
    Dim i, j
    For j = 0 to 4
        BattlesWon(j) = 0
        For i = 0 to 12
            Battle(CurrentPlayer, i) = 0
        Next
    Next
    NewBattle = 0
End Sub

Sub ResetMisions
 Dim i, j
    For j = 0 to 4
        ContadorMisionDone(j) = 0
        For i = 0 to 5
		OrdenNombreMision (j,i) = 0
		Norepetirmision (j,i) = 0
        Mision(j, i) = 0
        Next
	MisionActiva (j) = 0
    Next
    NewMision = 0
End Sub

Sub ResetDraw
 Dim i, j
    For j = 0 to 4
      '  ContadorMisionDone(j) = 0
        For i = 0 to 11
		OrdenNombreDraw (j,i) = 0
		Not_Repeat_Draw_number (j,i) = 0
        Draw(j, i) = 0
        Next
	Weel_of_Fortune_Activa (j) = 0
    Next
    'NewMision = 0
End Sub

'Extra subs for the battles

Sub LightSeqAllTargets_PlayDone()
    LightSeqAllTargets.Play SeqRandom, 10, , 1000
End Sub

Sub LightSeqBumpers_PlayDone()
    LightSeqBumpers.Play SeqRandom, 10, , 1000
End Sub

Sub LightSeqBlueTargets_PlayDone()
    LightSeqBlueTargets.Play SeqRandom, 10, , 1000
End Sub

' Wizards modes timer
Dim FTLstep:FTLstep = 0

Sub FollowTheLights_Timer
    LScape001.State = 0
	FlashRotativo001.Visible= False
    LScape002.State = 0
	LScape002Bis.State = 0
    LScape003.State = 0
	LScape0031.State = 0
	LScape0032.State = 0
	LScape0033.State = 0
    
	Panelled1.Image = "led0"
	PanelLedTimer. Enabled = False
    
    Select Case Battle(CurrentPlayer, 0)
        Case 8
            Select case FTLstep
                Case 0:FTLstep = 1:LScape001.State = 2:FlashRotativo001.Visible= True: PanelLedTimer. Enabled = False 'PlaySound "fx_alarm"
                Case 1:FTLstep = 2:LScape002.State = 2:LScape002BIs.State = 2
                Case 2:FTLstep = 3:LScape003.State = 2:LScape0031.State = 2:LScape0032.State = 2:LScape0033.State = 2
                Case 3:FTLstep = 0:Panelled1.Image = "led1": PanelLedTimer. Enabled = True 
                
            End Select
       
    End Select
End Sub



Sub CuentaAtras
	Cronometro_segundos.enabled = true
End Sub

Sub Cronometro_segundos_Timer

		If Segundos_Value > 0 AND NewBattle = 2 Then

			If Segundos_Value>19 Or Segundos_Value < 10 Then
				Segundos_Value = Segundos_Value - 1
				ScoreDMDActive =0
				TiempoActivarDMDScore (5000)
				PunchOutDMD
			Else 
				Segundos_Value = Segundos_Value - 1
			End If

		Else
			ScoreDMDActive =0
			TiempoActivarDMDScore (1500)
			PlaySound "HANNIBAL_KEEP_CALM_MA"
			DoubleFraseDMD FormatNumber(Punch_Out_Value, 0, -1, 0, -1), "TOTAL PUNCH OUT"
			AddScore Punch_Out_Value
			WinBattle
			
			'StopBattle
			'Falta volver a la cancion original
			Cronometro_segundos.enabled = false
			Punch_Out_Value = 0
		End If

		

End Sub

'**********************
' Power up Jackpot
'**********************
' 30 seconds hurry up with jackpots on the right ramp
' uses variable PowerupHits and the light50

Sub CheckPowerup
    If light50.State = 0 Then
        If PowerupHits MOD 10 = 0 Then
            EnablePowerup
        End If
    End If
End Sub

Sub EnablePowerup
    ' start the timers
    PowerupTimerExpired.Enabled = True
    PowerupSpeedUpTimer.Enabled = True
    ' turn on the light
    Light50.BlinkInterval = 160
    Light50.State = 2
End Sub

Sub PowerupTimerExpired_Timer()
    PowerupTimerExpired.Enabled = False
    ' turn off the light
    Light50.State = 0
End Sub

Sub PowerupSpeedUpTimer_Timer()
    PowerupSpeedUpTimer.Enabled = False
    ' Speed up the blinking
    Light50.BlinkInterval = 80
    Light50.State = 2
End Sub

Function Min(a, b)
  If a < b Then Min = a Else Min = b
End Function

Sub DMDTimer_Timer
	Dim i, n, n2, n3, n4, n5, x, y

				Frame = Frame + 1
			Select Case Battle(CurrentPlayer, 0)

			Case 3	'LOTERY
				DMDTimer.Interval = 80
				For i  =1 to 4
					If Rail_Lotery_Pos (i) > -129 Then 
						Rail_Lotery_Pos (i) = Rail_Lotery_Pos (i) - Vel_Rail (i)
					Else
								
							Rail_Lotery_Pos (i) = Vel_Rail(i) * (-2)
						
					End If
				
					Rail_Relativo (i) =    - Rail_Lotery_Pos (i) mod 32

				If Vel_Rail (i) = 0 Then 
						
						If Rail_Lotery_Pos (i)  MOD 32 >< 0 Then 
			
						If  Rail_Relativo (i)  > 16 Then 
												
								Rail_Lotery_Pos (i) = Rail_Lotery_Pos (i) - 1

							Else 
								Rail_Lotery_Pos (i) = Rail_Lotery_Pos (i) + 1
							End if
						End If
					

				End if
		
			Next
					FlexDMD.LockRenderThread
				For i =1 to 4
					FlexDMD.Stage.GetImage("Lotery_Img_"&i).SetBounds (32*(i-1)), Rail_Lotery_Pos (i), 32, 160
				Next

				'FLAG RAIL 1
					'FlexDMD.Stage.GetLabel("Score1").Text = FormatNumber ((Rail_Lotery_Pos (1) \ -32)+1, 0, -1, 0, -1)
					'FlexDMD.Stage.GetLabel("Score1").SetAlignedPosition 16, 32, FlexDMD_Align_BottomRight

				'FLAG RAIL 2
					'FlexDMD.Stage.GetLabel("Score2").Text = FormatNumber ((Rail_Lotery_Pos (2) \ -32)+1, 0, -1, 0, -1)
					'FlexDMD.Stage.GetLabel("Score2").SetAlignedPosition 48, 32, FlexDMD_Align_BottomRight

				'FLAG RAIL 3
					'FlexDMD.Stage.GetLabel("Score3").Text = FormatNumber ((Rail_Lotery_Pos (3)\ -32)+1, 0, -1, 0, -1)				
					'FlexDMD.Stage.GetLabel("Score3").SetAlignedPosition 80, 32, FlexDMD_Align_BottomRight

				'FLAG RAIL 4
					'FlexDMD.Stage.GetLabel("Score4").Text = FormatNumber ((Rail_Lotery_Pos (4)\ -32)+1, 0, -1, 0, -1)					
					'FlexDMD.Stage.GetLabel("Score4").SetAlignedPosition 112, 32, FlexDMD_Align_BottomRight

					FlexDMD.UnlockRenderThread
				

				If Frame MOD 20 = 0 Then 

				PlaySound "roulette"

				End if
		
				If Frame MOD 5 = 0 Then
						For i = 1 to 4	
							If Stop_Rail(i) = True Then 
								If Vel_Rail (i) > 0 Then 
									Vel_Rail (i) = Vel_Rail (i) - 1
									PlaySound "Stop_slot"	
								End if	
							End if
						Next
				End If
				If Vel_Rail (4) = 0 And Rail_Relativo(4) = 0 Then 

						PlaySound "fx_fanfare8"
						End_Lotery_VideoMode
				End if
					
		
			Case 4	'RUN AWAY
						'Make Visible only the current player car position
						For y = 1 to 3
								If Player_Car_position = y Then 

									Player_Car_Frames(y).Visible= True
								Else
									Player_Car_Frames(y).Visible= False
								End If
						Next

						If Car_Frames_ready = True Then 			
							If Lane_Saved(CurrentPlayer) <= 15 Then

								For i= 0 to 3
									Lane_RunAway_Status(i)= 1
								Next

								Lane_RunAway_Status( INT(RND * 3 + 1))= 0
								'Add Round in Runaway Mode
										
								FlexDMD.LockRenderThread
								FlexDMD.Stage.GetLabel("Score").Text = "Score:"& FormatNumber(RunAway_Value, 0, -1, 0, -1)
								FlexDMD.Stage.GetLabel("Score").SetAlignedPosition 1, 32, FlexDMD_Align_BottomLeft
								FlexDMD.UnlockRenderThread		
								
								Else
										'RunAway Done!
										ScoreDMDActive =0
										TiempoActivarDMDScore (1500)
										RunAway_Value = 10000000
										'DoubleFraseDMD FormatNumber(RunAway_Value, 0, -1, 0, -1), "TOTAL VIDEOMODE"
										AddScore RunAway_Value
										End_RunAway_Video_Mode
								End If
								
								Car_Frames_ready = False
								
							End If
								
								n = 1 + (Frame Mod 21)
								For i = 1 to 21
									If Lane_RunAway_Status(1)= 1 Then
									Car_Der_Frames(i).Visible = i = n
									End If

									If Lane_RunAway_Status(2)= 1 Then 
									Car_Izq_Frames(i).Visible = i = n
									End If

									If Lane_RunAway_Status(3)= 1 Then
									Car_Cen_Frames(i).Visible = i = n
									End If
								Next

							' 3 posibles colisiones
							If Car_Der_Frames(18).Visible = True AND Player_Car_position = 3 Then 	
								FraseMediumDMD  "CRASH"
								vpmtimer.addtimer 2000, "PlaySound ""FACE_ITS_TIME_TO_DISAPPEAR"" '"	
								PlaySound "Car_Crash" 
								End_RunAway_Video_Mode
							End If 

							If Car_Izq_Frames(18).Visible = True AND Player_Car_position = 1 Then 								
								FraseMediumDMD  "CRASH"
								vpmtimer.addtimer 2000, "PlaySound ""FACE_ITS_TIME_TO_DISAPPEAR"" '"	
								PlaySound "Car_Crash" 
								End_RunAway_Video_Mode					
							End If 

							If Car_Cen_Frames(18).Visible = True AND Player_Car_position = 2 Then 				'				
								FraseMediumDMD  "CRASH"
								vpmtimer.addtimer 200, "PlaySound ""FACE_ITS_TIME_TO_DISAPPEAR"" '"	
								PlaySound "Car_Crash" 
								End_RunAway_Video_Mode
							End If 								
							'Reducir tiempo entre rondas
						 
						If Frame Mod 21 = 0 Then 
							Car_Frames_ready = True
							DMDTimer.Interval = DMDTimer.Interval - 4
							Lane_Saved(CurrentPlayer) = Lane_Saved(CurrentPlayer) +1
							RunAway_Value = RunAway_Value + 300000	
							PlaySound "PassingCar"
						End If 

			Case 5 'FIND AND SHOOT

					Dim Ramdom
					DMDTimer.Interval = 80

					'Enemy 1 posiciones  64, 130, 196
					'Enemy 2 posiciones  88, 154, 220
					'Enemy 3 posiciones  112, 178, 244
					'Enemy 4 posiciones  136, 202, 268
	
					For i =1 to 4
						Frame_Enemy(i) = Frame_Enemy(i) + 1
					Next

					'POSITIONS
					For i =1 to 4
						If Enemy_FindAndShoot_Active (i) = False Then

							Ramdom = (INT(RND * 3 + 1))
							Enemy_FindAndShoot_posX(i,1) = (Ramdom * 8) + (80 * (Ramdom-1)) + ((i-1)*64) + (56 * Ramdom) + (16 *(Ramdom-1))

							'Rectificado 4
							If i = 4 Then 
								Enemy_FindAndShoot_posX(i,1) = Enemy_FindAndShoot_posX(i,1) -96

							End If

							Enemy_FindAndShoot_posX(i,2) = Enemy_FindAndShoot_posX(i,1)


							'Rectificada posición tomando el centro de la imagen y el centro del enemigo
								Enemy_FindAndShoot_posX(i,1) =  - Mirilla_posX + Enemy_FindAndShoot_posX(i,1) + 64 - 16
							
							Enemy_FindAndShoot_Active(i) = True							
						End If
					Next
						
					FlexDMD.LockRenderThread
					FlexDMD.Stage.GetImage("Background_FindAndShoot_1").SetBounds CursorX, 0, 600, 32

				'carga del gif en posicion
					 	
						n = 1 + (Frame_Enemy(1) Mod 5)	
							For i = 1 to 5
								If Frame_Enemy(1) =< 10 Then 
									FlexDMD.Stage.GetImage("Enemy1_Img_" & i).SetBounds Enemy_FindAndShoot_posX(1,1) + 32 - (Frame_Enemy(1)*3), 0 , 32, 32
									Enemy1_Frames(i).Visible = i = n
								End If
								
								If Frame_Enemy(1) > 10 Then 
									FlexDMD.Stage.GetImage("Enemy1_Img_" & i).SetBounds Enemy_FindAndShoot_posX(1,1), 0, 32, 32
									Enemy1_Frames(i).Visible = i = n
								End If

								If Frame_Enemy(1) > 40 Then 
									FlexDMD.Stage.GetImage("Enemy1_Img_" & i).SetBounds Enemy_FindAndShoot_posX(1,1) + (Frame_Enemy(1) - 40 )*3, 0 , 32, 32
									Enemy1_Frames(i).Visible = i = n
								End If
							Next

						FlexDMD.Stage.GetImage("PrimerPlanoFindAndShoot_1").SetBounds CursorX, 0, 600, 32 

						n2 = 1 + (Frame_Enemy(2) Mod 5)
							For i = 1 to 5
								If Frame_Enemy(2) =< 10 Then 
									FlexDMD.Stage.GetImage("Enemy2_Img_" & i).SetBounds Enemy_FindAndShoot_posX(2,1)- 32 + (Frame_Enemy(2)*3),0 , 32, 32
									Enemy2_Frames(i).Visible = i = n2
								End If
								
								If Frame_Enemy(2) > 10 Then 
									FlexDMD.Stage.GetImage("Enemy2_Img_" & i).SetBounds Enemy_FindAndShoot_posX(2,1), 0, 32, 32
									Enemy2_Frames(i).Visible = i = n2
								End If

								If Frame_Enemy(2) > 40 Then 
									FlexDMD.Stage.GetImage("Enemy2_Img_" & i).SetBounds Enemy_FindAndShoot_posX(2,1) + ((40 - Frame_Enemy(2) )*3),0 , 32, 32
									Enemy2_Frames(i).Visible = i = n2
								End If
							Next


						n3 = 1 + (Frame_Enemy(3) Mod 5)				
							For i = 1 to 5
								If Frame_Enemy(3) =< 10 Then 
									FlexDMD.Stage.GetImage("Enemy3_Img_" & i).SetBounds Enemy_FindAndShoot_posX(3,1), 32 - (Frame_Enemy(3)*3) , 32, 32
									Enemy3_Frames(i).Visible = i = n3
								End If
								
								If Frame_Enemy(3) > 10 Then 
									FlexDMD.Stage.GetImage("Enemy3_Img_" & i).SetBounds Enemy_FindAndShoot_posX(3,1), 0, 32, 32
									Enemy3_Frames(i).Visible = i = n3
								End If

								If Frame_Enemy(3) > 40 Then 
									FlexDMD.Stage.GetImage("Enemy3_Img_" & i).SetBounds Enemy_FindAndShoot_posX(3,1), (Frame_Enemy(3) - 40 )*3 , 32, 32
									Enemy3_Frames(i).Visible = i = n3
								End If
							Next

						n4 = 1 + (Frame_Enemy(4) Mod 5)					
							For i = 1 to 5
								If Frame_Enemy(4) =< 10 Then 
									FlexDMD.Stage.GetImage("Enemy4_Img_" & i).SetBounds Enemy_FindAndShoot_posX(4,1), 32 - (Frame_Enemy(4)*3) , 32, 32
									Enemy4_Frames(i).Visible = i = n4
								End If
								
								If Frame_Enemy(4) > 10 Then 
									FlexDMD.Stage.GetImage("Enemy4_Img_" & i).SetBounds Enemy_FindAndShoot_posX(4,1), 0, 32, 32
									Enemy4_Frames(i).Visible = i = n4
								End If

								If Frame_Enemy(4) > 40 Then 
									FlexDMD.Stage.GetImage("Enemy4_Img_" & i).SetBounds Enemy_FindAndShoot_posX(4,1), (Frame_Enemy(4) - 40 )*3 , 32, 32
									Enemy4_Frames(i).Visible = i = n4
								End If
							Next

				'MIRILLA

						If Mirilla_Active > 0 Then 
							n5 = 1 + (Frame Mod 4)
								For i = 2 to 4
									FlexDMD.Stage.GetImage("Mirilla" & i).SetBounds 0, 0, 128, 32
									Mirilla_FindAndShoot_DMD(i).Visible = i = n5

										If Mirilla_Active > 3 Then 
											Mirilla_Active = 0
										Else
											Mirilla_Active = Mirilla_Active + 1
										End if
								Next
						Else
								Mirilla_FindAndShoot_DMD(1).Visible = True
								For i = 2 to 4
								Mirilla_FindAndShoot_DMD(i).Visible = False
								Next
						End if

					FlexDMD.Stage.GetLabel("Score").Text = "HITS: " & FormatNumber(FindAndShoot_Scores(CurrentPlayer), 0, -1, 0, -1)
					FlexDMD.Stage.GetLabel("Score").SetAlignedPosition 120, 32, FlexDMD_Align_BottomRight

				'ENEMY1 FLAG

					FlexDMD.Stage.GetLabel("ENEMY1_POSITION").Text = FormatNumber( FindAndShoot_Timer, 0, -1, 0, -1)
					FlexDMD.Stage.GetLabel("ENEMY1_POSITION").SetAlignedPosition 12, 32, FlexDMD_Align_BottomRight
					FlexDMD.UnlockRenderThread
				
				For i=1 to 4 
						If Frame_Enemy(i) Mod 50 = 0 Then 
							vpmtimer.addtimer 2000, "Delay_enemy_findAnd_shoot ("&i&") '" 	
							'Saco al muñeco
							Enemy_FindAndShoot_posX(i,1)=- 256
							Enemy_FindAndShoot_posX(i,2)=- 256
						End If
				Next

				'MOVIMIENTO CON LOS FLIPPERS

					If LeftFlipperPressed = True Then 
						If CursorX < 0 Then 
							CursorX = CursorX + 8
							Mirilla_posX = Mirilla_posX - 8
								For i = 1 to 4
									Enemy_FindAndShoot_posX(i,1) = Enemy_FindAndShoot_posX(i,1) + 8
								Next
						End If
					End If

					If RightFlipperPressed = True Then
						If CursorX  >  -453 Then 
							CursorX = CursorX -8
							Mirilla_posX = Mirilla_posX + 8
								For i = 1 to 4
									Enemy_FindAndShoot_posX(i,1) = Enemy_FindAndShoot_posX(i,1) - 8
								Next
						End If
					End If

				'ENEMY HIT
 
				For i = 1 to 4
						If Enemy_FindAndShoot_posX(i,2)= Mirilla_posX  AND Frame_Enemy(i) > 10 AND  Frame_Enemy(i) < 40 Then 
							PlaySound "Gun_1"
							vpmtimer.addtimer 2000, "Delay_enemy_findAnd_shoot ("&i&") '" 
							FindAndShoot_Value = FindAndShoot_Value + 500000
							'Saco al muñeco
							Enemy_FindAndShoot_posX(i,1)=- 256
							Enemy_FindAndShoot_posX(i,2)=- 256
							FindAndShoot_Scores(CurrentPlayer) = FindAndShoot_Scores(CurrentPlayer) + 1
							Mirilla_FindAndShoot_DMD(1).Visible = False
							Mirilla_FindAndShoot_DMD(2).Visible = True
							Mirilla_Active = 1		
						End If

				Next
					'CUENTA ATRAS

					If Frame Mod 12 = 0 Then
						FindAndShoot_Timer = FindAndShoot_Timer - 1 
							If FindAndShoot_Timer = 0  or FindAndShoot_Scores(CurrentPlayer) =20 Then
							End_FindAndShoot_Video_Mode
							End If
							
					End If


			Case 8 'MURDOCK SCAPE

				Primitive011.ObjRoty= 315
				Primitive011.ObjRotx= 90
				Primitive011.ObjRotz= Primitive011.ObjRotz+ +1130

				If LScape001.State = 2  Then
					FlashRotativo001.RotZ= FlashRotativo001.RotZ+1130
					Primitive013.RotZ= Primitive013.RotZ+1130			
				End If

				If LScape002.State = 2  Then
					'FlashRotativo001.RotZ= FlashRotativo001.RotZ+1130
					Primitive004.RotZ= Primitive004.RotZ+1130	
					Primitive005.RotZ= Primitive005.RotZ+1130
				End If
				
		End Select
		
End Sub

Sub Delay_enemy_findAnd_shoot (enemigo)

		Enemy_FindAndShoot_Active (enemigo) = False
		Frame_Enemy(enemigo)= 0
		
End sub

Sub End_Lotery_VideoMode
		
	Dim i
		
		For i = 1 to 4
				
				If Rail_Lotery_Pos (i) = -128 Then 
					Rail_Lotery_Pos (i) = 0
				End if

				if Rail_Lotery_Pos (i) = 0 Then 
					Lotery_Value(1) = Lotery_Value(1) + 1
				End if
				
				if Rail_Lotery_Pos (i) = -32 Then 
					Lotery_Value(2) = Lotery_Value(2) + 1
				End if
				if Rail_Lotery_Pos (i) = -64 Then 
					Lotery_Value(3) = Lotery_Value(3) + 1
				End if
				if Rail_Lotery_Pos (i) = -96 Then 
					Lotery_Value(4) = Lotery_Value(4) + 1
				End if	

				
		Next	
					Lotery_Score = 10000000
			If Rail_Lotery_Pos (2) = Rail_Lotery_Pos (1) Then 

				If Rail_Lotery_Pos (3) = Rail_Lotery_Pos (1) Then 

					If Rail_Lotery_Pos (4) = Rail_Lotery_Pos (1) Then

							Lotery_Score = 3000000
					End If
				End if

			End if

				If ((Rail_Lotery_Pos (1) + Rail_Lotery_Pos(2) +  Rail_Lotery_Pos(3) +  Rail_Lotery_Pos(4))/-32) = 6 then 
					
				End If

					ScoreDMDActive =0
					TiempoActivarDMDScore (1000)
					ADDSCORE Lotery_Score
					
					'Necesario para no redefinir Lotery Value
					vpmtimer.addtimer 3000, "End_Lotery_VideoMode_Compensed '"

					vpmtimer.addtimer 3000, "PlaySound ""fx_Alarm"" '"
					vpmtimer.addtimer 4000, "JeepHoleExit '"
					WinBattle '"
				
End Sub

Sub End_Lotery_VideoMode_Compensed
	Dim i
		DMDTimer.Enabled = False
		Frame = 0
		VideoModeActive = False 'UNLOCK THE FLIPPERS
				For i = 1 to 4 
					Rail_Lotery_Pos (i)= 0
					Lotery_Value (i) = 0
				Next

			If Lotery_Score = 10000000 Then 
				GifDMD "10Millions"
			Else
				DoubleFraseDMD "" & (Lotery_Score/1000000) & " MILLIONS", "LOTERY VIDEOMODE"
			End If
				Lotery_Score = 0
End Sub

Sub End_FindAndShoot_Video_Mode
	Dim i,n, w, q

		ScoreDMDActive =0
		TiempoActivarDMDScore (1500)

		If FindAndShoot_Value > 7000000 Then 
			FindAndShoot_Value= 10000000
		End If

		If FindAndShoot_Value= 10000000 Then 
			GifDMD "10Millions"
			PlaySound "HANNIBAL_PLAINS"
		Else
			DoubleFraseDMD FormatNumber(FindAndShoot_Value, 0, -1, 0, -1), "TOTAL VIDEOMODE"
			PlaySound "HANNIBAL_getting_worse"
		End If

		AddScore FindAndShoot_Value
		FindAndShoot_Timer = 30
		DMDTimer.Enabled = False
		vpmtimer.addtimer 2000, "PlaySound ""fx_Alarm"" '"
		vpmtimer.addtimer 3000, "JeepHoleExit '"
		'DMDTimer.Interval = 144
		VideoModeActive = False
		FindAndShoot_Scores(CurrentPlayer) = 0
		Enemy_FindAndShoot_posX(1,1) = 0
		Enemy_FindAndShoot_posX(1,2) = 0
		Enemy_FindAndShoot_posX(2,1) = 0
		Enemy_FindAndShoot_posX(2,2) = 0
		Enemy_FindAndShoot_posX(3,1) = 0
		Enemy_FindAndShoot_posX(3,2) = 0
		Enemy_FindAndShoot_posX(4,1) = 0
		Enemy_FindAndShoot_posX(4,2) = 0
		CursorX = 0
		Mirilla_Active= 0
		Mirilla_posX = 64
		
		Frame = 0
			For i = 1 to 5
					Enemy1_Frames(i).Visible = False
					Enemy2_Frames(i).Visible = False
					Enemy3_Frames(i).Visible = False
					Enemy4_Frames(i).Visible = False
			Next
			For n = 1 to 4 
				Frame_Enemy(n)= 0
				Enemy_FindAndShoot_Active (n) = False
			Next
		WinBattle
		FindAndShoot_Value = 0
		
		
End Sub

Sub End_RunAway_Video_Mode
	Dim i,n

		ScoreDMDActive =0
		TiempoActivarDMDScore (1500)
		If RunAway_Value =10000000 Then
			GifDMD "10Millions"
			Playsound "HANNIBAL_PLAINS"
		Else
		DoubleFraseDMD FormatNumber(RunAway_Value, 0, -1, 0, -1), "TOTAL VIDEOMODE"
		End If
		AddScore RunAway_Value

		DMDTimer.Enabled = False
		vpmtimer.addtimer 2000, "PlaySound ""fx_Alarm"" '"
		vpmtimer.addtimer 3000, "JeepHoleExit '"
		'DMDTimer.Interval = 144
		VideoModeActive = False  'UNLOCK THE FLIPPERS
		Lane_Saved(CurrentPlayer) = 0
		Frame = 0
			For i = 1 to 21
				Car_Der_Frames(i).Visible = False
				Car_Cen_Frames(i).Visible= False		
				Car_Der_Frames(i).Visible= False		
			Next
			For n = 1to 3 
				Player_Car_Frames(n).Visible= False
			Next
		WinBattle

		RunAway_Value = 0
		
End Sub

Sub Rest_Mision_Timer_Timer
		Rest_MISION_active_DMD
		Dmd_Rest_Active = False
		Rest_Mision_Timer. Enabled = False
End Sub

Sub LuzBackglassOFF()
	Dim i
    For i =201 to 214
		DOF i,0
	Next	
					
End Sub



Sub BlinkB2STimer_Timer

	If FaseParpadeo = 1 Then 
				 
		DOF LuzBackglass, 1 
		FaseParpadeo = 0
	
	Else 
		DOF LuzBackglass, 0 
		FaseParpadeo = 1

	End If

End Sub


Sub BlinkCharacterB2STimer_Timer

	If FaseCharacterParpadeo = 1 Then 
				 
		DOF LuzCharacterBackglass, 1 
		FaseCharacterParpadeo = 0
	
	Else 
		DOF LuzCharacterBackglass, 0 
		FaseCharacterParpadeo = 1

	End If

End Sub


Sub PanelLedTimer_Timer

	If Panelled1.Image = "led1" Then 
				 
		Panelled1.Image = "led2"
		
	Else 
		Panelled1.Image = "led1"

	End If

End Sub