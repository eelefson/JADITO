package {
	import flash.utils.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.API.FlxKongregate;

	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class PlayState extends FlxState {
		[Embed(source = "image_assets/DesktopBackground.jpg")] private var BackgroundImage:Class;
		[Embed(source="image_assets/box.jpg")] private var BlackBoxImage:Class;
		[Embed(source="image_assets/check_mark_green.png")] private var CheckMarkImage:Class;
		[Embed(source="image_assets/x_mark_red.png")] private var XImage:Class;
		[Embed(source = "image_assets/red_circle.png")] private var CircleImage:Class;
		[Embed(source = "image_assets/scribble2.png")] private var ScribbleImage:Class;
		[Embed(source = "sound_assets/whoosh2.mp3")] private var WhooshSFX:Class;
		[Embed(source = "sound_assets/begin_game.mp3")] private var BeginSFX:Class;
		[Embed(source = "sound_assets/are-you-ready.mp3")] private var AreYouReadySFX:Class;
		[Embed(source = "font_assets/SLOPI___.ttf", fontFamily = "Typewriter", embedAsCFF = "false")] private var TypewriterFont:String;
		[Embed(source = "font_assets/pricedown bl.ttf", fontFamily = "Score", embedAsCFF = "false")] private var ScoreFont:String;
		[Embed(source = "font_assets/BowlbyOne-Regular.ttf", fontFamily = "Score2", embedAsCFF = "false")] private var Score2Font:String;
		[Embed(source = "image_assets/computerStart2.png")] private var ComputerTextImage:Class;
		[Embed(source = "image_assets/transparent.png")] private var ComputerScreenImage:Class;
		[Embed(source = "image_assets/Mute.png")] private var MuteButton:Class;
		[Embed(source = "image_assets/Play.png")] private var PlayButton:Class;
		
		public var mute_button:FlxButton;
		
		private var clipboard_graphic:FlxSprite;
		private var box_graphic:FlxSprite;
		private var check_graphic:FlxSprite;
		private var x_graphic:FlxSprite;
		private var calander_graphic:FlxSprite;
		private var cirle_graphic:FlxSprite;
		private var scribble_graphic:FlxSprite;
		private var begin_day_button:FlxSprite;
		private var computerScreenText:FlxSprite;
		private var computer_screen_graphic:FlxButton;
		
		private var checkBoxes:FlxGroup = new FlxGroup();
		private var mostRecentMark:FlxSprite;
		
		private var beginDayText:BorderedText;
		
		private var YourScoreText:DictatorDictionText;
		private var YourScore:DictatorDictionText;
		
		private var OtherScoreText:DictatorDictionText;
		private var OtherScore:DictatorDictionText;
		
		private var ScoreReward:DictatorDictionText;
		
		private var zoomCam:ZoomCamera;
		
		private var background_graphic:FlxSprite;
		private var toDoText:DictatorDictionText;
		
		public var topWall:FlxTileblock;
		public var bottomWall:FlxTileblock;
		public var leftWall:FlxTileblock;
		public var rightWall:FlxTileblock;
		
		private var timer:FlxDelay;
		private var flag:Boolean = true;
		
		private var go:Boolean = false;
		
		private var cameraX:Number = FlxG.width / 2; //consider 161 (midpoint of clipboard)
		private var cameraY:Number = FlxG.height / 2; //consider 348 (midpoint of clipboard);
		
		private var xDistance:Number;
		private var yDistance:Number;
		
		private var increment:int = 0;
		
		private var playWhoosh:Boolean = true;
		
		private var blink1:Boolean = true;
		private var blink2:Boolean = true;
		private var blink3:Boolean = true;
		
		private var computerScreenInterval:uint;
		
		private var timeRemaining:Number;
		private var scoreXDistance:Number;
		private var scoreYDistance:Number;
		private var scoreIncrement:int;
		
		override public function create():void {
			var i:int;
			
			FlxG.bgColor = 0xffffffff;
			
			// CAMERA
			zoomCam = new ZoomCamera(0, 0, FlxG.width, FlxG.height);
			FlxG.resetCameras(zoomCam);
			
			background_graphic = new FlxSprite(0, 0, BackgroundImage);
			add(background_graphic);
			
			if (Registry.pool.length == 0) {		
				if (Registry.playCurrentDay) {
					Registry.day++;
					if (Registry.day != DaysOfTheWeek.MONDAY) {
						generatePool();
					}
				}
				//Registry.playCurrentDay = false;
				var s:int;
				if (Registry.day == DaysOfTheWeek.SATURDAY) {
					for (i = 0; i < 10; i++) {
						Registry.taskStatuses[i] = TaskStatuses.EMPTY;
					}
				} else {
					for (s = 0; s < 6; s++) {
						Registry.taskStatuses[s] = TaskStatuses.EMPTY;
					}
				}
			}
			
			if (!Registry.playCurrentDay) {
				if (Registry.day == DaysOfTheWeek.MONDAY) {
					FlxG.play(BeginSFX);
				}
				computerScreenText = new FlxSprite(365, 60, ComputerTextImage);
				computerScreenText.visible = false;
				add(computerScreenText);
				blinkSprite();
				computerScreenInterval = setInterval(blinkSprite, 1000);
				
				computer_screen_graphic = new FlxButton(365, 51, null, clickBeginButton);
				computer_screen_graphic.loadGraphic(ComputerScreenImage);
				add(computer_screen_graphic);
			}
			
			var day:int = Registry.day - 1;
			cirle_graphic = new FlxSprite(32 + (Registry.day * 48), 61, CircleImage);
			add(cirle_graphic);
			
			for (var n:int = 0; n < Registry.day; n++) {
				scribble_graphic = new FlxSprite(32 + (n * 48), 64, ScribbleImage);
				add(scribble_graphic);				
			}
			toDoText = new DictatorDictionText(95, 257 + 10, 132, "To Do:");
			toDoText.setFormat("Typewriter", 18, 0xff000000, "center");
			add(toDoText);
			
			var underline:FlxTileblock = new FlxTileblock(95 + ((toDoText.width - toDoText.getRealWidth()) / 2), 257 + 6 + toDoText.height, toDoText.getRealWidth(), 1);
			underline.makeGraphic(toDoText.getRealWidth(), 1, 0xff000000);
			add(underline);
			
			YourScoreText = new DictatorDictionText(70, 113, 300, "Your Score:     ");
			var prevoiusScore:int;
			if (!Registry.failedMostRecentMinigame && Registry.playCurrentDay) {
				prevoiusScore = Registry.score - ((Registry.difficultyLevel + 1) * 100);
			} else {
				prevoiusScore = Registry.score;
			}
			YourScore = new DictatorDictionText(70, 113, 75, prevoiusScore.toString());
			
			OtherScoreText = new DictatorDictionText(70, 148, 300, "Rival's Score: ");
			OtherScore = new DictatorDictionText(70, 148, 75, "" + (Registry.BobScores[Registry.day] + 8000 * Registry.playthrough));
			
			YourScoreText.setFormat("Score", 28, 0xFF000000);
			YourScore.setFormat("Score", 28, 0xFF000000);
			OtherScoreText.setFormat("Score", 28, 0xFF000000);
			OtherScore.setFormat("Score", 28, 0xFF000000);
			
			YourScore.x += YourScoreText.getRealWidth();
			OtherScore.x += OtherScoreText.getRealWidth();
			
			add(YourScore);
			add(YourScoreText);
			add(OtherScore);
			add(OtherScoreText);
			
			if (!Registry.failedMostRecentMinigame && Registry.playCurrentDay) {
				var points:int = (Registry.difficultyLevel + 1) * 100;
				ScoreReward = new DictatorDictionText(FlxG.width / 2, FlxG.height / 2, 275, "+" + points.toString());
				ScoreReward.setFormat("Score", 128, 0xff00C72A, "center", 30);
				ScoreReward.x = ScoreReward.x - (ScoreReward.width / 2);
				ScoreReward.y = ScoreReward.y - (ScoreReward.height / 2);
				add(ScoreReward);
				scoreXDistance = distanceBetweenPoints(new FlxPoint(YourScore.x, 0), new FlxPoint(ScoreReward.x, 0)) / 40;
				scoreYDistance = (distanceBetweenPoints(new FlxPoint(0, YourScore.y), new FlxPoint(0, ScoreReward.y)) + 20) / 40;
				scoreIncrement = 0;
			}
			
			var x:int;
			var y:int;
			var j:int;
			if (Registry.day != DaysOfTheWeek.SATURDAY) {
				x = 95 + 23;
				y = 257 + 30 + 6;
				// Generates ROWS of black boxes
				for (i = 0; i < 3; i++) {
					// Generates COLUMNS of black boxes
					for (j = 0; j < 2; j++) {
						box_graphic = new FlxSprite(x + (60 * j), y + (50 * i), BlackBoxImage);
						checkBoxes.add(box_graphic);
					}
				}
			} else {
				x = 95 + 13;
				y = 257 + 20 + 12;
				// Generates ROWS of black boxes
				for (i = 0; i < 4; i++) {
					// Generates COLUMNS of black boxes
					for (j = 0; j < 3; j++) {
						if (i != 3 || j == 1) {
							box_graphic = new FlxSprite(x + (40 * j), y + (38 * i), BlackBoxImage);
							checkBoxes.add(box_graphic);
						}
					}
				}
			}
			add(checkBoxes);
			
			// Fills the black boxes with the appropriate check or x image
			for (var k:int = 0; k < Registry.taskStatuses.length; k++) {
				var box:FlxSprite = checkBoxes.members[k];
				if (Registry.taskStatuses[k] == TaskStatuses.SUCCESS) {
					check_graphic = new FlxSprite(box.x + 2, box.y - 6, CheckMarkImage);
					if (k == (Registry.taskStatuses.indexOf(TaskStatuses.EMPTY) - 1) || k == (Registry.taskStatuses.length - 1)) {
						check_graphic.alpha = 0;
						mostRecentMark = check_graphic;
					}
					add(check_graphic);
				} else if (Registry.taskStatuses[k] == TaskStatuses.FAILURE) {
					x_graphic = new FlxSprite(box.x - 2, box.y - 2, XImage);
					if (k == (Registry.taskStatuses.indexOf(TaskStatuses.EMPTY) - 1) || k == (Registry.taskStatuses.length - 1)) {
						x_graphic.alpha = 0;
						mostRecentMark = x_graphic;
					}
					add(x_graphic);					
				}
			}
			
			topWall = new FlxTileblock(0, 0, FlxG.width, 2);
			topWall.makeGraphic(FlxG.width, 2, 0xff000000);
			add(topWall);
			
			bottomWall = new FlxTileblock(0, FlxG.height - 2, FlxG.width, 2);
			bottomWall.makeGraphic(FlxG.width, 2, 0xff000000);
			add(bottomWall);
			
			leftWall = new FlxTileblock(0, 0, 2, FlxG.height);
			leftWall.makeGraphic(2, FlxG.height, 0xff000000);
			add(leftWall);
			
			rightWall = new FlxTileblock(FlxG.width - 2, 0, 2, FlxG.height);
			rightWall.makeGraphic(2, FlxG.height, 0xff000000);
			add(rightWall);
			
			if (Registry.playCurrentDay) {
				timeRemaining = 0.5;
				timer = new FlxDelay(3000);
				timer.start();
			}
			
			if (FlxG.music.active) {
				mute_button = new FlxButton(10, FlxG.height, null, mute);
				mute_button.loadGraphic(PlayButton);
			
			}else {
				mute_button = new FlxButton(10, FlxG.height, null, play);
				mute_button.loadGraphic(MuteButton);
			}
			mute_button.y = mute_button.y - (mute_button.height);
			add(mute_button);
			
			//FlxKongregate.submitStats("Score", Registry.score);
			super.create();
		}
		
		override public function update():void {
			super.update();
			var i:int;
			if (Registry.playCurrentDay) {
				var box:FlxSprite = checkBoxes.members[Registry.taskStatuses.indexOf(TaskStatuses.EMPTY)];
				
				// Calculates the x and y distances between the camera center and the next unfilled black box
				if (flag) {
					xDistance = distanceBetweenPoints(new FlxPoint(box.x + (box.width / 2), box.y + (box.height / 2)), new FlxPoint(cameraX, box.y + (box.height / 2))) / 40;
					yDistance = distanceBetweenPoints(new FlxPoint(box.x + (box.width / 2), box.y + (box.height / 2)), new FlxPoint(box.x + (box.width / 2), cameraY)) / 40;
					flag = false;
				}
				if (timeRemaining < 0 && !Registry.failedMostRecentMinigame) {
					if (scoreIncrement != 40) {
						ScoreReward.x -= scoreXDistance;
						ScoreReward.y += scoreYDistance;
						ScoreReward.size -= 2.99;
						scoreIncrement++;
					} else if (scoreIncrement == 40) {
						ScoreReward.visible = false;
						YourScore.text = Registry.score.toString();
					}
				}
				// Begins panning over to and zooming into the next unfilled black box
				if (timer.secondsElapsed > 1) {
					if (playWhoosh) {
						FlxG.play(WhooshSFX);
						playWhoosh = false;
					}
					zoomCam.focusOn(new FlxPoint(cameraX, cameraY));
					if (increment != 40) {
						cameraX += xDistance;
						cameraY += yDistance;
						increment++;
					}
					zoomCam.fade(0xffffffff, 2);
					
					zoomCam.targetZoom = 7;
				} else if (mostRecentMark != null) {
					mostRecentMark.alpha += 0.02;
				}
				
				if (timer.hasExpired) {
					pickMinigame();
				}
			}
			timeRemaining -= FlxG.elapsed;
		}
		
		private function blinkSprite():void {
			if (blink1) {
				computerScreenText.visible = true;
				blink1 = false;
			} else {
				computerScreenText.visible = false;
				blink1 = true;
			}
		}
		
		private function blinkText():void {
			if (blink2) {
				beginDayText.visible = true;
				blink2 = false;
			} else {
				beginDayText.visible = false;
				blink2 = true;
			}
		}
		
		public function clickBeginButton():void {
			computerScreenText.visible = false;
			computer_screen_graphic.kill();
			Registry.playCurrentDay = true;
			generatePool();
			clearInterval(computerScreenInterval);
			
			beginDayText = new BorderedText(0, FlxG.height / 2, FlxG.width, "Get Ready To Begin!");
			beginDayText.setFormat("Score2", 32, 0xffffffff, "center", 30);
			beginDayText.y = beginDayText.y - (beginDayText.height / 2);
			beginDayText.visible = false;
			add(beginDayText);
			blinkText();
			setInterval(blinkText, 500);
			FlxG.play(AreYouReadySFX);
			
			timer = new FlxDelay(3000);
			timer.start();
			if (Registry.usingWhatDidTheBossSay) {
				FlxG.switchState(new WhatDidTheBossSayCommand());
			}
		}
		
		public function generatePool():void {
			var levelZeroMinigames:Array = Registry.minigames[0];
			var levelOneMinigames:Array = Registry.minigames[1];
			var levelTwoMinigames:Array = Registry.minigames[2];
			var levelThreeMinigames:Array = Registry.minigames[3];
			
			var i:int;
			var pair:Dictionary;
			var temp:String;
			var levelWhatDidTheBossSaySeen:int = -1;
			switch(Registry.day) {
				case DaysOfTheWeek.MONDAY:
					// SELECT 6 LEVEL 0 GAMES
					//FlxKongregate.submitStats("DaysComplete", 0);
					shuffle(levelZeroMinigames);
					for (i = 0; i < 6; i++) {
						pair = new Dictionary();
						// Puts "What Did The Boss Say" minigame at the end of the day
						if (levelZeroMinigames[i] == MinigameEnums.WHAT_DID_THE_BOSS_SAY) {
							temp = levelZeroMinigames.splice(i, 1);
							levelZeroMinigames.push(temp);
						}
						pair["minigame"] = levelZeroMinigames[i];
						pair["level"] = 0;
						Registry.pool[i] = pair;
						// add minigames to next pool of minigames
						Registry.minigames[1].push(levelZeroMinigames[i]);
					}
					// remove the selected minigames from their original pool of minigames
					levelZeroMinigames.splice(0, 6);
					
					trace("Level 0: " + Registry.minigames[0]);
					trace("Level 1: " + Registry.minigames[1]);
					trace("Level 2: " + Registry.minigames[2]);
					trace("Level 3: " + Registry.minigames[3]);
					break;
				case DaysOfTheWeek.TUESDAY: // NO SUPPORT FOR WHAT DID THE BOSS SAY YET
					// SELECT 2 LEVEL 1 GAMES
					//FlxKongregate.submitStats("DaysComplete", 1);
					shuffle(levelOneMinigames);
					for (i = 0; i < 2; i++) {
						pair = new Dictionary();
						if (levelOneMinigames[i] == MinigameEnums.WHAT_DID_THE_BOSS_SAY) {
							levelWhatDidTheBossSaySeen = 1;
						} else {
							pair["minigame"] = levelOneMinigames[i];
							pair["level"] = 1;
							Registry.pool[i] = pair;
						}
						// add minigames to next pool of minigames
						Registry.minigames[2].push(levelOneMinigames[i]);
					}
					// remove the selected minigames from their original pool of minigames
					levelOneMinigames.splice(0, 2);
					
					// SELECT 4 LEVEL 0 GAMES
					shuffle(levelZeroMinigames);
					for (i = 0; i < 4; i++) {
						pair = new Dictionary();
						if (levelZeroMinigames[i] == MinigameEnums.WHAT_DID_THE_BOSS_SAY) {
							levelWhatDidTheBossSaySeen = 0;
						} else {
							pair["minigame"] = levelZeroMinigames[i];
							pair["level"] = 0;
							Registry.pool[i + 2] = pair;
						}
						// add minigames to next pool of minigames
						Registry.minigames[1].push(levelZeroMinigames[i]);
					}
					// remove the selected minigames from their original pool of minigames
					levelZeroMinigames.splice(0, 4);
					FlxG.shuffle(Registry.pool, 10);
					if (levelWhatDidTheBossSaySeen == 0) {
						pair = new Dictionary();
						pair["minigame"] = MinigameEnums.WHAT_DID_THE_BOSS_SAY;
						pair["level"] = 0;
						Registry.pool.unshift(pair);
					} else if (levelWhatDidTheBossSaySeen == 1) {
						pair = new Dictionary();
						pair["minigame"] = MinigameEnums.WHAT_DID_THE_BOSS_SAY;
						pair["level"] = 1;
						Registry.pool.unshift(pair);
					}
					
					trace("Level 0: " + Registry.minigames[0]);
					trace("Level 1: " + Registry.minigames[1]);
					trace("Level 2: " + Registry.minigames[2]);
					trace("Level 3: " + Registry.minigames[3]);
					break;
				case DaysOfTheWeek.WEDNESDAY:				
					// SELECT 6 LEVEL 1 GAMES
					//FlxKongregate.submitStats("DaysComplete", 2);
					shuffle(levelOneMinigames);
					for (i = 0; i < 6; i++) {
						pair = new Dictionary();
						if (levelOneMinigames[i] == MinigameEnums.WHAT_DID_THE_BOSS_SAY) {
							temp = levelOneMinigames.splice(i, 1);
							levelOneMinigames.push(temp);
						}
						pair["minigame"] = levelOneMinigames[i];
						pair["level"] = 1;
						Registry.pool[i] = pair;
						// add minigames to next pool of minigames
						Registry.minigames[2].push(levelOneMinigames[i]);
					}
					// remove the selected minigames from their original pool of minigames
					levelOneMinigames.splice(0, 6);
					
					trace("Level 0: " + Registry.minigames[0]);
					trace("Level 1: " + Registry.minigames[1]);
					trace("Level 2: " + Registry.minigames[2]);
					trace("Level 3: " + Registry.minigames[3]);
					break;
				case DaysOfTheWeek.THURSDAY: // NO SUPPORT FOR WHAT DID THE BOSS SAY YET
					// SELECT 4 LEVEL 2 GAMES
					//FlxKongregate.submitStats("DaysComplete", 3);
					shuffle(levelTwoMinigames);
					for (i = 0; i < 4; i++) {
						pair = new Dictionary();
						if (levelTwoMinigames[i] == MinigameEnums.WHAT_DID_THE_BOSS_SAY) {
							levelWhatDidTheBossSaySeen = 2;
						} else {
							pair["minigame"] = levelTwoMinigames[i];
							pair["level"] = 2;
							Registry.pool[i] = pair
						}
						// add minigames to next pool of minigames
						Registry.minigames[3].push(levelTwoMinigames[i]);
					}
					// remove the selected minigames from their original pool of minigames
					levelTwoMinigames.splice(0, 4);
					
					// SELECT 2 LEVEL 1 GAMES
					shuffle(levelOneMinigames);
					for (i = 0; i < 2; i++) {
						pair = new Dictionary();
						if (levelOneMinigames[i] == MinigameEnums.WHAT_DID_THE_BOSS_SAY) {
							levelWhatDidTheBossSaySeen = 1;
						} else {
							pair["minigame"] = levelOneMinigames[i];
							pair["level"] = 1;
							Registry.pool[i + 4] = pair;
						}
						// add minigames to next pool of minigames
						Registry.minigames[2].push(levelOneMinigames[i]);
					}
					// remove the selected minigames from their original pool of minigames
					levelOneMinigames.splice(0, 2);
					
					FlxG.shuffle(Registry.pool, 10);
					
					if (levelWhatDidTheBossSaySeen == 1) {
						pair = new Dictionary();
						pair["minigame"] = MinigameEnums.WHAT_DID_THE_BOSS_SAY;
						pair["level"] = 1;
						Registry.pool.unshift(pair);
					} else if (levelWhatDidTheBossSaySeen == 2) {
						pair = new Dictionary();
						pair["minigame"] = MinigameEnums.WHAT_DID_THE_BOSS_SAY;
						pair["level"] = 2;
						Registry.pool.unshift(pair);
					}
					
					trace("Level 0: " + Registry.minigames[0]);
					trace("Level 1: " + Registry.minigames[1]);
					trace("Level 2: " + Registry.minigames[2]);
					trace("Level 3: " + Registry.minigames[3]);
					break;
				case DaysOfTheWeek.FRIDAY:				
					// SELECT 6 LEVEL 2 GAMES
					//FlxKongregate.submitStats("DaysComplete", 4);
					shuffle(levelTwoMinigames);
					for (i = 0; i < 6; i++) {
						pair = new Dictionary();
						if (levelTwoMinigames[i] == MinigameEnums.WHAT_DID_THE_BOSS_SAY) {
							temp = levelTwoMinigames.splice(i, 1);
							levelTwoMinigames.push(temp);
						}
						pair["minigame"] = levelTwoMinigames[i];
						pair["level"] = 2;
						Registry.pool[i] = pair;
						// add minigames to next pool of minigames
						Registry.minigames[3].push(levelTwoMinigames[i]);
					}
					// remove the selected minigames from their original pool of minigames
					levelTwoMinigames.splice(0, 6);
					
					trace("Level 0: " + Registry.minigames[0]);
					trace("Level 1: " + Registry.minigames[1]);
					trace("Level 2: " + Registry.minigames[2]);
					trace("Level 3: " + Registry.minigames[3]);
					break;
				case DaysOfTheWeek.SATURDAY:				
					// SELECT 10 LEVEL 3 GAMES
					//FlxKongregate.submitStats("DaysComplete", 5);
					shuffle(levelThreeMinigames);
					for (i = 0; i < 10; i++) {
						pair = new Dictionary();
						if (levelThreeMinigames[i] == MinigameEnums.WHAT_DID_THE_BOSS_SAY) {
							temp = levelThreeMinigames.splice(i, 1);
							levelThreeMinigames.push(temp);
						}
						pair["minigame"] = levelThreeMinigames[i];
						pair["level"] = 3;
						Registry.pool[i] = pair;
					}
					// remove the selected minigames from their original pool of minigames
					levelThreeMinigames.splice(0, 10);
					
					trace("Level 0: " + Registry.minigames[0]);
					trace("Level 1: " + Registry.minigames[1]);
					trace("Level 2: " + Registry.minigames[2]);
					trace("Level 3: " + Registry.minigames[3]);
					break;
			}
		}
		
		public function pickMinigame():void {
			
			var minigameState:MinigameState;
			//gets the value of the first element of the array and removes it, won't be played
			//again on this day
			var currentMinigame:Dictionary = Registry.pool.shift();
			Registry.difficultyLevel = currentMinigame["level"];
			switch(currentMinigame["minigame"]) {
				case MinigameEnums.DICTATOR_DICTION:
					minigameState = new DictatorDiction();
					break;
				case MinigameEnums.COFFEE_RUN:
					minigameState = new CoffeeRun();
					break;
				case MinigameEnums.COLD_CALLER:
					minigameState = new ColdCaller();
					break;				
				case MinigameEnums.MY_DAUGTHERS_ART_PROJECT:
					minigameState = new MDAP();
					break;					
				case MinigameEnums.SIGN_PAPER:
					minigameState = new SignPapers();
					break;					
				case MinigameEnums.IN_OUT:
					minigameState = new InOut();
					break;
				case MinigameEnums.BRAINSTORMER:
					minigameState = new Brainstormer();
					break;	
				case MinigameEnums.SPEEDY_STAPLER:
					minigameState = new SpeedyStapler();
					break;	
				case MinigameEnums.SPELL_CHECKER:
					minigameState = new Spellchecker();
					break;
				case MinigameEnums.AVOID_THE_COWORKER:
					minigameState = new AvoidCoworker();
					break;
				case MinigameEnums.CATCH_PENCIL:
					minigameState = new CatchPencil();
					break;
				case MinigameEnums.PICK_UP_PAPERS:
					minigameState = new PickUpPapers();
					break;
				case MinigameEnums.CLOCK_IN:
					minigameState = new TimeClock();
					break;
				case MinigameEnums.WATER_BREAK:
					minigameState = new WaterBreak();
					break;
				case MinigameEnums.WHAT_DID_THE_BOSS_SAY:
					minigameState = new WhatDidTheBossSay();
					break;
			}
			FlxG.switchState(minigameState);
		}
		
		public function distanceBetweenPoints(P1:FlxPoint, P2:FlxPoint):Number {
			var dist:Number = FlxU.getDistance(P1, P2);
			if (P1.x >= P2.x) {
				dist *= -1;
			}
			if (P1.y >= P2.y) {
				dist *= -1;
			}
			return dist;
		}
		
		public function mute():void {
			FlxG.music.pause();
			mute_button.kill();
			mute_button = new FlxButton(10, FlxG.height, null, play);
			mute_button.loadGraphic(MuteButton);
			mute_button.y = mute_button.y - (mute_button.height);
			add(mute_button);
		}
		
		public function play():void {
			FlxG.music.resume();
			mute_button.kill();
			mute_button = new FlxButton(10, FlxG.height, null, mute);
			mute_button.loadGraphic(PlayButton);
			mute_button.y = mute_button.y - (mute_button.height);
			add(mute_button);
		}
		
		public function shuffle(a:Array):void {
			var p:int;
			var t:*;
			for (var i:int = a.length - 1; i >= 0; i--) {
				p = Math.floor((i+1)*Math.random());
				t = a[i];
				a[i] = a[p];
				a[p] = t;
			}
		}
	}
}