Scriptname sslgngmMCMScript extends SKI_ConfigBase
  
sllgngm Property QuestScript Auto

int debugLogFlagID
int fadeOutTimeID
int arousalThresholdID
int arousalWidthID

event OnPageReset(string page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	SetCursorPosition(0)

	AddHeaderOption("General: ")
	
	fadeOutTimeID =  AddSliderOption("Fade in time (sec):", QuestScript.fadeOutTime)
	arousalThresholdID =  AddSliderOption("Arousal threshold:", QuestScript.arousalThreshold)
	arousalWidthID =  AddSliderOption("Arousal + width:", QuestScript.arousalWidth)
	debugLogFlagID = AddToggleOption("Output papyrus log", QuestScript.debugLogFlag)
endevent

event OnOptionSelect(int option)
	if(option == debugLogFlagID)
		QuestScript.debugLogFlag = !QuestScript.debugLogFlag
		SetToggleOptionValue(debugLogFlagID, QuestScript.debugLogFlag)
	endif
endevent

event OnOptionSliderOpen(int option)
	if (option == fadeOutTimeID)
		SetSliderDialogStartValue(QuestScript.fadeOutTime)
		SetSliderDialogDefaultValue(QuestScript.fadeOutTime)
		SetSliderDialogRange(1.0, 60.0)
		SetSliderDialogInterval(1.0)
	elseif (option == arousalThresholdID)
		SetSliderDialogStartValue(QuestScript.arousalThreshold)
		SetSliderDialogDefaultValue(QuestScript.arousalThreshold)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif (option == arousalWidthID)
		SetSliderDialogStartValue(QuestScript.arousalWidth)
		SetSliderDialogDefaultValue(QuestScript.arousalWidth)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	endif
endevent

event OnOptionSliderAccept(int option, float value)
	if (option == fadeOutTimeID)
		QuestScript.fadeOutTime = value as Int
		SetSliderOptionValue(fadeOutTimeID, QuestScript.fadeOutTime)
	elseif (option == arousalThresholdID)
		QuestScript.arousalThreshold = value as Int
		SetSliderOptionValue(arousalThresholdID, QuestScript.arousalThreshold)
	elseif (option == arousalWidthID)
		QuestScript.arousalWidth = value as Int
		SetSliderOptionValue(arousalWidthID, QuestScript.arousalWidth)
	endif
endevent