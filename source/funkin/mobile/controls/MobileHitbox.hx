package funkin.mobile.controls;

import flixel.FlxG;
import flixel.util.FlxDestroyUtil;
import flixel.tweens.FlxEase;
import openfl.display.BitmapData;
import openfl.display.Shape;
import funkin.mobile.flixel.FlxButton;
import funkin.mobile.flixel.input.FlxMobileInputManager;
import funkin.mobile.flixel.input.FlxMobileInputID;

/**
 * Hitbox... HIT
 * @author StarNova (Cream.BR)
 */
 
class MobileHitbox extends FlxMobileInputManager
{
	public var buttons:Array<FlxButton> = [];
	
	public var buttonLeft:FlxButton;
	public var buttonDown:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;

	private final alphaTarget:Float = 0.1;

	public function new():Void
	{
		super();

		var buttonWidth:Int = Std.int(FlxG.width / 4);
		var data = [
			{color: 0xFF00FF, ids: [FlxMobileInputID.hitboxLEFT, FlxMobileInputID.noteLEFT]},
			{color: 0x00FFFF, ids: [FlxMobileInputID.hitboxDOWN, FlxMobileInputID.noteDOWN]},
			{color: 0x00FF00, ids: [FlxMobileInputID.hitboxUP, FlxMobileInputID.noteUP]},
			{color: 0xFF0000, ids: [FlxMobileInputID.hitboxRIGHT, FlxMobileInputID.noteRIGHT]}
		];
		
		for (i in 0...data.length) {
			var btn = createHint(i * buttonWidth, 0, buttonWidth, FlxG.height, data[i].color, data[i].ids);
			add(btn);
			buttons.push(btn);
		}

		buttonLeft  = buttons[0];
		buttonDown  = buttons[1];
		buttonUp    = buttons[2];
		buttonRight = buttons[3];

		scrollFactor.set();
		updateTrackedButtons();
	}

	private function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:Int, IDs:Array<FlxMobileInputID>):FlxButton
	{
		var hint:FlxButton = new FlxButton(X, Y, IDs);
		hint.loadGraphic(createHintGraphic(Width, Height, Color));
		
		hint.solid = hint.moves = false;
		hint.immovable = true;
		hint.scrollFactor.set();
		hint.alpha = 0.00001;

		var hintTween:FlxTween = null;
		hint.onDown.callback = function() {
		    if (hintTween != null) hintTween.cancel();
		    
		    hintTween = FlxTween.tween(hint, {alpha: alphaTarget}, 0.075, {
		        ease: FlxEase.circInOut,
		        onComplete: function(_) { hintTween = null; }
		    });
		}
		
		hint.onUp.callback = function() {
		    if (hintTween != null) hintTween.cancel();
		    
		    hintTween = FlxTween.tween(hint, {alpha: 0.00001}, 0.15, {
		        ease: FlxEase.circInOut,
		        onComplete: function(_) { hintTween = null; }
		    });
		}
		
		hint.onOut.callback = hint.onUp.callback;

		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		
		return hint;
	}

	private function createHintGraphic(Width:Int, Height:Int, Color:Int):BitmapData
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill(Color);
		shape.graphics.drawRect(0, 0, Width, Height);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	override function destroy():Void
	{
		super.destroy();
		for (btn in buttons)
			FlxDestroyUtil.destroy(btn);
	}
}
