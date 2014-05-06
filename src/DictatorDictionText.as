package  {
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class DictatorDictionText extends FlxText {
		
		public function DictatorDictionText(X:Number, Y:Number, Width:uint, Text:String = null, EmbeddedFont:Boolean = true) {
			super(X, Y, Width, Text, EmbeddedFont);	
		}
		
		public function getRealWidth():int {
			return _textField.textWidth; 
		}
	}

}