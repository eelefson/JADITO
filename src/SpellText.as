package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class SpellText extends FlxText
	{
		public var misspelled:Boolean;
		public var correct:String;
		
		public var minigame_super:Spellchecker;
		
		public function SpellText(sup:Spellchecker, X:Number, Y:Number, Width:uint, Text:String=null, Miss:Boolean=false, C:String="")
		{
			super(X, Y, Width, Text);
			minigame_super = sup;
			correct = C;
			misspelled = Miss;
		}
		
		public function getRealWidth():int
		{
			return this._textField.textWidth;
		}
		
		override public function update():void {
			if (FlxG.mouse.justReleased() && FlxG.mouse.screenX >= this.x && FlxG.mouse.screenX <= this.x + this._textField.textWidth &&
				FlxG.mouse.screenY >= this.y && FlxG.mouse.screenY <= this.y + this.height - 5 ) {
					
					if (misspelled) {
						this.text = correct;
						this.size = minigame_super.TEXT_SIZE - 5;
						this.color = 0x00009933;
						minigame_super.numTypos--;
					} else {
						minigame_super.hasFailed = true;
					}
					
				}
				
			if (FlxG.mouse.screenX >= this.x && FlxG.mouse.screenX <= this.x + this._textField.textWidth &&
				FlxG.mouse.screenY >= this.y && FlxG.mouse.screenY <= this.y + this.height - 5 && this.text != correct && !minigame_super.hasFailed) {
					this.color = 0xFFFFFFFF;
				} else if (this.text != correct && !minigame_super.hasFailed) {
					this.color = 0xFF000000;
				}
				
				/*if (FlxG.mouse.justReleased() && FlxG.mouse.screenX >= this.x && FlxG.mouse.screenX <= this.x + this._textField.textWidth &&
				FlxG.mouse.screenY >= this.y && FlxG.mouse.screenY <= this.y + this.height && misspelled) {
					corrected = true;
					this.text = correct;
					this.size = Spellchecker.TEXT_SIZE - 5;
					this.color = 0x00FF0000;
					Spellchecker.numTypos--;
				}
				
				if (FlxG.mouse.justReleased() && FlxG.mouse.screenX >= this.x && FlxG.mouse.screenX <= this.x + getRealWidth &&
				FlxG.mouse.screenY >= this.y && FlxG.mouse.screenY <= this.y + this.height && !misspelled) {
					
					Spellchecker.hasFailed = true;
					trace(this.text + " " + misspelled);
					
				}*/

				if (minigame_super.hasFailed) {
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