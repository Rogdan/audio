width = display.contentWidth
height = display.contentHeight
currentVolume = 1

function initButtons()
	initPlayPauseResumeButton()
	initStopButton()
	initLoopButton()
	initVolumeStatus()
	initVolumePlusButton()
	initVolumeMinusButton()
end

function initPlayPauseResumeButton()
	actionOnStatus = {
		paused = resume,
		playing = pause,
		stopped = play
	}

	playPauseResumeButton = display.newText("Play", width/4, height/4, native.systemFont, width/15)
	playPauseResumeButton.actionOnStatus = actionOnStatus.stopped
	playPauseResumeButton:addEventListener("touch", playPauseResumeAction)
end

function playPauseResumeAction(event)
	if event.phase == "ended" and sound ~= nil then
		playPauseResumeButton.actionOnStatus()
	end
end

play = function()
	playPauseResumeButton.text = "Pause"
	playPauseResumeButton.actionOnStatus = actionOnStatus.playing
	audioChanel = audio.play(sound, currentPlayOptions)
end

function soundEnded()
	playPauseResumeButton.text = "Play"
	playPauseResumeButton.actionOnStatus = actionOnStatus.stopped
end

pause = function()
	playPauseResumeButton.text = "Resume"
	playPauseResumeButton.actionOnStatus = actionOnStatus.paused
	audio.pause(sound)
end

resume = function()
	playPauseResumeButton.text = "Pause"
	playPauseResumeButton.actionOnStatus = actionOnStatus.playing
	audio.resume(sound)
end

function initStopButton()
	stopButton = display.newText("Stop", width*3/4, height/4, native.systemFont, width/15)
	stopButton:addEventListener("touch", stop)
end

function stop()
	if playPauseResumeButton.actionOnStatus ~= actionOnStatus.stopped then
		audio.stop(audioChanel)
		soundEnded()
	end
end

function initLoopButton()
	loopButton = display.newText("Loop = false", width/2, height*2/5, native.systemFont, width/15)
	loopButton.isLoop = false
	loopButton:addEventListener("touch", loop)
end

function loop(event)
	if event.phase == "ended" then
		stop()
		if loopButton.isLoop then
			loopButton.text = "Loop = false"
			currentPlayOptions = notLoopOptions
			
		else
			loopButton.text = "Loop = true"
			currentPlayOptions = loopOptions
		end

		loopButton.isLoop = not loopButton.isLoop
	end
end

function initVolumeMinusButton()
	volumeMinus = display.newText("-", width/4, height/2, native.systemFont, width/5)
	volumeMinus:addEventListener("touch", decVolume)
end

function incVolume(event)
	if event.phase == "ended" then
		appendToVolume(0.1)
	end
end

function initVolumePlusButton()
	volumePlus = display.newText("+", width*3/4, height/2, native.systemFont, width/5)
	volumePlus:addEventListener("touch", incVolume)
end

function decVolume(event)
	if event.phase == "ended" then
		appendToVolume(-0.1)
	end
end

function appendToVolume(value)
	if isSoundPlay() then
		if ((currentVolume + value) >= 0 and (currentVolume + value) <= 1) then
			currentVolume = currentVolume + value
			audio.setVolume(currentVolume)
			updateVolumeStatus()
		end
	end	
end

function isSoundPlay()
	return playPauseResumeButton.actionOnStatus ~= actionOnStatus.stopped
end

function initVolumeStatus()
	volumeStatus = display.newText("100%", width/2, height/2, native.systemFont, width/15)
end

function updateVolumeStatus()
	if currentVolume < 0.1 then
		volumeInPercent = 0
	else
		volumeInPercent = currentVolume*100
	end
	volumeStatus.text = tostring(volumeInPercent).."%"
end

function initPlayOptions()
	notLoopOptions = {onComplete = soundEnded, chanel = 3}
	loopOptions = {onComplete = soundEnded, chanel = 3, loops = -1}
	currentPlayOptions = notLoopOptions;
end

function initLoadUploadButton()
	action = {
		load = loadSound,
		dispose = disposeSound
	}
	
	loadDisposeButton = display.newText("Load sound", width/2, height*3/4, native.systemFont, width/15)
	loadDisposeButton.action = action.load	
	loadDisposeButton:addEventListener("touch", loadDisposeHandler)
end

function loadDisposeHandler(event)
	if event.phase == "ended" then
		loadDisposeButton.action()
	end
end

function loadSound()
	sound = audio.loadSound("res/pum.m4a")
	loadDisposeButton.text = "Dispose sound"
	loadDisposeButton.action = action.dispose
end

function disposeSound()
	stop()
	audio.dispose(sound)
	loadDisposeButton.text = "Load sound"
	loadDisposeButton.action = action.load
	sound = nil
end

function main()
	initPlayOptions()
	initButtons()
	initLoadUploadButton()
end;

--run main
main()