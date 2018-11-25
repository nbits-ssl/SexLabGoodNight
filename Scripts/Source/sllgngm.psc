Scriptname sllgngm extends Quest

ImageSpaceModifier Property FadeToBlackHoldIMod auto
ImageSpaceModifier Property FadeToBlackBackIMod auto
ImageSpaceModifier Property SleepyTimeFadeIn auto

bool Property debugLogFlag = false Auto
int Property fadeOutTime = 25 Auto
int Property arousalThreshold = 50 Auto
int Property arousalWidth = 20 Auto

import MiscUtil

Event OnInit()
	RegisterForSleep()
endEvent

Event OnSleepStart(Float afSleepStartTime, Float afDesiredSleepEndTime)
	float SleepTime = (afDesiredSleepEndTime - afSleepStartTime) * 24

	Actor Player = Game.GetPlayer()
	Actor[] actors = ScanCellActors(Player, 1024.0)

	Actor aggr
	int len = actors.Length
	int i = 0
	bool break = false 
	log("Search actors length: " + len)

	while (i != len && !break) 
		Actor act = actors[i]
		if (act.IsPlayerTeammate() && isValidGendar(Player, act))
			if (SexLab.IsValidActor(act) && calcChance(act, Player) > arousalThreshold)
				aggr = act
				break = true
			endif
		endif
		i += 1
	endwhile
	
	if (SleepTime > 3 && aggr)
		log("Search actors match: "  + aggr.GetActorBase().GetName() + " : " + i)

		Game.ForceFirstPerson()
		Game.DisablePlayerControls(true, true, true, false, true, true, true, true)

		int waitTime = Utility.RandomInt(1, (SleepTime - 1) as int)
		log(waitTime as float)
		FadeToBlackHoldIMod.apply()
		Utility.WaitMenuMode(waitTime as float)
		Game.GetPlayer().MoveTo(Game.GetPlayer())
		FadeToBlackHoldIMod.apply()
		Game.EnablePlayerControls()

		doSex(Player, aggr)
		Utility.Wait(fadeOutTime)
		
		FadeToBlackHoldIMod.remove()
		SleepyTimeFadeIn.apply()
		FadeToBlackBackIMod.apply()
	else
		log("no aggr or sleeptime less than 3 hours.")
	endif
EndEvent

Function doSex(Actor Pc, Actor Npc)
	Actor[] sexActors = new Actor[2]
	sslBaseAnimation[] anims
	
	if(Pc.GetLeveledActorBase().GetSex() == 1)
		sexActors[0] = Pc
		sexActors[1] = Npc
		anims =  SexLab.GetAnimationsByTags(2, "MF", "Oral,Cowgirl,Aggressive,Standing,Kneeling,Kissing,LeadIn", true)
	else
		sexActors[0] = Npc
		sexActors[1] = Pc
		if (Utility.RandomInt(0, 1) == 0)
			anims =  SexLab.GetAnimationsByTags(2, "MF,Oral", "Standing,Aggressive", true)
		else
			anims =  SexLab.GetAnimationsByTags(2, "MF,Cowgirl", "Standing,Aggressive", true)
		endif
	endif
	
	;SexLabUtil.StartSex(sexActors, anims)
	; startsex with noleadin & noask bed
	
	sslThreadModel Thread = SexLab.NewThread()
	Thread.AddActors(sexActors)
	Thread.SetAnimations(anims)
	Thread.DisableLeadIn()
	Thread.CenterOnBed(false)
	Thread.StartThread()
EndFunction

bool Function isValidGendar(Actor akAct, Actor akAct2)
	int akActSex = akAct.GetActorBase().GetSex()
	int akAct2Sex = akAct2.GetActorBase().GetSex()
	
	if(akActSex == 0 && akAct2Sex == 1) ; Male/Female
		return true
	elseif(akActSex == 1 && akAct2Sex == 0) ; Female/Male
		return true
	elseif(akActSex == -1 && akAct2Sex == 1) ; Creature/Female
		return true
	elseif(akActSex == 1 && akAct2Sex == -1) ; Female/Creature
		return true
	endif
	
	return false
EndFunction

int Function calcChance(Actor akRef, Actor target)
	int chance
	if(akRef.IsInFaction(arousalFaction))
		chance = akRef.GetFactionRank(arousalFaction)
	elseif(target.IsInFaction(arousalFaction))
		chance = target.GetFactionRank(arousalFaction)
	else
		return 0 ;  for C/C
	endif

	return chance + Utility.RandomInt(0, arousalWidth)
endFunction

Function log(String msg)
	; bool debugLogFlag = true
	; bool debugLogFlag = false

	if (debugLogFlag)
		debug.trace("[sslgngm] " + msg);
	endif
EndFunction

SexLabFramework Property SexLab  Auto
Faction Property ArousalFaction  Auto  

; not use
; ReferenceAlias Property PlayerRef  Auto  
; ReferenceAlias Property FollowerRef  Auto  
; Quest Property sslgngmFollower  Auto  
; Scene Property SexScene  Auto  
