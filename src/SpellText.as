package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class SpellText extends FlxText
	{
		
		public function SpellText(X:Number, Y:Number, Width:uint, Text:String=null, EmbeddedFont:Boolean=true)
		{
			super(X, Y, Width, Text, EmbeddedFont);
		}
		
		public function getRealWidth():int
		{
			return this._textField.textWidth;
		}
		
	}

}