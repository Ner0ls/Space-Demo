extends CanvasLayer

signal startGame

func showMessage(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func showLevelUp(level):
	$LevelUpLabel.text = "LEVEL " + str(level)
	$LevelUpLabel.show()
	$LevelUpLabelTimer.start()

func gameOver():
	showMessage("GAME OVER")
	yield($MessageTimer, "timeout")
	$PlayButton.show()
	$Message.text = "SPACE DEMO"
	$Message.show()

func updateScore(score):
	$ScoreLabel.text = str(score)


func _on_MessageTimer_timeout():
	$Message.hide()


func _on_LevelUpLabelTimer_timeout():
	$LevelUpLabel.hide()


func _on_PlayButton_pressed():
	$PlayButton.hide()
	$ScoreLabel.hide()
	emit_signal("startGame")
