package  {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
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
			
			start_button = new FlxButton(FlxG.width / 2, FlxG.height / 2, "Start Button", clickStartButton);
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
			FlxG.switchState(new PlayState());
			//FlxG.switchState(new MDAP());
		}
	}

}