package funkin.mobile.controls;
// start diggin in yo 
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import openfl.display.Shape;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
/*
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
        
        var gradientHeight:Int = Std.int(height * 0.1); // Height of gradient area
        var baseColor:FlxColor = FlxColor.fromString(color);
        
        var shape = new Shape();
        
        shape.graphics.beginFill(baseColor, 0.1);
        shape.graphics.drawRect(0, 0, width, height);
        shape.graphics.endFill();
        
        var matrix = new Matrix();
        matrix.createGradientBox(width, gradientHeight, Math.PI/2, 0, 0);
        shape.graphics.beginGradientFill(LINEAR, [baseColor, baseColor], [0.3, 0], [0, 255], matrix);
        shape.graphics.drawRect(0, 0, width, gradientHeight);
        shape.graphics.endFill();
        
        matrix.createGradientBox(width, gradientHeight, Math.PI/2, 0, height - gradientHeight);
        shape.graphics.beginGradientFill(LINEAR, [baseColor, baseColor], [0, 0.3], [0, 255], matrix);
        shape.graphics.drawRect(0, height - gradientHeight, width, gradientHeight);
        shape.graphics.endFill();
        
        var graphic = new BitmapData(width, height, true, 0);
        graphic.draw(shape);
        button.loadGraphic(graphic);
        
        button.onDown.callback = () -> {
            button.alpha = 0.15;
        };
        
        button.onUp.callback = () -> {
            button.alpha = 0.1;
        };
        
        button.onOut.callback = button.onUp.callback;

        return button;
    }

    override public function destroy()
    {
        super.destroy();
        buttonLeft = buttonDown = buttonUp = buttonRight = null;
    }
}
