package  
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Spellchecker extends MinigameState
	{
		public static var level:Number = Registry.difficultyLevel; // The level of the game's difficulty
		
		override public function create():void
		{
			FlxG.bgColor = 0xffaaaaaa;
			
			var url:URLRequest = new URLRequest("../src/spellchecker.txt");
			
			var loader:URLLoader = new URLLoader();
			
			loader.addEventListener(Event.COMPLETE, loaderComplete);
			
			function loaderComplete(e:Event):void
			{
				var data:String = loader.data;
				var paragraph:Array = data.split(" ");
				
				var x:int = 0;
				var y:int = 0;
				
				for (var i:int; i < paragraph.length; i++) {
					var word:String = paragraph[i];
					
					var text:SpellText = new SpellText(x, y, FlxG.width, word);
					
					if (x + text.getRealWidth() > 200) {
						text.x = 0;
						text.y = y = y + 20;
						x = 0;
					} 
					x += text.getRealWidth() + 5;
					
					add(text);
				}
			}
			
			loader.load(url);
		}
		
	}

}