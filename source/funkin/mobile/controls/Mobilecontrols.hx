package funkin.mobile.controls;

import flixel.group.FlxSpriteGroup;

class Mobilecontrols extends FlxSpriteGroup
{
	public var mode:String = 'hitbox';

	public var hitbox:HitBox;
	public var vPad:FlxVirtualPad;

	var config:Config;

	public function new() 
	{
		super();

		config = new Config();

		// load control mode num from Config.hx
		mode = getModeFromNumber(config.getcontrolmode());
		trace(config.getcontrolmode());

		switch (mode.toLowerCase())
		{
			case 'vpad_right':
				initVirtualPad(0);
			case 'vpad_left':
				initVirtualPad(1);
			case 'vpad_custom':
				initVirtualPad(2);
			case 'hitbox':
				hitbox = new HitBox();
				add(hitbox);
			case 'keyboard':
		}
	}

	function initVirtualPad(vpadMode:Int) 
	{
		switch (vpadMode)
		{
			case 1:
				vPad = new FlxVirtualPad(FULL, NONE);
			case 2:
				vPad = new FlxVirtualPad(FULL, NONE);
				vPad = config.loadcustom(vPad);
			default: // 0
				vPad = new FlxVirtualPad(RIGHT_FULL, NONE);
		}

		vPad.alpha = 0.75;
		add(vPad);	
	}


	public static function getModeFromNumber(modeNum:Int):String {
		return switch (modeNum)
		{
			case 0: 'vpad_right';
			case 1: 'vpad_left';
			case 2: 'keyboard';
			case 3: 'vpad_custom';
			case 4:	'hitbox';
			default: 'vpad_right';
		}
	}
}