package funkin.options.categories;

class MobileOptions extends OptionsScreen {

	var extrabutton:NumOption;
	
	public override function new() {
		super("Mobile Options", "Change Mobile Options. Only on mobile...");
		add(new Checkbox(
			"Hitbox Visibility",
			"Makes the hitbox invisible",
			"hitboxvisibility"));
		add(new NumOption(
			"Extra Button",
			"Adds space button on hitbox",
			1,
			2,
			1,
			"extrabutton"));
    #if mobile
	 MusicBeatState.instance.addVPad(FULL, A_B);
	 MusicBeatState.instance.addVPadCamera();
	 #end
	}
}
