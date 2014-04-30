package  {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class Minigame_ONE extends MinigameState {
		[Embed(source="image_assets/MadBoss-300x284.png")] private var BossImage:Class;
		
		private var boss_graphic:FlxExtendedSprite;
		
		override public function create():void {
			super.create();
			super.setTimer(5000);
			boss_graphic = new FlxExtendedSprite(FlxG.width / 2, FlxG.height / 2, BossImage);	
			boss_graphic.x = boss_graphic.x - (boss_graphic.width / 2);
			boss_graphic.y = boss_graphic.y - (boss_graphic.height / 2);
			boss_graphic.enableMouseClicks(false);
			add(boss_graphic);
		}
		
		override public function update():void {
			if (boss_graphic.clicks == 3) {
				super.success = true;
			}
			super.update();
		}		
	}
}