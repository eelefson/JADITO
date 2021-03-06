package  
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.API.FlxKongregate;
	import flash.utils.ByteArray;
	
	public class Spellchecker extends MinigameState
	{
		public var level:Number; // The level of the game's difficulty
		
		public var TEXT_SIZE:int = 25; // Size of text
		public var SPACE_SIZE:int = 10; // Size of spaces
		public var LINE_SPACING:int = 34; // Space between lines
		public var TEXT_MARGIN:int = 80; // Space between text and all edges of screen
		
		public var numTypos:int; // Number of typos left to find
		public var typoCounter:FlxText; // Counter for typos left
		public var hasFailed:Boolean = false; // Has the player failed?
		public var textGroup:FlxGroup;
		
		private var hasLoaded:Boolean = false;
		
		public var ticks:int = 0;
		
		[Embed(source = "../src/spellchecker.txt", mimeType = "application/octet-stream")] private var spellcheckFile:Class;
		[Embed(source = "font_assets/ArbutusSlab-Regular.ttf", fontFamily = "Regular", embedAsCFF = "false")] private var RegularFont:String;
		[Embed(source = "font_assets/BowlbyOne-Regular.ttf", fontFamily = "Score2", embedAsCFF = "false")] private var ScoreFont:String;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffaaaaaa;
			
			level = Registry.difficultyLevel;
			
			gameOver = false;
			
			
			
			// Difficulty 3 has two typos to find
			if (level < 2) {
				numTypos = 1;
			} else {
				numTypos = 2;
			}
			
			typoCounter = new FlxText(10, FlxG.height - 75, FlxG.width, "Typos: " + numTypos);
			typoCounter.font = "Score2";
			typoCounter.size = 30;
			typoCounter.color = 0xff000000;
			add(typoCounter);
			
			textGroup = new FlxGroup();
			//loadParagraph();
			
			super.create();
			if (level < 2) {
				super.setCommandText("Find the Typo!");
			} else {
				super.setCommandText("Find the Typos!");
			}

			if (level < 2) {
				super.setTimer(11000);
			} else {
				super.setTimer(16000);
			}
			var data5:Object = { "difficulty":level,
								"playthrough":Registry.playthrough,
								"sequence number":Registry.playthroughSeqNum };
			Registry.playthroughSeqNum++;
			Registry.loggingControl.logLevelStart(12, data5);
		}
		
		override public function update():void
		{
			super.update();
			
			if (numTypos <= 0) { // The user has won! Wait a few moments to continue
				ticks++;
				if (ticks == 20) { // Enough time has passed, end the game!
					if(!gameOver){
						var data1:Object = { "completed":"success" };
						Registry.loggingControl.logLevelEnd(data1);
					}
					if(Registry.kongregate) {
						if (level == 0) {
							FlxKongregate.submitStats("SpellCheckerBeginner", 1);
							FlxKongregate.submitStats("SpellCheckerProgress", 1);
						}else if (level == 1) {
							FlxKongregate.submitStats("SpellCheckerEasy", 1);
							FlxKongregate.submitStats("SpellCheckerProgress", 2);
						}else if (level == 2) {
							FlxKongregate.submitStats("SpellCheckerMedium", 1);
							FlxKongregate.submitStats("SpellCheckerProgress", 3);
						}else {
							FlxKongregate.submitStats("SpellCheckerHard", 1);
							FlxKongregate.submitStats("SpellCheckerProgress", 4);
						}
					}
					gameOver = true;
					super.success = true;
				}
			}

			if (super.timer.hasExpired && !super.success) {
				for (var i:int = 0; i < textGroup.length; i++) {
					var curr:SpellText = textGroup.members[i];
					if (curr.misspelled) {
						curr.color = 0x00FF0000;
					} else {
						curr.text = "";
					}
				}
			}
			
			if (hasFailed) { // The user has failed!
				if (!gameOver) {
					if (super.timer.hasExpired) {
						var data2:Object = { "completed":"failure","type":"timeout" };
						Registry.loggingControl.logLevelEnd(data2);
					} else {
						var data3:Object = { "completed":"failure", "type":"wrong word" };
						Registry.loggingControl.logLevelEnd(data3);
					}
				}
				gameOver = true;
				ticks++;
				if (ticks ==  40) {
					super.timer.abort();
				}
			}
			
			if (!hasLoaded && !FlxG.paused) {
				loadParagraph();
				hasLoaded = true;
			}
			
			typoCounter.text = "Typos: " + numTypos;
		}
		
		private function loadParagraph():void
			{
				var b:ByteArray = new spellcheckFile();
				var data:String = b.readUTFBytes(b.length)
				var lines:Array = data.split("\n"); // Holds all lines in text file
				
				var possibleParagraphs:Array = new Array();
				
				// Fill possibleParagraphs with all lines that match the current dfficutly level
				for (var j:int = 0; j < lines.length; j++ ) {
					var currLine:String = lines[j];
					if (currLine != "") {
						var lineLevel:int = lines[j].charAt(0);
						
						// This triggers if the difficutly levels match OR if the level is 2 and the line is 1
						if (lineLevel == level || level == 2 && lineLevel == 1) {
							possibleParagraphs.push(lines[j].substring(2));
						}
					}
				}
				
				// A random index into possibleParagraphs
				var parIndex:int = Math.floor(Math.random() * possibleParagraphs.length);
				
				var line:String = possibleParagraphs[parIndex];
				var array:Array = line.split(" | "); // Holds the correct string and substitutions

				var paragraph:Array = array[0].split(" "); // Holds all correct words
				
				var misspellings:Array = array[1].split(" "); // Holds all substitutions

				var temp_misspellings:Array = new Array();
				for(var m:int = 0; m < misspellings.length; m++){
					temp_misspellings[m] = misspellings[m];
				}
				
				shuffle(temp_misspellings);
				
				var misspelling_one:String = temp_misspellings.shift();
				// A random index into misspellings
				for(var l:int = 0; l < misspellings.length; l++){
					if (misspellings[l] == misspelling_one) {
						var replaceIndex:int =  l + 1;
					}
				}
				var replaceIndex2:int = -1;
				if (level >= 2) { // We need a second one if the difficulty is 2 or 3
					var misspelling_two:String = temp_misspellings.shift();
					for(var k:int = 0; k < misspellings.length; k++){
						if (misspellings[k] == misspelling_two) {
							replaceIndex2 =  k + 1;
						}
					}
				}
				
				var x:int = TEXT_MARGIN;
				var y:int = TEXT_MARGIN;
				
				// Print each word
				for (var i:int; i < paragraph.length; i++) {
					var word:String = paragraph[i];
					var text:SpellText;
					
					if (word.charAt(0) == "@") { // The current word has a possible substitution
						if (word.charAt(1) == "" + replaceIndex) { // Replace the current word with the first substitution
							text = new SpellText(this, x, y, FlxG.width, misspellings[replaceIndex - 1].substring(1), true, word.substring(2));
						} else if (word.charAt(1) == "" + replaceIndex2) { // Replace the current word with the second substitution
							text = new SpellText(this, x, y, FlxG.width, misspellings[replaceIndex2 - 1].substring(1), true, word.substring(2));
						} else { // Don't repalce the word, just trim the "@" part of it
							word = word.substring(2);
							text = new SpellText(this, x, y, FlxG.width, word);
						}
					} else { // The current word has no possible substitution
						text = new SpellText(this, x, y, FlxG.width, word);
					}
					
					text.size = TEXT_SIZE;
					text.font = "Regular";
					
					if (x + text.getRealWidth() > FlxG.width - TEXT_MARGIN) {
						text.x = TEXT_MARGIN;
						text.y = y = y + LINE_SPACING;
						x = TEXT_MARGIN;
					} 
					x += text.getRealWidth() + SPACE_SIZE;
					
					textGroup.add(text);
					add(text);
				}
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