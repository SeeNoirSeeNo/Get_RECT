extends Control
#SIGNALS
signal enter_next_stage
#PRELOADS
var shop = preload("res://Shop.tscn")
#NODES
@onready var topPanel = $TopPanel
@onready var bottomPanel = $BottomPanel
@onready var leftPanel = $LeftPanel
@onready var rightPanel = $RightPanel
@onready var next_stageBTN = $EndPanel/VBoxContainer2/NextStage
@onready var restartBTN = $EndPanel/VBoxContainer2/Restart
@onready var quitBTN = $EndPanel/VBoxContainer2/Quit
@onready var objectSpawner = $"../../objectSpawner"
@onready var bloodScan = get_node("../../BloodScan")
@onready var player = get_node("../../Player")
#STAGE
@onready var inGame_StageINT = $TopPanel/VBoxContainer/HBoxContainer2/StageINT
@onready var SB_StageINT = $EndPanel/VBoxContainer/HBoxContainer6/StageINT
#inGame SCORE/BOUNTY/PIXELS/COVERAGE
@onready var inGame_ScoreINT = $TopPanel/VBoxContainer/TopHBoxContainer/TotalScoreINT
@onready var inGame_KillBountyINT = $TopPanel/VBoxContainer/TopHBoxContainer/KillBountyINT 
@onready var inGame_PixelsINT = $TopPanel/VBoxContainer/TopHBoxContainer/PixelsINT
@onready var inGame_CoverageINT = $TopPanel/VBoxContainer/TopHBoxContainer/CoverageINT
#HIGHSCORE SCORE/BOUNTY/PIXELS/COVERAGE
@onready var HS_TotalScoreINT = $BottomPanel/VBoxContainer/TopHBoxContainer/HIGH_TotalScoreINT
@onready var HS_KillBountyINT = $BottomPanel/VBoxContainer/TopHBoxContainer/HIGH_KillBountyINT
@onready var HS_PixelsINT = $BottomPanel/VBoxContainer/TopHBoxContainer/HIGH_PixelsINT
@onready var HS_CoverageINT = $BottomPanel/VBoxContainer/TopHBoxContainer/HIGH_CoverageINT
#SCOREBOARD SCORE/BOUNTY/PIXELS/COVERAGE
@onready var scoreBoard = $EndPanel
@onready var SB_TotalScoreSTR = $EndPanel/VBoxContainer/HBoxContainer2/END_TotalScoreSTR
@onready var SB_TotalScoreINT = $EndPanel/VBoxContainer/HBoxContainer2/END_TotalScoreINT
@onready var SB_KillBountySTR = $EndPanel/VBoxContainer/HBoxContainer3/END_KillbountySTR
@onready var SB_KillBountyINT = $EndPanel/VBoxContainer/HBoxContainer3/END_KillbountyINT
@onready var SB_PixelesSTR = $EndPanel/VBoxContainer/HBoxContainer4/END_PixelesSTR
@onready var SB_PixelesINT = $EndPanel/VBoxContainer/HBoxContainer4/END_PixelesINT
@onready var SB_CoverageSTR = $EndPanel/VBoxContainer/HBoxContainer5/END_CoverageSTR
@onready var SB_CoverageINT = $EndPanel/VBoxContainer/HBoxContainer5/END_CoverageINT
@onready var countdownLabel = $Countdown



func _ready():
	#Function to Connect all Signals
	connect_signals() 
	#Hide the Scoreboard
	scoreBoard.visible = false	

	#Reset & Set Points & Labels
	update_stage_labels()
	update_highscore_labels()
	reset_global_points()
	
func update_highscore_labels():
	#Updaten Highscore Labels
	HS_TotalScoreINT.text = str(Global.highscoreScore)
	HS_KillBountyINT.text = str(Global.highscoreKillBounty)
	HS_PixelsINT.text = str(Global.highscorePixels)
	HS_CoverageINT.text = str(Global.highscoreCoverage)
	#Reset Global Scores
func reset_global_points():
	Global.score = 0
	Global.killBounty = 0
	Global.pixels = 0
	Global.coverage = 0


# CONNECTS "enemy_died" SIGNAL OF NEW SPAWNED ENEMIES
func _on_enemy_spawned(enemy):
	enemy.enemy_died.connect(self._on_enemy_died)

# CHECK FOR STAGE TRANSITION & CHANGE BOUNTY LABEL COLOR
func _on_enemy_died(enemy_color):
	inGame_KillBountyINT.self_modulate = enemy_color
	if get_tree().get_nodes_in_group("Enemies").size() == 1:
		stage_transition()

# THE TRANSITION BETWEEN STAGES
func stage_transition():
	var groups = ["Enemies", "Powerups", "Bullets", "Player"]
	#FINAL BLOOD SCAN
	set_visibility(groups, false)
	await get_tree().create_timer(0.1).timeout
	await bloodScan.count_blood_pixels_low_res()
	_on_score_updated()
	updateHighscores()
	await start_countdown()  # Add this line
	set_visibility(groups, true)
	go_to_next_stage()



# New function for the countdown
func start_countdown():
	
	countdownLabel.visible = true  # Make the label visible
	for i in range(3, 0, -1):  # Countdown from 3 to 1
		
		countdownLabel.text = str(i) + "..."
		countdownLabel.self_modulate = Global.pickRandomColor()
		countdownLabel.scale = Vector2(1, 1)  # Reset the scale
		Global.play_sound("countdown")
		# Pulsate the label
		for x in range(50):
			countdownLabel.scale += Vector2(0.02, 0.02)
			await get_tree().create_timer(0.001).timeout
		for x in range(50):
			countdownLabel.scale -= Vector2(0.02, 0.02)
			await get_tree().create_timer(0.001).timeout
	countdownLabel.text = "Stage " + str(Global.current_stage + 1) + " START!"
	Global.play_sound("stagestart")
	await get_tree().create_timer(1).timeout  # Wait for 1 second before hiding the label
	countdownLabel.visible = false  # Hide the label



# IF CURRENT "SKPC" > "HIGHSCORE SKPC" -> UPDATE
func updateHighscores():
	if Global.score > Global.highscoreScore:
		Global.highscoreScore = Global.score
	if Global.killBounty > Global.highscoreKillBounty:
		Global.highscoreKillBounty = Global.killBounty
	if Global.pixels > Global.highscorePixels:
		Global.highscorePixels = Global.pixels
	if Global.coverage > Global.highscoreCoverage:
		Global.highscoreCoverage = Global.coverage

func gameOver():
	#DEFINE WHAT TO HIDE/SHOW
	var groups = ["Enemies", "Powerups", "Bullets", "Player"]
	#FINAL BLOOD SCAN
	set_visibility(groups, false)
	await get_tree().create_timer(0.1).timeout
	await bloodScan.count_blood_pixels_low_res()
	set_visibility(groups, true)
	#SET HIGHSCORES
	_on_score_updated()
	updateHighscores()
	#SHOW & UPDATE EndPanel
	scoreBoard.visible = true
	next_stageBTN.visible = false
	start_counting_sequences()
	PlayerSkills.skillpoints += Global.score


func set_visibility(groups, visibility):
	for group in groups:
		for node in get_tree().get_nodes_in_group(group):
			#node.queue_free()
			node.visible = visibility


func start_counting_sequences():
	Global.play_sound("coutingUp")

	await start_count_up_and_down(inGame_ScoreINT.text.to_int(), SB_TotalScoreINT, inGame_ScoreINT)
	inGame_ScoreINT.text = str(0)
	Global.stop_sound("coutingUp")
	await get_tree().create_timer(0.7).timeout
	Global.play_sound("coutingUp")

	await start_count_up_and_down(inGame_KillBountyINT.text.to_int(), SB_KillBountyINT, inGame_KillBountyINT)
	inGame_KillBountyINT.text = str(0)	
	Global.stop_sound("coutingUp")
	await get_tree().create_timer(0.7).timeout

	Global.play_sound("coutingUp")
	await start_count_up_and_down(inGame_PixelsINT.text.to_int(), SB_PixelesINT, inGame_PixelsINT)
	inGame_PixelsINT.text = str(0)
	Global.stop_sound("coutingUp")
	await get_tree().create_timer(0.7).timeout

	Global.play_sound("coutingUp")
	await start_count_up_and_down_percentage(inGame_CoverageINT.text.to_float(), SB_CoverageINT, inGame_CoverageINT)
	inGame_CoverageINT.text = str(0)
	Global.stop_sound("coutingUp")




# Coroutine to count up and down the score
func start_count_up_and_down(final_score, score_label_up, score_label_down):
	var current_score = 0.0
	score_label_up.text = str(int(round(current_score)))  # Round to nearest integer
	score_label_down.text = str(final_score)  # Start at final score

	while current_score < final_score:
		# Calculate increment as a percentage of the remaining score
		var increment = max(1, (final_score - current_score) * 0.1)
		current_score += increment
		score_label_up.text = str(int(round(current_score)))  # Round to nearest integer
		score_label_down.text = str(final_score - int(round(current_score)))  # Subtract from final score
		await(get_tree().create_timer(0.03).timeout)  # Wait for 0.05 seconds

# Coroutine to count up the percentage
func start_count_up_and_down_percentage(final_score, score_label_up, score_label_down):
	var current_score = 0.0
	score_label_up.text = str(round(current_score * 100.0) / 100.0) + "%" # Format as float with two decimal places
	score_label_down.text = str(round(final_score * 100.0) / 100.0) + "%" # Start at final score

	while current_score < final_score:
		# Calculate increment as a percentage of the remaining score
		var increment = max(0.01, (final_score - current_score) * 0.1)
		current_score += increment
		score_label_up.text = str(round(current_score * 100.0) / 100.0) + "%"  # Format as float with two decimal places
		score_label_down.text = str(round((final_score - current_score) * 100.0) / 100.0) + "%"  # Subtract from final score
		await(get_tree().create_timer(0.03).timeout)  # Wait for 0.05 seconds

func _on_score_updated():
	#Update Text
	inGame_ScoreINT.text = str(Global.score)
	inGame_KillBountyINT.text = str(Global.killBounty)
	inGame_PixelsINT.text = str(Global.pixels)
	inGame_CoverageINT.text = str(Global.coverage) + "%"
	#Update Color
	inGame_ScoreINT.self_modulate = Global.pickRandomColor()
	#inGame_KillBountyINT.self_modulate = Global.pickRandomColor()
	inGame_PixelsINT.self_modulate = Global.pickRandomColor()
	inGame_CoverageINT.self_modulate = Global.pickRandomColor()

func update_stage_labels():
	inGame_StageINT.text = str(Global.current_stage)
	SB_StageINT.text = str(Global.current_stage)
	



func _on_player_died():
		gameOver()

func _on_restartBTN_pressed():
	get_tree().reload_current_scene()

func _on_shop_pressed():
	get_tree().change_scene_to_file("res://Shop.tscn")

func _on_quitBTN_pressed():
	get_tree().quit()


func _on_next_stage_pressed():
	scoreBoard.visible = false
	go_to_next_stage()

func go_to_next_stage():
	emit_signal("enter_next_stage")
	update_stage_labels()




#Function to Connect all Signals
func connect_signals():
	player.player_died.connect(self._on_player_died)
	restartBTN.pressed.connect(self._on_restartBTN_pressed)
	quitBTN.pressed.connect(self._on_quitBTN_pressed)
	Global.score_updated.connect(self._on_score_updated)
	objectSpawner.enemy_spawned.connect(self._on_enemy_spawned)



