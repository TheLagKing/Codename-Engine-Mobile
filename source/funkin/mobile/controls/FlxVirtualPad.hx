package funkin.mobile.controls;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;

/**
 * A gamepad which contains 4 directional buttons and 4 action buttons.
 * It's easy to set the callbacks and to customize the layout.
 *
 * @author Ka Wing Chin
 */
 
 // Bó modificar um pouco sa' bagaça ~ Idklool
class FlxVirtualPad extends FlxSpriteGroup
{
  public var buttonA:FlxButton;
	public var buttonB:FlxButton;
	public var buttonC:FlxButton;
	public var buttonY:FlxButton;
	public var buttonX:FlxButton;
	public var buttonLeft:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;
	public var buttonDown:FlxButton;
	
	public function new(?DPad:FlxDPadMode, ?Action:FlxActionMode)
	{
	  super();

	  switch (DPad)
	  {
	    case UP_DOWN:
	      add(buttonUp = createButton(0, FlxG.height - 85 * 3, 44 * 3, 45 * 3, 'up'));
	      add(buttonDown = createButton(0, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'down'));
	    case LEFT_RIGHT:
	      add(buttonLeft = createButton(0, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'left'));
	      add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'right'));
			case UP_LEFT_RIGHT:
				add(buttonUp = createButton(35 * 3, FlxG.height - 81 * 3, 44 * 3, 45 * 3, 'up'));
				add(buttonLeft = createButton(0, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'left'));
				add(buttonRight = createButton(69 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'right'));
			case FULL:
				add(buttonUp = createButton(35 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, 'up'));
				add(buttonLeft = createButton(0, FlxG.height - 81 * 3, 44 * 3, 45 * 3, 'left'));
				add(buttonRight = createButton(69 * 3, FlxG.height - 81 * 3, 44 * 3, 45 * 3, 'right'));
				add(buttonDown = createButton(35 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'down'));
			case RIGHT_FULL:
				add(buttonUp = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 116 * 3, 44 * 3, 45 * 3, 'up'));
				add(buttonLeft = createButton(FlxG.width - 130 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 45 * 3, 'left'));
				add(buttonRight = createButton(FlxG.width - 44 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 45 * 3, 'right'));
				add(buttonDown = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 45 * 3, 44 * 3, 45 * 3, 'down'));
			case NONE: // do nothing
			default:
			  add(buttonUp = createButton(35 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, 'up'));
				add(buttonLeft = createButton(0, FlxG.height - 81 * 3, 44 * 3, 45 * 3, 'left'));
				add(buttonRight = createButton(69 * 3, FlxG.height - 81 * 3, 44 * 3, 45 * 3, 'right'));
				add(buttonDown = createButton(35 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'down'));
	  }

	  switch (Action)
		{
			case A:
				add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'a'));
			case B:
				add(buttonB = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'b'));
			case A_B:
				add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'a'));
				add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'b'));
			case A_B_C:
				add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'a'));
				add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'b'));
				add(buttonC = createButton(FlxG.width - 127 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'c'));
			case A_B_X_Y:
			  add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 45 * 3, 'y'));
				add(buttonX = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 45 * 3, 'x'));
				add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'b'));
				add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'a'));
			case A_B_C_X_Y:
			  add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 45 * 3, 'y'));
				add(buttonX = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 45 * 3, 'x'));
				add(buttonC = createButton(FlxG.width - 127 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'c'));
				add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'b'));
				add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'a'));
			case NONE: // do nothing
			case B_C:
			    add(buttonB = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'b'));
			    add(buttonC = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'c'));
			case B_X_Y:
				add(buttonB = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'b'));
				add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'y'));
				add(buttonX = createButton(FlxG.width - 127 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'x'));
			case B_C_X_Y:
			  add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 45 * 3, 'y'));
				add(buttonX = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 45 * 3, 'x'));
				add(buttonC = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'c'));
				add(buttonB = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'b'));
			default:
			  add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'a'));
				add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, 'b'));
		}

	  scrollFactor.set();
	}

	override function destroy()
	{
	  super.destroy();

	  buttonA = buttonB = buttonC = buttonX = buttonY = buttonLeft = buttonDown = buttonUp = buttonRight = null;
	}
	
	function createButton(x:Float, y:Float, width:Int, height:Int, graphic:String)
	{
	  var button:FlxButton = new FlxButton(x, y);

	  button.frames = FlxTileFrames.fromFrame(FlxAtlasFrames.fromSpriteSheetPacker('assets/mobile/virtual-input.png', 'assets/mobile/virtual-input.txt').getByName(graphic), FlxPoint.get(width, height));
	  button.resetSizeFromFrame();
	  button.solid = false;
		button.immovable = true;
	  button.scrollFactor.set();

	  return button;
	}
}

enum FlxDPadMode
{
	NONE;
	UP_DOWN;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	RIGHT_FULL;
	FULL;
}

enum FlxActionMode
{
	NONE;
	A;
	B;
	A_B;
	A_B_C;
	A_B_X_Y;
	A_B_C_X_Y;
	B_C;
	B_C_X_Y;
	B_X_Y;
}