package {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.API.FlxKongregate;
	
	public class ColdCaller extends MinigameState {
		[Embed(source = "sound_assets/phoneblip.mp3")] private var inputSound:Class;
		[Embed(source = "sound_assets/wrong.mp3")] private var wrongSound:Class;
		[Embed(source = "image_assets/arrow-right.png")] private var img:Class;
		[Embed(source = "image_assets/PhoneLarge.png")] private var phoneImg:Class;
		
		public static var level:Number; // The level of the game's difficulty
		
		private var another:Boolean = false; // If there is another phone number to input after the current one
		private var justStarted:Boolean = true; // If the game has just started
		
		private var Nums:Array; // Contains the numbers of the buttons (in row-maor order)
		private var NumRefs:FlxGroup; // Contains references to the buttons
		
		private var goal:Array; // The goal number
		private var goal2:Array; // The next goal number
		private var goalText:FlxText; // Text displaying the goal number
		private var goalText2:FlxText; // Text displaying the next goal number
		private var currIndex:int; // The current digit the player is on
		
		private var answerText:FlxText; // Text displaying the answer as the player types
		
		override public function create():void {
			if (FlxG.getPlugin(FlxMouseControl) == null) {
				FlxG.addPlugin(new FlxMouseControl);
			}
			
			FlxG.bgColor = 0xffaaaaaa;
			FlxG.mouse.show();
			
			gameOver = false;
			
			level = Registry.difficultyLevel;
			
			Nums = new Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 0, 10);
			NumRefs = new FlxGroup(12);
			
			var phone:FlxSprite = new FlxSprite(-20, 20);
			phone.loadGraphic(phoneImg);
			add(phone);
			
			createNums();
			
			goal = generateGoal();
			
			goalText = new FlxText(FlxG.width - 200, 40, FlxG.width, "");
			goalText.color = 0x00FF0000;
			goalText.size = 26;
			goalText.font = "Regular";
			add(goalText);
			goalText.text = displayGoal(goal);
			
			var arrow:FlxSprite = new FlxSprite(FlxG.width - 250, 38);
			arrow.loadGraphic(img);
			add(arrow);
			// Generate a second goal number if the level is 2 or 3
			if (level > 2) {
				goal2 = generateGoal();
			
				goalText2 = new FlxText(FlxG.width - 200, goalText.y + 26, FlxG.width, "");
				goalText2.color = 0x00000000;
				goalText2.size = 26;
				goalText2.font = "Regular";
				add(goalText2);
				goalText2.text = displayGoal(goal2);
				
				another = true;
			}
			
			currIndex = 0;
			
			answerText = new FlxText(FlxG.width - 265, 380, FlxG.width);
			answerText.color = 0x00800000;
			answerText.size = 30;
			answerText.font = "Regular";
			add(answerText);
			super.create();
			super.setCommandText("Dial the Numbers!");
			
			if (level < 2) {
				super.setTimer(11000);
			} else if (level == 2) {
				super.setTimer(16000);
			} else {
				super.setTimer(23000);
			}
			super.timer.callback = timeout;
			var data5:Object = { "difficulty":level,
								"playthrough":Registry.playthrough,
								"sequence number":Registry.playthroughSeqNum };
			Registry.playthroughSeqNum++;
			Registry.loggingControl.logLevelStart(5, data5);
		}
		
		override public function update():void {
			super.update();
			
			if (justStarted) {
				// Jumble the numbers if applicable
				if (level > 0) {
					//createNums();
					jumbleNums();
				}
				justStarted = false;
			}
			
			if (!FlxG.paused && !gameOver && FlxG.mouse.justPressed()) {
				Registry.loggingControl.logAction(1, null);
			}
		}
		
		// Create the button sprites according to the Nums array
		public function createNums():void
		{
			var DIST_FROM_SIDE:int = 185;
			var DIST_FROM_TOP:int = 135;
			
			var index:int = 0;
			for (var i:int = 0; i < 4; i++) {
				for (var j:int = 0; j < 3; j++) {
					var num:Num = new Num();
					
					//num.scale = new FlxPoint(0.8, 0.8);
					
					FlxG.addPlugin(new FlxMouseControl);
					num.enableMouseClicks(false);
					num.mousePressedCallback = clicked;
					
					num.number = Nums[index];
					num.x = DIST_FROM_SIDE + j * 50;
					num.y = DIST_FROM_TOP + i * 55;
					
					NumRefs.add(num);
					add(num);
					index++;
				}
			}
		}
		
		// Jumble the buttons
		public function jumbleNums():void
		{
			//var temp:Array = new Array(10);
			
			//Nums.sort(randomSort);
			
			FlxG.shuffle(Nums, 5);
			for (var i:int = 0; i < NumRefs.length; i++) {
				var curr:Num = NumRefs.members[i];
				curr.number = Nums[i];
			}
		}
		
		// Used by jumbleNums
		private function randomSort(a:int, b:int):Number    //* means any kind of input
		{
			if (Math.random() < 0.5) return -1;
			else return 1;
		}
		
		// Update when a button is clicked
		public function clicked(obj:Num, x:int, y:int):void
		{
			obj.changeFrame(1);
			
			Registry.loggingControl.logAction(2, { "action":"clicked number" } );
			
			// Correct, increment the digit and update the result
			if (obj.number == goal[currIndex]) {
				FlxG.play(inputSound);
				answerText.text += goal[currIndex];
				currIndex++;
				
				// Add phone dashes when appropriate
				if (currIndex == 3 || currIndex == 6) {
					answerText.text += "-";
				}
			} else { // Incorrect, reset everything
				FlxG.play(wrongSound);
				//answerText.text = "";
				//currIndex = 0;
				if (level >= 1) {
					jumbleNums();
				}
			}
			
			// Jumble buttons after every click at level 3
			if (level >= 2) {
				jumbleNums();
			}
			
			// The current number is complete
			if (currIndex >= goal.length) {
				// Move to the next number if there is another
				if (another) {
					answerText.text = "";
					goal = goal2;
					goalText.text = displayGoal(goal2);
					goalText2.text = "";
					currIndex = 0;
					
					another = false;
				} else {
					if (!gameOver) {
						var data1:Object = { "completed":"success" };
						Registry.loggingControl.logLevelEnd(data1);
					}
					if(Registry.kongregate) {
						if (level == 0) {
							FlxKongregate.submitStats("ColdCallerBeginner", 1);
							FlxKongregate.submitStats("ColdCallerProgress", 1);
						}else if (level == 1) {
							FlxKongregate.submitStats("ColdCallerEasy", 1);
							FlxKongregate.submitStats("ColdCallerProgress", 2);
						}else if (level == 2) {
							FlxKongregate.submitStats("ColdCallerMedium", 1);
							FlxKongregate.submitStats("ColdCallerProgress", 3);
						}else {
							FlxKongregate.submitStats("ColdCallerHard", 1);
							FlxKongregate.submitStats("ColdCallerProgress", 4);
						}
					}
					gameOver = true;
					super.success = true;
				}
			}
		}
		
		// Generates and returns an array representing a random phone number
		public function generateGoal():Array
		{
			var res_length:int = 10;
			
			var res:Array = new Array(res_length);
			for (var i:int = 0; i < res_length; i++) {
				var randomNumber:int = Math.floor(Math.random() * 10);
				res[i] = randomNumber;
			}
			
			return res;
		}
		
		// Returns a String representation of an array of numbers
		public function displayGoal(g:Array):String
		{
			var res:String = g[0];
			res += g[1];
			res += g[2];
			res += "-" + g[3] + g[4] +
							g[5] + "-" + g[6] + g[7] + g[8] + g[9];
							
			return res
		}
		
		public function timeout():void {
			if (!gameOver) {
				var data1:Object = { "completed":"failure","type":"timeout" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			gameOver = true;
			super.success = false;
		}
		
		override public function destroy():void {
			//	Important! Clear out the plugin otherwise resources will get messed right up after a while
			FlxMouseControl.clear();

			super.destroy();
		}
	}

}