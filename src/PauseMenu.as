package {

    import org.flixel.*;
    
    public class PauseMenu extends FlxGroup {
        
        /**
	 *An array with the strings of the pause menu options
	*/
	public var pauseMenuOptions:Array;
	/**
	 *The background taht appears when the mouse is above the pause options
	*/
	public var pauseMenuOptionsBackground:FlxSprite;
	/**
	 *The group that holds the FlxTexts instances from the pause menu.
	*/
	public var pauseMenuOptionsGroup:FlxGroup;
	/**
	 *Use to show the pauseMenuOptionsBackground.
	*/
	public var pauseMenuOptionsArea:FlxRect;
        
        public var xPauseMenuGroup:Number;
        public var yPauseMenuGroup:Number;
        
        public var widthPauseMenu:Number;
        public var heightPauseMenu:Number;
        
        public function PauseMenu(xPauseMenuGroup:Number, yPauseMenuGroup:Number) {
            super();
            this.xPauseMenuGroup = xPauseMenuGroup;
            this.yPauseMenuGroup = yPauseMenuGroup;
            this.alive = false;
            this.exists = false;
            widthPauseMenu = 120;
	    heightPauseMenu = 90;
            initPauseMenuBackground();
            initTitlePauseMenu();
            initOptionsPauseMenu();
        }
        
        public function hide():void {
            this.alive = false;
            this.exists = false;
            FlxG.mouse.hide();
        }
        
        public function show():void {
            this.alive = true;
            this.exists = true;
            FlxG.mouse.show();
        }
        
        public function initOptionsPauseMenu():void {
            pauseMenuOptions = new Array();
	    pauseMenuOptions.push("RESUME");
	    pauseMenuOptions.push("BACK TO MENU");
	    pauseMenuOptionsGroup = new FlxGroup();
            
            var xMenuOptions:Number = widthPauseMenu - 80;
            var yMenuOptions:Number = 30;
            
            pauseMenuOptionsBackground = new FlxSprite(xMenuOptions, yMenuOptions + 1).makeGraphic(80, 11, 0xffe06000);
            pauseMenuOptionsBackground.scrollFactor.x = pauseMenuOptionsBackground.scrollFactor.y = 0;
            pauseMenuOptionsBackground.visible = false;
            
            for each(var pauseMenuOption:String in pauseMenuOptions) {
                var txt:FlxText = new FlxText(xMenuOptions, yMenuOptions, 120, pauseMenuOption);
                txt.scrollFactor.x = txt.scrollFactor.y = 0;
                txt.shadow = 0xff000000;
                pauseMenuOptionsGroup.add(txt);
                yMenuOptions += 12;
            }
            
            pauseMenuOptionsArea = new FlxRect(xMenuOptions, 30, 120, yMenuOptions - 30);
            
            add(pauseMenuOptionsBackground);
            add(pauseMenuOptionsGroup);
            
        }
        
        public function initTitlePauseMenu():void {
            var xTitle:Number = xPauseMenuGroup + 5;
	    var yTitle:Number = yPauseMenuGroup + 5;
	    var txtTitlePauseMenu:FlxText = new FlxText(xTitle, yTitle, widthPauseMenu, "PAUSED");
            txtTitlePauseMenu.alignment = 'center';
	    txtTitlePauseMenu.scrollFactor.x = txtTitlePauseMenu.scrollFactor.y = 0;
	    add(txtTitlePauseMenu);
        }
        
        public function initPauseMenuBackground():void {
            var pauseMenuGroupBackground:FlxSprite = new FlxSprite(xPauseMenuGroup,
		yPauseMenuGroup).makeGraphic(widthPauseMenu, heightPauseMenu, 0xff000000);
	    pauseMenuGroupBackground.scrollFactor.x = 0;
	    pauseMenuGroupBackground.scrollFactor.y = 0;
	    add(pauseMenuGroupBackground);
        }
        
        public function pointInFlxRect(pointX:int, pointY:int, rect:FlxRect):Boolean {
            return pointX >= rect.x && pointX <= rect.right && pointY >= rect.y && pointY <= rect.bottom
        }
        
        public function pauseMenuOptionClick(id:int):void {
            FlxG.paused = false;
            hide();
            if (id == 1) {
                FlxG.switchState(new MenuState());
            }
        }
        
        override public function update():void {
            if (pointInFlxRect(FlxG.mouse.screenX, FlxG.mouse.screenY, pauseMenuOptionsArea)) {
                //get which option is bellow the mouse
                var mx:int = (FlxG.mouse.screenY - pauseMenuOptionsArea.top) / 12;
                if (pauseMenuOptionsGroup.members[mx]) {
                    pauseMenuOptionsBackground.y = pauseMenuOptionsGroup.members[mx].y + 2;
                    pauseMenuOptionsBackground.visible = true;
                }
                
                if (FlxG.mouse.justReleased()) {
                    pauseMenuOptionClick(mx);
                }
                
            } else {
                pauseMenuOptionsBackground.visible = false;
            }
        }
        
    }

}