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
		
		private var foo:Number = FlxG.width / 2;
		private var bar:Number = FlxG.height / 2;
		
		private var xDistance:Number;
		private var yDistance:Number;
		
		private var increment:int = 0;
		
		//Stores important stuff about the state
		private var minigames:Array = new Array();
		
		public function PlayState(minigames:Array) {
			this.minigames = minigames;
		}
		
		override public function create():void {
			var i:int;
			
			if (Registry.pool.length == 0) {
				Registry.day++;
				
				generatePool();
				
				//if (Registry.taskStatuses.length == 0) {
					for (i = 0; i < 6; i++) {
						Registry.taskStatuses[i] = TaskStatuses.EMPTY;
					}
				//}
			}
			trace(Registry.pool);
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
			// ROWS
			for (i = 0; i < 4; i++) {
				// COLUMNS
				for (var j:int = 0; j < 3; j++) {
					box_graphic = new FlxSprite(x + (100 * j), y + (100 * i), BlackBoxImage);
					checkBoxes.add(box_graphic);
				}
			}
			add(checkBoxes);
			
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
			timer.start();
			
			super.create();
		}
		
		override public function update():void {
			super.update();
			var box2:FlxSprite = checkBoxes.members[Registry.taskStatuses.indexOf(TaskStatuses.EMPTY)];
			if (flag) {
				xDistance = distanceBetweenPoints(new FlxPoint(box2.x + (box2.width / 2), box2.y + (box2.height / 2)), new FlxPoint(foo, box2.y + (box2.height / 2))) / 50;
				trace(xDistance);
				yDistance = distanceBetweenPoints(new FlxPoint(box2.x + (box2.width / 2), box2.y + (box2.height / 2)), new FlxPoint(box2.x + (box2.width / 2), bar)) / 50;
				trace(yDistance);
				flag = false;
			}
			if (timer.secondsElapsed > 2) {
				zoomCam.focusOn(new FlxPoint(foo, bar));
				/*if (foo >= box2.x + (box2.width / 2)) {
					foo += xDistance;
				}
				if (bar >= box2.y + (box2.height / 2)) {
					bar += yDistance;
				}*/
				if (increment != 50) {
					foo += xDistance;
					bar += yDistance;
					increment++;
				}
				zoomCam.fade(0xffffffff, 2);
				
				zoomCam.targetZoom = 5;
			}
			/*if (timer.secondsElapsed > 2) {
				//TESTING CAMERA ZOOM
				//zoomCam.focusOn(new FlxPoint(box2.x + (box2.width / 2), box2.y + (box2.height / 2)));
				//zoomCam.focusOn(new FlxPoint(foo + 100, bar + 100));
				zoomCam.targetZoom = 5;
				//zoomCam.target = box2;
				flag = false;
			}*/
			if (timer.hasExpired) {
				pickMinigame();
			}
		}
		
		public function generatePool():void {
			var levelZeroMinigames:Array = minigames[0];
			var levelOneMinigames:Array = minigames[1];
			var levelTwoMinigames:Array = minigames[2];
			var levelThreeMinigames:Array = minigames[3];
			
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
						minigames[1].push(levelZeroMinigames[i]);
					}
					// remove the selected minigames from 
					levelZeroMinigames.splice(0, 6);
					trace(minigames[0]);
					trace(minigames[1]);
					break;
				case DaysOfTheWeek.TUESDAY:
					// SELECT 4 LEVEL 0 GAMES
					shuffle(levelZeroMinigames);
					for (i = 0; i < 4; i++) {
						pair = new Dictionary();
						pair["minigame"] = levelZeroMinigames[i];
						pair["level"] = 0;
						Registry.pool[i] = pair;
						// add minigames to next pool of minigames
						minigames[1].push(levelZeroMinigames[i]);
					}
					levelZeroMinigames.splice(0, 4);
					
					// SELECT 2 LEVEL 1 GAMES
					shuffle(levelOneMinigames);
					for (i = 0; i < 2; i++) {
						pair = new Dictionary();
						pair["minigame"] = levelOneMinigames[i];
						pair["level"] = 1;
						Registry.pool[i] = pair;
						// add minigames to next pool of minigames
						minigames[2].push(levelOneMinigames[i]);
					}
					levelOneMinigames.splice(0, 2);
					trace("THIS HAPPENED");
					break;
				case DaysOfTheWeek.WEDNESDAY:
					//TO DO
				case DaysOfTheWeek.THURSDAY:
					//TO DO
				case DaysOfTheWeek.FRIDAY:
					//TO DO
				case DaysOfTheWeek.SATURDAY:
					//TO DO
			}
			shuffle(Registry.pool);
		}
		
		public function pickMinigame():void {
			
			var minigameState:MinigameState;
			//gets the value of the first element of the array and removes it, won't be played
			//again on this day
			var currentMinigame:Dictionary = Registry.pool.shift();
			var level:uint = currentMinigame["level"];
			switch(currentMinigame["minigame"]) {
				case Minigames.MINIGAME_ZERO:
					minigameState = new Minigame_ZERO(minigames, level);
					break;
				case Minigames.MINIGAME_ONE:
					minigameState = new Minigame_ONE(minigames, level);
					break;
			}
			delete
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