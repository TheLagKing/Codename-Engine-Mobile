package funkin.options.categories;

class MobileOptions extends OptionsScreen {

	var extrabutton:NumOption;
	
	public override function new() {
		super("Mobile Options", "Change Mobile Options...");
		add(new Checkbox(
			"Hitbox Visibility",
			"Turning this off makes the hitbox invisible.\n Be careful with this.",
			"hitboxvisibility"));
		add(new Checkbox(
			"Classic Buttons",
			"Bring back the classic buttons.",
			"classicbuttons"));
		add(new NumOption(
			"Extra Button",
			"Adds extra buttons for hitbox.",
			0,
			2,
			1,
			"extrabutton"));
		add(new Checkbox(
			"Extras Buttons Top",
			"Makes extra buttons stay at the top of the screen.\n(when off, the extra buttons stay at the bottom of the screen)",
			"extrabuttontop"));
    #if mobile
	 MusicBeatState.instance.addVPad(FULL, A_B);
	 MusicBeatState.instance.addVPadCamera();
	 #end
	}
}
