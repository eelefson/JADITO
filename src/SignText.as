package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class SignText extends FlxText
	{	
		public function SignText(X:Number, Y:Number, Width:uint, Text:String=null)
		{
			super(X, Y, Width, Text);
		}
		
		public function getRealWidth():int
		{
			return this._textField.textWidth;
		}
	}
}