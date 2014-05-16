package  {
	import org.flixel.*;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class BorderedText extends FlxText {
		
		public function BorderedText(X:Number, Y:Number, Width:uint, Text:String=null, EmbeddedFont:Boolean=true) {
			super(X, Y, Width, Text, EmbeddedFont);
		}
		
				/**
		 * Internal function to update the current animation frame.
		 */
		override protected function calcFrame():void
		{
			if(_regen)
			{
				//Need to generate a new buffer to store the text graphic
				var i:uint = 0;
				var nl:uint = _textField.numLines;
				height = 0;
				while(i < nl)
					height += _textField.getLineMetrics(i++).height;
				height += 4; //account for 2px gutter on top and bottom
				_pixels = new BitmapData(width,height,true,0);
				frameHeight = height;
				_textField.height = height*1.2;
				_flashRect.x = 0;
				_flashRect.y = 0;
				_flashRect.width = width;
				_flashRect.height = height;
				_regen = false;
			}
			else	//Else just clear the old buffer before redrawing the text
				_pixels.fillRect(_flashRect,0);
			
			if((_textField != null) && (_textField.text != null) && (_textField.text.length > 0))
			{
				//Now that we've cleared a buffer, we need to actually render the text to it
				var format:TextFormat = _textField.defaultTextFormat;
				var formatAdjusted:TextFormat = format;
				_matrix.identity();
				//If it's a single, centered line of text, we center it ourselves so it doesn't blur to hell
				if((format.align == "center") && (_textField.numLines == 1))
				{
					formatAdjusted = new TextFormat(format.font,format.size,format.color,null,null,null,null,null,"left");
					_textField.setTextFormat(formatAdjusted);				
					_matrix.translate(Math.floor((width - _textField.getLineMetrics(0).width)/2),0);
				}
				//Render a single pixel shadow beneath the text
				if(_shadow > 0)
				{
					var n:int = 2;
					
					if (_shadow == 10) {
						n = 1;
					}
					
					if (_shadow == 30) {
						n = 4;
					}
					// WERE ORIGINALLY ALL 1's, changed to 3s to increased border width
					_textField.setTextFormat(new TextFormat(formatAdjusted.font,formatAdjusted.size,_shadow,null,null,null,null,null,formatAdjusted.align));                
					_matrix.translate(n, n);
					_pixels.draw(_textField, _matrix, _colorTransform);
					_matrix.translate(0, -n);
					_pixels.draw(_textField, _matrix, _colorTransform);
					_matrix.translate(0, -n);
					_pixels.draw(_textField, _matrix, _colorTransform);
					_matrix.translate( -n, 0);
					_pixels.draw(_textField, _matrix, _colorTransform);
					_matrix.translate(-n, 0);
					_pixels.draw(_textField, _matrix, _colorTransform);
					_matrix.translate(0, n);
					_pixels.draw(_textField, _matrix, _colorTransform);
					_matrix.translate(0, n);
					_pixels.draw(_textField, _matrix, _colorTransform);
					_matrix.translate(n, 0);
					_pixels.draw(_textField, _matrix, _colorTransform);

					_matrix.translate(0,-n);
					_textField.setTextFormat(new TextFormat(formatAdjusted.font,formatAdjusted.size,formatAdjusted.color,null,null,null,null,null,formatAdjusted.align));
				}
				//Actually draw the text onto the buffer
				_pixels.draw(_textField,_matrix,_colorTransform);
				_textField.setTextFormat(new TextFormat(format.font,format.size,format.color,null,null,null,null,null,format.align));
			}
			
			//Finally, update the visible pixels
			if((framePixels == null) || (framePixels.width != _pixels.width) || (framePixels.height != _pixels.height))
				framePixels = new BitmapData(_pixels.width,_pixels.height,true,0);
			framePixels.copyPixels(_pixels,_flashRect,_flashPointZero);
		}
	}

}