' Double Potions Pinball Presents
'
' Zone Fury VPX
'
' Visual Pinball Table DPT-X03
'
' Author: Neo
' Table Version: 1.0.0
' Version Date: 9/4/23
' Players: 1-4
'
'
' Zone Fury VPX is my third table for VPX, and is a conversion/rebuild of the VP9 version. 
' 
' For those who hadn't played the VP9 vversion, Zone Fury is based on the Zone mode in the Playstation 3 game Wipeout HD. In Zone Fury, the goal is to get to as high a Zone as you possibly can. 
' The table starts out at Zone 0 (Sub-Venom), and you advance Zones by making ramp shots, orbit shots, completing ZONE, and accruing 10,000 in bonus. 
' You progress through the Zones as in the original game. From the Wipeout speed classes early on, up to and beyond Zone 75 (Supersonic), "magnets" that serve as accelerators accelerate the ball as you progess through the Zones.
' The force of the bumpers also increases with each named Zone. The idea is that the game gets progressively faster the longer you play.
'
' The game is essentially unchanged from the VP9 version but I did put in some enhancements
' - Improved VPX physics
' - Replaced the old shoot-again light with an LED display that displays the remaining ball-save time similar to what Spooky did on games like Rick & Morty and TNA. It shows *SA* when you've won an extra ball
' - Changed LOCK to light all three locks when completed in any order for the first multiball of the game. LOCK on subsequent multiballs still light one lock at a time unless completed in sequence. 
'   Makes it a little easier to get multiball
' - Completing LOCK in multiball advances the battle zone by 0.2
' - Shooting left orbit now advances 1 Zone in general play, or the battle zone by 0.2 when in multiball
' - Winning any sponsor in multiball now advances Battle Zone by 0.5
' - Table remembers the status of LOCK drop targets across players/balls for multiball purposes 
' - Table remembers status of ZONE lights across players/balls
' - Reduced number of Zone Boost jackpots needed for Mirage sponsor from 4 to 2.
' - Changed Assegai sponsor requirement to "Battle Zone 10.0+ Jackpot"
' - Changed AG-Systems sponsor requirement to "Attain Zone 80" 
' - Clearing either the EG-X or G45 drop targets in any order now lights the Piranha Spinner for 1,000 points/spin for the remainder of the current ball
' - Clearing both EG-X and G45 drop targets once in the same ball sets all scores to 2x for remainder of ball. Clearing both three times in the same ball sets all scores to 3x for remainder of ball
' - Added a ramp-combo system to the game that was not in the VP9 version
' - Added a skill shot at the start of each ball that was not in the VP9 version.
' - Updated the GI lights to change colors with the named Zones as well as at certain Zones in multiball.
'
' Game Music Credits
'
' Table Startup/End of Game: Excerpts from "DOX T" by Cold Storage
' Mix 01, Mix 02, Mix 03: Excerpts from "Euphorasm Vol. 2" mixed by DJ Sly One
' Mix 04: Excerpt from "Listening" mixed by YuSik
' Mix 05: "Information High" by Yoko Kanno (from the anime Macross Plus)
' Mix 06: "Together Forever (Signum mix) by Oceanlab
' Mix 07: Multiball: "PSI-Missing" by Mami Kawada from the anime series To Ari Majutsu no Index 
' Mix 08: Multiball - "Kimi wo Mamotitai" from the anime series Freezing
'
' Wipeout HD Fury by SCEE Studio Liverpool, published by Sony Computer Entertainment Europe. Logos based on the original game placed on the table in honor of the Wipeout universe 
' as portrayed in the original games. 
'
' There is a B2S backglass included with the table zip. It's mre meant for cabinet guys, but DT players can use it if they wish. I didn't disable the DT score displays when B2S is active
'
' This table is not to be sold by anyone to anyone. The table is meant to be available as a FREE DOWNLOAD to be enjoyed by all. 
' No profit of any kind is being made by the author of this table. If you bought this table either by ebay, or some other means, YOU WERE RIPPED OFF!!!
'
' While modifications for personal use are okay. please reach out to me if you'd like to mod this table for public release. I'll be curious as to what is intended, as it may be something that never occurred to me 
' I'll likely be good with mods for VR rooms, specific cabinet setups, and DOF mods as I know next to nothing about how to set any of that stuff up, and I have no DOF or VR hardware to test. The table has some basic DOF commands
' in the script for some (likely not all) of the mechanical bits.
'
' Any suggestions or comments on how the table can be improved are welcome, you can find me at either vpForums, Pinball Nirvana, or VPUniverse.com. There is still much about building tables in VPX I still need to learn.
' Please keep comments constructive, as any non-constructive flames will be stoned to death ("Look, a flamer! May we burn him?") :-)
'
' ************************************************************************************************************************
' Table Revision History
'
' 1.0.0 - Initial Release Version
' ************************************************************************************************************************
'
' DOF Configuration (originally byOuthere, adapted for this table)
'
'101 Left Flipper
'102 Right Flipper
'103 Left Slingshot
'104 Right Slingshot
'105 Not Used
'106 Not Used
'107 Bumper Left
'108 Bumper Center
'109 Bumper Right
'110 Not Used
'111 sw1.sw2.sw3,sw14,sw15,sw16 = (Resetdrop, EGX,G45 DT)
'112 sw17,sw18,sw19,sw20 = (Resetdrop, LOCK DT)
'113 Nil
'114 Spinner (Shaker)
'115 Nil
'116 Drop Targets Hit (sw1-sw3, sw14-sw20)
'117 Not Used
'118 Not Used
'119 Not Used
'120 Not Used
'121 Not Used
'122 Knocker
'123 Auto Plunger
'124 Not Used
'125 Not Used
'126 Not Used
'127 Ball Release
'128 Drain hit
'129 Not Used
'131 Kickers (Piranha Lock 1 & 2)

Option Explicit

TableState = -1							 ' Bootup table. This is in case we want to code a boot-up sequence if we're building a solid-state tablle

' Option System Constants - these are preceded with "Def"

Const DefBallsPerGame = 3				' 3 balls per game
Const DefGoalScore1 = 800000			' Replay Score 1 = 800,000 
Const DefGoalScore2 = 1800000			' Replay Score 2 = 1,800,000. Replay score of 0 disables the replay level
Const DefGoalScore3 = 3100000			' Replay Score 3 = 3,100.000, Replay score of 0 disables the replay level
Const DefGoalScore4 = 0					' Replay Score 4 = 0. Replay score of 0 disables the replay level
Const DefHighScore1 = 1200000			' Default High Score 1= 500,000
Const DefHighScore2 = 1100000			' Default High Score 2= 400,000
Const DefHighScore3 = 1000000			' Default High Score 3= 300,000
Const DefHighScore4 = 900000			' Default High Score 4= 200,000
Const DefMaxCredits = 99				' Default Max Credits = 99
Const DefReplayCredits = 1				' Default of 1 credit for making a replay score
Const DefTop4Credits = 1				' Default of 1 credit for making a top-4 high Score
Const DefHSCredits = 3					' Default of 3 credits for beating the High Score
Const DefReplayAward = 1				' Default replay award. 1=Credit, 2=Extra Ball, 0=Off
Const DefBallSaver = 10					' Default ball saver time = 10 seconds (ball saver off)
Const DefMBBallSaver = 15				' Default multiball ball saver time = 15 seconds (ball saver off)
Const DefTiltSens = 1.0 				' Default Tilt Sensitivity = 1
Const DefGameMusic = 4					' Default Game Music = 4 (Player Choice All)
Const DefDebugMode = 0					' Default Debug Mode state = Disabled
Const DefTableTips = 0					' Default Table Tips = 0 (off)
Const DefTournament = 0					' Default Tournament Mode = 0 (off)
Const DefMaxEBGame = 4					' Default Maximum Extra Balls/Game = 4
Const DefMaxEBBIP = 10					' Default Maximum Extra Balls/Game = 10 (10 = Off = No Limit)
Const DefBSDisplayOn = 1				' Default Ball Save Display On
Const MaxOptions = 23					

' General Game Constants
 
Const cGameName = "ZoneFuryVPX"			' Name of table for savefile. Change this to the name of your table
Const cVersion = "1.0.0"				' Current version
Const cMaxPlayers = 4					' Maximum of 4 players
Const cScoreLength = 7					' Maximum length on the score displays is 7 digits
Const cMaxBonusMult = 6					' Maximum Bonus Multiplier = 6
Const ZoneVelIncr = 0.03696				' Increment for increasing ball velocity per Zone

' Option-System Variables

Dim OptionLevel							' Current Option Level
Dim WorkOption							' Working Option Value
Dim CurrentOpt							' Current Option 
Dim OptBallsPerGame						' Number of balls per game
Dim OptGoalScore(4)						' Replay Scores
Dim OptMaxCredits						' Maximum number of credits the table will allow
Dim OptDefaultHighScore					' Sets the Default High Score the next time the High Score is reset
Dim OptReplayCredits					' Number of credits won on a replay
Dim OptHiScoreCredits					' Number of credits won on beating the High Score
Dim OptReplayAward						' Indicates what is awarded for earning a replay score
Dim OptBallSaverTime					' Ball Saver time (in seconds)
Dim OptMBBallSaverTime					' Multiball Ball Saver Time (in seconds)
Dim OptTiltSens							' Tilt Sensitivity Option
Dim OptGameMusic						' Toggles the game music on/off
Dim OptDebugMode						' Toggles Debug Mode on/off
Dim OptClearStats						' Clear game statistics
Dim OptResetHighScore					' Resets High Score to the Default High Score
Dim OptOptionsToDefault					' Resets all options to default values
Dim OptHStoHighestScore					' Sets the Table High Score to the highest score attained (StatHighestScore)
Dim OptTournament						' Indicates the game is in Tournament Mode (Option 20)
										' Extra Balls and Specials score 100,000 points (field multiplier applies) instead of awarding an extra ball or special
										' No awards for replay scores or high scores
Dim OptMaxEBGame						' Maximum number of Extra Balls/Game
Dim OptMaxEBBIP							' Maximum number of Extra Balls/Ball-in-play
Dim OptBSDispOn							' Turns the ball save display on or off (Default is On)

' Game Variables

Dim Score(4)							' Player scores
Dim HighScore							' Highest score attained on the table
Dim GoalScore(4)						' Replay scores
Dim GoalScoreMade(4,4)					' Indicates whether a player has made a replay score
Dim L1State(4)
Dim L2State(4)
Dim L3State(4)
Dim L12State(4)
Dim L13State(4)
Dim Player								' Number of the current player
Dim Players								' Number of players in current game
Dim Credits								' Number of credits in machine
Dim BallInPlay							' Current number of the ball in play
Dim GameOver							' Indicates whether the game is over
Dim Drained								' Indicates we've drained
Dim Started								' Indicates we've started a game
Dim BallStarted							' Indicates we've started a ball
Dim BonusCounted						' Indicates whether we've counted the end-of-ball bonus
Dim Bonus								' End of ball bonus x 1000
Dim HoldBonus							' Stored bonus value
Dim BonusMultiplier(4)					' Current Bonus Multiplier. Defined as an array in case we need to track multipliers for each player
Dim FieldMultiplier						' Current Field Multiplier. Most table scoring is multiplied by this value
Dim PrevFieldMultiplier					' Stored previous field multiplier
Dim FldMultGenPlay						' This indicator tells the table how we got to the current Field Multiplier. This is Trus if we got it through general play and False if through multiball
Dim G45Down, EGXDown					' These indicators tell us if we've cleared the Goteki 45 or EG-X drop targets once in the current ball-in-play
Dim GotekiEGXCount						' This tells how mny times both the Goteki 45 and EG-X drop targets have been cleared in the same Ball-in-play
Dim SpecialLit(4)						' indicates "special when lit"
Dim RampLit(4)							' Indicates that the ramp is lit
Dim JackpotLit							' Indicates jackpot is lit
Dim x,y,x1,y1,z1,mv,z2,hs				' general use variables
Dim GameMode							' Current game mode.
										' 0 = Game Over
										' 1 = General Play
										' 2 = Multiball
Dim FreePlay							' Indicates whether Free Play mode is on
Dim TableState							' Current State of the table
										' -1 = Start-up
										'  0 = Normal Operation
										'  1 = Debug Mode
										'  2 = Operator Mode
Dim HandicapExBall(4)					' Indicated whether we've given a "handicap" extra ball during the game
Dim LockingBall							' Indicates we're locking a ball in the Piranha Lock
Dim ComboCount							' Counter for ramp shots during a combo
Dim SkillShotsMade(4)					' Number of skill shots made this game
Dim SkillShotActive						' Indicates whether the skill shot is active
Dim SkillShotWon						' Indicates whether we've won the skill shot
Dim L6PrevState
Dim L7PrevState
Dim L8PrevState
Dim L9PrevState

' Zone Variables

Dim Zone(4)								' Player's current Zone
Dim ZoneName(4)							' Name of player's current Zone
DIm ZoneForce(4)						' Stores the bumper force values per player
Dim ZoneVelMultiplier(4)				' Player's current velocity multiplier. This starts at 1 and increases by the constant ZoneVelIncr with each Zone
Dim LeftAdv2ZonesLit, RightAdv2ZonesLit	' These indicators mean that the ramp's 2-Zones light is lit if set to True



' Multiball Variables

Dim BallCount							' Number of balls currently on table
Dim BallsLocked(4)						' Number of Balls locked
Dim BallsToRelease(1)					' When we start multiball, this tells the table how many balls to release
Dim NextLock(4)							' Indicates the number of the next lock. This will be 0 if no locks are lit
Dim MBThisGame(4)						' Number of multiballs started this game
Dim LocksLit(4)							' Indicates the locks are lit
Dim Lock1Ready(4)						' Indicates Lock 1 is ready
Dim Lock2Ready(4)						' Indicates Lock 2 is ready
Dim Lock3Ready(4)						' Indicates Lock 3 is ready
Dim BattleZone(4)						' Current Battle Zone (0.1 to 20.0)
Dim BattleZoneInt						' Integer part of the Battle Zone (for display purposes)
Dim BattleZoneDec						' Decimal part of the Battle Zone (for display purposes)
Dim BZoneAccum							' Total of all Battle Zone accumulations during the current multiball. Used in calculating the Zone Boost Jackpot
Dim HitsToClearBarrier					' Number of hits to clear the current Barrier
Dim BarriersCleared						' Number of Barriers cleared this multiball
Dim TargetsHit							' Number of targets hit in the current multiball. 5 targets hit = +0.1 Battle Zone
Dim ZoneBoostJackpots(4)				' Number of Zone Boost Jackpots in the current game. Used to determine if we get the Mirage sponsor
Dim JackpotsThisMB(4)						' Number of Zone Battle jackpots this multiball
Dim ZoneBoostReady(1)					' These indicate whether a ramp is ready for the Zone Boost Jackpot
										' (0) = Left Ramp lit for Zone Boost if true
										' (1) = Right Ramp lit for Zone Boost if true
' Extra-Ball Variables

Dim ExtraBallLit(4)						' indicates whether the extra-ball shot is lit
Dim ExtraBalls							' Number of extra balls to play
Dim ExtraBallsGame(4)					' Number of extra balls earned this game
Dim ExtraBallsBIP(4)					' Number of extra balls earned this Ball-in-Play

' Sponsor Variables - These are indicators that indicate the player has earned the sponsors

Dim FeisarWon(4)							' We've won the Feisar sponsor this game
Dim EGXWon(4)								' We've won the EG-X Sponsor this game
Dim Goteki45Won(4)							' We've won the Goteki 45 sponsor this game
Dim PiranhaWon(4)							' We've won the Piranha sponsor this game
Dim HarimauWon(4)							' We've won the Harimau sponsor this game
Dim TriakisWon(4)							' We've won the Triakis sponsor this game
Dim QirexWon(4)								' We've won the Qirex sponsor this game
Dim AuricomWon(4)							' We've won the Auricom sponsor this game
Dim IcarasWon(4)							' We've won the Icaras sponsor this game
Dim AssegaiWon(4)							' We've won the Assegai sponsor this game
Dim AGSysWon(4)								' We've won the AG-Systems sponsor this game
Dim MirageWon(4)							' We've won the Mirage sponsor this game
Dim SponsorsWon(4)							' Number of sponsors won this game
Dim TotalBumperHits(4)						' Total number of bumper hits this game - used to determine if we are going to award the Harimau sponsor
Dim BumperHitsBall							' Number of bumper hits this ball
Dim QirexCount(4)							' Number of Qirex target hits


' Statistics variables - Statistics variables are preceded with "Stat"

Dim StatGamesPlayed						' Total Games Played
Dim StatTotalPoints						' Total Points Scored for all games
Dim StatHighestScore					' Highest score attained (not necessarily the table high score)
Dim StatBallsPlayed						' Total number of balls played (including extra balls earned)
Dim StatExtraBalls						' Total number of extra balls won
Dim StatXBallPct						' Percentage of extra balls won to number of games played
Dim StatAvgScore						' Average score per game
Dim StatTotalReplays					' Total number of replays won
Dim StatReplayPct						' Percentage of replays to number of games played
Dim StatMatchReplays					' Total number of replays won via match
Dim StatMatchPct						' Percentage of match replays to number of games played	
Dim StatHighestZone						' Highest Zone attained in normal Player
Dim StatHighBatZone						' Highest Battle Zone attained in Zone Battle Multiball
Dim StatHighBatZoneWon					' Highest Zone Boost won in Zone Battle Multiball
Dim StatZoneBattleMultiballs			' Number of multiballs played
Dim StatZoneBoostJackpots				' Number of Zone Boost Jackpots won
Dim StatJackpotPct						' Percentage of Heat Jackpots won vs. games played
Dim StatTotalZones						' Total Zones attained across all games
Dim StatAvgZoneGame						' Average Zone Attained/Game
Dim StatTimePlayedGame					' Total play time for full games in seconds
Dim StatTimePlayedBall					' Total play time for each ball in seconds
Dim StatAvgTimePlayedGame				' Average play time per game in seconds
Dim StatAvgTimePlayedBall				' Average play time per ball in seconds
Dim StatHistSub100K						' Histogram: Number of games with scores of < 100,000
Dim StatHist100K_249K					' Histogram: Number of games with scores of 100,000-249,999
Dim StatHist250K_499K					' Histogram: Number of games with scores of 250,000-499,999
Dim StatHist500K_999K					' Histogram: Number of games with scores of 500,000-999,999
Dim StatHist1M_1_4M						' Histogram: Number of games with scores of 1,000,000-1,499,999
Dim StatHist1_5M_1_9M					' Histogram: Number of games with scores of 1,500,000-1,999,999
Dim StatHist2MAndUp						' Histogram: Number of games with scores of 2,000,000 and Up
Dim StatHistSub100KPct					' Histogram: Number of games with scores of < 100,000
Dim StatHist100K_249KPct				' Histogram: Number of games with scores of 100,000-249,999
Dim StatHist250K_499KPct				' Histogram: Number of games with scores of 250,000-499,999
Dim StatHist500K_999KPct				' Histogram: Number of games with scores of 500,000-999,999
Dim StatHist1M_1_4MPct					' Histogram: Number of games with scores of 1,000,000-1,499,999
Dim StatHist1_5M_1_9MPct				' Histogram: Number of games with scores of 1,500,000-1,999,999
Dim StatHist2MAndUpPct					' Histogram: Number of games with scores of 2,000,000 and Up
Dim TimeInBall(4)						' Play time for the current ball
Dim TimeInGame(4)						' Total Play time for the game
Dim GameClockPulse(4)					' time counter for the current GameMode
Dim BallClockPulse(4)					' time counter for the current ball

' Variables for the score display system

Dim CreditDisplay(2)					' Credit Display Display
Dim BallDisplay(2)						' Ball/Match Display
Dim ScoreDisplay(3,6)					' Game-Score Displays

' Tilt-mechanism veriables

Dim Tilt								' Indicator showing whether or not we've tilted
Dim TiltSwing							' Current status of the tilt bob
Dim OldTilt								' Previous tilt direction
Dim NewTIlt								' New tilt direction
Dim TiltWarned							' Indicates whether we've gotten a tilt warning this ball

' A-B-C-D Rollover Lights Flipper Control

Dim ABCDTrig								' For rollover lanes
Dim TempState,TempState2					' Temporary Variables
Dim ABCDCount(4)							' Count of the number of different A-B-C rollovers hit
Dim ALit(4)									' Indicators by player for which of the ABCD lights should be lit
Dim BLit(4)
Dim CLit(4)
Dim DLit(4)									
Dim TempABCState							' Placeholder for an ABC rollover light state (for lane changes)

' Inlane/Outlane Lights Flipper Control

Dim FeisarTrig								' For In/Outlanes
Dim TempState3,TempState4					' Temporary Variables

' VP version check. Recommended 10.7.2 or higher, should work on 10.7.x

If Version < 10702 Then
	MsgBox "Warning! VP version 10.7.2 or higher recommended,"& vbNewLine & "this table may not work properly.",vbExclamation, VBOKOnly
End If

' ********************************** B2S Setup ***************************************

' Load the scripts needed to run the B2S backglass
' The file VP is looking for should be in the VP scripts folder (Controller.vbs).
' This has B2S controller functionality as well as DOF functionality. 


On Error Resume Next
ExecuteGlobal GetTextFile("Controller.vbs")
If Err Then MsgBox "Unable to open Controller.vbs. This is needed in order to run the table. It is available in the VP10 package."
On Error Goto 0

'This function will take an input digit and return a value that B2S can use to determine which segments in the B2S LED displays to light
'
'
' The idea came about due to the properties I found with the LED display system in B2S. The LED display segments in B2S are arranged like this.
'
'    1
'  -----
' |     |
'6|  7  |2
' |-----|
' |     |
'5|     |3
'  -----   . 8 (separator)
'    4
'
' The values you have to pass to the B2SSetCredits methods are not the values you want to display, they represent the individual segments that B2S will light up. 
' The way B2S interprets the values in relation to the segments is like this (display number "7" as an example:
'
'          Segments
' 1   2   3   4   5   6   7   8
'
' 1   1   1   0   0   0   0   0
'
' 1   2   4   8   1   3   6   1
'                 6   2   4   2
'                             8
'
' B2S interprets the bit values of the segments from left-to-right, so segments 1, 2, and 3 are on for the number 7
' 1 + 2 + 4 = 7
' So if we pass the value of 7 to the B2S SetCredit method, it turns on segments 1, 2, and 3 on the B2S element and displays the number 7

Function SegValueB2S(ByVal Digit)

	Select Case Digit
	Case 0
		SegValueB2S = 63					' Segments 1, 2, 3, 4, 5, 6 
	Case 1
		SegValueB2S = 6						' Segments 2, 3
	Case 2
		SegValueB2S = 91					' Segments 1, 2, 4, 5, 7
	Case 3
		SegValueB2S = 79					' Segments 1, 2, 3, 4, 7
	Case 4
		SegValueB2S = 102					' Segments 2, 3, 6, 7
	Case 5
		SegValueB2S = 109					' Segments 1, 3, 4, 6, 7
	Case 6
		SegValueB2S = 125					' Segments 2, 3, 4, 5, 6, 7
	Case 7									
		SegValueB2S = 7						' Segments 1, 2, 3
	Case 8
		SegValueB2S = 127					' Segments 1, 2, 3, 4, 5, 6, 7				' 
	Case 9
		SegValueB2S = 111					' Segments 1, 2, 3, 4, 6, 7
	Case Else
		SegValueB2S = 0						' All segments Off
	End Select

End Function

'**************************************************************************************
' Reel-Based Score Display Section
'*************************************************************************************

' Set up the display reels

' Ball and Credit displays
 
Set CreditDisplay(0) = CRD1
Set CreditDisplay(1) = CRD2
Set BallDisplay(0) = BAD1
Set BallDisplay(1) = BAD2

' Player 1 Game Score
 
Set ScoreDisplay(0,0) = P1D7
Set ScoreDisplay(0,1) = P1D6
Set ScoreDisplay(0,2) = P1D5
Set ScoreDisplay(0,3) = P1D4
Set ScoreDisplay(0,4) = P1D3
Set ScoreDisplay(0,5) = P1D2
Set ScoreDisplay(0,6) = P1D1

' Player 2 Game Score
 
Set ScoreDisplay(1,0) = P2D7
Set ScoreDisplay(1,1) = P2D6
Set ScoreDisplay(1,2) = P2D5
Set ScoreDisplay(1,3) = P2D4
Set ScoreDisplay(1,4) = P2D3
Set ScoreDisplay(1,5) = P2D2
Set ScoreDisplay(1,6) = P2D1

' Player 3 Game Score
 
Set ScoreDisplay(2,0) = P3D7
Set ScoreDisplay(2,1) = P3D6
Set ScoreDisplay(2,2) = P3D5
Set ScoreDisplay(2,3) = P3D4
Set ScoreDisplay(2,4) = P3D3
Set ScoreDisplay(2,5) = P3D2
Set ScoreDisplay(2,6) = P3D1

' Player 4 Game Score
 
Set ScoreDisplay(3,0) = P4D7
Set ScoreDisplay(3,1) = P4D6
Set ScoreDisplay(3,2) = P4D5
Set ScoreDisplay(3,3) = P4D4
Set ScoreDisplay(3,4) = P4D3
Set ScoreDisplay(3,5) = P4D2
Set ScoreDisplay(3,6) = P4D1

' Display routines. These handle the updates to the displays.

Sub UpdateBall(bl)

Dim Digit

	Digit = Mid(bl,1,1)
	UpdateDisplay "Ball",1, Digit+1
	If B2SOn then 
		Controller.B2SSetCredits 31,0 
		Controller.B2SSetCredits 32,SegValueB2S(bl)
	End If
End Sub

Sub UpdateMatch(bl)

Dim Digit
Dim i, Bl0

	If bl < 10 Then
		Bl0 = "0" & bl
	Else
		bl0 = bl
	End If
	For i = 2 to 1 Step -1
		Digit = Mid(bl0,i,1)
		UpdateDisplay "Match",3-i,Digit+1
	Next

	If B2SOn Then
		Controller.B2SSetCredits 31,SegValueB2S(-1)
		Controller.B2SSetCredits 32,SegValueB2S(-1)
		If bl = 0 Then	
			Controller.B2SSetCredits 31,63
			Controller.B2SSetCredits 32,63
		Else
			Controller.B2SSetCredits 31,SegValueB2S(bl \ 10)
			Controller.B2SSetCredits 32,SegValueB2S(bl Mod 10)
		End If
	End If

End Sub
 
 ' This function handles updates for updating the credit display

Sub UpdateCredit(cr)

Dim i,Digit,Cr0

	If cr < 10 Then
		Cr0 = "0" & cr
	Else
		Cr0 = cr
	End If
	For i = 2 to 1 Step -1
		Digit = Mid(Cr0,i,1)
		UpdateDisplay "Credit",3-i,Digit+1
	Next

	If B2SOn Then
		Controller.B2SSetCredits 29,SegValueB2S(-1)
		Controller.B2SSetCredits 30,SegValueB2S(-1)
		If cr < 10 Then	
			Controller.B2SSetCredits 29,63
			Controller.B2SSetCredits 30,SegValueB2S(cr)
		Else
			Controller.B2SSetCredits 29,SegValueB2S(cr \ 10)
			Controller.B2SSetCredits 30,SegValueB2S(cr Mod 10)
		End If
	End If

End Sub

' This zeroes out the player's score

Sub ZeroScore(p)

	Score(p) = 0
	UpdateScore("00")

End Sub 

Sub UpdateScore(ByVal sc)

' Input Parameters
'
' sc		: Input Score
'
' Local Variables
'
' i			: Counter
' Length	: Length of player score
' Digit		: Position of the next digit to be updated
 
Dim i
Dim Length
Dim Digit

' First we see if the length of the display is more than 7 digits. If it is, we'll truncate the input score and
' use the rightmost seven digits (if this should happen the table will still keep track of the actual score internally,
' but the display will roll over starting at 0,000,000
 
	If Len(sc) > cScoreLength then
		Length = cScoreLength
		sc = Right(sc,cScoreLength)
	ElseIf sc < 10 then
		Length = 2
		sc = "0" & sc
	Else
		Length = Len(sc)
	End If
 
' Now we'll step through the score and call the UpdateDisplay sub to update each digit to the display one at a time
 
	For i = Length to 1 Step -1
		Digit = Mid(sc,i,1)
		UpdateDisplay "Score", (Length+1) - i, Digit+1
	Next
 
	If B2SOn then 
		If sc <> 0 then 
			Controller.B2SSetScore Player,sc
			Select Case Length
			Case 4
				Digit = Mid(sc,1,1)
				Controller.B2SSetCredits (7*(Player-1)+4),128+SegValueB2S(Digit)
			Case 5
				Digit = Mid(sc,2,1)
				Controller.B2SSetCredits (7*(Player-1)+4),128+SegValueB2S(Digit)
			Case 6
				Digit = Mid(sc,3,1)
				Controller.B2SSetCredits (7*(Player-1)+4),128+SegValueB2S(Digit)
			Case 7
				Digit = Mid(sc,4,1)
				Controller.B2SSetCredits (7*(Player-1)+4),128+SegValueB2S(Digit)
				Digit = Mid(sc,1,1)
				Controller.B2SSetCredits (7*(Player-1)+1),128+SegValueB2S(Digit)
			End Select
		Else
			Controller.B2SSetCredits ((7*(Player-1))+6),SegValueB2S(0)
 			Controller.B2SSetCredits ((7*(Player-1))+7),SegValueB2S(0)
		End If
	End If

End Sub
 
' Sub UpdateDisplay
' This routine sets the displays to the correct settings.
'
' Global Variables Used:
'
' Player	: Current player in the game. Only used if we're updating a score
'
' Input Parameters:
'
' Display	: Selects the display we're updating/showing
' Digit  	: Position of the updated digit in the display
' Num		: New value to be displayed
 
 Sub UpdateDisplay (Display,Digit,Num)
 
 	Select Case Display
 	Case "Score"
 		ScoreDisplay(Player-1,Digit-1).SetValue Num
 	Case "Match"
 		BallDisplay(Digit-1).SetValue Num
 	Case "Ball"
  		BallDisplay(Digit).SetValue 0
  		BallDisplay(Digit-1).SetValue Num
  	Case "Credit"
 		CreditDisplay(Digit-1).SetValue Num
	End Select

 End Sub

' Sub ScoreDisplayOff
' Turns off all four player score displays

 Sub ScoreDisplayOff()

	For x = 0 to 3
 		For y = 0 to 6
			ScoreDisplay(x,y).SetValue 0
			If B2SOn Then Controller.B2SSetCredits ((7*x)+(y+1)),0
		Next
	Next
 
End Sub

' Sub PlayerDisplayOff
' Turns off the score display for the current player

Sub PlayerDisplayOff()

	For y = 0 to 6
		ScoreDisplay(Player-1,y).SetValue 0
		If B2SOn Then Controller.B2SSetCredits (7*(Player-1)+(y+1)),0
	Next
 
End Sub

'This turns off the Ball/Match displays

Sub BallMatchDisplayOff()

	BallDisplay(0).SetValue 0
	BallDisplay(1).SetValue 0
'	BIPText.Text = ""
	BIPReel.SetValue 1
 	If B2SOn then 
		Controller.B2SSetCredits 31,0
 		Controller.B2SSetCredits 32,0
		COntroller.B2SSetBallInPlay 32,0
	End If

End Sub

'This turns off the Credit display

Sub CredDisplayOff()

	CreditDisplay(0).SetValue 0
 	CreditDisplay(1).SetValue 0
	If B2SOn then 
		Controller.B2SSetCredits 29,0
 		Controller.B2SSetCredits 30,0
	End If
End Sub

Sub ScoreDisplaysOn()

 Dim CurrPlayer
 
 	CurrPlayer = Player									' Store the actual player number away
	For Player = 1 to Players
		If Score(player) = 0 then						' Turn the scores back on
			ZeroScore player
		Else
			UpdateScore Score(player)
		End If
	Next
 	Player = CurrPlayer									' Restore the proper player number
 	UpdateCredit Credits
	UpdateBall BallInPlay
'	BIPText.Text = "BALL IN PLAY"
	BIPReel.SetValue 0
	If B2SOn then Controller.B2SSetBallInPlay 32,1

End Sub

' This sub controls the flash effect of the current player's score at the start of a ball
 
Sub ScoreFlashTimer_Timer()
 
 	z2=(z2+1) Mod 2
 	Select Case z2
 	Case 0
 		PlayerDisplayOff()
 	Case 1
 		AddScore 0,True
 	End Select
 
 End Sub

' These subs handle the score display when there has been no scoring for a couple of seconds
' The time required before the display starts wiping out/in is controlled by the timer interval of the timer
' named BoredomTimer in the backdrop area (currently it is set to 3000).
 
 ' Variables for the counters used in this functionality
 
Dim SwipeCount									' This is a counter to comtrol the step the swipe timer is to execute
Dim B2SSwipeCount								' Counter which counts the opposite to control the digit to update in ther B2S backglass displays
Dim ScoreDigit(6)								' This array contains up to 7 digits of the player's score
Dim SwipeOut									' Set to True if we're swiping out, False if we're swiping in

' Sub BoredomTimer_Timer(): This sub is invoked when there has been no scoring and it activates the wipe in/out
' timer. The sub also collects the digits of the player's score for use in the swiping functionality
 
Sub BoredomTimer_Timer()
 
Dim i
Dim Length
Dim sc
 	
 	If Len(Score(player)) > cScoreLength then
		Length = cScoreLength
		sc = Right(score(player),cScoreLength)
	Else
 		If Score(player) = 0 then
 			Length = 2
 			sc = "00"
 		Else
			Length = Len(score(player))
			sc = Score(player)
 		End If
	End If
 
	For i = Length to 1 Step -1
		ScoreDigit(Length-i) = Mid(sc,i,1)				' Get the matching digits of the player's score
	Next
 
 	BoredomTimer.Enabled = False						' Turn off the Boredom Timer
	B2SSwipeCount = 0
 	SwipeCount = Length									' Set the swipe count to 0
	SwipeOut = True										' We're swiping out, so set this to tell the timer sub we're swiping out
 	SwipeTimer.Enabled = True							' Turn on the swipe timer
 
End Sub

Sub SwipeTimer_Timer()

Dim Length

	If Len(Score(Player)) > cScoreLength Then
		Length = cScoreLength
	Else
		Length = Len(score(player))
	End If
	SwipeCount = SwipeCount - 1
	B2SSwipeCount = B2SSwipeCount + 1
	If SwipeOut then
		If SwipeCount >= 0 then
			ScoreDisplay(Player-1,SwipeCount).SetValue 0
			If B2SOn Then Controller.B2SSetCredits 7*(Player-1)+(cScoreLength-(Length-B2SSwipeCount)),0
		Else
			If SwipeCount <= -2 then
				SwipeCount = Length 										' We're done. Reset the swipe counter
				B2SSwipeCount = 0
				SwipeOut = False											' and tell the timer sub we're swiping back in
			End If
		End If
	Else
		If SwipeCount >= 0 then
			ScoreDisplay(Player-1,SwipeCount).SetValue ScoreDigit(SwipeCount)+1
			If B2SOn Then 
				If (SwipeCount = 6 and B2SSwipeCount = 1) then Controller.B2SSetCredits 7*(Player-1)+B2SSwipeCount,128+SegValueB2S(ScoreDigit(SwipeCount))
				If (Length-B2SSwipeCount) <> 3 Then
					If not (SwipeCount = 6 and B2SSwipeCount = 1) then Controller.B2SSetCredits 7*(Player-1)+(cScoreLength-(Length-B2SSwipeCount)),SegValueB2S(ScoreDigit(SwipeCount))
				Else
					Controller.B2SSetCredits 7*(Player-1)+(cScoreLength-(Length-B2SSwipeCount)),128+SegValueB2S(ScoreDigit(SwipeCount))
				End If
			End If
		Else
			If SwipeCount <= -8 then
				SwipeCount = Length											' We're done. Reset the swipe counter
				B2SSwipeCount = 0
				SwipeOut = True												' and tell the timer sub we're swiping back out
			End If
		End If
	End If

End Sub

' ***************************************************************************************
' Initialization Section
' ***************************************************************************************

Sub ZoneFury_Init()

Dim objekt,Zed

	LoadEM
	If not ZoneFury.ShowDT then
		For Each objekt in CollDisplayDigits
			objekt.Visible = False
		Next
		For Each objekt in CollBackglassLights
			objekt.Visible = False
		Next
	Else
		For Each objekt in CollDisplayDigits
			objekt.Visible = True
		Next
		For Each objekt in CollBackglassLights
			objekt.Visible = True
		Next
	End If
	For Zed = 1 to cMaxPlayers
		Score(Zed) = 0
		GoalScoreMade(Zed,1) = False
		GoalScoreMade(Zed,2) = False
		GoalScoreMade(Zed,3) = False
		GoalScoreMade(Zed,4) = False
		BonusMultiplier(Zed) = 0
		LocksLit(Zed) = False
		SpecialLit(Zed) = False
		ExtraBallLit(Zed) = 0
		ExtraBallsGame(Zed) = 0
		ExtraBallsBIP(Zed) = 0
		RampLit(Zed) = False
		L1State(Zed) = 0
		L2State(Zed) = 0
		L3State(Zed) = 0
		L12State(Zed) = 0
		L13State(Zed) = 0
		QirexCount(Zed) = 0
		TotalBumperHits(Zed) = 0
		SkillShotsMade(Zed) = 0
	Next
	BarrierLeft.IsDropped = 1: BarrierRight.IsDropped = 1
	ClearStatistics()
	OptionsToDefault()									' set the options to default values before attempting to load them
	LoadHS()
	GameOver = True
	GameOverReel.SetValue 0
	MatchReel.SetValue 1
	BIPReel.SetValue 1
	HSReel.SetValue 1
	TiltReel.SetValue 1
	If B2SOn Then
		Controller.B2SSetCredits 29, SegValueB2S(Credits \ 10)
 		Controller.B2SSetCredits 30,SegValueB2S(Credits Mod 10)
		Controller.B2SSetCredits 31, SegValueB2S(0)
		Controller.B2SSetCredits 32, SegValueB2S(0)
		Controller.B2SSetGameOver 35,1								' Game over light on
		Controller.B2SSetBallInPlay 32,0
		Controller.B2SSetData 25,0
		Controller.B2SSetMatch 34,0
		Controller.B2SSetTilt 33,0
	End If
	TableState = 0
	ExtraBalls = 0
	Player = 0
	Players = 0
	BallInPlay = 0
	UpdateCredit Credits
	UpdateMatch "00"
	z2 = 0
	x1 = 0	
	StartAttractMode()									' Start the attract mode	
	PlaySound"Zone Transition"
	If OptGameMusic <> 0 then PlaySound"vpzonefuryintro"
	MusicTrack = 0
	LoadLUT

End Sub

' ***************************************************************************************
' Key-Up/Key-Down
' ***************************************************************************************


Sub ZoneFury_KeyDown(ByVal keycode)

Dim oFlipper

 	If Keycode = 64 and GameOver and TableState <> 2 and TableState <> -1 then
		PlaySound"OpMenuStart"
		GoOptions()											' F6 = Option Mode
	End If

	If Keycode = 60 and TableState <> -1 then
		GoHelp()										 	' F2 = Help
	End If

	If keycode = PlungerKey Then
		Plunger.PullBack
		PlaySound "plungerpull",0,1,0.25,0.25
	End If
	
	Select Case TableState
	Case -1									' Table boot-up
	' Table is booting up - disable keys
	Case 0,1								' Normal and Debug states
		If keycode = LeftFlipperKey Then
			If not GameOver and not Tilt then
				For Each oFlipper in collLeftFlipper
					oFlipper.EOSTOrque = 0.75
					oFlipper.RotateToEnd
				Next				
				PlaySound SoundFXDOF("fx_flipperup", 101, DOFOn, DOFFlippers), 0, .67, -0.05, 0.05
				ShiftABCDLeft()
				ShiftInOutLeft()
				If SelectingMusic then
					Select Case GameMode
					Case 1
						StopAllMusic
						MusicTrack = MusicTrack - 1
						Select Case OptGameMusic
						Case 3
							If MusicTrack < 1 then MusicTrack = 6
							ZoneFuryMusicChoice()
						Case 4
							If MusicTrack < 1 then MusicTrack = 8
							ZoneFuryMusicChoiceAll()
						End Select
					Case 2
						MusicTrack = MusicTrack - 1
						If MusicTrack < 1 then MusicTrack = 8
						DisplayTrack
					End Select
				End If
			End If
		End If
		
		If keycode = RightFlipperKey Then
			If not GameOver and not Tilt then
				For Each oFlipper in collRightFlipper
					oFlipper.EOSTOrque = 0.75
					oFlipper.RotateToEnd
				Next		
				PlaySound SoundFXDOF("fx_flipperup", 102, DOFOn, DOFFlippers), 0, .67, 0.05, 0.05
				ShiftABCDRight()
				ShiftInOutRight()
				If SelectingMusic then
					Select Case GameMode
					Case 1
						StopAllMusic
						MusicTrack = MusicTrack + 1
						Select Case OptGameMusic
						Case 3
							If MusicTrack > 6 then MusicTrack = 1
							ZoneFuryMusicChoice()
						Case 4
							If MusicTrack > 8 then MusicTrack = 1
							ZoneFuryMusicChoiceAll()
						End Select
					Case 2
						MusicTrack = MusicTrack + 1
						If MusicTrack > 8 then MusicTrack = 1
						DisplayTrack
					End Select
				End If
			End If
		End If
		
		If keycode = LeftTiltKey Then
			Nudge 90,5
			If not GameOver then
				NewTilt = 1
				TiltCheck()
			End If
		End If
    
		If keycode = RightTiltKey Then
			Nudge 270,5
			If not GameOver then
				NewTilt = 2
				TiltCheck()
			End If
		End If
    
		If keycode = CenterTiltKey Then
			Nudge 0,6
			If not GameOver then
				NewTilt = 3
				TiltCheck()
			End If
		End If

		If keycode = AddCreditKey Then
			PlaySound"Coin3"
			CoinTimer.Enabled = True		
		End If

		If KeyCode = StartGameKey then								'Start-Game key
			If (Credits > 0 or FreePlay) and not Started then
				StartGame()
			Else
				PlaySound "No Credits Beep"
			End If
		End If
    
		If keycode = 31 and GameOver then							' S-Key
			DisplayStatistics()
		End If

		If keycode = LeftMagnaSave Then bLutActive = True

		If keycode = RightMagnaSave Then
			If bLutActive Then NextLUT
		End If

	Case 2									' Operator State
	
		Select Case Keycode
 		Case 8											' 7-Key - Escape/Abort
			PlaySound"OpMenuEsc"
			OptionLevel = OptionLevel - 1
  			If OptionLevel < 1 then 
 				ScoreDisplayOff()
				UpdateOptions()
 				BallMatchDisplayOff()
 				CredDisplayOff()
				If ZoneFury.ShowDT Then
					CredText1.Text = "Restarting Table"
					CredText2.Text = "VPX L-" & cVersion & " VPX L-" & Version
				Else
					CredText1FS.Text = "Restarting Table"
					CredText2FS.Text = "VPX L-" & cVersion & " VPX L-" & Version
				End If
 				ExitOptionsTimer.Enabled = True
  				Player = 0
			Else
 				DisplayOption()
 			End If
 		Case 9											' 8-Key - Previous Option/Value
			PlaySound"OpMenuPrev"
			Select Case OptionLevel
 			Case 1										
 				CurrentOpt = CurrentOpt - 1
				If CurrentOpt < 1 then CurrentOpt = MaxOptions
				DisplayOption()
			Case 2
 				Select Case CurrentOpt
 				Case 1											' Option 1 - Balls Per Game (1-9)	
 					WorkOption = WorkOption - 1
 					If WorkOption < 1 then WorkOption = 9
					BallMatchDisplayOff()
					UpdateBall WorkOption
 				Case 2											' Option 2 - Replay Score Level 1
 					WorkOption = WorkOption - 100000
 					If WorkOption < 0 then WorkOption = 9900000
 					Player = 3
					PlayerDisplayOff
 					UpdateScore WorkOption
 				Case 3											' Option 3 - Replay Score Level 2
 					If OptGoalScore(1) <> 0 then
						WorkOption = WorkOption - 100000
						If WorkOption < OptGoalScore(1) and WorkOption > 0 then WorkOption = 0
						If WorkOption < 0 then WorkOption = 9900000
						Player = 3
						PlayerDisplayOff
						UpdateScore WorkOption
 					End If
 				Case 4											' Option 4 - Replay Score Level 3
 					If OptGoalScore(2) <> 0 then
						WorkOption = WorkOption - 100000
						If WorkOption < OptGoalScore(2) and WorkOption > 0 then WorkOption = 0
						If WorkOption < 0 then WorkOption = 9900000
						Player = 3
						PlayerDisplayOff
						UpdateScore WorkOption
 					End If
				Case 5											' Option 5 - Replay Score Level 4
 					If OptGoalScore(3) <> 0 then
						WorkOption = WorkOption - 100000
						If WorkOption < OptGoalScore(3) and WorkOption > 0 then WorkOption = 0
						If WorkOption < 0 then WorkOption = 9900000
						Player = 3
						PlayerDisplayOff
						UpdateScore WorkOption
 					End If 
 				Case 6											' Option 6 - MAx Credits
 					WorkOption = WorkOption - 1
 					If WorkOption < 0 then WorkOption = 99
					BallMatchDisplayOff()
					UpdateMatch WorkOption
 				Case 7											' Option 7 - Default High Score
 					WorkOption = WorkOption - 1000000
 					If WorkOption < 1000000 then WorkOption = 9000000
 					Player = 3
					PlayerDisplayOff
 					UpdateScore WorkOption
 				Case 8											' Option 8 - Number of credits for a replay
  					WorkOption = WorkOption - 1
 					If OptReplayAward <> 2 then
						If WorkOption < 0 then WorkOption = 3
 					Else
 						If WorkOption < 0 then WorkOption = 1
 					End If
					BallMatchDisplayOff()
					UpdateBall WorkOption
 				Case 9											' Option 9 - Replay Score Award (Credit or Extra Ball) 
 					WorkOption = WorkOption - 1
 					If WorkOption < 0 then WorkOption = 2
 					CredText1.Text = "New Value "
 					Select Case WorkOption
 					Case 0
 						CredText1.Text = CredText1.Text & "(0=Off)"
					Case 1
 						CredText1.Text = CredText1.Text & "(1=Credit)"
					Case 2
 						CredText1.Text = CredText1.Text & "(2=Extra Ball)"
 					End Select
 					BallMatchDisplayOff()
					UpdateBall WorkOption
				Case 10											' Option 10 - Nunber of high score credits
  					WorkOption = WorkOption - 1
 					If WorkOption < 0 then WorkOption = 9
					BallMatchDisplayOff()
					UpdateBall WorkOption
 				Case 11,12										' Option 11 - BallSaver Time. Option 12 - Multiball BallSaver time
  					WorkOption = WorkOption - 1
 					If WorkOption < 0 then WorkOption = 30
'					If WorkOption < 10 then WorkOption = 0
 					BallMatchDisplayOff()
					UpdateMatch WorkOption
   				Case 13											' Option 13 - Tilt Sensitivity (0-2.000)
 					WorkOption = WorkOption - 0.250
 					If WorkOption < 0 then 
 						WorkOption = 2.000
 					Else
 						If WorkOption < 0.250 then WorkOption = 0
 					End If
					Player = 3
					PlayerDisplayOff
 					UpdateScore WorkOption*1000
				Case 14											' Option 14 - Game Music"
					WorkOption = WorkOption - 1
					If WorkOption < 0 then WorkOption = 4
					Select Case WorkOption
					Case 0
						CredText1.Text = "0 = All Music Off"
					Case 1
						CredText1.Text = "1 = Random Default"
					Case 2
						CredText1.Text = "2 = Random Per Ball"
					Case 3
						CredText1.Text = "3 = Player Choice Default"
					Case 4
						CredText1.Text = "4 = Player Choice All"
					End Select
 					BallMatchDisplayOff()
					UpdateBall WorkOption
 				Case 15,16,17,18,19,20,23						' Option 15 - Debug Mode, Option 16 - Clear Stats, Option 17 - Reset High Score, Option 18 - Options to Default, Option 19 - Set the High Score to the highest attained, Option 20 - Tournament Mode
 					If WorkOption = 0 then
 						WorkOption = 1
 					Else
 						Workoption = 0
 					End If
 					BallMatchDisplayOff()
					UpdateBall WorkOption
				Case 21												' Option 21 - Max Extra Balls/Game
 					WorkOption = WorkOption - 1
 					If WorkOption < 0 then WorkOption = 9
					BallMatchDisplayOff()
					UpdateBall WorkOption
				Case 22												' Option 22 - Max Extra Balls/B.I.P
 					WorkOption = WorkOption - 1
 					If WorkOption < 0 then WorkOption = 10
					BallMatchDisplayOff()
					If WorkOption < 10 then UpdateBall WorkOption
   				End Select
 			End Select
 		Case 10										'9-Key - Next Option
			PlaySound"OpMenuNext"
			Select Case OptionLevel
 			Case 1
 				CurrentOpt = CurrentOpt + 1
				If CurrentOpt > MaxOptions then CurrentOpt = 1
				DisplayOption()
 			Case 2
 				Select Case CurrentOpt
 				Case 1 ' Balls Per Game
 					WorkOption = WorkOption + 1
 					If WorkOption > 9 then WorkOption = 1
					BallMatchDisplayOff()
					UpdateBall WorkOption
 				Case 2	' Replay Score Level 1
					WorkOption = WorkOption + 100000
 					If WorkOption > 9900000 then WorkOption = 0
 					Player = 3
					PlayerDisplayOff()
 					UpdateScore WorkOption
 				Case 3
 					If OptGoalScore(1) <> 0 then
						WorkOption = WorkOption + 100000
						If WorkOption > 9900000 then WorkOption = 0
						If WorkOption < OptGoalScore(1) and WorkOption <> 0 then 
 							WorkOption = OptGoalScore(1) + 100000
 							If WorkOption > 9900000 then WorkOption = 0
						End If
						Player = 3
						PlayerDisplayOff
						UpdateScore WorkOption
 					End If
 				Case 4
					If OptGoalScore(2) <> 0 then
						WorkOption = WorkOption + 100000
						If WorkOption > 9900000 then WorkOption = 0
						If WorkOption < OptGoalScore(2) and WorkOption <> 0 then 
 							WorkOption = OptGoalScore(2) + 100000
 							If WorkOption > 9900000 then WorkOption = 0
 						End If
						Player = 3
						PlayerDisplayOff
						UpdateScore WorkOption
 					End If
 				Case 5
 					If OptGoalScore(3) <> 0 then
						WorkOption = WorkOption + 100000
						If WorkOption > 9900000 then WorkOption = 0
						If WorkOption < OptGoalScore(3) and WorkOption <> 0 then 
 							WorkOption = OptGoalScore(3) + 100000
							If WorkOption > 9900000 then WorkOption = 0
 						End If
						Player = 3
						PlayerDisplayOff
						UpdateScore WorkOption
 					End If
 				Case 6
 					WorkOption = WorkOption + 1
 					If WorkOption > 99 then WorkOption = 0
					BallMatchDisplayOff()
					UpdateMatch WorkOption
 				Case 7
					WorkOption = WorkOption + 1000000
 					If WorkOption > 99000000 then WorkOption = 1000000
 					Player = 3
					PlayerDisplayOff
 					UpdateScore WorkOption
 				Case 8
  					WorkOption = WorkOption + 1
 					If OptReplayAward <> 2 then
						If WorkOption > 3 then WorkOption = 0
 					Else
 						If WorkOption > 1 then WorkOption = 0
 					End If
					BallMatchDisplayOff()
					UpdateBall WorkOption
  				Case 9
 					WorkOption = WorkOption + 1
 					If WorkOption > 2 then WorkOption = 0
 					CredText1.Text = "New Value "
 					Select Case WorkOption
 					Case 0
 						CredText1.Text = CredText1.Text & "(0=Off)"
 					Case 1
 						CredText1.Text = CredText1.Text & "(1=Credit)"
 					Case 2
 						CredText1.Text = CredText1.Text & "(2=Extra Ball)"
 					End Select
 					BallMatchDisplayOff()
					UpdateBall WorkOption
 				Case 10
 					WorkOption = WorkOption + 1
 					If WorkOption > 9 then WorkOption = 0
					BallMatchDisplayOff()
					UpdateBall WorkOption
 				Case 11,12
  					WorkOption = WorkOption + 1
 					If WorkOption > 30 then WorkOption = 0
' 					If WorkOption > 0 and WorkOption < 10 then WorkOption = 10
					BallMatchDisplayOff()
					UpdateMatch WorkOption
				Case 13
 					WorkOption = WorkOption + 0.250
 					If WorkOption > 2.000 then WorkOption = 0
 					If WorkOption < 0.250 and WorkOption <> 0 then WorkOption = 0.250
 					Player = 3
					PlayerDisplayOff
 					UpdateScore WorkOption*1000
				Case 14											' Option 14 - Game Music"
					WorkOption = WorkOption + 1
					If WorkOption > 4 then WorkOption = 0
					Select Case WorkOption
					Case 0
						CredText1.Text = "0 = All Music Off"
					Case 1
						CredText1.Text = "1 = Random Default"
					Case 2
						CredText1.Text = "2 = Random Per Ball"
					Case 3
						CredText1.Text = "3 = Player Choice Default"
					Case 4
						CredText1.Text = "4 = Player Choice All"
					End Select
 					BallMatchDisplayOff()
					UpdateBall WorkOption
 				Case 15,16,17,18,19,20,23						' Option 15 - Debug Mode, Option 16 - Clear Stats, Option 17 - Reset High Score, Option 18 - Options to Default, Option 19 - Set the High Score to the highest attained, Option 20 - Tournament Mode
 					If WorkOption = 0 then
 						WorkOption = 1
 					Else
 						Workoption = 0
 					End If
					BallMatchDisplayOff()
					UpdateBall WorkOption
				Case 21
					WorkOption = WorkOption + 1
 					If WorkOption > 9 then WorkOption = 0
					BallMatchDisplayOff()
					UpdateBall WorkOption
				Case 22
					WorkOption = WorkOption + 1
 					If WorkOption > 10 then WorkOption = 0
					BallMatchDisplayOff()
					If WorkOption < 10 then UpdateBall WorkOption
 				End Select
  			End Select
 		Case 11													'0-Key = Enter/Confirm
			PlaySound"OpMenuEnter"
 			If CurrentOpt <> 0 then
				Select Case OptionLevel
				Case 1
					OptionLevel = 2
					CredText1.Text = "New Value "
					Select Case CurrentOpt
					Case 1
						CredText1.Text = CredText1.Text & "(1-9)"
						WorkOption = OptBallsPerGame
					Case 2
						CredText1.Text = CredText1.Text & "(100K-9.9M)"
						WorkOption = OptGoalScore(1)
					Case 3
						CredText1.Text = CredText1.Text & "(100K-9.9M)"
						WorkOption = OptGoalScore(2)
					Case 4
						CredText1.Text = CredText1.Text & "(100K-9.9M)"
						WorkOption = OptGoalScore(3)
					Case 5
						CredText1.Text = CredText1.Text & "(100K-9.9M)"
						WorkOption = OptGoalScore(4)
					Case 6
						CredText1.Text = CredText1.Text & "(0-99)"
						WorkOption = OptMaxCredits
					Case 7
						CredText1.Text = CredText1.Text & "(1M-9M)"
						WorkOption = OptDefaultHighScore
					Case 8
						If OptReplayAward <> 2 then 
							CredText1.Text = CredText1.Text & "(0-3)"
 						Else
							CredText1.Text = CredText1.Text & "(0-1)"
 						End If
						WorkOption = OptReplayCredits
					Case 9
 						CredText1.Text = CredText1.Text & "(0-2)"
 						WorkOption = OptReplayAward
					Case 10
						CredText1.Text = CredText1.Text & "(0-9)"
 						WorkOption = OptHiScoreCredits
					Case 11
 						CredText1.Text = CredText1.Text & "(0-30)"
 						WorkOption = OptBallSaverTime
					Case 12
 						CredText1.Text = CredText1.Text & "(0-30)"
 						WorkOption = OptMBBallSaverTime
 					Case 13
 						CredText1.Text = CredText1.Text & "(0, 0.250-2.000)"
						WorkOption = OptTiltSens
					Case 14
						WorkOption = OptGameMusic
						Select Case WorkOption
							Case 0
								CredText1.Text = "0 = All Music Off"
							Case 1
								CredText1.Text = "1 = Random Default"
							Case 2
								CredText1.Text = "2 = Random Per Ball"
							Case 3
								CredText1.Text = "3 = Player Choice Default"
							Case 4
								CredText1.Text = "4 = Player Choice All"
						End Select
					Case 15
						CredText1.Text = CredText1.Text & "(0=Off, 1=On, Default Off)"
						WorkOption = OptDebugMode
					Case 16
						CredText1.Text = CredText1.Text & "(0=Off, 1=On, Default Off)"
						WorkOption = OptClearStats
					Case 17
						CredText1.Text = CredText1.Text & "(0=Off, 1=On, Default Off)"
						WorkOption = OptResetHighScore
					Case 18
						CredText1.Text = CredText1.Text & "(0=Off, 1=On, Default Off)"
  						WorkOption = OptOptionsToDefault
					Case 19
						CredText1.Text = CredText1.Text & "(0=Off, 1=On, Default Off)"
						WorkOption = OptHStoHighestScore
					Case 20
						CredText1.Text = CredText1.Text & "(0=Off, 1=On, Default Off)"
						WorkOption = OptTournament
					Case 21
						CredText1.Text = CredText1.Text & "(0-9, Default 4)"
 						WorkOption = OptMaxEBGame
					Case 22
						CredText1.Text = CredText1.Text & "(Off, 0-9, Default Off)"
 						WorkOption = OptMaxEBBIP
					Case 23
						CredText1.Text = CredText1.Text & "(0=Off, 1=On, Default On)"
						WorkOption = OptBSDispOn
				End Select
 				Case 2
					Select Case CurrentOpt
					Case 1
						OptBallsPerGame = WorkOption
					Case 2
						OptGoalScore(1) = WorkOption
					Case 3
						OptGoalScore(2) = WorkOption
					Case 4
						OptGoalScore(3) = WorkOption
					Case 5
						OptGoalScore(4) = WorkOption
					Case 6
						OptMaxCredits = WorkOption
 					Case 7
						OptDefaultHighScore = WorkOption
					Case 8
 						OptReplayCredits = WorkOption
					Case 9
 						OptReplayAward = WorkOption
 						If OptReplayAward = 2 then OptReplayCredits = 1
 					Case 10
 						OptHiScoreCredits = WorkOption
 					Case 11
 						OptBallSaverTime = WorkOption
  					Case 12
 						OptMBBallSaverTime = WorkOption
 					Case 13
						OptTiltSens = WorkOption
 					Case 14
  						OptGameMusic = WorkOption
 					Case 15
 						OptDebugMode = WorkOption
					Case 16
  						CredText1.Text = "Updating"
 						OptionCompleteTimer.Enabled = True
 						Exit Sub
 					Case 17
 						CredText1.Text = "Updating"
 						OptionCompleteTimer.Enabled = True
 						Exit Sub
  					Case 18
 						CredText1.Text = "Updating"
						OptionCompleteTimer.Enabled = True
 						Exit Sub
  					Case 19
 						CredText1.Text = "Updating"
 						OptionCompleteTimer.Enabled = True
 						Exit Sub
  					Case 20
 						CredText1.Text = "Updating"
 						OptionCompleteTimer.Enabled = True
						Exit Sub
					Case 21
						OptMaxEBGame = WorkOption
					Case 22
						OptMaxEBBIP = WorkOption
					Case 23
						OptBSDispOn = WorkOption
 					End Select
					CredText1.Text = "Update Complete"
					OptionLevel = 1
				End Select
 			End If
		End Select	

	End Select

End Sub

Sub ZoneFury_KeyUp(ByVal keycode)

Dim oFlipper

	If keycode = PlungerKey Then
		Plunger.Fire
		PlaySound "plunger",0,1,0.25,0.25
	End If
    
	If keycode = LeftFlipperKey Then
'		LeftFlipper.EOSTorque = 0.1
'		LeftFlipper.RotateToStart
		For Each oFlipper in collLeftFlipper
			oFlipper.EOSTOrque = 0.1
			oFlipper.RotateToStart
		Next		

		If not GameOver and not Tilt then PlaySound "fx_flipperdown", 0, 1, -0.05, 0.05
	End If
    
	If keycode = RightFlipperKey Then
'		RightFlipper.EOSTorque = 0.1
'		RightFlipper.RotateToStart
		For Each oFlipper in collRightFlipper
			oFlipper.EOSTOrque = 0.1
			oFlipper.RotateToStart
		Next		
		If not GameOver and not Tilt then PlaySound "fx_flipperdown", 0, 1, -0.05, 0.05
	End If

    If keycode = LeftMagnaSave Then 
		bLutActive = False
		LUTText1.Text = ""
	End If

End Sub

' ***************************************************************************************
' Game-Start Section
' ***************************************************************************************


Sub CoinTimer_Timer()

	CoinTimer.Enabled = False
	If Credits < OptMaxCredits then Credits = Credits + 1
	UpdateCredit Credits
	PlaySound"Menu 2"

End Sub

' This sub is called when we start a game

Sub StartGame()

Dim Zed

'	If Players < cMaxPlayers and not GameStartTimer.Enabled then			' Don't allow any other players until the first player's ball is on the plunger
	If Players < cMaxPlayers then			
		Randomize															' Re-SeeD the random number generator
		MasterSeq.StopPlay
		FlashersNormal()
		Player = 1															' Player 1 always goes first
		GameOver = False													' We're starting a game...set this to False
		GameOverReel.SetValue 1
		HSReel.SetValue 1
		HSReel.TimerEnabled = False
		EndGameTimer.Enabled = False
		If B2SOn then 
			Controller.B2SSetData 25,0
			COntroller.B2SSetGameOver 35,0
		End If
		GameMode = 1														' Set the game mode to normal
		If not FreePlay then Credits = Credits - 1							' Deduct a credit
		UpdateCredit Credits												' Update the display
		Players = Players + 1												' Add 1 to total players
		Select Case Players
		Case 1
			Light1P.State = 1
			Light2P.State = 0
			Light3P.State = 0
			Light4P.State = 0
			If B2SOn then 
				Controller.B2SSetData 40,1
				Controller.B2SSetData 41,0
				Controller.B2SSetData 42,0
				Controller.B2SSetData 43,0
			End If
		Case 2
			Light1P.State = 1
			Light2P.State = 1
			Light3P.State = 0
			Light4P.State = 0
			If B2SOn then 
				Controller.B2SSetData 40,1
				Controller.B2SSetData 41,1
				Controller.B2SSetData 42,0
				Controller.B2SSetData 43,0
			End If
		Case 3
			Light1P.State = 1
			Light2P.State = 1
			Light3P.State = 1
			Light4P.State = 0
			If B2SOn then 
				Controller.B2SSetData 40,1
				Controller.B2SSetData 41,1
				Controller.B2SSetData 42,1
				Controller.B2SSetData 43,0
			End If
		Case 4
			Light1P.State = 1
			Light2P.State = 1
			Light3P.State = 1
			Light4P.State = 1
			If B2SOn then 
				Controller.B2SSetData 40,1
				Controller.B2SSetData 41,1
				Controller.B2SSetData 42,1
				Controller.B2SSetData 43,1
			End If
		End Select
		QirexCount(Players) = 0
		TotalBumperHits(Players) = 0
		HandicapExBall(Players) = False
		TimeInGame(Players) = 0
		If Players = 1 then													' One player starting?
			InitLockDropTargets()
			StopAttractMode()													' Stop the attract mode...set the table lights to start-of-game status
			PlaySound"Start"
			InitSpinners()
			ScoreDisplayOff()												' Initialize the score displays
			Started = False													' set the game-started indicator to False
			BallStarted = False												' Set the ball-started indicator to False
			AdvanceMultiplier 0												' This will set the bonus multiplier to 1
			StopAllMusic()
			InitializeZones()												' Initialize the zone variables
			InitializeMultiball()											' Initialize the multiball variables
			InitializeZones()												' Initialize the zone variables
			InitGI()
			InitSponsors()													' Initialize the sponsors
			InitLockDropTargets()
			GameStartTimer.Enabled = True									' Turn on the timer to put the ball on the plunger
			For Zed = 1 to cMaxPlayers
				Score(Zed) = 0
				ExtraBallsGame(Zed) = 0
				ExtraBallsBIP(Zed) = 0
				SkillShotsMade(Zed) = 0
				GoalScoreMade(Zed,1) = False
				GoalScoreMade(Zed,2) = False
				GoalScoreMade(Zed,3) = False
				GoalScoreMade(Zed,4) = False
			Next
		End If
		If Players >= 2 then												' Starting a multiplayer game?
			Player = Players												' Bring up the score display for the new player
			ZeroScore Players
			Player = 1														' Make sure we're back to player 1
		Else
			ZeroScore Player												' Make sure Player 1's score is zeroed
			ScoreFlashTimer.Enabled = True									' Start Player 1's score flashing
		End If
		InitSpecial()														' Initialize Special feature for gane start
		InitExtraBall()														' Initialize extra ball feature
		InitTargetLights()
		InitABCD()															' Initialize ABCD rollovers
		BIPReel.SetValue 0
		MatchReel.SetValue 1
		MatchFlashTimer.Enabled = False
		If B2SOn then 
			Controller.B2SSetBallInPlay 32,1
			Controller.B2SSetMatch 34,0
		End If
		UpdateBall 1														' Start off with Ball 1
	End If

End Sub

 Sub GameStartTimer_Timer()
 
	Player = Players
	GoNextBall()															' Put the next ball on the plunger
 	GameStartTimer.Enabled = False											' turn off the timer
	Select Case OptGameMusic
	Case 0
		StopAllMusic()
	Case 1
		ZoneFuryMusic()
	Case 2
		MusicTrack = 1
	Case 3
		MusicTrack = 1
		ZoneFuryMusicChoice()
	Case 4
		MusicTrack = 1
		ZoneFuryMusicChoice()
	End Select

End Sub

'*************************************** Hit-Event Section *******************************************
'
' Often this is the largest section in the entire script, as it is the meat and drink of the whole table
'
' Anything in the table that has a hit event or that does something related to a hit event is located here
'
' ************************ Non-Scoring Hit Events ***********************

Sub Drain_Hit()

	PlaySound "drain",0,1,0,0.25
	DOF 128, DOFPulse											' DOF 128 = Drain hit
	Drain.DestroyBall
	If GameMode = 2 then							' Are we in Zone Battle multiball?
 		If MBBallSaver then							' Is the Multiball Ball-Saver active?
 			BallsToRelease(1) = BallsToRelease(1) + 1		' Bump the counter by 1
			BallReleaseSaved.Enabled = True			' Turn on the timer to kick the ball back out
			Exit Sub								' Exit the sub
 		End If
 	End If
	BallCount = BallCount - 1						' reduce the number of balls on the table by 1
	Select Case BallCount
	Case 2
		' Do nothing at this time...This is in case we went to do something later
	Case 1
		EndMultiballTimer.Enabled = True					' If 1 ball remains, multiball has ended
	Case 0
		If not BallSaver and not MBBallSaver then
			Drained = True							' Indicate we've drained
			BoredomTimer.Enabled = False			' Make sure the timers to start swiping the score display are off
			SwipeTimer.Enabled = False				
			AddScore 0,True								' Make sure the current score is fully displayed
			Drain.TimerEnabled = True				' If the ball saver is inactive, count the end-of-ball bonus
		Else
			BallSaved = True						' Ball Is Saved
 			BallCount = 1                           ' Putting 1 ball back into play
 			BallsToRelease(0) = BallCount			' Set the Release counter			
			BallReleaseSaved.Enabled = True
			PlaySound"BallSaved"
		End If
	End Select

End Sub

Sub Drain_Timer()

	Drain.TimerEnabled = False
	BallStarted = False
	BallTimer.Enabled = False
	If OptDebugMode = 0 then 
		StatBallsPlayed = StatBallsPlayed + 1			' Bump the Balls-Played statistic by 1
		StatTimePlayedBall = StatTimePlayedBall + TimeInBall(Player)
	End If
	If not Tilt then
		BonusTimer.Interval = 300
		BonusTimer.Enabled = True
	Else
		BallRelease.TimerEnabled = True
	End If

End Sub

Sub BallRelease_Timer()

	Me.TimerEnabled = False
	GameTimer.Enabled = False
	GoNextBall()

End Sub


Sub Gate_Hit

	If not Started then Started = True							' Indicate a game has started
	If not BallStarted then BallStarted = True
	ScoreFlashTimer.Enabled = False								' Stop flashing the current player's score display
	AddScore 0,True	
 	If GameMode = 2 then
 		If OptMBBallSaverTime <> 0 and MBBallSaver then StartBallSaver
	Else
		If OptBallSaverTime <> 0 and BallSaver then 
			StartBallSaver 
		Else
'			If ExtraBalls = 0 then LSA.State = 0
		End If
 	End If
	If BallInPlay = OptBallsPerGame and ExtraBalls = 0 and OptTournament = 0 then
		If Score(Player) < Int(0.15 * GoalScore(1)) and not HandicapExBall(Player) then 
			LightExtraBall			' Light the extra ball in the event we get to the last ball of the game and the player's score is less than 15% of the current 1st replay score(at default of 800,000, this would be 120,000)
			HandicapExBall(Player) = True
		End If
	End If


End Sub

Sub TrigLOrbit_Hit()

	If not Tilt and GameMode <> 2 Then
		AddScore 5000,True	
		AdvanceZone()
'		SeqFlashersLeft.Play SeqBlinking,,45,2									' Play the left flashers on ramp shot completion except in multiball
	Else
		If GameMode = 2 and not MBReleaseTimer.Enabled then AdvanceBattleZone 0.2
	End If
	If ComboTimer.Enabled Then
		ComboCount = ComboCount + 1
		CheckCombo()
		ComboTimer_Timer()
	End If
	TrigLOrbit.Enabled = False
	TrigLOrbit.TimerEnabled = True

End Sub

Sub TrigLOrbit_Timer()

	TrigLOrbit.Enabled = True
	Me.TimerEnabled = False	

End Sub

Sub Trigger2_Hit

	If not Started then Started = True							' Indicate a game has started
	If not BallStarted then 
		BallStarted = True										' Indicate we've started a new ball
		TimeInBall(Player) = 0									' And reset the time in ball counter to 0
	End If
	BallTimer.Enabled = True
	ScoreFlashTimer.Enabled = False								' Stop flashing the current player's score display
	AddScore 0,True	
	If not GameTimer.Enabled then GameTimer.Enabled = True
	If LockingBall Then	LockingBall = False
 	If GameMode = 2 then
 		If (OptMBBallSaverTime <> 0 and MBBallSaver) and (not BallSaverTimer.Enabled and not BallSaverLightTimer.Enabled) then StartBallSaver
	Else
		If OptBallSaverTime <> 0 and BallSaver then 
			StartBallSaver 
		Else
'			If ExtraBalls = 0 then LSA.State = 0
		End If
 	End If	

End Sub

' GoNextBall: This sub sets up the table for the next ball and puts it into play
 
Sub GoNextBall()

' Recover from the tilted state if we tilted

  	If Tilt then
		Tilt = False
'		TiltText.Text = ""
'		TiltSwing = 0
'		NewTilt = 0
'		OldTilt = 0
		TiltReel.SetValue 1
		If B2SOn then Controller.B2SSetTilt 33,0
		MasterSeq.StopPlay
		Select Case Players
		Case 1
			Light1P.State = 1
			Light2P.State = 0
			Light3P.State = 0
			Light4P.State = 0
			If B2SOn Then
				Controller.B2SSetData 40,1
				Controller.B2SSetData 41,0
				Controller.B2SSetData 42,0
				Controller.B2SSetData 43,0
			End If
		Case 2
			Light1P.State = 1
			Light2P.State = 1
			Light3P.State = 0
			Light4P.State = 0
			If B2SOn Then
				Controller.B2SSetData 40,1
				Controller.B2SSetData 41,1
				Controller.B2SSetData 42,0
				Controller.B2SSetData 43,0
			End If
		Case 3
			Light1P.State = 1
			Light2P.State = 1
			Light3P.State = 1
			Light4P.State = 0
			If B2SOn Then
				Controller.B2SSetData 40,1
				Controller.B2SSetData 41,1
				Controller.B2SSetData 42,1
				Controller.B2SSetData 43,0
			End If
		Case 4
			Light1P.State = 1
			Light2P.State = 1
			Light3P.State = 1
			Light4P.State = 1
			If B2SOn Then
				Controller.B2SSetData 40,1
				Controller.B2SSetData 41,1
				Controller.B2SSetData 42,1
				Controller.B2SSetData 43,1
			End If
		End Select
		ScoreDisplaysOn()
		Select Case OptGameMusic
		Case 1,2
			ZoneFuryMusic()
		Case 3
			ZoneFuryMusicChoice()
		Case 4
			ZoneFuryMusicChoiceAll()
		End Select
	End If
	TiltWarned = False											' Reset the tilt warning for the next ball

' Turn off the special for the player who just played if it's on

	If SpecialLit(Player) then SpecialOff()

' Deal with any extra balls. If there are none, advance to the next player or the next ball-in-play

	If ExtraBalls = 0 then										' Do we have any extra balls to play
		Player = Player + 1										' If we don't, move on to the next player				
		If Player > Players then								' Have we exceeded the number of players in the game?
			Player = 1											' If we have, it's player 1's turn again
			BallInPlay = BallInPlay + 1							' Assuming this isn't the end of the last ball in the game, go to the next ball in play
			If OptDebugMode = 1 then BallInPlay = 1				' Unlimited balls in debug mode
			If BallInPlay <= OptBallsPerGame then ExtraBallsBIP(Player) = 0
		End If
		BallSaveDisplayOff()
		LSA.State = 0
		LSA2.State = 0		
	Else
		ExtraBalls = ExtraBalls - 1								' Deduct 1 from the number of extra balls remaining
		If ExtraBalls = 0 then 
			BallSaveDisplayOff()								' If we have no more extra balls left, turn off the ball save display
			LSA.State = 0
			LSA2.State = 0
		Else
			DisplaySA()											' Display SA on the ball save display
		End If
	End If

' Reset and check table features.

	ResetBonus()												' Reset the end of ball bonus
	GetTargetLights()
	GetABCD()													' Get the state of the ABCD rollovers
	CheckLockStatus()											' Check the lock status for the new player
	If (Lock1Ready(player) or Lock2Ready(player) or Lock3Ready(player)) or ExtraBallLit(Player) <> 0 then			' Open the Piranha diverter if a lock is lit or the extra ball is lit
		PiranhaDiverter1.RotateToEnd
	Else
		PiranhaDiverter1.RotateToStart
	End If

	GetZone()													' Get Zone number/name
	InitEGXDropTargets()										' Reset the drop targets
	InitG45DropTargets()										' Reset the drop targets
	SetFieldMultiplier 1,True,False
	ResetSpinner()												' Reset the lit spinner for new player
	ResetSpinnerCount Player									' reset the spinner counter for the new player
	Reset2Zones()												' reset the 2 zones lights
	ResetFeisar()												' reset Feisar sequence
	SetLockDropTargets()										' Set the lock drop targets for new layer
	GetSponsorStatus()
	If ExtraBallLit(Player) Then
		LXBall.State = 2
	Else
		LXBall.State = 0
	End If
	G45Down = False												' Set the Goteki 45/EGX indicators to false and set the cleared-both count back to 0 for start of ball
	EGXDown = False					
	GotekiEGXCount = 0
	If BumperHitsBall >= 100 then BumpersNormal()
	BumperHitsBall = 0
	
' Determine if we should end the game

	If BallInPlay <= OptBallsPerGame then 						' Have we played the last ball in the game?
		UpdateBall BallInPlay					 				' If not, go on to the next ball
		BallRelease.CreateBall									' Kick out a ball from the trough
		BallRelease.Kick 90,7
'		PlaySound"ballrelease"
		PlaySound SoundFXDOF("ballrelease",127,DOFPulse,DOFContactors)			' DOF 127 = ball release?
		BallCount = 1											' One ball is currently on the table
		Drained = False											' Ball is no longer drained, so we set this to false
		If not ScoreFlashTimer.Enabled then ScoreFlashTimer.Enabled = True	' Start flashing the current player's score display
		If OptBallSaverTime <> 0 then 							' Turn the ball-saver on
			ActivateBallSaver()
		Else
			BallSaver = False
			BallSaverTimer.Enabled = False
		End If
		TimeInBall(Player) = 0									' Reset ball time to 0
		ActivateSkillShot()

' Offer music options for next ball
	
		If BallInPlay <= OptBallsPerGame then
			Select Case OptGameMusic
			Case 0
				StopAllMusic()
			Case 1
			' Do nothing at this time
			Case 2
				StopAllMusic()
				ZoneFuryMusic()
			Case 3,4
				If ZoneFury.ShowDT Then
					CredText1.Text = "Use Flippers to Select Music"
				Else
					CredText1FS.Text = "Use Flippers to Select Music"
				End If
				DisplayTrack()
				SelectingMusic = True
			End Select
		End If

	Else														' If we have played the last ball of the game, go ahead and end the game
		EndGame()												' Invoke the match feature and end the game
	End If

End Sub


' These subs handle the skill shot

' This activates the skill shot at start of the ball

Sub ActivateSkillShot()

Dim SkillTarget

	SkillShotActive = True
	SkillShotWon = False
	Randomize Timer
	SkillTarget = RndNbr(4)
	Select Case SkillTarget
	Case 1
		L6.State = 2
	Case 2
		L7.State = 2
	Case 3
		L8.State = 2
	Case 4
		L9.State = 2
	End Select

End Sub

' This deactivates the skill shot feature when the ball hits any ZONE rollover

Sub DeactivateSkillShot()

	SkillShotActive = False
	If not SkillShotWon Then
		If ALit(Player) then 
			L9.State = 1
		Else
			L9.State = 0
		End If
		If BLit(Player) then 
			L8.State = 1
		Else
			L8.STate = 0
		End If
		If CLit(Player) then 
			L7.State = 1
		Else
			L7.State = 0
		End If
		If DLit(Player) then 
			L6.State = 1
		Else
			L6.State = 0
		End If
	Else
		SkillShotWon = False
	End If

End Sub

' This sub will score the skill shot and give the player its rewards when the skill shot is made

Sub AwardSkillShot()

	If not Tilt then														' we cannot be tilted
		SkillShotWon = True
		SkillShotsMade(Player) = SkillShotsMade(Player) + 1
		If SkillShotsMade(Player) > 5 then SkillShotsMade(Player) = 5
		AddScore 10000*SkillShotsMade(Player),True							' 10,000 points x number of skill shots made (max 50,000 points)
		If OptBallSaverTime <> 0 then AddBallSaverTime 3												' +3 seconds added to ball saver time
		If BonusMultiplier(player) < cMaxBonusMult then
			PlaySound"Barrel Roll"
			AdvanceMultiplier 1											' Bump the bonus multiplier
			AddBonus
		Else
			If not TriakisWon(player) then 
				AwardSponsor "Triakis" 									' Award the Triakis Sponsor if we've not yet won it
			Else
				AddScore 15000,True										' Score 15,000 points if we've already earned the Triakis sponsor this game
			End If
		End If
		FlashABCD														' Flash the ABC lights to draw attention to the fact these are complete
		ClearABCD()
		L9.TimerEnabled = True
'		AdvanceZone
	End If
	DeactivateSkillShot()

End Sub

' ************************ Scoring Hit Events ***********************

Sub Bumper1_Hit

	If not Tilt Then
'		PlaySound "fx_bumper4"
		PlaySound SoundFXDOF("fx_bumper4",107,DOFPulse,DOFContactors)		' DOF 107 = Left Bumper
		BumperHitsBall = BumperHitsBall + 1
		TotalBumperHits(player) = TotalBumperHits(player) + 1
		If BumperHitsBall >= 100 then
			AddScore (1000 + (Int(10*Rnd)) * 10),True
			BumpersAttractMode()
		Else
			AddScore (200 + (Int(10*Rnd)) * 10),True
		End If
		If TotalBumperHits(Player) >= 100 and not HarimauWon(player) then AwardSponsor "Harimau" 
		If SpecialLit(player) then SwitchSpecial()	
	End If

End Sub

Sub Bumper1_Timer
	'Do nothing at this time
End Sub

Sub Bumper2_Hit

	If not Tilt Then
'		PlaySound "fx_bumper4"
		PlaySound SoundFXDOF("fx_bumper4",109,DOFPulse,DOFContactors)		' DOF 109 = Right Bumper
		If BumperHitsBall >= 100 then
			AddScore (1000 + (Int(10*Rnd)) * 10),True
		Else
			AddScore (200 + (Int(10*Rnd)) * 10),True
			BumperHitsBall = BumperHitsBall + 1
			If BumperHitsBall >= 100 then BumpersAttractMode()
		End If
		TotalBumperHits(player) = TotalBumperHits(player) + 1
		If TotalBumperHits(Player) = 100 and not HarimauWon(player) then AwardSponsor "Harimau"
		If SpecialLit(player) then SwitchSpecial() 	
	End If

End Sub

Sub Bumper2_Timer
	'Do nothing at this time
End Sub	

Sub Bumper3_Hit

	If not Tilt Then
'		PlaySound "fx_bumper4"
		PlaySound SoundFXDOF("fx_bumper4",108,DOFPulse,DOFContactors)		' DOF 108 = Center Bumper
		If BumperHitsBall >= 100 then
			AddScore (1000 + (Int(10*Rnd)) * 10),True
		Else
			AddScore (200 + (Int(10*Rnd)) * 10),True
			BumperHitsBall = BumperHitsBall + 1
			If BumperHitsBall >= 100 then BumpersAttractMode()
		End If
		TotalBumperHits(player) = TotalBumperHits(player) + 1
		If TotalBumperHits(Player) = 100 and not HarimauWon(player) then AwardSponsor "Harimau"
		If SpecialLit(player) then SwitchSpecial() 	
	End If

End Sub

Sub Bumper3_Timer
	'Do nothing at this time
End Sub

' ***** Top Rollovers (Switches sw9, sw8, sw7, sw6)


Sub sw9_Hit

	If not Tilt Then
		PlaySound"Boost"
		If SkillShotActive Then
			If L9.State = 2 then
				AwardSkillShot
				Exit Sub
			Else
				DeactivateSkillShot
			End If
		End If
		If L9.State = 0 Then
			L9.State = 1
			ALit(Player) = True
			AddScore 1000,True
			AddBonus
			ABCDCount(Player) = ABCDCount(Player) + 1
			CheckABCD()
		Else
			AddScore 550,True
		End If

	End If

End Sub

Sub sw8_Hit

	If not Tilt Then
		PlaySound"Boost"
		If SkillShotActive Then
			If L8.State = 2 then
				AwardSkillShot
				Exit Sub
			Else
				DeactivateSkillShot
			End If
		End If
		If L8.State = 0 Then
			L8.State = 1
			BLit(Player) = True
			AddScore 1000,True
			AddBonus
			ABCDCount(Player) = ABCDCount(Player) + 1
			CheckABCD()
 		Else
	 		AddScore 550,True
		End If

	End If

End Sub

Sub sw7_Hit

	If not Tilt Then
		PlaySound"Boost"
		If SkillShotActive Then
			If L7.State = 2 then
				AwardSkillShot
				Exit Sub
			Else
				DeactivateSkillShot
			End If
		End If
		If L7.State = 0 Then
			L7.State = 1
			CLit(Player) = True
			AddBonus
			AddScore 1000, True
			ABCDCount(Player) = ABCDCount(Player) + 1
			CheckABCD()
		Else
			AddScore 550, True
		End If
	End If

End Sub

Sub sw6_Hit

	If not Tilt Then
		PlaySound"Boost"
		If SkillShotActive Then
			If L6.State = 2 then
				AwardSkillShot
				Exit Sub
			Else
				DeactivateSkillShot
			End If
		End If
		If L6.State = 0 Then
			L6.State = 1
			DLit(Player) = True
			AddBonus
			AddScore 1000, True
			ABCDCount(Player) = ABCDCount(Player) + 1
			CheckABCD()
		Else
			AddScore 550, True
		End If
	End If

End Sub

Sub CheckABCD()													' Check to see if we've completed A-B-C-D

	If ABCDCount(Player) = 4 then										' If the count is 4, A-B-C-D is complete
		AddScore 10000,True												' Add some bonus points
		If BonusMultiplier(player) < cMaxBonusMult then
			AdvanceMultiplier 1									' Bump the bonus multiplier
			AddBonus
 		Else
			If not TriakisWon(player) then 
				AwardSponsor "Triakis" 							' Award the Triakis Sponsor if we've not yet won it
			Else
				AddScore 15000,True								' Score 15,000 points if we've already earned the Triakis sponsor this game
				PlaySound"Barrel Roll"
			End If
			AddBonus()
		End If
		FlashABCD												' Flash the ABC lights to draw attention to the fact these are complete
	End If

End Sub

' This sub clears the counters and indicators for the ABCD rollovers and lights for a single player.

Sub ClearABCD()

	ABCDCount(Player) = 0
	ALit(Player) = False
	BLit(Player) = False
	CLit(Player) = False
	DLit(Player) = False

End Sub

' This initializes the ABCD rollovers at the start of the game

Sub InitABCD()

Dim pl

	For pl = 1 to cMaxPlayers
		ALit(Pl) = False
		BLit(Pl) = False
		CLit(Pl) = False
		DLit(Pl) = False
		ABCDCount(pl) = 0
	Next

End Sub

' This gets the state of the ABCD lights by player

Sub GetABCD()

	If ALit(Player) then 
		L9.State = 1
	Else
		L9.State = 0
	End If
	If BLit(Player) then 
		L8.State = 1
	Else
		L8.State = 0
	End If
	If CLit(Player) then 
		L7.State = 1
	Else
		L7.State = 0
	End If
	If DLit(Player) then 
		L6.State = 1
	Else
		L6.State = 0
	End If

End Sub

Sub FlashABCD()

Dim oLight

	L9.BlinkPattern = "1000"
	L8.BlinkPattern = "0100"
	L7.BlinkPattern = "0010"
	L6.BlinkPattern = "0001"

	For Each oLight in collABCDLights							' Start them blinking
		oLight.State = 2
		oLight.BlinkInterval = 75
	Next
'	If GameMode <> 2 then SeqFlashersTop.Play SeqBlinking,,45,10	' Play the top flashers on ZONE completion except in multiball
	ClearABCD()
	L9.TimerEnabled = True

End Sub

' This restores the ABCD lighting to normal

Sub L9_Timer()

Dim oLight

	L9.TimerEnabled = False	
	For Each oLight in collABCDLights
		oLight.BlinkPattern = "10"
		oLight.BlinkInterval = 100
		oLight.State = 0
	Next

'	If ALit(Player) then L9.State = 1
'	If BLit(Player) then L8.State = 1
'	If CLit(Player) then L7.State = 1
'	If DLit(Player) then L6.State = 1

End Sub

' *** EG-X Drop Targets (Switches sw1, sw2, sw3)

Dim EGXTargetsDown, EGXDTSeq, EGXInSequence

Sub sw1_Hit

	If not Tilt then
		PlaySound SoundFXDOF("DTDrop",116,DOFPulse,DOFContactors)
		gi5_E.State = 1
		AddScore 900,True
		EGXTargetsDown = EGXTargetsDown + 1
		sw1.IsDropped = True
		L1.State = 1
		EGXDTSeq = EGXDTSeq + "1"
		CheckEGXDropTargets
		AddBonus											' Bump the end of ball bonus by 1
	End If

End Sub

Sub sw1_Timer

	sw1.TimerEnabled = False
	ResetEGXDropTargets()

End Sub

Sub sw2_Hit

	If not Tilt then
		PlaySound SoundFXDOF("DTDrop",116,DOFPulse,DOFContactors)
		gi5_G.State = 1
		AddScore 900,True
		EGXTargetsDown = EGXTargetsDown + 1
		sw2.IsDropped = True
		L2.State = 1
		EGXDTSeq = EGXDTSeq + "2"
		CheckEGXDropTargets
		AddBonus											' Bump the end of ball bonus by 1
	End If

End Sub

Sub sw2_Timer

' Do nothing at this time

End Sub

Sub sw3_Hit

	If not Tilt then
		PlaySound SoundFXDOF("DTDrop",116,DOFPulse,DOFContactors)
		gi5_X.State = 1
		AddScore 900,True
		EGXTargetsDown = EGXTargetsDown + 1
		sw3.IsDropped = True
		L3.State = 1
		EGXDTSeq = EGXDTSeq + "3"
		CheckEGXDropTargets
		AddBonus											' Bump the end of ball bonus by 1
	End If

End Sub

Sub sw3_Timer

' Do nothing at this time

End Sub

Sub CheckEGXDropTargets()

	If not Tilt Then
		Select Case EGXTargetsDown
		Case 1
			If EGXDTSeq <> "1" then
				EGXInSequence = False
				LEGXSeq.State = 0
			End If
		Case 2
			If EGXDTSeq <> "12" then
				EGXInSequence = False
				LEGXSeq.State = 0
			End If
		Case 3
			If EGXDTSeq <> "123" then
				EGXInSequence = False
				LEGXSeq.State = 0
				AddScore 10000,True								' 10,000 points for clearing all drop targets in any order
			Else
				If not EGXWon(player) then 
					AwardSponsor "EG-X"							' Award EG-X Sponsorship
				Else
					AddScore 15000,True							' Score 15,000 points if we've already earned the EG-X sponsor this game
				End If
				If not BallSaver and not MBBallSaver then
					StartGeneralBallSaver 5								' turn on a 5-second ball save for completing Feisar		
				Else
					AddBallSaverTime 5									' Add 5 seconds to the ball save if it is already running
				End If
			End If
			If not SpinnerLit then LightSpinner()				' Light the Piranha spinner on clearing any drop target bank
			If Zone(Player) >= 7 then
				If not LeftAdv2ZonesLit and GameMode <> 2 then ActivateLeft2Zones()
			End If
			EGXDown = True									' Indicate all the EG-X drop targets have come down
			CheckGotekiEGX									' Check to see if both the EG-X and Goteki 45 targets have cleared
			sw1.TimerEnabled = True							' Turn on the Drop Target 1 timer. This timer controls when the targets are reset
		End Select
	End If

End Sub

Sub ResetEGXDropTargets()

	PlaySound SoundFXDOF("DTResetB", 111, DOFPulse, DOFcontactors), 0, .7, 0, 0.05
	InitEGXDropTargets()									'

End Sub

Sub InitEGXDropTargets()

Dim oTarget, oLight

	For Each oTarget in CollEGXTargets
		oTarget.IsDropped = False
	Next

	For Each oLight in collEGXLights
		oLight.State = 0
	Next
	EGXTargetsDown = 0
	EGXDTSeq = ""
	EGXInSequence = True
	LEGXSeq.State = 1
	EGXDown = False
	gi5_E.State = 0
	gi5_G.State = 0
	gi5_X.State = 0

End Sub


'*** Goteki-45 Drop Targets (Switches sw14, sw15, sw16)

Dim G45TargetsDown, G45DTSeq, G45InSequence

Sub sw14_Hit()

	If not Tilt then
		PlaySound SoundFXDOF("DTDrop",116,DOFPulse,DOFContactors)
		gi8_G.State = 1
		AddScore 900,True
		sw14.IsDropped = True
		G45TargetsDown = G45TargetsDown + 1
		L14.State = 1
		G45DTSeq = G45DTSeq + "1"
		CheckGotekiDropTargets
		AddBonus											' Bump the end of ball bonus by 1
	End If

End Sub

Sub sw14_Timer()

	sw14.TimerEnabled = False
	ResetGotekiDropTargets()

End Sub

Sub sw15_Hit()

	If not Tilt then
		PlaySound SoundFXDOF("DTDrop",116,DOFPulse,DOFContactors)
		gi8_4.State = 1
		AddScore 900,True
		G45TargetsDown = G45TargetsDown + 1
		sw15.IsDropped = True
		L15.State = 1
		G45DTSeq = G45DTSeq + "2"
		CheckGotekiDropTargets
		AddBonus											' Bump the end of ball bonus by 1
	End If

End Sub

Sub sw16_Hit()

	If not Tilt then
		PlaySound SoundFXDOF("DTDrop",116,DOFPulse,DOFContactors)
		gi8_5.State = 1
		AddScore 900,True
		G45TargetsDown = G45TargetsDown + 1
		sw16.IsDropped = True
		L16.State = 1
		G45DTSeq = G45DTSeq + "3"
		CheckGotekiDropTargets
		AddBonus											' Bump the end of ball bonus by 1
	End If

End Sub

Sub CheckGotekiDropTargets()

	If not Tilt then
		Select Case G45TargetsDown
		Case 1
			If G45DTSeq <> "1" then
				G45InSequence = False
				LG45Seq.State = 0
			End If
		Case 2
			If G45DTSeq <> "12" then
				G45InSequence = False
				LG45Seq.State = 0
			End If
		Case 3
			If G45DTSeq <> "123" then
				G45InSequence = False
				LG45Seq.State = 0
				AddScore 10000,True								' 10,000 points for clearing all drop targets in any order
			Else
				If not Goteki45Won(player) then 
					AwardSponsor "Goteki45"						' Award Goteki 45 Sponsorship
				Else
					AddScore 15000,True							' Score 15,000 points if we've already won the Goteki 45 sponsor
				End If
				If not BallSaver and not MBBallSaver then
					StartGeneralBallSaver 5								' turn on a 5-second ball save for completing Feisar		
				Else
					AddBallSaverTime 5									' Add 5 seconds to the ball save if it is already running
				End If
			End If
			If Zone(Player) >= 7 then
				If not RightAdv2ZonesLit and GameMode <> 2 then ActivateRight2Zones()
			End If
			If not SpinnerLit then LightSpinner()				' Light the Piranha spinner on clearing any drop target bank
			G45Down = True									' Indicate all the EG-X drop targets have come down
			CheckGotekiEGX										' Check to see if both the EG-X and Goteki 45 targets have cleared
			sw14.TimerEnabled = True					' Turn on the Drop Target 1 timer. This timer controls when the targets are reset
		End Select
	End If

End Sub

Sub ResetGotekiDropTargets()

	PlaySound SoundFXDOF("DTResetB", 111, DOFPulse, DOFcontactors), 0, .7, 0, 0.05
	InitG45DropTargets()									'

End Sub

Sub InitG45DropTargets()

Dim oTarget, oLight

	For Each oTarget in collG45Targets
		oTarget.IsDropped = False
	Next

	For Each oLight in collG45Lights
		oLight.State = 0
	Next
	G45TargetsDown = 0
	G45DTSeq = ""
	G45InSequence = True
	LG45Seq.State = 1
	G45Down = False
	gi8_G.State = 0
	gi8_4.State = 0
	gi8_5.State = 0

End Sub

' Sub CheckGotekiEGX. This sub checks to see if we've cleared both sets of the Goteki 45 and EG-X drop targets in the same ball. If we have, the counter
' tracking this is bumped by 1. Clearing both sets once in the same ball advances the field multiplier to 2x, clearing both sets, CLearing both sets three times in the same ball advances the field multiplier to 3x

Sub CheckGotekiEGX()

	If EGXDown and G45Down then
		GotekiEGXCount = GotekiEGXCount + 1
		Select Case GotekiEGXCount
		Case 1
			SetFieldMultiplier 2,True,False															' 2x All Scores for one clear
		Case 3
			SetFieldMultiplier 3,True,False															' 3x All scores for three clears
		Case 5
			SetFieldMultiplier 6,True,False															' 6x All Scores for five clears
		End Select
		If (GotekiEGXCount > 3) and (GotekiEGXCount mod 2 = 0) then AddScore 50000,False			' Score 50,000 (unaffected by the field multiplier) for every two clears beyond 4 in the same ball
		EGXDown = False
		G45Down = False
	End If

End Sub

'*** Qirex Spot Targets (Switches sw11, sw12, sw13)

Sub sw12_Hit

	If not Tilt then
		AddScore 900,True
		PlaySound "LAZER"
		QirexCount(player) = QirexCount(player) + 1
		If QirexCount(player) = 10 and not QirexWon(player) then AwardSponsor "Qirex"
		L12.State = 2
		L12.TimerEnabled = True
	End If

End Sub

Sub L12_Timer()
	
	L12.TimerEnabled = False
	L12.State = 0

End Sub

Sub sw13_Hit

	If not Tilt then
		AddScore 900,True
		PlaySound "LAZER"
		QirexCount(player) = QirexCount(player) + 1
		If QirexCount(player) = 10 and not QirexWon(player) then AwardSponsor "Qirex"
		L13.State = 2
		L13.TimerEnabled = True
	End If

End Sub

Sub L13_Timer()
	
	L13.TimerEnabled = False
	L13.State = 0

End Sub

'*** LOCK DropTargets (Switches sw17, sw18, sw19, sw20)

Dim LockDTSeq(4)
Dim LockDTInSequence(4)
Dim LockTargetsDown(4)
Dim LockLDown(4)
Dim LockODown(4)
Dim LockCDown(4)
Dim LockKDown(4)


Sub sw17_Hit()

	If not Tilt then
		PlaySound SoundFXDOF("DTDrop",116,DOFPulse,DOFContactors)
		gi26_L.State = 1
		AddScore 900,True
		LockTargetsDown(Player) = LockTargetsDown(Player) + 1
		sw17.IsDropped = True
		LockLDown(Player) = True
		LockDTSeq(Player) = LockDTSeq(Player) + "1"
		CheckLockDropTargets
		AddBonus											' Bump the end of ball bonus by 1
	End If

End Sub

Sub sw18_Hit()

	If not Tilt then
		PlaySound SoundFXDOF("DTDrop",116,DOFPulse,DOFContactors)
		gi26_O.State = 1
		AddScore 900,True
		LockTargetsDown(Player) = LockTargetsDown(Player) + 1
		sw18.IsDropped = True
		LockODown(Player) = True
		LockDTSeq(Player) = LockDTSeq(Player) + "2"
		CheckLockDropTargets
		AddBonus											' Bump the end of ball bonus by 1
	End If

End Sub

Sub sw19_Hit()

	If not Tilt then
		PlaySound SoundFXDOF("DTDrop",116,DOFPulse,DOFContactors)
		gi26_C.State = 1
		AddScore 900,True
		LockTargetsDown(Player) = LockTargetsDown(Player) + 1
		sw19.IsDropped = True
		LockCDown(Player) = True
		LockDTSeq(Player) = LockDTSeq(Player) + "3"
		CheckLockDropTargets
		AddBonus											' Bump the end of ball bonus by 1
	End If

End Sub

Sub sw20_Hit()

	If not Tilt then
		PlaySound SoundFXDOF("DTDrop",116,DOFPulse,DOFContactors)
		gi26_K.State = 1
		AddScore 900,True
		LockTargetsDown(Player) = LockTargetsDown(Player) + 1
		sw20.IsDropped = True
		LockKDown(Player) = True
		LockDTSeq(Player) = LockDTSeq(Player) + "4"
		CheckLockDropTargets
		AddBonus											' Bump the end of ball bonus by 1
	End If

End Sub

Sub sw17_Timer()

	sw17.TimerEnabled = False
	ResetLockDropTargets()

End Sub

Sub CheckLockDropTargets()

	Select Case LockTargetsDown(Player)
	Case 1
		If LockDTSeq(Player) <> "1" then
			LockDTInSequence(Player) = False
		End If
	Case 2
		If LockDTSeq(Player) <> "12" then
			LockDTInSequence(Player) = False
		End If
	Case 3
		If LockDTSeq(Player) <> "123" then
			LockDTInSequence(Player) = False
		End If
	Case 4
		If LockDTSeq(Player) <> "1234" then
			LockDTInSequence(Player) = False
			AddScore 10000,True								' 10,000 points for clearing all drop targets in any order
			If LocksLit(player) < 3 and GameMode <> 2 then 
				If MBThisGame(Player) = 0 Then
					Activate3Locks							' Activate all 3 locks if it's for the player's first multiball of the GameMode
				Else
					Activate1Lock							' Activate the next lock if we haven't already done so and we mustn't be in multiball currently
				End If
			End If
			If GameMode = 2 then AdvanceBattleZone 0.2		' Bump battle zone if LOCK completed during multiball
		Else
			If not IcarasWon(player) then 
				'AwardSponsor "Icaras"					' Award Icaras Sponsorship
				AwardIcarasDelay.Enabled = True			' Award Icarus Sponsorship
			Else
				AddScore 15000,True						' Score 15,000 if we've already won the Icaras sponsor this game
			End If
			If LocksLit(player) < 3 and GameMode <> 2 then Activate3Locks		' Activate the locks if we haven't already done so and we mustn't be in multiball currently
		End If
		sw17.TimerEnabled = True					' Turn on the Drop Target 1 timer. This timer controls when the targets are reset
	End Select

End Sub

Sub ResetLockDropTargets()

	PlaySound SoundFXDOF("DTResetB",112,DOFPulse,DOFContactors)
	InitLockDropTargets()									'

End Sub

Sub InitLockDropTargets()

Dim oTarget

	For Each oTarget in collLockDropTargets
		oTarget.IsDropped = False
	Next

	LockTargetsDown(Player) = 0
	LockDTSeq(Player) = ""
	LockDTInSequence(Player) = True
	LockLDown(Player) = False
	LockODown(Player) = False
	LockCDown(Player) = False
	LockKDown(Player) = False
	gi26_L.State = 0
	gi26_O.State = 0
	gi26_C.State = 0
	gi26_K.State = 0

End Sub

Sub SetLockDropTargets()

Dim oTarget

'	For Each oTarget in collLockDropTargets
'		oTarget.IsDropped = False
'	Next
	If LockLDown(Player) Then 
		sw17.IsDropped = True
	Else
		sw17.IsDropped = False
	End If
	If LockODown(Player) Then 
		sw18.IsDropped = True
	Else
		sw18.IsDropped = False
	End If
	If LockCDown(Player) Then 
		sw19.IsDropped = True
	Else
		sw19.IsDropped = False
	End If
	If LockKDown(Player) Then 
		sw20.IsDropped = True
	Else
		sw20.IsDropped = False
	End If

End Sub

' Zone Ramp triggers

Sub LeftRampZone_Hit()

	If not Tilt then													' We cannot be tilted
'		If GameMode <> 2 then SeqFlashersLeft.Play SeqBlinking,,45,2	' Play the left flashers on ramp shot completion except in multiball
		If LFeisarA.State = 0 then
			LFeisarA.State = 1
			FeisarTrig = FeisarTrig + 1
			CheckFeisar
		End If
		If GameMode <> 2 then											' Don't count combos in multiball
			ComboCount = ComboCount + 1
			If not ComboTimer.Enabled Then 
				ActivateCombo()
			Else
				CheckCombo()
			End If
		End If
		Select Case GameMode											' Treat this shot differently if we're in Zone Battle
		Case 1
			If not LeftAdv2ZonesLit then
				AddScore 5000,True											' 5000 points per Zone
				AdvanceZone()												' Advance to the next Zone
			Else
				AddScore 10000,True											' 10,000 points when 2 Zones are lit
				AdvanceZone():AdvanceZone()									' Advance 2 Zones
				PlaySound"Barrel Roll"
				LLeft2Zones_Timer()
			End If
		Case 2
			If not ZoneBoostReady(0) then									' Zone Boost?
				PlaySound"Boost"
				AddScore 5000,True											' Non-Boost Ramp shots are 5,000 points
				AdvanceBattleZone 0.5										' Advance the Battle Zone by 0.5
			Else
				AwardZoneBoost()											' Award the Zone Boost if Ready
			End If
		End Select
	End If

End Sub		

Sub RightRampZone_Hit()

	If not Tilt then														' We cannot be tilted
'		If GameMode <> 2 then SeqFlashersRight.Play SeqBlinking,,45,2		' Play the right flashers on ramp shot completion except in multiball
		If LFeisarR.State = 0 then
			LFeisarR.State = 1
			FeisarTrig = FeisarTrig + 1
			CheckFeisar
		End If
		If GameMode <> 2 then												' Don't count combos in multiball
			ComboCount = ComboCount + 1
			If not ComboTimer.Enabled Then 
				ActivateCombo()
			Else
				CheckCombo()
			End If
		End If
		Select Case GameMode												' Treat this shot differently if we're in Zone Battle
		Case 1										
			If not RightAdv2ZonesLit then
				AddScore 5000,True											' 3000 points per Zone
				AdvanceZone()												' Advance to the next Zone
			Else
				AddScore 10000,True											' 6000 points
				AdvanceZone():AdvanceZone()									' Advance 2 Zones
				PlaySound"Barrel Roll"
				LRight2Zones_Timer()
			End If
		Case 2
			If not ZoneBoostReady(1) then									' Zone Boost?
				PlaySound"Boost"
				AddScore 5000,True											' Non-Boost Ramp shots are 5,000 points
				AdvanceBattleZone 0.5										' Advance the Battle Zone by 0.5
			Else
				AwardZoneBoost()											' Award the Zone Boost if Ready
			End If
		End Select
	End If

End Sub	

' THese subs control the combo system

Sub ActivateCombo()

	LLeftBarrier.State = 2
	LRightBarrier.State = 2
	ComboTimer.Enabled = True

End Sub

Sub CheckCombo()

	ComboTimer.Enabled = False
	If not Tilt then
		Select Case ComboCount
		Case 2
			AddScore 10000,False											' 2-Way Combo 10,000 points
		Case 3
			AddScore 20000,False											' 3-Way Combo: 20,000 points, 2x Field for 30 seconds
			SetFieldMultiplier 2,False,True
 			PlaySound "Perfect"
		Case 4
			AddScore 30000,False											' 4-Way Combo: 30,000 points
		Case 5
			AddScore 50000,False											' 5-Way Combo: 50,000 points, 3x Field for 30 seconds
			SetFieldMultiplier 3,False,True
			PlaySound "5 Chain Bonus"
		Case 6,7,8,9
			AddScore 75000,False											' 6-9 way combo: 75,000 points
		Case 10
			AddScore 100000,False											' 10-way combo: 100,000 points, 6x Field 30 seconds
			SetFieldMultiplier 6,False,True
			PlaySound "10 Chain Bonus"
		Case 15	
			AddScore 100000,False											
			PlaySound "15 Chain Bonus"
		Case 20
			AddScore 100000,False
			PlaySound "20 Chain Bonus"
		Case Else
			AddScore 100000,False
		End Select
		ComboTimer.Enabled = True
	End If

End Sub

Sub ComboTimer_Timer()

	ComboTimer.Enabled = False
	LLeftBarrier.State = 0
	LRightBarrier.State = 0	
	ComboCount = 0

End Sub

' *** Piranha Spinner subs (switch SPiranha)

Dim SpinnerCount(4), SpinnerLit								' Number of times the spinner has spun in the current ball
															' SpinnerLit indicates whether the Piranha Spinner is lit for 1000 points/spin

' Initialize spinner at the start of a game

Sub InitSpinners()

Dim x

	For x = 1 to 4
		SpinnerCount(x) = 0
	Next

End Sub

' Reset a single player's spinner

Sub ResetSpinnerCount(ByVal Pl)

	SpinnerCount(Pl) = 0

End Sub

Sub SPiranha_Spin()

'	PlaySound "fx_spinner",0,.25,0,0.25
	PlaySound "fx_spinner", 0, .25, Pan(SPiranha), 0.25, 0, 0, 1, AudioFade(SPiranha)
	If not Tilt then
		DOF 114,DOFPulse
		SpinnerCount(Player) = SpinnerCount(Player) + 1
		PlaySound"LAZER"
		If not SpinnerLit then
			AddScore 100,True
		Else
			AddScore 1000,True
		End If
		If SpinnerCount(player) = 50 then
			If not PiranhaWon(player) then 
				AwardSponsor "Piranha"			' Award the Piranha sponsor
			Else
				AddScore 15000,True				' Score 15,000 points if we've already won the Piranha sponsor this game
			End If
		End If
	End If

End Sub

Sub LightSpinner()

	SpinnerLit = True
	L21.State = 1

End Sub

Sub ResetSpinner()

	SpinnerLit = False
	L21.State = 0

End Sub



' *** Inlane/Outlane subs

Sub LeftOutlane_Hit()

	If not Tilt then
		AddScore 5000,True
		PlaySound"DROP4"
		If LFeisarF.State = 0 then
			FeisarTrig = FeisarTrig + 1
			LFeisarF.State = 1
			CheckFeisar
			AddBonus											' Bump the end of ball bonus by 1
		End If
		If SpecialLit(Player) and LSpecial1.State = 1 then AwardSpecial
		If BallSaverLightTimer.Enabled and not MBBallSaver then BallSaverLightTimer.Enabled = False
	End If

End Sub

Sub RightOutlane_Hit()

	If not Tilt then
		AddScore 5000,True
		PlaySound"DROP4"
		If LFeisarS.State = 0 then
			FeisarTrig = FeisarTrig + 1
			LFeisarS.State = 1
			CheckFeisar
			AddBonus											' Bump the end of ball bonus by 1
		End If
		If SpecialLit(Player) and LSpecial2.State = 1 then AwardSpecial
		If BallSaverLightTimer.Enabled and not MBBallSaver then BallSaverLightTimer.Enabled = False
	End If

End Sub

Sub LeftInlane_Hit()

	If not Tilt then
		AddScore 1000,True
		PlaySound"DROP4_up"
		If LFeisarE.State = 0 then
			FeisarTrig = FeisarTrig + 1
			LFeisarE.State = 1
			CheckFeisar
			AddBonus											' Bump the end of ball bonus by 1
		End If
		If L2ZonesL.State = 1 and GameMode <> 2 then 
			ActivateRtRamp2Zones()
			L2ZonesL.State = 0
		End If
		' Do something else here
	End If

End Sub

Sub RightInlane_Hit()

	If not Tilt then
		AddScore 1000,True
		PlaySound"DROP4_up"
		If LFeisarI.State = 0 then
			FeisarTrig = FeisarTrig + 1
			LFeisarI.State = 1
			CheckFeisar
			AddBonus											' Bump the end of ball bonus by 1
		End If
		If L2ZonesR.State = 1 and GameMode <> 2 then 
			ActivateLtRamp2Zones()
			L2ZonesR.State = 0
		End If
		' Do something else here
	End If

End Sub

Sub CheckFeisar()

	If FeisarTrig = 6 then
		If not FeisarWon(player) then
			AwardSponsor "Feisar"								' Award the Feisar sponsor
		Else
			AddScore 15000,True									' Score 15,000 points if we've already earned the Feisar sponsor this game
		End If
		ResetFeisar												' Reset Feisar lights
		If not BallSaver and not MBBallSaver then
			StartGeneralBallSaver 5								' turn on a 5-second ball save for completing Feisar		
		Else
			AddBallSaverTime 5									' Add 5 seconds to the ball save if it is already running
		End If
	End If

End Sub

Sub ResetFeisar()

	FeisarTrig = 0
	LFeisarF.State = 0
	LFeisarE.State = 0
	LFeisarI.State = 0
	LFeisarS.State = 0
	LFeisarA.State = 0
	LFeisarR.State = 0

End Sub

'*** Other Scoring Targets

' Checks the spot-target and drop target lights. If all six are lit, light the ramp.

Sub InitTargetLights()

Dim Zed

	For Zed = 1 to 4
		L1State(Zed) = 0
		L2State(Zed) = 0
		L3State(Zed) = 0
		L12State(Zed) = 0
		L13State(Zed) = 0
	Next
	L1.State = 0
	L2.State = 0
	L3.State = 0
	L12.State = 0
	L13.State = 0

End Sub

'  This sub sets the drop/spot target lights by player

Sub GetTargetLights()

	L1.State = L1State(Player)
	L2.State = L2State(Player)
	L3.State = L3State(Player)
	L12.State = L12State(Player)
	L13.State = L13State(Player)

End Sub

' These control the Advance 2-zones feature on the ramps

Sub ActivateLeft2Zones()

	L2ZonesL.State = 1

End Sub

Sub ActivateRight2Zones()

	L2ZonesR.State = 1

End Sub

Sub ActivateLtRamp2Zones()

	LLeft2Zones.State = 2
	LeftAdv2ZonesLit = True
	LLeft2Zones.TimerEnabled = True

End Sub

Sub ActivateRtRamp2Zones()

	LRight2Zones.State = 2
	RightAdv2ZonesLit = True
	LRight2Zones.TimerEnabled = True

End Sub

Sub LLeft2Zones_Timer()

	LLeft2Zones.TimerEnabled = False
	LLeft2Zones.state = 0
	LeftAdv2ZonesLit = False

End Sub

Sub LRight2Zones_Timer()

	LRight2Zones.TimerEnabled = False
	LRight2Zones.State = 0
	RightAdv2ZonesLit = False

End Sub

Sub Reset2Zones()

	LLeft2Zones_Timer()
	LRight2Zones_Timer()
	L2ZonesL.State = 0
	L2ZOnesR.State = 0

End Sub

' *** Piranha Lock Subs

Dim BallsInLockKicker						' Number of balls currently in the lock kicker

Sub PiranhaLock1_Hit()

'	PlaySound"kicker_enter"
	
PlaySound "kicker_enter",0,.75,0,0.25
	PiranhaLock1.DestroyBall
	If ExtraBallLit(player) <> 0 then 
		ExtraBallTimer.Enabled = True
		If Lock1Ready(player) or Lock2Ready(player) or Lock3Ready(player) then LockingBall = True
	End If
	' Add code to check to see if the next lock is lit based on the number of balls locked
	BallsInLockKicker = BallsInLockKicker + 1
	If Lock1Ready(player) or Lock2Ready(player) or Lock3Ready(player) then 									' Locks lit for multiball?
		LockBall												' If yes, lock a ball
		BallsInLockKicker = 0
	Else
		PiranhaLock1.TimerEnabled = True							' If not, turn on the kicker timer to kick it back out
	End If

End Sub

Sub PiranhaLock1_Timer()

	PiranhaLock1.TimerEnabled = False							' Turn off the kicker timer
	PiranhaLock1.CreateBall
	PiranhaLock1.Kick 260,8										' Kick the ball out in a random direction
'	PlaySound"solenoid"
	PlaySound SoundFXDOF("solenoid",131,DOFPulse,DOFContactors),0,.75,0,0.25
	If ExtraBallLit(player) = 0 then PiranhaDiverter1.TimerEnabled = True

	If not BallSaver or MBBallSaver then 
		StartGeneralBallSaver 5										' Start a 5-second ball save
	Else
		AddBallSaverTime 5
	End If

End Sub

Sub PiranhaDiverter1_Timer()

	PiranhaDiverter1.TimerEnabled = False
	PiranhaDiverter1.RotateToStart

End Sub

' ************************************************************************************************
' Bonus-Count Section
' ************************************************************************************************

' End-of-ball bonus

' Bonus routine originally developed by shiva...Adapted to use 30K, 40k, and 50k bonus lights

' This is the main controller sub for the bonus-countdown feature

Sub BonusTimer_Timer()
	
	x1 = Int(bonus / 10) 							' will be equal to the 10's digit
	y1 = bonus Mod 10 								' will be equal to the 1's digit
	BonusCounted = False 							' ensure that this is set to false before we count

' We go into this if/then section if there are any lights lit in the 1k - 9k range.
' The highest value light will be turned off and our score will be increased
' by 1000 times the multiplier value. We set the variable 'BonusCounted' to true to
' make sure that we only count once per timer cycle.

	If y1 <> 0 Then 		' If there are any 1k - 9k lights lit then y will not equal zero and we will proceede
   		Select Case y1
   			Case 9 										' counts the 9k light
      			LBonus9.State = 0:PlaySound"RTIIC_41"	' turns off the 9k light
   			Case 8 										' counts the 8k light
      			LBonus8.State = 0:PlaySound"RTIIC_41" 	' turns off the 8k light
   			Case 7 										' counts the 7k light
      			LBonus7.State = 0:PlaySound"RTIIC_41" 	' turns off the 7k light
   			Case 6 										' counts the 6k light
      			LBonus6.State = 0:PlaySound"RTIIC_41" 	' turns off the 6k light
   			Case 5 										' counts the 5k light
      			LBonus5.State = 0:PlaySound"RTIIC_41" 	' turns off the 5k light
   			Case 4 										' counts the 4k light
      			LBonus4.State = 0:PlaySound"RTIIC_41" 	' turns off the 4k light
   			Case 3 										' counts the 3k light
   		   		LBonus3.State = 0:PlaySound"RTIIC_41" 	' turns off the 3k light
   			Case 2 										' counts the 2k light
      			LBonus2.State = 0:PlaySound"RTIIC_41" 	' turns off the 2k light
   			Case 1 										' counts the 1k light
      			LBonus1.State = 0:PlaySound"RTIIC_41" 	' turns off the 1k light
   		End Select

'		If not Tilt then addscore 1000					' adds the counted bonus to our score and times it by the multiplier
		AddScore 1000,True										' adds the counted bonus to our score and times it by the multiplier (this line will be removed when the tilt mechanism is installed
		BonusCounted = True 							' we counted a 1's bonus so make sure we don't count a 10's bonus
	End If

	If x1 <> 0 and not BonusCounted Then 				' Only count a 10's bonus if we have some and have not counted a 1's bonus
   		Select Case x1
  			Case 10 									' If the 40k, 30k, 20k, and 10k lights are on then
       			LBonus1.State = 1 						' Turn on the 1k - 9k lights and turn off the 10k light
      			LBonus2.State = 1
      			LBonus3.State = 1
      			LBonus4.State = 1
      			LBonus5.State = 1
      			LBonus6.State = 1
      			LBonus7.State = 1
      			LBonus8.State = 1
      			LBonus9.State = 1
      			LBonus40.State = 1:PlaySound"RTIIC_41"	' Turn off the 10k light
      			LBonus30.State = 0
      			LBonus20.State = 0
				LBonus10.state = 0
   			Case 9										' If the 40k, 30k, and 20k light is on then
      			LBonus1.State = 1 						' Turn on the 1k - 9k lights and turn off the 10k light
      			LBonus2.State = 1
      			LBonus3.State = 1
      			LBonus4.State = 1
      			LBonus5.State = 1
      			LBonus6.State = 1
      			LBonus7.State = 1
      			LBonus8.State = 1
      			LBonus9.State = 1
      			LBonus40.State = 1:PlaySound"RTIIC_41"	' Turn off the 10k light
      			LBonus30.State = 1
      			LBonus20.State = 0
				LBonus10.state = 1
   			Case 8 										' If the 40k, 30k, and 10k lights are on then
      			LBonus1.State = 1 						' Turn on the 1k - 9k lights and turn off the 10k light
      			LBonus2.State = 1
      			LBonus3.State = 1
      			LBonus4.State = 1
      			LBonus5.State = 1
      			LBonus6.State = 1
      			LBonus7.State = 1
      			LBonus8.State = 1
      			LBonus9.State = 1
      			LBonus40.State = 1:PlaySound"RTIIC_41"	' Turn off the 10k light
      			LBonus30.State = 1
      			LBonus20.State = 1
				LBonus10.state = 0
   			Case 7 										' If the 40k and 30k light is on then
      			LBonus1.State = 1 						' Turn on the 1k - 9k lights and turn off the 10k light
      			LBonus2.State = 1
      			LBonus3.State = 1
      			LBonus4.State = 1
      			LBonus5.State = 1
      			LBonus6.State = 1
      			LBonus7.State = 1
      			LBonus8.State = 1
      			LBonus9.State = 1
      			LBonus40.State = 1:PlaySound"RTIIC_41"	' Turn off the 10k light
      			LBonus30.State = 0
      			LBonus20.State = 1
				LBonus10.state = 0
   			Case 6 										' If the 40k and 20k light is on then
      			LBonus1.State = 1 						' Turn on the 1k - 9k lights and turn off the 10k light
      			LBonus2.State = 1
      			LBonus3.State = 1
      			LBonus4.State = 1
      			LBonus5.State = 1
      			LBonus6.State = 1
      			LBonus7.State = 1
      			LBonus8.State = 1
      			LBonus9.State = 1
      			LBonus40.State = 1:PlaySound"RTIIC_41"	' Turn off the 10k light
      			LBonus30.State = 0
      			LBonus20.State = 0
				LBonus10.state = 1
   			Case 5 										' If the 40k and 10k light is on then
      			LBonus1.State = 1 						' Turn on the 1k - 9k lights and turn off the 10k light
      			LBonus2.State = 1
      			LBonus3.State = 1
      			LBonus4.State = 1
      			LBonus5.State = 1
      			LBonus6.State = 1
      			LBonus7.State = 1
      			LBonus8.State = 1
      			LBonus9.State = 1
      			LBonus40.State = 1:PlaySound"RTIIC_41"	' Turn off the 10k light
      			LBonus30.State = 0
      			LBonus20.State = 0
				LBonus10.state = 0
 			Case 4 										' If the 40k light is on then
      			LBonus1.State = 1 						' Turn on the 1k - 9k lights and turn off the 10k light
      			LBonus2.State = 1
      			LBonus3.State = 1
      			LBonus4.State = 1
      			LBonus5.State = 1
      			LBonus6.State = 1
      			LBonus7.State = 1
      			LBonus8.State = 1
      			LBonus9.State = 1
      			LBonus40.State = 0:PlaySound"RTIIC_41"	' Turn off the 10k light
      			LBonus30.State = 1
      			LBonus20.State = 0
				LBonus10.state = 0
  			Case 3 										' If the 30k light is on then
      			LBonus1.State = 1 						' Turn on the 1k - 9k lights and turn off the 10k light
      			LBonus2.State = 1
      			LBonus3.State = 1
      			LBonus4.State = 1
      			LBonus5.State = 1
      			LBonus6.State = 1
      			LBonus7.State = 1
      			LBonus8.State = 1
      			LBonus9.State = 1
      			LBonus40.State = 0:PlaySound"RTIIC_41"	' Turn off the 10k light
      			LBonus30.State = 0
      			LBonus20.State = 1
				LBonus10.state = 0
   			Case 2 							' If the 20k Light is on then
      			LBonus1.State = 1 						' Turn on the 1k - 9k lights and turn off the 10k light
      			LBonus2.State = 1
      			LBonus3.State = 1
      			LBonus4.State = 1
      			LBonus5.State = 1
      			LBonus6.State = 1
      			LBonus7.State = 1
      			LBonus8.State = 1
      			LBonus9.State = 1
      			LBonus40.State = 0:PlaySound"RTIIC_41"	' Turn off the 10k light
      			LBonus30.State = 0
      			LBonus20.State = 0
				LBonus10.state = 1
   			Case 1 							' If the 10k Light is on then
      			LBonus1.State = 1 						' Turn on the 1k - 9k lights and turn off the 10k light
      			LBonus2.State = 1
      			LBonus3.State = 1
      			LBonus4.State = 1
      			LBonus5.State = 1
      			LBonus6.State = 1
      			LBonus7.State = 1
      			LBonus8.State = 1
      			LBonus9.State = 1
      			LBonus40.State = 0:PlaySound"RTIIC_41"	' Turn off the 10k light
      			LBonus30.State = 0
      			LBonus20.State = 0
				LBonus10.state = 0
   		End Select

		'If not Tilt then AddScore 1000							' adds the counted bonus to our score
		AddScore 1000,True	
		BonusCounted = True
	End If

	Bonus = Bonus - 1 							' subtract the bonus we just counted from the total bonus
	
	BonusTimer.Interval = 60
 
 	If Tilt then
 		x1 = 0
 		y1 = 0
 	End If
	
	If x1 = 0 And y1 = 0  Then 						' Have we counted all the bonus?
 		CheckMulti()								' If so, check the multiplier
	End If

End Sub ' End of Sub BonusTimer_Timer

' AddBonus: Adds 1k bonus to the bonus counter and change the lights
' The control routine for adding a bonus to your score
' Note the two variables, the "x1" handles the 10, 20, 30, and 40 lights
' The "y1" variable is for the 1 to 9 lights


Sub AddBonus() 

 
    Bonus = Bonus + 1							' This increases Bonus by one
    If Bonus > 109 Then							' But don't go over 109k bonus
       Bonus = 109								' Make sure it will stay at 109
       AddScore 1000,True						' Award 1000 points instead
    End If
 	HoldBonus = Bonus							' Store the bonus for purposes of the multiplier
    AddBonusLights()							' Update the bonus lights	
	If Bonus mod 10 = 0 and GameMode <> 2 then AdvanceZone()		' Advance 1 Zone for every 10K bonus accumulated					
    
End Sub

' This sub updates the bonus lights

Sub AddBonusLights() 
    
    x1 = Int(bonus/10) 							' 10's bonus digit
	y1 = bonus Mod 10 						' 1's bonus digit
	
    If y1 = 0 Then							' Turn off the lights
       LBonus1.State = 0
       LBonus2.State = 0
       LBonus3.State = 0
       LBonus4.State = 0
       LBonus5.State = 0
       LBonus6.State = 0
       LBonus7.State = 0
       LBonus8.State = 0
       LBonus9.State = 0
    End If

' This makes sure the proper light is turned on with the proper bonus    
    If y1 >= 1 Then LBonus1.State = 1
    If y1 >= 2 Then LBonus2.State = 1
    If y1 >= 3 Then LBonus3.State = 1
    If y1 >= 4 Then LBonus4.State = 1
    If y1 >= 5 Then LBonus5.State = 1
    If y1 >= 6 Then LBonus6.State = 1
    If y1 >= 7 Then LBonus7.State = 1
    If y1 >= 8 Then LBonus8.State = 1
    If y1 = 9 Then LBonus9.State = 1
    
    LBonus10.State = 0
    LBonus20.State = 0
    LBonus30.State = 0
    LBonus40.State = 0

' This makes sure the proper "10" light is turned on with the proper bonus    
    If x1 = 1 Then LBonus10.State = 1
    If x1 = 2 Then LBonus20.State = 1
    If x1 = 3 then LBonus30.State = 1
    If x1 = 4 then LBonus40.State = 1
    If x1 = 5 then						' If Bonus is 50, turn on the 40k and 10k lights
    	LBonus40.State = 1
    	LBonus10.State = 1
    End If
    If x1 = 6 then						' If Bonus is 60, turn on the 40k and 20k lights
    	LBonus40.State = 1
    	LBonus20.State = 1
    End If
    If x1 = 7 then						' If Bonus is 70, turn on the 40k and 30k lights
    	LBonus40.State = 1
    	LBonus30.State = 1
    End If
    If x1 = 8 then						' If Bonus is 80, turn on the 40k, 30k, and 10k lights
    	LBonus40.State = 1
    	LBonus30.State = 1
    	LBonus10.State = 1
    End If
    If x1 = 9 then						' If Bonus is 90, turn on the 40k, 30k, and 20k lights
    	LBonus40.State = 1
    	LBonus30.State = 1
    	LBonus20.State = 1
    End If
    If x1 = 10 Then						' If bonus is "100", turn on all four lights
       LBonus10.State = 1
       LBonus20.State = 1
       LBonus30.State = 1
       LBonus40.State = 1
    End If

End Sub 


' This resets the Bonus lights for the start of each new ball in play
' Multiplier lights turned off when TAdvMultCount() called at BonusTimer_Timer() sub

Sub ResetBonus()

    LBonus1.State = 1							'Turns 1k Light back on after bonus collected
    LBonus2.State = 0
    LBonus3.State = 0
    LBonus4.State = 0
    LBonus5.State = 0
    LBonus6.State = 0
    LBonus7.State = 0
    LBonus8.State = 0
    LBonus9.State = 0
    LBonus10.State = 0
    LBonus20.State = 0
	LBonus30.State = 0
	LBonus40.State = 0
    AdvanceMultiplier 0							' Resets Multiplier to 1    
    Bonus = 1									' Reset Bonus Count to 1
    BonusTimer.Interval = 300
    
End Sub ' End of Sub ResetBonus

' Advances the bonus multiplier and sets the appropriate light
'
' Parameter
'
' Inc = Tells the sub how much we're advancing the multiplier. The multiplier cannot be advanced past the predefined maximum (defined by the constant MaxBonusMult)
'       Pass a 0 to the sub if we need to reset
'		The sub takes the absolute value, so if a -1 is passed, the multiplier will still advance by 1		
'

Sub AdvanceMultiplier(ByVal Inc)

Dim Increment									' How much we're bumping the multiplier

	If Inc = 0 then
		BonusMultiplier(Player) = 1				' Reset back to 1
	Else
		If GameMode <> 2 then 
			AdvanceZone()						' Advance to the next Zone if we're not in multiball
		Else
			AdvanceBattleZone 0.5				' Advance Battle Zone by 0.5 if we are in multiball
		End If
		Increment = Abs(Inc)					' Make sure we're dealing with a positive increment
		If (Increment + BonusMultiplier(Player)) > cMaxBonusMult then 
			BonusMultiplier(Player) = cMaxBonusMult
		Else
			BonusMultiplier(Player) = BonusMultiplier(Player) + Increment
		End If
		StopSound"Boost"
		PlaySound "Barrel Roll"				' play one sound regardless of the multiplier
	End If
	Select Case BonusMultiplier(Player)
	Case 1
		LBonus2x.State = 0
		LBonus3x.State = 0
		LBonus4x.State = 0
		LBonus5x.State = 0
		LBonus6x.State = 0
	Case 2
		LBonus2x.State = 1
		AddScore 5000,True	
	Case 3
		LBonus2x.State = 1
		LBonus3x.State = 1
		AddScore 5000,True	
	Case 4
		LBonus2x.State = 1
		LBonus3x.State = 1
		LBonus4x.State = 1
		AddScore 5000,True	
	Case 5
		LBonus2x.State = 1
		LBonus3x.State = 1
		LBonus4x.State = 1
		LBonus5x.State = 1
		AddScore 5000,True	
	Case 6
		LBonus2x.State = 1
		LBonus3x.State = 1
		LBonus4x.State = 1
		LBonus5x.State = 1
		LBonus6x.State = 1
		AddScore 5000,True
	End Select

End Sub

' Sub SetFieldMultiplier. This sets the Field Multiplier to a value vetween 1 and 3
'
' Parameters
'
' FieldX : The number we're setting the multiplier to
' GenPlay: This is True if we get here via clearing the EG-X and Goteki drop targets in the same ball
' Timed: This is true if we're setting a time limit for the playfield multiplier.

Sub SetFieldMultiplier(FieldX,GenPlay,Timed)

	If FieldX < 1 then FieldX = 1				' Make certain the new multiplier is set to a value no less than 1 nor higher than 6
	If FieldX > 6 then FieldX = 6
	FieldMultiplier = FieldX					' Set the Field Multiplier to the parameter value
	FldMultGenPlay = GenPlay					' Set the general-play indicator according to the Gen Play parameter
	If FldMultGenPlay Then 
		PrevFieldMultiplier = FieldMultiplier
	Else
		PrevFieldMultiplier = 1
	End If
	If FieldXReset.Enabled and GameMode <> 2 then FieldXReset.Enabled = False
	Select Case FieldX
	Case 1										' 1x Scores = both table multiplier lights should be off
		LField2x.State = 0
		LField3x.State = 0
		FieldXReset.Enabled = False
		FieldXReset.Interval = 30000		
	Case 2										' 2x Scores = Only the All Scores 2x light should be lit
		If not Timed then 
			LField2x.State = 1
			LField3x.State = 0
		Else
			LField2x.State = 2
			LField3x.State = 0
			FieldXReset.Enabled = True			' Start reset timer (default 30 seconds)
		End If
	Case 3										' 3x Scores = Only the All Scores 3x light should be lit
		If not Timed then
			LField2x.State = 0
			LField3x.State = 1
		Else
			LField2x.State = 0
			LField3x.State = 2
			FieldXReset.Enabled = True			' Start reset timer (default 30 seconds)
		End If
	Case 6										' 6x Scores = Both All Scores 2x and All Scores 3x are lit
		If not Timed then
			LField2x.State = 1
			LField3x.State = 1
		Else
			LField2x.State = 2
			LField3x.State = 2
			FieldXReset.Enabled = True			' Start reset timer (default 30 seconds)
		End If
	End Select

End Sub

' This is called when we're resetting a timed field multiplier after the timer expires

Sub ResetFieldMultiplier()

	If GameMode <> 2 Then
		SetFieldMultiplier 1,True,False
	Else
		If JackpotsThisMB(Player) < 2 then SetFieldMultiplier 2,False,False
		If JackpotsThisMB(Player) >= 2 then SetFieldMultiplier 3,False,False		' Set 3x All Scores at 2 jackpots in the same multiball		
		If JackpotsThisMB(Player) >= 5 then SetFieldMultiplier 6,False,False		' Set 6x All Scores at 5 jackpots in the same multiball
	End If

End Sub

Sub FieldXReset_Timer()

	FieldXReset.Enabled = False
	FieldXReset.Interval = 30000
	ResetFieldMultiplier()

End Sub

'********************************************
' *** Routine used to count by Multiplier in Bonus Countdown ***
'********************************************
' This routine checks for the multiplier, and calls the AdvanceMultCount to
' count by each mult value

Sub CheckMulti()

 	If BonusMultiplier(player) > 0 then
   		Bonus = HoldBonus
   		AdvanceMultCount()						' Start a new count by Multiplier
   	End If
 
 	If BonusMultiplier(player) = 0 then
 		ResetBonus()
 		BonusTimer.Enabled = False 				' turn off the timer
 		BallRelease.TimerEnabled = True
   	End If 
 
End Sub ' end sub CheckMulti()

'********************************************
' this counts each bonus by the mult value

Sub AdvanceMultCount()
 			
  	If BonusMultiplier(player) = 6 Then			' If Multiplier
 		LBonus6x.State = 0						' Turn off 5x light
 		AddBonusLights()
 	End If
  	If BonusMultiplier(player) = 5 Then			' If Multiplier
 		LBonus5x.State = 0						' Turn off 5x light
 		AddBonusLights()
 	End If
   			
 	If BonusMultiplier(player) = 4 then 
 		LBonus4x.State = 0						' Turn off 4x light
 		AddBonusLights()
 	End If
 	
	If BonusMultiplier(player) = 3 Then
	   	LBonus3x.State = 0						' Turn off 3x light
		AddBonusLights()
	End If

	If BonusMultiplier(player) = 2 Then
	   	LBonus2x.State = 0						' Turn off 2x light
		AddBonusLights()
	End If
			
	If BonusMultiplier(player) = 1 then
		AddBonusLights()
	End If

	BonusMultiplier(player) = BonusMultiplier(player) - 1						' decrease multiplier by one!
			
End Sub ' End of Sub AdvanceMultCount

' ************************* Light-Handler Section ***********************

' Lane-Change Subs

' This sub moves the ABC lights left

Dim TempFlag

Sub ShiftABCDLeft()

	TempState = L9.State
	L9.State = L8.State
	L8.State = L7.State
	L7.State = L6.State	
	L6.State = TempState

	TempFlag = ALit(Player)
	ALit(Player) = BLit(Player)
	BLit(Player) = CLit(Player)
	CLit(Player) = DLit(Player)
	DLit(Player) = TempFlag

'	If L9.State = 1 then 
'		ALit(Player) = True
'	Else
'		ALit(Player) = False
'	End If
'	If L8.State = 1 then 
'		BLit(Player) = True
'	Else
'		BLit(Player) = False
'	End If
'	If L7.State = 1 then 
'		CLit(Player) = True
'	Else
'		CLit(Player) = False
'	End If
'	If L6.State = 1 then 
'		DLit(Player) = True
'	Else
'		DLit(Player) = False
'	End If

End Sub

' This sub moves the ABC lights right

Sub ShiftABCDRight()

	TempState2 = L6.State
	L6.State = L7.State
	L7.State = L8.State
	L8.State = L9.State
	L9.State = TempState2

	TempFlag = DLit(Player)
	DLit(Player) = CLit(Player)
	CLit(Player) = BLit(Player)
	BLit(Player) = ALit(Player)
	ALit(Player) = TempFlag

'	If L9.State = 1 then 
'		ALit(Player) = True
'	Else
'		ALit(Player) = False
'	End If
'	If L8.State = 1 then 
'		BLit(Player) = True
'	Else
'		BLit(Player) = False
'	End If
'	If L7.State = 1 then 
'		CLit(Player) = True
'	Else
'		CLit(Player) = False
'	End If
'	If L6.State = 1 then 
'		DLit(Player) = True
'	Else
'		DLit(Player) = False
'	End If

End Sub

Sub ShiftInOutLeft()

	TempState3 = LFeisarF.State
	LFeisarF.State = LFeisarE.State
	LFeisarE.State = LFeisarI.State
	LFeisarI.State = LFeisarS.State
	LFeisarS.State = TempState3

End Sub

' This one moves the inlane/outlane lights left

Sub ShiftInOutRight()

	TempState4 = LFeisarS.State
	LFeisarS.State = LFeisarI.State
	LFeisarI.State = LFeisarE.State
	LFeisarE.State = LFeisarF.State
	LFeisarF.State = TempState4

End Sub

' *********************************************************************
' Special - these subs control the Special
' *********************************************************************

Sub InitSpecial()

	For z1 = 1 to 4
		SpecialLit(z1) = False
	Next
	LSpecial1.State = 0
	LSpecial2.State = 0

End Sub

Sub LightSpecial()

	SpecialLit(player) = True
	z1 = Int (10*Rnd)
	If z1 < 5 then
		LSpecial1.State = 1
	Else
		LSpecial2.State = 1
	End If

End Sub

Sub SwitchSpecial()

	If LSpecial1.State = 1 then
		LSpecial1.State = 0
		LSpecial2.State = 1
	Else
		LSpecial2.State = 0
		LSpecial1.State = 1
	End If

End Sub

Sub AwardSpecial()

	SpecialLit(player) = False
	LSpecial1.State = 0
	LSpecial2.State = 0
	AddCreditTimer.Interval = 50
	AddCredits 1

End Sub

Sub SpecialOff()

	SpecialLit(player) = False
	LSpecial1.State = 0
	LSpecial2.State = 0

End Sub

' **************************** Extra Ball Section *************************************

' These subs deal with the awarding of extra balls

' This sub lights the Piranha lower kicker for an extra ball

Sub LightExtraBall()

	PlaySound"Energy Critical Beep"
	ExtraBallLit(player) = ExtraBallLit(player) + 1		' Set the internal indicator
	LXBall.State = 2									' turn on the extra-ball light
	PiranhaDiverter1.RotateToEnd						' Open the diverter 
	If GameMode <> 2 then SeqFlashersBotLeft.Play SeqBlinking,,45,5									' Play the left flashers on ramp shot completion except in multiball

End Sub

' This sub awards an extra ball

Sub AwardExtraBall()

	PlaySound"LB_XBALL"
	If OptTournament = 0 and ExtraBallsGame(Player)<OptMaxEBGame and ExtraBallsBIP(Player)<OptMaxEBBIP Then		' Tournament mode? Have we reached the Max EBs for the game?
		ExtraBallLit(player) = ExtraBallLit(Player) - 1															' set the extra-ball-lit indicato
		If ExtraBallLit(Player) <= 0 then 
			ExtraBallLit(Player) = 0
			LXBall.State = 0																							' turn the extra-ball light off
		End If
		If not BallSaverTimer.Enabled then DisplaySA()															' Indicate the extra ball on the ball save dfisplay
		ExtraBalls = ExtraBalls + 1																				' Hey, we got an extra ball...add 1 to the extra-ball counter
		ExtraBallsGame(Player) = ExtraBallsGame(Player) + 1
		If OptMaxEBBIP < 10 then ExtraBallsBIP(Player) = ExtraBallsBIP(Player) + 1
	Else
		If not Tilt then AddScore 100000,True																	' If we're in tournamnet mode, or we've reched an extra-ball limit, score 100,000 for an extra ball instead
		ExtraBallLit(player) = ExtraBallLit(Player) - 1															' set the extra-ball-lit indicato
		If ExtraBallLit(Player) <= 0 then 
			ExtraBallLit(Player) = 0
			LXBall.State = 0																							' turn the extra-ball light off
		End If
		ExtraBalls = ExtraBalls + 1																				' Hey, we got an extra ball...add 1 to the extra-ball counter
		ExtraBallsGame(Player) = ExtraBallsGame(Player) + 1
	End If
	If OptDebugMode = 0 then StatExtraBalls = StatExtraBalls + 1											' Update the statistic

End Sub

' This initializes the extra ball feature at the start of the game

Sub InitExtraBall()					

	For z1 = 1 to 4
		ExtraBallLit(z1) = 0
	Next
	LSA.State = 0
	LSA2.State = 0
	LXBall.State = 0
	ExtraBalls = 0
	PiranhaDiverter1.RotatetoStart

End Sub

Sub ExtraBallTimer_Timer()

	ExtraBallTimer.Enabled = False
	AwardExtraBall()

End Sub

' ************************************ Multiball Section **********************************
'
' This section is for Zone Battle Multiball and all the subs and timers associated with it.
'
' All scoring events specific to the multiball (i.e. Barrier hits and zone boost jackpots) are not subject to the Field Multiplier, as the Field Multiplier is 2x minimum during multiball
'
' This initializes the multiball feature for start of game

Sub InitializeMultiball()

	For z1 = 1 to 4
		LocksLit(z1) = False											' make sure the locks-lit indicators are false at game start
		Lock1Ready(z1) = False
		Lock2Ready(z1) = False
		Lock3Ready(z1) = False
		BallsLocked(z1) = 0												' we don't have any balls locked at game start, so this is 0
		MBThisGame(z1) = 0												' No one has played any mutiballs yet, so these are 0
		ZoneBoostJackpots(z1) = 0
		JackpotsThisMB(z1) = 0
	Next
	LLock1.State = 0: LLock2.State = 0: LLock3.State = 0	' Turn off all lock lights on table
	LockingBall = False

End Sub

' This sub checks the lock status for the current player. Used at the start of each ball/player

Sub CheckLockStatus()

	LLock1.State = 0
	LLock2.State = 0
	LLock3.State = 0
	If LocksLit(Player) <> 0 then
	Select Case LocksLit(player)
	Case 1
		If Lock1Ready(player) then
			LLock1.State = 2
		Else
			LLock1.State = 1
		End If
	Case 2
		If Lock1Ready(player) then
			LLock1.State = 2
		Else
			LLock1.State = 1
		End If
		If Lock2Ready(player) then
			LLock2.State = 2
		Else
			LLock2.State = 1
		End If
	Case 3
		If Lock1Ready(player) then
			LLock1.State = 2
		Else
			LLock1.State = 1
		End If
		If Lock2Ready(player) then
			LLock2.State = 2
		Else
			LLock2.State = 1
		End If
		If Lock3Ready(player) then
			LLock3.State = 2
		Else
			LLock3.State = 1
		End If
	End Select
	Else
		LLock1.State = 0						' Turn off all lock lights on table
		LLock2.State = 0
		LLock3.State = 0
	End If
	
	
End Sub

' Activates the locks for multiball

Sub Activate3Locks()

	PiranhaDiverter1.RotateToEnd
	SeqFlashersBotLeft.Play SeqBlinking,,45,3									' Play the left flashers when lock is lit
	PlaySound "Lock Lit"
	If LocksLit(player) < 3 then
		Select Case LocksLit(player)
		Case 0
			LocksLit(player) = 3
			LLock1.State = 2: LLock2.State = 2: LLock3.State = 2
			Lock1Ready(player) = True:Lock2Ready(player) = True:Lock3Ready(player) = True
		Case 1
			LocksLit(player) = 3
			LLock2.State = 2: LLock3.State = 2
			Lock2Ready(player) = True:Lock3Ready(player) = True
		Case 2
			LocksLit(player) = 3
			LLock3.State = 2
			Lock3Ready(player) = True
		End Select
	Else
		Exit Sub
	End If

End Sub

Sub Activate1Lock()

	PiranhaDiverter1.RotateToEnd
	SeqFlashersBotLeft.Play SeqBlinking,,45,3									' Play the left flashers when lock is lit
	PlaySound "Lock Lit"
	LocksLit(player) = LocksLit(Player) + 1
	NextLock(Player) = NextLock(Player) + 1
	Select Case NextLock(Player)
	Case 1
		LLock1.State = 2
		Lock1Ready(player) = True
	Case 2
		LLock2.State = 2
		Lock2Ready(player) = True
	Case 3
		LLock3.State = 2
		Lock3Ready(player) = True
	End Select

End Sub

' This will deactivate the locks for multiball. Useful when changing players or when the game ends

Sub Deactivate3Locks()

	If ExtraBallLit(Player) = 0 then PiranhaDiverter1.RotateToStart
	LocksLit(player) = 0
	LLock1.State = 0: LLock2.State = 0: LLock3.State = 0
	Lock1Ready(player) = False:Lock2Ready(player) = False:Lock3Ready(player) = False

End Sub

' This locks a ball. Multiball starts when three balls are locked

Sub LockBall()

	BallsLocked(Player) = BallsLocked(Player) + 1					' Bump the balls-locked counter by 1
	BallsInLockKicker = 0											' We're not ejecting a ball from the Piranha Lock...set this back to 0
	BallTimer.Enabled = False
	Select Case BallsLocked(Player)
	Case 1
		PlaySound "Lock 1"
		LLock1.State = 1											' 1 ball locked: Set LockLight1 to steady on and kick another ball onto the plunger
		Lock1Ready(Player) = False
		BallReleaseMultiball.Enabled = True
		If BallSaverTimer.Enabled then BallSaverTimer.Enabled = False
		If not Lock2Ready(Player) then PiranhaDiverter1.RotateToStart
	Case 2
		PlaySound "Lock 2"
		LLock2.State = 1											' 2 balls locked: Set LockLight2 to steady on and kick another ball onto the plunger
		Lock2Ready(Player) = False
		BallReleaseMultiball.Enabled = True
		If BallSaverTimer.Enabled then BallSaverTimer.Enabled = False
		If not Lock3Ready(Player) then PiranhaDiverter1.RotateToStart
	Case 3
		PlaySound "Lock 3"
		LLock3.State = 1											' 3 balls locked: Set LockLight3 to steady on and turn on the timer to start multiball
		Lock3Ready(Player) = False
		PiranhaDiverter1.RotateToStart
		StartMultiballTimer.Enabled = True
		PiranhaLock1.TimerEnabled = False							' make sure we don't get any balls ejecting from the Piranha Lock if we're starting multiball
	End Select

End Sub

' This kicks a ball onto the plunger after we lock a ball

Sub BallReleaseMultiball_Timer()

	BallReleaseMultiball.Enabled = False							' turn off the BallRelease multiball timer
	AddScore 25000,True												' Add some points for locking a ball
	AddBonus														' Advance the bonus by 1
	BallRelease.CreateBall											' kick a ball from the plunger
	BallRelease.Kick 90,7
'	PlaySound"ballrelease"
	PlaySound SoundFXDOF("ballrelease",127,DOFPulse,DOFContactors)			' DOF 127 = ball release?
	AutoPlunger.TimerEnabled = True

End Sub

' This fires the autoplunger when we've saved a ball from draining

Sub Autoplunger_Timer()

	Autoplunger.TimerEnabled = False
	AutoPlunger.Fire
'	PlaySound"Plunger"
	PlaySound SoundFXDOF("Plunger", 123, DOFPulse, DOFcontactors),0,1,0.25,0.25

End Sub

' This timer sub initiates the multiball when it fires. This is only activated after we've locked 3 balls

Sub StartMultiballTimer_Timer()

	StartMultiballTimer.Enabled = False								' We're starting multiball - turn the start-multiball timer off
	LocksLit(player) = 0											' Locks are no longer lit for the current player
	LLock1.State = 0												' Turn off the lock lights
	LLock2.State = 0
	LLock3.State = 0
	BallCount = 3													' Set the number of balls in play to 3 at multiball start
	BallsToRelease(1) = BallsLocked(player)							' We're releasing however many balls we've locked
	BallsLocked(player) = 0											' Multiball starting: Set the number of balls locked back to 0
	LLeft2Zones_Timer():LRight2Zones_Timer()						' Turn off the 2-zones lights for multiball
	GameMode = 2													' "All Hands, Prepare For Multiball!" (From ST:TNG)
	If MBThisGame(Player) = 0 then
		BattleZone(player) = 0.1			' Set the Battle Zone to 0.1 at the start of multiball
	Else
		If JackpotsthisMB(Player) <> 0 then BattleZone(Player) = Round((BattleZone(Player)/2),1)
	End If
	PiranhaDiverter2.RotateToEnd
	MBReleaseTimer.Interval = 3050
	Select Case OptGameMusic
	Case 0
	Case 1,2,3
		MusicTrack = 7
		StopAllMusic()
		ZoneFuryMusic
		PlaySound"multiballstart"										' Play a sound announcing we're starting multiball
		MBReleaseTimer.Enabled = True									' start the timer to release the hounds
	Case 4
		PrevTrack = MusicTrack
		StopAllMusic
		PlaySound"multiballdelay"
		SelectingMusic = True
		If ZoneFury.ShowDT then
			CredText1.Text = "Multiball: Flippers Change Music"
		Else
			CredText1FS.Text = "Multiball: Flippers Change Music"
		End If
		DisplayTrack
		MBMusicDelayTimer.Enabled = True
	End Select
	SeqZoneLights.Play SeqAllOff
	LBattleZone.State = 2
	BZoneAccum = 0													' Zero out the accumulator for the start of multiball
	ZoneBoostReady(0) = False: ZoneBoostReady(1) = False			' Set both Zone Boost indicators for the ramps to false
	AdvanceBattleZone 0
	ZoneComma_3.State = 1											' turn on the decimal point in the Zone display
	ZoneTriggersOff()												' Disable boost pads during multiball
	TargetsHit = 0
	MBThisGame(Player) = MBThisGame(Player) + 1						' Add 1 to multiball counter for player this game
	If FieldMultiplier = 1 then	SetFieldMultiplier 2,False,False	' If we're still at 1x scores at the start of multiball, set all scores to 2x and set the indicator to restore 1x at the end of multiball
	BallSaverSec = 0: BallSaver10ths = 0:BallSaverTimer_Timer()
	BallSaverLightTimer_Timer()										' Ensure the start-of-ball Ball Saver is off when we start multiball
	If OptMBBallSaverTime <> 0 then ActivateMultiballBallSaver()	' Activate the Multiball Ball Saver if enabled
	If OptDebugMode = 0 then StatZoneBattleMultiballs = StatZoneBattleMultiballs + 1


End Sub

' This kicks the balls out into play one at a time

Sub MBReleaseTimer_Timer()

	MBReleaseTimer.Interval = 1250
	PiranhaLock2.CreateBall										' Restore a ball...it's coming back into play
	PiranhaLock2.Kick 320,45									' kick a ball back into play towards the top
'	PlaySound"solenoid"											' Play the sound
	PlaySound SoundFXDOF("solenoid",131,DOFPulse,DOFContactors),0,.75,0,0.25
	BallsToRelease(1) = BallsToRelease(1) - 1					' Reduce the number of balls we're releasing by 1
	FlashersMultiball()											' Start multiball pattern for the flashers
	If BallsToRelease(1) = 0 then 
		MBReleaseTimer.Enabled = False							' If the balls to release is 0, don't release any more
		PiranhaDiverter2.TimerEnabled = True
		RaiseBarrierTimer.Interval = 15000						' Raise the first Barrier 10 seconds after the start of multiball
		RaiseBarrierTimer.Enabled = True						' Start the timer to raise the first barrier
		JackpotsThisMB(Player) = 0
		If OptMBBallSaverTime <> 0 then 
			StartBallSaver										' Start the clock running for the multiball ball saver
			BallSaverLightTimer.Interval = 3000					' Set a 3.0-second grace period for ball saves in multiball
		End If
	End If

End Sub

Sub MBMusicDelayTimer_Timer()

	MBMusicDelayTimer.Enabled = False
	ResetMusicChoices
	ZoneFuryMusicChoiceAll()										' Start selected music track for multiball
	PlaySound"multiballstart"										' Play a sound announcing we're starting multiball
	MBReleaseTimer.Enabled = True									' Start the timer to release the hounds

End Sub

Sub PiranhaDiverter2_Timer()

	PiranhaDiverter2.TimerEnabled = False
	PiranhaDiverter2.RotateToStart							' Close the diverter

End Sub

Sub PiranhaLock2_Hit()

	PiranhaDiverter2.TimerEnabled = False
	PiranhaDiverter2.RotateToEnd
	PiranhaLock2.DestroyBall
	PiranhaLock2.TimerEnabled = True

End Sub

Sub PiranhaLock2_Timer()

	PiranhaLock2.TimerEnabled = False
	PiranhaLock2.CreateBall
	PiranhaLock2.Kick 320,45
	PiranhaDiverter2.TimerEnabled = True

End Sub

' This timer sub raises a Barrier. Barriers start to appear 15 seconds after the start of multiball, and 5-10 seconds after we attain a Zone Boost Jackpot

Sub RaiseBarrierTimer_Timer()

	RaiseBarrierTimer.Enabled = False						' Turn off the timer to raise the barrier
	PlaySound"Barrier"
	If Int(10*Rnd) mod 2 = 0 then							' Randomly determine which Barrier to raise
		BarrierLeft.IsDropped = False
		LLeftBarrier.State = 2
	Else
		BarrierRight.IsDropped = False
		LRightBarrier.State = 2
	End If
	HitsToClearBarrier = 1 + JackpotsThisMB(Player)					' Set the number of hits to clear based on how many Zone Boosts we've attained this multiball
	If HitsToClearBarrier > 5 then HitsToClearBarrier = 5	' But, do not go over 5 hits

End Sub

' This sub advances the Battle Zone by the amount indicated by the Inc parameter. It also adds to the Battle Zone accumulator counter used in calculating
' the amount of Zones Boosted

Sub AdvanceBattleZone(ByVal Inc)

Dim BZtoDisplay																' Internal variable to set up the display since we don't want to mess with the actual Battle Zone value

	If (BattleZone(player)+Inc) < 20.0 then									' At max battle Zone yet?
		BattleZone(player) = BattleZone(player) + Inc							' If not, bump the Battle Zone by the increment
		BZoneAccum = BZoneAccum + Inc										' Bump the total accruals in case we get a Zone Boost
	Else
		BattleZone(player) = 20.0											' Make sure we don't go over Battle Zone 20
		BZoneAccum = 0														' Zero out the accumulator when at battle Zone 20
	End If
	GetBattleZone()															' Get the GI colors colors based on the battle zone
	BattleZone(player) = Round(BattleZone(player),1)						' Make certain we're passing a value with one and only one decimal point
	BZToDisplay = BattleZone(player) * 10									' Prep to display the current Battle Zone
	If BZToDisplay < 10 then BZToDisplay = "0" & BZToDisplay				' Tack on a leading zero if needed (0.x)
	If not ZoneBoostDisplayFlash.Enabled then DisplayZone BZToDisplay		' Display the current Battle Zone on the Zone display
	
End Sub

' This determines the colors of the GI lights for the battle Zone

Sub GetBattleZone

Dim oLight

	If BattleZone(Player) <= 1.9 then 
		For Each oLight in GI_Color
			oLight.Color = RGB(0,140,140)
			oLight.ColorFull = RGB (0,251,251)
		Next
	End If

	If BattleZone(Player) >= 2.0 and BattleZone(Player) <= 3.9 then 
		For Each oLight in GI_Color
			oLight.Color = RGB(146,69,0)
			oLight.ColorFull = RGB (221,111,0)
		Next
	End If

	If BattleZone(Player) >= 4.0 and BattleZone(Player) <= 5.9 then 
		For Each oLight in GI_Color
			oLight.Color = RGB(150,0,150)
			oLight.ColorFull = RGB (252,0,252)
		Next
	End If

	If BattleZone(Player) >= 6.0 and BattleZone(Player) <= 7.9 then 
		For Each oLight in GI_Color
			oLight.Color = RGB(176,54,0)
			oLight.ColorFull = RGB (255,83,0)
		Next
	End If

	If BattleZone(Player) >= 8.0 and BattleZone(Player) <= 9.9 then 
		For Each oLight in GI_Color
			oLight.Color = RGB(136,106,60)
			oLight.ColorFull = RGB (253,207,25)
		Next
	End If

	If BattleZone(Player) >= 10.0 and BattleZone(Player) <= 11.9 then 
		For Each oLight in GI_Color
			oLight.Color = RGB(207,203,148)
			oLight.ColorFull = RGB (0,255,255)
		Next
	End If

	If BattleZone(Player) >= 12.0 and BattleZone(Player) <= 13.9 then 
		For Each oLight in GI_Color
			oLight.Color = RGB(107,103,75)
			oLight.ColorFull = RGB (0,236,236)
		Next
	End If

	If BattleZone(Player) >= 14.0 and BattleZone(Player) <= 15.9 then 
		For Each oLight in GI_Color
			oLight.Color = RGB(207,203,148)
			oLight.ColorFull = RGB (255,0,0)
		Next
	End If

	If BattleZone(Player) >= 16.0 and BattleZone(Player) <= 17.9 then 
		For Each oLight in GI_Color
			oLight.Color = RGB(32,32,32)
			oLight.ColorFull = RGB (250,60,70)
		Next
	End If

	If BattleZone(Player) >= 18.0 then 
		For Each oLight in GI_Color
			oLight.Color = RGB(32,32,32)
			oLight.ColorFull = RGB (255,255,255)
		Next
	End If

End Sub

' Sub AwardZoneBoost
'
' This sub does two things.
'
' 1) Awards the Zone Boost Jackpot (50,000 points x the current Battle Zone. If the BattleZone is < 1, the jackpot is still 50,000)
' 2) Bumps the Battle Zone by the sum total of all accumulations up until this award.
'
' Once a Zone Boost Jackpot is awarded, the total accumulations will be reset to 0 until the next Zone Boost Jackpot
' This will give the ZOne Boost Jackpot a range of 50,000-1,000,000 points.
' Additionally, the Battle Zone counter resets after a Zone Boost Jackpot is attained at Battle Zone 20.0

Dim BatZone																		' Integer portion of Battle Zone
Dim BatZoneDec																	' Decimal portion of Battle Zone

Sub AwardZoneBoost()

	If not Tilt then
		BatZone = Int(BattleZone(Player))
		BatZoneDec = Round(10*(BattleZone(Player)-BatZone),0)
		BZDisplayFlash = BattleZone(player) * 10
		If OptDebugMode = 0 Then
			StatZoneBoostJackpots = StatZoneBoostJackpots + 1
			If BattleZone(Player) > StatHighBatZoneWon then 
				StatHighBatZoneWon = BattleZone(Player)
				If BattleZone(Player) > StatHighBatZone then StatHighBatZone = BattleZone(Player)
			End If
		End If
		ZoneBoostDelay1.Enabled = True											' Start timer sequence for zone boost jackpot callout
		ZoneBoostDisplayFlash.Enabled = True									' Flash the Zone display 
		SeqFlashersAll.Play SeqBlinking,,100,4									' Start a lightshow for scoring a jackpot (flashers and playfield lights)
		PlayfieldSeq.Play SeqBlinking,,100,4
		If BattleZone(player) <= 1 then
			AddScore 50000,False												' If the Battle Zone is 1 or less, the Jackpot is 50,000
		Else
			AddScore (50000 * Round(BattleZone(Player),1)),False				' Otherwise, the Jackpot is 50,000 * the current Battle Zone. Do NOT apply the Field multiplier to the jackpot
		End If
		ZoneBoostJackpots(player) = ZoneBoostJackpots(Player) + 1				' Tack on one more Zone Boost jackpot this game
		JackpotsThisMB(Player) = JackpotsThisMB(Player) + 1						' Do the same to the Jackpots this multiball counter
		If ZoneBoostJackpots(player) = 2 then 									' Did we hit 2 this game?
			If not MirageWon(player) then AwardMirageDelay.Enabled = True		' If we did, award the Mirage sponsor if we haven't already obtained it. Put a slight delay so we don't overlay the Zone Boost sound
		End If
		If JackpotsThisMB(Player) = 2 then SetFieldMultiplier 3,False,False		' Set 3x All Scores at 2 jackpots in the same multiball
		If JackpotsThisMB(Player) = 5 then SetFieldMultiplier 6,False,False		' Set 6x All scores at 5 jackpots in the same multiball
		ZoneBoostReady(0) = False: ZoneBoostReady(1) = False					' Set both Zone Boost indicators for the ramps to false
		LLeftZoneBoost.State = 0: LRightZoneBoost.State = 0						' Turn off the Zone Boost lights
		RaiseBarrierTimer.Interval = Int((5000 * Rnd)+1) + 4999					' Set the next Barrier to raise 5-10 seconds after the Zone Boost
		RaiseBarrierTimer.Enabled = True										' Start the timer to raise the next Barrier
	End If

End Sub

' These timers deal with the new dynamic zone boost jackpot callout

Sub ZoneBoostDelay1_Timer()

	ZoneBoostDelay1.Enabled = False
	PlaySound"ZoneBoostPrefix"
	ZoneBoostDelay2.Enabled = True

End Sub

Sub ZoneBoostDelay2_Timer()

	ZoneBoostDelay2.Enabled = False
	Select Case BatZone
	Case 0
		PlaySound"ZoneBoost_00"
		ZoneBoostDelay3.Interval = 759
	Case 1
		PlaySound"ZoneBoost_01"
		ZoneBoostDelay3.Interval = 589
	Case 2
		PlaySound"ZoneBoost_02"
		ZoneBoostDelay3.Interval = 488
	Case 3
		PlaySound"ZoneBoost_03"
		ZoneBoostDelay3.Interval = 607
	Case 4
		PlaySound"ZoneBoost_04"
		ZoneBoostDelay3.Interval = 646
	Case 5
		PlaySound"ZoneBoost_05"
		ZoneBoostDelay3.Interval = 847
	Case 6
		PlaySound"ZoneBoost_06"
		ZoneBoostDelay3.Interval = 770
	Case 7
		PlaySound"ZoneBoost_07"
		ZoneBoostDelay3.Interval = 684
	Case 8
		PlaySound"ZoneBoost_08"
		ZoneBoostDelay3.Interval = 525
	Case 9
		PlaySound"ZoneBoost_09"
		ZoneBoostDelay3.Interval = 729
	Case 10
		PlaySound"ZoneBoost_10"
		ZoneBoostDelay3.Interval = 641
	Case 11
		PlaySound"ZoneBoost_11"
		ZoneBoostDelay3.Interval = 751
	Case 12
		PlaySound"ZoneBoost_12"
		ZoneBoostDelay3.Interval = 736
	Case 13
		PlaySound"ZoneBoost_13"
		ZoneBoostDelay3.Interval = 865
	Case 14
		PlaySound"ZoneBoost_14"
		ZoneBoostDelay3.Interval = 939
	Case 15
		PlaySound"ZoneBoost_15"
		ZoneBoostDelay3.Interval = 940
	Case 16
		PlaySound"ZoneBoost_16"
		ZoneBoostDelay3.Interval = 1027
	Case 17
		PlaySound"ZoneBoost_17"
		ZoneBoostDelay3.Interval = 1081
	Case 18
		PlaySound"ZoneBoost_18"
		ZoneBoostDelay3.Interval = 927
	Case 19
		PlaySound"ZoneBoost_19"
		ZoneBoostDelay3.Interval = 994
	Case 20
		PlaySound "ZoneBoost_20"
		ZoneBoostDelay3.Interval = 779
	End Select
	ZoneBoostDelay3.Enabled = True

End Sub

Sub ZoneBoostDelay3_Timer()

	ZoneBoostDelay3.Enabled = False
	Select Case BatZoneDec
	Case 0
		PlaySound "ZoneBoost_Point0"
	Case 1
		PlaySound "ZoneBoost_Point1"
	Case 2
		PlaySound "ZoneBoost_Point2"
	Case 3
		PlaySound "ZoneBoost_Point3"
	Case 4
		PlaySound "ZoneBoost_Point4"
	Case 5
		PlaySound "ZoneBoost_Point5"
	Case 6
		PlaySound "ZoneBoost_Point6"
	Case 7
		PlaySound "ZoneBoost_Point7"
	Case 8
		PlaySound "ZoneBoost_Point8"
	Case 9
		PlaySound "ZoneBoost_Point9"
	End Select

	ZoneBoostDisplayFlash.Enabled = False
	SeqFlashersAll.StopPlay
	PlayfieldSeq.StopPlay
	If BattleZone(player) <= 1 then
		AdvanceBattleZone BZoneAccum										' Bump the Battle Zone by the total of all accumulations since the last Zone Boost
		BZoneAccum = 0														' We got a Zone Boost Jackpot. Reset the accumulator counter
	Else
		If BattleZone(Player) >= 20.0 then 									' Did we Zone Boost at Battle Zone 20.0?
			BattleZone(Player) = 0.1										' If yes, reset the Battle Zone counter
			BZoneAccum = 0
			If not EndMultiballTimer.Enabled then AdvanceBattleZone 0		' Update the Zone displaye if we're not about to end multiball
		Else
			If BattleZone(Player) >= 10.0 then
				If not AssegaiWon(player) then 
					AwardSponsor"Assegai"									' Award the Assegai Sponsor when we attain a jackpot at Battle Zone 10 or higher
				Else
					AddScore 15000,True										' Score 15,000 points if we've already won the Assegai sponsor
				End If
			End If
			If not EndMultiballTimer.Enabled then AdvanceBattleZone BZoneAccum	' Bump the Battle Zone by the total of all accumulations since the last Zone Boost if we're not about to end multiball
			BZoneAccum = 0													' We got a Zone Boost Jackpot. Reset the accumulator counter
		End If
	End If

End Sub

' This is the timer to control the flashing effect on the zone display when a zone boost jackpot is awarded

Dim swFlash: swFlash = 1
Dim BZDisplayFlash



Sub ZoneBoostDisplayFlash_Timer()

	Select Case swFlash
	Case 1
		swFlash = 0
		ZoneDisplayOff()
	Case 0
		swFlash = 1
		DisplayZone BZDisplayFlash
	End Select

End Sub

' This is the delay timer for awarding Mirage to avoid overlapping callouts


Sub AwardMirageDelay_Timer()

	AwardMirageDelay.Enabled = False
	AwardSponsor "Mirage"

End Sub

' This ia the delay trimer for awarding Icaras to avoid overlapping callouts

Sub AwardIcarasDelay_Timer()

	AwardIcarasDelay.Enabled = False
	AwardSponsor "Icaras"

End Sub

' These two subs are the hit events for the Barriers

Sub BarrierLeft_Hit()

	If not Tilt then
		HitsToClearBarrier = HitsToClearBarrier - 1						' Knock one off from the hits needed to clear the barrier
		If HitsToClearBarrier = 0 then									' Are we clearing it?
			BarrierLeft.IsDropped = True								' If yes, drop the Barrier
			PlaySound"Zone Ship Exploding"								' Play a sound
			PlaySound"Target Attainable"
			AddScore 25000,False										' Dropping a barrier is 25,000 points
			ZoneBoostReady(0) = True									' Activate the Zone Boost
			LLeftZoneBoost.State = 2
			LLeftBarrier.State = 0
		Else
			AddScore 10000,False										' Hitting a Barrier without dropping it is 10,000 points
			PlaySound"Barrier Hit"
		End If
	End If

End Sub

Sub BarrierRight_Hit()

	If not Tilt then
		HitsToClearBarrier = HitsToClearBarrier - 1						' Knock one off from the hits needed to clear the barrier
		If HitsToClearBarrier = 0 then									' Are we clearing it?
			BarrierRight.IsDropped = True								' If yes, drop the Barrier
			PlaySound"Zone Ship Exploding"								' Play a sound
			PlaySound"Target Attainable"
			AddScore 25000,False										' Dropping a barrier is 25,000 points
			ZoneBoostReady(1) = True									' Activate the Zone Boost
			LRightZoneBoost.State = 2
			LRightBarrier.State = 0
		Else
			AddScore 10000,False										' Hitting a Barrier without dropping it is 10,000 points
			PlaySound"Barrier Hit"
		End If
	End If

End Sub

' This sub returns the table to normal after Zone Battle Multiball

Sub EndZoneBattleMultiball()

	DisplayZone Zone(Player)											' Restore the current Zone
	GetZone()
	ZoneBoostDisplayFlash.Enabled = False
	SeqFlashersAll.StopPlay
	PlayfieldSeq.StopPlay
	SeqZoneLights.StopPlay
	GameMode = 1														' Restore the Game Mode to general play
	FlashersNormal()													' Turn Flashers off
	ZoneComma_3.State = 0												' turn off the period in the Zone display
	LBattleZone.State = 0
	ZoneBoostReady(0) = False
	ZoneBoostReady(1) = False											' Set both Zone Boost indicators for the ramps to false
	LLeftZoneBoost.State = 0:LRightZoneBoost.State = 0
	RaiseBarrierTimer.Enabled = False									' Stop the Barrier timer so the Barriers won't raise
	BarrierLeft.IsDropped = True: BarrierRight.IsDropped = True			' We're done. Drop the Barriers.
	LLeftBarrier.State = 0:LRightBarrier.State = 0
	ZoneTriggersOn()													' Turn on the accelerator triggers
	InitLockDropTargets()												' Make the player clear all the LOCK drop targets prior to lighting a lock for multiball again
	LocksLit(player) = 0												' Ensure the number of locks lit is 0
	NextLock(Player) = 0												' Reset the Next Lock number to 0
	If not FldMultGenPlay then 
		SetFieldMultiplier 1,True,False									' Reset the Field Multiplier to 1x if we weren't at 2x or 3x at the start on multiball
	Else
		SetFieldMultiplier PrevFieldMultiplier,True,False
	End If
	StopAllMusic()	
	Select Case OptGameMusic
	Case 0,1,2
		ZoneFuryMusic()
	Case 3
		ZoneFuryMusicChoice()
	Case 4
		MusicTrack = PrevTrack
		ZoneFuryMusicChoiceAll()
	End Select
	If BattleZone(Player) > StatHighBatZone and OptDebugMode = 0 then 
		StatHighBatZone = BattleZone(Player)
		' Maybe play a high score sound
	End If

End Sub

Sub EndMultiballTimer_Timer()

	EndMultiballTimer.Enabled = False
	EndZoneBattleMultiball()											' If 1 ball remains and we get here, end the multiball mode

End Sub


' ************************************************************************************************
' End-Of-Game Section
' ************************************************************************************************

' These subs deal with the end of the game

 Sub EndGame()
 
	GameOver = True
	PiranhaDiverter1.RotateToStart
	For x1 = 1 to Players
		If Score(x1) > HighScore then
			HighScore = Score(x1)
			PlaySound "1st Place"
			If OptHiScoreCredits <> 0 then 
				MatchTimer.Interval = 1350
				HighScoreDelayTimer.Enabled = True
			End If
		Else
			MatchTimer.Interval = 50
		End If
		If OptDebugMode = 0 then 
			If Score(x1) > StatHighestScore then StatHighestScore = Score(x1)
			StatGamesPlayed = StatGamesPlayed + 1
			StatTotalPoints = StatTotalPoints + Score(x1)
			StatTotalZones = StatTotalZones + Zone(x1)
			If Score(x1) < 100000 then 
				StatHistSub100K = StatHistSub100K + 1
			ElseIf Score(x1) >= 100000 and Score(x1) < 250000 then 
				StatHist100K_249K = StatHist100K_249K + 1
			ElseIf Score(x1) >= 250000 and Score(x1) < 500000 then
				StatHist250K_499K = StatHist250K_499K + 1
			ElseIf Score(x1) >= 500000 and Score(x1) < 1000000 then 
				StatHist500K_999K = StatHist500K_999K + 1
			ElseIf Score(x1) >= 1000000 and Score(x1) < 1500000 then
				StatHist1M_1_4M = StatHist1M_1_4M + 1
			ElseIf Score(x1) >= 1500000 and Score(x1) < 2000000 then
				StatHist1_5M_1_9M = StatHist1_5M_1_9M + 1
			Else
				StatHist2MAndUp = StatHist2MAndUp + 1
			End If
			StatTimePlayedGame = StatTimePlayedGame + TimeInGame(x1)
			If Zone(x1) > StatHighestZone then StatHighestZone = Zone(x1)
		End If
 	Next

	z1 = 1
	MatchTimer.Enabled = True	
	
End Sub	
 
 Sub MatchTimer_Timer()

 	Randomize
	StopAllMusic()
	MatchReel.SetValue 0
	BIPReel.SetValue 1
	If B2SOn then 
		Controller.B2SSetBallInPlay 32,0
		Controller.B2SSetMatch 34,1
	End If
	BoredomTimer.Enabled = False
	SwipeTimer.Enabled = False
	y1 = int(Rnd*10)*10
 	If y1 = 0 then
		mv = "0" & y1
 	Else
 		mv = y1
	End If
	UpdateMatch mv

 	z1 = z1 + 1
	If z1 = 10 then
		MatchTimer.Enabled = False
		Match()
		PlaySound "Session Complete"
	Else
		PlaySound "Boost"
	End If
	
	MatchTimer.Interval = (45 * z1)
	
End Sub

Sub Match()

	For z1 = 1 to Players
		x1 = Right(score(z1),2)
		If x1 = CStr(mv) then
			AddCreditTimer.Interval = 25
			AddCredits 1
			MatchFlashTimer.Enabled = True
 			If not OptDebugMode then
 				StatTotalReplays = StatTotalReplays + 1
 				StatMatchReplays = StatMatchReplays + 1
 			End If
		End If
 	Next
	Started = False
	Player = 0												' These will be moved to the end of the match routine when scripted
	Players = 0
	BallInPlay = 0
'	GameOverText.Text = "GAME OVER"
	GameOverReel.SetValue 0
	If B2SOn then Controller.B2SSetGameOver 35,1
	GameMode = 0
	Light1P.State = 0
	Light2P.State = 0
	Light3P.State = 0
	Light4P.State = 0
	If B2SOn Then
		Controller.B2SSetData 40,0
		Controller.B2SSetData 41,0
		Controller.B2SSetData 42,0
		Controller.B2SSetData 43,0
	End If
	x1 = 0
'	StartAttractMode()
'	GILightsNormal()
	PlayfieldSeq.Play SeqAllOff
	FlashersGameEnd()
	EndGameTimer.Enabled = True
	If OptGameMusic <> 0 then PlaySound"vpzonefuryending"
' 	CredText1.TimerEnabled = False
' 	StartCredits()
'	If Credits > 0 or FreePlay then
'		StartGameLight.State = 2
'	Else
'		StartGameLight.State = 0
'	End If

End Sub	

Sub HighScoreDelayTimer_Timer()

	HighScoreDelayTimer.Enabled = False
	AddCredits OptHiScoreCredits
	StatTotalReplays = StatTotalReplays + OptHiScoreCredits

End Sub

Sub MatchFlashTimer_Timer()

 	z2=(z2+1) Mod 2
 	Select Case z2
 	Case 0
 		MatchReel.SetValue 0
		If B2SOn then Controller.B2SSetMatch 34,1
 	Case 1
 		MatchReel.SetValue 1
		If B2SOn then Controller.B2SSetMatch 34,0
 	End Select

End Sub

Sub EndGameTimer_Timer()

	EndGameTimer.Enabled = False
	PlayfieldSeq.StopPlay
	FlashersNormal()
	StartAttractMode()
	GILightsNormal()	

End Sub

' ****************************** Attract-Mode Section *********************************

' These subs deal with the attract mode. The basic attract mode I employ in my tables is something along these lines...
'
' First up...the playfield lights/objects
'
' I first create collections of groups of lights on the table that I feel should go together. If I happen to have other objects that should do something 
' during the attract mode I code AttractMode and Normal subs for them as well. Mostly I just do lights.
'
' I then code AttractMode and Normal subs for each collection I define. The AttractMode sub will set the lights in a pre-defined blinking pattern
' based on the lights, how they're grouped, and what sort of pattern I want. I then have the table call the Normal subs when we start a game. Each Normal
' sub will turn all the lights in the collection off and it will set a standard "10" blinking pattern for the whole collection.
'
' Once I have the AttractMode and Normal subs coded, I create a collection of all the lights on the table (I usually call it collAllLights). 
' I then place a single Light Sequencer object on the table keyed to this one collection. This is controlled with a timer. I usually use a separate timer
' but you should be able to use the timer included with the light sequencer if you wish. I set the timer interval to 10000 (approximately 10 seconds). 
' When the timer sub fires the sequencer runs the next function call. When the sequencer is done, the lights revert to the blink patterns set in the 
' AttractMode subs until the timer fires again. This timer is turned off when we start a game. You can put as many or as few sequencer calls in the timer
' sub controlling the sequencer calls as you like.
'
' Now the backdrop
'
' I use some code that shiva originally developed for the attract mode on the displays that resembles what real machines do. What this does is show
' the previously-played game's scores for a few seconds, then the score displays briefly blink out, and then show the high score on all four displays.
' Some real tables put up the top 4 in a 4-player score display. This template will not do so as it only tracks one high score, but if you want a top-4
' high score list to show this can be done fairly easily. After a shorter time, the display goes back to showing the last game's scores. The displays will
' keep doing this until we start a game or exit the table. There will be game-over and high-score lights that will be showing in the backdrop,
' as well as a start-game light.The game over and start game lights won't be affected by the attract-mode but the high-score light will turn on anf off
' depending on what the displays are showing.
'
' Please refer to the VP9 documentation regarding what the different light sequencer calls are	

Dim SequenceCount													' Controls which light-sequencer event we'll be firing when the sequencer timer fires

Sub StartAttractMode()

	SequenceCount = 0
	SeqTimer.Enabled = True
	AttractTimer.Enabled = True
	BumpersAttractMode()
	ABCDLightsAttractMode()
	EGXLightsAttractMode()
	G45LightsAttractMode()
	LeftOrbitLightsAttractMode()
	LeftRampLightsAttractMode()
	RightRampLightsAttractMode()
	LeftOutlaneLightsAttractMode()
	RightOutlaneLightsAttractMode()
	MultiplierLightsAttractMode()
	BonusLights1K9KAttractMode()
	BonusLights10KAttractMode()
	SponsorLightsAttractMode()
	ZoneNameLightsAttractMode()

End Sub

' Call AttractMode subs for all your playfield light collections

Sub StopAttractMode()

	PlayfieldSeq.StopPlay														' Stop playing any light-sequencer event
	PlayfieldSeq.Play SeqAllOff:PlayfieldSeq.StopPlay
	SeqTimer.Enabled = False												' turn the sequencer timer off
	AttractTimer.Enabled = False
	BumpersNormal()
	ABCDLightsNormal()
	EGXLIghtsNormal()
	G45LightsNormal()
	LeftOrbitLightsNormal()
	LeftRampLightsNormal()
	RightRampLightsNormal()
	LeftOutlaneLightsNormal()
	RightOutlaneLightsNormal()
	MultiplierLightsNormal()
	BonusLights1K9KNormal()
	BonusLights10KNormal()
	SponsorLightsNormal()
	ZoneNameLightsNormal()
'	StopAllMusic()

End Sub

' Call Normal subs for all your playfield light collections


' Light-Sequencer timer
'
' This is the timer sub that controls the light sequencer.
  
Sub SeqTimer_Timer()
 
 	SequenceCount = SequenceCount + 1											' bump the sequence counter
  	SeqTimer.Enabled = False												' turn off the timer so it doesnt fire again until after the sequence plays
  	Select Case SequenceCount
 	Case 1
 		PlayfieldSeq.UpdateInterval = 5
 		PlayfieldSeq.Play SeqUpOn,60,5,250
 	Case 2
 		PlayfieldSeq.UpdateInterval = 5
 		PlayfieldSeq.Play SeqDownOn,60,5,250
 	Case 3
 		PlayfieldSeq.UpdateInterval = 10
 		PlayfieldSeq.Play SeqRightOn,40,5,250
 	Case 4
 		PlayfieldSeq.UpdateInterval = 10
 		PlayfieldSeq.Play SeqLeftOn,40,5,250
 	Case 5
 		PlayfieldSeq.UpdateInterval = 15
 		PlayfieldSeq.Play SeqMiddleOutHorizOn,40,4,250
 	Case 6
 		PlayfieldSeq.UpdateInterval = 15
 		PlayfieldSeq.Play SeqMiddleInHorizOn,40,4,250
 	Case 7
 		PlayfieldSeq.UpdateInterval = 15
 		PlayfieldSeq.Play SeqMiddleOutVertOn,40,4,250
 	Case 8
 		PlayfieldSeq.UpdateInterval = 15
 		PlayfieldSeq.Play SeqMiddleInVertOn,40,4,250
 	End Select
 	If SequenceCount = 9 then 													' If we've reached the last defined sequencer event
 		SequenceCount = 0														' Reset the sequence counter
 		SeqTimer.Enabled = True											' Restart the timer
 	End If
 
End Sub
 
' Restart the sequencer timer when we've finished playing a light-sequencer event.

Sub PlayfieldSeq_PlayDone
 
 	If GameMode = 0 then SeqTimer.Enabled = True
 
End Sub

' AttractMode subs
'
' The AttractMode subs are essentially the same. How many you have depends on how many collections of lights you have.
'
' They will set the blink pattern of the lights in each collection, then start them blinking. You can set a specific blink interval for the lights if you wish to do so.

Sub BumpersAttractMode()

Dim oLight


	b1l1.BlinkPattern = "100"
	b1l2.BlinkPattern = "100"
	b2l1.BlinkPattern = "010"
	b2l2.BlinkPattern = "010"
	b3l1.BlinkPattern = "001"
	b3l2.BlinkPattern = "001"	
	For Each oLight in CollBumperLights
		oLight.State = 2
	Next

End Sub

' ABC Lights

Sub ABCDLightsAttractMode()

Dim oLight

	L6.BlinkPattern = "1000"
	L7.BlinkPattern = "0100"
	L8.BlinkPattern = "0010"
	L9.BlinkPattern = "0001"
	For Each oLight in collABCDLights
		oLight.State = 2
	Next

End Sub

' EG-X Drop Target lights (including the in-sequence light)

Sub EGXLightsAttractMode()

Dim oLight

	L1.BlinkPattern = "1000"
	L2.BlinkPattern = "0100"
	L3.BlinkPattern = "0010"
	LEGXSeq.BlinkPattern = "0001"
	For Each oLight in CollEGXLights
		oLight.State = 2
	Next

End Sub

' Goteki 45 drop target Lights including in-sequence light

Sub G45LightsAttractMode()

Dim oLight

	L14.BlinkPattern = "1000"
	L15.BlinkPattern = "0100"
	L16.BlinkPattern = "0010"
	LG45Seq.BlinkPattern = "0001"
	For Each oLight in CollG45Lights
		oLight.State = 2
	Next

End Sub

' Left lights

Sub LeftOrbitLightsAttractMode()

Dim oLight

	L21.BlinkPattern = "10000"
	LLock1.BlinkPattern = "01000"
	LLock2.BlinkPattern = "00100"
	LLock3.BlinkPattern = "00010"
	LXBall.BlinkPattern = "00001"
	L12.BlinkInterval = 125
	L13.BlinkInterval = 125
	L12.BlinkPattern = "01"
	L13.BlinkPattern = "10"
	For Each oLight in collLeftOrbitLights
		oLight.State = 2
	Next

End Sub

' Right Ramp Lights

Sub RightRampLightsAttractMode()

Dim oLight

	LFeisarR.BlinkPattern = "1000"
	LRight2Zones.BLinkPattern = "0100"
	LRightBarrier.BlinkPattern = "0010"
	LRightZoneBoost.BlinkPattern = "0001"
	For Each oLight in collRightRampLights
		oLight.State = 2
	Next

End Sub

'Left Ramp Lights

Sub LeftRampLightsAttractMode()

Dim oLight

	LLeft2Zones.BlinkPattern = "1000"
	LLeftBarrier.BLinkPattern = "0100"
	LFeisarA.BlinkPattern = "0010"
	LLeftZoneBoost.BlinkPattern = "0001"
	For Each oLight in collLeftRampLights
		oLight.State = 2
	Next

End Sub

' Inlane / Outlane lights

Sub LeftOutlaneLightsAttractMode()

Dim oLight

	LSpecial1.BlinkPattern = "1010"
	LFeisarF.BlinkPattern = "1010"
	LFeisarE.BlinkPattern = "0101"
	L2ZOnesL.BlinkPattern = "0101"	
	
	For Each oLight in collLeftOutlaneLights
		oLight.State = 2
'		oLight.BlinkInterval = 75
	Next

End Sub

Sub RightOutlaneLightsAttractMode()

Dim oLight

	LSpecial2.BlinkPattern = "1010"
	LFeisarI.BlinkPattern = "0101"
	LFeisarS.BlinkPattern = "1010"
	L2ZOnesR.BlinkPattern = "0101"	
	
	For Each oLight in collRightOutlaneLights
		oLight.State = 2
'		oLight.BlinkInterval = 75
	Next

End Sub

' Bonus Multiplier Lights

Sub MultiplierLightsAttractMode()

Dim oLight

	LBonus2x.BlinkPattern = "10000"
	LBonus3x.BlinkPattern = "01000"
	LBonus4x.BlinkPattern = "00100"
	LBonus5x.BlinkPattern = "00010"
	LBonus6x.BlinkPattern = "00001"
	LField2x.BlinkPattern = "10"
	LField3x.BlinkPattern = "01"
	
	For Each oLight in collMultiplierLights
		oLight.State = 2
	Next

End Sub

' 1K-9K Bonus Lights

Sub BonusLights1K9KAttractMode()

Dim oLight

	LBonus1.BlinkPattern = "111000000"
	LBonus2.BlinkPattern = "011100000"
	LBonus3.BlinkPattern = "001110000"
	LBonus4.BlinkPattern = "000111000"
	LBonus5.BlinkPattern = "000011100"
	LBonus6.BlinkPattern = "000001110"
	LBonus7.BlinkPattern = "000000111"
	LBonus8.BlinkPattern = "100000011"
	LBonus9.BlinkPattern = "110000001"
	
	For Each oLight in collBonus1KLights
		oLight.State = 2
	Next

End Sub

' 10K-40K Bonus Lights

Sub BonusLights10KAttractMode()

Dim oLight

	LBonus10.BlinkPattern = "1000"
	LBonus20.BlinkPattern = "0100"
	LBonus30.BlinkPattern = "0010"
	LBonus40.BlinkPattern = "0001"
	
	For Each oLight in collBonus10KLights
		oLight.State = 2
	Next

End Sub

Sub SponsorLightsAttractMode()

Dim oLight

	LFeisar1.BlinkPattern = 	"111100000000"
	LEGX1.BlinkPattern = 	    "011110000000"
	LG45.BlinkPattern = 		"001111000000"
	LPiranha1.BlinkPattern =	"000111100000"
	LQirex1.BlinkPattern = 		"000011110000"
	LHarimau1.BlinkPattern =    "000001111000"
	LTriakis1.BlinkPattern =    "000000111100"
	LIcaras1.BlinkPattern =     "000000011110"
	LAGSys1.BlinkPattern = 		"000000001111"
	LAuricom1.BlinkPattern =    "100000000111"
	LAssegai1.BlinkPattern =    "110000000011"
	LMirage1.BlinkPattern =     "111000000001"

	For Each oLight in collSponsorLights
		oLight.State = 2
	Next

End Sub

' Zone Name Lights

Sub ZoneNameLightsAttractMode()

Dim oLight

	LSubVenom.BlinkPattern =     "10000000000000"
	LVenom.BlinkPattern =        "01000000000000"
	LSubFlash.BlinkPattern =     "00100000000000"
	LFlash.BlinkPattern =        "00010000000000"
	LSubRapier.BlinkPattern =    "00001000000000"
	LRapier.BlinkPattern =       "00000100000000"
	LSubPhantom.BlinkPattern =   "00000010000000"
	LPhantom.BlinkPattern =      "00000001000000"
	LSuperPhantom.BlinkPattern = "00000000100000"
	LZen.BlinkPattern =          "00000000010000"
	LSuperZen.BlinkPattern =     "00000000001000"
	LSubsonic.BlinkPattern =     "00000000000100"
	LMach1.BlinkPattern =        "00000000000010"
	LSupersonic.BlinkPattern =   "00000000000001"


	For Each oLight in collZoneLights
		oLight.State = 2
	Next

End Sub


' Normal mode subs
'
' These akll do the same thing as well. In each collection they'll restore the lights to a normal start-of-game state and set the blink pattern to the normal "10" 

Sub BumpersNormal()

Dim oLight

	For Each oLight in CollBumperLights
		oLight.State = 1
		oLight.BlinkPattern = "10"
	Next
	
End Sub

Sub ABCDLightsNormal()

Dim oLight

	For Each oLight in collABCDLights
		oLight.State = 0
		oLight.BlinkPattern = "10"
	Next
	
End Sub

Sub EGXLightsNormal()

Dim oLight

	For Each oLight in collEGXLights
		oLight.State = 0
		oLight.BlinkPattern = "10"
	Next
	
End Sub

Sub G45LightsNormal()

Dim oLight

	For Each oLight in collG45Lights
		oLight.State = 0
		oLight.BlinkPattern = "10"
	Next
	
End Sub

Sub LockLightsNormal()

Dim oLight

	For Each oLight in collLockLights
		oLight.State = 0
		oLight.BlinkPattern = "10"
	Next
	
End Sub

Sub LeftOrbitLightsNormal()

Dim oLight

	For Each oLight in collLeftOrbitLights
		oLight.State = 0
		oLight.BlinkPattern = "10"
	Next
	L12.BlinkInterval = 50
	L13.BlinkInterval = 50

End Sub

Sub RightRampLightsNormal()

Dim oLight

	For Each oLight in collRightRampLights
		oLight.State = 0
		oLight.BlinkPattern = "10"
	Next
	
End Sub

Sub LeftRampLightsNormal()

Dim oLight

	For Each oLight in collLeftRampLights
		oLight.State = 0
		oLight.BlinkPattern = "10"
	Next
	
End Sub

Sub LeftOutlaneLightsNormal()

Dim oLight

	For Each oLight in collLeftOutlaneLights
		oLight.State = 0
		oLight.BlinkPattern = "10"
		oLight.BlinkInterval = 100
	Next
	
End Sub

Sub RightOutlaneLightsNormal()

Dim oLight

	For Each oLight in collRightOutlaneLights
		oLight.State = 0
		oLight.BlinkPattern = "10"
		oLight.BlinkInterval = 100
	Next
	
End Sub

Sub MultiplierLightsNormal()

Dim oLight

	For Each oLight in collMultiplierLights
		oLight.State = 0
		oLight.BlinkPattern = "10"
	Next
	
End Sub

Sub BonusLights1K9KNormal()

Dim oLight

	For Each oLight in collBonus1KLights
		oLight.State = 0
		oLight.BlinkPattern = "10"
	Next
	
End Sub

Sub BonusLights10KNormal()

Dim oLight

	For Each oLight in collBonus10KLights
		oLight.State = 0
		oLight.BlinkPattern = "10"
	Next
	
End Sub

Sub SponsorLightsNormal()

Dim oLight

	For Each oLight in collSponsorLights
		oLight.State = 0
		oLight.BlinkPattern = "10"
'		oLight.BlinkInterval = 100
	Next

End Sub

Sub ZoneNameLightsNormal()

Dim oLight

	For Each oLight in collZoneLights
		oLight.State = 0
		oLight.BlinkPattern = "10"
'		oLight.BlinkInterval = 100
	Next

End Sub

Sub AllLightsOff()

Dim oLight

	For Each oLight in CollAllLights
		oLight.State = 0
	Next

End Sub

' Backdrop Attract Mode

' Backglass Display Attract-mode timer sub'
'
' This timer sub controls the backdrop score displays during attract mode. First it'll show the scores from the previous game (or all zeroes if we just started the table) for 3 seconds, 
' shut off for 1/5 second, then show the high score on all four displays for 1.5 seconds, then shut off for 1/2 second, and repeat. The high score light also turns on and off
' when the table shows the high score. This was originally taken from shiva's template, and is a pretty standard system I use on my tables that use this style of display. Yu-Gi-Oh, Tokimemo, 
' and Harry Potter all use an adaptation of this sub.
' 
 
Sub AttractTimer_Timer()

Dim Scores(4)

    Select Case x1
    	Case 0
			ScoreDisplayOff()
    		AttractTimer.Interval = 3000					' CHANGE to increase Time for Player's score to display
'			HighScoreText.Text = ""
'			HighScoreText.TimerEnabled = False				' Turn off the high score light
			HSReel.SetValue 1
			HSReel.TimerEnabled = False
			If B2SOn then Controller.B2SSetData 25,0
			If Score(1) = 0 then
				Player = 1
				UpdateScore "00"
			Else
				Player = 1
				UpdateScore Score(1)
			End If
			If Score(2) = 0 then
				Player = 2
				UpdateScore "00"
			Else
				Player = 2
				UpdateScore Score(2)
			End If
			If Score(3) = 0 then
				Player = 3
				UpdateScore "00"
			Else
				Player = 3
				UpdateScore Score(3)
			End If
			If Score(4) = 0 then
				Player = 4
				UpdateScore "00"
			Else
				Player = 4
				UpdateScore Score(4)
			End If
		Case 1
     		AttractTimer.Interval = 200						' CHANGE to blink out score displays for 1/5 second
			ScoreDisplayOff()
    	Case 2
    		AttractTimer.Interval = 1500					' CHANGE to increase Time High Score is displayed
'    		HighScoreText.TimerEnabled = True				' Turn on the high score light
			HSReel.TimerEnabled = True
     		For y1 = 1 To 4
    			Scores(y1) = HighScore
 				player = y1
    			UpdateScore Scores(y1)
 			Next	
    	Case 3
     		AttractTimer.Interval = 200						' CHANGE to blink out score displays for 1/5 second
'			HighScoreText.Text = ""
'			HighScoreText.TimerEnabled = False				' Turn off the high score light
			HSReel.SetValue 1
			HSReel.TimerEnabled = True
			If B2SOn then Controller.B2SSetData 25,0
			ScoreDisplayOff()
   	End Select

	x1 = (x1 + 1) Mod 4 		

End Sub

Sub HSReel_Timer()

	hs = hs + 1
	Select Case (hs mod 2)
	Case 0
'		HighScoreText.Text = "HIGH SCORE"
		HSReel.SetValue 0
		If B2SOn then Controller.B2SSetData 25,1
	Case 1
'		HighScoreText.Text = ""
		HSReel.SetValue 1
		If B2SOn then Controller.B2SSetData 25,0
	End Select

End Sub

' This sub will stop all the sequencers involving the dome flashers

Sub StopAllSeq()

Dim oSeq

	For Each oSeq in CollAllSequencers
		oSeq.StopPlay
	Next

End Sub


' Dome Flasher Control
'
' This section contains subs controlling the six dome flashers not activated by light-sequencer commands. The flashers are grouped into multiple collections
'
' These control the six flashers during multiball

Sub FlashersMultiball()

Dim oFlasher

	LFlasher1.BlinkPattern = "100000"
	Flasher001.BlinkPattern = "100000"
	LFlasher2.BlinkPattern = "010000"
	Flasher002.BlinkPattern = "010000"
	LFlasher3.BlinkPattern = "001000"
	Flasher003.BlinkPattern = "001000"
	LFlasher6.BlinkPattern = "000100"
	Flasher006.BlinkPattern = "000100"
	LFlasher5.BlinkPattern = "000010"
	Flasher005.BlinkPattern = "000010"
	LFlasher4.BlinkPattern = "000001"
	Flasher004.BlinkPattern = "000001"

	For Each oFlasher in CollFlashersAll
		oFlasher.BlinkInterval = 75
		oFlasher.State = 2
	Next

End Sub

Sub FlashersNormal()

Dim oFlasher

	For Each oFlasher in CollFlashersAll
		oFlasher.BlinkPattern = "10"
		oFlasher.BlinkInterval = 50
		oFlasher.State = 0
	Next

End Sub

Sub FlashersGameEnd()

Dim oFlasher

	LFlasher4.BlinkPattern = "100000"
	Flasher004.BlinkPattern = "100000"
	LFlasher5.BlinkPattern = "010000"
	Flasher005.BlinkPattern = "010000"
	LFlasher6.BlinkPattern = "001000"
	Flasher006.BlinkPattern = "001000"
	LFlasher3.BlinkPattern = "000100"
	Flasher003.BlinkPattern = "000100"
	LFlasher1.BlinkPattern = "000010"
	Flasher001.BlinkPattern = "000010"
	LFlasher2.BlinkPattern = "000001"
	Flasher002.BlinkPattern = "000001"

	For Each oFlasher in CollFlashersAll
		oFlasher.BlinkInterval = 150
		oFlasher.State = 2
	Next

End Sub



' ************************************************ Game Music Section ********************************************************
'
' Music-hndling subs go here
'
' Current Music Legend
'
' 0 = End the music track currently playing / End of Game
' 1 = VP Zone Fury Mix 01a (Excerpt from Euphorasm Vol. 2 by DJ Sly One)
' 2 = VP Zone Fury Mix 01b (Second Excerpt from Euphorasm Vol. 2 by DJ Sly One)
' 3 = VP Zone Fury Mix 02 (Third Excerpt from Euphorasm Vol. 2 by DJ Sly One)
' 4 = VP Zone Fury Mix 03 (Excerpt from Listening by YuSik from wipeoutzone.com)
' 5 = VP Zone Fury Mix 04 ("Information High" from the anime Macross Plus)
' 6 = VP Zone Fury Mix 05 ("Beautiful Together (Signum mix)" by Oceanlab)
' 7 = Multiball music ("PSI-Missing" performed by Mami Kawada - OP theme from To Aru Majutsu no Index)
' 8 - Multiball music ("Kimi wo Mamotitai" 1st ED from the anime Freezing)
' 

Dim SelectingMusic
Dim PrevTrack						' indicates previous track to resume after multiball (Option 14 setting 4 only)
Dim MusicTrack						' Indicates current music track

' This sub randomly determines game music

Sub ZoneFuryMusic()

	Randomize Timer
 	If OptGameMusic and not Tilt then
		If not GameOver and GameMode <> 2 then MusicTrack = (Int(6*Rnd) + 1)
 		Select Case MusicTrack
 			Case 0
 				StopSound"vpzonefurymix01a"
 				StopSound"vpzonefurymix01a"
 				StopSound"vpzonefurymix02"
	 			StopSound"vpzonefurymix03"
				StopSound"vpzonefurymultiball"
				StopSound"vpzonefurymultiball2"
				StopSound"vpzonefuryaltmix04"
				StopSound"vpzonefuryaltmix05"
 			Case 1
				PlaySound"vpzonefurymix01a",-1
 			Case 2
				PlaySound"vpzonefurymix01b",-1
 			Case 3
				PlaySound"vpzonefurymix02",-1
 			Case 4
				PlaySound"vpzonefurymix03",-1
			Case 5
				PlaySound"vpzonefuryaltmix04",-1
			Case 6
				PlaySound"vpzonefuryaltmix05",-1
 			Case 7
				Select Case (Int(2*Rnd) + 1)
				Case 1
					PlaySound"vpzonefurymultiball2",-1
				Case 2
					PlaySound"vpzonefurymultiball",-1
				End Select
		End Select
	End If

End Sub

Sub StopAllMusic()

	StopSound"vpzonefuryintro"
 	StopSound"vpzonefurymix01a"
 	StopSound"vpzonefurymix01b"
 	StopSound"vpzonefurymix02"
	StopSound"vpzonefurymix03"
	StopSound"vpzonefurymultiball"
	StopSound"vpzonefurymultiball2"
	StopSound"vpzonefuryending"
	StopSound"vpzonefuryaltmix04"
	StopSound"vpzonefuryaltmix05"

End Sub

' This sub is to allow a player to choose the main game music except for multiball which is random (Option 14, Settng 3)

Sub ZoneFuryMusicChoice()

 	If OptGameMusic and not Tilt then
		StopAllMusic
		If SelectingMusic then DisplayTrack
 		Select Case MusicTrack
 			Case 1
				PlaySound"vpzonefurymix01a",-1
 			Case 2
				PlaySound"vpzonefurymix01b",-1
 			Case 3
				PlaySound"vpzonefurymix02",-1
 			Case 4
				PlaySound"vpzonefurymix03",-1
			Case 5
				PlaySound"vpzonefuryaltmix04",-1
			Case 6
				PlaySound"vpzonefuryaltmix05",-1
 			Case 7
				Select Case (Int(2*Rnd) + 1)
				Case 1
					PlaySound"vpzonefurymultiball2",-1
				Case 2
					PlaySound"vpzonefurymultiball",-1
				End Select
		End Select
	End If

End Sub

' This sub allowa a player to select any music track in the game (Option 14 Setting 4)

Sub ZoneFuryMusicChoiceAll()

 	If OptGameMusic and not Tilt then
		StopAllMusic
		If SelectingMusic then DisplayTrack
 		Select Case MusicTrack
 			Case 1
				PlaySound"vpzonefurymix01a",-1
 			Case 2
				PlaySound"vpzonefurymix01b",-1
 			Case 3
				PlaySound"vpzonefurymix02",-1
 			Case 4
				PlaySound"vpzonefurymix03",-1
			Case 5
				PlaySound"vpzonefuryaltmix04",-1
			Case 6
				PlaySound"vpzonefuryaltmix05",-1
 			Case 7
				PlaySound"vpzonefurymultiball",-1
			Case 8
				PlaySound"vpzonefurymultiball2",-1
		End Select
	End If

End Sub

Sub ResetMusicChoices()

	SelectingMusic = False
	CredText1.Text = ""
	CredText2.Text = ""
	CredText1FS.Text = ""
	CredText2FS.Text = ""

End Sub

Sub DisplayTrack()

	If ZoneFury.ShowDT Then
		Select Case MusicTrack
			Case 1
				CredText2.Text = "1) Euphorasm 2 - Mix 1"
			Case 2
				CredText2.Text = "2) Euphorasm 2 - Mix 2"
			Case 3
				CredText2.Text = "3) Euphorasm 2 - Mix 3"
			Case 4
				CredText2.Text = "4) Listening - Mix 1"
			Case 5
				CredText2.Text = "5) Information High"
			Case 6
				CredText2.Text = "6) Beautiful Together"
			Case 7
				CredText2.Text = "7) PSI-Missing"
			Case 8
				CredText2.Text = "8) Kimi wo Mamotitai"
		End Select
	Else
		Select Case MusicTrack
			Case 1
				CredText2FS.Text = "1) Euphorasm 2 - Mix 1"
			Case 2
				CredText2FS.Text = "2) Euphorasm 2 - Mix 2"
			Case 3
				CredText2FS.Text = "3) Euphorasm 2 - Mix 3"
			Case 4
				CredText2FS.Text = "4) Listening - Mix 1"
			Case 5
				CredText2FS.Text = "5) Information High"
			Case 6
				CredText2FS.Text = "6) Beautiful Together"
			Case 7
				CredText2FS.Text = "7) PSI-Missing"
			Case 8
				CredText2FS.Text = "8) Kimi wo Mamotitai"
		End Select
	End If

End Sub

Sub TrigPlunge_Unhit()

	ResetMusicChoices()

End Sub

' ************************************ Savefile Section *************************************
'
' These subs load and save information to and from the savefile. This uses the LoadValue/SaveValue function calls in VP
' This is known to cause problems if VP is not run from the same place in which it is installed.

' This sub saves the statistics we want to save. Authors can store anything they wish into the save file, and retrieve as needed.
' This template currently saves high scores, options, and statistics.
'
' In this template this sub is called on table exit

Sub SaveHS()

	SaveValue cGameName,"oBallsPerGame",OptBallsPerGame
	SaveValue cGameName,"sHighScore",HighScore
	SaveValue cGameName,"sCredits", Credits
	SaveValue cGameName,"sGamesPlayed", StatGamesPlayed
	SaveValue cGameName,"sTotalPoints",StatTotalPoints
 	SaveValue cGameName,"sHighestScore",StatHighestScore
	SaveValue cGameName,"sReplaysWon",StatTotalReplays
	SaveValue cGameName,"oBallsPerGame",OptBallsPerGame
	SaveValue cGameName,"oReplay1",OptGoalScore(1)
	SaveValue cGameName,"oReplay2",OptGoalScore(2)
	SaveValue cGameName,"oReplay3",OptGoalScore(3)
	SaveValue cGameName,"oReplay4",OptGoalScore(4)
	SaveValue cGameName,"oMaxCredit",OptMaxCredits
 	SaveValue cGameName,"oDefHighScore",OptDefaultHighScore
	SaveValue cGameName,"oReplayCredits",OptReplayCredits
	SaveValue cGameName,"oHiScoreCredits",OptHiScoreCredits
	SaveValue cGameName,"oReplayAward",OptReplayAward
	SaveValue cGameName,"oBallSaverTime",OptBallSaverTime
	SaveValue cGameName,"oMBBallSaverTime",OptMBBallSaverTime
	SaveValue cGameName,"oTiltSens",OptTiltSens
	SaveValue cGameName,"oGameMusic",OptGameMusic
	SaveValue cGameName,"oDebugMode",OptDebugMode
	SaveValue cGameName,"oTournament",OptTournament
	SaveValue cGameName,"oMaxEBGame",OptMaxEBGame
	SaveValue cGameName,"oMaxEBBIP",OptMaxEBBIP
 	SaveValue cGameName,"sMatchReplays",StatMatchReplays
 	SaveValue cGameName,"sBallsPlayed",StatBallsPlayed
 	SaveValue cGameName,"sExtraBalls",StatExtraBalls
	SaveValue cGameName,"sHighZone",StatHighestZone
	SaveValue cGameName,"sTotMultiballs",StatZoneBattleMultiballs
	SaveValue cGameName,"sTotJackpots",StatZoneBoostJackpots
	SaveValue cGameName,"sHighBatZone",StatHighBatZone
	SaveValue cGameName,"sHighBatZoneWon",StatHighBatZoneWon
	SaveValue cGameName,"sTotGameTime",StatTimePlayedGame
 	SaveValue cGameName,"sTotBallTime",StatTimePlayedBall
	SaveValue cGameName,"sHist100K",StatHistSub100K	
	SaveValue cGameName,"sHist249K",StatHist100K_249K
	SaveValue cGameName,"sHist499K",StatHist250K_499K	
	SaveValue cGameName,"sHist999K",StatHist500K_999K
	SaveValue cGameName,"sHist1_4M",StatHist1M_1_4M
	SaveValue cGameName,"sHist1_9M",StatHist1_5M_1_9M
	SaveValue cGameName,"sHist2M",StatHist2MAndUp
	SaveValue cGameName,"sTotZones",StatTotalZones
	SaveValue cGameName,"oBSDispOn",OptBSDispOn

End Sub

' This sub will load the data from the savefile. In this template this data is loaded at startup.
' The LoadValue is actually a function call, where the SaveValue is a sub call, so what the LoadValue function returns gets put into the variable as a string and is converted into numeric values,
' If LoadValue returns a null string, either a zero or the default value gets put into the option or stat value

Sub LoadHS()

Dim Value

	Value = LoadValue(cGameName,"oBallsPerGame")
	If Value <> "" then	 
		OptBallsPerGame = CDbl(Value)
	Else
		OptBallsPerGame = DefBallsPerGame
	End If

	Value = LoadValue(cGameName,"sHighScore")
	If Value <> "" then	 
		HighScore = CDbl(Value)
	Else
		HighScore = CDbl(DefHighScore1)
	End If
	
	Value = LoadValue(cGameName,"sCredits")
	If Value <> "" then 
		Credits = CDbl(Value)
	Else
		Credits = 0
	End If

	Value = LoadValue(cGameName,"sGamesPlayed")
	If Value <> "" then 
		StatGamesPlayed = CDbl(Value)
	Else
		StatGamesPlayed = 0
	End If

	Value = LoadValue(cGameName,"sTotalPoints")
	If Value <> "" then 
 		StatTotalPoints = CDbl(Value)
 	Else
 		StatTotalPoints = 0
 	End If

 	Value = LoadValue(cGameName,"sHighestScore")
	If Value <> "" then 
		StatHighestScore = CDbl(Value)
	Else
		StatHighestScore = 0
	End If
	
	Value = LoadValue(cGameName,"sReplaysWon")
	If Value <> "" then 
		StatTotalReplays = CDbl(Value)
	Else
		StatTotalReplays = 0
	End If

 	Value = LoadValue(cGameName,"oBallsPerGame")
 	If Value <> "" then
 		OptBallsPerGame = CDbl(Value)
 	Else
 		OptBallsPerGame = DefBallsPerGame
 	End If
 
 	Value = LoadValue(cGameName,"oReplay1")
 	If Value <> "" then
 		OptGoalScore(1) = CDbl(Value)
 	Else
 		OptGoalScore(1) = DefGoalScore1
 	End If
 
 	Value = LoadValue(cGameName,"oReplay2")
 	If Value <> "" then
 		OptGoalScore(2) = CDbl(Value)
 	Else
 		OptGoalScore(2) = DefGoalScore2
 	End If
 
 	Value = LoadValue(cGameName,"oReplay3")
 	If Value <> "" then
 		OptGoalScore(3) = CDbl(Value)
 	Else
 		OptGoalScore(3) = DefGoalScore3
 	End If
 
 	Value = LoadValue(cGameName,"oReplay4")
 	If Value <> "" then
 		OptGoalScore(4) = CDbl(Value)
 	Else
 		OptGoalScore(4) = DefGoalScore4
 	End If
 
 	Value = LoadValue(cGameName,"oMaxCredit")
 	If Value <> "" then
 		OptMaxCredits = CDbl(Value)
 	Else
 		OptMaxCredits = DefMaxCredits
 	End If

 	Value = LoadValue(cGameName,"oDefHighScore")
 	If Value <> "" then
 		OptDefaultHighScore = CDbl(Value)
 	Else
 		OptDefaultHighScore = DefHighScore1
 	End If

 	Value = LoadValue(cGameName,"oReplayCredits")
 	If Value <> "" then
 		OptReplayCredits = CDbl(Value)
 	Else
 		OptReplayCredits = DefReplayCredits
 	End If

	Value = LoadValue(cGameName,"oHiScoreCredits")
 	If Value <> "" then
 		OptHiScoreCredits = CDbl(Value)
 	Else
 		OptHiScoreCredits = DefHSCredits
 	End If

 	Value = LoadValue(cGameName,"oReplayAward")
 	If Value <> "" then
 		OptReplayAward = CDbl(Value)
 	Else
 		OptReplayAward = DefReplayAward
 	End If

 	Value = LoadValue(cGameName,"oBallSaverTime")
 	If Value <> "" then
 		OptBallSaverTime = CDbl(Value)
 	Else
 		OptBallSaverTime = DefBallSaver
 	End If 

 	Value = LoadValue(cGameName,"oMBBallSaverTime")
 	If Value <> "" then
 		OptMBBallSaverTime = CDbl(Value)
 	Else
 		OptMBBallSaverTIme = DefMBBallSaver
 	End If 

	Value = LoadValue(cGameName,"oTiltSens")
 	If Value <> "" then
 		OptTiltSens = CDbl(Value)
 	Else
 		OptTiltSens = DefTiltSens
 	End If

 	Value = LoadValue(cGameName,"oGameMusic")
 	If Value <> "" then
 		OptGameMusic = CDbl(Value)
 	Else
 		OptGameMusic = DefGameMusic
 	End If

 	Value = LoadValue(cGameName,"oDebugMode")
 	If Value <> "" then
 		OptDebugMode = CDbl(Value)
 	Else
 		OptDebugMode = DefDebugMode
 	End If 

  	Value = LoadValue(cGameName,"oTournament")
 	If Value <> "" then
		OptTournament= CDbl(Value)
 	Else
 		OptTournament = 0
 	End If

  	Value = LoadValue(cGameName,"oMaxEBGame")
 	If Value <> "" then
		OptMaxEBGame = CDbl(Value)
 	Else
 		OptMaxEBGame = DefMaxEBGame
 	End If

  	Value = LoadValue(cGameName,"oMaxEBBIP")
 	If Value <> "" then
		OptMaxEBBIP = CDbl(Value)
 	Else
 		OptMaxEBBIP = DefMaxEBBIP
 	End If

  	Value = LoadValue(cGameName,"sMatchReplays")
 	If Value <> "" then
 		StatMatchReplays = CDbl(Value)
 	Else
 		StatMatchReplays = 0
 	End If 

 	Value = LoadValue(cGameName,"sGamesPlayed")
 	If Value <> "" then
		StatGamesPlayed = CDbl(Value)
 	Else
 		StatGamesPlayed = 0
 	End If 

 	Value = LoadValue(cGameName,"sTotalPoints")
 	If Value <> "" then
 		StatTotalPoints = CDbl(Value)
 	Else
 		StatTotalPoints = 0
 	End If 

 	Value = LoadValue(cGameName,"sHighestScore")
 	If Value <> "" then
		StatHighestScore = CDbl(Value)
 	Else
 		StatHighestScore = 0
 	End If 

  	Value = LoadValue(cGameName,"sBallsPlayed")
 	If Value <> "" then
		StatBallsPlayed = CDbl(Value)
 	Else
 		StatBallsPlayed = 0
 	End If 

 	Value = LoadValue(cGameName,"sExtraBalls")
 	If Value <> "" then
		StatExtraBalls = CDbl(Value)
 	Else
 		StatExtraBalls = 0
 	End If 

 	Value = LoadValue(cGameName,"sHighZone")
 	If Value <> "" then
		StatHighestZone = CDbl(Value)
 	Else
 		StatHighestZone = 0
 	End If 

 	Value = LoadValue(cGameName,"sTotMultiballs")
 	If Value <> "" then
		StatZoneBattleMultiballs = CDbl(Value)
 	Else
 		StatZoneBattleMultiballs = 0
 	End If 

 	Value = LoadValue(cGameName,"sTotJackpots")
 	If Value <> "" then
		StatZoneBoostJackpots = CDbl(Value)
 	Else
 		StatZoneBoostJackpots = 0
 	End If 

 	Value = LoadValue(cGameName,"sHighBatZone")
 	If Value <> "" then
		StatHighBatZone = CDbl(Value)
 	Else
 		StatHighBatZone = 0
 	End If 

 	Value = LoadValue(cGameName,"sHighBatZoneWon")
 	If Value <> "" then
		StatHighBatZoneWon = CDbl(Value)
 	Else
 		StatHighBatZoneWon = 0
 	End If 

 	Value = LoadValue(cGameName,"sTotGameTime")
 	If Value <> "" then
		StatTimePlayedGame = CDbl(Value)
 	Else
 		StatTimePlayedGame = 0
 	End If 
 
 	Value = LoadValue(cGameName,"sTotBallTime")
 	If Value <> "" then
		StatTimePlayedBall = CDbl(Value)
 	Else
 		StatTimePlayedBall = 0
 	End If 

 	Value = LoadValue(cGameName,"sHist100K")
 	If Value <> "" then
		StatHistSub100K = CDbl(Value)
 	Else
 		StatHistSub100K = 0
 	End If 

 	Value = LoadValue(cGameName,"sHist249K")
 	If Value <> "" then
		StatHist100K_249K = CDbl(Value)
 	Else
 		StatHist100K_249K = 0
 	End If

 	Value = LoadValue(cGameName,"sHist499K")
 	If Value <> "" then
		StatHist250K_499K = CDbl(Value)
 	Else
 		StatHist250K_499K = 0
 	End If

 	Value = LoadValue(cGameName,"sHist999K")
 	If Value <> "" then
		StatHist500K_999K = CDbl(Value)
 	Else
 		StatHist500K_999K = 0
 	End If

 	Value = LoadValue(cGameName,"sHist1_4M")
 	If Value <> "" then
		StatHist1M_1_4M = CDbl(Value)
 	Else
 		StatHist1M_1_4M = 0
 	End If

 	Value = LoadValue(cGameName,"sHist1_9M")
 	If Value <> "" then
		StatHist1_5M_1_9M = CDbl(Value)
 	Else
 		StatHist1_5M_1_9M = 0
 	End If

 	Value = LoadValue(cGameName,"sHist2M")
 	If Value <> "" then
		StatHist2MAndUp = CDbl(Value)
 	Else
 		StatHist2MAndUp = 0
 	End If

 	Value = LoadValue(cGameName,"sTotZones")
 	If Value <> "" then
		StatTotalZones = CDbl(Value)
 	Else
 		StatTotalZones = 0
 	End If

 	Value = LoadValue(cGameName,"oBSDispOn")
 	If Value <> "" then
		OptBSDispOn = CDbl(Value)
 	Else
 		OptBSDispOn = 1
 	End If

 End Sub

' ******************************* Statistics Section ********************************************
'
' These subs handle the display of various game statistics.

' This will display the accumulated statistics. This can be modified to ahow additional stats if desired

 Sub DisplayStatistics()
 
 Dim MsgText
 
 	GetCalculatedStats()
 	MsgText = "Zone Fury VPX " & cVersion & chr(13)
	MsgText = MsgText & "Double Potions Pinball Table DPT-X03"
	MsgText = MsgText & chr(13) & chr(13) & "Can You Own the Zone??"
	MsgText = MsgText & chr(13) & chr(13) & "Table Design and Script coded by Neo. Rebuild from the VP9 version"
	MsgText = MsgText & chr(13) & "Based on WipeoutHD Fury by SCEE Studio Liverpool"
	MsgText = MsgText & chr(13) & "Logos based on the original game placed in honor of the Wipeout universe portrayed in the original games"
	MsgText = MsgText & chr(13)
	MsgText = MsgText & chr(13) & "Games Played : " & StatGamesPlayed
 	MsgText = MsgText & chr(13) & "Balls Played : " & StatBallsPlayed
 	MsgText = MsgText & chr(13) & "Highest Score: " & FormatNumber(StatHighestScore, 0, -1, 0, -1)
	MsgText = MsgText & chr(13) & "Average Score: " & FormatNumber(StatAvgScore, 0, -1, 0, -1)
	MsgText = MsgText & chr(13) & "Extra Balls Won/Pct-Game: " & StatExtraBalls & " / " & FormatPercent(StatXBallPct,1,-1,0,-1)	
	MsgText = MsgText & chr(13) & "Replays Won/Pct: " & StatTotalReplays & " / " & FormatPercent(StatReplayPct,1,-1,0,-1)	
	MsgText = MsgText & chr(13) & "Match Replays/Pct: " & StatMatchReplays & " / " & FormatPercent(StatMatchPct,1,-1,0,-1)
	MsgText = MsgText & chr(13) & "Average Play Time/Game (sec): " & FormatNumber(StatAvgTimePlayedGame, 0, -1, 0, -1)
	MsgText = MsgText & chr(13) & "Average Play Time/Ball (sec): " & FormatNumber(StatAvgTimePlayedBall, 0, -1, 0, -1)
	MsgText = MsgText & chr(13) & "Highest Zone Attained: " & StatHighestZone
	MsgText = MsgText & chr(13) & "Total Zones: " & StatTotalZones
	MsgText = MsgText & chr(13) & "Average Zone/Game: " & FormatNumber(StatAvgZoneGame, 0, -1, 0, -1)
	MsgText = MsgText & chr(13) & "Zone Battle Multiballs: " & StatZoneBattleMultiballs
	MsgText = MsgText & chr(13) & "Zone Boost Jackpots: " & StatZoneBoostJackpots
	MsgText = MsgText & chr(13) & "Highest Battle Zone: " & FormatNumber(StatHighBatZone,1,-1,0,-1)
	MsgText = MsgText & chr(13) & "Highest Zone Boost Won: " & FOrmatNumber(StatHighBatZoneWon,1,-1,0,-1)
	MsgText = MsgText & chr(13) & ""
	MsgText = MsgText & chr(13) & "Scores < 100,000: " & FormatNumber(StatHistSub100K, 0, -1, 0, -1) & " / " & FormatPercent(StatHistSub100KPct,1,-1,0,-1)
	MsgText = MsgText & chr(13) & "Scores 100,000-249,999: " & FormatNumber(StatHist100K_249K, 0, -1, 0, -1) & " / " & FormatPercent(StatHist100K_249KPct,1,-1,0,-1)
	MsgText = MsgText & chr(13) & "Scores 250,000-499,999: " & FormatNumber(StatHist250K_499K, 0, -1, 0, -1) & " / " & FormatPercent(StatHist250K_499KPct,1,-1,0,-1)
	MsgText = MsgText & chr(13) & "Scores 500,000-999,999: "  & FormatNumber(StatHist500K_999K, 0, -1, 0, -1) & " / " & FormatPercent(StatHist500K_999KPct,1,-1,0,-1)
	MsgText = MsgText & chr(13) & "Scores 1,000,000-1,499,999: " & FormatNumber(StatHist1M_1_4M, 0, -1, 0, -1) & " / " & FormatPercent(StatHist1M_1_4MPct,1,-1,0,-1)
	MsgText = MsgText & chr(13) & "Scores 1,500,000-1,999,999: " & FormatNumber(StatHist1_5M_1_9M, 0, -1, 0, -1) & " / " & FormatPercent(StatHist1_5M_1_9MPct,1,-1,0,-1) 
	MsgText = MsgText & chr(13) & "Scores 2,000,000 +: " & FormatNumber(StatHist2MAndUp, 0, -1, 0, -1) & " / " & FormatPercent(StatHist2MAndUpPct,1,-1,0,-1)  
	MsgBox MsgText, vbInformation
 
 End Sub	

 'This sub generates the calculated stats
 
 Sub GetCalculatedStats()
 
 	' Set the averages and percentages to zero if the number of games played is zero to avoid a division-by-0 error
 
 	If StatGamesPlayed = 0 then
 		StatAvgScore = 0
 		StatXBallPct = 0
 		StatReplayPct = 0
 		StatMatchPct = 0
		StatAvgZoneGame = 0
		StatAvgTimePlayedGame = 0
		StatHistSub100KPct = 0
		StatHist100K_249KPct = 0
		StatHist250K_499KPct = 0
		StatHist500K_999KPct = 0
		StatHist1M_1_4MPct = 0
		StatHist1_5M_1_9MPct = 0
		StatHist2MAndUpPct = 0
 	Else
 		StatAvgScore = StatTotalPoints \ StatGamesPlayed				' Integer-divide the total points by games played
 		StatXBallPct = (StatExtraBalls / StatGamesPlayed)
 		StatReplayPct = (StatTotalReplays / StatGamesPlayed)
 		StatMatchPct = (StatMatchReplays / StatGamesPlayed)
		StatAvgZoneGame = (StatTotalZones / StatGamesPlayed)
		StatAvgTimePlayedGame = (StatTimePlayedGame / StatGamesPlayed)
		StatHistSub100KPct = (StatHistSub100K / StatGamesPlayed)
		StatHist100K_249KPct = (StatHist100K_249K / StatGamesPlayed)
		StatHist250K_499KPct = (StatHist250K_499K / StatGamesPlayed)
		StatHist500K_999KPct = (StatHist500K_999K / StatGamesPlayed)
		StatHist1M_1_4MPct = (StatHist1M_1_4M / StatGamesPlayed)
		StatHist1_5M_1_9MPct = (StatHist1_5M_1_9M / StatGamesPlayed)
		StatHist2MAndUpPct = (StatHist2MAndUp / StatGamesPlayed)
 	End If
	If StatBallsPlayed = 0 Then
 		StatAvgTimePlayedBall = 0
	Else
		StatAvgTimePlayedBall = (StatTimePlayedBall / StatBallsPlayed)
	End If

 End Sub
 
 
 'This sub zeroes out all stats
 
Sub ClearStatistics()
 
 	StatGamesPlayed = 0
 	StatTotalPoints = 0
 	StatHighestScore = 0
 	StatBallsPlayed = 0
 	StatExtraBalls = 0
 	StatTotalReplays = 0
 	StatMatchReplays = 0
	StatHighestZone = 0
	StatHighBatZone = 0
	StatHighBatZoneWon = 0
	StatZoneBattleMultiballs = 0
	StatZoneBoostJackpots = 0
	StatTotalZones = 0
	StatTimePlayedGame = 0
	StatTimePlayedBall = 0
	StatHistSub100K = 0
	StatHist100K_249K = 0
	StatHist250K_499K = 0
	StatHist500K_999K = 0
	StatHist1M_1_4M = 0
	StatHist1_5M_1_9M = 0
	StatHist2MAndUp = 0
 	GetCalculatedStats()
 
End Sub

' Game time timers

Sub GameTimer_Timer()

	GameClockPulse(Player) = GameClockPulse(Player) + 1
	If GameClockPulse(Player) = 10 Then
		GameClockPulse(Player) = 0
		TimeInGame(Player) = TimeInGame(Player) + 1
	End If

End Sub

Sub BallTimer_Timer()

	BallClockPulse(Player) = BallClockPulse(Player) + 1
	If BallClockPulse(Player) = 10 Then
		BallClockPulse(Player) = 0
		TimeInBall(Player) = TimeInBall(Player) + 1
	End If

End Sub


' ************************************ Rulecard/Scorecard/Help Section **********************

' Help box (F2 in attract mode)
 
Sub GoHelp()
 
Dim MsgOut
 
 	MsgOut = "5 = Add Coin" & chr(13)
 	MsgOut = msgOut & "1 - Start Game (press multiple times for a 2, 3, or 4-player game)" & chr(13)
 	MsgOut = msgOut & "R - Show Rulecard" & chr(13)
 	MsgOut = msgOut & "T - Show Replay Card" & chr(13)
 	MsgOut = msgOut & "S - Show Statistics" & chr(13)
	MsgOut = msgOut & "Standard VP key assignments for plunger, flippers, and nudging" & chr(13) & chr(13)
	MsgOut = msgOut & "" & "Left Magna Save (Hold): Activate LUT lighting." & chr(13)
	MsgOut = msgOut & "" & "Right Magna Save  Select LUT lighting (only while Left Magna Save is held)." & chr(13)
	MsgOut = msgOut & "" & chr(13) 
	MsgOut = msgOut & "F6 - Operator Menu" & chr(13) 
 	MsgOut = msgOut & chr(13) & "In Operator Menu" & chr(13)
 	MsgOut = msgOut & "0 - Enter (forward one menu level)" & chr(13)
 	MsgOut = msgOut & "7 - Escape (back up one menu level)" & chr(13)
 	MsgOut = msgOut & "8 - Back One Choice in current menu" & chr(13)
 	MsgOut = msgOut & "9 - Forward one choice in menu" & chr(13)
	MsgOut = msgOut & "" & chr(13) 
 	MsgBox msgOut,vbInformation, " Key Assignments"
 
End Sub

' *************************** Credits Section *****************************
'
' Controls the adding of additional credits to the machine earned during play

Dim CredAdd

Sub AddCredits(ByVal cr)

	If cr > 3 then 										' Don't add more than 3 credits at once. Modify, remove, or comment out this if-then-else if you want to be able to be able to add more than 3 credits
		CredAdd = 3
	Else
		CredAdd = cr
	End If
	If cr = 1 then 
		AddCreditTimer.Interval = 417
	Else
		AddCreditTimer.Interval = 333
	End If
	AddCreditTimer.Enabled = True						' Turn on the timer

End Sub

Sub AddCreditTimer_Timer()

	If CredAdd > 0 then
		CredAdd = CredAdd - 1							' Deduct 1 from the number we're adding
'		PlaySound"knocker"								' The required knocker. It should knock once with each credit added
		PlaySound SoundFXDOF("knocker",122,DOFPulse,DOFContactors)	
		If OptTournament = 0 or GameOver then
			If Credits < OptMaxCredits Then
				Credits = Credits + 1					' Add 1 to the credits in the machine
			End If
			UpdateCredit Credits						' update the display
		Else
			If not Tilt then AddScore 100000, True		' Score 100,000 instead of adding a credit if we're in tournament mode and the game has not ended
		End If
	Else
		AddCreditTimer.Enabled = False					' We're done. turn the timer off
		AddCreditTimer.Interval = 417					' And also restore the interval
	End If
	
End Sub

' ************************************ Ball-Saver Section ***********************************

' These subs help control the two ball savers (general-play ball-saver, and multiball ball-saver). Both are controlled with a single timer

Dim BallSaver						' Indicates whether the ball-saver is active
Dim MBBallSaver						' indicates whether the multiball ball-saver is active
Dim BallSaved
Dim BallSaverSec					' Time remaining in current ball saver
Dim BallSaver10ths					' Decimal portion of ball saver timer (.1 - .9)

 
Sub ActivateBallSaver()				' Activate start-of-ball ball saver
 
 	BallSaver = True
	BallSaverSec = OptBallSaverTime
	BallSaver10ths = 0
 
End Sub

Sub ActivateMultiballBallSaver()	' Activate multiball ball saver
 
 	BallSaver = True
	BallSaverSec = OptMBBallSaverTime
	BallSaver10ths = 0
 	MBBallSaver = True
 
End Sub

Sub StartGeneralBallSaver(ByVal BSTime)				' Activate generic ball saver for a length as indiated by the BSTime parameter

	If GameMode <> 2 then 							' Are we in multiball?
		BallSaver = True							
	Else
		MBBallSaver = True							' Activate multiball ball saver if we're in Zone Battle Multiball
	End If
	BallSaverSec = BSTime
	BallSaver10ths = 0
	If BallSaverLightTimer.Enabled then BallSaverLightTimer.Enabled = False
	StartBallSaver()
 
End Sub

Sub AddBallSaverTime(ByVal BSTime)					' Add additional time to a running ball saver timer

	If BallSaverLightTimer.Enabled Then				
		BallSaverLightTimer.Enabled = False			' If we're in the ball saver grace period, turn this timer off and start a ball saver for the added time
		StartGeneralBallSaver BSTime
		Exit Sub
	End If
	BallSaverTimer.Enabled = False					' turn off ball saver time
	BallSaverSec = BallSaverSec + BSTime			' Add the extra ball save time
	BallSaverTimer.Enabled = True					' turn the ballsave timer back on

End Sub
	
	
  
Sub StartBallSaver()
 
 	BallSaverTimer.Enabled = True
	If BallSaver or MBBallSaver then 
		If OptBSDispOn Then
			DisplayBallSave BallSaverSec,BallSaver10ths
		Else
			BallSaveDisplayOff
			LSA.State = 2
			LSA2.State = 2
		End If
	End If
 
 End Sub
 
 Sub BallSaverTimer_Timer()

	BallSaver10ths = BallSaver10ths - 1
	If BallSaver10ths < 0 Then
		If BallSaverSec > 0 then 
			BallSaver10ths = 9
			BallSaverSec = BallSaverSec - 1
			Select Case BallSaverSec
			Case 4
				LSA.BlinkInterval = 100
				LSA2.BlinkInterval = 100
			Case 2,3
				LSA.BlinkInterval = 75
				LSA2.BlinkInterval = 75
			Case -1,0,1
				LSA.BlinkInterval = 50
				LSA2.BlinkInterval = 50
			Case Else
				LSA.BlinkInterval = 125
				LSA2.BlinkInterval = 125
			End Select
		Else 
			BallSaver10ths = 0
		End If
	End If
	If BallSaverSec <= 0 and BallSaver10ths <= 0 then
		BallSaverSec = 0
		BallSaver10ths = 0
		BallSaveDisplayOff
		LSA.State = 0
		LSA2.State = 0
		BallSaverTimer.Enabled = False
		BallSaverLightTimer.Enabled = True
		If ExtraBalls <> 0 then DisplaySA()
	Else
		If OptBSDispOn = 1 then 
			DisplayBallSave BallSaverSec,BallSaver10ths
			If BallSaverSec <= 4 then
				LSA.State = 2
				LSA2.State = 2
			Else
				LSA.State = 0
				LSA2.State = 0
			End If			
		Else
			BallSaveDisplayOff
			LSA.State = 2
			LSA2.State = 2
		End If
	End If
 
 End Sub
 
 Sub BallSaverLightTimer_Timer()
 
	BallSaverLightTimer.Enabled = False
	BallSaverLightTimer.Interval = 2000								' Restore ball-saver grace period to 2.0 seconds
	BallSaver = False
	MBBallSaver = False
 	
 End Sub

Sub BallReleaseSaved_Timer()

	BallRelease.CreateBall											' kick a ball from the plunger
	BallRelease.Kick 90,7
'	PlaySound"ballrelease"
	PlaySound SoundFXDOF("ballrelease",127,DOFPulse,DOFContactors)			' DOF 127 = ball release
	If GameMode <> 2 Then
		BallsToRelease(0) = BallsToRelease(0) - 1
		If BallsToRelease(0) = 0 then
			If BallSaved then BallSaved = False
		End If
		BallSaveDisplayOff
		BallSaverSec = 0
		BallSaver10ths = 0
		LSA.State = 0
		LSA2.State = 0
		LSA.BlinkInterval = 150
		LSA2.BlinkInterval = 150
		BallSaverTimer.Enabled = False											' One save per ball
		BallSaverLightTimer.Enabled = False
		BallReleaseSaved.Enabled = False
		BallSaver = False
		If ExtraBalls <> 0 then DisplaySA()
	Else
		BallsToRelease(1) = BallsToRelease(1) - 1
		If BallsToRelease(1) = 0 then BallReleaseSaved.Enabled = False
	End If
	AutoPlunger.TimerEnabled = True

End Sub	

' ************************************ Tilt-Mechanism Section *******************************
'
' These subs handle arguably the most infamous of all pinball devices, the tilt mechanism.
' Tilt functionality taken from shivaEngine. Thanks to shiva for making this mechanism available :-)
' Mechanism adapted to allow adjustable tilt sensitivity set in the Operator Menu

 ' This takes care of slowing down and stopping the tilt bob

 Sub TiltTimer_Timer() 								
 
     TiltSwing = (TiltSwing / 6) * 5 					' This reduces the swing to 83.33% of its previous value
     If TiltSwing < 0.001 Then
        TiltSwing = 0 							' Stop the swing when it goes below .001
        TiltTimer.Enabled = False 					' And turn off the tilt timer
     End If
     
 End Sub ' End of Sub TiltTimer_Timer

 
 ' This adds to the swing of the tilt bob and checks to see if we tilted
 
Sub TiltCheck()
 
  	 If OptTiltSens = 0 then Exit Sub			' If the tilt sensitivity is zero, we've turned the tilt mechanism off
 
     TiltTimer.Enabled = True 					' We nudged the machine so turn on the tilt timer
     
     If NewTilt = OldTilt Then 					' See if we are shaking the machine in the same direction as the last time
        TiltSwing = TiltSwing + 0.25 			' If so we get a bigger swing increase
     Else
        TiltSwing = TiltSwing + 0.18 			' If not we get a smaller increase
     End If
     
    OldTilt = NewTilt 							' Save the last nudge direction
 
	If TiltSwing > (OptTiltSens*0.7) and not TiltWarned then 
		PlaySound "Tilt Warning"
		TiltWarned = True
	End If

	If TiltSwing > OptTiltSens Then 			' If tiltswing goes over the tilt sensitivity then we tilted
		If not Tilt then PlaySound "Tilted Out"
		Tilt = True								' Set the machine to the tilted state
		TiltReel.SetValue 0
		Light1P.State = 0
		Light2P.State = 0
		Light3P.State = 0
		Light4P.State = 0
		BallSaverSec = 0: BallSaver10ths = 0:BallSaverTimer.Enabled = False: BallSaverLightTimer_Timer() ' Turn off all ball saver timers
		BallSaveDisplayOff()
		LSA.State = 0: LSA2.State = 0
		MasterSeq.Play SeqAllOff				' All Playfield lights off
		BoredomTimer.Enabled= False
		SwipeTimer.Enabled = False
		ScoreDisplayOff							' All displays off
		BallMatchDisplayOff
		CredDisplayOff
		StopAllMusic()
		If B2SOn Then
			Controller.B2SSetTilt 33,1
			Controller.B2SSetBallInPlay 32,0
			Controller.B2SSetData 40,0
			Controller.B2SSetData 41,0
			Controller.B2SSetData 42,0
			Controller.B2SSetData 43,0
		End If
  		Select Case GameMode
 		Case 2
		'	This is here in case we want to do things specific to the current game mode after tilting
 		Case Else
        End Select
     End If
     
 End Sub ' End of Sub TiltCheck


' ********************************* Operator's Menu Section **********************************
'
' These subs handle the meat of the operator-menu system. In this template, the operator menu controls certain game options
' that can be set to play a game to their liking. The template comes with 19 options by default. Additional options can be added 
' by table authors if desired starting with Option 20, though the process is a bit involved.
'
' To access the Operator's Menu, press F6 when the table is running Attract Mode. Navigating the operator menu is nearly identical to
' navigating the operator menus in an early-90s Williams or Bally DMD machine.
'
' 7-Key: Escape/Back
' 8-Key: Previous Option/Value
' 9-Key: Next Option/Value
' 0-Key: Enter/Confirm
'
' I originally developed this system for BGC2035, and I later adapted it to my Tokimeki Forever, Initial D, and Harry Potter tables.
'
' Adding new options is not the easiest thing to do. 
' These are the steps to add options if authors wish to add them
'
' -Change the Const MaxOptions to the total number of options after the ones you add. New options should start at Option 20
' -Define variables for the new options. I preface these with "Opt," such as OptTiltSens or OptBallsPerGame
' -Script the new options in the Key-Down sub under the case structure with 8-key, 9-key, and 0-key

' Sub GoOptions - this is called when we first go to the operator menu

  Sub GoOptions()
 
	StopAllMusic()
  	TableState = 2
   	CurrentOpt = 0
 	OptionLevel = 1
 	PlayfieldSeq.StopPlay
 	MasterSeq.Play SeqAllOff
	For z1 = 1 to 4
		Player = z1
 		PlayerDisplayOff
	Next
 	AttractTimer.Enabled = False
' 	Credtimer.Enabled = False
 	SeqTimer.Enabled = False
' 	BIPText.Text = ""
'	MatchText.Text = ""
	BIPReel.SetValue 1
	MatchReel.SetValue 1
 	UpdateCredit 0
 	BallMatchDisplayOff()
	If B2SOn then 
		Controller.B2SSetBallInPlay 32,0
		Controller.B2SSetMatch 34,0
		Controller.B2SSetData 25,0
	End If
 	CredText1.Text = "Options"
 	CredText2.Text = "7=Exit 8=Prev 9=Next 0=Enter"
' 	GameOverText.Text = "":
	GameOverReel.SetValue 1
	GameOverReel.TimerEnabled = False
	HSReel.SetValue 1
	HSReel.TimerEnabled = False
'	GameOverText.TimerEnabled = False
 
End Sub

' Timer sub that fires when we exit the options

Sub ExitOptionsTimer_Timer()
 
 	ExitOptionsTimer.Enabled = False
 	EndOptions()
 
End Sub
 
' Exits the option system and returns the table to attract mode

 Sub EndOptions()
 
  	TableState = 0
 	OptionLevel = 0
 	CurrentOpt = 0
 	MasterSeq.StopPlay
	CredText1.Text = ""
	CredText2.Text = ""
' 	MadeBy = 0                         ' Reset the attract-mode display control
 	AttractTimer.Enabled = True
' 	CredTimer.Enabled = True
	SequenceCount = 0
 	SeqTimer.Enabled = True
	StartAttractMode()
'	GameOverText.Text = "":GameOverText.TimerEnabled = True
	GameOverReel.SetValue 0: GameOverReel.TimerEnabled = False
'  	If Credits = 0 and not FreePlay then 
'		StartGameLight.State = 0
' 	Else
'		StartGameLight.State = 2
' 	End If
	ScoreDisplayOff()
	UpdateCredit Credits
	If OptGameMusic <> 0 then PlaySound "vpzonefuryintro"
 
 End Sub

 ' This sub will reset the high score to the default based on the options
 
 Sub ResetHighScore()
 
 	HighScore = OptDefaultHighScore
 
 End Sub
 
' This sub will set the table high score to the highest score the player has attained

 Sub HighScoretoHighestAttained()
 
 	HighScore = StatHighestScore
 
 End Sub

' Sub OptionsToDefault: This sub will reset all options to the "factory" defaults
 
 Sub OptionsToDefault()
 
	OptBallsPerGame = DefBallsPerGame							' Set Balls Per Game
 	OptGoalScore(1) = DefGoalScore1								' Set all 4 replay score levels
 	OptGoalScore(2) = DefGoalScore2
 	OptGoalScore(3) = DefGoalScore3
 	OptGoalScore(4) = DefGoalScore4
 	OptMaxCredits = DefMaxCredits								' Set the maximum credits
 	OptDefaultHighScore = DefHighScore1							' Set default high score
 	OptReplayCredits = DefReplayCredits							' Set the number of credits for a replay
 	OptReplayAward = DefReplayAward								' Set the type of award for a replay score
 	OptHiScoreCredits = DefHSCredits							' Number of credits for a high score
 	OptBallSaverTime = DefBallSaver								' Default Ball Saver time
 	OptMBBallSaverTime = DefMBBallSaver							' Multiball Ball Saver time
 	OptTiltSens = DefTiltSens									' Default tilt sensitivity
 	OptGameMusic = DefGameMusic									' Default game music on/off									
 	OptDebugMode = DefDebugMode									' Debug mode on/off
	OptTournament = DefTournament								' Tournament Mode on/off
	OptMaxEBGame = DefMaxEBGame									' Max Extra Balls/Game
	OptMaxEBBIP = DefMaxEBBIP									' Max Extra Balls/Ball-In-Play
 	UpdateOptions()												' Update the options
 
 End Sub

 ' UpdateOptions: This sub updates the settings to match the updated options
 
 Sub UpdateOptions()
 
  	For z1 = 1 to 4												' Get the replay scores from the options
		GoalScore(z1) = OptGoalScore(z1)
 	Next
 
  	If TableState <> 2 then										' Set the TableState to 1 if we're in debug mode
		Select Case OptDebugMode
		Case 0
			TableState = 0
		Case 1
			TableState = 1
		End Select
 	End If

  	If OptMaxCredits = 0 then
 		FreePlay = True								
 	Else
 		FreePlay = False
 	End If

  	OptClearStats = 0											' Set the clear/reset options to 0
	OptResetHighScore = 0
 	OptOptionstoDefault = 0
 	OptHStoHighestScore = 0

 End Sub

' THis sub displays the options in the CredText text boxes

 Sub DisplayOption()
 
 Dim OptText
 
 	BallMatchDisplayOff()
 	CredDisplayOff()
	ScoreDisplayOff()
 	Player = 0
 	UpdateCredit CurrentOpt
  	Select Case CurrentOpt
 	Case 1
 		CredText1.Text = "Balls Per Game"
 		UpdateBall OptBallsPerGame
 	Case 2
 		CredText1.Text = "Replay Score Level 1"
 		Player = 3
 		UpdateScore OptGoalScore(1)
 	Case 3
 		CredText1.Text = "Replay Score Level 2"
 		Player = 3
 		UpdateScore OptGoalScore(2)
 	Case 4
 		CredText1.Text = "Replay Score Level 3"
 		Player = 3
 		UpdateScore OptGoalScore(3)
  	Case 5
 		CredText1.Text = "Replay Score Level 4"
		Player = 3
		UpdateScore OptGoalScore(4)
  	Case 6
 		CredText1.Text = "Max Credits"
 		UpdateMatch OptMaxCredits
 	Case 7
 		CredText1.Text = "Default High Score"
 		Player = 3
 		UpdateScore OptDefaultHighScore
 	Case 8
 		CredText1.Text = "Replay Credits"
 		UpdateBall OptReplayCredits
  	Case 9
 		CredText1.Text = "Replay Award"
 		UpdateBall OptReplayAward
 	Case 10
 		CredText1.Text = "High Score Credits"
 		UpdateBall OptHiScoreCredits
  	Case 11
		CredText1.Text = "Ball Saver Time (sec)"
 		UpdateMatch OptBallSaverTime
 	Case 12
   		CredText1.Text = "Multiball Saver Time (sec)"
 		UpdateMatch OptMBBallSaverTime
 	Case 13
   		CredText1.Text = "Tilt Sensitivity"
 		Player = 3
 		UpdateScore OptTiltSens*1000
  	Case 14
   		CredText1.Text = "Game Music"
 		UpdateBall OptGameMusic
  	Case 15
   		CredText1.Text = "Debug Mode On/Off"
 		UpdateBall OptDebugMode
 	Case 16
   		CredText1.Text = "Clear Statistics"
 		UpdateBall OptClearStats
 	Case 17
   		CredText1.Text = "Reset High Score"
 		UpdateBall OptClearStats
 	Case 18
   		CredText1.Text = "Options to Defaults"
 		UpdateBall OptClearStats
	Case 19
   		CredText1.Text = "Hi Score to Best Attained"
 		UpdateBall OptHStoHighestScore
	Case 20
   		CredText1.Text = "Tournament Mode"
 		UpdateBall OptTournament
	Case 21
   		CredText1.Text = "Max E.B. Per Game"
 		UpdateBall OptMaxEBGame
	Case 22
   		CredText1.Text = "Max E.B. Per B.I.P"
		If OptMaxEBBIP < 10 then UpdateBall OptMaxEBBIP
  	Case 23
   		CredText1.Text = "Ball Save Display On/Off"
 		UpdateBall OptBSDispOn	
   	End Select
 
 End Sub

' Sub OptionCompleteTimer: This fires when we're done updating certain options

 Sub OptionCompleteTimer_Timer()
 
 	OptionCompleteTimer.Enabled = False
 	CredText1.Text = "Update Complete"
 	OptionLevel = 1
 	Select Case CurrentOpt
 	Case 16
 		ClearStatistics()
 	Case 17
 		ResetHighScore()
 	Case 18
 		OptionsToDefault()
 	Case 19
 		HighScoretoHighestAttained()
	Case 20
		OptTournament = WorkOption
 	End Select
 
 End Sub


'*****GI Lights On
dim xx

For each xx in GI:xx.State = 1: Next

'**********Sling Shot Animations
' Rstep and Lstep  are the variables that increment the animation
'****************
Dim RStep, Lstep

Sub RightSlingShot_Slingshot

'    PlaySound "right_slingshot", 0, 1, 0.05, 0.05
    PlaySound SoundFXDOF("right_slingshot", 104, DOFPulse, DOFcontactors), 0, 1, 0.05, 0.05
    RSling.Visible = 0
    RSling1.Visible = 1
    sling1.TransZ = -20
    RStep = 0
    RightSlingShot.TimerEnabled = 1
	If not Tilt then 
		AddScore 20,True	
		If SpecialLit(player) then SwitchSpecial()
	End If

End Sub

Sub RightSlingShot_Timer
    Select Case RStep
        Case 3:RSLing1.Visible = 0:RSLing2.Visible = 1:sling1.TransZ = -10
        Case 4:RSLing2.Visible = 0:RSLing.Visible = 1:sling1.TransZ = 0:RightSlingShot.TimerEnabled = 0:gi1.State = 1:Gi2.State = 1
    End Select
    RStep = RStep + 1
End Sub

Sub LeftSlingShot_Slingshot

'    PlaySound "left_slingshot",0,1,-0.05,0.05
    PlaySound SoundFXDOF("left_slingshot", 103, DOFPulse, DOFcontactors),0,1,-0.05,0.05
    LSling.Visible = 0
    LSling1.Visible = 1
    sling2.TransZ = -20
    LStep = 0
    LeftSlingShot.TimerEnabled = 1
	If not Tilt then 
		AddScore 20,True	
		If SpecialLit(player) then SwitchSpecial()
	End If

End Sub

Sub LeftSlingShot_Timer
    Select Case LStep
        Case 3:LSLing1.Visible = 0:LSLing2.Visible = 1:sling2.TransZ = -10
        Case 4:LSLing2.Visible = 0:LSLing.Visible = 1:sling2.TransZ = 0:LeftSlingShot.TimerEnabled = 0:gi3.State = 1:Gi4.State = 1
    End Select
    LStep = LStep + 1
End Sub

' Rubbers behind drop targets

Sub LockRubber_Hit()

	If not Tilt then
		PlaySound "shipship"
		AddScore 50,True
	End If

End Sub	

Sub EGXRubber_Hit()

	If not Tilt then
		PlaySound "shipship"
		AddScore 30,True
	End If

End Sub	

Sub G45Rubber_Hit()

	If not Tilt then
		PlaySound "shipship"
		AddScore 30,True
	End If

End Sub	

'**********************************************************************
' Score-Adding Section
'**********************************************************************

Sub AddScore(Points,ApplyMult)
	
	BoredomTimer.Enabled = False												' Turn off the boredom and swipe timers
	SwipeTimer.Enabled = False
	If not GameOver and not Tilt then
		If not ApplyMult then
			Score(player) = Score(player) + (Points)
		Else
			Score(Player) = Score(Player) + (Points * FieldMultiplier)
		End If
 		UpdateScore(Score(player))

		If GameMode = 2 then										' If we're in multiball, check to see if we need to bump the Battle Zone
			TargetsHit = TargetsHit + 1
			If TargetsHit Mod 10 = 0 then AdvanceBattleZone 0.1		' Bump the Battle Zone with every 10 targets hit in multiball
		End If

 		If GoalScore(1) <> 0 then
			If Score(player) >= GoalScore(1) and not GoalScoreMade(1,player) and OptTournament = 0 then
				GoalScoreMade(1,player) = True	
				If not OptDebugMode then StatTotalReplays = StatTotalReplays + 1
				AddCredits 1
			End If
		End If
		If GoalScore(2) <> 0 then
			If Score(player) >= GoalScore(2) and not GoalScoreMade(2,player) and OptTournament = 0 then
				GoalScoreMade(2,player) = True
				If not OptDebugMode then StatTotalReplays = StatTotalReplays + 1
				AddCredits 1
			End If
		End If
		If GoalScore(3) <> 0 then
			If Score(player) >= GoalScore(3) and not GoalScoreMade(3,player) and OptTournament = 0 then
				GoalScoreMade(3,player) = True
				If not OptDebugMode then StatTotalReplays = StatTotalReplays + 1
				AddCredits 1
			End If
 		End If
		If GoalScore(4) <> 0 then
			If Score(player) >= GoalScore(4) and not GoalScoreMade(4,player) and OptTournament = 0 then
				GoalScoreMade(4,player) = True
				If not OptDebugMode then StatTotalReplays = StatTotalReplays + 1
				AddCredits 1
			End If
		End If
		If not GameOver then BoredomTimer.Enabled = True													' Turn the boredom timer back on when we've finished adding the score
	End If

End Sub



'***************************************************************
'             Supporting Ball & Sound Functions v3.0
'  includes random pitch in PlaySoundAt and PlaySoundAtBall
'***************************************************************

Dim TableWidth, TableHeight

TableWidth = ZoneFury.width
TableHeight = ZoneFury.height

Function Vol(ball) ' Calculates the Volume of the sound based on the ball speed
    Vol = Csng(BallVel(ball) ^2 / 2000)
End Function

Function Pan(ball) ' Calculates the pan for a ball based on the X position on the table. "ZoneFury" is the name of the table
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
    PlaySound soundname, 0, 1, Pan(tableobj), 0.1, 0, 0, 0, AudioFade(tableobj)
End Sub

Sub PlaySoundAtBall(soundname) ' play a sound at the ball position, like rubbers, targets, metals, plastics
    PlaySound soundname, 0, Vol(ActiveBall), pan(ActiveBall), 0.2, Pitch(ActiveBall) * 10, 0, 0, AudioFade(ActiveBall)
End Sub

Function RndNbr(n) 'returns a random number between 1 and n
    Randomize timer
    RndNbr = Int((n * Rnd) + 1)
End Function

'****************************************************
'   JP's VPX7 Rolling Sounds + Ballshadow
'   limits the ball speed using the maxvel constant
'****************************************************

Const tnob = 19   'total number of balls, 20 balls, from 0 to 19
Const lob = 0     'number of locked balls
Const maxvel = 42 'max ball velocity
ReDim rolling(tnob)
InitRolling

Sub InitRolling
    Dim i
    For i = 0 to tnob
        rolling(i) = False
    Next
End Sub

Sub RollingTimer_Timer()
    Dim BOT, b, ballpitch, ballvol, speedfactorx, speedfactory
    BOT = GetBalls

    ' stop the sound of deleted balls and hide the shadow
    For b = UBound(BOT) + 1 to tnob
        rolling(b) = False
        StopSound("fx_ballrolling" & b)
'        aBallShadow(b).Y = 3000
    Next

    ' exit the sub if no balls on the table
    If UBound(BOT) = lob - 1 Then Exit Sub 'there no extra balls on this table

    ' play the rolling sound for each ball and draw the shadow
    For b = lob to UBound(BOT)
'        aBallShadow(b).X = BOT(b).X
 '       aBallShadow(b).Y = BOT(b).Y

        If BallVel(BOT(b))> 1 Then
            If BOT(b).z <30 Then
                ballpitch = Pitch(BOT(b))
                ballvol = Vol(BOT(b))
            Else
                ballpitch = Pitch(BOT(b)) + 25000 'increase the pitch on a ramp
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



'************************************
' What you need to add to your table
'************************************

' a timer called RollingTimer. With a fast interval, like 10
' one collision sound, in this script is called fx_collide
' as many sound files as max number of balls, with names ending with 0, 1, 2, 3, etc
' for ex. as used in this script: fx_ballrolling0, fx_ballrolling1, fx_ballrolling2, fx_ballrolling3, etc


'******************************************
' Explanation of the rolling sound routine
'******************************************

' sounds are played based on the ball speed and position

' the routine checks first for deleted balls and stops the rolling sound.

' The For loop goes through all the balls on the table and checks for the ball speed and 
' if the ball is on the table (height lower than 30) then then it plays the sound
' otherwise the sound is stopped, like when the ball has stopped or is on a ramp or flying.

' The sound is played using the VOL, PAN and PITCH functions, so the volume and pitch of the sound
' will change according to the ball speed, and the PAN function will change the stereo position according
' to the position of the ball on the table.


'**************************************
' Explanation of the collision routine
'**************************************

' The collision is built in VP.
' You only need to add a Sub OnBallBallCollision(ball1, ball2, velocity) and when two balls collide they 
' will call this routine. What you add in the sub is up to you. As an example is a simple Playsound with volume and paning
' depending of the speed of the collision.


Sub Pins_Hit (idx)
	PlaySound "pinhit_low", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 0, 0
End Sub

Sub Targets_Hit (idx)
	PlaySound "target", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 0, 0
End Sub

Sub Metals_Thin_Hit (idx)
	PlaySound "metalhit_thin", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0
End Sub

Sub Metals_Medium_Hit (idx)
	PlaySound "metalhit_medium", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0
End Sub

Sub Metals2_Hit (idx)
	PlaySound "metalhit2", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0
End Sub

Sub Gates_Hit (idx)
	PlaySound "gate4", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0
End Sub

Sub Rubbers_Hit(idx)
 	dim finalspeed
  	finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
 	If finalspeed > 20 then 
		PlaySound "fx_rubber2", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0
	End if
	If finalspeed >= 6 AND finalspeed <= 20 then
 		RandomSoundRubber()
 	End If
End Sub

Sub Posts_Hit(idx)
 	dim finalspeed
  	finalspeed=SQR(activeball.velx * activeball.velx + activeball.vely * activeball.vely)
 	If finalspeed > 16 then 
		PlaySound "fx_rubber2", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0
	End if
	If finalspeed >= 6 AND finalspeed <= 16 then
 		RandomSoundRubber()
 	End If
End Sub

Sub RandomSoundRubber()
	Select Case Int(Rnd*3)+1
		Case 1 : PlaySound "rubber_hit_1", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0
		Case 2 : PlaySound "rubber_hit_2", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0
		Case 3 : PlaySound "rubber_hit_3", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0
	End Select
End Sub

Sub LeftFlipper_Collide(parm)
    PlaySound "fx_rubber_flipper", 0, parm / 60, pan(ActiveBall), 0.2, 0, 0, 0, AudioFade(ActiveBall)
End Sub

Sub RightFlipper_Collide(parm)
    PlaySound "fx_rubber_flipper", 0, parm / 60, pan(ActiveBall), 0.2, 0, 0, 0, AudioFade(ActiveBall)
End Sub

Sub RandomSoundFlipper()
	Select Case Int(Rnd*3)+1
		Case 1 : PlaySound "flip_hit_1", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0
		Case 2 : PlaySound "flip_hit_2", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0
		Case 3 : PlaySound "flip_hit_3", 0, Vol(ActiveBall), Pan(ActiveBall), 0, Pitch(ActiveBall), 1, 0
	End Select
End Sub

' ****************************** Display System Section *******************************************************

' Williams System-6 through System-9 Style 4x7-digit Numeric Display System 1.0.0
' 2012 Double Potions Pinball Productions
'
' All code related to the displays will be located here
'
' Define the number patterns for all displays
'
' The numbers are similar to Williams System 7 displays (7-segment numeric displays)
' The segment patterns will work for the score as well as the ball and credit displays
'
' Segments are defined as follows.
'
'      6
'   _______
'  |       |
'  |       |
' 5|       |1
'  |   7   |
'  |_______|
'  |       |
'  |       |
' 4|       |2
'  |   3   |
'  |_______|
'
' If additional segments are needed for your particular table, copy and paste from the row you want to add and rename the lights based on the row you're adding,
' starting with the next number up from the highest pre-defined number (for a score the highest segment name would be "ScoreX_49" so you would start with "ScoreX_50"
' You'll need to do this for each player, and you would also need to change the ScoreLength constant at the top of the script to the number of digits

Dim Pattern7Seg(11)											' Numeric Digit Patterns (0-9)

Pattern7Seg(0)=Array(1,1,1,1,1,1,0)			 				' Pattern for 0				
Pattern7Seg(1)=Array(1,1,0,0,0,0,0)							' Pattern for 1 
Pattern7Seg(2)=Array(1,0,1,1,0,1,1)							' Pattern for 2
Pattern7Seg(3)=Array(1,1,1,0,0,1,1)							' Pattern for 3
Pattern7Seg(4)=Array(1,1,0,0,1,0,1)							' Pattern for 4
Pattern7Seg(5)=Array(0,1,1,0,1,1,1)							' Pattern for 5
Pattern7Seg(6)=Array(0,1,1,1,1,1,1)							' Pattern for 6
Pattern7Seg(7)=Array(1,1,0,0,0,1,0)							' Pattern for 7
Pattern7Seg(8)=Array(1,1,1,1,1,1,1)							' Pattern for 8
Pattern7Seg(9)=Array(1,1,1,0,1,1,1)							' Pattern for 9

															' Alphabetic Patterns (10+)
Pattern7Seg(10)=Array(1,1,0,1,1,1,1)						' Pattern for A
Pattern7Seg(11)=Array(0,1,1,0,1,1,1)						' Pattern for S

Sub DisplayZone(ByVal Zn)
 
Dim Count, Value, Calc, Selected, Segment, Tmp, Tmp2
 
 	ZoneDisplayOff()											' Clear out the Ball Display before updating

	Tmp = Zn													' Set Tmp to the value of the input parameter

	If Zn <= 999 then 
		Tmp = Zn												' Set Tmp to the value of the input parameter
	Else
		Tmp = Right(Zn,3)										' Display cannot hold more than 3 digits
	End If

    For Selected=Len(Tmp) to 1 Step -1							' Get the number of digits to process 
    	Calc=(10^Selected/10)									' The required formula - Helps determine highest digit position
    	Value=Tmp\Calc											' Get the value of the highest digit
		Tmp=Tmp-(Value*Calc)									' Remove the highest digit from value of Tmp
    	For Count=(Selected*7)-6 To (Selected*7)				' Calculate display digit number
    		Segment=(Count-1) Mod 7								' Calculate segment number within digit
    		Tmp2=Eval("Pattern7Seg("&Value&")("&Segment&")") 	' Get the segment state from the array
     		Eval("Zone_"&Count).State=Tmp2		  				' Update the segment
    	Next													' Repeat until all 7 segments are updated
    Next														' Repeat until all digits are updated
	If GameMode = 2 then ZoneComma_3.State = 1

End Sub

' Sub ZoneDisplayOff()
' This turns the Zone display off

Sub ZoneDisplayOff()

Dim i
	
	For i = 1 to 21
 		Eval("Zone_"&i).State = 0
	Next	
	ZoneComma_3.State = 0

End Sub

Sub DisplayBallSave(ByVal BSD,BSD10th)

Dim Count, Value, Calc, Selected, Segment, Tmp, Tmp2

	BallSaveDisplayOff()
	Tmp = BSD
	If BSD > 99 Then
		Tmp = 99
	Else
		Tmp = BSD
	End If
	
	If Tmp >= 10 Then
		For Selected=Len(Tmp) to 1 Step -1							' Get the number of digits to process 
			Calc=(10^Selected/10)									' The required formula - Helps determine highest digit position
			Value=Tmp\Calc											' Get the value of the highest digit
			Tmp=Tmp-(Value*Calc)									' Remove the highest digit from value of Tmp
			For Count=(Selected*7)-6 To (Selected*7)				' Calculate display digit number
				Segment=(Count-1) Mod 7								' Calculate segment number within digit
				Tmp2=Eval("Pattern7Seg("&Value&")("&Segment&")") 	' Get the segment state from the array
				Eval("BS_"&Count).State=Tmp2		  				' Update the segment
			Next													' Repeat until all 7 segments are updated
		Next	
	Else
		BSC_3.State = 1											' decimal point on
		Selected = 2											' Put the value on the leftmost digit in the display
		Calc = (10^Selected/10)									' The required formula - Helps determine highest digit position
		Value = Tmp
		Tmp = Tmp-(Value*Calc)
		For Count=(Selected*7)-6 To (Selected*7)				' Calculate display digit number
			Segment=(Count-1) Mod 7								' Calculate segment number within digit
			Tmp2=Eval("Pattern7Seg("&Value&")("&Segment&")") 	' Get the segment state from the array
			Eval("BS_"&Count).State=Tmp2		  				' Update the segment
		Next													' Repeat until all 7 segments are updated
		Tmp = BSD10th											' Get the decimal portion and put it in the rightmost display position
		Selected = 1
		Calc = (10^Selected/10)
		Value = Tmp\Calc
		Tmp = Tmp-(Value*Calc)
		For Count=(Selected*7)-6 To (Selected*7)				' Calculate display digit number
			Segment=(Count-1) Mod 7								' Calculate segment number within digit
			Tmp2=Eval("Pattern7Seg("&Value&")("&Segment&")") 	' Get the segment state from the array
			Eval("BS_"&Count).State=Tmp2		  				' Update the segment
		Next													' Repeat until all 7 segments are updated
	End If

End Sub


Sub BallSaveDisplayOff()

Dim i
	
	For i = 1 to 14
 		Eval("BS_"&i).State = 0
	Next
	BSC_3.State = 0

End Sub

' Displays "SA" when we earn an extra ball

Sub DisplaySA()

Dim Count,Selected, Segment, Tmp2

	BallSaveDisplayOff
	LSA.State = 1
	LSA2.State = 1
	Selected = 2
	For Count=(Selected*7)-6 To (Selected*7)				' Calculate display digit number
		Segment=(Count-1) Mod 7								' Calculate segment number within digit
		Tmp2=Eval("Pattern7Seg(11)("&Segment&")") 			' Get the segment state from the array
		Eval("BS_"&Count).State=Tmp2		  				' Update the segment
	Next													' Repeat until all 7 segments are updated
	Selected = 1
	For Count=(Selected*7)-6 To (Selected*7)				' Calculate display digit number
		Segment=(Count-1) Mod 7								' Calculate segment number within digit
		Tmp2=Eval("Pattern7Seg(10)("&Segment&")") 			' Get the segment state from the array
		Eval("BS_"&Count).State=Tmp2		  				' Update the segment
	Next													' Repeat until all 7 segments are updated
	
End Sub

' ************************************* Zone Section **************************************
'
' This section contains the subs for initializing and advancing Zones in general play (Game Mode 1)
' The Multiball section will deal with Zone Battle Multiball
'

' Sub InitializeZones. This sub initializes the Zone counters of all players at the start of the game.

Sub InitializeZones()

Dim i,oFlipper, oLight

	For i = 1 to 4
		Zone(i) = 0										' Start at Zone 0
		ZoneName(i) = "Sub-Venom"						' Zone 0 = Sub-Venom
		ZoneVelMultiplier(i) = 1						' Velocity multiplier starts at 1
		BattleZone(i) = 0.1								' Set the Battle Zone to 0.1 at game start
		For Each oFlipper in collLeftFlipper
			oFlipper.Visible = False
		Next
		For Each oFlipper in collRightFlipper
			oFlipper.Visible = False
		Next
		LeftFlipperSubVenom.Visible = True
		RightFlipperSubVenom.Visible = True
		ZoneForce(i) = 10
	Next
	ZoneDisplayOff()
	For Each OLight in CollZoneLights
		oLight.State = 0
	Next
	GILightsNormal()
'	For Each oLight in GI
'		oLight.Color = RGB(207,203,148)
'		oLight.ColorFull = RGB (255,255,190)
'	Next
'	For Each oLight in CollPlasticBorders
'		oLight.Image = "Zone27_SuperPhantom"
'	Next

End Sub

Sub GILightsNormal()

Dim oLight, oFlipper

	For Each oLight in GI_Color
		oLight.Color = RGB(207,203,148)
		oLight.ColorFull = RGB (255,255,190)
	Next

	For Each oFlipper in collLeftFlipper
		oFlipper.Visible = False
	Next
	For Each oFlipper in collRightFlipper
		oFlipper.Visible = False
	Next
	LeftFlipperSubVenom.Visible = True
	RightFlipperSubVenom.Visible = True

End Sub

' Sub GetZone. This retrieves the current player's Zone and puts it on the Zone display. Will also set the Zone lights based on the named Zone

Sub GetZone()

Dim oBumper

	DisplayZone Zone(Player)							' put the Zone number on the display
	GetZoneName()										' Set the Zone lights based on the current Named Zone
	For Each oBumper in CollBumpers
		oBumper.Force = ZoneForce(Player)
	Next

End Sub

' Sub GetZoneName. This sets the Zone Name lights based on the current player's Zone Name

Sub GetZoneName()

Dim oLight, oFlipper

	For each oLight in collZoneLights
		oLight.State = 0								' turn off all Zone lights first
	Next
	For Each oFlipper in collLeftFlipper
		oFlipper.Visible = False
		oFlipper.Enabled = False
	Next
	For Each oFlipper in collRightFlipper
		oFlipper.Visible = False
		oFlipper.Enabled = False
	Next

	Select Case ZoneName(Player)						' Turn on only the Zone lights we need
	Case "Sub-Venom"
		LSubVenom.State = 2
		LeftFlipperSubVenom.Visible = True
		RightFlipperSubVenom.Visible = True
		LeftFlipperSubVenom.Enabled = True
		RightFlipperSubVenom.Enabled = True
		For Each oLight in GI_Color
			oLight.Color = RGB(207,203,148)
			oLight.ColorFull = RGB (255,255,190)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone00_SubVenom"
'		Next
	Case "Venom"
		LSubVenom.State = 1
		LVenom.State = 2
		LeftFlipperVenom.Visible = True
		RightFlipperVenom.Visible = True
		LeftFlipperVenom.Enabled = True
		RightFlipperVenom.Enabled = True
		For Each oLight in GI_Color
			oLight.Color = RGB(128,255,0)
			oLight.ColorFull = RGB (0,251,251)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone02_Venom"
'		Next
	Case "Sub-Flash"
		LSubVenom.State = 1
		LVenom.State = 1
		LSubFlash.State = 2
		LeftFlipperSubFlash.Visible = True
		RightFlipperSubFlash.Visible = True
		LeftFlipperSubFlash.Enabled = True
		RightFlipperSubFlash.Enabled = True	
		For Each oLight in GI_Color
			oLight.Color = RGB(221,111,0)
			oLight.ColorFull = RGB (0,106,213)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone03_SubFlash"
'		Next
	Case "Flash"
		LSubVenom.State = 1
		LVenom.State = 1
		LSubFlash.State = 1
		LFlash.State = 2
		LeftFlipperFlash.Visible = True
		RightFlipperFlash.Visible = True
		LeftFlipperFlash.Enabled = True
		RightFlipperFlash.Enabled = True
		For Each oLight in GI_Color
			oLight.Color = RGB(255,255,128)
			oLight.ColorFull = RGB (150,0,150)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone05_Flash"
'		Next
	Case "Sub-Rapier"
		LSubVenom.State = 1
		LVenom.State = 1
		LSubFlash.State = 1
		LFlash.State = 1
		LSubRapier.State = 2
		LeftFlipperSubRapier.Visible = True
		RightFlipperSubRapier.Visible = True
		LeftFlipperSubRapier.Enabled = True
		RightFlipperSubRapier.Enabled = True
		For Each oLight in GI_Color
			oLight.Color = RGB(255,0,255)
			oLight.ColorFull = RGB (255,83,0)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone07_SubRapier"
'		Next
	Case "Rapier"
		LSubVenom.State = 1
		LVenom.State = 1
		LSubFlash.State = 1
		LFlash.State = 1
		LSubRapier.State = 1
		LRapier.State = 2
		LeftFlipperRapier.Visible = True
		RightFlipperRapier.Visible = True
		LeftFlipperRapier.Enabled = True
		RightFlipperRapier.Enabled = True
		For Each oLight in GI_Color
			oLight.Color = RGB(240,78,0)
			oLight.ColorFull = RGB (193,0,193)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone12_Repier"
'		Next
	Case "Sub-Phantom"
		LSubVenom.State = 1
		LVenom.State = 1
		LSubFlash.State = 1
		LFlash.State = 1
		LSubRapier.State = 1
		LRapier.State = 1
		LSubPhantom.State = 2
		LeftFlipperSubPhantom.Visible = True
		RightFlipperSubPhantom.Visible = True
		LeftFlipperSubPhantom.Enabled = True
		RightFlipperSubPhantom.Enabled = True
		For Each oLight in GI_Color
			oLight.Color = RGB(255,89,255)
			oLight.ColorFull = RGB (236,118,0)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone16_SubPhantom"
'		Next
	Case "Phantom"
		LSubVenom.State = 1
		LVenom.State = 1
		LSubFlash.State = 1
		LFlash.State = 1
		LSubRapier.State = 1
		LRapier.State = 1
		LSubPhantom.State = 1
		LPhantom.State = 2
		LeftFlipperPhantom.Visible = True
		RightFlipperPhantom.Visible = True
		LeftFlipperPhantom.Enabled = True
		RightFlipperPhantom.Enabled = True
		For Each oLight in GI_Color
			oLight.Color = RGB(220,220,220)
			oLight.ColorFull = RGB (244,80,0)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone20_Phantom"
'		Next
	Case "Super-Phantom"
		LSubVenom.State = 1
		LVenom.State = 1
		LSubFlash.State = 1
		LFlash.State = 1
		LSubRapier.State = 1
		LRapier.State = 1
		LSubPhantom.State = 1
		LPhantom.State = 1
		LSuperPhantom.State = 2
		LeftFlipperSuperPhantom.Visible = True
		RightFlipperSuperPhantom.Visible = True
		LeftFlipperSuperPhantom.Enabled = True
		RightFlipperSuperPhantom.Enabled = True
		For Each oLight in GI_Color
			oLight.Color = RGB(207,203,148)
			oLight.ColorFull = RGB (253,207,0)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone27_SuperPhantom"
'		Next
	Case "Zen"
		LSubVenom.State = 1
		LVenom.State = 1
		LSubFlash.State = 1
		LFlash.State = 1
		LSubRapier.State = 1
		LRapier.State = 1
		LSubPhantom.State = 1
		LPhantom.State = 1
		LSuperPhantom.State = 1
		LZen.State = 2
		LeftFlipperZen.Visible = True
		RightFlipperZen.Visible = True
		LeftFlipperZen.Enabled = True
		RightFlipperZen.Enabled = True
		For Each oLight in GI_Color
			oLight.Color = RGB(207,203,148)
			oLight.ColorFull = RGB (0,255,255)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone35_Zen"
'		Next
	Case "Super-Zen"
		LSubVenom.State = 1
		LVenom.State = 1
		LSubFlash.State = 1
		LFlash.State = 1
		LSubRapier.State = 1
		LRapier.State = 1
		LSubPhantom.State = 1
		LPhantom.State = 1
		LSuperPhantom.State = 1
		LZen.State = 1
		LSuperZen.State = 2
		LeftFlipperSuperZen.Visible = True
		RightFlipperSuperZen.Visible = True
		LeftFlipperSuperZen.Enabled = True
		RightFlipperSuperZen.Enabled = True
		For Each oLight in GI_Color
			oLight.Color = RGB(207,203,148)
			oLight.ColorFull = RGB (0,236,236)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone42_SuperZen"
'		Next
	Case "Subsonic"
		LSubVenom.State = 1
		LVenom.State = 1
		LSubFlash.State = 1
		LFlash.State = 1
		LSubRapier.State = 1
		LRapier.State = 1
		LSubPhantom.State = 1
		LPhantom.State = 1
		LSuperPhantom.State = 1
		LZen.State = 1
		LSuperZen.State = 1
		LSubsonic.State = 2
		LeftFlipperSubsonic.Visible = True
		RightFlipperSubsonic.Visible = True
		LeftFlipperSubsonic.Enabled = True
		RightFlipperSubsonic.Enabled = True
		For Each oLight in GI_Color
			oLight.Color = RGB(207,203,148)
			oLight.ColorFull = RGB (255,0,0)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone50_Subsonic"
'		Next
	Case "Mach 1"
		LSubVenom.State = 1
		LVenom.State = 1
		LSubFlash.State = 1
		LFlash.State = 1
		LSubRapier.State = 1
		LRapier.State = 1
		LSubPhantom.State = 1
		LPhantom.State = 1
		LSuperPhantom.State = 1
		LZen.State = 1
		LSuperZen.State = 1
		LSubsonic.State = 1
		LMach1.State = 2
		LeftFlipperMach1.Visible = True
		RightFlipperMach1.Visible = True
		LeftFlipperMach1.Enabled = True
		RightFlipperMach1.Enabled = True
		For Each oLight in GI_Color
			oLight.Color = RGB(150,146,98)
			oLight.ColorFull = RGB (32,32,32)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone60_Mach1"
'		Next
	Case "Supersonic"
		LSubVenom.State = 1
		LVenom.State = 1
		LSubFlash.State = 1
		LFlash.State = 1
		LSubRapier.State = 1
		LRapier.State = 1
		LSubPhantom.State = 1
		LPhantom.State = 1
		LSuperPhantom.State = 1
		LZen.State = 1
		LSuperZen.State = 1
		LSubsonic.State = 1
		LMach1.State = 1
		LSupersonic.State = 2
		LeftFlipperSupersonic.Visible = True
		RightFlipperSupersonic.Visible = True
		LeftFlipperSupersonic.Enabled = True
		RightFlipperSupersonic.Enabled = True
		For Each oLight in GI_Color
			oLight.Color = RGB(207,203,148)
			oLight.ColorFull = RGB (255,255,255)
		Next
'		For Each oLight in CollPlasticBorders
'			oLight.Image = "Zone75_Supersonic"
'		Next		
	End Select

End Sub

Sub InitGI()

Dim oLight

	For Each oLight in GI_Color
		oLight.Color = RGB(207,203,148)
		oLight.ColorFull = RGB (255,255,190)
	Next

End Sub

' Sub AdvanceZone. This advances the current player's Zone, and determines what to do based on the Zone attained

Sub AdvanceZone()

	Zone(player) = Zone(player) + 1												' Add 1 to the current Zone
	If GameMode <> 2 then DisplayZone Zone(Player)								' Display the Zone
	ZoneVelMultiplier(Player) = ZoneVelMultiplier(player) + ZoneVelIncr			' Increase ball velocity multiplier by the Zone increment

	Select Case Zone(player)													' Do different things depending on the Zone attained
	Case 1
		PlaySound"Sub-Venom"
	Case 2
		ZoneName(Player) = "Venom"													' New Named Zone
		PlaySound"Zone Transition"													' Announce the new named Zone
		StopAllSeq()
		SeqFlashersAll.Play SeqBlinking,,30,3
		ZoneTransition.Enabled = True 
		AddScore 10000,True															' 10,000 points for attaining Venom
	Case 3
		ZoneName(Player) = "Sub-Flash"												' New Named Zone
		PlaySound"Zone Transition"													' Announce the new named Zone
		StopAllSeq()
		SeqFlashersAll.Play SeqBlinking,,30,3
		ZoneTransition.Enabled = True
		AddScore 10000,True																' 10,000 points for attaining Sub-Flash
	Case 5
		ZoneName(Player) = "Flash"													' New Named Zone
		PlaySound"Zone Transition"													' Announce the new named Zone
		StopAllSeq()
		SeqFlashersAll.Play SeqBlinking,,30,3
		ZoneTransition.Enabled = True
		AddScore 10000,True																' 10,000 points for attaining Flash
	Case 6
		PlaySound"Zone 5 Clear"														' Announce we've cleared Zone 5
	Case 7
		ZoneName(Player) = "Sub-Rapier"												' New Named Zone
		PlaySound"Zone Transition"													' Announce the new named Zone
		StopAllSeq()
		SeqFlashersAll.Play SeqBlinking,,30,3
		ZoneTransition.Enabled = True
		AddScore 10000,True															' 10,000 points for attaining Sub-Rapier
	Case 11
		PlaySound"Zone 10 Clear"													' Announce we've cleared Zone 10
	Case 12
		ZoneName(Player) = "Rapier"													' New Named Zone
		PlaySound"Zone Transition"													' Announce the new named Zone
		StopAllSeq()
		SeqFlashersAll.Play SeqBlinking,,30,3
		ZoneTransition.Enabled = True
		AddScore 10000,True															' 10,000 points for attaining Rapier
	Case 16
		ZoneName(Player) = "Sub-Phantom"											' New Named Zone
		PlaySound"Zone Transition"													' Announce the new named Zone
		StopAllSeq()
		SeqFlashersAll.Play SeqBlinking,,30,3
		ZoneTransition.Enabled = True
		AddScore 20000,True															' 10,000 points for attaining Sub-Phantom
	Case 20
		ZoneName(Player) = "Phantom"												' New Named Zone
		PlaySound"Zone Transition"													' Announce the new named Zone
		StopAllSeq()
		SeqFlashersAll.Play SeqBlinking,,30,3
		ZoneTransition.Enabled = True
		AddScore 20000,True															' 10,000 points for attaining Phantom
	Case 21
		PlaySound"Zone 20 Clear"													' Announce we've cleared Zone 20
	Case 26
		PlaySound"Zone 25 Clear"													' Announce we've cleared Zone 25
	Case 27
		ZoneName(Player) = "Super-Phantom"											' New Named Zone
		PlaySound"Zone Transition"													' Announce the new named Zone
		StopAllSeq()
		SeqFlashersAll.Play SeqBlinking,,30,3
		ZoneTransition.Enabled = True
		AddScore 20000,True															' 10,000 points for attaining Super-Phantom
	Case 31
		PlaySound"Zone 30 Clear"													' Announce we've cleared Zone 30
	Case 35
		ZoneName(Player) = "Zen"													' New Named Zone
		PlaySound"Zone Transition"													' Announce the new named Zone
		StopAllSeq()
		SeqFlashersAll.Play SeqBlinking,,30,3
		ZoneTransition.Enabled = True
		AddScore 20000,True															' 10,000 points for attaining Zen
		LightExtraBall																' Extra Ball is lit at Zone 35	
	Case 36
		PlaySound"Zone 35 Clear"													' Announce we've cleared Zone 35
	Case 41
		PlaySound"Zone 40 Clear"													' Announce we've cleared Zone 40
	Case 42
		ZoneName(Player) = "Super-Zen"												' New Named Zone
		PlaySound"Zone Transition"													' Announce the new named Zone
		StopAllSeq()
		SeqFlashersAll.Play SeqBlinking,,30,3
		ZoneTransition.Enabled = True
		AddScore 30000,True															' 20,000 points for attaining Super-Zen
	Case 46
		PlaySound"Zone 45 Clear"													' Announce we've cleared Zone 30
	Case 50
		ZoneName(Player) = "Subsonic"												' New Named Zone
		PlaySound"Zone Transition"													' Announce the new named Zone
		StopAllSeq()
		SeqFlashersAll.Play SeqBlinking,,30,3
		ZoneTransition.Enabled = True
		AddScore 30000,True															' 30,000 points for attaining Subsonic
	Case 51
		PlaySound"Zone 50 Clear"													' Announce we've cleared Zone 30
	Case 56
		If not AuricomWon(player) then AwardSponsor "Auricom"						' Award Auricom Sponsorship
	Case 60
		ZoneName(Player) = "Mach 1"													' New Named Zone
		PlaySound"Zone Transition"													' Announce the new named Zone
		StopAllSeq()
		SeqFlashersAll.Play SeqBlinking,,30,3
		ZoneTransition.Enabled = True
		AddScore 40000,True															' 40,000 points for attaining Mach 1
	Case 61
		PlaySound"Zone 60 Clear"													' Announce we've cleared Zone 60
	Case 71
		PlaySound"Zone 70 Clear"													' Announce we've cleared Zone 70
	Case 75
		ZoneName(Player) = "Supersonic"												' New Named Zone
		PlaySound"Zone Transition"													' Announce the new named Zone
		ZoneTransition.Enabled = True
		StopAllSeq()
		SeqFlashersAll.Play SeqBlinking,,30,3
		AddScore 50000,True															' 50,000 points for attaining Supersonic
		LightSpecial																' Special Lit at Zone 75
	Case 80
		If not AGSysWon(player) then AwardSponsor "AG-Systems"						' Award AG-Systems Sponsorship at Zone 80
	Case 81
		PlaySound"Zone 80 Clear"													' Announce we've cleared Zone 80
	Case 91
		PlaySound"Zone 90 Clear"													' Announce we've cleared Zone 90
	Case 100
		LightExtraBall																' Light extra ball at attaining Zone 100
		AddScore 100000,True														' 100,000 points for Zone 100
	Case 101
		PlaySound"Zone 100 Clear"													' Announce we've cleared Zone 100
	Case Else
		If Zone(Player) > 100 and Zone(Player) mod 25 = 0 then AddScore 100000,True	' Additional 100,000 points every 25 Zones after Zone 100
		If Zone(Player) > 100 and Zone(Player) mod 50 = 0 then LightExtraBall		' Light extra ball every 50 Zones after Zone 100
	End Select
	GetZoneName()																	' Set the appropriate Zone lights

End Sub

Sub ZoneTransition_Timer()

Dim oBumper

	ZoneTransition.Enabled = False
	Select Case Zone(player)
	Case 2
		PlaySound"Venom"
	Case 3,4
		PlaySound"Sub-Flash"														' Announce the new named Zone
	Case 5,6
		PlaySound"Flash"															' Announce the new named Zone
	Case 7,8,9,10,11
		PlaySound"Sub-Rapier"														' Announce the new named Zone
	Case 12,13,14,15
		PlaySound"Rapier"															' Announce the new named Zone
	Case 16,17,18,19
		PlaySound"Sub-Phantom"														' Announce the new named Zone
	Case 20,21,22,23,24,25,26
		PlaySound"Phantom"															' Announce the new named Zone
	Case 27,28,29,30,31,32,33,34
		PlaySound"Super-Phantom"													' Announce the new named Zone 
	Case 35,36,37,38,39,40,41
		PlaySound"Zen"																' Announce the new named Zone
	Case 42,43,44,45,46,47,48,49
		PlaySound"Super-Zen"														' Announce the new named Zone
	Case 50,51,52,53,54,55,56,57,58,59
		PlaySound"Sub-Sonic"														' Announce the new named Zone
	Case 60,61,62,63,64,65,66,67,68,69,70,71,72,73,74
		PlaySound"Mach 1"															' Announce the new named Zone	
	Case 75,76,77,78,79,80
		PlaySound"Supersonic"														' Announce the new named Zone
	End Select

	ZoneForce(Player) = ZoneForce(Player) + 1
	For Each oBumper in collBumpers
		oBumper.Force = ZoneForce(Player)
	Next

End Sub

' Zone Trigger subs
'
' These alter the velocity of the active ball by the current velocity multiplier.
'
' This multiplier was determined by going to the actual Wipeout HD game and estimating the speed of a ship at Sub-Venom speed
' as well as a ship at Supersonic speed (at Zone 75).
'
' When a player completes a Zone mode session, Wipeout HD gives the maximum speed attained. The farthest I had ever gotten was 3 seconds past
' reaching Zone 75, which came out to a max speed of 1,490 km/h. To estimate a ship at Sub-Venom speed, I ran a Speed Lap session using a Piranha ship at Venom class and noted the highest
' speed attained without using a speed pad. Using this information and a similar run in the same ship in Flash class, I estimated the Sub-Venom speed to be 395 km/h.
'
' 1490 / 395 = approximately 3.772
'
' The multiplier for Zone 0 starts at 1, so I subtracted 1 from this result, which is 2.772, and divided this by 75 to get the per-Zone increment.
'
' 2.772 / 75 = 0.03696.
'
' The 0.03696 is the increment used to alter the velocity multiplier of the ball based on the current Zone.

' Sub ZoneTriggersOn. This activates the Zone triggers

Sub ZoneTriggersOn()

Dim oTrigger

	For Each oTrigger in collZoneTriggers
		oTrigger.Enabled = True
	Next

End Sub

' Sub ZoneTriggersOff. This turns off the Zone triggers. Usually done if we tilt or during Zone Battle Multiball


Sub ZoneTriggersOff()

Dim oTrigger

	For Each oTrigger in collZoneTriggers
		oTrigger.Enabled = False
	Next

End Sub

' Zone Trigger hit events. These alter the velocity of the ball by the zone velocity multiplier

Sub ZoneTrigger1_Hit()

	ActiveBall.VelX = ActiveBall.VelX * ZoneVelMultiplier(Player)
	ActiveBall.VelY = ActiveBall.VelY * ZoneVelMultiplier(Player)
	If not Tilt then PlaySound"Boost"

End Sub

Sub ZoneTrigger2_Hit()

	ActiveBall.VelX = ActiveBall.VelX * ZoneVelMultiplier(Player)
	ActiveBall.VelY = ActiveBall.VelY * ZoneVelMultiplier(Player)
	If not Tilt then PlaySound"Boost"

End Sub

Sub ZoneTrigger3_Hit()

	ActiveBall.VelX = ActiveBall.VelX * ZoneVelMultiplier(Player)
	ActiveBall.VelY = ActiveBall.VelY * ZoneVelMultiplier(Player)
	If not Tilt then PlaySound"Boost"

End Sub

Sub ZoneTrigger4_Hit()

	ActiveBall.VelX = ActiveBall.VelX * ZoneVelMultiplier(Player)
	ActiveBall.VelY = ActiveBall.VelY * ZoneVelMultiplier(Player)
	If not Tilt then PlaySound"Boost"

End Sub


Sub ZoneTrigger5_Hit()

	ActiveBall.VelX = ActiveBall.VelX * ZoneVelMultiplier(Player)
	ActiveBall.VelY = ActiveBall.VelY * ZoneVelMultiplier(Player)

End Sub

' *************************** Sponsor Section *****************************
'
' Subs for the 12 Sponsors in the game.

' This sub initializes the sponsor indicators at game start

Sub InitSponsors()

Dim oLight

	For z1 = 1 to 4
		FeisarWon(z1) = False
		EGXWon(z1) = False
		Goteki45Won(z1) = False
		PiranhaWon(z1) = False
		HarimauWon(z1) = False
		TriakisWon(z1) = False
		QirexWon(z1) = False
		AuricomWon(z1) = False
		IcarasWon(z1) = False
		AssegaiWon(z1) = False
		AGSysWon(z1) = False
		MirageWon(z1) = False
		SponsorsWon(z1) = 0
	Next

	For Each oLight in collSponsorLights
		oLight.State = 0											' Make certain the lights are off at game start
		oLight.TimerInterval = 1250									' Set the timer interval of the light timers to 1250. The timer sub controls when they stop blinking after they are won
		olight.BlinkInterval = 100
	Next

End Sub

' Sub GetSponsorStatus. This is called at the start of each ball. This will set the lights to the correct status based on the player-specific indicators

Sub GetSponsorStatus()

Dim oLight

	For Each oLight in collSponsorLights
		oLight.BlinkPattern = "10"
		oLight.BlinkInterval = 75
		oLight.State = 0											' Make certain the lights are off before checking
	Next
	If FeisarWon(player) then LFeisar1.State = 1
	If EGXWon(player) then LEGX1.State = 1
	If Goteki45Won(player) then LG45.State = 1
	If PiranhaWon(player) then LPiranha1.State = 1
	If HarimauWon(player) then LHarimau1.State = 1
	If TriakisWon(player) then LTriakis1.State = 1
	If QirexWon(player) then LQirex1.State = 1
	If AuricomWon(player) then LAuricom1.State = 1
	If IcarasWon(player) then LIcaras1.State = 1
	If AssegaiWon(player) then LAssegai1.State = 1
	If AGSysWon(player) then LAGSys1.State = 1
	If MirageWon(player) then LMirage1.State = 1

	If SponsorsWon(player) = 12 then SetAllSponsorPattern								' Set the Sponsor lights on a special blink pattern for the remainder of the game

End Sub

' Sub AwardSponsor
'
' This sub give the player the appropriate award based on the value of the "Sp" parameter

Sub AwardSponsor(ByVal Sp)

	If not Tilt then
		SponsorsWon(player) = SponsorsWon(player) + 1
		Select Case Sp
		Case "Feisar"
			PlaySound"Feisar"									' Complete F-E-I-S-A-R
			FeisarWon(player) = True
			LFeisar1.State = 2
			LFeisar1.TimerEnabled = True
		Case "EG-X"												' Clear the EG-X drop targets in sequence
			PlaySound"EG-X"
			EGXWon(player) = True
			LEGX1.State = 2
			LEGX1.TimerEnabled = True
		Case "Goteki45"											' Clear the Goteki 45 drop targets in sequence
			PlaySound"Goteki 45"
			Goteki45Won(player) = True
			LG45.State = 2
			LG45.TimerEnabled = True
		Case "Piranha"											' Get 50 spins on the Piranha spinner in one ball
			PlaySound"Piranha"
			PiranhaWon(player) = True
			LPiranha1.State = 2
			LPiranha1.TimerEnabled = True
		Case "Harimau"											' Get 100 total hits on the bumpers in one game
			PlaySound"Harimau"
			HarimauWon(player) = True
			LHarimau1.State = 2
			LHarimau1.TimerEnabled = True
		Case "Triakis"											' Complete Z-O-N-E when the bonus multiplier is at 6x
			PlaySound"Triakis"
			TriakisWon(player) = True
			LTriakis1.State = 2
			LTriakis1.TimerEnabled = True
		Case "Qirex"											' Get 20 total hits on the "Q" targets in one game
			PlaySound"Qirex"
			QirexWon(player) = True
			LQirex1.State = 2
			LQirex1.TimerEnabled = True
		Case "Auricom"											' Clear Zone 55 in general play
			PlaySound"Auricom"
			AuricomWon(player) = True
			LAuricom1.State = 2
			LAuricom1.TimerEnabled = True
		Case "Icaras"											' Clear the L-O-C-K drop targets in sequence
			PlaySound"Icaras"
			IcarasWon(player) = True
			LIcaras1.State = 2
			LIcaras1.TimerEnabled = True
		Case "Assegai"											' Attain Zone 10.0 and score a jackpot in Zone Battle Multiball
			PlaySound"Assegai"
			AssegaiWon(player) = True
			LAssegai1.State = 2
			LAssegai1.TimerEnabled = True
		Case "AG-Systems"										' Attain Zone 100 in general play
			PlaySound"AG-Systems"
			AGSysWon(player) = True
			LAGSys1.State = 2
			LAGSys1.TimerEnabled = True
		Case "Mirage"											' Get 2 Zone Boost Jackpots in one game
			PlaySound"Mirage"
			MirageWon(player) = True
			LMirage1.State = 2
			LMirage1.TimerEnabled = True
		End Select

		Select Case SponsorsWon(Player)
		Case 6
			AddScore 100000,True								' 100,000 points for 6 Sponsors
			LightExtraBall										' Light Extra Ball
		Case 12
			AddScore 250000,True								' 250,000 points for all sponsors won
			SetAllSponsorPattern								' Set Sponsor lights on a special blink pattern for the remainder of the game
			LightSpecial										' Light Special after collecting all 12 sponsors
			LightExtraBall										' Light Extra Ball
		Case Else
			AddScore 25000,True									' Each sponsor scores 25,000 points
		End Select

		If GameMode = 2 then AdvanceBattleZone 0.5

	End If

End Sub

' This sub sets the sponsor lights blinking in a special pattern for the remainder of the game

Sub SetAllSponsorPattern()

Dim oLight

	LFeisar1.BlinkPattern =    	"011111111111"
	LEGX1.BlinkPattern =       	"101111111111"
	LG45.BlinkPattern =  		"110111111111"
	LPiranha1.BlinkPattern =   	"111011111111"
	LQirex1.BlinkPattern =     	"111101111111"
	LHarimau1.BlinkPattern =   	"111110111111"
	LTriakis1.BlinkPattern =   	"111111011111"
	LIcaras1.BlinkPattern =    	"111111101111"
	LAGSys1.BlinkPattern = 		"111111110111"
	LAuricom1.BlinkPattern =	"111111111011"
	LAssegai1.BlinkPattern =   	"111111111101"
	LMirage1.BlinkPattern =    	"111111111110"

	For Each oLight in collSponsorLights
		oLight.BlinkInterval = 75
		oLight.State = 2
	Next

End Sub

'*** These subs set the sponsor lights to steady on after they are finished bliniking after won

Sub LFeisar1_Timer()

	LFeisar1.TimerEnabled = False
	LFeisar1.State = 1

End Sub

Sub LEGX1_Timer()

	LEGX1.TimerEnabled = False
	LEGX1.State = 1

End Sub

Sub LG45_Timer()

	LG45.TimerEnabled = False
	LG45.State = 1

End Sub

Sub LPiranha1_Timer()

	LPiranha1.TimerEnabled = False
	LPiranha1.State = 1

End Sub

Sub LQirex1_Timer()

	LQirex1.TimerEnabled = False
	LQirex1.State = 1

End Sub

Sub LHarimau1_Timer()

	LHarimau1.TimerEnabled = False
	LHarimau1.State = 1

End Sub

Sub LTriakis1_Timer()

	LTriakis1.TimerEnabled = False
	LTriakis1.State = 1

End Sub

Sub LIcaras1_Timer()

	LIcaras1.TimerEnabled = False
	LIcaras1.State = 1

End Sub

Sub LAGSys1_Timer()

	LAGSys1.TimerEnabled = False
	LAGSys1.State = 1

End Sub

Sub LAuricom1_Timer()

	LAuricom1.TimerEnabled = False
	LAuricom1.State = 1

End Sub

Sub LAssegai1_Timer()

	LAssegai1.TimerEnabled = False
	LAssegai1.State = 1

End Sub

Sub LMirage1_Timer()

	LMirage1.TimerEnabled = False
	LMirage1.State = 1

End Sub

'*********
'   LUT
'*********

Dim GiIntensity
GiIntensity = 1   'used for the LUT changing to increase the GI lights when the table is darker

Dim bLutActive, LUTImage

Sub ChangeGiIntensity(factor) 'changes the intensity scale

    Dim bulb

    For each bulb in GI_Color
        bulb.IntensityScale = GiIntensity * factor
    Next

End Sub


Sub LoadLUT

    bLutActive = False
    x = LoadValue(cGameName, "LUTImage")
    If(x <> "")Then LUTImage = x Else LUTImage = 0
    UpdateLUT

End Sub

Sub SaveLUT
    SaveValue cGameName, "LUTImage", LUTImage
End Sub

Sub NextLUT

	LUTImage = (LUTImage + 1)MOD 10
	UpdateLUT
	SaveLUT

End Sub

Sub UpdateLUT

    Select Case LutImage
        Case 0:ZoneFury.ColorGradeImage = "LUT0":GiIntensity = 1:ChangeGIIntensity 1:If bLutActive then LUTText1.Text = "LUT0"
        Case 1:ZoneFury.ColorGradeImage = "LUT1":GiIntensity = 1.1:ChangeGIIntensity 1:If bLutActive then LUTText1.Text = "LUT1"
        Case 2:ZoneFury.ColorGradeImage = "LUT2":GiIntensity = 1.2:ChangeGIIntensity 1:If bLutActive then LUTText1.Text = "LUT2"
        Case 3:ZoneFury.ColorGradeImage = "LUT3":GiIntensity = 1.3:ChangeGIIntensity 1:If bLutActive then LUTText1.Text = "LUT3"
        Case 4:ZoneFury.ColorGradeImage = "LUT4":GiIntensity = 1.4:ChangeGIIntensity 1:If bLutActive then LUTText1.Text = "LUT4"
        Case 5:ZoneFury.ColorGradeImage = "LUT5":GiIntensity = 1.5:ChangeGIIntensity 1:If bLutActive then LUTText1.Text = "LUT5"
        Case 6:ZoneFury.ColorGradeImage = "LUT6":GiIntensity = 1.6:ChangeGIIntensity 1:If bLutActive then LUTText1.Text = "LUT6"
        Case 7:ZoneFury.ColorGradeImage = "LUT7":GiIntensity = 1.7:ChangeGIIntensity 1:If bLutActive then LUTText1.Text = "LUT7"
        Case 8:ZoneFury.ColorGradeImage = "LUT8":GiIntensity = 1.8:ChangeGIIntensity 1:If bLutActive then LUTText1.Text = "LUT8"
        Case 9:ZoneFury.ColorGradeImage = "LUT9":GiIntensity = 1.9:ChangeGIIntensity 1:If bLutActive then LUTText1.Text = "LUT9"
    End Select

End Sub


' ********************************** End-Of-Script Section **************************************

Sub ZoneFury_Exit()

	If TableState <> -1 then SaveHS

End Sub