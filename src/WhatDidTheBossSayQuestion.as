package  {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class WhatDidTheBossSayQuestion extends FlxState {
		
		private var questionText:FlxText;
		
		private var delay:FlxDelay;
		
		override public function create():void {
			questionText = new FlxText(0, FlxG.height / 2, FlxG.width, "Question goes here!");
			questionText.setFormat(null, 32, 0xff000000, "center", 30);
			questionText.y = questionText.y - (questionText.height / 2);
			add(questionText);
			
			delay = new FlxDelay(5000);
			delay.start();
		}
		
		override public function update():void {
			super.update();
			if (delay.hasExpired) {
				FlxG.switchState(new PlayState());
			}
		}
		
	}

}