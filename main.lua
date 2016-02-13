width = display.contentWidth
height = display.contentHeight

function initButtons()
	initPlayPauseResumeButton()
	initStopButton()
	initLoopButton()
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
	if event.phase == "ended" then
		playPauseResumeButton.actionOnStatus()
	end
end

play = function()
	playPauseResumeButton.text = "Pause"
	playPauseResumeButton.actionOnStatus = actionOnStatus.playing
	audioChanel = audio.play(sound, currentOptions)
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

function stop(event)
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
			currentOptions = notLoopOptions
			
		else
			loopButton.text = "Loop = true"
			currentOptions = loopOptions
		end

		loopButton.isLoop = not loopButton.isLoop
	end
end

function initOptions()
	notLoopOptions = {onComplete = soundEnded, chanel = 3}
	loopOptions = {onComplete = soundEnded, chanel = 3, loops = -1}
	currentOptions = notLoopOptions;
end

function loadSound()
	sound = audio.loadSound("res/pum.m4a")
end

function main()
	initOptions()
	initButtons()
	loadSound()
end;

--run main
main()