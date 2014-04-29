package  {
	import org.flixel.*;	
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class Minigame_ZERO extends MinigameState {
		[Embed(source = "image_assets/angry-boss.jpg")] private var BossImage:Class;
		
		private var boss_graphic:FlxSprite;
		
		public function Minigame_ZERO(minigames:Array, level:uint) {
			super(minigames, level);
		}
		
		override public function create():void {
			super.create();
			
			boss_graphic = new FlxSprite(FlxG.width / 2, FlxG.height / 2, BossImage);	
			boss_graphic.x = boss_graphic.x - (boss_graphic.width / 2);
			boss_graphic.y = boss_graphic.y - (boss_graphic.height / 2);
			add(boss_graphic);
		}
	}
}