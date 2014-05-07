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
		public static var hasFailed:Boolean = false; // Has the player failed?
		
		public var ticks:int = 0;
		
		[Embed(source="../src/spellchecker.txt",mimeType="application/octet-stream")] private var spellcheckFile:Class;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffaaaaaa;
			
			level = Registry.difficultyLevel;
			
			super.setTimer(20000);
			
			// Difficulty 3 has two typos to find
			if (level < 3) {
				numTypos = 1;
			} else {
				numTypos = 2;
			}
			
			loadParagraph();
			
			super.create();
			super.setCommandText("Find the Typos!");
			super.setTimer(20000);
		}
		
		override public function update():void
		{
			if (numTypos <= 0) { // The user has won! Wait a few moments to continue
				ticks++;
				if (ticks == 40) { // Enough time has passed, end the game!
					super.success = true;
				}
			}
			
			if (hasFailed) { // The user has failed!
				ticks++;
				if (ticks ==  40) {
					super.timer.abort();
				}
			}
			
			super.update();
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
						
						// This triggers if the difficutly levels match OR if the level is 3 and the line is 2
						if (lineLevel == level || level == 3 && lineLevel == 2) {
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
				if (level == 3) { // We need a second one if the difficulty is 3
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