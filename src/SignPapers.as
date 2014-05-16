package 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import flash.utils.ByteArray;
	
	public class SignPapers extends MinigameState
	{
		public static var level:Number; // The level of the game's difficulty
		
		private var papers:Array; // An array containing all of then valid papers to sign for the current level
		private var seenPapers:Array; // An array of paper indexes that have already been seen
		
		private var currPaperAnswer:Boolean; // The answer to the current paper
		private var currPaperText:FlxText; // The text displaying the current paper
		
		private var numAnswered:int = 0; // How many papers the player has answered
		private var numLeft:FlxText; // Text showing how many papers the player has left to answer
		
		private var lineSprite:FlxSprite; // The "Sign here: ___" image
		private var passButton:FlxButtonPlus; // The button to pass on singing a paper
		
		private static var NUM_PAPERS:int = 4; // How many papers the player must sign per game
		
		[Embed(source = "/image_assets/signline.png")] private var img:Class;
		
		[Embed(source="../src/signpapers.txt",mimeType="application/octet-stream")] private var papersFile:Class;
		
		override public function create():void
		{
			
			FlxG.bgColor = 0xffaaaaaa;
			
			level = Registry.difficultyLevel;
			
			papers = new Array();
			
			currPaperText = new FlxText(FlxG.width / 8, FlxG.height / 4, 3 * (FlxG.width / 4));
			currPaperText.font = "Arial";
			if (level == 0) {
				currPaperText.size = 40;
			} else if (level == 1) {
				currPaperText.size = 35;
			} else {
				currPaperText.size = 23;
				currPaperText.y -= 40;
			}
			add(currPaperText);
			
			loadPapers();
			
			lineSprite = new FlxSprite(30, FlxG.height / 4 + 150);
			lineSprite.loadGraphic(img);
			add(lineSprite);
			
			numLeft = new FlxText(20, FlxG.height - 85, FlxG.width, "" + NUM_PAPERS);
			numLeft.color = 0x00000000;
			numLeft.size = 50;
			add(numLeft);
			
			passButton = new FlxButtonPlus(50, (FlxG.height / 4) * 3, pass, null, "SKIP", 200, 40);
			passButton.updateInactiveButtonColors([ 0xffFF0080, 0xffFF80C0 ]);
			passButton.updateActiveButtonColors([ 0xffFFFF00, 0xffFF8000 ]);
			passButton.screenCenter();
			passButton.textNormal.size = 30;
			passButton.textHighlight.size = 30;
			add(passButton);
			
			super.create();
			super.setCommandText("Sign for money gain ONLY!");
			if (level < 2) {
				super.setTimer(21000);
			} else {
				super.setTimer(26000);
			}
			super.timer.callback = timeout;
			//Registry.loggingControl.logLevelStart(10, null);
		}
		
		override public function update():void
		{
			if (!FlxG.paused) {
				// Easier to create rectangle bounding box than a sprite in this case
				if (FlxG.mouse.justReleased() && FlxG.mouse.screenX >= lineSprite.x && FlxG.mouse.screenX <= lineSprite.x + lineSprite.width &&
					FlxG.mouse.screenY >= lineSprite.y && FlxG.mouse.screenY <= lineSprite.y + lineSprite.height) {
						if (currPaperAnswer) {
							numAnswered++;
							
							// CHECKS IF VICTORY CONDITIONS ARE MET
							if (numAnswered >= NUM_PAPERS) {
								//var data1:Object = { "completed":"success" };
								//Registry.loggingControl.logLevelEnd(data1);
								super.success = true;
								currPaperText.text = "Good work!";
								numLeft.text = "0";
							} else {
								updateText();
								numLeft.text = "" + (NUM_PAPERS - numAnswered);
							}
							
						} else {
							//var data2:Object = { "completed":"failure" };
							//Registry.loggingControl.logLevelEnd(data2);
							super.timer.abort();
						}
				}
			}
			
			super.update();
		}
		
		public function updateText():void
		{
			var text:String = papers.shift();
			currPaperText.color = 0x00000000;
			currPaperText.text = text.substring(2);
			currPaperAnswer = text.charAt(0) == "Y";
		}
		
		public function pass():void
		{
			if (!currPaperAnswer) {
				numAnswered++;
				
				if (numAnswered >= NUM_PAPERS) {
					//var data1:Object = { "completed":"success" };
					//Registry.loggingControl.logLevelEnd(data1);
					super.success = true;
					currPaperText.text = "Good work!";
					numLeft.text = "0";
				} else {
					updateText();
					numLeft.text = "" + (NUM_PAPERS - numAnswered);
				}
			} else {
				//var data2:Object = { "completed":"failure" };
				//Registry.loggingControl.logLevelEnd(data2);
				super.timer.abort();
			}
		}
		
		private function loadPapers():void
			{
				var b:ByteArray = new papersFile();
				var data:String = b.readUTFBytes(b.length);
				
				
				//var data:String = loader.data;
				var lines:Array = data.split("\n");
				
				for (var i:int; i < lines.length; i++ ) {
					var line:String = lines[i];
					
					var num:String = line.charAt(0);
					if (num == "" + level) {
						papers.push(line.substring(2));
					}
				}
				FlxG.shuffle(papers, 30);
				updateText();
			}
			
		public function timeout():void {
			var data1:Object = { "completed":"failure" };
			Registry.loggingControl.logLevelEnd(data1);
		
		
		}
	}

}