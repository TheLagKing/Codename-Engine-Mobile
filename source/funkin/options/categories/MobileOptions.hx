package funkin.options.categories;

class AppearanceOptions extends OptionsScreen {
	public override function new() {
		super("Mobile Options", "Change Mobile Options. Only on mobile...");
		add(new Checkbox(
			"hitbox visibility",
			"Makes the hitbox invisible",
			"hitboxvisibility"));
    #if mobile
	 MusicBeatState.instance.addVPad(FULL, A_B);
	 MusicBeatState.instance.addVPadCamera();
	 #end
	}
