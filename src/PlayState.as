package {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class PlayState extends FlxState {
		[Embed(source = "image_assets/Clipboard_Background.png")] private var ClipboardImage:Class;
		[Embed(source="image_assets/box.jpg")] private var BlackBoxImage:Class;
		[Embed(source = "image_assets/checkmark.png")] private var CheckMarkImage:Class;
		
		private var clipboard_graphic:FlxSprite;
		private var box_graphic:FlxSprite;
		private var check_graphic:FlxSprite;
		
		private var checkBoxes:FlxGroup = new FlxGroup();
		
		public var topWall:FlxTileblock;
		public var bottomWall:FlxTileblock;
		public var leftWall:FlxTileblock;
		public var rightWall:FlxTileblock;
		
		override public function create():void {
			FlxG.bgColor = 0xffffffff;
			
			clipboard_graphic = new FlxSprite(FlxG.width / 2, FlxG.height / 2, ClipboardImage);
			
			clipboard_graphic.x = clipboard_graphic.x - (clipboard_graphic.width / 2);
			clipboard_graphic.y = clipboard_graphic.y - (clipboard_graphic.height / 2);
			add(clipboard_graphic);
			
			var x:int = clipboard_graphic.x + 79;
			var y:int = clipboard_graphic.y + 115;
			// ROWS
			for (var i:int = 0; i < 4; i++) {
				// COLUMNS
				for (var j:int = 0; j < 3; j++) {
					box_graphic = new FlxSprite(x + (100*j), y + (100*i), BlackBoxImage);
					checkBoxes.add(box_graphic);
				}
			}
			add(checkBoxes);
			
			for (var k:int = 0; k < checkBoxes.length; k++) {
				var box:FlxSprite = checkBoxes.members[k];
				check_graphic = new FlxSprite(box.x + 3, box.y - 10, CheckMarkImage);
				add(check_graphic);
			}
			
			topWall = new FlxTileblock(0, 0, FlxG.width, 2);
			topWall.makeGraphic(FlxG.width, 2, 0xff000000);
			add(topWall);
			
			bottomWall = new FlxTileblock(0, FlxG.height - 2, FlxG.width, 2);
			bottomWall.makeGraphic(FlxG.width, 2, 0xff000000);
			add(bottomWall);
			
			leftWall = new FlxTileblock(0, 0, 2, FlxG.height);
			leftWall.makeGraphic(2, FlxG.height, 0xff000000);
			add(leftWall);
			
			rightWall = new FlxTileblock(FlxG.width - 2, 0, 2, FlxG.height);
			rightWall.makeGraphic(2, FlxG.height, 0xff000000);
			add(rightWall);
			
			super.create();
		}
		
		override public function update():void {
			
		}
	}
}