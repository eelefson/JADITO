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
		[Embed(source = "image_assets/checkmark.png")] private var CheckMarkImage:Class;
		[Embed(source = "image_assets/red-x.png")] private var XImage:Class;
		
		private var clipboard_graphic:FlxSprite;
		private var box_graphic:FlxSprite;
		private var check_graphic:FlxSprite;
		private var x_graphic:FlxSprite;
		
		private var checkBoxes:FlxGroup = new FlxGroup();
		
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
		
		override public function create():void {
			var i:int;
			
			FlxG.bgColor = 0xffffffff;
			
			// CAMERA
			zoomCam = new ZoomCamera(0, 0, FlxG.width, FlxG.height);
			FlxG.resetCameras(zoomCam);
			
			clipboard_graphic = new FlxSprite(FlxG.width / 2, FlxG.height / 2, ClipboardImage);
			clipboard_graphic.x = clipboard_graphic.x - (clipboard_graphic.width / 2);
			clipboard_graphic.y = clipboard_graphic.y - (clipboard_graphic.height / 2);
			add(clipboard_graphic);
			
			var x:int = clipboard_graphic.x + 79;
			var y:int = clipboard_graphic.y + 115;
			// Generates ROWS of black boxes
			for (i = 0; i < 4; i++) {
				// Generates COLUMNS of black boxes
				for (var j:int = 0; j < 3; j++) {
					box_graphic = new FlxSprite(x + (100 * j), y + (100 * i), BlackBoxImage);
					checkBoxes.add(box_graphic);
				}
			}
			add(checkBoxes);
			
			// Fills the black boxes with the appropriate check or x image
			for (var k:int = 0; k < Registry.taskStatuses.length; k++) {
				var box:FlxSprite = checkBoxes.members[k];
				if (Registry.taskStatuses[k] == TaskStatuses.SUCCESS) {
					check_graphic = new FlxSprite(box.x + 3, box.y - 10, CheckMarkImage);
					add(check_graphic);
				} else if (Registry.taskStatuses[k] == TaskStatuses.FAILURE) {
					x_graphic = new FlxSprite(box.x - 6, box.y - 4, XImage);
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
			
			timer = new FlxDelay(5000);
			//timer = new FlxDelay(2000); changed to speed up testing
			timer.start();
			
			super.create();
		}
		
		override public function update():void {
			super.update();
			var i:int;
			if (Registry.pool.length == 0 || go) {
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
				}
			} else {
				var box:FlxSprite = checkBoxes.members[Registry.taskStatuses.indexOf(TaskStatuses.EMPTY)];
				
				// Calculates the x and y distances between the camera center and the next unfilled black box
				if (flag) {
					xDistance = distanceBetweenPoints(new FlxPoint(box.x + (box.width / 2), box.y + (box.height / 2)), new FlxPoint(cameraX, box.y + (box.height / 2))) / 50;
					yDistance = distanceBetweenPoints(new FlxPoint(box.x + (box.width / 2), box.y + (box.height / 2)), new FlxPoint(box.x + (box.width / 2), cameraY)) / 50;
					flag = false;
				}
				
				// Begins panning over to and zooming into the next unfilled black box
				if (timer.secondsElapsed > 2) {
				//if (timer.secondsElapsed > 1) { CHANGED TO MAKE TESTING FASTER
					zoomCam.focusOn(new FlxPoint(cameraX, cameraY));
					if (increment != 50) {
						cameraX += xDistance;
						cameraY += yDistance;
						increment++;
					}
					zoomCam.fade(0xffffffff, 2);
					
					zoomCam.targetZoom = 5;
				}
				
				if (timer.hasExpired) {
					pickMinigame();
				}
			}
		}
		
		public function generatePool():void {
			var levelZeroMinigames:Array = Registry.minigames[0];
			var levelOneMinigames:Array = Registry.minigames[1];
			var levelTwoMinigames:Array = Registry.minigames[2];
			var levelThreeMinigames:Array = Registry.minigames[3];
			
			var i:int;
			var pair:Dictionary;
			switch(Registry.day) {
				case DaysOfTheWeek.MONDAY:
					// SELECT 6 LEVEL 0 GAMES
					shuffle(levelZeroMinigames);
					for (i = 0; i < 6; i++) {
						pair = new Dictionary();
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
			shuffle(Registry.pool);
		}
		
		public function pickMinigame():void {
			
			var minigameState:MinigameState;
			//gets the value of the first element of the array and removes it, won't be played
			//again on this day
			var currentMinigame:Dictionary = Registry.pool.shift();
			Registry.difficultyLevel = currentMinigame["level"];
			switch(currentMinigame["minigame"]) {
				case MinigameEnums.MINIGAME_ZERO:
					minigameState = new Minigame_ZERO();
					break;
				case MinigameEnums.MINIGAME_ONE:
					minigameState = new Minigame_ONE();
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