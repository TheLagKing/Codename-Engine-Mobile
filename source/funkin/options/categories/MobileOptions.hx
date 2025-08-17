package funkin.options.categories;

class MobileOptions extends OptionsScreen {

	var extrabutton:NumOption;
	
	public override function new() {
		super("Mobile Options", "Change Mobile Options. Only on mobile...");
		add(new Checkbox(
			"Hitbox Visibility",
			"Makes the hitbox invisible",
			"hitboxvisibility"));
		add(new Checkbox(
			"Classic Buttons",
			"Bring back the classic buttons",
			"classicbuttons"));
		add(new NumOption(
			"Extra Button",
			"Adds space button on hitbox",
			0,
			2,
			1,
			"extrabutton"));
		add(new Checkbox(
			"Extras Buttons Top",
			"Makes extra buttons stay at the top of the screen\n(off makes the extra buttons stay below the screen)",
			"extrabuttontop"));
    #if mobile
	 MusicBeatState.instance.addVPad(FULL, A_B);
	 MusicBeatState.instance.addVPadCamera();
	 #end
	}
}
