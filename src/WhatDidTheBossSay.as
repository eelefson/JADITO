package  {
	import org.flixel.*;
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class WhatDidTheBossSay extends MinigameState {
		[Embed(source = "image_assets/confused_coworker.png")] private var Coworker1Image:Class;
		[Embed(source="image_assets/speech bubble2.png")] private var SpeechBubbleImage:Class;
		
		private var coworker_graphic:FlxSprite;
		private var speech_bubble_graphic:FlxSprite;
		private var questionText:FlxText;
		
		override public function create():void {
			FlxG.bgColor = 0xffffffff;
			
			coworker_graphic = new FlxSprite(400, 25, Coworker1Image);
			coworker_graphic.x = coworker_graphic.x - (coworker_graphic.width / 2);
			add(coworker_graphic);
			
			speech_bubble_graphic = new FlxSprite(40, 25, SpeechBubbleImage);
			add(speech_bubble_graphic);
			
			var question:String;
			if (Registry.difficultyLevel == 0) {
				question = "What's the new guy's name again?";
			} else if (Registry.difficultyLevel == 1) {
				question = "What was the WiFi password?";
			} else if (Registry.difficultyLevel == 2) {
				question = "Do you remember that funny website's URL?";
			} else if (Registry.difficultyLevel == 3) {
				question = "I forgot the security code... What was it?";
			}
			
			questionText = new FlxText(speech_bubble_graphic.x + (speech_bubble_graphic.width / 2), speech_bubble_graphic.y + (speech_bubble_graphic.height / 2), 250, question);
			questionText.setFormat(null, 16, 0xff000000, "center");
			questionText.x = questionText.x - (questionText.width / 2);
			questionText.y = questionText.y - (questionText.height);
			add(questionText);
			
			super.create();
			
			super.setCommandText("Remember!");
			super.setTimer(10000);
		}
		
		override public function update():void {
			super.update();
		}
	}

}