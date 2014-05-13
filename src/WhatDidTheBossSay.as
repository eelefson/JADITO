package  {
	import org.flixel.*;
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class WhatDidTheBossSay extends MinigameState {
		[Embed(source = "image_assets/confused_coworker.png")] private var Coworker1Image:Class;
		
		private var coworker_graphic:FlxSprite;
		
		override public function create():void {
			coworker_graphic = new FlxSprite(0, 0, Coworker1Image);
			add(coworker_graphic);
			
			super.create();
			
			super.setCommandText("Remember!");
			super.setTimer(10000);
		}
		
		override public function update():void {
			super.update();
		}
	}

}