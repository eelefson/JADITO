package  
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import flash.utils.ByteArray;
	
	public class Spellchecker extends MinigameState
	{
		public static var level:Number; // The level of the game's difficulty
		
		public static var TEXT_SIZE:int = 25; // Size of text
		public static var SPACE_SIZE:int = 10; // Size of spaces
		public static var LINE_SPACING:int = 30; // Space between lines
		public static var TEXT_MARGIN:int = 80; // Space between text and all edges of screen
		
		public static var numTypos:int; // Number of typos left to find
		public var typoCounter:FlxText; // Counter for typos left
		public static var hasFailed:Boolean = false; // Has the player failed?
		
		private var hasLoaded:Boolean = false;
		
		public var ticks:int = 0;
		
		[Embed(source="../src/spellchecker.txt",mimeType="application/octet-stream")] private var spellcheckFile:Class;
		
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
			
			typoCounter = new FlxText(10, FlxG.height - 65, FlxG.width / 2, "" + numTypos);
			typoCounter.size = 30;
			typoCounter.color = 0xff000000;
			add(typoCounter);
			
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
			var data5:Object = { "difficulty":level };
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
					gameOver = true;
					super.success = true;
				}
			}
			
			if (super.timer.hasExpired && !super.success && !FlxG.paused) {
				hasFailed = true;
			}
			
			if (hasFailed) { // The user has failed!
				if(!gameOver){
					var data2:Object = { "completed":"failure" };
					Registry.loggingControl.logLevelEnd(data2);
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
			
			typoCounter.text = "" + numTypos;
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
				
				// A random index into misspellings
				var replaceIndex:int = Math.floor(Math.random() * misspellings.length) + 1;
				var replaceIndex2:int = -1;
				if (level >= 2) { // We need a second one if the difficulty is 2 or 3
					replaceIndex2 = Math.floor(Math.random() * misspellings.length) + 1
				}
				
				var x:int = TEXT_MARGIN;
				var y:int = TEXT_MARGIN;
				
				// Print each word
				for (var i:int; i < paragraph.length; i++) {
					var word:String = paragraph[i];
					var text:SpellText;
					
					//trace(word);
					
					if (word.charAt(0) == "@") { // The current word has a possible substitution
						if (word.charAt(1) == "" + replaceIndex) { // Replace the current word with the first substitution
							text = new SpellText(x, y, FlxG.width, misspellings[replaceIndex - 1].substring(1), true, word.substring(2));
						} else if (word.charAt(1) == "" + replaceIndex2) { // Replace the current word with the second substitution
							text = new SpellText(x, y, FlxG.width, misspellings[replaceIndex2 - 1].substring(1), true, word.substring(2));
						} else { // Don't repalce the word, just trim the "@" part of it
							word = word.substring(2);
							text = new SpellText(x, y, FlxG.width, word);
						}
					} else { // The current word has no possible substitution
						text = new SpellText(x, y, FlxG.width, word);
					}
					
					text.size = TEXT_SIZE;
					
					if (x + text.getRealWidth() > FlxG.width - TEXT_MARGIN) {
						text.x = TEXT_MARGIN;
						text.y = y = y + LINE_SPACING;
						x = TEXT_MARGIN;
					} 
					x += text.getRealWidth() + SPACE_SIZE;
					
					add(text);
				}
			}
		

	}

}