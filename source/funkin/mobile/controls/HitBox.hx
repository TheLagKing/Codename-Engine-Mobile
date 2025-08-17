package funkin.mobile.controls;

import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.GradientType;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

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
	
	// Variables for the fade effect
	private var topFade:FlxSprite;
	private var bottomFade:FlxSprite;
	private var fadeTween:FlxTween;

    public function new()
    {
        super();
        buttonLeft = buttonDown = buttonUp = buttonRight = new FlxButton(0, 0);
        
        // Create fade sprites
        createFadeSprites();
        addButtons();
        scrollFactor.set();
    }
	
	function createFadeSprites() {
		// Create top fade
		topFade = new FlxSprite();
		topFade.makeGraphic(FlxG.width, 50, FlxColor.TRANSPARENT, true);
		topFade.pixels.lock();
		for (y in 0...50) {
			var alpha = Std.int(0.5 * 255 * (1 - y/50));
			var color = FlxColor.fromRGB(0, 0, 0, alpha);
			for (x in 0...FlxG.width) {
				topFade.pixels.setPixel32(x, y, color);
			}
		}
		topFade.pixels.unlock();
		topFade.dirty = true;
		topFade.alpha = 0;
		topFade.y = 0;
		
		// Create bottom fade
		bottomFade = new FlxSprite();
		bottomFade.makeGraphic(FlxG.width, 50, FlxColor.TRANSPARENT, true);
		bottomFade.pixels.lock();
		for (y in 0...50) {
			var alpha = Std.int(0.5 * 255 * (y/50));
			var color = FlxColor.fromRGB(0, 0, 0, alpha);
			for (x in 0...FlxG.width) {
				bottomFade.pixels.setPixel32(x, y, color);
			}
		}
		bottomFade.pixels.unlock();
		bottomFade.dirty = true;
		bottomFade.alpha = 0;
		bottomFade.y = FlxG.height - 50;
		
		// Add them to the group
		add(topFade);
		add(bottomFade);
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
        button.loadGraphic(createHitboxGraphic(width, height));
        button.color = FlxColor.fromString(color);
        button.alpha = 0.1;

		var buttonTween:FlxTween = null;
        button.onDown.callback = function()
			{
				if (buttonTween != null)
					buttonTween.cancel();

				buttonTween = FlxTween.tween(button, {alpha: 0.65}, 0.65 / 100, {
					ease: FlxEase.circInOut,
					onComplete: (twn:FlxTween) -> buttonTween = null
				});
				
				// Hide fades when button is pressed
				if (fadeTween != null) fadeTween.cancel();
				fadeTween = FlxTween.tween(topFade, {alpha: 0}, 0.2);
				fadeTween = FlxTween.tween(bottomFade, {alpha: 0}, 0.2);
			}
        button.onUp.callback = function()
			{
				if (buttonTween != null)
					buttonTween.cancel();

				buttonTween = FlxTween.tween(button, {alpha: 0.1}, 0.65 / 10, {
					ease: FlxEase.circInOut,
					onComplete: (twn:FlxTween) -> buttonTween = null
				});
				
				// Show fades when button is released
				if (fadeTween != null) fadeTween.cancel();
				fadeTween = FlxTween.tween(topFade, {alpha: 1}, 0.2);
				fadeTween = FlxTween.tween(bottomFade, {alpha: 1}, 0.2, {
					onComplete: function(twn:FlxTween) {
						fadeTween = FlxTween.tween(topFade, {alpha: 0}, 0.5, {startDelay: 0.5});
						fadeTween = FlxTween.tween(bottomFade, {alpha: 0}, 0.5, {startDelay: 0.5});
					}
				});
			}
        button.onOut.callback = button.onUp.callback;

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
		shape.graphics.beginGradientFill(GradientType.RADIAL, [0xFFFFFF, FlxColor.TRANSPARENT], [1, 0], [0, 255], null, null, null, 0.5);
		shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
		shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);

		return FlxG.bitmap.add(bitmap);
    }

    override public function destroy()
    {
        super.destroy();
        buttonLeft = buttonDown = buttonUp = buttonRight = null;
		if (fadeTween != null) fadeTween.cancel();
		topFade = null;
		bottomFade = null;
    }
}        button.onUp.callback = function()
			{
				if (buttonTween != null)
					buttonTween.cancel();

				buttonTween = FlxTween.tween(button, {alpha: 0.1}, 0.65 / 10, {
					ease: FlxEase.circInOut,
					onComplete: (twn:FlxTween) -> buttonTween = null
				});
				
				// Show fades when button is released
				if (fadeTween != null) fadeTween.cancel();
				fadeTween = FlxTween.tween(topFade, {alpha: 0.5}, 0.2);
				fadeTween = FlxTween.tween(bottomFade, {alpha: 0.5}, 0.2, {
					onComplete: function(twn:FlxTween) {
						fadeTween = FlxTween.tween(topFade, {alpha: 0}, 0.5, {startDelay: 0.5});
						fadeTween = FlxTween.tween(bottomFade, {alpha: 0}, 0.5, {startDelay: 0.5});
					}
				});
			}
        button.onOut.callback = button.onUp.callback;

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
		shape.graphics.beginGradientFill(GradientType.RADIAL, [0xFFFFFF, FlxColor.TRANSPARENT], [1, 0], [0, 255], null, null, null, 0.5);
		shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
		shape.graphics.endFill();

        var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);

		return FlxG.bitmap.add(bitmap);
    }

    override public function destroy()
    {
        super.destroy();
        buttonLeft = buttonDown = buttonUp = buttonRight = null;
		if (fadeTween != null) fadeTween.cancel();
		topFade = null;
		bottomFade = null;
    }
}
