extends Control
#NODES
@onready var topPanel = $TopPanel
@onready var bottomPanel = $BottomPanel
@onready var leftPanel = $LeftPanel
@onready var rightPanel = $RightPanel
@onready var restartBTN = $EndPanel/VBoxContainer2/Restart
@onready var quitBTN = $EndPanel/VBoxContainer2/Quit
@onready var bloodScan = get_node("../../BloodScan")
@onready var player = get_node("../../Player")
#CURRENT SCORE/BOUNTY/PIXELS/COVERAGE
@onready var totalScoreINT = $TopPanel/VBoxContainer/TopHBoxContainer/TotalScoreINT
@onready var killBountyINT = $TopPanel/VBoxContainer/TopHBoxContainer/KillBountyINT 
@onready var pixelsINT = $TopPanel/VBoxContainer/TopHBoxContainer/PixelsINT
@onready var coverageINT = $TopPanel/VBoxContainer/TopHBoxContainer/CoverageINT
#HIGHSCORE SCORE/BOUNTY/PIXELS/COVERAGE
@onready var HIGH_totalScoreINT = $BottomPanel/VBoxContainer/TopHBoxContainer/HIGH_TotalScoreINT
@onready var HIGH_killBountyINT = $BottomPanel/VBoxContainer/TopHBoxContainer/HIGH_KillBountyINT
@onready var HIGH_pixelsINT = $BottomPanel/VBoxContainer/TopHBoxContainer/HIGH_PixelsINT
@onready var HIGH_coverageINT = $BottomPanel/VBoxContainer/TopHBoxContainer/HIGH_CoverageINT
#ENDSCREEN SCORE/BOUNTY/PIXELS/COVERAGE
@onready var EndPanel = $EndPanel
@onready var END_totalScoreSTR = $EndPanel/VBoxContainer/HBoxContainer2/END_TotalScoreSTR
@onready var END_totalScoreINT = $EndPanel/VBoxContainer/HBoxContainer2/END_TotalScoreINT
@onready var END_killBountySTR = $EndPanel/VBoxContainer/HBoxContainer3/END_KillbountySTR
@onready var END_killBountyINT = $EndPanel/VBoxContainer/HBoxContainer3/END_KillbountyINT
@onready var END_PixelesSTR = $EndPanel/VBoxContainer/HBoxContainer4/END_PixelesSTR
@onready var END_PixelesINT = $EndPanel/VBoxContainer/HBoxContainer4/END_PixelesINT
@onready var END_CoverageSTR = $EndPanel/VBoxContainer/HBoxContainer5/END_CoverageSTR
@onready var END_CoverageINT = $EndPanel/VBoxContainer/HBoxContainer5/END_CoverageINT

func _ready():
	#Connect Signals
	player.player_died.connect(self._on_player_died)
	restartBTN.pressed.connect(self._on_restartBTN_pressed)
	quitBTN.pressed.connect(self._on_quitBTN_pressed)
	Global.score_updated.connect(self._on_score_updated)
	#Hide EndPanel
	EndPanel.visible = false

	#Reset & Set Points
	HIGH_totalScoreINT.text = str(Global.highscoreScore)
	Global.score = 0
	HIGH_killBountyINT.text = str(Global.highscoreKillBounty)
	Global.killBounty = 0
	HIGH_pixelsINT.text = str(Global.highscorePixels)
	Global.pixels = 0
	HIGH_coverageINT.text = str(Global.highscoreCoverage)
	Global.coverage = 0

func gameOver():
	#FINAL BLOOD SCAN
	await bloodScan.count_blood_pixels_low_res()
	bloodScan.active = false
	#SET HIGHSCORES
	if Global.score > Global.highscoreScore:
		Global.highscoreScore = Global.score
	if Global.killBounty > Global.highscoreKillBounty:
		Global.highscoreKillBounty = Global.killBounty
	if Global.pixels > Global.highscorePixels:
		Global.highscorePixels = Global.pixels
	if Global.coverage > Global.highscoreCoverage:
		Global.highscoreCoverage = Global.coverage
	#SHOW & UPDATE EndPanel
	EndPanel.visible = true
	start_counting_sequences()

func start_counting_sequences():
	await start_count_up_and_down(totalScoreINT.text.to_int(), END_totalScoreINT, totalScoreINT)
	totalScoreINT.text = str(0)
	await start_count_up_and_down(killBountyINT.text.to_int(), END_killBountyINT, killBountyINT)
	killBountyINT.text = str(0)
	await start_count_up_and_down(pixelsINT.text.to_int(), END_PixelesINT, pixelsINT)
	pixelsINT.text = str(0)
	await start_count_up_and_down_percentage(coverageINT.text.to_float(), END_CoverageINT, coverageINT)
	coverageINT.text = str(0)


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
		await(get_tree().create_timer(0.05).timeout)  # Wait for 0.05 seconds

# Coroutine to count up the percentage
func start_count_up_and_down_percentage(final_score, score_label_up, score_label_down):
	var current_score = 0.0
	score_label_up.text = str(round(current_score * 100.0) / 100.0)  # Format as float with two decimal places
	score_label_down.text = str(round(final_score * 100.0) / 100.0)  # Start at final score

	while current_score < final_score:
		# Calculate increment as a percentage of the remaining score
		var increment = max(0.01, (final_score - current_score) * 0.1)
		current_score += increment
		score_label_up.text = str(round(current_score * 100.0) / 100.0)  # Format as float with two decimal places
		score_label_down.text = str(round((final_score - current_score) * 100.0) / 100.0)  # Subtract from final score
		await(get_tree().create_timer(0.05).timeout)  # Wait for 0.05 seconds

func _on_score_updated():
	#Update Text
	totalScoreINT.text = str(Global.score)
	killBountyINT.text = str(Global.killBounty)
	pixelsINT.text = str(Global.pixels)
	coverageINT.text = str(Global.coverage) + "%"
	#Update Color
	totalScoreINT.self_modulate = Global.pickRandomColor()
	killBountyINT.self_modulate = Global.pickRandomColor()
	pixelsINT.self_modulate = Global.pickRandomColor()
	coverageINT.self_modulate = Global.pickRandomColor()

func _on_player_died():
		gameOver()

func _on_restartBTN_pressed():
	EndPanel.visible = false
	get_tree().reload_current_scene()
	
func _on_quitBTN_pressed():
	get_tree().quit()
