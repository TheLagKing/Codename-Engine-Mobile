package funkin.mobile.controls;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

/**
 * ...
 * @author Idklool
 */
class HitBox extends FlxSpriteGroup
{
    public var buttonLeft:FlxButton;
    public var buttonDown:FlxButton;
    public var buttonUp:FlxButton;
    public var buttonRight:FlxButton;

    public function new()
    {
        super();
        buttonLeft = buttonDown = buttonUp = buttonRight = new FlxButton(0, 0);
        
        addButtons();
        scrollFactor.set();
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
        button.alpha = 0.1;

        button.onDown.callback = () -> button.alpha = 0.15;
        button.onUp.callback = () -> button.alpha = 0.1;
        button.onOut.callback = button.onUp.callback;

        return button;
    }

    override public function destroy()
    {
        super.destroy();
        buttonLeft = buttonDown = buttonUp = buttonRight = null;
    }
}