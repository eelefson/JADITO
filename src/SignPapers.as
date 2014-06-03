package 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import mx.core.FlexSprite;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import flash.utils.ByteArray;
	import org.flixel.plugin.photonstorm.API.FlxKongregate;
	
	public class SignPapers extends MinigameState
	{
		public static var level:Number; // The level of the game's difficulty
		
		public var TEXT_SIZE:int = 25; // Size of text
		public var SPACE_SIZE:int = 10; // Size of spaces
		public var LINE_SPACING:int = 30; // Space between lines
		public var TEXT_MARGIN:int = 80; // Space between text and all edges of screen
		
		public var textGroup:FlxGroup;
		
		private var papers:Array; // An array containing all of then valid papers to sign for the current level
		private var seenPapers:Array; // An array of paper indexes that have already been seen
		
		private var currPaperAnswer:Boolean; // The answer to the current paper
		private var currPaperText:FlxText; // The text displaying the current paper
		
		private var numAnswered:int = 0; // How many papers the player has answered
		private var numLeft:FlxText; // Text showing how many papers the player has left to answer
		
		private var lineSprite:FlxSprite; // The "Sign here: ___" image
		private var passButton:FlxButtonPlus; // The button to pass on singing a paper
		
		private var signature_graphic:FlxExtendedSprite
		
		private var newVersion:Boolean;
		private var hintBubble:FlxSprite;
		private var hint:FlxText;
		private var tries:Number;
		
		private static var NUM_PAPERS:int = 4; // How many papers the player must sign per game
		
		[Embed(source = "/image_assets/signline.png")] private var img:Class;
		[Embed(source = "image_assets/Signature2.png")] private var SignatureImage:Class;
		[Embed(source = "image_assets/hintbubble.png")] private var hintImage:Class;
		
		[Embed(source = "sound_assets/phoneblip.mp3")] private var inputSound:Class;
		[Embed(source = "sound_assets/wrong.mp3")] private var wrongSound:Class;
		
		[Embed(source = "../src/signpapers.txt", mimeType = "application/octet-stream")] private var papersFile:Class;
		[Embed(source = "font_assets/BowlbyOne-Regular.ttf", fontFamily = "Score2", embedAsCFF = "false")] private var ScoreFont:String;
		
		override public function create():void {
			if (FlxG.getPlugin(FlxMouseControl) == null) {
				FlxG.addPlugin(new FlxMouseControl);
			}
			
			newVersion = true;
			
			FlxG.bgColor = 0xffaaaaaa;
			
			textGroup = new FlxGroup();
			
			gameOver = false;
			
			level = Registry.difficultyLevel;
			
			tries = 3 - level;
			
			papers = new Array();
			
			currPaperText = new FlxText(FlxG.width / 8, FlxG.height / 4, 3 * (FlxG.width / 4));
			currPaperText.font = "Arial";
			currPaperText.size = 40;
			currPaperText.color = 0xFF000000;
			if (level == 0) {
				TEXT_SIZE = 40;
				LINE_SPACING = 45;
			} else if (level == 1) {
				TEXT_SIZE = 35;
				LINE_SPACING = 40;
			} else {
				TEXT_SIZE = 23;
				SPACE_SIZE = 6;
				currPaperText.y -= 40;
			}
			add(currPaperText);
			
			loadPapers();
			
			lineSprite = new FlxSprite(30, FlxG.height / 4 + 150);
			lineSprite.loadGraphic(img, false, false, 512, 55);
			if (level == 0) {
				lineSprite.frame = 1;
			}
			add(lineSprite);
			
			signature_graphic = new FlxExtendedSprite(205, FlxG.height / 4 + 120, SignatureImage);
			signature_graphic.visible = false;
			add(signature_graphic);
			
			numLeft = new FlxText(10, FlxG.height - 75, FlxG.width, "Papers: " + NUM_PAPERS);
			numLeft.font = "Score2";
			numLeft.color = 0x00000000;
			numLeft.size = 30;
			add(numLeft);
			
			passButton = new FlxButtonPlus(50, (FlxG.height / 4) * 3, pass, null, "REFUSE", 200, 40);
			passButton.updateInactiveButtonColors([ 0xffFF0080]);
			passButton.updateActiveButtonColors([ 0xffFFFF00, 0xffFF8000 ]);
			passButton.screenCenter();
			passButton.textNormal.setFormat("Score2", 30, 0xFFFFFFFF, null, 1);
			passButton.textHighlight.setFormat("Score2", 30, 0xFFFFFFFF, null, 1);
			passButton.textNormal.y -= 7;
			passButton.textHighlight.y -= 7;
			//passButton.textNormal.size = 30;
			//passButton.textHighlight.size = 30;
			//passButton.textNormal.color = 0xFF000000;
			//passButton.textHighlight.color = 0xFF000000;
			add(passButton);
			
			if (newVersion) {
				signature_graphic.y += 20;
				lineSprite.y += 20;
				
				hintBubble = new FlxSprite(0, 200);
				hintBubble.loadGraphic(hintImage);
				hintBubble.visible = false;
				add(hintBubble);
				
				hint = new FlxText(150, 230, FlxG.width);
				hint.size = 23;
				hint.color = 0xFF000000;
				hint.font = "Typewriter";
				add(hint);
			}
			
			super.create();
			super.setCommandText("Sign for money gain ONLY!");
			if (level < 2) {
				super.setTimer(21000);
			} else {
				super.setTimer(26000);
			}
			super.timer.callback = timeout;
			var data5:Object = { "difficulty":level,
								"playthrough":Registry.playthrough,
								"sequence number":Registry.playthroughSeqNum };
			Registry.playthroughSeqNum++;
			Registry.loggingControl.logLevelStart(10, data5);
		}
		
		override public function update():void {
			super.update();
			if (!FlxG.paused && !gameOver) {
				// Easier to create rectangle bounding box than a sprite in this case
				if (FlxG.mouse.justReleased() && FlxG.mouse.screenX >= lineSprite.x && FlxG.mouse.screenX <= lineSprite.x + lineSprite.width &&
					FlxG.mouse.screenY >= lineSprite.y && FlxG.mouse.screenY <= lineSprite.y + lineSprite.height) {
						Registry.loggingControl.logAction(3, { "action":"sign clicked" } );
						if (currPaperAnswer) {
							numAnswered++;
							
							if (newVersion) {
								hintBubble.visible = false;
								hint.text = "";
							}
							
							// CHECKS IF VICTORY CONDITIONS ARE MET
							if (numAnswered >= NUM_PAPERS) {
								if(!gameOver){
									var data1:Object = { "completed":"success" };
									Registry.loggingControl.logLevelEnd(data1);
								}
								if(Registry.kongregate) {
									if (level == 0) {
										FlxKongregate.submitStats("SignThePapersBeginner", 1);
										FlxKongregate.submitStats("SignThePapersProgress", 1);
									}else if (level == 1) {
										FlxKongregate.submitStats("SignThePapersEasy", 1);
										FlxKongregate.submitStats("SignThePapersProgress", 2);
									}else if (level == 2) {
										FlxKongregate.submitStats("SignThePapersMedium", 1);
										FlxKongregate.submitStats("SignThePapersProgress", 3);
									}else {
										FlxKongregate.submitStats("SignThePapersHard", 1);
										FlxKongregate.submitStats("SignThePapersProgress", 4);
									}
								}
								gameOver = true;
								super.success = true;
								for (var i:int = 0; i < textGroup.length; i++) {
									var curr:SignText = textGroup.members[i];
									remove(curr);
									textGroup.remove(curr);
								}
								currPaperText.text = "Good work!";
								numLeft.text = "Papers: 0";
							} else {
								updateText();
								FlxG.play(inputSound);
								numLeft.text = "Papers: " + (NUM_PAPERS - numAnswered);
							}
							
						} else {
							if (newVersion && tries > 0) {
					
								hintBubble.visible = true;
								hint.text = "Remember to sign for money gain only!";
								tries--;
								
								FlxG.play(wrongSound);
								
							} else {
							
								if(!gameOver) {
									var data2:Object = { "completed":"failure","type":"wrong answer" };
									Registry.loggingControl.logLevelEnd(data2);
								}
								gameOver = true;
								super.timer.abort();
								
							}
						}
				} else if (!gameOver) {
					Registry.loggingControl.logAction(1, null);
				}
				if (FlxG.mouse.screenX >= lineSprite.x && FlxG.mouse.screenX <= lineSprite.x + lineSprite.width &&
					FlxG.mouse.screenY >= lineSprite.y && FlxG.mouse.screenY <= lineSprite.y + lineSprite.height) {
					signature_graphic.visible = true;
				} else {
					signature_graphic.visible = false;
				}
			}
		}
		
		public function updateText():void
		{
			/*var text:String;
			if (level == 0 && numAnswered == 0) {
				text = "If you sign here, we will GIVE YOU the $30,000 immediately.";
				currPaperAnswer = true;
			} else if (level == 0 && numAnswered == 1) {
				text = "Our SERVICE FEE is a mere $50";
				currPaperAnswer = false;
			} else {
				text = papers.shift();
				currPaperAnswer = text.charAt(0) == "Y";
				text = text.substring(2);
			}
			currPaperText.color = 0x00000000;
			currPaperText.text = text;*/
			
			for (var i:int = 0; i < textGroup.length; i++) {
				var curr:SignText = textGroup.members[i];
				remove(curr);
				textGroup.remove(curr);
			}
			
			var textBlock:String;
			if (level == 0 && numAnswered == 0) {
				textBlock = "  If you sign here, we will @give @you @$30,000 right away.";
				currPaperAnswer = true;
			} else if (level == 0 && numAnswered == 1) {
				textBlock = "  Our services will @cost @you @$10,000.";
				currPaperAnswer = false;
			} else {
				textBlock = papers.shift();
				currPaperAnswer = textBlock.charAt(0) == "Y"; 
			}
			
			var paragraph:Array = textBlock.substring(2).split(" ");
			
			var x:int = TEXT_MARGIN;
			var y:int = TEXT_MARGIN;
			
			if (newVersion && level >= 2) {
				y -= 20;
			}
			
			if (level == 0 && newVersion) {
				y -= 20;
			}
			
			// Print each word
			for (var j:int; j < paragraph.length; j++) {
				var word:String = paragraph[j];
				var text:SignText = new SignText(x, y, FlxG.width / 2);
				
				text.size = TEXT_SIZE;
				text.font = "Arial";
				if (level == 0 && word.charAt(0) == '@' && currPaperAnswer) {
					text.color = 0xFF336600;
					text.text = word.substring(1);
				} else if (level == 0 && word.charAt(0) == '@' && !currPaperAnswer) {
					text.color = 0xFFFF0000;
					text.text = word.substring(1);
				} else {
					text.color = 0xFF000000;
					text.text = word;
				}
				
				if (x + text.getRealWidth() > FlxG.width - TEXT_MARGIN) {
					text.x = TEXT_MARGIN;
					text.y = y = y + LINE_SPACING;
					x = TEXT_MARGIN;
				} 
				x += text.getRealWidth() + SPACE_SIZE;

				textGroup.add(text);
				add(textGroup);
			}
		}
		
		public function pass():void
		{
			
			Registry.loggingControl.logAction(2, { "action":"pass button" } );
			if (!currPaperAnswer) {
				numAnswered++;
				
				if (newVersion) {
					hintBubble.visible = false;
					hint.text = "";
				}
				
				if (numAnswered >= NUM_PAPERS) {
					if(!gameOver){
						var data1:Object = { "completed":"success" };
						Registry.loggingControl.logLevelEnd(data1);
					}
					gameOver = true;
					super.success = true;
					currPaperText.text = "Good work!";
					for (var i:int = 0; i < textGroup.length; i++) {
						var curr:SignText = textGroup.members[i];
						remove(curr);
						textGroup.remove(curr);
					}
					numLeft.text = "Papers: 0";
				} else {
					updateText();
					numLeft.text = "Papers: " + (NUM_PAPERS - numAnswered);
					FlxG.play(inputSound);
				}
			} else {
				if (newVersion && tries > 0) {
					
					hintBubble.visible = true;
					hint.text = "Don't refuse if you will gain money!";
					tries--;
					
					FlxG.play(wrongSound);
					
				} else {
				
					if(!gameOver){
						var data2:Object = { "completed":"failure","type":"wrong answer" };
						Registry.loggingControl.logLevelEnd(data2);
					}
					gameOver = true;
					super.timer.abort();
				}
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
			if(!gameOver){
				var data1:Object = { "completed":"failure","type":"timeout" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			gameOver = true;
		}
		
		override public function destroy():void {
			//	Important! Clear out the plugin otherwise resources will get messed right up after a while
			FlxMouseControl.clear();

			super.destroy();
		}
	}

}