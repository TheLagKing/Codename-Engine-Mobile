package funkin.mobile.controls;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class HitBox extends FlxSpriteGroup
{
    public var buttonLeft:FlxButton;
    public var buttonDown:FlxButton;
    public var buttonUp:FlxButton;
    public var buttonRight:FlxButton;
    public var buttonSpace:FlxButton = null; // Initialize as null

    public function new()
    {
        super();
        buttonLeft = buttonDown = buttonUp = buttonRight = new FlxButton(0, 0);
        
        addButtons();
        scrollFactor.set();
    }

    function addButtons() {
        var hasExtraButton:Bool = Options.extrabutton == 1;
        var buttonHeight:Int = hasExtraButton ? Std.int(FlxG.height * 0.75) : FlxG.height;
        var spaceY:Int = hasExtraButton ? Std.int(FlxG.height * 0.75) : 0;

        add(buttonLeft = createHitbox(0, 0, Std.int(FlxG.width / 4), buttonHeight, '0xC24B99'));
        add(buttonDown = createHitbox(FlxG.width / 4, 0, Std.int(FlxG.width / 4), buttonHeight, '0x00FFFF'));
        add(buttonUp = createHitbox(FlxG.width / 2, 0, Std.int(FlxG.width / 4), buttonHeight, '0x12FA05'));
        add(buttonRight = createHitbox((FlxG.width / 2) + (FlxG.width / 4), 0, Std.int(FlxG.width / 4), buttonHeight, '0xF9393F'));

        if (hasExtraButton) {
            buttonSpace = createHitbox(0, spaceY, FlxG.width, Std.int(FlxG.height * 0.25), '0xFFFFFF', true);
            add(buttonSpace);
        }
    }

    function createHitbox(x:Float, y:Float, width:Int, height:Int, color:String, ?isSpace:Bool = false):FlxButton
    {
        var button = new FlxButton(x, y);
        button.makeGraphic(width, height, FlxColor.fromString(color));
        button.alpha = Options.hitboxvisibility ? (isSpace ? 0.2 : 0.1) : 0;

        button.onDown.callback = () -> {
            if (Options.hitboxvisibility) button.alpha = isSpace ? 0.2 : 0.1;
  };
        
        button.onUp.callback = () -> {
            if (Options.hitboxvisibility) button.alpha = isSpace ? 0.2 : 0.1;
        };
        
        button.onOut.callback = button.onUp.callback;

        return button;
    }

    public static function toggleExtraButton():Void {
        Options.extrabutton = Options.extrabutton == 1 ? 0 : 1;
        FlxG.resetState();
    }

    override public function destroy()
    {
        super.destroy();
        buttonLeft = buttonDown = buttonUp = buttonRight = buttonSpace = null;
    }
}
