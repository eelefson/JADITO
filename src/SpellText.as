package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class SpellText extends FlxText
	{
		public var misspelled:Boolean;
		public var correct:String;
		
		public function SpellText(X:Number, Y:Number, Width:uint, Text:String=null, Miss:Boolean=false, C:String="")
		{
			super(X, Y, Width, Text);
			correct = C;
			misspelled = Miss;
		}
		
		public function getRealWidth():int
		{
			return this._textField.textWidth;
		}
		
		override public function update():void {
			if (FlxG.mouse.justReleased() && FlxG.mouse.screenX >= this.x && FlxG.mouse.screenX <= this.x + this.width &&
				FlxG.mouse.screenY >= this.y && FlxG.mouse.screenY <= this.y + this.height) {
					
					if (misspelled) {
						this.text = correct;
						this.size = Spellchecker.TEXT_SIZE - 5;
						this.color = 0x00FF0000;
						Spellchecker.numTypos--;
						misspelled = !misspelled;
					} else {
						Spellchecker.hasFailed = true;
					}
					
				}
			
				if (Spellchecker.hasFailed) {
					if (misspelled) {
						this.color = 0x00FF0000;
					} else {
						this.text = "";
					}
				}
				
			super.update();
		}
		
	}

}