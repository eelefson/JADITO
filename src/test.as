package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FX.*;
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class test extends FlxState
	{
		[Embed(source = "image_assets/crayon_background.png")] private var background:Class;
		[Embed(source = "image_assets/crayon_dot.png")] private var dot:Class;
		[Embed(source = "image_assets/CrayonRed.png")] private var crayon:Class;
		
		public var level:FlxTilemap;
		public var player:FlxSprite;
		
		private var crayon_graphic:FlxExtendedSprite;
		private var dot_graphic:FlxExtendedSprite;
		
		private var previousPoint:FlxPoint;
		
		private var ballGroup:FlxGroup;
		
		override public function create():void {
			FlxG.bgColor = 0xffaaaaaa;
			ballGroup = new FlxGroup();
			
			crayon_graphic = new FlxExtendedSprite(0, 0, crayon);
			crayon_graphic.enableMouseDrag();
			
			dot_graphic = new FlxExtendedSprite(crayon_graphic.x + crayon_graphic.width, crayon_graphic.y + crayon_graphic.height, dot);
			previousPoint = new FlxPoint(dot_graphic.x, dot_graphic.y);
			
			add(ballGroup);
			add(crayon_graphic);
		}
		
		override public function update():void {
			super.update();
			
			dot_graphic.x = crayon_graphic.x + crayon_graphic.width;
			dot_graphic.y = crayon_graphic.y + crayon_graphic.height;

			if (crayon_graphic.isDragged) {
				var line:FlxSprite = new FlxSprite();
				line.makeGraphic(640, 430, 0x00000000);
				line.drawLine(previousPoint.x, previousPoint.y, dot_graphic.x, dot_graphic.y, 0xFFFF0000, 16);
				ballGroup.add(line);
					
				previousPoint = new FlxPoint(dot_graphic.x, dot_graphic.y);
			}
		}
		
	}

}