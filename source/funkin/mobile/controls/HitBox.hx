package funkin.mobile.controls;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import funkin.options.Options;

class HitBox extends FlxSpriteGroup
{
    public var buttonLeft:FlxButton;
    public var buttonDown:FlxButton;
    public var buttonUp:FlxButton;
    public var buttonRight:FlxButton;

    public static final DEFAULT_ALPHA:Float = 0.15;
    public static final PRESSED_ALPHA:Float = 0.1;
    
    public function new()
    {
        super();
        buttonLeft = buttonDown = buttonUp = buttonRight = new FlxButton(0, 0);
        
        addButtons();
        scrollFactor.set();

        updateHitboxVisibility();
    }
    
    public function updateHitboxVisibility() {
        var alphaValue:Float = Options.hitboxvisibility ? DEFAULT_ALPHA : 0;
        var pressedAlphaValue:Float = Options.hitboxvisibility ? PRESSED_ALPHA : 0;
        
        buttonLeft.alpha = alphaValue;
        buttonDown.alpha = alphaValue;
        buttonUp.alpha = alphaValue;
        buttonRight.alpha = alphaValue;
        
        // Update the pressed state alphas as well
        buttonLeft.onDown.callback = () -> buttonLeft.alpha = pressedAlphaValue;
        buttonDown.onDown.callback = () -> buttonDown.alpha = pressedAlphaValue;
        buttonUp.onDown.callback = () -> buttonUp.alpha = pressedAlphaValue;
        buttonRight.onDown.callback = () -> buttonRight.alpha = pressedAlphaValue;
        
        buttonLeft.onUp.callback = buttonLeft.onOut.callback = () -> buttonLeft.alpha = alphaValue;
        buttonDown.onUp.callback = buttonDown.onOut.callback = () -> buttonDown.alpha = alphaValue;
        buttonUp.onUp.callback = buttonUp.onOut.callback = () -> buttonUp.alpha = alphaValue;
        buttonRight.onUp.callback = buttonRight.onOut.callback = () -> buttonRight.alpha = alphaValue;
    }

    function addButtons() {
        var x:Int = 0;
        var y:Int = 0;

        add(buttonLeft = createHitbox(x, y, Std.int(FlxG.width / 4), FlxG.height, '0xC24B99'));
        add(buttonDown = createHitbox(FlxG.width / 4, y, Std.int(FlxG.width / 4), FlxG.height, '0x00FFFF'));
        add(buttonUp = createHitbox(FlxG.width / 2, y, Std.int(FlxG.width / 4), FlxG.height, '0x12FA05'));
        add(buttonRight = createHitbox(FlxG.width * 3 / 4, y, Std.int(FlxG.width / 4), FlxG.height, '0xF9393F'));
    }

    function createHitbox(x:Float, y:Float, width:Int, height:Int, color:String)
    {
        var button:FlxButton = new FlxButton(x, y);
        button.makeGraphic(width, height, FlxColor.fromString(color));
        button.alpha = Options.hitboxvisibility ? DEFAULT_ALPHA : 0;
        
        button.onDown.callback = () -> button.alpha = Options.hitboxvisibility ? PRESSED_ALPHA : 0;
        button.onUp.callback = () -> button.alpha = Options.hitboxvisibility ? DEFAULT_ALPHA : 0;
        button.onOut.callback = button.onUp.callback;

        return button;
    }

    override public function destroy()
    {
        super.destroy();
        buttonLeft = buttonDown = buttonUp = buttonRight = null;
    }
}
