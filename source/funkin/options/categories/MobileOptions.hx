package funkin.options.categories;

class MobileOptions extends OptionsScreen {
	public override function new() {
		super("Mobile Options", "Change Mobile Options. Only on mobile...");
		add(new Checkbox(
			"hitbox visibility",
			"Makes the hitbox invisible",
			"hitboxvisibility"));
		add(new Checkbox(
			"extra button",
			"Adds space button on hitbox",
			"extrabutton"));
    #if mobile
	 MusicBeatState.instance.addVPad(FULL, A_B);
	 MusicBeatState.instance.addVPadCamera();
	 #end
	}
}
