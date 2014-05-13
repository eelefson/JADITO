package {
	import flash.utils.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class PlayState extends FlxState {
		[Embed(source = "image_assets/Clipboard_Background.png")] private var ClipboardImage:Class;
		[Embed(source="image_assets/box.jpg")] private var BlackBoxImage:Class;
		[Embed(source="image_assets/check_mark_green.png")] private var CheckMarkImage:Class;
		[Embed(source="image_assets/x_mark_red.png")] private var XImage:Class;
		[Embed(source = "image_assets/calendar.png")] private var CalanderImage:Class;
		[Embed(source = "image_assets/red_circle.png")] private var CircleImage:Class;
		[Embed(source = "image_assets/scribble.png")] private var ScribbleImage:Class;
		[Embed(source = "image_assets/beginDayButton.png")] private var BeginDayButton:Class;
		[Embed(source = "sound_assets/whoosh2.mp3")] private var WhooshSFX:Class;
		[Embed(source = "sound_assets/begin_game.mp3")] private var BeginSFX:Class;
		[Embed(source = "sound_assets/are-you-ready.mp3")] private var AreYouReadySFX:Class;
		
		private var clipboard_graphic:FlxSprite;
		private var box_graphic:FlxSprite;
		private var check_graphic:FlxSprite;
		private var x_graphic:FlxSprite;
		private var calander_graphic:FlxSprite;
		private var cirle_graphic:FlxSprite;
		private var scribble_graphic:FlxSprite;
		private var begin_day_button:FlxSprite;
		
		private var checkBoxes:FlxGroup = new FlxGroup();
		private var mostRecentMark:FlxSprite;
		
		private var beginDayText:BorderedText;
		
		private var zoomCam:ZoomCamera;
		
		public var topWall:FlxTileblock;
		public var bottomWall:FlxTileblock;
		public var leftWall:FlxTileblock;
		public var rightWall:FlxTileblock;
		
		private var timer:FlxDelay;
		private var flag:Boolean = true;
		
		private var go:Boolean = false;
		
		private var cameraX:Number = FlxG.width / 2;
		private var cameraY:Number = FlxG.height / 2;
		
		private var xDistance:Number;
		private var yDistance:Number;
		
		private var increment:int = 0;
		
		private var playWhoosh:Boolean = true;
		
		private var blink:Boolean = true;
		
		override public function create():void {
			var i:int;
			
			FlxG.bgColor = 0xffffffff;
			
			// CAMERA
			zoomCam = new ZoomCamera(0, 0, FlxG.width, FlxG.height);
			FlxG.resetCameras(zoomCam);
			
			if (Registry.pool.length == 0) {		
				if (Registry.playCurrentDay) {
					Registry.day++;
				}
				Registry.playCurrentDay = false;
				var s:int;
				if (Registry.day == DaysOfTheWeek.SATURDAY) {
					//for (i = 0; i < 10; i++) { TEMPORARY CHANGE, RETURN TO 10 WHEN FULL SET OF MINIGAMES IMPLEMENTED
					for (s = 0; s < 6; s++) {
						Registry.taskStatuses[s] = TaskStatuses.EMPTY;
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
				begin_day_button = new FlxButton(FlxG.width, FlxG.height / 2, null, clickBeginButton);
				begin_day_button.loadGraphic(BeginDayButton);
				begin_day_button.x = begin_day_button.x - (begin_day_button.width * 1.35);
				begin_day_button.y = begin_day_button.y - (begin_day_button.height / 2);
				add(begin_day_button);
			}
			
			calander_graphic = new FlxSprite(FlxG.width / 2, 0, CalanderImage);
			calander_graphic.x = calander_graphic.x - (calander_graphic.width / 2);
			add(calander_graphic);
			
			var day:int = Registry.day - 1;
			cirle_graphic = new FlxSprite(((FlxG.width / 2) - (calander_graphic.width / 2) + 6) + (Registry.day * (calander_graphic.width / 6)), 22, CircleImage);
			add(cirle_graphic);
			
			for (var n:int = 0; n < Registry.day; n++) {
				scribble_graphic = new FlxSprite(((FlxG.width / 2) - (calander_graphic.width / 2)) + (n * (calander_graphic.width / 6)), 0, ScribbleImage);
				add(scribble_graphic)				
			}
			
			clipboard_graphic = new FlxSprite(FlxG.width / 2, FlxG.height / 2, ClipboardImage);
			clipboard_graphic.x = clipboard_graphic.x - (clipboard_graphic.width / 2);
			clipboard_graphic.y = clipboard_graphic.y - (clipboard_graphic.height / 2);
			add(clipboard_graphic);
			
			var x:int;
			var y:int;
			var j:int;
			if (Registry.day != DaysOfTheWeek.SATURDAY) {
				x = clipboard_graphic.x + 53;
				y = clipboard_graphic.y + 70;
				// Generates ROWS of black boxes
				for (i = 0; i < 3; i++) {
					// Generates COLUMNS of black boxes
					for (j = 0; j < 2; j++) {
						box_graphic = new FlxSprite(x + (75 * j), y + (58 * i), BlackBoxImage);
						checkBoxes.add(box_graphic);
					}
				}
			} else {
				x = clipboard_graphic.x + 40;
				y = clipboard_graphic.y + 60;
				// Generates ROWS of black boxes
				for (i = 0; i < 4; i++) {
					// Generates COLUMNS of black boxes
					for (j = 0; j < 3; j++) {
						if (i != 3 || j == 1) {
							box_graphic = new FlxSprite(x + (50 * j), y + (50 * i), BlackBoxImage);
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
					x_graphic = new FlxSprite(box.x - 3, box.y - 2, XImage);
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
			
			if (Registry.beginningOfDay) {
				Registry.beginningOfDay = false;
				beginDayText = new BorderedText(0, FlxG.height, FlxG.width, "Get Ready To Begin!");
				beginDayText.setFormat(null, 32, 0xffffffff, "center", 30);
				beginDayText.y = beginDayText.y - beginDayText.height - 35;
				beginDayText.visible = false;
				add(beginDayText);
				blinkText();
				setInterval(blinkText, 500);
				FlxG.play(AreYouReadySFX);
			}
			
			timer = new FlxDelay(5000);
			//timer = new FlxDelay(2000); changed to speed up testing
			timer.start();
			
			super.create();
		}
		
		override public function update():void {
			super.update();
			var i:int;
			/*if (Registry.pool.length == 0 || go) {
				if (!go) {
					if (Registry.day == DaysOfTheWeek.SATURDAY) {
						//for (i = 0; i < 10; i++) { TEMPORARY CHANGE, RETURN TO 10 WHEN FULL SET OF MINIGAMES IMPLEMENTED
						for (i = 0; i < 6; i++) {
							Registry.taskStatuses[i] = TaskStatuses.EMPTY;
						}
					} else {
						for (i = 0; i < 6; i++) {
							Registry.taskStatuses[i] = TaskStatuses.EMPTY;
						}
					}
					go = true;
				}
				if (timer.hasExpired) {
					if (Registry.day > DaysOfTheWeek.SATURDAY) {
						FlxG.switchState(new WinState());
					} else {
						generatePool();
						Registry.day++;
						FlxG.switchState(new PlayState());
					}
				}*/
			if (Registry.playCurrentDay) {
				var box:FlxSprite = checkBoxes.members[Registry.taskStatuses.indexOf(TaskStatuses.EMPTY)];
				
				// Calculates the x and y distances between the camera center and the next unfilled black box
				if (flag) {
					xDistance = distanceBetweenPoints(new FlxPoint(box.x + (box.width / 2), box.y + (box.height / 2)), new FlxPoint(cameraX, box.y + (box.height / 2))) / 50;
					yDistance = distanceBetweenPoints(new FlxPoint(box.x + (box.width / 2), box.y + (box.height / 2)), new FlxPoint(box.x + (box.width / 2), cameraY)) / 50;
					flag = false;
				}
				
				// Begins panning over to and zooming into the next unfilled black box
				if (timer.secondsElapsed > 2) {
					if (playWhoosh) {
						FlxG.play(WhooshSFX);
						playWhoosh = false;
					}
				//if (timer.secondsElapsed > 1) { CHANGED TO MAKE TESTING FASTER
					zoomCam.focusOn(new FlxPoint(cameraX, cameraY));
					if (increment != 50) {
						cameraX += xDistance;
						cameraY += yDistance;
						increment++;
					}
					zoomCam.fade(0xffffffff, 2);
					
					zoomCam.targetZoom = 5;
				} else if (mostRecentMark != null) {
					mostRecentMark.alpha += 0.02;
				}
				
				if (timer.hasExpired) {
					pickMinigame();
				}
			}
		}
		
		private function blinkText():void {
			if (blink) {
				beginDayText.visible = true;
				blink = false;
			} else {
				beginDayText.visible = false;
				blink = true;
			}
		}
		
		public function clickBeginButton():void {
			Registry.playCurrentDay = true;
			Registry.beginningOfDay = true;
			generatePool();
			if (Registry.usingWhatDidTheBossSay) {
				FlxG.switchState(new WhatDidTheBossSayQuestion());
			} else {
				FlxG.switchState(new PlayState());
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
			switch(Registry.day) {
				case DaysOfTheWeek.MONDAY:
					// SELECT 6 LEVEL 0 GAMES
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
				case DaysOfTheWeek.TUESDAY:
					// TEMPORARY, FOR DEVELOPMENT AND TESTS (SEE BELOW FOR ACTUAL CODE)
					// SELECT 6 LEVEL 1 GAMES
					shuffle(levelOneMinigames);
					for (i = 0; i < 6; i++) {
						pair = new Dictionary();
						// Puts "What Did The Boss Say" minigame at the end of the day
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
					
					// SELECT 2 LEVEL 1 GAMES
					/*shuffle(levelOneMinigames);
					for (i = 0; i < 2; i++) {
						pair = new Dictionary();
						pair["minigame"] = levelOneMinigames[i];
						pair["level"] = 1;
						Registry.pool[i] = pair;
						// add minigames to next pool of minigames
						Registry.minigames[2].push(levelOneMinigames[i]);
					}
					// remove the selected minigames from their original pool of minigames
					levelOneMinigames.splice(0, 2);
					
					// SELECT 4 LEVEL 0 GAMES
					shuffle(levelZeroMinigames);
					for (i = 0; i < 4; i++) {
						pair = new Dictionary();
						pair["minigame"] = levelZeroMinigames[i];
						pair["level"] = 0;
						Registry.pool[i+2] = pair;
						// add minigames to next pool of minigames
						Registry.minigames[1].push(levelZeroMinigames[i]);
					}
					// remove the selected minigames from their original pool of minigames
					levelZeroMinigames.splice(0, 4);*/

					trace("Level 0: " + Registry.minigames[0]);
					trace("Level 1: " + Registry.minigames[1]);
					trace("Level 2: " + Registry.minigames[2]);
					trace("Level 3: " + Registry.minigames[3]);
					break;
				case DaysOfTheWeek.WEDNESDAY:
					// TEMPORARY, FOR DEVELOPMENT AND TESTS (SEE BELOW FOR ACTUAL CODE)
					// SELECT 6 LEVEL 2 GAMES
					shuffle(levelTwoMinigames);
					for (i = 0; i < 6; i++) {
						pair = new Dictionary();
						// Puts "What Did The Boss Say" minigame at the end of the day
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
					
					// SELECT 6 LEVEL 1 GAMES
					/*shuffle(levelOneMinigames);
					for (i = 0; i < 6; i++) {
						pair = new Dictionary();
						pair["minigame"] = levelOneMinigames[i];
						pair["level"] = 1;
						Registry.pool[i] = pair;
						// add minigames to next pool of minigames
						Registry.minigames[2].push(levelOneMinigames[i]);
					}
					// remove the selected minigames from their original pool of minigames
					levelOneMinigames.splice(0, 6);*/
					
					trace("Level 0: " + Registry.minigames[0]);
					trace("Level 1: " + Registry.minigames[1]);
					trace("Level 2: " + Registry.minigames[2]);
					trace("Level 3: " + Registry.minigames[3]);
					break;
				case DaysOfTheWeek.THURSDAY:
					// TEMPORARY, FOR DEVELOPMENT AND TESTS (SEE BELOW FOR ACTUAL CODE)
					// SELECT 6 LEVEL 3 GAMES
					shuffle(levelThreeMinigames);
					for (i = 0; i < 6; i++) {
						pair = new Dictionary();
						// Puts "What Did The Boss Say" minigame at the end of the day
						if (levelThreeMinigames[i] == MinigameEnums.WHAT_DID_THE_BOSS_SAY) {
							temp = levelThreeMinigames.splice(i, 1);
							levelThreeMinigames.push(temp);
						}
						pair["minigame"] = levelThreeMinigames[i];
						pair["level"] = 3;
						Registry.pool[i] = pair;
					}
					
					// SELECT 4 LEVEL 2 GAMES
					/*shuffle(levelTwoMinigames);
					for (i = 0; i < 4; i++) {
						pair = new Dictionary();
						pair["minigame"] = levelTwoMinigames[i];
						pair["level"] = 2;
						Registry.pool[i] = pair;
						// add minigames to next pool of minigames
						Registry.minigames[3].push(levelTwoMinigames[i]);
					}
					// remove the selected minigames from their original pool of minigames
					levelTwoMinigames.splice(0, 4);
					
					// SELECT 2 LEVEL 1 GAMES
					shuffle(levelOneMinigames);
					for (i = 0; i < 2; i++) {
						pair = new Dictionary();
						pair["minigame"] = levelOneMinigames[i];
						pair["level"] = 1;
						Registry.pool[i+4] = pair;
						// add minigames to next pool of minigames
						Registry.minigames[2].push(levelOneMinigames[i]);
					}
					// remove the selected minigames from their original pool of minigames
					levelOneMinigames.splice(0, 2);*/
					
					trace("Level 0: " + Registry.minigames[0]);
					trace("Level 1: " + Registry.minigames[1]);
					trace("Level 2: " + Registry.minigames[2]);
					trace("Level 3: " + Registry.minigames[3]);
					break;
				case DaysOfTheWeek.FRIDAY:
					// TEMPORARY, FOR DEVELOPMENT AND TESTS (SEE BELOW FOR ACTUAL CODE)
					// SELECT 6 LEVEL 3 GAMES
					shuffle(levelThreeMinigames);
					for (i = 0; i < 6; i++) {
						pair = new Dictionary();
						// Puts "What Did The Boss Say" minigame at the end of the day
						if (levelThreeMinigames[i] == MinigameEnums.WHAT_DID_THE_BOSS_SAY) {
							temp = levelThreeMinigames.splice(i, 1);
							levelThreeMinigames.push(temp);
						}
						pair["minigame"] = levelThreeMinigames[i];
						pair["level"] = 3;
						Registry.pool[i] = pair;
					}
					
					// SELECT 6 LEVEL 2 GAMES
					/*shuffle(levelTwoMinigames);
					for (i = 0; i < 6; i++) {
						pair = new Dictionary();
						pair["minigame"] = levelTwoMinigames[i];
						pair["level"] = 2;
						Registry.pool[i] = pair;
						// add minigames to next pool of minigames
						Registry.minigames[3].push(levelTwoMinigames[i]);
					}
					// remove the selected minigames from their original pool of minigames
					levelTwoMinigames.splice(0, 6);*/
					
					trace("Level 0: " + Registry.minigames[0]);
					trace("Level 1: " + Registry.minigames[1]);
					trace("Level 2: " + Registry.minigames[2]);
					trace("Level 3: " + Registry.minigames[3]);
					break;
				case DaysOfTheWeek.SATURDAY:
					// TEMPORARY, FOR DEVELOPMENT AND TESTS (SEE BELOW FOR ACTUAL CODE)
					// SELECT 6 LEVEL 3 GAMES
					shuffle(levelThreeMinigames);
					for (i = 0; i < 6; i++) {
						pair = new Dictionary();
						// Puts "What Did The Boss Say" minigame at the end of the day
						if (levelThreeMinigames[i] == MinigameEnums.WHAT_DID_THE_BOSS_SAY) {
							temp = levelThreeMinigames.splice(i, 1);
							levelThreeMinigames.push(temp);
						}
						pair["minigame"] = levelThreeMinigames[i];
						pair["level"] = 3;
						Registry.pool[i] = pair;
					}
					
					// SELECT 10 LEVEL 3 GAMES
					/*shuffle(levelThreeMinigames);
					for (i = 0; i < 10; i++) {
						pair = new Dictionary();
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
					break;*/
			}
			//shuffle(Registry.pool);
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