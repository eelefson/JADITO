package 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class SignPapers extends MinigameState
	{
		public static var level:Number = Registry.difficultyLevel; // The level of the game's difficulty
		
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
		
		override public function create():void
		{
			
			FlxG.bgColor = 0xffaaaaaa;
			
			papers = new Array();
			
			var url:URLRequest = new URLRequest("../src/signpapers.txt");
			
			var loader:URLLoader = new URLLoader();
			
			loader.addEventListener(Event.COMPLETE, loaderComplete);
			
			currPaperText = new FlxText(FlxG.width / 4 + 50, FlxG.height / 4, FlxG.width / 2);
			add(currPaperText);
			
			lineSprite = new FlxSprite(30, FlxG.height / 4 + 150);
			lineSprite.loadGraphic(img);
			add(lineSprite);
			
			numLeft = new FlxText(20, FlxG.height - 60, FlxG.width, "" + NUM_PAPERS);
			numLeft.color = 0x00000000;
			numLeft.size = 50;
			add(numLeft);
			
			passButton = new FlxButtonPlus(50, (FlxG.height / 4) * 3, pass, null, "PASS", 200, 40);
			passButton.updateInactiveButtonColors([ 0xffFF0080, 0xffFF80C0 ]);
			passButton.updateActiveButtonColors([ 0xffFFFF00, 0xffFF8000 ]);
			passButton.screenCenter();
			passButton.textNormal.size = 30;
			passButton.textHighlight.size = 30;
			add(passButton);
			
			function loaderComplete(e:Event):void
			{
				var data:String = loader.data;
				var lines:Array = data.split("\n");
				
				for (var i:int; i < lines.length; i++ ) {
					var line:String = lines[i];
					
					var num:String = line.charAt(0);
					if (num == "" + level) {
						papers.push(line.substring(2));
					}
				}
				FlxG.shuffle(papers, 2);
				updateText();
			}
			
			loader.load(url);
			
			super.setTimer(20000);
			super.create();
		}
		
		override public function update():void
		{
			// Easier to create rectangle bounding box than a sprite in this case
			if (FlxG.mouse.justReleased() && FlxG.mouse.screenX >= lineSprite.x && FlxG.mouse.screenX <= lineSprite.x + lineSprite.width &&
				FlxG.mouse.screenY >= lineSprite.y && FlxG.mouse.screenY <= lineSprite.y + lineSprite.height) {
					if (currPaperAnswer) {
						numAnswered++;
						
						// CHECKS IF VICTORY CONDITIONS ARE MET
						if (numAnswered == NUM_PAPERS) {
							super.success = true;
						}
						updateText();
						numLeft.text = "" + (NUM_PAPERS - numAnswered);
						
					} else {
						super.timer.abort();
					}
			}
			
			super.update();
		}
		
		public function updateText():void
		{
			var text:String = papers.shift();
			currPaperText.size = 30;
			currPaperText.color = 0x00000000;
			currPaperText.text = text.substring(2);
			currPaperAnswer = text.charAt(0) == "Y";
		}
		
		public function pass():void
		{
			if (!currPaperAnswer) {
				numAnswered++;
				
				if (numAnswered == NUM_PAPERS) {
					super.success = true;
				}
				updateText();
				numLeft.text = "" + (NUM_PAPERS - numAnswered);
			} else {
				super.timer.abort();
			}
		}
		
		
	}

}