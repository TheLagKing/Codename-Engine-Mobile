package funkin.mobile.backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import funkin.backend.assets.Paths;

#if mobile
import flixel.input.touch.FlxTouch;
#end

/**
 * Class to manage the pause button on mobile devices
 * Implements singleton pattern to ensure only one instance exists
 * Class methods are static for easy access on any states if needed
 * @author Dechis
 */
class PauseButtonManager 
{
    private static var instance:PauseButtonManager;
    private var pauseButton:FlxSprite;
    private var isVisible:Bool = false;
    private var onClickCallback:Void->Void;
    
    public static function getInstance():PauseButtonManager 
    {
        if (instance == null) 
        {
            instance = new PauseButtonManager();
        }
        return instance;
    }
    
    private function new() 
    {
    }
    
    /**
     * Main function to show the pause button on mobile devices
	 * @param camera - Camera where the button will be displayed
     * @param parent - Group where the button will be added (optional)
     * @param onClick - Callback for when the button is clicked (optional)
     */
    public static function showPauseButtonOnCamera(camera:flixel.FlxCamera, ?parent:FlxGroup, ?onClick:Void->Void):Void 
    {
        #if mobile
        var manager = getInstance();
        
        manager.pauseButton = new FlxSprite().loadAnimatedGraphic(Paths.image('game/pauseButton'));
        manager.pauseButton.antialiasing = true;
        manager.pauseButton.scrollFactor.set();
        manager.pauseButton.alpha = 0.7;
        manager.pauseButton.scale.set(0.9, 0.9);
        manager.pauseButton.updateHitbox();
        
        manager.pauseButton.animation.add("idle", [0, 1, 2, 3, 4, 5], 6, true);
        manager.pauseButton.animation.add("hover", [6, 7, 8, 9, 10], 8, false);
        manager.pauseButton.animation.add("pressed", [11, 12, 13, 14, 15, 16, 17, 18, 19], 12, false);
        manager.pauseButton.animation.add("return", [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32], 10, false);
        
        manager.pauseButton.x = FlxG.width - manager.pauseButton.width - 20;
        manager.pauseButton.y = 20;
        
        manager.pauseButton.animation.play("idle");
        
        manager.pauseButton.cameras = [camera];
        
        manager.onClickCallback = onClick;
        
        if (parent != null) 
        {
            parent.add(manager.pauseButton);
        }
        else 
        {
            FlxG.state.add(manager.pauseButton);
        }
        
        manager.isVisible = true;
        
        trace("Button added");
        #else
        trace("Button only available on mobile");
        #end
    }
    
    public static function hidePauseButton():Void 
    {
        #if mobile
        var manager = getInstance();
        
        if (manager.pauseButton != null && manager.isVisible) 
        {
            manager.pauseButton.destroy();
            manager.pauseButton = null;
            manager.onClickCallback = null;
            manager.isVisible = false;
            trace("Pause button removed");
        }
        #end
    }

    public static function isButtonVisible():Bool 
    {
        #if mobile
        return getInstance().isVisible;
        #else
        return false;
        #end
    }
    
    public static function updatePosition():Void 
    {
        #if mobile
        var manager = getInstance();
        if (manager.pauseButton != null && manager.isVisible) 
        {
            manager.pauseButton.x = FlxG.width - manager.pauseButton.width - 20;
            manager.pauseButton.y = 20;
        }
        #end
    }
    
    public static function update():Void 
    {
        #if mobile
        var manager = getInstance();
        
        if (manager.pauseButton != null && manager.isVisible) 
        {
            var justPressed = false;
            
			for (touch in FlxG.touches.list)
			{
				var touchPos = touch.getWorldPosition(manager.pauseButton.cameras[0]); 
				if (touch.justPressed && manager.pauseButton.overlapsPoint(touchPos, true, manager.pauseButton.cameras[0]))
				{
					justPressed = true;
					break;
				}
			}
            
            if (justPressed) 
            {
                manager.pauseButton.animation.play('pressed');
                
                if (manager.onClickCallback != null) 
                {
                    manager.onClickCallback();
                }
            }
        }
        #end
    }
}