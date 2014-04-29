package  {
	import org.flixel.*;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class MenuState extends FlxState {
		[Embed(source = "image_assets/start-button.png")] private var ImageButton:Class // This is a sprite of the button
		
		public var start_button:FlxButton;
		
		override public function create():void {
			var title:FlxText;
			title = new FlxText(0, 16, FlxG.width, "Just Another Day In The Office");
			title.setFormat(null, 64, 0xFFFFFFFF, "center");
			add(title);
			
			start_button = new FlxButton(FlxG.width / 2, FlxG.height / 2, null, clickStartButton);
			start_button.loadGraphic(ImageButton);
			start_button.x = start_button.x - (start_button.width / 2);
			start_button.y = start_button.y - (start_button.height / 2);
			add(start_button);
			
			var instructions:FlxText;
			instructions = new FlxText(0, FlxG.height - 128, FlxG.width, "Instructions:\n" + 
				"Use the mouse throughout the game.\n");
			instructions.setFormat(null, 16, 0xFFFFFFFF, "center");
			add(instructions);
			
			super.create();
		}
		
		override public function update():void {
			super.update();
		}
		
		public function clickStartButton():void {
			//var a:Array = new Array(0, 1, 2, 3 , 4, 5, 6, 7);
			var a:Array = new Array(Minigames.MINIGAME_ZERO, Minigames.MINIGAME_ONE, Minigames.MINIGAME_ZERO, Minigames.MINIGAME_ONE, Minigames.MINIGAME_ZERO, Minigames.MINIGAME_ONE, Minigames.MINIGAME_ZERO, Minigames.MINIGAME_ONE, Minigames.MINIGAME_ZERO, Minigames.MINIGAME_ONE, Minigames.MINIGAME_ZERO, Minigames.MINIGAME_ONE);
			shuffle(a);
			var levelZeroMinigames:Array = new Array();
			
			for (var i:int = 0; i < 10; i++) {
				levelZeroMinigames[i] = a[i];
			}
			
			var minigames:Array = new Array(levelZeroMinigames, new Array(), new Array(), new Array());
			Registry.day = -1;
			Registry.pool = new Array();
			Registry.taskStatuses = new Array();
			FlxG.switchState(new PlayState(minigames));
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