package funkin.mobile.controls;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

class HitBox extends FlxSpriteGroup
{
    public var buttonLeft:FlxButton;
    public var buttonDown:FlxButton;
    public var buttonUp:FlxButton;
    public var buttonRight:FlxButton;
    public var buttonSpace:FlxButton;

    public function new()
    {
        super();
        buttonLeft = buttonDown = buttonUp = buttonRight = buttonSpace = new FlxButton(0, 0);
        
        addButtons();
        scrollFactor.set();
    }

    function addButtons() {
        var buttonHeight:Int = Options.extrabutton ? Std.int(FlxG.height * 0.75) : FlxG.height;
        var offsetFir:Int = Options.extrabutton ? Std.int(FlxG.height * 0.75) : 0;

        // Directional buttons (3/4 height if extra button enabled, full height if not)
        add(buttonLeft = createHitbox(0, 0, Std.int(FlxG.width / 4), buttonHeight, FlxColor.fromString('0xC24B99')));
        add(buttonDown = createHitbox(FlxG.width / 4, 0, Std.int(FlxG.width / 4), buttonHeight, FlxColor.fromString('0x00FFFF')));
        add(buttonUp = createHitbox(FlxG.width / 2, 0, Std.int(FlxG.width / 4), buttonHeight, FlxColor.fromString('0x12FA05')));
        add(buttonRight = createHitbox((FlxG.width / 2) + (FlxG.width / 4), 0, Std.int(FlxG.width / 4), buttonHeight, FlxColor.fromString('0xF9393F')));

        // Extra button (only if enabled)
        if (Options.extrabutton) {
            add(buttonSpace = createHitbox(0, offsetFir, FlxG.width, Std.int(FlxG.height * 0.25), FlxColor.fromString('0x7700FF'), true));
        }
    }

    function createHitbox(x:Float, y:Float, width:Int, height:Int, color:FlxColor, ?isSpace:Bool = false)
    {
        var button:FlxButton = new FlxButton(x, y);
        button.makeGraphic(width, height, color);
        button.alpha = Options.hitboxvisibility ? (isSpace ? 0.2 : 0.1) : 0;

        button.onDown.callback = () -> {
            if (Options.hitboxvisibility) button.alpha = isSpace ? 0.25 : 0.15;
        };
        button.onUp.callback = () -> {
            if (Options.hitboxvisibility) button.alpha = isSpace ? 0.2 : 0.1;
        };
        button.onOut.callback = button.onUp.callback;

        return button;
    }

    override public function destroy()
    {
        super.destroy();
        buttonLeft = buttonDown = buttonUp = buttonRight = buttonSpace = null;
    }
}