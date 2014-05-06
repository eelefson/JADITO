package  {
	import org.flixel.FlxButton;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class DictatorDictionButton extends FlxButton {
		public var value:Array;
		
		public function DictatorDictionButton(X:Number = 0, Y:Number = 0, Label:String = null, OnClick:Function = null, value:Array = null) {
			super(X, Y, Label, OnClick);
			this.value = value;
		}
		
		override protected function onMouseUp(event:MouseEvent):void {
			if(!exists || !visible || !active || (status != PRESSED))
				return;
			if (onUp != null)
				onUp(value);
			if(soundUp != null)
				soundUp.play(true);
		}
	}

}