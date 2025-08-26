package funkin.mobile.controls;

import openfl.display.BitmapData;
import openfl.display.Shape;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.tweens.FlxTween;
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
    public var buttonExtra:FlxButton;
    public var buttonExtraTwo:FlxButton;

    public function new()
    {
        super();
        buttonLeft = buttonDown = buttonUp = buttonRight = buttonExtra = buttonExtraTwo = new FlxButton(0, 0);
        
        addButtons();
        scrollFactor.set();
    }

    function addButtons() {
        var hasExtraButton:Bool = Options.extrabutton >= 1;
        var hasSecondExtraButton:Bool = Options.extrabutton == 2;
        
        var buttonHeight:Int = hasExtraButton ? (Options.extrabuttontop ? Std.int(FlxG.height * 0.75 / 0.4) : Std.int(FlxG.height * 0.75)) : FlxG.height;
        var extraY:Int = hasExtraButton ? (Options.extrabuttontop ? Std.int(FlxG.height * 0.75 / 240) : Std.int(FlxG.height * 0.75)) : 0;
        var extraHeight:Int = Std.int(FlxG.height * 0.25);
        
        var x:Int = 0;
        var y:Int = 0;

        add(buttonLeft = createHitbox(x, y, Std.int(FlxG.width / 4), buttonHeight, '0xC24B99'));
        add(buttonDown = createHitbox(FlxG.width / 4, y, Std.int(FlxG.width / 4), buttonHeight, '0x00FFFF'));
        add(buttonUp = createHitbox(FlxG.width / 2, y, Std.int(FlxG.width / 4), buttonHeight, '0x12FA05'));
        add(buttonRight = createHitbox(FlxG.width * 3 / 4, y, Std.int(FlxG.width / 4), buttonHeight, '0xF9393F'));
        
        if (hasExtraButton) {
            if (hasSecondExtraButton) {
                // First extra button (left half of extra space)
                buttonExtra = createHitbox(0, extraY, Std.int(FlxG.width / 2), extraHeight, '0xFFFFFF', true);
                add(buttonExtra);
                
                // Second extra button (right half of extra space)
                buttonExtraTwo = createHitbox(FlxG.width / 2, extraY, Std.int(FlxG.width / 2), extraHeight, '0xFFFF00', true);
                add(buttonExtraTwo);
            } else {
                // Single extra button (full extra space)
                buttonExtra = createHitbox(0, extraY, FlxG.width, extraHeight, '0xFFFFFF', true);
                add(buttonExtra);
            }
        }
    }

function createHitbox(x:Float, y:Float, width:Int, height:Int, color:String, ?isExtra:Bool = false)
{
    var button:FlxButton = new FlxButton(x, y);
    button.loadGraphic(createHitboxGraphic(width, height));
    button.color = FlxColor.fromString(color);
    button.alpha = Options.hitboxvisibility ? (isExtra ? 0.2 : 0.1) : 0;

    if (Options.hitboxvisibility) {
    var buttonTween:FlxTween = null;
    button.onDown.callback = function()
        {
            if (buttonTween != null)
                buttonTween.cancel();

            buttonTween = FlxTween.tween(button, {alpha: 0.65}, 0.65 / 100, {
                ease: FlxEase.circInOut,
                onComplete: function(twn:FlxTween) {
                    buttonTween = null;
                }
            });
        }
    button.onUp.callback = function()
        {
            if (buttonTween != null)
                buttonTween.cancel();

            var targetAlpha:Float = isExtra ? 0.2 : 0.1;
            buttonTween = FlxTween.tween(button, {alpha: targetAlpha}, 0.65 / 10, {
                ease: FlxEase.circInOut,
                onComplete: function(twn:FlxTween) {
                    buttonTween = null;
                }
            });
        }
    button.onOut.callback = button.onUp.callback;
    }

    return button;
}
    
    function createHitboxGraphic(Width:Int, Height:Int):FlxGraphic
    {
        var shape:Shape = new Shape();
        shape.graphics.beginFill(0xFFFFFF);
        
        shape.graphics.lineStyle(3, 0xFFFFFF, 1);
        shape.graphics.drawRect(0, 0, Width, Height);
        shape.graphics.lineStyle(0, 0, 0);
        shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
        shape.graphics.endFill();
        shape.graphics.beginGradientFill(RADIAL, [0xFFFFFF, FlxColor.TRANSPARENT], [1, 0], [0, 255], null, null, null, 0.5);
        shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
        shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
        bitmap.draw(shape);

        return FlxG.bitmap.add(bitmap);
    }

    public static function toggleExtraButton():Void {
        Options.extrabutton = (Options.extrabutton + 1) % 3; // Cycles through 0, 1, 2
        FlxG.resetState();
    }
    
    override public function destroy()
    {
        super.destroy();
        buttonLeft = buttonDown = buttonUp = buttonRight = buttonExtra = buttonExtraTwo = null;
    }
}
